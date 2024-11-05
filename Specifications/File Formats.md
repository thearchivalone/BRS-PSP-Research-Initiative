# Found File Formats

This documentation is mostly here to help structure, describe and name the various types of files/data found within the game

=================================================================
* Tentative Name: Rudimentary Typed Data Pack
* Type: Data archive
* Extension: .vol
* Header: RTDP
* Purpose: Store vast majority of the game's data
* Notes:
	* Compression is on a per file basis and often are found within internal BIN, LPK, and PTMD archives
	* Files in all caps are typically upper level archive files
	* Lower case files (example: pack.vol from SYSTEM.VOL) are suspicious files that need to be examined further (this applies to all file types)
	* These are also hidden data files (must be decrypted); the names of the files listed and anything past the EOF section can be encrypted data (hence some of the weird file names and / or specific sizes of files within their respective archives)
* Structure:
	* 0x04 - Unknown value at this time
	* 0x08 - Number of files within the archive
	* 0x0c - Total file size of archive (very important for decryption; after extracting the data, run BRS-Xor.bms script on the VOL file and you'll see what I mean)
	* 0x10 - 0x14 - There are at least 3 individual XOR encryption keys in this one byte although some archives may use different keys; they are almost always going to be here and 0x55 is the main one for the vast majority of encrypted files
	* 0x20 - File list starts here; each name takes up 32 bytes
	* For every file listed, it follows this structure (offset used instead of specific address and begins 32 bytes after the start)
		* 0x04 - Data Offset within the archive
		* 0x08 - Extracted file size
		* File list sizes vary per archive but they consistently use a single 16-byte section that begins and ends with 0x37 (EOF section from here on) 
			* This section also consists of single bytes that are all probably extra XOR encryption keys (minus 0x37)
			* Example: Several PTMDs that are nested fairly deep in the structure use "0x65 0x65" (ee) for at least part of their encryption. 
				0x28 seems to be the only one from the original that's omitted here, so it's very possible that one is never used
		
=================================================================
* Tentative Name: Let's Play Kid
* Type: Data archive
* Extension: .lpk
* Header: LPK
* Purpose: Store data of similar or same types in a listed structure that can be quickly extracted
* Notes:
	* List based structure without direct encryption or compression for the most part; it's up to individual contents to handle this
	* Can either be a single archive with multiple files within or be multiple LPKs within (which aren't scripted for extraction yet due to having 
		a bit of a different structure)
	* Seems to be the standard way to store data outside of gzip compressed BIN or GZ archives
* Structure:
	* 0x04 - Number of files within the archive
	* 0x0c - List of all file offsets and sizes within the archive. See BRS-LPK.bms for how this particle section is structured. There's some math involved
	
==================================================================
* Tentative Name: Plot Thickens, My Dear
* Type: Variable
* Extension: .ptm
* Header: PTMD, PTM, PTMD-XP
* Purpose: General use data format for basically everything
* Notes:
	* Not 100% sure what these are for yet but they seem to be variable
* Structure:
	* Currently Unknown

==================================================================
* Tentative Name: just BIN files
* Type: Variable
* Extension: .bin
* Header: variable
* Purpose: Similar to PTMD's purpose but more often than not are data listings and GZip compressed archives
* Structure:
	* Varies depending on use case
	
==================================================================
* Tentative Name: Stacked Container
* Type: Container / Data archive
* Extension: .sc
* Header: SC
* Purpose: General purpose container that is often packed together more tightly than other ones
* Notes:
	* Almost always has other file types inside (such as INSM, INSA, and SSCR)
	* Can contain any amount of other types
	* Each container wrapped with SC
* Structure:
	* 0x04 - Internal Container list start
	* 0x24 - Internal Container list end
	* 0x24 - Main Container end
		* Each internal container list data takes up 8-bytes with the first 4-bytes being the start point and last 4-bytes being the end
		* Every end can become the start point of the next stored data (hence why these begin and end with the SC header)
	
==================================================================
* Tentative Name: Super Stacked ContaineR
* Type: Container
* Extension: None known
* Header: SSCR
* Purpose: Not fully known but these seem to be an extension of SC and contain much of the Scripted data.

==================================================================
* Tentative Name: Playing Donkey Kong
* Type: Data / Container
* Extension: .pdk
* Header: PDK
* Purpose: Stores difficulty related data
* Notes:
	* Found primarily within the Minigames structures
* Structure:
	* Currently Unknown

==================================================================
* Name: RIFF Container Format
* Extension: .at3
* Header: RIFF (with multiple other sub headers depending on format of audio encoded within)
* Notes:
	* These are often just standard audio containers with most of the music, voice lines and sound effects compressed within
	* Can easily be extracted and converted to a standard playable format using [VGMstream](https://github.com/vgmstream/vgmstream) (or similar other converters)

===================================================================
* Tentative Name: Internal Node Structure Model
* Type: Data
* Extension: .mdl (if PTMD is found within)
* Header: INSM
* Purpose: Stores model data
* Notes:
	* Can house model data (converting extension to .mdl can allow viewing as a model in 3D software but isn't guaranteed to work)
* Structure:
	* 0x20 - Start of offset list for other formats associated with this

===================================================================
* Tentative Name: Internal Node Structure Animation
* Type: Data
* Extension: .anm
* Header: INSA
* Purpose: Stores animation data
* Notes:
	* Can be embedded inside of an INSM container
* Structure:
	* 0x1c - Offset to File string

==================================================================
	
==================================================================
* Tentative Name: Easily, my Favorite Container
* Type: Container
* Extension: .efc
* Header: EFC
* Purpose: Just effects and scripting related containers
* Notes:
	* These can have other data types within but often are found wherever INSM and INSA files are found.
	
==================================================================
* Tentative Name: Extensible Text Container
* Type: Container
* Extension: .xtc
* Header: XTC
* Purpose: Render text on screen
* Notes:
	* Primarily related to user interface elements
	* Files can vary in size on disc depending on region and language
	* Text is allocated to the end of the data structure
* Data Typings:
	* \b(#) - Button text with event tied to it (such as changing a setting or zooming the camera in or out in the Gallery)
	* \z(#) - Zone text; zones include time of day variants of game stages
	* Untyped - Readable but not interactive
* Structure:
	* 0x08 - X ID

==================================================================
* Tentative Name: SoDa Of archives
* Type: Container
* Extension: None known
* Header: SDOa
* Purpose: Stores data related to interfaces but not fully sure the extent of these yet
* Notes:
	* Often found where XTC, XPN and PTMD files are found
	* First discovered while diving through the menu archives
* Structure:
	* 0x04 (2 bytes) - U ID
	
==================================================================
* Tentative name: Extensible Button Node
* Type: Processor Node
* Extension: .xbn
* Header: XBN
* Purpose: Process button data for player interaction with other systems (guess for now; could change later)
* Notes:
	* Often found with SDOa and XTC files but not always PTMD
* Structure:
	* 0x18 - X ID
	
==================================================================
* Tentative Name: the Unknown
* Extension: None known
* Header: Variable 4-byte with a single Ascii Character
* Purpose: Separates PTMD and other Interface data inside of their LPK archives.
* Notes:
	* This contains game data
	* Not sure what all it does but it seems to be one of the most important elements of the interface structure
* Structure:
	* 0x04 (2 bytes) - U ID
	* 0x08 - X ID + 0x01

==================================================================
* Tentative Name: bRS scrIPTING BMS
* Extension: .bms
* Header: bscr
* Purpose: The core scripting language for handling a variety of tasks that don't need to be performed using C / C++.
* Notes:
	* Anywhere there's a blank .bms file inside of an archive (especially within VOL files), expect there to be game scripting somewhere within (probably encrypted too)
	* The .bms file essentially acts as a memory object container that gets populated only when that particular script is needed by the game while the player is playing it
	* Some of these are persistent across the entire game, others are volatile (as in get destroyed and replaced by other types of data), dependent on what their core functions are
* Structure:
	* 0x04 - 32-byte script file string name; first byte begins with a $ (0x24) character followed by a blank space and then the full name of the bms file in the archive to write the script to
	* 0x34 - Offset to scripting payload (You'll see a large chunk of text that includes multiple filenames from this directory and things like _INIT_ACTION_FROM here
	* 0x38 - Offset from the address that 0x3c leads to; Use this to move to where EDXD starts
	* 0x3c - Script File Offset in VOL (can be used as the size when writing to file)
	
==================================================================
* Tentative Name: Everything Does eXtensive Duties
* Extension: .edx
* Header: EDXD
* Purpose: An extension of the BMS format, allowing for extra scripting beyond the file size allocated for those files
* Notes:
	* This one is subject to change but it looks like these can be found in the VOL archives and act as a memory object for containing the scripting data within the .edx file
* Structure:
	* Currently Unknown
	
==================================================================
* Tentative Name: BRS eXtensible Contancorous Binary
* Type: Data
* Extension: .bin
* Header: BXCB
* Notes:
	* Param1.bin and Param2.bin files contain this data

==================================================================
* Tentative: Effective Format Pack
* Type: Container
* Extension: .efp
* Header: EFP
* Purpose: Either points to an mdl somewhere else in the structure or contains the data to create the mdl file
* Notes:
	* .efp file in VOL archive is not 0x55 encrypted; it uses a different encryption key that possibly isn't in the VOL itself
* Structure:
	* 0x18 - 24-byte mdl string name associated here

==================================================================
* Tentative: Panic Punching Protection Gang
* Extension: .phd
* Header: PPHD, PPTN, PPPG, PPVA
* Purpose: Currently Unknown
* Notes:
	* Named after the PPPG header I found
	* These all seem to be linked together in multiple VOL archives in a set structure

==================================================================
* Further Notes:
	* There are quite a few other types (such as cam, anm, edb and edx),  but the majority of those are top level and may or may not need specific tools to extract and use
	* This document is subject to change as more research is done

==================================================================
*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets* 