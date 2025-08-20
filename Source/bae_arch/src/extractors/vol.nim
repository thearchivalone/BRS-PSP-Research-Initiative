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

var 
  xorkey: int
  encrypted_section: int
  files_list: seq[string]
  offsets_list: seq[int]
  sizes_list: seq[int]

proc print_extracted(key: string, value: string): void =
  echo fmt"{key}: {value}"

proc extract_data*(path: string, start: int, len: int): void =
  magic_number = "RTDP"
  data = read_header_data(path, start, len)
  header_end = read_long_string(
    data,
    0x04,
    4
  )
  file_count = read_long_string(
    data,
    0x08,
    4
  )
  file_size = read_long_string(
    data,
    0x0c,
    4
  )
  xorkey = read_long_string(data, 0x10, 1)
  # Start working through file name list in header
  var list_init = 0x20
  var cur_pos = list_init
  var string_len = 0x20  # 32-byte strings here
  for _ in 0..<file_count:
    files_list.add(
      read_char_string(
        data,
        cur_pos,
        string_len
      )
    )
    inc(cur_pos, string_len)
    sizes_list.add(
      read_long_string(
        data,
        cur_pos,
        0x04
      )
    )
    inc(cur_pos, 0x04)
    offsets_list.add(
      read_long_string(
        data,
        cur_pos,
        0x04
      )
    )
    inc(cur_pos, 0x04)
  var j = 0
#  For testing purposes; don't remove in case of weirdness
#  while j < file_count:
#    print_extracted("File name", files_list[j])
#    print_extracted("File offset", fmt"{toHex(offsets_list[j])}")
#    print_extracted("File size", fmt"{sizes_list[j]}")
#    inc(j)
  encrypted_section = file_size
  dec(encrypted_section, header_end)
  # Start decrypting the encrypted data headers only
  # Also, flush and reuse the data buffer
  # Expect possible bugs here
  data.setLen(0)
