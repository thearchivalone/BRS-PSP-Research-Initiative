# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: mdl.nim
##    purpose: Extract model data
##
##

import std/json
import std/tables

import shared
import ptm
import ../tools/memory

type MDL* = ref Extractor

var
  vertex_start: int
  vertex_chain: int
  vertex_end: int
  vertex_len: int
  vertex_count: int
  vertices_list: seq[string]
  vertices_offsets_list: seq[int]
  model_count: int # In case of a multi-model situation
  texture_count: int
  textures_list: seq[int]
  textures_offsets_list: seq[int]

proc extract_mdl_headers*(e: MDL, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["file_size_addr"] = "0x10"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))

  var texture_start: int
  model_count = read_long_string(
    local_data,
    0x04,
    1
  )
  texture_count = read_long_string(
    local_data,
    0x05,
    1
  )
  header_end = file_size - 0x04
  vertex_start = file_size
  vertex_chain = read_long_string(
    local_data,
    0x14,
    4
  )
  vertex_end = read_long_string(
    local_data,
    0x18,
    4
  )
  vertex_len = vertex_end - vertex_start
  vertex_count = read_long_string(
    local_data,
    0x0c,
    4
  ) + 1
  texture_start = read_long_string(
    local_data,
    0x24,
    4
  )
  data.add(local_data)
  local_data.setLen(0)
  # Start extracting texture headers
  var cur_pos = texture_start
  for _ in 0..<texture_count:
    var ptm: PTMD
    ext_json.add(
      ptm.extract_ptm_headers(
        path, cur_pos, header_len
      )
    )
  # Return the json blob
  return ext_json
