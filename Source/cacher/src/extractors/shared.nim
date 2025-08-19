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
  arbitrary_no = 1024 * 16 # A 16kb buffer value for iteration in case length of data section is unknown
 # These are specific to each unique file format type
  magic_number*: string
  header_end*: int
  size*: int
  primary_type*: string
  secondary_type*: string
  file_count*: int
  files_list*: seq[string]
  offsets_list*: seq[int]
  sizes_list*: seq[int]
  path*: string
  ext*: string
  file_name*: string

# Make this a type so that only extractors have direct access to most of the shared vars
type Extractor* = ref object of RootObj

proc new_extractor*(p: string): Extractor =
  var self: Extractor
  # Sanitize the path just in case
  path = p
  ext = get_file_ext(path)
  file_name = get_file_name(path)
  return self
