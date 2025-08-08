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
quickbms_version = "0.12.0"
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

tools_dir = sys.argv[2]

# Tools urls
choosenim_dir = os.getcwd() + path_delimiter + tools_dir + path_delimiter + "nim"

# temporary
choosenim_exe = "choosenim-" + choosenim_version + "_" + platform + "_amd64" + exe
choosenim_url = "https://github.com/nim-lang/choosenim/releases/download/v" + choosenim_version + "/" + choosenim_exe
choosenim_command = choosenim_dir + path_delimiter + choosenim_exe

def download_choosenim(choosenim_url, choosenim_version):
    print("Downloading Nim Bootstrapper")
    if OS == "win":
        query_parameters = {"downloadFormat": "exe"}
    else:
        query_parameters = {"downloadFormat": "bin"}
    response = requests.get(choosenim_url, params=query_parameters)
    if response.ok and response.status_code == 200:
        with open(choosenim_command, mode="wb") as file:
            file.write(response.content)

# Create Nim directory if doesn't exist
choosenim_dir = pathlib.Path(choosenim_dir)
if not pathlib.Path(choosenim_dir).exists():
    pathlib.Path(choosenim_dir).mkdir(parents=True, exist_ok=True)
    download_choosenim(choosenim_url, choosenim_version)

# For convenience and sanity
choosenim_dir = pathlib.Path(choosenim_dir).__str__()
if pathlib.Path(choosenim_command).exists():
    pathlib.Path(choosenim_command).replace(choosenim_dir + path_delimiter + "choosenim" + exe)

choosenim_command = choosenim_dir + path_delimiter + "choosenim" + exe

# Download nim versions
def download_nim(nim_version):
    print("Downloading Nim " + nim_version)
    nim_dir = choosenim_dir + path_delimiter + nim_version
    subprocess.call([choosenim_command, f'--nimbleDir:{nim_dir}', nim_version], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

custom_tools_dir = choosenim_dir + path_delimiter + "custom"
nim_dir = choosenim_dir + path_delimiter + nim_version
if not pathlib.Path(nim_dir).exists() and not pathlib.Path(custom_tools_dir).exists():
    pathlib.Path(nim_dir).mkdir(parents=True, exist_ok=True)
    download_nim(nim_version)

# temporary
quickbms_dir = tools_dir + path_delimiter + "quickbms"
quickbms_zip = "quickbms_" + OS + '.zip'
quickbms_url = "https://github.com/LittleBigBug/QuickBMS/releases/download/" + quickbms_version + "/" + quickbms_zip
quickbms_command = quickbms_dir + path_delimiter + "quickbms" + exe
quickbms_zip = quickbms_dir + path_delimiter + quickbms_zip

def download_quickbms(quickbms_url, quickbms_version):
    print("Downloading QuickBMS")
    query_parameters = {"downloadFormat": "zip"}
    response = requests.get(quickbms_url, params=query_parameters)
    if response.ok and response.status_code == 200:
        with open(quickbms_zip, mode="wb") as file:
            file.write(response.content)

def prepare_quickbms(quickbms_zip, quickbms_dir):
    print("Preparing Quickbms")
    with ZipFile(quickbms_zip, "r") as archive:
        archive.extractall(path=quickbms_dir)
    pathlib.Path(quickbms_zip).unlink()

if not pathlib.Path(quickbms_dir).exists():
    pathlib.Path(quickbms_dir).mkdir(parents=True, exist_ok=True)
    download_quickbms(quickbms_url, quickbms_version)
    prepare_quickbms(quickbms_zip, quickbms_dir)
