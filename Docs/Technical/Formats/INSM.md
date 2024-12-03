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
* Structure:
	* 0x08 - Address to Unknown Data Section with possible model data
	* 0x10 - Address where padding starts before embedded section
	* 0x14 - Offset from 0x3c to the vertex data that creates the full mesh; subtract 0x04 to get to first X value (bosses may have augmentations); all values here draw straight lines between vertices; section ends with 0
	* 0x18 - Address to unknown data structure
	* 0x24 - Address where the math calculation tables start
	* 0x28 - Start position of Unknown Data section - patterns of floats have been found here and at 0x2c but not sure what they're for yet
	* 0x2c - Offset from 0x28 to get to the a Second Unknown Data Section
	* 0x34 - Offset of PTMD or alternative structures from Header
	* 0x3c - Offset to Mesh Vertex Data Start from Header