# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

$quickbms_url = 'https://github.com/LittleBigBug/QuickBMS/releases/download/' + $quickbms_version + '/quickbms_' + $os + '.zip'
$quickbms_zip = $(Split-Path -Path $quickbms_url -Leaf)

if (($os -eq 'win') -Or ($os -eq 'linux')) {
	$arch = 'x86_64'
	if ($os -eq 'win') {
		$platform = 'windows'
	} else {
		$platform = $os
	}
} elseif ($os -eq 'macosx') {
	$arch = 'universal'
	$platform = 'darwin'
}

$python3_url = 'https://github.com/bjia56/portable-python/releases/download/cpython-v' + $python3_version + '-build.2/python-headless-' + $python3_version + '-' + $platform + '-' + $arch + '.zip'
$python3_zip = $(Split-Path -Path $python3_url -Leaf)

if ($os -eq 'win') {
	$platform = 'windows'
} else {
	$platform = $os
}

$choosenim_url = 'https://github.com/nim-lang/choosenim/releases/download/v' + $choosenim_version + '/choosenim-' + $choosenim_version + '_' + $platform + '_amd64' + $exe
$choosenim_zip = $(Split-Path -Path $choosenim_url -Leaf)

Write-Output "Checking Required Tools"
Start-Sleep $sleep

$tools_dir = $tools_dir + $path_delimiter + $os

$tmp = $tools_dir + $path_delimiter + "quickbms"
if (!(Test-Path -Path $tmp -PathType Container)) {
	$download_qbms = 1
} else {
	$quickbms_command = $tmp + $path_delimiter + "quickbms" + $exe
}

# Quick and dirty hack to solve a pathing issue when moving this to external script
$output = $cwd + $path_delimiter + $output

Function Download_Quickbms {
	$tmp = $output + $path_delimiter + $quickbms_zip
	$dir = $output + $path_delimiter + "quickbms"
	Write-Output "Downloading QuickBMS"
	Invoke-WebRequest -Uri $quickbms_url -OutFile $tmp
	Write-Output "Preparing QuickBMS"
	Expand-Archive -Path $tmp -DestinationPath $dir
	$quickbms_command = $dir + $path_delimiter + "quickbms" + $exe
	Remove-Item -Path $tmp
}

$tmp = $tools_dir + $path_delimiter + "python3"
if (!(Test-Path -Path $tmp -PathType Container)) {
	$download_python3 = 1
} else {
	$python3_command = $tmp + $path_delimiter + "python3" + $exe
}

Function Download_Python3 {
	$tmp = $output + $path_delimiter + $python3_zip
	$dir = $output + $path_delimiter + "python3"
	& Write-Output "Downloading Python $python3_version"
	Invoke-WebRequest -Uri $python3_url -OutFile $tmp
	Write-Output "Preparing Python3"
	Expand-Archive -Path $tmp -DestinationPath $output
	$extracted = $output + $path_delimiter + "python-headless-" + $python3_version + '-' + $platform + '-' + $arch
	Move-Item -Path $extracted -Destination $dir
	$python3_command = $dir + $path_delimiter + "bin" + $path_delimiter + "python" + $exe
	Remove-Item -Path $tmp
}

$tmp = $tools_dir + $path_delimiter + "nim"
if (!(Test-Path -Path $tmp -PathType Container)) {
	$download_nim = 1
} else {
	$nim_new_command = $tmp + $path_delimiter + $nim_new_version + $path_delimiter + "bin" + $path_delimiter + "nim" + $exe
	$nimble_new_command = $tmp + $path_delimiter + $nim_new_version + $path_delimiter + "bin" + $path_delimiter + "nimble" + $exe
	$nim_old_command = $tmp + $path_delimiter + $nim_old_version + $path_delimiter + "bin" + $path_delimiter + "nim" + $exe
	$nimble_old_command = $tmp + $path_delimiter + $nim_old_version + $path_delimiter + "bin" + $path_delimiter + "nimble" + $exe
}

Function Download_Nim {
	$tmp = $output + $path_delimiter + $choosenim_zip
	$dir = $output + $path_delimiter + "nim"
	Write-Output "Downloading Nim Bootstrapper"
	Invoke-WebRequest -Uri $choosenim_url -OutFile $tmp
	$choosenim_new = $dir + $path_delimiter + "choosenim" + $exe
	New-Item -Path $dir -ItemType Directory | Out-Null
	Move-Item -Path $tmp -Destination $choosenim_new
	$choosenim_command = $choosenim_new

	# Two versions of nim are for plugin support more than anything else
	$new_dir = $dir + $path_delimiter + $nim_new_version
	$old_dir = $dir + $path_delimiter + $nim_old_version
	& Write-Output "Downloading Nim $nim_new_version"
	& $choosenim_command $nim_new_version --nimbleDir=$new_dir | Out-Null
	$nim_new_command = $new_dir + $path_delimiter + "bin" + $path_delimiter + "nim" + $exe
	$nimble_new_command = $new_dir + $path_delimiter + "bin" + $path_delimiter + "nimble" + $exe
	& Write-Output "Downloading Nim $nim_old_version"
	& $choosenim_command $nim_old_version --nimbleDir=$old_dir | Out-Null
	$nim_old_command = $old_dir + $path_delimiter + "bin" + $path_delimiter + "nim" + $exe
	$nimble_old_command = $old_dir + $path_delimiter + "bin" + $path_delimiter + "nimble" + $exe
}

if (($download_qbms -eq '1') -Or ($download_python3 -eq '1') -Or ($download_nim -eq '1')) {
	$input = Read-Host 'Can I download missing tools? (y/N)'

	# Only create directory if tools are being downloaded on initial run
	if (!(Test-Path -Path $tools_dir -PathType Container)) {
		New-Item -Path . -Name $tools_dir -ItemType Directory | Out-Null
	}

	if ($input -eq 'y') {
		Write-Output "Preparing Tools"
		$output = Get-Item -Path $tools_dir | % { $_.FullName }
		if ($download_qbms -eq '1') {
			Download_Quickbms
		}
		if ($download_python3 -eq '1') {
			Download_Python3
		}
		if ($download_nim -eq '1') {
			Download_Nim
		}
	}
	else {
		Write-Output "Please download and place tools inside of the Tools directory; then run this script again"
		exit
	}
}

