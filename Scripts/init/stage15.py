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
odin_version = "2025-09"

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
        cmd = exe
        path_delimiter = "\\"
    case _:
        platform = OS
        cmd = ".sh"
        path_delimiter = "/"

tools_dir = os.getcwd() + path_delimiter + sys.argv[2] + path_delimiter + OS
deps_dir = os.getcwd() + path_delimiter + sys.argv[3]
source_dir = os.getcwd() + path_delimiter + sys.argv[4]

# Use GLFW for windowing, sokol for GL and clay (?) for ui layout
glad_dir = source_dir + path_delimiter + "glad"
glfw_url = "https://github.com/glfw/glfw.git"
glfw_cache = deps_dir + path_delimiter + "glfw"
sokol_url = "https://github.com/floooh/sokol.git"
sokol_cache = deps_dir + path_delimiter + "sokol"
clay_url = "https://github.com/nicbarker/clay.git"
clay_cache = deps_dir + path_delimiter + "clay"

def download_source(url, source, cache):
    if not pathlib.Path(cache).exists():
        print(f"Downloading {source} sources")
        subprocess.call(
            [
                "git",
                "clone",
                "--recursive",
                "--depth=1",
                url,
                cache
            ]
        )

# Build GLFW without Cmake Courtesy: https://medium.com/@m0_/compiling-glfw-on-windows-without-cmake-graphics-framework-series-ebee8720d9b1
def build_glad(glad_dir):
    print("Building GLFW dependency")
    tmp = os.getcwd()
    os.chdir(glad_dir)
    subprocess.call(
        [
            "clang",
            "-c",
            "-I./include",
            "src/gl.c"
        ]
    )
    os.chdir(tmp)

def build_glfw(glfw_cache, glad_dir):
    global OS, path_delimiter, cmd
    print("Building GLFW. Please wait")
    tmp = os.getcwd()
    build_dir = "build"
    os.chdir(glfw_cache)
    if not pathlib.Path(build_dir).exists():
        os.mkdir(build_dir)
    os.chdir(build_dir)
    C_FLAGS = f""",
        -Bstatic,
    """
    INCLUDE = f""",
        -I {glad_dir}{path_delimiter}include,
    """
    SRC_FOLDER = f"..{path_delimiter}src"
    GEN_C = f""",
        {SRC_FOLDER}{path_delimiter}context.c,
        {SRC_FOLDER}{path_delimiter}egl_context.c,
        {SRC_FOLDER}{path_delimiter}glx_context.c,
        {SRC_FOLDER}{path_delimiter}init.c,
        {SRC_FOLDER}{path_delimiter}input.c,
        {SRC_FOLDER}{path_delimiter}monitor.c,
        {SRC_FOLDER}{path_delimiter}null_init.c,
        {SRC_FOLDER}{path_delimiter}null_joystick.c,
        {SRC_FOLDER}{path_delimiter}null_monitor.c,
        {SRC_FOLDER}{path_delimiter}null_window.c,
        {SRC_FOLDER}{path_delimiter}osmesa_context.c,
        {SRC_FOLDER}{path_delimiter}platform.c,
        {SRC_FOLDER}{path_delimiter}vulkan.c,
        {SRC_FOLDER}{path_delimiter}window.c,
    """
    MAIN_C = f""",
        {glad_dir}{path_delimiter}gl.o,
        {glfw_cache}{path_delimiter}examples{path_delimiter}boing.c,
    """
    EXTRA_C = f""",
        {glfw_cache}{path_delimiter}deps{path_delimiter}getopt.c,
        {glfw_cache}{path_delimiter}deps{path_delimiter}tinycthread.c,
    """
    if OS == "win":
        C_FLAGS = C_FLAGS + """,
            -D_GLFW_WIN32,
        """
        GLFW_WIN = f"{SRC_FOLDER}"
        INCLUDE = INCLUDE + f""",
            -I {glad_dir}{path_delimiter}include,
            -I {glfw_cache}{path_delimiter}include{path_delimiter},
            -I {GLFW_WIN},
            -I {glfw_cache}{path_delimiter}examples,
        """
        WIN_C = f""",
            {GLFW_WIN}{path_delimiter}wgl_context.c,
            {GLFW_WIN}{path_delimiter}win32_init.c,
            {GLFW_WIN}{path_delimiter}win32_joystick.c,
            {GLFW_WIN}{path_delimiter}win32_module.c,
            {GLFW_WIN}{path_delimiter}win32_monitor.c,
            {GLFW_WIN}{path_delimiter}win32_thread.c,
            {GLFW_WIN}{path_delimiter}win32_time.c,
            {GLFW_WIN}{path_delimiter}win32_window.c,
            {GLFW_WIN}{path_delimiter}wl_init.c,
            {GLFW_WIN}{path_delimiter}wl_monitor.c,
            {GLFW_WIN}{path_delimiter}wl_window.c,
        """
        args = ["clang", "-c"]
        args = args + GEN_C.replace(" ", "").replace("?", " ").split(",\n")
        args = args + EXTRA_C.replace(" ", "").replace("?", " ").split(",\n")
        args = args + WIN_C.replace(" ", "").replace("?", " ").split(",\n")
        args = args + C_FLAGS.replace(" ", "").replace("?", " ").split(",\n")
        args = args + INCLUDE.replace(" ", "").replace("?", " ").split(",\n")
        subprocess.call(
            args,
        )
    else:
        print("Goop")
    os.chdir(tmp)

build_glad(glad_dir)
download_source(glfw_url, "glfw", glfw_cache)
build_glfw(glfw_cache, glad_dir)
download_source(sokol_url, "sokol", sokol_cache)
download_source(clay_url, "clay", clay_cache)