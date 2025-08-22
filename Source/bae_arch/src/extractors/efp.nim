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
import mdl
import anm
import esb
import ../tools/memory

type EFP* = ref Extractor

var
  esb_count: int
  esb_files_list: seq[string]
  esb_offsets_list: seq[int]
  model_count: int
  model_files_list: seq[string]
  model_offsets_list: seq[int]
  animation_count: int
  animation_files_list: seq[string]
  animation_offsets_list: seq[int]
  efp_index: int

proc extract_efp_headers*(e: EFP, path: string, start: int, len: int): JsonNode =
  var local_data: seq[byte]
  var tbl = newTable[string, string]()
  tbl["file_path"] = path
  tbl["magic_len"] = "0x03"
  tbl["header_end_addr"] = "0x30"

  local_data = read_header_data(path, start, len)
  ext_json.add(extract_header_data(local_data, tbl))

  var model_start = header_end
  var animation_start: int
  var esb_start: int
  esb_count = read_long_string(
    local_data,
    0x0c,
    1
  )
  model_count = read_long_string(
    local_data,
    0x0d,
    1
  )
  animation_count = read_long_string(
    local_data,
    0x0e,
    1
  )
  efp_index = read_long_string(
    local_data,
    0x0f,
    1
  )
  animation_start = read_long_string(
    local_data,
    0x10,
    4
  ) + model_start
  # Add the current local_data to data blob and then flush to reuse it
  data.add(local_data)
  local_data.setLen(0)
  # Begin extracting headers based on file type
  # Extract Model Headers
  var cur_pos = model_start
  for _ in 0..<model_count:
    var mdl: MDL
    ext_json.add(
      mdl.extract_mdl_headers(
        path, cur_pos, header_len
      )
    )
  # Extract Animation Headers
  for _ in 0..<animation_count:
    var anm: ANM
    ext_json.add(
      anm.extract_anm_headers(
        path, cur_pos, header_len
      )
    )
  # Extract ESB Headers
  for _ in 0..<esb_count:
    var esb: ESB
    ext_json.add(
      esb.extract_esb_headers(
        path, cur_pos, header_len
      )
    )
  return ext_json
