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
import std/dirs
import std/strutils
import std/sequtils
import std/os

var full_walk_buffer: seq[ptr seq[char]]
# 256KB to help with optimizing reading and memory management
var block_size = 4096 * 64 # Read game data in decently large chunks to speed up extraction

proc trim_char_string*(buffer: string): string =
  var s = newString(4)
  for i in buffer:
    if i == '\x00':
      break
    s.add(i)
  return s

proc read_char_string*(buffer: string, start: int, len: int): string =
  var i = 0
  var s = newStringOfCap(len)
  while i < len:
    s.add(buffer[i])
    inc(i)
  return trim_char_string(s)

proc reverse_long_string*[T](buffer: seq[T]): string =
  var i = len(buffer) - 1
  var s = newStringOfCap(2)
  while i > -1:
    let b = parseInt(fmt"{buffer[i]}")
    if b != 0:
      s.add(toHex(b))
    if b + i + len(s) == 0:
      s.add("00")
    dec(i)
  return s

# Read a 4 byte chunk of data
proc read_long_string*(buffer: string, start: int, len: int): int =
  var i = 0
  var s = newStringOfCap(len)
  while i < len:
    s.add(buffer[i + start])
    inc(i)
  let s1 = reverse_long_string(toSeq(s))
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


proc read_file_data_into_buffer*(path: string): seq[ptr seq[byte]] =
  var i = 0
  var size = get_file_size(path)
  var b = read_file_data(path)
  var curr_buffer: seq[byte]
  var curr_byte: seq[char]
  while i < size:
    curr_byte.add(b[i])
    if i mod 2 == 0:
      curr_buffer.add(curr_byte)
      curr_byte.setLen(0)
    inc(i)
  return curr_buffer


# Read all files from directory into memory
proc read_all_files_into_buffer*(path: string): void =
  var i = 0
  var full_path = parentDir(cast[Path](path))
  for kind in walkDirRec(full_path):
    var p = fmt"{kind}"
    var size = get_file_size(p)
    var b = read_file_data(p)
    var curr_buffer: seq[byte]
    while i < size:
      curr_buffer.add(b[i])
      if i mod block_size == 0 and i >= block_size:
        full_walk_buffer.add(addr curr_buffer)
        curr_buffer.setLen(0)
      i += 1

# Hash all files
# Print file name + hash

proc shutdown*(): void =
  # Empty out buffers
  full_walk_buffer.setLen(0)

proc init*(): void =
  echo("")
