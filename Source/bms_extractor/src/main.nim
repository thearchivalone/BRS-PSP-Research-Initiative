# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

import std/[os, strformat, strutils, sequtils]

# Variables
var file_name: string
var file_output: string

# Helper function for error handling
proc check(e: bool) =
  if not e:
    raise newException(IOError, "File could not be read")

when declared(commandLineParams):
  file_name = paramStr(1)
  file_output = paramStr(2)

proc reverse[T](a: seq[T]): string =
  var i = len(a) - 1
  # Setting this at the lowest value needed forces the string to only expand its length if absolutely needed
  var tmp = newStringOfCap(2)
  while i > -1:
    let b = parseInt(fmt"{a[i]}")
    if b != 0:
      tmp.add(toHex(a[i]))
    if b == 0 and i == 0 and len(tmp) == 0:
      tmp.add("00")
    dec(i)
  return tmp

proc get_script_string(f: File, pos: int, l: int): string =
  var s = newString(l)
  var o = newStringOfCap(2)
  var j = 0
  f.setFilePos(pos)
  let b1 = f.readChars(s)
  for i in s:
    if i != '\x00':
      o.add(i)
      inc(j)
    else:
      f.setFilePos(pos + j + 1)
      break
  return o

proc get_byte_string(f: File, pos: int, l: int): string =
  var buffer: array[4, byte]
  # Grab byte value (always in 4-byte chunks)
  f.setFilePos(pos)
  let b1 = f.readBytes(buffer, 0, l)
  let r1 = reverse(toSeq(buffer))
  return r1

# Parse each individual structure
proc read_script_data_structure(f: File, start_pos: int, end_pos: int): string =
  var offset_addr = 0x00
  var offset = newStringOfCap(2)
  var unk_addr = 0x02
  var unk = newStringOfCap(2)
  var function_addr = 0x04
  var function = newStringOfCap(4)

  # Not sure what these are for yet
  var prim_addr = 0x2c
  var prim = newStringOfCap(2)
  var sec_addr = 0x24
  var sec = newStringOfCap(2)
  # This is where the values are set
  var data_addr = 0x28
  var data = newStringOfCap(2)

  offset = get_byte_string(f, start_pos + offset_addr, 2)
  unk = get_byte_string(f, start_pos + unk_addr, 2)
  function = get_script_string(f, start_pos + function_addr, 28)
  prim = get_byte_string(f, start_pos + prim_addr, 4)
  sec = get_byte_string(f, start_pos + sec_addr, 4)
  data = get_byte_string(f, start_pos + data_addr, 4)

  var output = newStringOfCap(4)
  output.add(function)
  output.add(" : ")
  output.add(data)
  f.setFilePos(start_pos + parseHexInt(offset))
  return output

proc read_all_strings(f: File, start_pos: int, payload_pos: int,
    end_pos: int): seq[string] =
  var init_offset = 0x40
  var size = end_pos - payload_pos
  var scripts: seq[string]
  var final_scripts: seq[string]
  var i = 0

  # Use this for writing scripts to files
  let w = open(file_output, fmWrite)
  defer: w.close()

  while i < 1000:
    if i == 0:
      scripts.add(
        read_script_data_structure(
          f,
          start_pos,
          end_pos)
      )
    else:
      scripts.add(
        read_script_data_structure(
        f,
        f.getFilePos(),
        end_pos
        )
      )
    if f.getFilePos() >= payload_pos:
      break
    inc(i)

  for s in scripts:
    w.writeLine(s)

  # Grab payload in its entirety
  var payload = newString(size)
  discard f.readChars(payload)
  final_scripts = payload.split({'\x00', '\x5A'})
  for s in final_scripts:
    w.writeLine(s)

proc read_binary_data(f: File) =
  # Read Magic Number header
  var magic_number = newString(4)
  var script_start = newString(2)
  var script_payload_start = newString(2)
  var script_end = newString(2)
  var script_start_addr = 0x2c
  var script_payload_addr = 0x34
  var script_end_addr = 0x3c
  var scripts: seq[string]
  let bytes = f.readChars(magic_number)
  if magic_number == "bscr":
    # Grab where the script data begins and ends
    script_end = get_byte_string(f, script_end_addr, 2)

    # Grab where the script payload starts
    script_payload_start = get_byte_string(f, script_payload_addr, 2)

    # Grab where the script data starts
    script_start = get_byte_string(f, script_start_addr, 2)

    f.setFilePos(parseHexInt(script_start) + 4)

    # Start reading the script data
    add(scripts,
      read_all_strings(
          f,
          parseHexInt(script_start),
          parseHexInt(script_payload_start),
          parseHexInt(script_end)
      )
    )

proc main() =
  # Read bms script into memory in its entirety
  var f = open(file_name)
  defer: f.close()
  read_binary_data(f)

main()
