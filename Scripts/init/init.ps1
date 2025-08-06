# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

$python3_modules = @("requests", "pathlib3x")

# Set this to prevent some of the extra info on screen
$global:ProgressPreference = "SilentlyContinue"

# Platform specific variables
if ($os -eq "win") {
	$platform = "windows"
	$arch = "x86_64"
} elseif ($os -eq "linux") {
	$platform = $os
	$arch = "x86_64"
} elseif ($os -eq "macosx") {
	$platform = "darwin"
	$arch = "universal2"
}

$python3_url = 'https://github.com/bjia56/portable-python/releases/download/cpython-v' + $python3_version + '-build.2/python-headless-' + $python3_version + '-' + $platform + '-' + $arch + '.zip'
$python3_zip = $(Split-Path -Path $python3_url -Leaf)

Write-Output "Checking Required Tools"
Start-Sleep $sleep

$tools_dir = $tools_dir + $path_delimiter + $os

# Only create directory if tools are being downloaded on initial run
if (!(Test-Path -Path $tools_dir -PathType Container)) {
	New-Item -Path . -Name $tools_dir -ItemType Directory | Out-Null
}

# Quick and dirty hack to solve a pathing issue when moving this to external script
$output = Get-Item -Path $tools_dir | % { $_.FullName }

$tmp = $output + $path_delimiter + "python3"
if (!(Test-Path -Path $tmp -PathType Container)) {
	$download_python3 = 1
}

$python3_dir = $output + $path_delimiter + "python3"

Function Download_Python3 {
	$tmp = $output + $path_delimiter + $python3_zip
	Write-Output "Downloading Python3"
	Invoke-WebRequest -Uri $python3_url -OutFile $tmp
	Write-Output "Preparing Python3"
	Expand-Archive -Path $tmp -DestinationPath $output
	$extracted = $output + $path_delimiter + "python-headless-" + $python3_version + '-' + $platform + '-' + $arch
	Move-Item -Path $extracted -Destination $python3_dir
	Remove-Item -Path $tmp
}

# Add portable python to internal path so that it and its modules can be used without polluting system python
Function Activate_Python3 {
	Write-Output "Activating Python3 Interpretor"
	$env:PATH = $python3_dir + $path_delimiter + "Scripts" + ";" + $python3_dir + $path_delimiter + "bin" + ";" + $env:PATH
}

Function Install_Init_Python3_Modules {
	Write-Output "Downloading Required Python3 Modules."
	Write-Output "Please wait. This should only run once."
	foreach ($mod in $python3_modules) {
		python -m pip install $mod -qqq | Out-Null
	}
}

Function Run_Python3_Init {
	Write-Output "Running Extraction Script"
	$init = $cwd + $path_delimiter + $scripts_dir + $path_delimiter + "init" + $path_delimiter + "init.py"
	& python $init $os $tools_dir
}

if ($download_python3 -eq '1') {
	Download_Python3
}

Activate_Python3

if ($download_python3 -eq '1') {
	Install_Init_Python3_Modules
}

Run_Python3_Init
