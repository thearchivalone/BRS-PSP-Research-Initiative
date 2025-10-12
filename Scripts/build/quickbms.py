# Copyright 2025 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## quickbms.py - Download, extract and installs QuickBMS tools (will be removed after port work is done)
import os
from globals import tools_dir, deps_dir, path_delimiter, quickbms_version, exe, OP
from pathlib import Path
import helpers

# temporary
quickbms_dir = (
    tools_dir
    + path_delimiter
    + "quickbms"
)
quickbms_zip = "quickbms_" + OP + ".zip"
quickbms_cache = deps_dir + path_delimiter + quickbms_zip
quickbms_url = (
    "https://github.com/LittleBigBug/QuickBMS/releases/download/"
    + quickbms_version
    + "/"
    + quickbms_zip
)
quickbms_command = quickbms_dir + path_delimiter + "quickbms" + exe
quickbms_zip = quickbms_dir + path_delimiter + quickbms_zip

helpers.download_source_release(quickbms_url, quickbms_cache, "QuickBMS")
helpers.prepare_source_release(quickbms_cache, quickbms_dir, quickbms_dir, quickbms_dir, "QuickBMS")

print("Activating QuickBMS interpretor")
os.environ["PATH"] = quickbms_dir + ";" + os.getenv("PATH")