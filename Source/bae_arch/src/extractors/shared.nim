# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: shared.nim
##    purpose: Contains methods, types and variables shared among all extractor types
##
##

import std/json
import std/paths

import ../tools/memory

var
  # data blobs
  ext_json* = %* []
  arbitrary_no* = 1024 * 16 # A 16kb buffer value for iteration in case length of data section is unknown
  # Shared variables
  header_len* = 0x64 # 100 bytes is a reasonable chunk to cover all of the variations
  data*: seq[byte]
  file_path*: string
  file_ext*: string
  file_name*: string
  file_size*: int
  magic_number*: string
  header_end*: int
  primary_type*: string
  secondary_type*: string
  file_count*: int
