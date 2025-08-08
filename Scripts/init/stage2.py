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
    case _:
        platform = OS
        path_delimiter = "/"

tools_dir = sys.argv[2]
cwd = os.getcwd()
nim_dir = cwd + path_delimiter + tools_dir + path_delimiter + OS + path_delimiter + "nim"

# Versions
nim_version = "2.2.4"
nimble_version = "0.20.1"

# Permanent
custom_tools_dir = nim_dir + path_delimiter + "custom"
if not pathlib.Path(custom_tools_dir).exists():
    pathlib.Path(custom_tools_dir).mkdir(parents=True, exist_ok=True)

nimble_command = custom_tools_dir + path_delimiter + "nimble" + exe
nim_command = custom_tools_dir + path_delimiter + "nim" + exe

# Temporary
nimble_zip = nimble_version + ".zip"
nimble_url = "https://github.com/nim-lang/nimble/archive/refs/tags/v" + nimble_zip
nimble_zip = nim_dir + path_delimiter + nimble_zip
nimble_src_dir = nim_dir + path_delimiter + "nimble-" + nimble_version
nimble_dir = nim_dir + path_delimiter + nim_version
nim_bin_dir = nimble_dir + path_delimiter + "bin"
nim_version_dir = nim_dir + path_delimiter + nim_version
nim_bin = nim_bin_dir + path_delimiter + "nim" + exe
nimble_new_command = nim_bin_dir + path_delimiter + "nimble" + exe
nimble_final_command = nimble_src_dir + path_delimiter + "nimble" + exe
nimble_custom_command = custom_tools_dir + path_delimiter + "nimble" + exe
choosenim_command = nim_dir + path_delimiter + "choosenim" + exe

# Download and build latest version of nimble
def download_nimble(nimble_url, nimble_zip):
    print("Downloading Nimble")
    query_parameters = {"downloadFormat": "zip"}
    response = requests.get(nimble_url, params=query_parameters)
    if response.ok and response.status_code == 200:
        with open(nimble_zip, mode="wb") as file:
            file.write(response.content)

def prepare_nimble(nimble_zip, nim_dir):
    print("Preparing Nimble")
    with ZipFile(nimble_zip, "r") as archive:
        archive.extractall(path=nim_dir)
    pathlib.Path(nimble_zip).unlink()

def build_nimble(nimble_new_command, nim_bin, nimble_src_dir):
    print("Building Nimble")
    tmp = os.getcwd()
    os.chdir(nimble_src_dir)
    subprocess.call([nimble_new_command, 'add', 'checksums'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    subprocess.call([nimble_new_command, 'add', 'sat'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    subprocess.call([nimble_new_command, 'add', 'zippy'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    subprocess.call([nimble_new_command, 'build', f'--nim:{nim_bin}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    os.chdir(tmp)

def install_nim(nim_bin, nim_command):
    print("Installing Nim")
    pathlib.Path(nim_bin).replace(nim_command)

def install_nimble(nimble_final_command, nimble_custom_command):
    print("Installing Nimble")
    pathlib.Path(nimble_final_command).replace(nimble_custom_command)

def cleanup_nim(nimble_src_dir, nim_version_dir, choosenim_command):
    print("Cleaning Up")
    pathlib.Path(nimble_src_dir).rmtree()
    pathlib.Path(nim_version_dir).rmtree()
    pathlib.Path(choosenim_command).unlink()

if not pathlib.Path(nimble_command).exists():
    download_nimble(nimble_url, nimble_zip)
    prepare_nimble(nimble_zip, nim_dir)
    build_nimble(nimble_new_command, nim_bin, nimble_src_dir)
    install_nim(nim_bin, nim_command)
    install_nimble(nimble_final_command, nimble_custom_command)
    cleanup_nim(nimble_src_dir, nim_version_dir, choosenim_command)
