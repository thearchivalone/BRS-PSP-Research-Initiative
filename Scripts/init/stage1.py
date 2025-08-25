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
nim_version = "2.2.4"

# Platform specific variables
exe = ""
query_parameters = ""
platform = ""
bext = ""
OS = sys.argv[1]
match OS:
    case "win":
        platform = "windows"
        exe = ".exe"
        path_delimiter = "\\"
        rar = ".zip"
        bext = ".bat"
    case _:
        platform = OS
        path_delimiter = "/"
        rar = ".tar.gz"
        bext = ".sh"

tools_dir = os.getcwd() + path_delimiter + sys.argv[2]
deps_dir = sys.argv[3]
scripts_dir = os.getcwd() + path_delimiter + sys.argv[4]

# Tools urls
choosenim_dir = tools_dir + path_delimiter + OS + path_delimiter + "nim"

# temporary
choosenim_slug = "csources_v2-master"
choosenim_cache = deps_dir + path_delimiter + choosenim_slug
choosenim_url = "https://github.com/nim-lang/csources_v2.git"
choosenim_src_dir = choosenim_cache
choosenim_build_cmd = "build" + bext
choosenim_old_build_cmd = (
    scripts_dir + path_delimiter + "nim" + path_delimiter + choosenim_build_cmd
)
choosenim_build_cmd = (
    os.getcwd()
    + path_delimiter
    + choosenim_src_dir
    + path_delimiter
    + choosenim_build_cmd
)


def download_choosenim(choosenim_url):
    print("Downloading Nim Bootstrapper")
    global choosenim_src_dir
    subprocess.call(
        ["git", "clone", "--depth=1", "--recurse", choosenim_url, choosenim_src_dir]
    )


def prepare_choosenim(choosenim_src_dir):
    global choosenim_old_build_cmd
    global choosenim_build_cmd
    print("Preparing Nim Bootstrapper")
    pathlib.Path(choosenim_old_build_cmd).copy(choosenim_build_cmd)


def build_choosenim(choosenim_src_dir, choosenim_build_cmd):
    tmp = os.getcwd()
    os.chdir(choosenim_src_dir)
    print("Building Nim Bootstrapper. Please wait")
    subprocess.call([choosenim_build_cmd], shell=True)
    os.chdir(tmp)


# Create Nim directory if doesn't exist
choosenim_dir = pathlib.Path(choosenim_dir).__str__()
if not pathlib.Path(choosenim_dir).exists():
    if not pathlib.Path(choosenim_cache).exists():
        download_choosenim(choosenim_url)
    prepare_choosenim(choosenim_src_dir)
    build_choosenim(choosenim_src_dir, choosenim_build_cmd)

nim_url = "https://github.com/nim-lang/Nim.git"
nim_cache = deps_dir + path_delimiter + "nim"
nim_src_dir = os.getcwd() + path_delimiter + nim_cache
nim_maintenance_tool = "koch"

nim_bootstrapper = (
    choosenim_src_dir + path_delimiter + "bin" + path_delimiter + "nim" + exe
)
nim_old_build_cmd = (
    os.getcwd() + path_delimiter + nim_bootstrapper
)  # To fix a weird pathing issue
nim_build_cmd = nim_src_dir + path_delimiter + "bin" + path_delimiter + "nim" + exe

# Different tools to use with the build process
zigcc_url = "https://github.com/enthus1ast/zigcc.git"
dlls_zip = "dlls.zip"
dlls_url = "https://nim-lang.org/download/" + dlls_zip


def download_nim(nim_version, nim_src_dir):
    print("Downloading Nim " + nim_version)
    subprocess.call(
        [
            "git",
            "clone",
            "--depth=1",
            f"--branch=v{nim_version}",
            "--recurse",
            nim_url,
            nim_src_dir,
        ]
    )


def download_dlls(dlls_url):
    print("Downloading Windows Required DLLs. Please wait")
    kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage3"
    query_parameters = {"downloadFormat": "zip"}
    response = requests.get(dlls_url, params=query_parameters)
    if response.ok and response.status_code == 200:
        with open(dlls_zip, mode="wb") as file:
            file.write(response.content)
    else:
        print(
            "dlls files failed to download; please check your internet connection and try again later"
        )
        with open(kill_file, mode="w") as file:
            file.write("")


def prepare_dlls(dlls_zip):
    print("Preparing dlls")
    with ZipFile(dlls_zip, "r") as archive:
        archive.extractall("bin")


def prepare_nim(zigcc_url, dlls_url, nim_src_dir):
    global nim_old_build_cmd
    global nim_build_cmd
    global dlls_zip
    pathlib.Path(nim_old_build_cmd).replace(nim_build_cmd)
    tmp = os.getcwd()
    os.chdir(nim_src_dir)

    print("Downloading Zigcc Sources. Please wait")
    subprocess.call(["git", "clone", "--depth=1", "--recurse", zigcc_url])

    if OS == "win":
        download_dlls(dlls_url)
        prepare_dlls(dlls_zip)

    os.chdir(tmp)


def build_nim(nim_src_dir, nim_build_cmd):
    global nim_maintenance_tool
    global exe
    tmp = os.getcwd()
    os.chdir(nim_src_dir)

    print("Building Zigcc Sources. Please wait")
    zigcc_cmd = "zigcc" + path_delimiter + "src" + path_delimiter + "zigcc"
    subprocess.call([nim_build_cmd, "c", "--noNimblePath", "--skipUserCfg", zigcc_cmd])

    print("Building Nim Stage 1. Please wait")
    subprocess.call(
        [
            nim_build_cmd,
            "c",
            "--noNimblePath",
            "--skipUserCfg",
            "--cc:clang",
            "--threads:on",
            f"--clang.exe={zigcc_cmd}",
            f"--clang.linkerexe={zigcc_cmd}",
            nim_maintenance_tool,
        ]
    )

    zigcc_cmd = zigcc_cmd + exe
    print("Building Nim Stage 2. Please wait")
    subprocess.call(
        [
            nim_maintenance_tool,
            "--stable",
            "boot",
            "-d:release",
            "--threads:on",
            "--cc:clang",
            f"--clang.exe={zigcc_cmd}",
            f"--clang.linkerexe={zigcc_cmd}",
            "--skipUserCfg",
            "--skipParentCfg",
        ]
    )

    print("Building Nim Tools. Please wait")
    subprocess.call(
        [
            nim_maintenance_tool,
            "--stable",
            "tools",
            "--d:release",
            "--threads:on",
            "--cc:clang",
            f"--clang.exe={zigcc_cmd}",
            f"--clang.linkerexe={zigcc_cmd}",
            "--skipUserCfg",
            "--skipParentCfg",
        ]
    )
    os.chdir(tmp)


def install_nim(nim_src_dir, nim_dir):
    global path_delimiter
    print("Installing Nim Toolchain. Please wait")
    pathlib.Path(nim_src_dir).replace(nim_dir)


nim_dir = choosenim_dir
if not pathlib.Path(nim_dir).exists():
    download_nim(nim_version, nim_src_dir)
    prepare_nim(zigcc_url, dlls_url, nim_src_dir)
    build_nim(nim_src_dir, nim_build_cmd)
    install_nim(nim_src_dir, nim_dir)
