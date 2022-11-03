#! /usr/bin/env python3

import argparse
import json
import os
from pathlib import Path

BACKUP_DIR = Path.home() / "dotfiles_old"


def move_to_backup(target: Path) -> None:
    print(f"Moving {target} ==> {BACKUP_DIR/target.name}")
    if not args.dry_run:
        target.rename(BACKUP_DIR / target.name)


def make_symlink(src: Path, dst: Path) -> None:
    print(f"linking {src} ==> {dst}")
    if not args.dry_run:
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.symlink_to(src)


def main(locations: dict[str, str], args):
    BACKUP_DIR.mkdir(exist_ok=True)

    location_paths: dict[Path, Path] = {
        Path(__file__).with_name(src): Path(dst.format(**os.environ))
        for src, dst in locations.items()
    }

    print("\nCreating backups of existing files...")
    for src, dst in location_paths.items():
        if dst.exists():
            move_to_backup(dst)

    print("\nInstalling files...")
    for src, dst in location_paths.items():
        make_symlink(src, dst)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="install.py",
        description="Installs dotfiles into the correct locations by symlink",
    )
    parser.add_argument("-d", "--dry-run", action="store_true")
    parser.add_argument(
        "locations_file",
        type=Path,
        nargs="?",
        default=Path(__file__).with_name("locations.json"),
        help="a json file describing which files to symlink, and where to place them.",
    )

    args = parser.parse_args()
    if args.dry_run:
        print("starting dry run. Not moving any files...")

    with args.locations_file.open() as f:
        locations = json.load(f)
    main(locations, args)
