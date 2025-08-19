# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

## \
##    file_name: vol.nim
##    purpose: Extract RTDP volume archives
##
##

import std/json
import std/strformat
import std/strutils
import std/sequtils

import shared
import ../tools/memory

type VOL = ref object of Extractor

var xorkey: int
var encrypted_section: int
var decrypted_data: string

proc extract_data*(path: string): void =
  magic_number = "RTDP"
  var data = read_file_data(path)
  header_end = read_long_string(
    data,
    0x04,
    4
  )
  echo(fmt"Header ends here: {header_end}")
#  file_count = read_long_string(
#    data,
#    0x08,
#    4
#  )
#  size = read_long_string(
#    data,
#    0x0c,
#    4
#  )
#  xorkey = read_long_string(data, 0x10, 1)
#  # Start working through file name list in header
#  var list_init = 0x20
#  var cur_pos = list_init
#  var string_len = 0x20 # 32-byte strings here
#  for _ in 0..<file_count:
#    files_list.add(
#      read_char_string(
#        data,
#        cur_pos,
#        string_len
#      )
#    )
#    inc(cur_pos, string_len)
#    sizes_list.add(
#      read_long_string(
#        data,
#        cur_pos,
#        0x04
#      )
#    )
#    inc(cur_pos, 0x04)
#    offsets_list.add(
#      read_long_string(
#        data,
#        cur_pos,
#        0x04
#      )
#    )
#    inc(cur_pos, 0x04)
#  encrypted_section = size
#  dec(encrypted_section, header_end)
#  # Start decrypting the encrypted data
#  # Expect possible bugs here
#  var s = cast[seq[string]](data)
#  for i in s:
#    decrypted_data.add(
#      toHex(
#        parseHexInt(
#          i
#        ) xor xorkey
#      )
#    )
