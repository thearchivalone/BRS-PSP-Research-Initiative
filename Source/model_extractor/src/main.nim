# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

import std/[os, strformat, strutils, sequtils, streams]

# Variables
var dump_data: seq[string]
var file_name: string
var file_output: string

# Helper function for error handling
proc check(e: bool) =
  if not e:
    raise newException(IOError, "File could not be read")

when declared(commandLineParams):
  file_name = paramStr(1)
  file_output = paramStr(2)

var fs = newFileStream(file_name, fmRead)

proc get_magic_number_string(content: string, pos: int, l: int): string =
  var buffer = newStringOfCap(l - 2)
  var i = 0
  while i < l:
    buffer.add(content[i + pos])
    inc(i)
  return buffer

proc trim_byte_string(s: string): string =
  var p = 0
  var o = newString(2)
  for i in s:
    # This covers 0s showing at end of binary string
    if p == 0:
      if i != '0':
        o.add(i)
        p = 1
    else:
      o.add(i)
  return o

proc reverse[T](a: seq[T]): string =
  var i = len(a) - 1
  # Setting this at the lowest value needed forces the string to only expand its length if absolutely needed
  var tmp = newString(0)
  while i > -1:
    if i == 0 and len(tmp) == 0:
      tmp.add("00")
    else:
      tmp.add(toHex(fmt"{a[i]}"))
    dec(i)
  return tmp

proc get_byte_string(content: string, pos: int, l: int): string =
  var buffer = newString(0)
  var i = 0
  while i < l:
    buffer.add(content[i + pos])
    inc(i)
  return reverse(toSeq(buffer))

proc dump_model_data(content: string, pos: int, end_pos: int, offset: int,
    delimiter: string) =
  var cur_pos = pos
  var count = 0
  var f = open(file_output, fmWrite)
  while cur_pos <= end_pos:
    var line = get_byte_string(content, cur_pos, 4)
    if line == delimiter:
      dump_data.add(fmt"--------")
      inc(count)
    else:
      dump_data.add(line)
    cur_pos += 4
  for x in dump_data:
    f.writeLine(x)
  defer: f.close()

proc jump_to_vertex_data(content: string) =
  var jump_1_addr = 0x24
  var jump_1 = newString(0)
  var killswitch = "3F800000"
  jump_1.add(get_byte_string(content, jump_1_addr, 4))

  if parseHexInt(jump_1) != parseHexInt(killswitch): # Killswitch Value
    var jump_2_addr = parseHexInt(jump_1) - 4
    var jump_2 = get_byte_string(content, jump_2_addr, 4)

    var jump_3_addr = parseHexInt(jump_2) + 4
    var jump_3 = get_byte_string(content, jump_3_addr, 4)

    # Has a 32-bit header a single 4-byte stop at the beginning
    var jump_4_addr = parseHexInt(jump_3) + 4 + 32
    dump_model_data(content, jump_4_addr, jump_2_addr, 0x18, killswitch)

proc read_binary_data(content: string) =
  # Read Magic Number header
  var magic_number = newStringOfCap(2)
  magic_number.add(get_magic_number_string(content, 0, 4))
  if magic_number == "INSM":
    jump_to_vertex_data(content)

proc main() =
  if not isNil(fs):
    var content = fs.readAll()
    read_binary_data(content)
  fs.close()

main()
