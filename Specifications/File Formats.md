* Name: RTDP Volume (named after the Magic Number header)
* Extension: .vol
* Header: RTDP
* Notes:
	* Compression is on a per file basis and often are found within BIN and LPK archives
* Structure:
	* 0x04 - Unknown value at this time
	* 0x08 - Number of files within the archive
	* 0x20 - File list starts here; each name takes up 32 bytes
	* For every file listed, it follows this structure (offset used instead of specific address and begins 32 bytes after the start)
		* 0x04 - Data Offset within the archive
		* 0x08 - Extracted file size
		
=================================================================
* Name: LPK Archives
* Extension: .lpk
* Header: LPK
* Notes:
	* Can either be a single archive with multiple files within or be multiple LPKs within
	* Seems to be the standard way to store data outside of gzip compressed BIN or GZ archives
	* This section primarily focuses on single archives but multiarchive information will be coming in the future
* Structure:
	* 0x04 - Number of files within the archive
	* 0x0c - List of all file offsets and sizes within the archive. See BRS-LPK.bms for how this particle section is structured. There's some math involved
	
==================================================================
* Name: PTMD Assets
* Extension: Variable
* Header: PTMD
* Notes:
	* Little is currently known about what these files are but they seem to be related to the Art Gallery, portraits and various interface related assets
	* My current guess is that these are a modified version of the PMD format used by [Miku Miku Dance](https://sites.google.com/view/vpvp/)
	* The only other games for the PSP that may have used a similar format are the Project Diva games

==================================================================
* Name: BIN Files
* Extension: variable
* Header: None known
* Notes:
	* These seem to be a grab all format; they are used as archives (often using a modified gzip format), listings of files, or even ways to label the directory (in the case of several empty files within various volumes)
	* Some are labeled as PNGs, AT3s or any other file format as a way to seemingly hide them. These are often compressed using weak, single byte XOR encryption (see BRS-Xor.bms for more information about that)
	
==================================================================
* Name: SC / SSCR Files
* Extension: None known
* Header: SC / SSCR
* Notes:
	* These are related to the internal scripting engine
	* They seem to be a container or an archive depending on needs
	* Some contain INSM files
* Structure:
	* Currently Unknown
	
==================================================================
* Name: SDOa Files
* Extension: None known
* Header: SDOa
* Notes:
	* Little is known about what these are for right now but they were first found within Minimap archives
	
==================================================================
* Name: XBN Files
* Extension: None known
* Header: XBN
* Notes:
	* Little is known about what these are for right now but they were first found within Minimap archives
	
==================================================================
* Name: XTC Files
* Extension: None known
* Header: XTC
* Notes:
	* Little is known about what these are for right now but they were first found within Minimap archives
	
==================================================================
* Name: PDK Files
* Extension: None known
* Header: PDK
* Notes:
	* Little is known about what these are for right now but they were first found within the MiniGame archives
	* Contains list of scripts and is related to difficulty settings
	
==================================================================
* Name: AT3 Files
* Extension: .at3
* Header: RIFF (with multiple other sub headers depending on format of audio encoded within)
* Notes:
	* These are often just standard audio containers with most of the music, voice lines and sound effects compressed within
	* Can easily be extracted and converted to a standard playable format using [VGMstream](https://github.com/vgmstream/vgmstream) (or similar other converters)
	* Aren't always audio but instead encrypted archive files or other formats depending on what is needed within the structure
	
=====================================================================
* Name: INSM Files
* Extension: None known
* Header: INSM
* Notes:
	* This is some kind of modified version of the MDL format
	* Changing to `.mdl` file allows opening in any software that supports that format
	
=====================================================================

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.* 