# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: anm.nim
##    purpose: Extract animation data
##
##

import std/json
import std/tables

import shared
import ../tools/memory

type ANM* = ref Extractor

var
  bone_count: int

proc extract_anm_headers*(e: ANM, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["file_size_addr"] = "0x1c"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))
  data.add(local_data)
  local_data.setLen(0)
  # Begin extracting internal headers
  return ext_json
