# Copyright 2024 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets

$cwd = (Get-Item . | % { $_.FullName })

Function Run_Python3_Stage4() {
	$tmp = $init_scripts_dir + $path_delimiter + "stage4.py"
	& python $tmp $os $game_dir
}

Run_Python3_Stage4
