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
import std/strformat
import std/strutils
import std/paths
import std/base64

import shared
import ../tools/memory

var
  vertex_start: int
  vertex_end: int
  vertex_len: int
  vertex_count: int
  vertices_list: seq[string]
  texture_count: int
  textures_list: seq[int]

proc extract_data*(path: string, start: int, len: int): void =
  var local_data: seq[byte]
  magic_number = "INSM"
  local_data = read_header_data(path, start, len)
  header_end = read_long_string(
    local_data,
    0x10,
    4
  ) - 0x04
  vertex_start = header_end + 0x04
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
  file_size = header_end # These are the same, so use them as such
  data.add(local_data)
  local_data.setLen(0)
  # Start working through header to collect useful information
  local_data.add(
    read_header_data(
      path, vertex_start, vertex_len
    )
  )
  var cur_pos = vertex_start
  var chain_start = 0x010d
  var killswitch = 0x3f80000
  var kill = false
  var chunk: seq[byte]
  var i = 0
  while i < vertex_count:
    var vertex_index = read_long_string(local_data, cur_pos, 2)
    var vertex_jump = read_long_string(local_data, cur_pos + 0x04, 4) - 0x04
    if vertex_index == chain_start:
      break
    if vertex_index == killswitch:
      kill = true
      break
    dec(cur_pos, cur_pos)
    inc(cur_pos, vertex_jump)
    # Read chunk from file
    chunk = read_header_data(path, vertex_jump, 4)
    dec(vertex_jump, vertex_jump)
    inc(vertex_jump, read_long_string(chunk, 0, 4))
    chunk.setLen(0)
    inc(i)
  if not kill:
    var remainder = vertex_count - i - 1
    for j in i..< vertex_count:
      # Read the chain
