# INSA Armateur Data Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Internal Node Structure Animation
* Type: Data
* Extension: .anm
* Header: INSA
* Purpose: Stores animation and armateur data
* Notes:
	* APData - Animation / Physics Data (until loaded into a modleing software, this is just a guess)
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
* Structure:
	* 0x0c - The Shredder Pattern is in effect if both this and 0x20 are not 0 and have the same value
	* 0x10 - This 4-byte value leads to the vertex data; see the notes above
	* 0x1c - Offset from Header / Size of file
	* 0x14 - 0x28 - Default calculation type; 0x20 - Alternative calculation type (used primarily for ZIG and some of the models in the G Namespace)
	* 0x18 - End of data Address (offset from Header) before padding
	* 0x20 - Important for the alternative calculation type; see 0x0c's notes for how this applies to the bone generation
	* 0x24 - Equivalent to 0x2c for 0x20
	* 0x28 - Start of a chain of multiple bitwise operations with the final byte being how many calculations are performed; the final value is related to the rotation of the bones (starts as a degree value and then gets converted to radians)
	* 0x2c - Default start value for the calculations at 0x28; varies by file and how many calculations performed
	* 0x30 - 8 byte end of header

---