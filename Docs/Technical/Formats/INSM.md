# INSM Model Data Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

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

---

* Extension: .mdl (if PTMD or alternative structures are found within)
* Header: INSM
* Purpose: Stores model, mesh and material data
* Notes:
	* Vertex Stride seems to vary a bit depending on where the model will be seen in game; ranges between 4 and 8 lines from what I've observed with some junk here and there that must be skipped on read
	* Vertex Data Section ranges from where 0x3c starts to just before the location at 0x34
	* Calculation for where vertex offset shifts: Second Mesh Vertex Data Address - <Values of these addresses subtracted>(0x18 - 0x14 - 0x10) - <Round this to nearest byte>(0x08)
	* 0x14 and 0xc7 are common in the 4th byte of the headers of different sections of data
	* There's a list somewhere near the header (or pointed to by an address the header points to) that contains important model data
* Header Structure:
	* 0x08 - Address to Unknown Data Section with possible model data; after rounding this, this gives a start region to start expecting offset shifts to happen
	* 0x10 - Address to Unkown 4-byte Value
	* 0x14 - Address to first model data structure
	* 0x18 - Address to second model data structure. See notes above
	* 0x1c - Address to third model data structure
	* 0x20 - Address to fourth model data structure
	* 0x24 - Address to PTMD or alternative structures
	* 0x28 - Address to possible Calculation table
	* 0x2c - Address to unknown section
	* 0x30 - Address to unknown section
	* 0x34 - Same as 0x24
	* 0x3c - Address to Model Data Structure 0 (First one of interest to me)
* Model Data Structure (Address found at 0x3c)
	* 0x00 - Header Contains 0xc7 and some bit flag values
	* 0x04 <=> 0x0c - Unknown 4-byte values
* Model Data Structure (From Address found at 0x14 + 0x04)
	* 0x00 - Header 0x14
	*
* Model Data Structure (Address found at 0x18)
---