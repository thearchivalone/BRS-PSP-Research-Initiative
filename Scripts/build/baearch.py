# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## baearch.py - Build all of the main tooling here
import os
from globals import tools_dir, source_dir, custom_dir, deps_dir, path_delimiter, exe
from pathlib import Path
import subprocess
import helpers
# Nim Source tools go here
custom_source_dir = source_dir
custom_tools_dir = custom_dir

if not Path(custom_tools_dir).exists():
    Path(custom_tools_dir).mkdir()


def install_extraction_tool(stem, custom_tools_dir):
    global exe
    global path_delimiter
    print(f"Installing {stem}")
    tmp = custom_tools_dir + path_delimiter + stem + exe
    exe_path = "src" + path_delimiter + "main" + exe
    Path(exe_path).replace(tmp)


def build_extraction_tool(stem, custom_dir):
    global nimble_deps
    global exe
    print(f"Building {stem}")
    nimble_deps_dir = (
        deps_dir + path_delimiter + "nimbledeps"
    )
    nimble_pkgs_dir = nimble_deps_dir + path_delimiter + "pkgs2"
    nim_dir = (
        tools_dir
        + path_delimiter
        + "nim"
    )
    nim_bin_dir = nim_dir + path_delimiter + "bin"
    nimble_bin = nim_bin_dir + path_delimiter + "atlas" + exe
    nim_bin = nim_bin_dir + path_delimiter + "nim" + exe
    zigcc = (
        nim_dir
        + path_delimiter
        + "zigcc"
        + path_delimiter
        + "src"
        + path_delimiter
        + "zigcc"
        + exe
    )
    os.chdir(custom_dir)
    subprocess.call([nimble_bin, "install"])
    subprocess.call(
        [
            nim_bin,
            "c",
            "--cc:clang",
            f"--clang.exe={zigcc}",
            f"--clang.linkerexe={zigcc}",
            "--opt:speed",
            f"--nimblePath:{nimble_pkgs_dir}",
            "-d:release",
            "--deepcopy:on",
            "src/main.nim",
        ],
    )


def prepare_extraction_tools(custom_source_dir, custom_tools_dir):
    global path_delimiter
    print("Preparing Extraction Tools")
    trees = Path(custom_source_dir).rglob("*.nimble")
    tmp = os.getcwd()
    for subtree in trees:
        root = os.path.dirname(subtree)
        stem = Path(subtree).stem
        build_extraction_tool(stem, root)
        install_extraction_tool(stem, custom_tools_dir)
        os.chdir(tmp)


prepare_extraction_tools(custom_source_dir, custom_tools_dir)