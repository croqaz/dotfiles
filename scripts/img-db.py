#
# photo-DB utils
#
import os
import sys
import shutil
from glob import glob
from PIL import Image
from PIL.ExifTags import TAGS
from datetime import datetime
from numpy import base_repr

RTAGS = {v: k for k, v in TAGS.items()}


def get_img_date(img):
    exif = img._getexif()
    if not exif:
        return
    # (36867, 37521) # (DateTimeOriginal, SubsecTimeOriginal)
    # (36868, 37522) # (DateTimeDigitized, SubsecTimeDigitized)
    # (306, 37520)   # (DateTime, SubsecTime)
    tags = [
        RTAGS['DateTimeOriginal'],  # when img was taken
        RTAGS['DateTimeDigitized'], # when img was stored digitally
        RTAGS['DateTime'],  # when img file was changed
    ]
    for tag in tags:
        if exif.get(tag):
            return datetime.strptime(exif[tag], '%Y:%m:%d %H:%M:%S')


def get_make_model(img):
    exif = img._getexif()
    if not exif:
        return
    make = exif.get(RTAGS['Make'], '').title()
    model = exif.get(RTAGS['Model'], '').replace(' ', '-')
    return f'{make}-{model}'


def hamming_distance(s1: str, s2: str):
    """ The Hamming distance between equal-length strings """
    if len(s1) != len(s2):
        return float('inf')
    return sum(c1 != c2 for c1, c2 in zip(s1, s2))


def format_rc_b32(row_hash, col_hash, sz=12):
    hash_int = row_hash << (sz * sz) | col_hash
    base_32 = base_repr(hash_int, 32).lower().zfill(26)
    return base_32[::-1]


def get_img_grays(image, width, height):
    """
    Convert image to grayscale, downsize to width*height, and return list
    of grayscale integer pixel values (for example, 0 to 255).
    """
    gray_image = image.convert('L')
    small_image = gray_image.resize((width, height), Image.ANTIALIAS)
    return list(small_image.getdata())


def dhash_img_row_col(image, size=12):
    """
    Calculate row and column difference hash for given image and return
    hashes as (row_hash, col_hash) where each value is a size*size bit integer.
    """
    width = size + 1
    grays = get_img_grays(image, width, width)

    row_hash = 0
    col_hash = 0
    for y in range(size):
        for x in range(size):
            offset = y * width + x
            row_bit = grays[offset] < grays[offset + 1]
            row_hash = row_hash << 1 | row_bit

            col_bit = grays[offset] < grays[offset + width]
            col_hash = col_hash << 1 | col_bit

    return (row_hash, col_hash)


def show_exif(img):
    for k, v in img._getexif().items():
        print(TAGS.get(k, k), ':', v)


def rename_image(pth, base=None):
    old_dir, old_name = os.path.split(pth)
    old_name, e = os.path.splitext(old_name)
    e = e.lower()
    if e not in ('.jpg', '.jpeg', '.png'):
        return
    img = Image.open(pth)
    print('IMG:', pth)
    print('DATE:', get_img_date(img))
    print('MODEL:', get_make_model(img))

    row, col = dhash_img_row_col(img)
    name = format_rc_b32(row, col)
    if name == old_name:
        return
    if not base:
        base = old_dir
    print(f'{pth}\t->  {base}/{name}{e}')
    return shutil.move(pth, f'{base}/{name}{e}')


def rename_all_images(pth):
    for p in glob(pth + '/*.*', recursive=True):
        try:
            rename_image(p)
        except Exception as err:
            print('ERROR renaming', err)


if __name__ == '__main__':
    rename_all_images(sys.argv[1])
