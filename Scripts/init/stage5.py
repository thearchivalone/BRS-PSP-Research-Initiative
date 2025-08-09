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

# for delaying things
import time

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

# Variables
archive_types = ["vol", "zzz", "gz"]
scripts_dir = os.getcwd() + path_delimiter + sys.argv[3] + path_delimiter + "quickbms"
# Don't add os.getcwd() to these two so they can be used as strings for replacement
game_dir = sys.argv[2]
extraction_dir = sys.argv[4]
sleep = int(sys.argv[5])
cont = True

# Scripts
bones_script = scripts_dir + path_delimiter + "BRS-Dig-For-Bones.bms"
extraction_script = scripts_dir + path_delimiter + "BRS-Extract.bms"

# Start Running the Actual Extraction Functions
time.sleep(sleep)

def delete_extraction_dir(extraction_dir, sleep):
    print("Removing extracted files. Please wait")
    time.sleep(sleep)
    if pathlib.Path(extraction_dir).exists():
        pathlib.Path(extraction_dir).rmtree()

def clean(extraction_dir, sleep):
    print("Cleaning up. Please wait")
    time.sleep(sleep)
    files = pathlib.Path(extraction_dir).rglob("*TEMP*")
    for file in files:
        if file.exists():
            pathlib.Path(file).unlink()

def extract_internals(rglob_dir, extraction_dir, extraction_script, sleep):
    print("Extracting embedded archives. Please wait")
    time.sleep(sleep)
    global archive_types
    files = []
    tmp = os.getcwd()
    for arc in archive_types:
        files.extend(pathlib.Path(extraction_dir).rglob(arc))
    for file in files:
        for parent in file.parents():
            if parent == f'{rglob_dir}':
                os.chdir(os.path.dirname(file.__str__()))
                subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
                os.chdir(tmp)

def extract_field(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Field Models. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("FLD")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_battle(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Battle Models. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("BTL")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_gallery(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Gallery Files. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("GALLERY")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_interface(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Gallery Files. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("IF")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    extract_internals("IF", extraction_dir, extraction_script, sleep)

def extract_minigames(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Gallery Files. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("Mini_Game")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_memorycard(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Memory Card Volume. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("MC.VOL")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_system(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting System Volume. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("SYSTEM.VOL")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    extract_internals("SYSTEM.VOL", extraction_dir, extraction_script, sleep)

def extract_title(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Title Volume. Please wait")
    global path_delimiter
    time.sleep(sleep)
    tmp = os.getcwd() + path_delimiter + game_dir
    files = pathlib.Path(tmp).rglob("TITLE.VOL")
    for file in files:
        tmp = os.path.dirname(file.__str__()).replace(game_dir, extraction_dir)
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{file}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    extract_internals("TITLE.VOL", extraction_dir, extraction_script, sleep)

def extract_all(game_dir, extraction_dir, extraction_script, sleep):
    extract_field(game_dir, extraction_dir, extraction_script, sleep)
    extract_battle(game_dir, extraction_dir, extraction_script, sleep)
    extract_gallery(game_dir, extraction_dir, extraction_script, sleep)
    extract_interface(game_dir, extraction_dir, extraction_script, sleep)
    extract_minigames(game_dir, extraction_dir, extraction_script, sleep)
    extract_memorycard(game_dir, extraction_dir, extraction_script, sleep)
    extract_system(game_dir, extraction_dir, extraction_script, sleep)
    extract_title(game_dir, extraction_dir, extraction_script, sleep)

def get_user_input(game_dir, extraction_dir, extraction_script, sleep):
    global cont
    print("What would you like to do today?")
    print("1) Extract Field Models")
    print("2) Extract Battle Models")
    print("3) Extract Gallery Files")
    print("4) Extract Interface Files")
    print("5) Extract MiniGame Files")
    print("6) Extract Memory Card Volume")
    print("7) Extract System Volume")
    print("8) Extract Title Volume")
    print("a) Extract All of These")
    print("b) Dig For Bones")
    print("q) Quit this Program")
    print("d) Delete All Extracted Files")

    response = input("Please type selection and press Enter key: ")

    match response:
        case 'q':
            cont = False
        case 'a':
            extract_all(game_dir, extraction_dir, extraction_script, sleep)
        case 'd':
            delete_extraction_dir(extraction_dir, sleep)
        case '1':
            extract_field(game_dir, extraction_dir, extraction_script, sleep)
        case '2':
            extract_battle(game_dir, extraction_dir, extraction_script, sleep)
        case '3':
            extract_gallery(game_dir, extraction_dir, extraction_script, sleep)
        case '4':
            extract_interface(game_dir, extraction_dir, extraction_script, sleep)
        case '5':
            extract_minigames(game_dir, extraction_dir, extraction_script, sleep)
        case '6':
            extract_memorycard(game_dir, extraction_dir, extraction_script, sleep)
        case '7':
            extract_system(game_dir, extraction_dir, extraction_script, sleep)
        case '8':
            extract_title(game_dir, extraction_dir, extraction_script, sleep)

while cont == True:
    get_user_input(game_dir, extraction_dir, extraction_script, sleep)

clean(extraction_dir, sleep)

print("Have a wonderful day! Happy modding, digging, and BRSing!!! :D")
