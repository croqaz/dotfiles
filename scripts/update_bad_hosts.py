import sys
import requests


def update_adaway():
    URL = 'https://adaway.org/hosts.txt'
    r = requests.get(URL)
    print(r, URL)
    hosts = set()
    for line in r.text.split('\n'):
        line = line.strip()
        if not line:
            continue
        if line.startswith('127.0.0.1 '):
            hosts.add(line[9:].strip())
    print(f'Found hosts: {len(hosts)}')
    return 'ADAWAY', hosts


def upd_disconnect():
    URL = 'https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt'
    r = requests.get(URL)
    print(r, URL)
    hosts = set()
    for line in r.text.split('\n')[3:]:
        line = line.strip()
        if not line:
            continue
        hosts.add(line.strip())
    print(f'Found hosts: {len(hosts)}')
    return 'DISCONNECT', hosts


def upd_admiral():
    # in advertising lists
    URL = 'https://v.firebog.net/hosts/Admiral.txt'
    r = requests.get(URL)
    print(r, URL)
    hosts = set()
    for line in r.text.split('\n'):
        line = line.strip()
        if not line:
            continue
        hosts.add(line.strip().split(" ")[0])
    print(f'Found hosts: {len(hosts)}')
    return 'ADMIRAL', hosts


def upd_w3kbl():
    # in suspicious lists
    URL = 'https://v.firebog.net/hosts/static/w3kbl.txt'
    r = requests.get(URL)
    print(r, URL)
    hosts = set()
    for line in r.text.split('\n')[6:]:
        line = line.strip()
        if not line:
            continue
        hosts.add(line.strip().split(" ")[0])
    print(f'Found hosts: {len(hosts)}')
    return 'W3KBL', hosts


def save_result(*funcs):
    OUTPUT = sys.argv[1] if len(sys.argv) > 1 else 'blacklist.conf'
    all_hosts = set()
    with open(OUTPUT, 'w') as fd:
        for func in funcs:
            name, hosts = func()
            fd.write(f'# ({name})\n')
            for x in sorted(hosts - all_hosts):
                if len(x) < 5: continue
                fd.write(f'address=/{x}/#\n')
                # fd.write(f'0.0.0.0 {x}\n')
            fd.write('\n')
            all_hosts.update(hosts)
    print(f'Written hosts: {len(all_hosts)} in {OUTPUT}')


if __name__ == '__main__':
    save_result(
        update_adaway,
        upd_disconnect,
        upd_admiral,
        upd_w3kbl,
    )
