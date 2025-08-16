# SCMP Model Container Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Name: Skeletal Container Missing Player
* Type: Container / 3D Pipeline Data
* Header: SCMP
* Purpose: Possible unused Player Character model
* Notes:
	* Seems to be the only SC container that doesn't have an SSCR section but instead contains an extra SCMP section in its place
	* Contains 3 SCMP headers total
	* Shares the same Namespace as the BRS model meaning it's probably a scrapped Player character
	* The header suggests that there may have been a scrapped Multiplayer mode and this was the character for it
	* Codenamed ZIG in the files
	* Has almost as many bones as most of the BRS models and contains some Animation data (but not the same way to access it as most other models minus some equipment, gadgets and skills)
	* The 0x20 math calculations (see my INSA notes on that part) for the second bone are bugged; their final result seems to be one of the few inconsistencies among the models
* Structure:
	* 0x04 - Offset of first SCMP / Internal Container instance - Main Container
	* 0x08 - Offset of second SCMP / Internal Container instance - Mesh Container
	* 0x0c - Offset of third SCMP / Internal Container instance - Armateur Container

---