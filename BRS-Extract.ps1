# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

# General variables
$path_delimiter = ""
$exe = ""
$sleep = 3

# Prepare platform specific path stuff
$os = ""
if ($IsWindows) {
	$path_delimiter = "\"
	$os = "win"
}
else {
	$path_delimiter = "/"
	if ($IsLinux) {
		$os = "linux"
	} else {
		$os = "macosx"
	}
}

# Directory variables
$game_dir = "Game"
$docs_dir = "Docs"
$extraction_dir = "Extraction"
$scripts_dir = "Scripts"
$tools_dir = "Tools"
$source_dir = "Source"

# Populate initial scripts directories
$init_scripts_dir = $cwd + $path_delimiter + $scripts_dir + $path_delimiter + "init"

if ($os -eq "win") {
	$exe = ".exe"
}

Function Check_If_Stage_Kill($stage) {
	$item = $cwd + $path_delimiter + $tools_dir + $path_delimiter + $stage
	if (Test-Path -Path $item) {
		Start-Sleep $sleep
		Remove-Item $item
		exit
	}
}

# Run Stage1 - Bootstrap Nim
$tmp = $init_scripts_dir + $path_delimiter + "stage1.ps1"
& $tmp
Check_If_Stage_Kill("stage1")

# Run Stage2 - Build and Install Nimble + Nim Toolchain
$tmp = $init_scripts_dir + $path_delimiter + "stage2.ps1"
& $tmp
Check_If_Stage_Kill("stage2")

# Run Stage3 - Install QuickBMS
$tmp = $init_scripts_dir + $path_delimiter + "stage3.ps1"
& $tmp
Check_If_Stage_Kill("stage3")

# Run Stage4 - Check Game Files Exist
$tmp = $init_scripts_dir + $path_delimiter + "stage4.ps1"
& $tmp
Check_If_Stage_Kill("stage4")

# Run Stage5 - Run Extraction Scripts
$tmp = $init_scripts_dir + $path_delimiter + "stage5.ps1"
& $tmp
