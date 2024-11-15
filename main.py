#!/usr/bin/python

# 仅使用系统内置 python，禁止任何第三方库等

import subprocess
from typing import List

def run_cmd(cmd) -> str:
    p = subprocess.run(cmd, shell=True, text=True, capture_output=True)
    return p.stdout

class Package(object):
    def __init__(self, name:str, pkg_name:str="") -> None:
        self.name = name
        self.pkg_name = pkg_name if pkg_name != "" else name

    def __repr__(self) -> str:
        return f"Package[{self.name}]"

    def install(self) -> bool:
        """安装指定包"""
        if self.check_installed():
           return True
        try:
           ret = run_cmd(f"yay -S {self.name}")
        except Exception as e:
            print(e)
        return False

    def check_installed(self) -> bool:
        """检测包是否已安装"""
        try:
            ret = run_cmd(f"pacman -Q {self.name}")
        except Exception as e:
            return False
        return True


class PackageGroup(object):
    def __init__(self, name:str) -> None:
        self.name = name
        self.members = []  # type: List[Package]

    def add_package(self, package:Package):
        self.members.append(package)

    def add(self, name:str, pkg_name:str):
        package = Package(name, pkg_name)
        self.members.append(package)

    def install(self):
        for i, pkg in enumerate(self.members):
            print(f"{i}: start install {pkg.name}")
            pkg.install()

def main():
    p = Package("zsh")
    print(p.check_installed())

if __name__ == "__main__":
    main()
