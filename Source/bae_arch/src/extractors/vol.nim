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
import std/paths
import std/base64

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
  var local_data: seq[byte]
  magic_number = "RTDP"
  local_data = read_header_data(path, start, len)
  header_end = read_long_string(
    local_data,
    0x04,
    4
  )
  file_count = read_long_string(
    local_data,
    0x08,
    4
  )
  file_size = read_long_string(
    local_data,
    0x0c,
    4
  )
  xorkey = read_long_string(local_data, 0x10, 1)
  # Start working through file name list in header
  var list_init = 0x20
  var cur_pos = list_init
  var string_len = 0x20  # 32-byte strings here
  for _ in 0..<file_count:
    files_list.add(
      read_char_string(
        local_data,
        cur_pos,
        string_len
      )
    )
    inc(cur_pos, string_len)
    sizes_list.add(
      read_long_string(
        local_data,
        cur_pos,
        0x04
      )
    )
    inc(cur_pos, 0x04)
    offsets_list.add(
      read_long_string(
        local_data,
        cur_pos,
        0x04
      )
    )
    inc(cur_pos, 0x04)
  encrypted_section = file_size
  dec(encrypted_section, header_end)
  # Read the encrypted data headers only
  # flush local_data and reuse it
  # Expect possible bugs here
  local_data.setLen(0)
  for i in 0..<file_count:
    var offset = offsets_list[i]
    # Reset cur_pos to 0 and then get the offset from the header
    dec(cur_pos, cur_pos)
    inc(cur_pos, header_end + offset)
    local_data.add(read_header_data(path, cur_pos, header_len))
    data.add(local_data)
    local_data.setLen(0)
  # Extract the encrypted data backwards to keep it in proper order
  var init = len(data) - 1
  for j in 0..<len(data):
    var cur = init - j
    var d = data[cur]
    for i in 0..<len(d):
      local_data.add(
        cast[byte](
          cast[int](d[i]) xor xorkey
        )
      )
    data.delete(cur)
    data.add(local_data)
    local_data.setLen(0)
  # Populate json blob with extracted data in order so it can be passed around
  # Then flush data so it doesn't hang around in memory
  dec(init, init)
  inc(init, len(data) - 1)
  for j in 0..<len(data):
    var cur = init - j
    var d = data[cur]
    # base64 encode this since it's so small, then decode when needed
    var encoded = encode(d)
    var name = files_list[j].split('\x00')[4] # hack to remove leading whitespaces left from original read
    var ext = name.split('.')[1]
    file_path = fmt"{extractFilename(cast[Path](path))}"
    file_types = populate_types_by_ext(ext)
    var size = sizes_list[j]
    var local_json = %*{
      "file name": name,
      "file size": size,
      "file archive": file_path,
      "file extension": ext,
      "file types": file_types,
      "file header": encoded
    }
    ext_json.add(local_json)
  data.setLen(0)
  echo ext_json.pretty()
