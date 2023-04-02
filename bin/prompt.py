#! /usr/bin/env python3

import subprocess
import sys

reset = "\033[0m"
colors = [f"\033[38;5;{i}m" for i in range(256)]
ncolors = {
    "black": "\033[0;30m",
    "red": "\033[0;31m",
    "green": "\033[0;32m",
    "yellow": "\033[0;33m",
    "blue": "\033[0;34m",
    "magenta": "\033[0;35m",
    "cyan": "\033[0;36m",
    "white": "\033[0;37m",
}


def colored(color, text):
    return f"\001{color}\002{text}\001{reset}\002"


def git_isdirty():
    cmd = ["git", "diff", "--no-ext-diff", "--quiet"]
    kwargs = {"stdout": subprocess.DEVNULL, "stderr": subprocess.DEVNULL}
    normal = subprocess.run(cmd, **kwargs).returncode
    cached = subprocess.run(cmd + ["--cached"], **kwargs).returncode
    return not (normal == 0 and cached == 0)


def git_showbranch():
    branches = subprocess.run(
        ["git", "branch", "--no-color"], capture_output=True, text=True
    )
    if branches.returncode != 0:
        return ""
    else:
        try:
            branch = next(b for b in branches.stdout.split('\n') if b.startswith('*'))
        except StopIteration:
            return ""
        return branch[2:].strip()


def term_prompt(return_code, userhost, folder):
    dollar = colored(ncolors["red" if int(return_code) else "white"], "$")
    name = colored(colors[1], userhost)

    branch = git_showbranch()
    if branch:
        color = ncolors["yellow" if git_isdirty() else "blue"]
        git = colored(color, f" ({branch})")
    else:
        git = ""
    return rf"[{name} {folder}{git}]{dollar} "


if __name__ == "__main__":
    print(term_prompt(*sys.argv[1:]))
