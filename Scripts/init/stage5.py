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
archive_types = ["vol", "zzz", "gz", "lpk", "bin", "efc", "efp"]
scripts_dir = os.getcwd() + path_delimiter + sys.argv[3] + path_delimiter + "quickbms"
docs_dir = os.getcwd() + path_delimiter + sys.argv[6]
cache_dir = os.getcwd() + path_delimiter + sys.argv[7]
# Don't add os.getcwd() to these two so they can be used as strings for replacement
game_dir = sys.argv[2]
extraction_dir = sys.argv[4]
default_extraction = os.getcwd() + path_delimiter + extraction_dir + path_delimiter + "usa"
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

def clean(name, extraction_dir, sleep):
    time.sleep(sleep)
    # Clean up temporary files left behind from extraction
    files = []
    files.extend(pathlib.Path(extraction_dir).rglob("*TEMP*"))
    for file in files:
        if file.exists():
            pathlib.Path(file).unlink()
    # Clean up any empty directories created in error
    trees = []
    trees.extend(pathlib.Path(extraction_dir).rglob(name)) # This grabs all subdirectories in the extraction_dir
    for subtree in trees:
        if pathlib.Path(subtree).exists() and not os.listdir(subtree):
            pathlib.Path(subtree).rmdir()

def cache(cache_dir, cache_type, cache_action, cache_file):
    subprocess.call(['cacher', f'{cache_dir}', f'{cache_type}', f'{cache_action}', f'{cache_file}'])

def extract_bms_script(file):
    global path_delimiter
    tmp = file.stem
    output = f'{os.path.dirname(file)}' + path_delimiter + f'{tmp}' + "_extract"
    subprocess.call(['bms_extractor', f'{file}', f'{output}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_internals(extraction_script, sleep):
    global archive_types
    files = []
    tmp = os.getcwd()
    # Grab all files within the cwd and attempt to extract them
    files.extend(pathlib.Path(tmp).rglob("*.*"))
    for file in files:
        # Extract the script into a more human readable format
        if file.suffix == ".bms":
            extract_bms_script(file)

        # If a directory, do not extract files outside of it; whoops on lpks!!!
        for arc in archive_types:
            ext = "." + arc
            if not pathlib.Path(file).is_dir() and pathlib.Path(file).suffix == ext:
                os.chdir(os.path.dirname(file))
                subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{os.path.basename(file)}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def extract_archives(name, game_dir, extraction_dir, extraction_script, sleep):
    global cache_dir
    tld = os.getcwd()
    tmp = os.getcwd() + path_delimiter + game_dir
    trees = pathlib.Path(tmp).rglob(name)
    for subtree in trees:
        # Fixes a quirk with top level volume extraction
        if name == "SYSTEM.VOL" or name == "TITLE.VOL" or name == "MC.VOL":
            name = ""
        tmp = os.path.dirname(subtree.__str__()).replace(game_dir, extraction_dir) + path_delimiter + name
        subprocess.call(['quickbms', '-Y', '-d', f'{extraction_script}', f'{subtree}', f'{tmp}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
        cache(cache_dir, "game", "files", f'{tmp}')
        os.chdir(tmp)
        extract_internals(extraction_script, sleep)
        clean(".", extraction_dir, sleep)
        os.chdir(tld)

def extract_field(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Field Models. Please wait")
    extract_archives("FLD", game_dir, extraction_dir, extraction_script, sleep)

def extract_battle(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Battle Models. Please wait")
    extract_archives("BTL", game_dir, extraction_dir, extraction_script, sleep)

def extract_gallery(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Gallery Files. Please wait")
    time.sleep(sleep)
    extract_archives("GALLERY", game_dir, extraction_dir, extraction_script, sleep)

def extract_interface(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Interface Files. Please wait")
    time.sleep(sleep)
    extract_archives("IF", game_dir, extraction_dir, extraction_script, sleep)

def extract_minigames(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting MiniGame Files. Please wait")
    time.sleep(sleep)
    extract_archives("MINI_GAME", game_dir, extraction_dir, extraction_script, sleep)

def extract_memorycard(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Memory Card Volume. Please wait")
    time.sleep(sleep)
    extract_archives("MC.VOL", game_dir, extraction_dir, extraction_script, sleep)

def extract_system(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting System Volume. Please wait")
    time.sleep(sleep)
    extract_archives("SYSTEM.VOL", game_dir, extraction_dir, extraction_script, sleep)

def extract_title(game_dir, extraction_dir, extraction_script, sleep):
    print("Extracting Title Volume. Please wait")
    time.sleep(sleep)
    extract_archives("TITLE.VOL", game_dir, extraction_dir, extraction_script, sleep)

def extract_all(game_dir, extraction_dir, extraction_script, sleep):
    extract_field(game_dir, extraction_dir, extraction_script, sleep)
    extract_battle(game_dir, extraction_dir, extraction_script, sleep)
    extract_gallery(game_dir, extraction_dir, extraction_script, sleep)
    extract_interface(game_dir, extraction_dir, extraction_script, sleep)
    extract_minigames(game_dir, extraction_dir, extraction_script, sleep)
    extract_memorycard(game_dir, extraction_dir, extraction_script, sleep)
    extract_system(game_dir, extraction_dir, extraction_script, sleep)
    extract_title(game_dir, extraction_dir, extraction_script, sleep)

def dig_for_bones(model_dir, extraction_dir, docs_dir, bones_script):
    print("Digging for bones. Please wait")
    global path_delimiter
    trees = []
    files = []
    output = docs_dir + path_delimiter + "Technical" + path_delimiter + "Models" + path_delimiter + "Field"
    trees.extend(pathlib.Path(extraction_dir).rglob(model_dir))
    for subtree in trees:
        files.extend(pathlib.Path(subtree).rglob("*.*"))
        for file in files:
            if not pathlib.Path(file).is_dir():
                output = output + path_delimiter + pathlib.Path(file).stem + ".MD"
                subprocess.call(['quickbms', '-Y', '-d', f'{bones_script}', f'{file}', '>', f'{output}'], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

def get_user_input(game_dir, extraction_dir, extraction_script, sleep):
    global cont
    global docs_dir
    global bones_script
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
        case 'b':
            dig_for_bones("FCHR", extraction_dir, docs_dir, bones_script)
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

print("Cleaning up. Please wait")
clean(".", extraction_dir, sleep)

print("Updating cache. May take a few minutes. Please wait")
cache(".cache", "game", "files", default_extraction)

print("Have a wonderful day! Happy modding, digging, and BRSing!!! :D")
