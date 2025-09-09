# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

# Core sys libraries
import sys

import os

# downloader library
import requests

# portable python I'm using doesn't include pathlib, so using a backported version instead
import pathlib3x as pathlib

# for extracting zip file
from zipfile import ZipFile

# Version of tools used
# llvm_version = "20250709"
llvm_version = "20240619"
zig_version = "0.14.1"

# Platform specific variables
exe = ""
query_parameters = ""
platform = ""
arch = ""
llvm_platform = ""
OS = sys.argv[1]
match OS:
    case "win":
        platform = "windows"
        arch = "x86_64"
        exe = ".exe"
        path_delimiter = "\\"
        rar = ".zip"
    case _:
        platform = OS
        if OS == "macos":
            llvm_platform = platform + "-"
            arch = "universal"
            march = arch
        path_delimiter = "/"
        rar = ".tar.xz"

tools_dir = os.getcwd() + path_delimiter + sys.argv[2]
deps_dir = sys.argv[3]

# Go ahead and download a standalone version of the LLVM toolchain based on MingW for Windows and Mac; Linux users can still download through their package manager
# Required for nim c interop stuff
llvm_slug = "llvm-mingw-" + llvm_version + "-ucrt-" + llvm_platform + arch
llvm_zip = llvm_slug + rar
llvm_cache = deps_dir + path_delimiter + llvm_zip
llvm_url = (
    "https://github.com/mstorsjo/llvm-mingw/releases/download/"
    + llvm_version
    + "/"
    + llvm_zip
)
llvm_zip = tools_dir + path_delimiter + llvm_zip
llvm_slug = tools_dir + path_delimiter + llvm_slug
llvm_dir = tools_dir + path_delimiter + "llvm"


def download_llvm(llvm_url, llvm_zip):
    print("Downloading LLVM Toolchain")
    kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage10"
    if OS == "win":
        query_parameters = {"downloadFormat": "zip"}
    else:
        query_parameters = {"downloadFormat": "xz"}
    response = requests.get(llvm_url, params=query_parameters)
    if response.ok and response.status_code == 200:
        with open(llvm_zip, mode="wb") as file:
            file.write(response.content)
    else:
        print(
            "llvm files failed to download; please check your internet connection and try again later"
        )
        with open(kill_file, mode="w") as file:
            file.write("")


def prepare_llvm(llvm_zip, llvm_dir):
    global llvm_cache
    print("Preparing LLVM")
    if not pathlib.Path(llvm_cache).exists():
        with ZipFile(llvm_zip, "r") as archive:
            archive.extractall(path=tools_dir)
        pathlib.Path(llvm_zip).replace(llvm_cache)
    else:
        with ZipFile(llvm_cache, "r") as archive:
            archive.extractall(path=tools_dir)


def install_llvm(llvm_dir):
    global llvm_slug
    print("Installing LLVM")
    pathlib.Path(llvm_slug).replace(llvm_dir)


if not pathlib.Path(llvm_dir).exists():
    if not pathlib.Path(llvm_cache).exists():
        download_llvm(llvm_url, llvm_zip)
    prepare_llvm(llvm_zip, llvm_dir)
    install_llvm(llvm_dir)

zig_slug = "zig-x86_64-" + platform + "-" + zig_version
zig_zip = zig_slug + rar
zig_cache = deps_dir + path_delimiter + zig_zip
zig_url = "https://ziglang.org/download/" + zig_version + "/" + zig_zip
zig_zip = tools_dir + path_delimiter + zig_zip
zig_slug = tools_dir + path_delimiter + zig_slug
zig_dir = tools_dir + path_delimiter + "zig"


def download_zig(zig_url):
    global zig_cache
    if not pathlib.Path(zig_cache).exists():
        print("Downloading Zig Compiler")
        global cwd
        kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage10"
        if OS == "win":
            query_parameters = {"downloadFormat": "zip"}
        else:
            query_parameters = {"downloadFormat": "xz"}
        response = requests.get(zig_url, params=query_parameters)
        if response.ok and response.status_code == 200:
            with open(zig_zip, mode="wb") as file:
                file.write(response.content)
        else:
            print(
                "Zig files failed to download; please check your internet connection and try again later"
            )
            with open(kill_file, mode="w") as file:
                file.write("")


def prepare_zig(zig_zip, tools_dir):
    global zig_cache
    print("Preparing Zig")
    if not pathlib.Path(zig_cache).exists():
        with ZipFile(zig_zip, "r") as archive:
            archive.extractall(path=tools_dir)
        pathlib.Path(zig_zip).replace(zig_cache)
    else:
        with ZipFile(zig_cache, "r") as archive:
            archive.extractall(path=tools_dir)


def install_zig(zig_dir):
    global zig_slug
    print("Installing Zig")
    pathlib.Path(zig_slug).replace(zig_dir)


if not pathlib.Path(zig_dir).exists():
    if not pathlib.Path(zig_cache).exists():
        download_zig(zig_url)
    prepare_zig(zig_zip, tools_dir)
    install_zig(zig_dir)