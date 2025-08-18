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
nim_dir = os.getcwd() + path_delimiter + tools_dir + path_delimiter + OS + path_delimiter + "nim"
deps_dir = os.getcwd() + path_delimiter + sys.argv[3]

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
nimble_cache = deps_dir + path_delimiter + nimble_zip
nimble_url = "https://github.com/nim-lang/nimble/archive/refs/tags/v" + nimble_zip
nimble_zip = nim_dir + path_delimiter + nimble_zip
nimble_src_dir = nim_dir + path_delimiter + "nimble-" + nimble_version
nimble_dir = nim_dir + path_delimiter + nim_version
nimble_deps_dir = deps_dir + path_delimiter + "nimbledeps"
nimble_pkgs_dir = nimble_deps_dir + path_delimiter + "pkgs2"
nim_bin_dir = nimble_dir + path_delimiter + "bin"
nim_version_dir = nim_dir + path_delimiter + nim_version
nim_bin = nim_bin_dir + path_delimiter + "nim" + exe
nimble_new_command = nim_bin_dir + path_delimiter + "nimble" + exe
nimble_final_command = nimble_src_dir + path_delimiter + "src" + path_delimiter + "nimble" + exe
nimble_custom_command = custom_tools_dir + path_delimiter + "nimble" + exe

# Download and build latest version of nimble
def download_nimble(nimble_url, nimble_zip):
    global nimble_cache
    if not pathlib.Path(nimble_cache).exists():
        print("Downloading Nimble")
        kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage2"
        query_parameters = {"downloadFormat": "zip"}
        response = requests.get(nimble_url, params=query_parameters)
        if response.ok and response.status_code == 200:
            with open(nimble_zip, mode="wb") as file:
                file.write(response.content)
        else:
            print("Nimble files failed to download; please check your internet connection and try again later")
            with open(kill_file, mode="w") as file:
                file.write("")

def prepare_nimble(nimble_zip, nim_dir):
    global nimble_cache
    print("Preparing Nimble")
    if not pathlib.Path(nimble_cache).exists():
        with ZipFile(nimble_zip, "r") as archive:
            archive.extractall(path=nim_dir)
        pathlib.Path(nimble_zip).replace(nimble_cache)
    else:
        with ZipFile(nimble_cache, "r") as archive:
            archive.extractall(path=nim_dir)

def build_nimble(nimble_new_command, nim_bin, nimble_src_dir):
    global nimble_deps_dir
    tmp = os.getcwd()
    cmd = ""
    os.chdir(nimble_src_dir)
    subprocess.call([nimble_new_command, 'add', f'--nimbleDir:{nimble_deps_dir}', f'--nim:{nim_bin}', 'checksums'])
    subprocess.call([nimble_new_command, 'add', f'--nimbleDir:{nimble_deps_dir}', f'--nim:{nim_bin}', 'sat'])
    subprocess.call([nimble_new_command, 'add', f'--nimbleDir:{nimble_deps_dir}', f'--nim:{nim_bin}', 'zippy'])
    subprocess.call([nimble_new_command, 'install', f'--nimbleDir:{nimble_deps_dir}', f'--nim:{nim_bin}', 'zigcc'])
    if OS == "win":
        cmd = ".cmd"
    print("Building Nimble. Please wait")
    zigcc = nimble_deps_dir + path_delimiter + "bin" + path_delimiter + "zigcc" + cmd
    subprocess.call([nim_bin, 'c', '--cc:clang', f'--clang.exe={zigcc}', f'--clang.linkerexe={zigcc}', '--opt:speed', f'--nimblePath:{nimble_pkgs_dir}', '-d:release', 'src/nimble.nim'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    os.chdir(tmp)

def install_nim(nim_bin, nim_command):
    print("Installing Nim")
    pathlib.Path(nim_bin).replace(nim_command)

def install_nimble(nimble_final_command, nimble_custom_command):
    print("Installing Nimble")
    pathlib.Path(nimble_final_command).replace(nimble_custom_command)

def cleanup_nim(nimble_src_dir, nim_version_dir):
    print("Cleaning Up")
    pathlib.Path(nimble_src_dir).rmtree()
    pathlib.Path(nim_version_dir).rmtree()

if not pathlib.Path(nimble_command).exists():
    download_nimble(nimble_url, nimble_zip)
    prepare_nimble(nimble_zip, nim_dir)
    build_nimble(nimble_new_command, nim_bin, nimble_src_dir)
    install_nim(nim_bin, nim_command)
    install_nimble(nimble_final_command, nimble_custom_command)
    cleanup_nim(nimble_src_dir, nim_version_dir)
