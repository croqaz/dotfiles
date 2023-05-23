pdfextract() {
  # PDF extract uses 3 arguments:
  #   $1 is the first page of the range to extract
  #   $2 is the last page of the range to extract
  #   $3 is the input file
  #   output file will be named "inputfile_pXX-pYY.pdf"
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
     -dFirstPage=${1} \
     -dLastPage=${2} \
     -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
     ${3}
}

# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias pdfmerge='gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=_merged.pdf'

# Compress PDF files with /ebook option
# https://www.ghostscript.com/doc/current/VectorDevices.htm
alias pdfcompress='gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dColorImageResolution=72 -dMonoImageResolution=72 -dGrayImageResolution=72 -dEmbedAllFonts=true -dSubsetFonts=true -dNOPAUSE -dBATCH -dSAFER -sOutputFile=_compressed.pdf'
