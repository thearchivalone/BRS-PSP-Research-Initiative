# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: sc.nim
##    purpose: Extract field data structures
##
##

import std/json
import std/tables

import shared
import ../tools/memory

type SC* = ref Extractor

var
  hierarchy: int
  container_start: int
  container_offsets_list: seq[int]
  container_sizes_list: seq[int]

proc extract_sc_headers*(e: SC, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["magic_len"] = "0x02"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))
  hierarchy = read_long_string(
    local_data,
    0x02,
    1
  )
  container_start = read_long_string(
    local_data,
    0x04,
    4
  )
  # Fix a bug with some containers
  if container_start == 0x3c:
    dec(container_start, 0x0c)
  # Read the offsets
  var cur_pos = 0x08
  var prev: int
  for _ in 0..<10:
    var tmp = read_long_string(
      local_data,
      cur_pos,
      4
    )
    if tmp != 0 and tmp != prev:
      container_offsets_list.add(tmp)
      prev = tmp
      inc(cur_pos, 0x04)
    else:
      break
  # Read the internal headers
  # Will fill in as I figure this out
  return ext_json
