This directory will house information about how the game was structured and various findings as I go.

=====================================================================
## How and Where To Use These Scripts

* You'll need to have the game ripped to an ISO file and fully extracted with something like 7-zip

* LPK archives, GZip compressed BIN files, VOL archives, and Zlib compressed ZZZ archives can all be extracted using the BRS-Extract.bms script like so:
	
	* `quickbms.exe -Y BRS-Extract.bms <VOL archive name> <VOL archive name>` - to extract data to a subdirectory of the same name + _extract 
	
	* Quick note: Don't use -y instead of -Y by accident; it will completely erase your script file or worse nuke the game data file you're working with; the -Y just tells quickbms to continue without asking you for further prompts
	
* If you come across any files that have `check-me` at the end of them after extraction, check the first four bytes to see what it says; that was added to aid in my discovery of unaccounted for formats

* AT3 audio files right now still require an external tool to extract them

* Extract-Xor.bms can be used on files that are encrypted that aren't within an archive (until I get that implemented into the other archive extraction types since those are more file by file encryption than full archive, from what I've found)

* Enjoy looking at the game

* These instructions will keep getting updated as I go

=====================================================================
*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*