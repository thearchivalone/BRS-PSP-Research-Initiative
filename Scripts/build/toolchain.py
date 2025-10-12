# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## toolchain.py - Download, extract and installs toolchain files here
import os
from pathlib import Path
from globals import path_delimiter, llvm_version, llvm_platform, clang_version, Platform, zig_version, zig_cache_dir, exe, arch, rar, tools_dir, deps_dir, cache_dir
import helpers

if not Path(cache_dir).exists():
    os.mkdir(cache_dir)

if not Path(deps_dir).exists():
    os.mkdir(deps_dir)

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

helpers.download_source_release(llvm_url, llvm_cache, "llvm")
helpers.prepare_source_release(llvm_cache, llvm_slug, tools_dir, llvm_dir, "llvm")
helpers.install_source(llvm_slug, llvm_dir, "llvm")
helpers.cleanup_slug(llvm_slug, "llvm")

zig_slug = "zig-x86_64-" + Platform + "-" + zig_version
zig_zip = zig_slug + rar
zig_cache = deps_dir + path_delimiter + zig_zip
zig_url = "https://ziglang.org/download/" + zig_version + "/" + zig_zip
zig_zip = tools_dir + path_delimiter + zig_zip
zig_slug = tools_dir + path_delimiter + zig_slug
zig_dir = tools_dir + path_delimiter + "zig"

helpers.download_source_release(zig_url, zig_cache, "zig")
helpers.prepare_source_release(zig_cache, zig_slug, tools_dir, zig_dir, "zig")
helpers.install_source(zig_slug, zig_dir, "zig")
helpers.cleanup_slug(zig_slug, "zig")

print("Activating Toolchain")

# Set these in case they are null
if not "LIB" in os.environ:
    os.environ["LIB"] = ""
if not "INCLUDE" in os.environ:
    os.environ["INCLUDE"] = ""

os.environ["PATH"] = llvm_dir + path_delimiter + "bin" + ";" + zig_dir + path_delimiter + "bin" + ";" + os.getenv("PATH")
os.environ["COMPILER_PATH"] = llvm_dir + path_delimiter + "bin"
os.environ["INCLUDE"] = llvm_dir + path_delimiter + "lib" + path_delimiter + "clang" + path_delimiter + clang_version + path_delimiter + "include" + ";" + llvm_dir + path_delimiter + "include" + ";" + os.getenv("INCLUDE")
os.environ["LIB"] = llvm_dir + path_delimiter + "lib" + path_delimiter + "clang" + path_delimiter + clang_version + path_delimiter + "lib" + ";" + llvm_dir + path_delimiter + "bin" + ";" + os.getenv("LIB")
os.environ["ZIGCC"] = zig_dir + path_delimiter + "zig" + exe + " cc"
os.environ["ZIGCPP"] = zig_dir + path_delimiter + "zig" + exe + " c++"
# Set this for sanity when compiling with zig
os.environ["ZIG_LOCAL_CACHE_DIR"] = zig_cache_dir