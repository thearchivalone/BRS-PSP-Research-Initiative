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
import std/strformat
import std/strutils
import std/paths
import std/tables
import std/base64

import ../tools/memory

type Extractor* = ref object of RootObj

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
  file_archive*: string
  file_ext*: string
  file_types*: seq[string]
  file_count*: int
  file_embedded_counts*: seq[int]
  magic_number*: string
  magic_extra*: int
  header_end*: int
  header_encoded*: string

proc print_extracted*(key: string, value: string): void =
  echo fmt"{key}: {value}"

proc populate_types_by_ext*(ext: string): seq[string] =
  var res: seq[string]
  case ext:
    of "VOL":
      res.add("archive")
      res.add("data")
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
    of "SC":
      res.add("container")
    of "sc":
      res.add("container")
    of "xtc":
      res.add("ui")
    of "esb":
      res.add("data")
    of "sdoa":
      res.add("data")
    of "lpk":
      res.add("container")
  return res

proc extract_header_data*(buffer: seq[byte], t: TableRef): JsonNode =
  header_encoded = encode(buffer)
  file_path = t.mgetOrPut("file_path")
  let p = extractFilename(cast[Path](file_path))
  let par = parentDir(cast[Path](file_name))
  file_name = fmt"{p}"
  if len(file_name) != 0:
    file_ext = file_name.split('.')[1]
  magic_number = t.mgetOrPut(
    "magic_number",
    read_char_string(
      buffer,
      0x00,
      parseHexInt(
        t.mgetOrPut(
          "magic_len", "0x04"
        )
      )
    )
  ).split('\x00')[4]
  if magic_number != "RTDP":
    file_archive = fmt"{par}"
  if magic_number != "LPK":
    header_end = read_long_string(
      buffer,
      parseHexInt(
        t.mgetOrPut(
          "header_end_addr", "0x30"
        )
      ),
      4
    )
    file_size = read_long_string(
      buffer,
      parseHexInt(
        t.mgetOrPut(
          "file_size_addr", "0x04"
        )
      ),
      4
    )
  file_types = populate_types_by_ext(file_ext)
  for f in file_types:
    if f == "archive" or f == "container":
      file_count = read_long_string(
        buffer,
        parseHexInt(
          t.mgetOrPut(
            "file_count_addr", "0x04"
          )
        ),
        4
      )
  var output = %*{
    "file header": header_encoded,
    "file name": file_name,
    "file size": file_size,
    "file archive": file_archive,
    "file extension": file_ext,
    "file types": file_types,
    "magic number": magic_number
  }
  return output
