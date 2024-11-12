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

$archive_types += @("vol", "zzz", "gz")

$sleep = 3

Write-Output "Checking If Required Extraction Tools Are Available"

if (!(Test-Path -Path $tools_dir -PathType Container)) {
	New-Item -Path . -Name $tools_dir -ItemType Directory | Out-Null
}

Write-Output "Checking QuickBMS"

if ((Get-Command $quickbms_command -ErrorAction SilentlyContinue) -eq $null)
{
	$download_qbms = 1
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
		Write-Output "Please download QuickBMS and place it inside of the Tools directory; then run this script again"
		exit
	}
}

Start-Sleep $sleep

Function Delete {
	Write-Output "Removing extracted files. Please wait"
	Start-Sleep $sleep
	Remove-Item $extraction_dir -Force -Recurse
}

Function Clean {
	Write-Output "Cleaning up. Please wait"
	Start-Sleep $sleep
	Get-ChildItem -Path $extraction_dir -Force -Recurse -Directory |
		Sort-Object -Property FullName -Descending |
		Where-Object { $($_ | Get-ChildItem -Force | Select-Object -First 1).Count -eq 0 } |
		Remove-Item

	foreach ($item in (Get-ChildItem -Path $extraction_dir -Force -Recurse | % { $_.FullName })) {
		if ($item -like "*TEMP*") {
			Remove-Item $Item -Force
		}
	}
}

Function Extract_Internals {
	Write-Output "Extracting embedded archives. Please wait"
	Start-Sleep $sleep
	foreach ($item in (Get-ChildItem -Path $extraction_dir -Force -Recurse | % { $_.FullName })) {
		$ext = (Split-Path -Path $item -Leaf).Split(".")[1]
		$dir = Split-Path -Path $item -Parent
		foreach ($arc in $archive_types) {
			if (($ext -eq $arc) -And (($dir -like "*SYSTEM*") -Or ($dir -like "*TITLE*") -Or ($dir -like "*IF*"))) {
				cd $dir
				& $quickbms_command -Y -d $extraction_script $item
				cd $cwd
			}
		}
	}
}

Function Extract_Field {
	Write-Output "Extracting the Field models"
	Start-Sleep $sleep
	$field_dir = $game_dir + "\FLD"
	foreach ($item in (Get-ChildItem -Path $field_dir -Force -Recurse | % { $_.FullName })) {
		$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
		& $quickbms_command -Y -d $extraction_script $item $dir
	}
}

Function Extract_Battle {
	Write-Output "Extracting the Battle models"
	Start-Sleep $sleep
	$btl_dir = $game_dir + "\BTL"
	foreach ($item in (Get-ChildItem -Path $btl_dir -Force -Recurse | % { $_.FullName })) {
		$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
		& $quickbms_command -Y -d $extraction_script $item $dir
	}
}

Function Extract_Gallery {
	Write-Output "Extracting the Gallery files"
	Start-Sleep $sleep
	$gallery_dir = $game_dir + "\GALLERY"
	foreach ($item in (Get-ChildItem -Path $gallery_dir -Force -Recurse | % { $_.FullName })) {
		$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
		& $quickbms_command -Y -d $extraction_script $item $dir
	}
}

Function Extract_Interface {
	Write-Output "Extracting the Interface files"
	Start-Sleep $sleep
	$if_dir = $game_dir + "\IF"
	foreach ($item in (Get-ChildItem -Path $if_dir -Force -Recurse | % { $_.FullName })) {
		$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
		& $quickbms_command -Y -d $extraction_script $item $dir
	}
	Extract_Internals
}

Function Extract_MiniGames {
	Write-Output "Extracting the Mini-Games"
	Start-Sleep $sleep
	$mg_dir = $game_dir + "\Mini_Game"
	foreach ($item in (Get-ChildItem -Path $mg_dir -Force -Recurse | % { $_.FullName })) {
		$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
		& $quickbms_command -Y -d $extraction_script $item $dir
	}
}

Function Extract_MemoryCard {
	Write-Output "Extracting the Memory Card Volume"
	Start-Sleep $sleep
	$item = $game_dir + "\PSP_GAME\USRDIR\GAMEDATA\MC.VOL"
	$item = Get-Item -Path $item |  % { $_.FullName }
	$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
	$dir = Split-Path $dir -Parent
	& $quickbms_command -Y -d $extraction_script $item $dir
}

Function Extract_System {
	Write-Output "Extracting the System Volume"
	Start-Sleep $sleep
	$item = $game_dir + "\PSP_GAME\USRDIR\GAMEDATA\SYSTEM.VOL"
	$item = Get-Item -Path $item |  % { $_.FullName }
	$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
	$dir = Split-Path $dir -Parent
	& $quickbms_command -Y -d $extraction_script $item $dir
	Extract_Internals
}

Function Extract_Title {
	Write-Output "Extracting the Title Volume"
	Start-Sleep $sleep
	$item = $game_dir + "\PSP_GAME\USRDIR\GAMEDATA\TITLE.VOL"
	$item = Get-Item -Path $item |  % { $_.FullName }
	$dir = $item.replace(($game_dir + "\"), ($extraction_dir + "\"))
	$dir = Split-Path $dir -Parent
	& $quickbms_command -Y -d $extraction_script $item $dir
	Extract_Internals
}

Function Extract_All {
	Extract_Field
	Extract_Battle
	Extract_Gallery
	Extract_Interface
	Extract_MiniGames
	Extract_MemoryCard
	Extract_System
	Extract_Title
}

$Continue = 1

Function Get_User_Input {
	Write-Output "What would you like to do today?"
	Write-Output "1) Extract the Field models"
	Write-Output "2) Extract the Battle models"
	Write-Output "3) Extract the Gallery files"
	Write-Output "4) Extract the Interface files"
	Write-Output "5) Extract the Mini-Game files"
	Write-Output "6) Extract the Memory Card Volume"
	Write-Output "7) Extract the System Volume"
	Write-Output "8) Extract the Title Volume"
	Write-Output "a) Extract the important things"
	Write-Output "q) Quit the program"
	Write-Output "d) Remove extracted files"

	$input = Read-Host "Type value and press enter"

	if ($input -eq 'q') {
		break
	}
	if ($input -eq 'a') {
		Extract_All
	}
	if ($input -eq 'd') {
		Delete
	}

	switch ($input) {
		1 { Extract_Field }
		2 { Extract_Battle }
		3 { Extract_Gallery }
		4 { Extract_Interface }
		5 { Extract_MiniGames }
		6 { Extract_MemoryCard }
		7 { Extract_System }
		8 { Extract_Title }
		default {}
	}
}

Do {
	Get_User_Input
} While ($Continue -eq '1')

Clean

Write-Output "Have a wonderful day! Happy modding, digging, and BRSing!!! :D"

#Write-Output "Models, Audio and other extracted assets can be found in the Assets folder"