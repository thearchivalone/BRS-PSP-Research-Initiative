# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

Function Cleanup_Nim() {
  $nim_src_dir = $deps_dir + $path_delimiter + "nim"
  if (Test-Path -Path $nim_src_dir) {
      Write-Output "Cleaning up Nim source code. Please wait"
      & Start-Sleep $sleep
      & Remove-Item -Path $nim_src_dir -Force -Recurse
    }
}

Cleanup_Nim

Function Activate_Nim() {
	Write-Output "Activating Nim Toolchain"
  $nim_path = $cwd + $path_delimiter + $tools_dir + $path_delimiter + $os + $path_delimiter + "nim"
	$env:PATH = $nim_path + $path_delimiter + "bin" + ";" + $env:PATH
  $env:PATH = $nim_path + $path_delimiter + "lib" + ";" + $env:PATH
}

Activate_Nim
