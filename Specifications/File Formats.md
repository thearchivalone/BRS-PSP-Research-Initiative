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
* Type: 3D Pipeline Data
* Extension: .ptm
* Header: PTMD, PTM, PTMD-XP
* Purpose: Contains textures, materials and other data related to models and user interface elements
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
	* Currently Unknown how similar it is to a normal LPK

==================================================================
* Tentative Name: Skeletal Container
* Type: Container / 3D Pipeline Data
* Extension: .sc(hierarchy value)
* Header: SC
* Purpose: Houses the main models, riggings and animation data
* Notes:
	* SC's have a multilevel hierarchy based on the bit value of the byte after the header
* Structure:
	* 0x00 - (2-bytes) Header + (1-byte) Hierarchy level + 0 = Magic Number
		* Hierarchy (by Bit Flag; rest are internals)
			* 0x80 (Bit8) - Unknown
			* 0x40 (Bit7) - Field Event Armateur Skeleton (Internal to 0x10)
			* 0x3D - Field Object/Enemy Armateur Skeleton (Probably destructable or interactive)
			* 0x34 - Field Player Character Armateur Skeleton
			* 0x20 (Bit6) - Field Map EFC Skeleton
			* 0x1D - Field SUM00P Armateur Skeleton
			* 0x16 - Field Enemy Armateur Skeleton
			* 0x14 - Field Skill (?) Armateur Skeleton
			* 0x10 (Bit4) - Field Event/Map Skeleton Top Level (Probably related to Cutscenes) - Can contain multiple 0x40 SC's / SSCR's
			* 0x0A - Field SUM00 Armateur Skeleton
			* 0x0B - Field SUM Armateur Skeleton (Rest of SUM's use this + RID Gimmicks)
			* 0x0C - Field Test Enemy Armateur Skeleton
			* 0x09 - Same as 0x03 (Multiple TEST FEVTs)
			* 0x08 (Bit 3) - Field Character/Map Skeleton Top Level (Can contain an internal STCM if a Map)
			* 0x04 (Bit2) - Unknown
			* 0x03 - Test Field Event with BTL Model data (FEVT_TEST_AOIK00)
			* 0x02 (Bit1) - Field Event PHD Skeleton
			* 0x01 (Bit0) - Field Character Skeleton Without Armateur
			* 0x00 - Field Event Unused SC data + types (FEVT_TEST_KAMI00) - There were multiple different data types unique to this section found here

	* 0x04 - Internal Container list start - Can be 0x3c for some models; that's a bug that doesn't seem to affect the game but will break the extraction process
	* 0x08 - First internal object ends here but not guaranteed to help with any extra extraction
	* The rest of this section is variable based on how big the SC container is, so may have to wing it quite a bit to get anything extracted

==================================================================
* Tentative Name: Skeletal Container Missing Player
* Type: Container / 3D Pipeline Data
* Header: SCMP
* Purpose: Possible unused Player Character model
* Notes:
	* Seems to be the only SC container that doesn't have an SSCR section but instead contains an extra SCMP section in its place
	* Shares the same Namespace as the BRS model meaning it's probably a scrapped Player character
	* The header suggests that there may have been a scrapped Multiplayer mode and this was the character for it
	* Codenamed ZIG in the files
	* Has almost as many bones as most of the BRS models and contains some Animation data (but not the same way to access it as most other models minus some equipment, gadgets and skills)

==================================================================
* Tentative Name: Scripted Skeletal Character Rigging
* Type: 3D Pipeline Data
* Extension: .ss
* Header: SSCR
* Purpose: Controls the animation and armatures for animated 3D Models
* Notes:
	* This was first discovered on a random hunch while out for food. A quick script to check for vertex values found BRS's model pretty quickly under the `BTL\FLD\FCHR` directory
	* Often found inside of SC containers
* Structure:
	* 0x0c - Scripted Data Section Start
	* 0x10 - Scripted Data String End Address
	* 0x14 - Scripted Data Section End Address
	* 0x18 - SSCR Data End Address (Everything below is padding)
	* 0x2c - Scripted Data String Start Address

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
* Purpose: Alternative version of EFP found heavily inside of SCs.
* Notes:
	* Originally thought a unique type but `BTL\CHR\BCHR_CAT00` contains an EFP with multiple ESB files inside

==================================================================
* Tentative  Name: Effective Stealthy Binary
* Type: Data
* Extension: .esb
* Header: None
* Purpose: Unknown
* Structure:
	* 0x00 (2 bytes) - Size of data

==================================================================
* Tentative Name: Internal Node Structure Model
* Type: Data
* Extension: .cam (if INSA structures are found)
* Header: INSM
* Purpose: Stores model data without the texture or material data
* Notes:
	* Despite having the `.cam` extension, these quite possibly might not be necessarily camera related; the name could be short for something along the lines of Character Animation / Armateur Matrix due to these being primarily found within the Battle system as parts of what makes up the fragmented models
	* If they didn't change anything with the structure of these, then these should have bones while their MDL counterparts shouldn't have any (haven't tested enough)
* Structure:
	* See the next section for structure; they're both mostly the same

===================================================================
* Tentative Name: Internal Node Structure Model
* Type: Data
* Extension: .mdl (if PTMD or alternative structures are found within)
* Header: INSM
* Purpose: Stores model, texture and material data
* Notes:
	* Vertex Stride seems to vary a bit depending on where the model will be seen in game; ranges between 4 and 8 lines from what I've observed with some junk here and there that must be skipped on read
	* Vertex Data Section ranges from where 0x3c starts to just before the location at 0x34
* Structure:
	* 0x10 - Address where padding starts before embedded section
	* 0x18 - Address to unknown data structure
	* 0x24 - Address where the math calculation tables start
	* 0x28 - Start position of Unknown Data section - patterns of floats have been found here and at 0x2c but not sure what they're for yet
	* 0x2c - Offset from 0x28 to get to the a Second Unknown Data Section
	* 0x34 - Offset of PTMD or alternative structures from Header
	* 0x3c - Vertex Data Section Start Address (where model quads are found)

===================================================================
* Tentative Name: Internal Node Structure Animation
* Type: Data
* Extension: .anm
* Header: INSA
* Purpose: Stores animation and armateur data
* Notes:
	* Can be embedded inside of an INSM container
	* 24-byte name string found at Offset -0x18 from start when embedded (Mostly applies to Battle models)
	* The number of INSAs found in an SC model represents how many bones that model has
	* Wherever the chain that starts at 0x28 ends (final value looks something like 0x04 0x03 0xff 0xff), the next byte over has the offset from that address to somewhere around the data section that contains physics and/or animation data.
	* There's an offset somewhere around that address if it doesn't land within that data section and probably will repeat this process until it reaches that section
* Structure:
	* 0x1c - Offset from Header / Size of file
	* 0x14 - 0x28 - Animation section; 0x20 - Ignore it
	* 0x18 - End of data address before padding
	* 0x28 - Start of a chain of multiple bitwise operations with the final byte being how many calculations are performed before jumping to the section offset at the next byte over 
	* ox2c - Default start value for the calculations at 0x28; varies by file and how many calculations performed

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
* Type: Data
* Extension: .edx
* Header: EDXD
* Purpose: Archive padding with very little data inside
* Notes:
	* All are of 1.5 KB in size and found only inside of `GAMEDATA\BTL\BCHR` directory
* Structure:
	* 0x5c - Shared value among most if not all edx files - 8FED8D55
	
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