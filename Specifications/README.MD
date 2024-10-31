This directory will house information about how the game was structured and various findings as I go.

=====================================================================
## How and Where To Use These Scripts

* You'll need to have the game ripped to an ISO file and fully extracted with something like 7-zip

* Directories that have VOL archives in them (`PSP_GAME\USRDIR\GAMEDATA` and `PSP_GAME\USRDIR\GAMEDATA\BTL\BCHR` for example) will need to have the BRS-Vol.bms script ran like this:
	
	* `quickbms.exe -y BRS-Vol.bms <VOL archive name> <VOL archive name>` - to extract data to a subdirectory of the same name + _extract
	
* Then, you'll replace BRS-Vol.bms with BRS-Xor.bms in the above command and run it again to convert the VOL archive into its alternative, decrypted form. Pretty much every file has data hidden inside of it somewhere ;)

* Almost everything extracted within `PSP_GAME\USRDIR\GAMEDATA\BTL\BCHR` is encrypted (see param1.bin, param2.bin and several random files of varying types - see anything debug-related, labeled dummy, or test along with several at3 files for what I mean; human readable files in the VOLs tell the game what order to decrypt and load the files in, some of which can act as keys for other encrypted files)

* Some decrypted files will list other files and can have alternative XOR encryption keys decrypted too

* The vast majority of files inside of archives do not have extensions, so you'll need to open them inside of a hex editor and compare the first 4 characters (called a Magic Header) to their corresponding within the `Specifications/FileFormats.md` documentation of this repository

* Any files with an `LPK` Magic Header can be extracted with the `BRS-LPK.bms` script

* Enjoy looking at the game

=====================================================================
*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets* 