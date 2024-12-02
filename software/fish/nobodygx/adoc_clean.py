#!/bin/python3

import os
import sys

def main(ifile:str):
    with open(ifile, mode='r', encoding='utf-8') as f:
        fulltext = f.read()
    content = []
    bname = os.path.basename(ifile)
    bname = bname[:bname.rfind('.')]
    content.append(f'# {bname}\n')
    for line in fulltext.split("\n"):
        if not line.startswith("#"):
            content.append(line)
            continue
        if not line.endswith("]"):
            content.append(line)
            continue
        line = "#" + line
        line = line[:line.rfind('[')]
        content.append(line.strip())

    with open(ifile, mode='w', encoding='utf-8') as f:
        f.write("\n".join(content))


if __name__ == "__main__":
    if len(sys.argv) <= 1:
        print("please enter file, exit")
        exit()
    ifile = sys.argv[1]
    if not ifile.endswith(".md"):
        print('please enter markdown file, exit')
        exit()
    main(ifile)
