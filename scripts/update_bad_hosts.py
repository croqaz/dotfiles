import sys
import requests


def upd_easylist():
    URL = 'https://v.firebog.net/hosts/Easylist.txt'
    r = requests.get(URL)
    print(r, URL)
    hosts = set()
    for line in r.text.split('\n')[3:]:
        line = line.strip()
        if not line or line[0] == '#':
            continue
        hosts.add(line.strip())
    print(f'Found hosts: {len(hosts)}')
    return 'EASYLIST', hosts


def upd_adaway():
    URL = 'https://adaway.org/hosts.txt'
    r = requests.get(URL)
    print(r, URL)
    hosts = set()
    for line in r.text.split('\n'):
        line = line.strip()
        if not line or line[0] == '#':
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
        if not line or line[0] == '#':
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
        if not line or line[0] == '#':
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
        if not line or line[0] == '#':
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
    print(f'Written {len(all_hosts)} hosts in {OUTPUT}')


if __name__ == '__main__':
    save_result(
        upd_adaway,
        upd_easylist,
        upd_disconnect,
        upd_admiral,
        upd_w3kbl,
    )
