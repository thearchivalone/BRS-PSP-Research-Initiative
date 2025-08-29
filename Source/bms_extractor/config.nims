# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

import std/[strformat]

var path_delimiter = ""
var exe = ""
if buildOS == "windows":
  path_delimiter = "\\"
  exe = ".exe"
else:
  path_delimiter = "/"

let opt = "speed"
let build = "release"
let cc = "clang"
let clang = "zigcc" & exe
let linker = "zigcc" & exe
let nim_cache = getEnv("NIMDEPS")

switch("opt", opt)
switch("define", build)
switch("cc", cc)
switch("clang.exe", clang)
switch("clang.linkerexe", linker)
switch("nimcache", nim_cache)
