# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

Function Run_Python3_Stage2() {
	Write-Output "Running Stage2 Script"
	$tmp = $init_scripts_dir + $path_delimiter + "stage2.py"
	& python $tmp $os $tools_dir
}

Run_Python3_Stage2

Function Activate_Nim() {
	Write-Output "Activating Nim Toolchain"
	$env:PATH = $cwd + $path_delimiter + $tools_dir + $path_delimiter + $os + $path_delimiter + "nim" + $path_delimiter + "custom" + ";" + $env:PATH
}

Activate_Nim
