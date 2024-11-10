# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

$game_dir = "Game"
$tools_dir = "Tools"
$extraction_dir = "Extraction"
$assets_dir = "Assets"
$models_dir = $assets_dir + "\Models"
$audio_dir = $assets_dir + "\Audio"

$quickbms_url = 'https://aluigi.altervista.org/papers/quickbms.zip'
$quickbms_zip = $(Split-Path -Path $quickbms_url -Leaf)
$quickbms_command = $tools_dir + "\quickbms.exe"
$quickbms_command = Get-Item -Path $quickbms_command | % { $_.FullName }

$vgmstream_url = 'https://github.com/vgmstream/vgmstream/releases/download/r1951/vgmstream-win64.zip'
$vgmstream_zip = $(Split-Path -Path $vgmstream_url -Leaf)
$vgmstream_command = $tools_dir + "\vgmstream-cli.exe"
$vgmstream_command = Get-Item -Path $vgmstream_command | % { $_.FullName }

$extraction_script = "Scripts\BRS-Extract.bms"
$extraction_script = Get-Item -Path $extraction_script | % { $_.FullName }

$archive_types += @("vol", "bin", "zzz", "gz", "efp", "lpk")

$sleep = 2

Write-Output "Checking If Required Extraction Tools Are Available"

if (!(Test-Path -Path $tools_dir -PathType Container)) {
	New-Item -Path . -Name $tools_dir -ItemType Directory | Out-Null
}

Write-Output "Checking QuickBMS"

if ((Get-Command $quickbms_command -ErrorAction SilentlyContinue) -eq $null)
{
	$download_qbms = 1
}

Write-Output "Checking VgmStream"
if ((Get-Command $vgmstream_command -ErrorAction SilentlyContinue) -eq $null)
{
	$download_vgms = 1
}

if ($download_qbms -eq '1' -Or $download_vgms -eq '1') {
	$input = Read-Host 'Can I download the missing tools? (y/N)'

	if ($input -eq 'y') {
		Write-Output "Preparing Tools"
		$output = Get-Item -Path $tools_dir | % { $_.FullName }
		if ($download_qbms -eq '1') {
			Write-Output "Downloading QuickBMS"
			Invoke-WebRequest -Uri $quickbms_url -OutFile $output\$quickbms_zip
			Write-Output "Preparing QuickBMS"
			Expand-Archive -Path $output\$quickbms_zip -DestinationPath $output
			Remove-Item -Path $output\$quickbms_zip
		}
		if ($download_vgms -eq '1') {
			Write-Output "Downloading VgmStream"
			Invoke-WebRequest -Uri $vgmstream_url -OutFile $output\$vgmstream_zip
			Write-Output "Preparing VgmStream"
			Expand-Archive -Path $output\$vgmstream_zip -DestinationPath $output
			Remove-Item -Path $output\$vgmstream_zip
		}
	}
	else {
		Write-Output "Please download QuickBMS and VgmStream and place them inside of the Tools directory; then run this script again"
		exit
	}
}

Start-Sleep $sleep

Write-Output "Extracting and decrypting game archives. This process can take awhile"

foreach ($item in (Get-ChildItem -Path $game_dir -Force -Recurse | % { $_.FullName })) {
	$ext = (Split-Path -Path $item -Leaf).Split(".")[1]
	$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
	foreach ($arc in $archive_types) {
		if ($ext -eq $arc) {
			if (!($item -like '*ITM*ZZZ') -And !($dir -like '*INSDIR*') -And !$($dir -like '*SYSDIR*') -And !($item -like '*UMD*')) {
				& $quickbms_command -Y $extraction_script $item $dir
			}
		}
	}
	# Copy the sound folder over so they get converted 
	if (($item -like '*SOUND*') -And ($ext -eq 'at3')) {
		$sound_dir = $extraction_dir + "\PSP_GAME\USRDIR\GAMEDATA\SOUND"
		New-Item -Path $sound_dir -Force -ItemType Directory | Out-null
		Copy-Item -Path $item -Destination $sound_dir
	}
}

Start-Sleep $sleep

Write-Output "Recursively extracting archives"

Function Extract-Internals {
	(Get-ChildItem -Path . -Force -Recurse -File | % { $_.FullName } ) | ForEach-Object -Parallel {
		$file = Split-Path $_ -Leaf
		$dir = Split-Path $_ -Parent
		$extract = $file + '_extract'
		$ext = (Split-Path -Path $file -Leaf).Split(".")[1]
		foreach ($arc in $archive_types) {
			if (($ext -eq $arc)) {
				& $quickbms_command -Y $extraction_script $file $extract
				cd $extract
				Extract-Internals
			} else {
				break
			}
		}
	}
}

foreach ($item in (Get-ChildItem -Path $extraction_dir -Force -Recurse -File | % { $_.FullName } )) {
	$dir = Split-Path $item -Parent
	$file = Split-Path $item -Leaf
	$extract = $file + '_extract'
	$ext = (Split-Path -Path $file -Leaf).Split(".")[1]

	cd $dir
	foreach ($arc in $archive_types) {
		if (($ext -eq $arc)) {
			& $quickbms_command -Y $extraction_script $file $extract
			cd $extract
			Extract-Internals
		}
	}
	cd $cwd
}

Start-Sleep $sleep

Write-Output "Preparing asset extraction"

if (!(Test-Path -Path $audio_dir -PathType Container)) {
	New-Item -Path . -Name $audio_dir -ItemType Directory | Out-Null
}

$audio_dir = Get-Item -Path $audio_dir | % { $_.FullName }

if (!(Test-Path -Path $models_dir -PathType Container)) {
	New-Item -Path . -Name $models_dir -ItemType Directory | Out-Null
}

$models_dir = Get-Item -Path $models_dir | % { $_.FullName }

Start-Sleep $sleep

Write-Output "Extracting and converting assets"

foreach ($item in (Get-ChildItem -Path $extraction_dir -Force -Recurse -File | % { $_.FullName } )) {
	$dir = Split-Path $item -Parent
	$file = Split-Path $item -Leaf
	$extract = $file + '_extract'
	$ext = (Split-Path -Path $file -Leaf).Split(".")[1]

	# Generate a UID for assets so that all converted files can be placed in Audio directory if they have are named the same on disc
	$guid = New-Guid
	$audio = (Split-Path -Path $file -Leaf).Split(".")[0]
	$audio = $audio + '-' + $guid + '.wav'

	$model = (Split-Path -Path $file -Leaf).Split(".")[0]
	$model = $model + '-' + $guid + '.mdl'

	cd $dir
	if ($ext -eq "at3") {
		& $vgmstream_command $file -o $audio
		Move-Item -Path $audio -Destination $audio_dir
	} elseif (($ext -eq "mdl") -Or ($ext -eq "md")) {
		Copy-Item -Path $file -Destination $model
		Move-Item -Path $model -Destination $models_dir
	}
	cd $cwd
}

Start-Sleep $sleep

Write-Output "Removing empty folders"

Get-ChildItem -Path $extraction_dir -Force -Recurse -Directory |
	Sort-Object -Property FullName -Descending |
	Where-Object { $($_ | Get-ChildItem -Force | Select-Object -First 1).Count -eq 0 } |
	Remove-Item

cd $cwd

Start-Sleep $sleep

Write-Output "Extraction finished."
Write-Output "Models, Audio and other extracted assets can be found in the Assets folder"