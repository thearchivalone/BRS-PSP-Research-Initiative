# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: cam.nim
##    purpose: Extract camera / canned animation data
##
##

import std/json
import std/tables

import shared
import anm
import ../tools/memory

type CAM* = ref Extractor

var
  cam_count: int # In case of a multi-model situation
  animation_count: int
  animations_list: seq[int]
  animation_offsets_list: seq[int]

proc extract_cam_headers*(e: CAM, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["file_size_addr"] = "0x24"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))
  var animation_start: int
  cam_count = read_long_string(
    local_data,
    0x04,
    1
  )
  animation_count = read_long_string(
    local_data,
    0x05,
    1
  )
  header_end = file_size
  animation_start = read_long_string(
    local_data,
    0x24,
    4
  )
  data.add(local_data)
  local_data.setLen(0)
  # Start extracting animation headers
  var cur_pos = animation_start
  for _ in 0..<animation_count:
    var anm: ANM
    ext_json.add(
      anm.extract_anm_headers(
        path, cur_pos, header_len
      )
    )
  # Return the json blob
  return ext_json
