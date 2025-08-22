# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: ptm.nim
##    purpose: Parse and extract texture data
##
##

import std/json
import std/tables

import shared
import ../tools/memory

type PTMD* = ref Extractor

proc extract_ptm_headers*(e: PTMD, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["file_size_addr"] = "0x0c"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))

  # Will fill in the rest later since these are a compressed format
  return ext_json
