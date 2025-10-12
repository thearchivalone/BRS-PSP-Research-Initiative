# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## helpers.py - Generic functions that can be used in multiple parts of the build system are stored here
import sys
import subprocess
import requests
from globals import path_delimiter, tools_dir
from pathlib import Path
from zipfile import ZipFile

def download_source_git_b(url, source, cache, branch):    
    if not Path(cache).exists():
        print(f"Downloading {source} sources")
        subprocess.call(
            [
                "git",
                "clone",
                "--recursive",
                "--depth=1",
                f"--branch={branch}",
                url,
                cache
            ]
        )

def download_source_git(url, source, cache):
    if not Path(cache).exists():
        print(f"Downloading {source} sources")
        subprocess.call(
            [
                "git",
                "clone",
                "--recursive",
                "--depth=1",
                url,
                cache
            ]
        )


def download_source_release(url, cache, source):
    if not Path(cache).exists():
        print(f"Downloading {source} sources")
        query_parameters = {"downloadFormat": f"{Path(cache).suffix}"}
        response = requests.get(url, params=query_parameters)
        if response.ok and response.status_code == 200:
            with open(cache, mode="wb") as file:
                file.write(response.content)
        else:
            print(
                f"{source} files failed to download; please check your internet connection and try again later"
            )
            sys.exit()

def prepare_source_release(cache, slug, extract_dir, install_dir, source):
    if not Path(slug).exists() and not Path(install_dir).exists():
        print(f"Preparing {source}")
        if not Path(cache).exists():
            with ZipFile(cache, "r") as archive:
                    archive.extractall(path=extract_dir)
        else:
            with ZipFile(cache, "r") as archive:
                archive.extractall(path=extract_dir)

def install_source(slug, install_dir, source):
    if not Path(install_dir).exists():
        print(f"Installing {source}")
        Path(slug).copy(install_dir)

def cleanup_slug(slug, source):
    if Path(slug).exists():
        print(f"Cleaning up old {source} files")
        # From official pathlib docs
        for root, dirs, files in Path(slug).walk(top_down=False):
            for name in files:
                (root / name).unlink()
            for name in dirs:
                (root / name).rmdir()
        Path(slug).rmdir()