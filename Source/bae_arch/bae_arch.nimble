# Package

version = "0.0.1"
author = "Brad D"
description = "BRS Archive Excavator - Archive Viewer Tool written in Nim"
license = "BSD-3-Clause"
srcDir = "src"
bin = @["main"]


# Dependencies

requires "nim >= 2.2.4"

requires "db_connector >= 0.1.0"

requires "https://github.com/floooh/sokol-nim.git"

requires "https://github.com/treeform/pixie.git"

requires "https://github.com/thearchivalone/nimclay.git"
