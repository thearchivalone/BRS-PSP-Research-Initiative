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

# Versions
quickbms_version = "0.12.0"

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
source_dir = sys.argv[3]

# temporary
quickbms_dir = os.getcwd() + path_delimiter + tools_dir + path_delimiter + OS + path_delimiter + "quickbms"
quickbms_zip = "quickbms_" + OS + '.zip'
quickbms_url = "https://github.com/LittleBigBug/QuickBMS/releases/download/" + quickbms_version + "/" + quickbms_zip
quickbms_command = quickbms_dir + path_delimiter + "quickbms" + exe
quickbms_zip = quickbms_dir + path_delimiter + quickbms_zip

def download_quickbms(quickbms_url, quickbms_version):
    print("Downloading QuickBMS")
    kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage3"
    query_parameters = {"downloadFormat": "zip"}
    response = requests.get(quickbms_url, params=query_parameters)
    if response.ok and response.status_code == 200:
        with open(quickbms_zip, mode="wb") as file:
            file.write(response.content)
    else:
        print("QuickBMS files failed to download; please check your internet connection and try again later")
        with open(kill_file, mode="w") as file:
            file.write("")

def prepare_quickbms(quickbms_zip, quickbms_dir):
    print("Preparing Quickbms")
    with ZipFile(quickbms_zip, "r") as archive:
        archive.extractall(path=quickbms_dir)
    pathlib.Path(quickbms_zip).unlink()

if not pathlib.Path(quickbms_dir).exists():
    pathlib.Path(quickbms_dir).mkdir(parents=True, exist_ok=True)
    download_quickbms(quickbms_url, quickbms_version)
    prepare_quickbms(quickbms_zip, quickbms_dir)

# Nim Source tools go here
custom_source_dir = os.getcwd() + path_delimiter + source_dir
custom_tools_dir = os.getcwd() + path_delimiter + tools_dir + path_delimiter + OS + path_delimiter + "nim" + path_delimiter + "custom"

def install_extraction_tool(stem, custom_dir, custom_tools_dir):
    global exe
    global path_delimiter
    print(f'Installing {stem}')
    tmp = custom_tools_dir + path_delimiter + stem + exe
    pathlib.Path("main" + exe).replace(tmp)

def build_extraction_tool(stem, custom_dir):
    print(f'Building {stem}')
    os.chdir(custom_dir)
    subprocess.call(['nimble', 'build', '-d:release'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    
def prepare_extraction_tools(custom_source_dir, custom_tools_dir):
    print("Preparing Extraction Tools")
    trees = pathlib.Path(custom_source_dir).rglob("*.nimble")
    tmp = os.getcwd()
    for subtree in trees:
        root = os.path.dirname(subtree)
        stem = pathlib.Path(subtree).stem
        build_extraction_tool(stem, root)
        install_extraction_tool(stem, root, custom_tools_dir)
        os.chdir(tmp)

# A little bit of a hack; only rebuild custom tools if a change has been made in how many are available
source_tmp = pathlib.Path(custom_source_dir).rglob(".")
count = 0
built = 2 # Due to having Nim and Nimble installed, manually add this to prevent a loop
for i in source_tmp:
    count += 1
    for j in pathlib.Path(custom_tools_dir).rglob("*"):
        if j.stem == i.stem:
            built += 1

if built < count:
    prepare_extraction_tools(custom_source_dir, custom_tools_dir)
