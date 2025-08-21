# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: memory.nim
##    purpose: Contains primarily methods, types and variables related to memory related tasks such as general file information and reading data into buffers
##
##

import std/json
import std/streams
import std/paths
import std/strformat
import std/strutils
import std/os

# 256KB to help with optimizing reading and memory management
var block_size = 4096 * 64 # Read game data in decently large chunks to speed up extraction

proc trim_char_string*(buffer: seq[byte]): string =
  var s = newString(4)
  for i in buffer:
    if i == 0:
      break
    s.add(cast[char](i))
  return s

proc read_char_string*(buffer: seq[byte], start: int, len: int): string =
  var i = 0
  var s: seq[byte]
  while i < len:
    s.add(buffer[i + start])
    inc(i)
  return trim_char_string(s)

proc reverse_long_string*[T](buffer: seq[T]): string =
  var i = len(buffer) - 1
  var s = newStringOfCap(2)
  while i > -1:
    var b = buffer[i]
    if b != 0:
      s.add(toHex(b))
    # Cover instances where either the long is 0 or is 2+ bytes long but ends with 00
    if i + len(s) == 0 or (len(s) > 0 and b == 0):
      s.add("00")
    dec(i)
  return s

# Read a 4 byte chunk of data
proc read_long_string*(buffer: seq[byte], start: int, len: int): int =
  var i = 0
  var s: seq[byte]
  while i < len:
    s.add(buffer[i + start])
    inc(i)
  let s1 = reverse_long_string(s)
  return parseHexInt(s1)

proc get_file_size*(p: string): int =
  var f = open(p, fmRead)
  var size = f.getFileSize()
  f.close()
  return size

proc get_file_ext*(p: string): string =
  return splitFile(cast[Path](p)).ext

proc get_file_name*(p: string): string =
  return fmt"{extractFilename(cast[Path](p))}"

proc read_file_data*(p: string): string =
  var fs = openFileStream(p)
  var s: string = fs.readAll()
  fs.close()
  return s

# Only the header data needs to be read in most instances, so why waste the memory?
proc read_header_data*(path: string, start: int, len: int): seq[byte] =
  var buffer: seq[byte]
  buffer.setLen(len)
  var f = open(path, fmRead)
  f.setFilePos(start)
  discard f.readBytes(buffer, 0, len)
  f.close()
  return buffer

# Hash all files
# Print file name + hash
