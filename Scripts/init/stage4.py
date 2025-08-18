# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

# Core sys libraries
import sys

import os

# portable python I'm using doesn't include pathlib, so using a backported version instead
import pathlib3x as pathlib

# for running programs
import subprocess

# Platform specific variables
exe = ""
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

game_dir = os.getcwd() + path_delimiter + sys.argv[2]

# variables
regions = ["usa", "jpn", "eur"]
psp_game_dir = "PSP_GAME"
count = 3

def check_game_files(region):
    global count
    tmp = game_dir + path_delimiter + region + path_delimiter + psp_game_dir
    kill_file = os.getcwd() + path_delimiter + "Tools" + path_delimiter + "stage4"
    if pathlib.Path(tmp).exists():
        print(f'{region.upper()} game files found')
    else:
        count = count - 1
        if count == 0:
            print(f'Please extract {psp_game_dir} folder from any version of the game and then run this script again.')
            with open(kill_file, mode="w") as file:
                file.write("")

print("Checking for Game Files")
for region in regions:
    check_game_files(region)
