# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

$requests_version = "2.32.4"
$py7zr_version = "1.0.0"

$python3_version = "3.11.13"
$python3_modules = @("pip", "setuptools", "requests==$requests_version", "git+https://github.com/bitranox/pathlib3x.git", "py7zr==$py7zr_version")
$download_python3 = 0
$extract_from_cache = 0

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

Write-Output "Checking Required Tools"
Start-Sleep $sleep

$tools_dir = $tools_dir + $path_delimiter + $os
$deps_dir = $cwd + $path_delimiter + $cache_dir + $path_delimiter + "deps"
$db_dir = $cwd + $path_delimiter + $db_dir

$python3_url = 'https://github.com/bjia56/portable-python/releases/download/cpython-v' + $python3_version + '-build.2/python-headless-' + $python3_version + '-' + $platform + '-' + $arch + '.zip'
$python3_zip = $(Split-Path -Path $python3_url -Leaf)
$python3_deps_cache = $deps_dir + $path_delimiter + "python3"

# Only create directory if tools are being downloaded on initial run
if (!(Test-Path -Path $tools_dir -PathType Container)) {
	New-Item -Path . -Name $tools_dir -ItemType Directory | Out-Null
}

# Create the cache directory if it doesn't exist yet
if (!(Test-Path -Path $deps_dir -PathType Container)) {
	New-Item -Path $deps_dir -ItemType Directory -Force | Out-Null
}

# Create the db directory if it doesn't exist yet
if (!(Test-Path -Path $db_dir -PathType Container)) {
	New-Item -Path $db_dir -ItemType Directory -Force | Out-Null
}

# Quick and dirty hack to solve a pathing issue when moving this to external script
$output = Get-Item -Path $tools_dir | % { $_.FullName }

$python3_output = $output + $path_delimiter + "python3"
if (!(Test-Path -Path $python3_output -PathType Container)) {
	if ($os -eq "win") {
		Write-Output "Windows Only Warning:"
		Write-Output "If you haven't enabled long directory names in the Windows Registry yet,"
		Write-Output "	please do it before continuing. This script will most likely hit the 260 character"
		Write-Output "	limit, so expect errors without it enabled. Thanks for understanding"
		Start-Sleep $sleep
		Start-Sleep $sleep
	}
}

$python3_cache = $deps_dir + $path_delimiter + $python3_zip
if (!(Test-Path -Path $python3_cache) -and !(Test-Path -Path $python3_output)) {
  $download_python3 = 1
}

if (($download_python3 -eq 0)) {
  if (!(Test-Path -Path $python3_output)) {
    $extract_from_cache = 1
  }
}

$python3_dir = $output + $path_delimiter + "python3"

Function Download_Python3 {
	$tmp = $output + $path_delimiter + $python3_zip
  if ($download_python3 -eq 1) {
    Write-Output "Downloading Python3"
    Invoke-WebRequest -Uri $python3_url -OutFile $tmp
    Write-Output "Preparing Python3"
    Expand-Archive -Path $tmp -DestinationPath $output
    $extracted = $output + $path_delimiter + "python-headless-" + $python3_version + '-' + $platform + '-' + $arch
    Move-Item -Path $extracted -Destination $python3_dir
    Move-Item -Path $tmp -Destination $deps_dir
  } elseif ($extract_from_cache -eq 1) {
    Write-Output "Preparing Python3"
    Expand-Archive -Path $python3_cache -DestinationPath $output
    $extracted = $output + $path_delimiter + "python-headless-" + $python3_version + '-' + $platform + '-' + $arch
    Move-Item -Path $extracted -Destination $python3_dir
  }
}

# Add portable python to internal path so that it and its modules can be used without polluting system python
Function Activate_Python3 {
	Write-Output "Activating Python3 Interpretor"
	$env:PATH = $python3_dir + $path_delimiter + "Scripts" + ";" + $python3_dir + $path_delimiter + "bin" + ";" + $env:PATH
}

Function Install_Init_Python3_Modules {
  if (($download_python3 -eq 1) -or ($extract_from_cache -eq 1)) {
    Write-Output "Downloading Required Python3 Modules."
    Write-Output "Please wait. This should only run once."
    $tmp = $output + $path_delimiter + $python3_zip
    foreach ($mod in $python3_modules) {
      python -m pip install --cache-dir $python3_deps_cache $mod -qqq | Out-Null
    }
  }
}

Function Run_Python3_Init {
	$init = $cwd + $path_delimiter + $scripts_dir + $path_delimiter + "init" + $path_delimiter + "stage1.py"
	& python $init $os $tools_dir $deps_dir
}

Download_Python3
Activate_Python3
Install_Init_Python3_Modules

Run_Python3_Init
