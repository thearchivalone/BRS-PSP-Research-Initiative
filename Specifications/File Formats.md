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
	* 0x04 - Offset to Encrypted Data Section (varies per archive)
	* 0x08 - Number of files within the archive (extremely important for decryption)
	* 0x0c - Total file size of archive (not that important now that decryption has been figured out)
	* 0x10 - The first byte here seems to be the main encryption key for everything; the other bytes might be backups
	* 0x20 - File list starts here; each name takes up 32 bytes
	* For every file listed, it follows this structure (offset used instead of specific address and begins 32 bytes after the start)
		* 0x04 - Data Offset from the start of the Encrypted Data Section
		* 0x08 - Data Size after extraction; may be compressed in some instances but so far that has been on a file by file basis within nested archives

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
* Type: Data
* Extension: .ptm
* Header: PTMD, PTM, PTMD-XP
* Purpose: General purpose data type related to visual assets
* Structure:
	* 0x08 - This looks like it may be some kind of ID
	* 0x0c - Offset from Header / Size of file (can be around 0x400 less than what Windows shows the file size to be, possibly due to padding)

==================================================================
* Tentative Name: just BIN files
* Type: Variable
* Extension: .bin
* Header: Variable
* Purpose: Generic data format type that can be used for anything and be any other file type
* Structure:
	* Varies depending on use case

==================================================================
* Tentative Name: CUTe and INnocent
* Type: Data archive
* Extension: .bin
* Header: LPK
* Purpose: Store Boss specific LPK data
* Notes:
	* Uses some duplicate structures as LPK but is considered a separate File Type due to being unique
* Structure:

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
* Type: Data
* Extension: .at3
* Header: RIFF (with multiple other sub headers depending on format of audio encoded within)
* Purpose: Stores Atrac3 (also known as Sony Minidisc) compressed lossless WAV audio; applies to all audio in game
* Notes:
	* Format isn't natively supported on any platform that's not a Sony game console or music player
	* Must be converted to WAV format to listen to or use
	* Probably cannot be converted back for modding without issues; multiple sources recommend just rebuilding from scratch before replacing audio in game due to Sony not releasing official information about the codec and various games using different versions of the format with some studios further customizing it on a per game basis
* Structure:
	* See the `extract_riff_experimental` section of `BRS-Extract.bms` for a general idea of the structure; it's pretty messy compared to a normal RIFF-WAVE audio file

==================================================================
* Tentative: Effective Format Pack
* Type: Container
* Extension: .efp
* Header: EFP
* Purpose: Stores multiple different types of data inside, most of which seem to be related to effects
* Notes:
	* Can contain multiple INSM mdls and PTMD ptms embedded with names
* Structure:
	* 0x18 - 24-byte first internal INSM mdl or PTMD ptm name string
	* 0x30 - Address of first internal INSM mdl structure

==================================================================
* Tentative Name: Easily, my Favorite Container
* Type: Container
* Extension: .efc
* Header: EFC
* Purpose: Exactly the same as EFP's with one difference.
* Notes:
	* Difference: Includes an embedded ESB file with only a size, a name and some data
	* These also exist in very small quantities

==================================================================
* Tentative  Name: Effective Stealthy Binary
* Type: Data
* Extension: .esb
* Header: None
* Notes:
	* Consistently found as one of the last embedded objects inside of what would otherwise be an EFP
* Structure:
	* 0x00 (2 bytes) - Size of data

==================================================================
* Tentative Name: Internal Node Structure Model
* Type: Data
* Extension: .cam (if INSA structures are found)
* Header: INSM
* Purpose: Stores model data
* Structure:
	* 0x34 - Offset of INSA structure from Header

===================================================================
* Tentative Name: Internal Node Structure Model
* Type: Data
* Extension: .mdl (if PTMD or alternative structures are found within)
* Header: INSM
* Purpose: Stores model data
* Structure:
	* 0x34 - Offset of PTMD or alternative structures from Header

===================================================================
* Tentative Name: Internal Node Structure Animation
* Type: Data
* Extension: .anm
* Header: INSA
* Purpose: Stores animation data
* Notes:
	* Can be embedded inside of an INSM container
	* 24-byte name string found at Offset -0x18 from start when embedded
* Structure:
	* 0x1c - Offset from Header / Size of file

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
* Tentative Name: Probably Bad Data
* Type: Debug
* Extension: .pbd
* Header: Variable 4-byte with at least one single Ascii Character
* Purpose: Contain data that could be anything, but most likely is debug related or for padding between elements in a container
* Structure:
	* 0x04 (2 bytes) - U ID
	* 0x08 - X ID + 0x01

==================================================================
* Tentative Name: bRS scrIPTING BMS
* Extension: .bms
* Header: bscr
* Purpose: The core scripting language for handling a variety of tasks that don't need to be performed using C / C++.
* Structure:
	* 0x04 - 32-byte script file string name; first byte begins with any Ascii character followed by a blank space and then the full name of the bms file in the archive to write the script to
	* 0x34 - Offset to scripting payload (You'll see a large chunk of text that includes multiple filenames from this directory and things like _INIT_ACTION_FROM here
	* 0x38 - Offset from the address that 0x3c leads to; Use this to move to where EDXD starts
	* 0x3c - Script File Offset in VOL (can be used as the size when writing to file)
	
==================================================================
* Tentative Name: Everything Does eXtensive Duties
* Extension: .edx
* Header: EDXD
* Purpose: Unsure what this is for as of now
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
* Tentative Name: Panic Punching Protection Gang
* Type: Data
* Extension: .phd
* Header: PPHD, PPTN, PPPG, PPVA
* Purpose: Currently Unknown
* Notes:
	* Named after the PPPG header I found
	* These all seem to be linked together in multiple VOL archives in a set structure

==================================================================
* Tentative Name: Something That Can Map
* Extension: .bin, .sm
* Header: STCM
* Purpose: Stores stage and map data
* Notes:
	* Originally found in decrypted and extracted Map VOLs under `GAMEDATA\BTL\MAP`
* Structure:
	* Currently Unknown

==================================================================
* Further Notes:
	* This document is subject to change as more research is done

==================================================================
*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*