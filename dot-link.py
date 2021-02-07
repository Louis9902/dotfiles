#!/usr/bin/python
import argparse
import os
import sys

verbose = False
dry_run = False
skip_backup = False


# Problems:
#  - when directory as target is a link then the logic gets funky.


def naming_path(path):
    """
    Changes all occurrences of the 'dot-' prefix of an path segment to an actual '.'.
    This might behave strange with full paths because of the leading path separator.
    """
    path = path.split(os.path.sep)
    return os.path.join(
        *[node if not node.startswith("dot-") else ".%s" % node[4:] for node in path]
    )


def paths_for_file_mirror(src_path, dst_path):
    """
    Yields paths which follow the directory structure of the source directory but are
    relative to the destination directory. If a path contains the 'dot-' prefix in
    the source then it will be replaced with an '.' in the destination.
    """
    for path, folders, files in os.walk(src_path):
        root = os.path.relpath(path, src_path).strip("./")
        for file in files:
            path = file if not root else os.path.join(root, file)
            src = os.path.join(src_path, path)
            dst = os.path.join(dst_path, naming_path(path))
            yield src, dst


def paths_for_install(src_path, dst_path):
    """
    Yields paths which need a symlink at destination to the source file in order to
    resemble the source directory structure at the destination.
    """
    for src, dst in paths_for_file_mirror(src_path, dst_path):
        if os.path.islink(dst):
            # Should double check if is symlink to source
            continue
        yield src, dst


def path_for_backup(src_path, src_root, bkp_path):
    """
    Returns a potential backup path, the path is relative to the backup destination,
    but follows the same file structure as the source path to the source root path.
    """
    dst_path = os.path.relpath(src_path, src_root).strip("/")
    dst_path = os.path.join(bkp_path, dst_path)
    path = dst_path
    count = 0
    while os.path.exists(path) and count < 10:
        path = "%s.%i" % (path, count)
        if verbose:
            print("Backup %s exists, incrementing" % path)
        count += 1
    return path


def install(src_path, dst_path, bkp_path, packages):
    """"""
    for package in packages:
        pkg_path = os.path.join(src_path, package)
        if verbose or dry_run:
            print("Package %s:" % package)
        for src, dst in paths_for_install(pkg_path, dst_path):
            # Backups
            if not skip_backup and os.path.exists(dst):
                bkp = path_for_backup(dst, dst_path, bkp_path)
                if verbose or dry_run:
                    print(" Backing up %s -> %s" % (dst, bkp))
                if not dry_run:
                    os.makedirs(os.path.dirname(bkp), exist_ok=True)
                    os.rename(dst, bkp)
            # Linking
            if verbose or dry_run:
                print(" Linking at %s -> %s" % (src, dst))
            if not dry_run:
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                os.symlink(src, dst)


def setup_parser():
    parser = argparse.ArgumentParser()
    parser.description = "A program for managing the installation of dot file packages"

    xdg_data_home = os.environ.get(
        "XDG_DATA_HOME", os.path.join(os.path.expandvars("$HOME"), ".local", "share")
    )

    src_d = os.environ.get("DOT_LINK_SOURCE", os.getcwd())
    dst_d = os.environ.get("DOT_LINK_DESTINATION", os.path.dirname(os.getcwd()))
    bkp_d = os.environ.get(
        "DOT_LINK_BACKUP", os.path.join(xdg_data_home, "dot-link", "backup")
    )

    # fmt: off
    parser.add_argument('-s', '--source',
                        help='set dotfiles source folder',
                        default=src_d, metavar='path')
    parser.add_argument('-d', '--destination',
                        help='set dotfiles destination folder',
                        default=dst_d, metavar='path')
    parser.add_argument('-b', '--backup',
                        help='set dotfiles backup folder',
                        default=bkp_d, metavar='path')

    parser.add_argument('-n', '--dry-run',
                        help='do not link files, just print a list of file actions',
                        action='store_true')
    parser.add_argument('-v', '--verbose',
                        help='increase the output verbosity of the process',
                        action='store_true')
    parser.add_argument('-B', '--skip-backup',
                        help='skip creating a backup of the dotfiles',
                        action='store_true')

    parser.add_argument('packages', nargs='*',
                        help='one or more packages')
    # fmt: on

    return parser


def main():
    parser = setup_parser()
    args = parser.parse_args()

    if not args.packages:
        parser.print_usage()
        sys.exit(1)

    # Set global argument options
    global verbose
    verbose = args.verbose
    global dry_run
    dry_run = args.dry_run
    global skip_backup
    skip_backup = args.skip_backup

    # Expand all relevant user directories
    args.source = os.path.expanduser(args.source)
    args.destination = os.path.expanduser(args.destination)
    args.backup = os.path.expanduser(args.backup)

    install(args.source, args.destination, args.backup, args.packages)


if __name__ == "__main__":
    main()
