# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## nim.py - Download, extract and installs nim files here
import os
import re
import subprocess
from pathlib import Path
from globals import path_delimiter, nim_version, Platform, exe, bext, tools_dir, deps_dir
import helpers

# Nim bootstrapper sources
choosenim_slug = "csources_v2-master"
choosenim_cache = deps_dir + path_delimiter + choosenim_slug
choosenim_url = "https://github.com/nim-lang/csources_v2.git"
choosenim_src_dir = choosenim_cache
choosenim_build_cmd = "build" + bext
choosenim_build_cmd = (
    choosenim_src_dir
    + path_delimiter
    + choosenim_build_cmd
)
choosenim_dir = tools_dir + path_delimiter + "nim"

def patch_choosenim(choosenim_build_cmd):
    print(f"Patching {Path(choosenim_build_cmd).stem}")
    # Use array of strings since multiple ones can exist that must be updated
    patch_string = []
    zig_string = ""
    if Platform == "windows":
        patch_string = ["gcc"]
        zig_string = "%ZIGCC%"
    else:
        patch_string = [
            'CC="${CC}"',
            'CC="gcc"',
            'CC="clang"'
        ]
        zig_string = 'CC="${ZIGCC}"'
    with open(choosenim_build_cmd, 'r+') as f:
        content = f.read()
        for c in patch_string:
            split = re.split(c, content)
            modified = zig_string.join(split)
            with open(choosenim_build_cmd, 'w') as w:
                w.write(modified)
        f.close()

def build_choosenim(choosenim_src_dir, choosenim_build_cmd):
    tmp = os.getcwd()
    os.chdir(choosenim_src_dir)
    print("Building Nim Bootstrapper. Please wait")
    subprocess.call([choosenim_build_cmd], shell=True)
    os.chdir(tmp)

if not Path(choosenim_dir).exists():
    helpers.download_source_git(choosenim_url, "Nim Bootstrapper", choosenim_cache)
    patch_choosenim(choosenim_build_cmd)
    build_choosenim(choosenim_src_dir, choosenim_build_cmd)

nim_url = "https://github.com/nim-lang/Nim.git"
nim_cache = deps_dir + path_delimiter + "nim"
nim_maintenance_tool = "koch"
nim_bootstrapper = (
    choosenim_src_dir + path_delimiter + "bin" + path_delimiter + "nim" + exe
)
nim_old_build_cmd = nim_bootstrapper
nim_build_cmd = choosenim_cache + path_delimiter + "bin" + path_delimiter + "nim" + exe
nim_dir = tools_dir + path_delimiter + "nim"
nimble_deps_dir = deps_dir + path_delimiter + "nimbledeps"

# Different tools to use with the build process
zigcc_url = "https://github.com/enthus1ast/zigcc.git"
dlls_zip = ""
dlls_url = ""

if Platform == "windows":
    dlls_zip = "dlls.zip"
    dlls_url = "https://nim-lang.org/download/" + dlls_zip

def build_nim(nim_maintenance_tool, nim_build_cmd):
    global exe

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

def install_choosenim(slug, install_dir, source):
    global exe
    print(f"Installing {source}")
    install_dir = install_dir + path_delimiter + Path(slug).stem + exe
    Path(slug).copy(install_dir)

def patch_zigcc_util():
    print("Patching Zigcc to work with local Nim")
    utils = "zigcc/src/zigcc/utils.nim"
    patch_string = "import os, osproc"
    new_string = "import std/os, std/osproc"
    with open(utils, "r+") as f:
        content = f.read()
        split = re.split(patch_string, content)
        modified = new_string.join(split)
        with open(utils, 'w') as w:
            w.write(modified)
        w.close()
    f.close()

if not Path(nim_dir).exists():
    helpers.download_source_git_b(nim_url, "Nim", nim_cache, f"v{nim_version}")

    tmp = os.getcwd()
    os.chdir(nim_cache)

    # Install temporary nim binary on path Kock can use
    install_choosenim(nim_build_cmd, "bin", "Nim boostrapper")
    if Platform == "windows":
        helpers.download_source_release(dlls_url, dlls_zip, "Nim dlls")
        helpers.prepare_source_release(dlls_zip, nim_dir, "bin", nim_dir, "Nim dlls") # nim_dir is a pure hack here
    helpers.download_source_git(zigcc_url, "zigcc", "zigcc")

    # These are required to successfully build
    os.environ["LIB"] = nim_cache + path_delimiter + "lib" + ";" + os.getenv("LIB")

    patch_zigcc_util()
    build_nim(nim_maintenance_tool, nim_build_cmd)
    os.chdir(tmp)
    helpers.install_source(nim_cache, nim_dir, "Nim Toolchain")

print("Activating Nim Toolchain")
os.environ["PATH"] = nim_dir + path_delimiter + "bin" + ";" + os.getenv("PATH")
os.environ["NIMDEPS"] = nimble_deps_dir