# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

import std/streams
import std/paths
import std/strformat
import std/dirs
import std/strutils
import std/asyncfile

var full_walk_buffer:seq[ptr seq[char]]
# 256KB to help with optimizing reading and memory management
var block_size = 4096 * 64 # Read game data in decently large chunks to speed up extraction

proc get_file_size(p:string): int64 =
  var f = openAsync(p, fmRead)
  var size = f.getFileSize()
  f.close()
  return size

proc read_file_data(p:string): string =
    var fs = openFileStream(p)
    var s:string = fs.readAll()
    fs.close()
    return s

# Read all files from directory into memory
proc read_all_files_into_buffer*(path:string): void =
  var i = 0
  var full_path = parentDir(cast[Path](path))
  for kind in walkDirRec(full_path):
    echo(fmt"Reading {extractFilename(kind)}")
    var p = fmt"{kind}"
    var size = get_file_size(p)
    var b = read_file_data(p)
    var curr_buffer:seq[char]
    while i < size:
      curr_buffer.add(b[i])
      if i mod block_size == 0 and i >= block_size:
        full_walk_buffer.add(addr curr_buffer)
        curr_buffer.setLen(0)
      i += 1
  echo(len(full_walk_buffer))

# Hash all files
# Print file name + hash
