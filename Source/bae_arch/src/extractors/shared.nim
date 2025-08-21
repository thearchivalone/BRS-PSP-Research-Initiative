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

var
  # data blobs
  ext_json* = %* []
  arbitrary_no* = 1024 * 16 # A 16kb buffer value for iteration in case length of data section is unknown
  # Shared variables
  header_len* = 0x64 # 100 bytes is a reasonable chunk to cover all of the variations
  data*: seq[seq[byte]]
  file_name*: string
  file_size*: int
  file_path*: string
  file_ext*: string
  file_types*: seq[string]
  file_count*: int
  magic_number*: string
  header_end*: int

proc populate_types_by_ext*(ext: string): seq[string] =
  var res: seq[string]
  case ext:
    of "vol":
      res.add("archive")
      res.add("data")
    of "bms":
      res.add("script")
    of "edx":
      res.add("data")
    of "bin":
      res.add("data")
    of "mdl":
      res.add("container")
      res.add("model")
    of "anm":
      res.add("container")
      res.add("animation")
    of "cam":
      res.add("container")
      res.add("camera")
    of "efp":
      res.add("container")
      res.add("data")
    of "efc":
      res.add("container")
      res.add("data")
    of "phd":
      res.add("data")
    of "pbd":
      res.add("debug")
    of "at3":
      res.add("asset")
      res.add("audio")
    of "ptm":
      res.add("asset")
      res.add("texture")
    of "sc":
      res.add("container")
    of "xtc":
      res.add("ui")
    of "esb":
      res.add("data")
    of "sdoa":
      res.add("data")
  return res
