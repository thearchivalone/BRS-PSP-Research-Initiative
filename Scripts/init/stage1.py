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

# for running programs
import subprocess

# for extracting zip file
from zipfile import ZipFile

# Version of tools used
choosenim_version = "0.8.16"
nim_version = "2.2.4"

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
        rar = ".tar.gz"

tools_dir = os.getcwd() + path_delimiter + sys.argv[2]
deps_dir = sys.argv[3]

# Tools urls
choosenim_dir = tools_dir + path_delimiter + "nim"

# temporary
choosenim_exe = "choosenim-" + choosenim_version + "_" + platform + "_amd64" + exe
choosenim_cache = deps_dir + path_delimiter + choosenim_exe
choosenim_url = (
    "https://github.com/nim-lang/choosenim/releases/download/v"
    + choosenim_version
    + "/"
    + choosenim_exe
)
choosenim_command = choosenim_dir + path_delimiter + choosenim_exe


def download_choosenim(choosenim_url):
    if not pathlib.Path(choosenim_cache).exists():
        print("Downloading Nim Bootstrapper")
        global cwd
        kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage1"
        if OS == "win":
            query_parameters = {"downloadFormat": "exe"}
        else:
            query_parameters = {"downloadFormat": "bin"}
        response = requests.get(choosenim_url, params=query_parameters)
        if response.ok and response.status_code == 200:
            with open(choosenim_command, mode="wb") as file:
                file.write(response.content)
        else:
            print(
                "Nim files failed to download; please check your internet connection and try again later"
            )
            with open(kill_file, mode="w") as file:
                file.write("")


# Create Nim directory if doesn't exist
choosenim_dir = pathlib.Path(choosenim_dir).__str__()
if not pathlib.Path(choosenim_dir).exists():
    pathlib.Path(choosenim_dir).mkdir(parents=True, exist_ok=True)
    download_choosenim(choosenim_url)

# For convenience and sanity
choosenim_dir = pathlib.Path(choosenim_dir).__str__()
if pathlib.Path(choosenim_command).exists():
    pathlib.Path(choosenim_command).replace(choosenim_cache)

choosenim_command = choosenim_cache


# Download nim versions
def download_nim(nim_version):
    print("Downloading Nim " + nim_version)
    nim_dir = choosenim_dir + path_delimiter + nim_version
    subprocess.call(
        [choosenim_command, f"--nimbleDir:{nim_dir}", nim_version],
        stderr=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
    )


custom_tools_dir = choosenim_dir + path_delimiter + "custom"
nim_dir = choosenim_dir + path_delimiter + nim_version
if not pathlib.Path(nim_dir).exists() and not pathlib.Path(custom_tools_dir).exists():
    pathlib.Path(nim_dir).mkdir(parents=True, exist_ok=True)
    download_nim(nim_version)
