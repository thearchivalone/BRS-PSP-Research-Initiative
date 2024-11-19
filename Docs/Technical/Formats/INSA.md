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
* Structure:
	* 0x10 - This 4-byte value leads to the vertex data; see the notes above
	* 0x1c - Offset from Header / Size of file
	* 0x14 - 0x28 - Default calculation type; 0x20 - Alternative calculation type (used primarily for ZIG and some of the models in the G Namespace)
	* 0x18 - End of data Address (offset from Header) before padding
	* 0x20 - Seems only important for alternative calculation type
	* 0x24 - Equivalent to 0x2c for 0x20
	* 0x28 - Start of a chain of multiple bitwise operations with the final byte being how many calculations are performed before jumping to the APData section offset at the next byte over
	* ox2c - Default start value for the calculations at 0x28; varies by file and how many calculations performed

---