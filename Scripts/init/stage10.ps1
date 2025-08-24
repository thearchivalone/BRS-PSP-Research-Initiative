# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

Function Run_Python3_Stage10() {
	$tmp = $init_scripts_dir + $path_delimiter + "stage10.py"
	& python $tmp $os $tools_dir $deps_dir
}

Run_Python3_Stage10

Function Activate_Llvm() {
  $clang_version = "18"
  $wrapper = "clang-target-wrapper"
	Write-Output "Activating LLVM Toolchain"
  $llvm_dir = $cwd + $path_delimiter + $tools_dir + $path_delimiter + $os + $path_delimiter + "llvm"
  $libclang_dir = $cwd + $path_delimiter + $tools_dir + $path_delimiter + $os + $path_delimiter + "libclang"
	$env:PATH = $llvm_dir + $path_delimiter + "bin" + ";" + $env:PATH
  $env:COMPILER_PATH = $llvm_dir + $path_delimiter + "bin" 
  $env:INCLUDE = $libclang_dir + $path_delimiter + "include" + $path_delimiter + "clang-c" + ";" + $llvm_dir + $path_delimiter + "lib" + $path_delimiter + "clang" + $path_delimiter + $clang_version + $path_delimiter + "include" + ";" + $llvm_dir + $path_delimiter + "include" + ";" + $env:INCLUDE
  $env:LIB = $llvm_dir + $path_delimiter + "lib" + $path_delimiter + "clang" + $path_delimiter + $clang_version + $path_delimiter + "lib" + ";" + $llvm_dir + $path_delimiter + "bin" + ";" + $libclang_dir + $path_delimiter + "bin" + ";" + $llvm_dir + $path_delimiter + "lib" + ";" + $llvm_dir  + $env:LIB
  $env:LIBRARY_PATH = $env:LIB

  # Run target wrapper based on platform
  if ($os -eq "win") {
    $wrapper = $wrapper + $exe
  } else {
    $wrapper = $wrapper + ".sh"
  }
  $env:CC = $wrapper
}

Activate_Llvm

Function Activate_Zig() {
	Write-Output "Activating Zig Compiler"
  $extra = ""
  if ($os -eq "win") {
    $extra = "C:\Windows\System32;"
  }
	$env:PATH = $cwd + $path_delimiter + $tools_dir + $path_delimiter + $os + $path_delimiter + "zig" + ";" + $extra + $env:PATH
}

Activate_Zig
