# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## globals.py - A single point where environment and other shared variables will live using a .env system
import platform
import os
from dotenv import load_dotenv

OS = platform.system()
path_delimiter = ""
Platform = ""
llvm_platform = ""
arch = ""
exe = ""
bext = ""
match OS:
    case "Windows":
        OP = "win"
        Platform = "windows"
        arch = "x86_64"
        exe = ".exe"
        path_delimiter = "\\"
        rar = ".zip"
        bext = ".bat"
    case _:
        if OS == "Darwin":
            Platform = "macos"
            llvm_platform = Platform + "-"
            arch = "universal"
        else:
            Platform = OS
            arch = "x86_64"
        OP = Platform
        path_delimiter = "/"
        rar = ".tar.xz"
        bext = ".sh"

# Load all of the custom .env variables into the code
load_dotenv()
# Directories
game_dir = os.getcwd() + path_delimiter + os.getenv("GAME_DIR")
docs_dir = os.getcwd() + path_delimiter + os.getenv("DOCS_DIR")
extraction_dir = os.getcwd() + path_delimiter + os.getenv("EXTRACTION_DIR")
scripts_dir = os.getcwd() + path_delimiter + os.getenv("SCRIPTS_DIR")
tools_dir = os.getcwd() + path_delimiter + os.getenv("TOOLS_DIR") + path_delimiter + Platform
source_dir = os.getcwd() + path_delimiter + os.getenv("SOURCE_DIR")
cache_dir = os.getcwd() + path_delimiter + os.getenv("CACHE_DIR")
custom_dir = os.getcwd() + path_delimiter + os.getenv("CUSTOM_DIR")
db_dir = os.getcwd() + path_delimiter + os.getenv("DB_DIR")
deps_dir = cache_dir + path_delimiter + "deps"
zig_cache_dir = cache_dir + path_delimiter + "zig"
# Versions
llvm_version = os.getenv("LLVM_VERSION")
clang_version = os.getenv("CLANG_VERSION")
python_version = os.getenv("PYTHON_VERSION")
nim_version = os.getenv("NIM_VERSION")
zig_version = os.getenv("ZIG_VERSION")
quickbms_version = os.getenv("QUICKBMS_VERSION")