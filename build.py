# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## build.py - This is where the build system starts
import sys
import os
import importlib
import subprocess
from pathlib import Path

# Temporarily add these directories to the PYTHON_PATH variable so Python can import their modules more easily
sys.path.append(os.path.abspath("./Scripts/shared/"))

# check globals are accessible
try:
    importlib.import_module('globals')
except ImportError:
    print("Globals module is not accessible. Check PYTHONPATH and try again")
from globals import python_version

def check_python_version():
    print("Checking if Python version is supported")
    version = sys.version_info
    if version.major < 3:
        print("Please download a supported version of Python")
        sys.exit()
    else:
        if version.minor < 11:
            print("Please download a supported version of Python")
            sys.exit()

def check_package_manager():
    print("Checking if PDM is installed")
    try:
        importlib.import_module('pdm')
    except ImportError:
        subprocess.call(
            [
                "python3",
                "-m",
                "pip",
                "install",
                "--user",
                "pdm"
            ]
        )

def check_python_venv():
    print("Checking if Python isolated environment exist")
    if not Path(".venv").exists():
        subprocess.call(
            [
                "python3",
                "-m",
                "pdm",
                "venv",
                "create"
            ]
        )

def check_python_venv_version(python_version):
    print(f"Checking if Python {python_version} is installed")
    subprocess.call(
        [
            "python3",
            "-m",
            "pdm",
            "use",
            python_version
        ]
    )

def install_python_modules():
    print("Installing required python modules")
    subprocess.call(
        [
            "python3",
            "-m",
            "pdm",
            "install",
            "--venv"
        ]
    )

check_python_version()
check_package_manager()
check_python_venv()
install_python_modules()
check_python_venv_version(python_version)

print("Importing local modules")
from globals import scripts_dir

print("Fixing paths")
sys.path.append(os.path.abspath(scripts_dir + "/build/"))

import toolchain
import nim
import quickbms
import baearch