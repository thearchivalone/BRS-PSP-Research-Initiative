# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: lpk.nim
##    purpose: Parse and extract lpk archives
##
##

import std/json
import std/tables

import shared
import ../tools/memory

type LPK* = ref Extractor

var
  offsets_list: seq[int]

proc extract_lpk_headers*(e: LPK, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["magic_len"] = "0x03"
  tbl["file_count_addr"] = "0x04"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))
  return ext_json
