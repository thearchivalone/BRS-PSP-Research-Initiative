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
zig_version = "0.14.1"

# Platform specific variables
exe = ""
query_parameters = ""
platform = ""
OS = sys.argv[1]
match OS:
    case "win":
        platform = "windows"
        exe = ".exe"
        path_delimiter = "\\"
        rar = ".zip"
    case _:
        platform = OS
        path_delimiter = "/"
        rar = ".tar.xz"

tools_dir = os.getcwd() + path_delimiter + sys.argv[2]
deps_dir = sys.argv[3]

# temporary
tools_dir = tools_dir + path_delimiter + OS
zig_slug = "zig-x86_64-" + platform + "-" + zig_version
zig_zip =  zig_slug + rar
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
            print("Zig files failed to download; please check your internet connection and try again later")
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
