# INSA Armateur Data Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Name: Internal Node Structure - Animation
* Type: Data
* Extension: .anm
* Header: INSA
* Purpose: Stores animation and armateur data
* Notes:
	* APData - Animation / Physics Data (until loaded into a modeling software, this is just a guess)
	* Can be embedded inside of an INSM container
	* 24-byte name string found at Offset -0x18 from start when embedded (Mostly applies to Battle models)
	* The number of INSAs found in an SC model represents how many bones that model has
	* The two calculation types for determining where to jump to to get to APData section:
		* 0x28 - Calculate data over a known range of addresses each offset by 0x24 bytes
		* 0x20 - Calculate data by an unknown total quantity with an offset of 0x08 bytes per calculation and a bit shift by 1 to the left on the first byte to stop it
	* The value at 0x10 is an elusive bugger; the developers read every byte of data from one bone to the next (or the end of file) until they hit "0000803f," 0x10's value, "0000803f." Even then, there's several extra steps for some models (check for duplicates, check for extra 0's, etc)
	* Bone Generation Patterns - See accompanying Bone-Generation-Table spreadsheet for specifics on these patterns
		* The Shredder - the vertex data is either non-existent for the bone it applies to or spread across this single bone's memory in 4-byte chunks instead of being clustered together like most of the others
		* The 7-11 - This pattern has only been seen one time so far and may have been a human error on my part; the name comes from it having an offset of 0x24 from the third occurence and being a possible inconvenience (similar to how the next pattern was handled)
		* The 33C - This pattern is more prominant but also problematic; 0x33c offset from the third occurence can mean these things:
			* if it occurs on its own, it can be a direct offset to the start of the vertex data section
			* it can be inside of the vertex data section as somewhere close to the center of the memory region
			* (need to test further) it can mean other patterns were applied and act as a second indicator of the pattern used
		* The OC - Named after its pattern of alternating 0x10 and 0x1c offsets; often found after other patterns but also can function similarly to any other pattern that uses either of its shared offsets
		* The Shizu Shuffle - Expect possible chaos in the mix; these can have varied patterns and be fully nonexistent if combined with an augmentation
		* The Standard - Expect to find a large block of vertex data immediately after the third instance of 0x10's value
		* The VAP Data Shuffle - Similar to The Standard except expect to find Animation Data Mixed in with the Vertex Data
		* 3x10 to The Standard - Augmented variation of The Standard; expect to jump 0x30 (3 times 0x10 offset to get to Vertex Data)
		* 3x10 to The VAP Data Shuffle - Same augmentation but for the VAP Data Shuffle
	* 0x10 is found at the end of each vertex data cluster; these clusters represent the start and finish of a straight line that makes up the edge of the quad / tri used to build each bone. The more vertices, the longer the edge
	* Header Structure Value Notes
		* Data Values for 0x00 (mainly relevant if Final Structure)
			* 0x04 - Jump 0x08 for end address of 0x14 Data structure
			* 0x02 - Jump 0x16 for same end address
		* Data Values for 0x04
			* Offset between structures - 0x60 (until the final structure; can be variable then)
			* 0x02
				* Animation Data Structure starts at 0x2d4
			* 0x03
				* Animation Data Structure starts at a variable address
* Header Structure:
	* 0x04 - Value is related to Namespace and how to read the Data; See notes above about values and see Data Structure for how each section is laid out
	* 0x0c - The Shredder Pattern is in effect if both this and 0x20 are not 0 and have the same value
	* 0x10 - Originally thought this was an offset but not sure now
	* 0x1c - Offset from Header / Size of file
	* 0x14 - 0x28 - Default calculation type; 0x20 - Alternative calculation type (used primarily for ZIG and some of the models in the G Namespace)
		* This value is also the address for where animation data reading starts
	* 0x18 - End of data Address (offset from Header) before padding
	* 0x20 - Important for the alternative calculation type; see 0x0c's notes for how this applies to the bone generation
	* 0x24 - Equivalent to 0x2c for 0x20
	* 0x28 - Start of a chain of multiple bitwise operations with the final byte being how many calculations are performed; the final value is probably related to the rotation of the bones (starts as a degree value and then gets converted to radians)
		* Also where animation data reading starts; see Animation Data Structure section below
	* 0x2c - Default start value for the calculations at 0x28; varies by file and how many calculations performed
	* 0x30 - 8 byte end of header
* Animation Data Structure (Initial section pointed at by 0x14)
	* 0x00 - See 0x28 for theories on what this is
	* 0x04 - Address where the Animation Data tied to this section starts
		* Structure of this Address:
			* 0x00 - 1-byte header - Usually 0x02
			* 0x01 - 1-byte data type - Tells how many 4-byte chunks are addresses to jump to to obtain data for this section
				* 0x01 - read next 32-byte chunk (with no 0x0000 chunks in it)
				* 0x03 - read next 32-byte chunk (expect at least 3 0x0000 chunks at set locations)
			* 0x04 - 2-byte Unknown Value
				* 0x02 - unknown
				* 0x24 - Last 12 <=> 16 bytes of this 32-byte chunk tell where to read next data structure and what to read (based on the 4-byte value of address sent from here)
			* 0x06 - 2-byte Unknown Value that usually matches 0x08
			* 0x08 - 4-byte Usually same as 0x06; if 0x01 is 0x03 - First 0x0000 chunk
			* 0x0c - 4-byte Unknown Value
			* 0x10 - 4-byte Unknown Value; if 0x01 is 0x03 - Second 0x0000 chunk
			* 0x14 - 4-byte Unknown Value; if 0x01 is 0x03 - Third 0x0000 chunk
			* 0x18 <=> 0x20 - Each of these Unknown 4-byte Values seem to have a consistent structure across multiple anm files; Need to test further
	* 0x08 - if final structure, see Notes above related to 0x00 value
* Animation Data Structure (Based on Value at 0x04)
	* 0x00 - 1-byte header
		* 0x00 - first structure
			* Read the next 24-byte chunk
		* 0x02 - second structure
			* Read the next 32-byte chunk
	* 0x01 - Usually 0x01 to represent this section type
	* 0x04 - Address where the Animation Data tied to this section starts
		* Structure of this Address:
			* 0x04 - 2-byte Unknown Value (See Previous Section for Values here)
			* 0x06 - 2-byte Unknown Value that usually matches 0x08
			* 0x08 - 4-byte Usually same as 0x06
---