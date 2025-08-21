# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

import std/os
import std/paths
import std/strformat
import std/strutils
import std/json
import db_connector/db_sqlite

# custom code imports
import extractors/vol

# Variables
var cache_dir: string
var cache_type: string
var cache_action: string
var cache_file: string
var db_file: string
var db: DbConn

when declared(commandLineParams):
  cache_dir = paramStr(1)
  cache_type = paramStr(2)
  cache_action = paramStr(3)
  cache_file = paramStr(4)

proc check_table_exists(tbl: string) =
  db.exec(sql"""CREATE TABLE if not exists ?(
      id INTEGER NOT NULL PRIMARY KEY,
      value BLOB
    )""",
    tbl)

proc cache(tbl: string, id: int, value: string) =
  db.exec(sql"INSERT or IGNORE INTO ? (id, value) VALUES (?, ?)", tbl, id, value)

proc check_action() =
  let p = joinPath("", cache_file)
  var full_path = cast[Path](p)
  var tbl: string
  var id = 0
  var value: string
  var action: string
  var walk: bool

  case cache_action:
    of "test":
      extract_data(cache_file, 0, 1024)
    of "files":
      tbl = "files"
      walk = true
      action = "cache"

  case action:
    of "cache":
      if walk:
        # variables
        var region: string
        var archive: string
        var file: string
        var parent: string
        var chash: int
        var file_json = %* []
        var region_json = %* []
        var json = %* []

        # Get parentdir so we can walk it
        var k = parentDir(full_path)

        check_table_exists(tbl)
        for path in walkDirRec(fmt"{k}"):
          # Split path so json has more structure
          var s = split(path, {'\\', '/'})
          var i = 0

          for path in s:
            case path:
              of "eur":
                region = path
              of "usa":
                region = path
              of "jpn":
                region = path
              of "BTL":
                archive = path
              of "FLD":
                archive = path
              of "GALLERY":
                archive = path
              of "IF":
                archive = path
              of "MINI_GAME":
                archive = path
              of "SOUND":
                archive = path
              of "MC.VOL":
                archive = path
              of "SYSTEM.VOL":
                archive = path
              of "TITLE.VOL":
                archive = path

          file = extractFilename(path)
          chash = hash(cast[Path](path))
          parent = fmt"{lastPathPart(parentDir(cast[Path](path)))}"
          region_json = %* {"archive": archive, "region": region,
              "parent": parent, "file": file, "hash": toHex(chash)}
          json.add(region_json)
        var p_json = pretty(json)
        cache(tbl, id, p_json)

proc check_db() =
  # Set this up to solve some errors if dir doesn't exist
  let p = joinPath("", cache_dir)
  discard existsOrCreateDir(p)
  db_file = joinPath(p, "research.db")
  db = open(db_file, "", "", "")

proc main() =
  check_db()
  check_action()
  db.close()

main()
