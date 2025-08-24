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

requires "naylib >= 25.33.0"

requires "puppy >= 2.1.2"

requires "zigcc >= 3.0.0"
