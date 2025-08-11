# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

import std/[os, strformat, strutils, sequtils]

# Variables
var file_name:string

# Helper function for error handling
proc check(e: bool) =
  if not e:
    raise newException(IOError, "File could not be read")

when declared(commandLineParams):
  file_name = paramStr(1)

proc reverse[T](a:seq[T]): seq[T]=
  var i = len(a) - 1
  var tmp: seq[T]
  while i > -1:
    tmp.add(a[i])
    dec(i)
  return tmp

proc to_string[T](a:seq[T]): string =
  var str = newStringOfCap(len(a))
  for tmp in a:
    add(str, alignString(fmt"{tmp}", 2, '\x00', '0'))
  return str

proc get_script_string(f:File, a:int, length:int): string =
  var s = newString(length)
  f.setFilePos(a)
  let b1 = f.readChars(s)
  return s

proc get_byte_string(f:File, a:int): string =
  var buffer: array[4, byte]
  # Grab byte value (always in 4-byte chunks)
  f.setFilePos(a)
  let b1 = f.readBytes(buffer, 0, 4)
  let r1 = reverse(toSeq(buffer))
  return to_string(r1)

proc read_all_strings(f:File, start_pos:int, payload_pos:int, end_pos:int): seq[string] =
  var init_offset = 0x40
  var size = end_pos - start_pos
  var lines = toInt(size / 4)
  var i = 0
  var pos = start_pos
  var scripts: seq[string]
  var final_scripts: seq[string]

  scripts = get_script_string(f, start_pos, size).split({'\x00'})
  for s in scripts:
    if s.len >= 4:
      add(final_scripts, s)
  for s in final_scripts:
    echo s

proc read_binary_data(f:File) =
  # Read Magic Number header
  var magic_number = newString(4)
  var script_start = newString(4)
  var script_payload_start = newString(4)
  var script_end = newString(4)
  var script_start_addr = 0x2c
  var script_payload_addr = 0x34
  var script_end_addr = 0x3c
  var scripts: seq[string]
  let bytes = f.readChars(magic_number)
  if magic_number == "bscr":
    # Grab where the script data begins and ends
    script_end = get_byte_string(f, script_end_addr)

    # Grab where the script payload starts
    script_payload_start = get_byte_string(f, script_payload_addr)

    # Grab where the script data starts
    script_start = get_byte_string(f, script_start_addr)

    f.setFilePos(parseInt(script_start) + 4)

    # Start reading the script data
    add(scripts, read_all_strings(f, parseInt(script_start), parseInt(script_payload_start), parseInt(script_end)))
  
proc main() =
  # Read bms script into memory in its entirety
  var f = open(file_name)
  defer: f.close()
  read_binary_data(f)

main()
