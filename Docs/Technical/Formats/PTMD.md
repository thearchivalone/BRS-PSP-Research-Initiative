# PTMD Mesh Data Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Plot Thickens, My Dear
* Type: 3D Pipeline Data
* Extension: .ptm
* Header: PTMD, PTM, PTMD-XP
* Purpose: Contains textures, materials and other data related to models and user interface elements
* Structure:
	* 0x08 - This looks like it may be some kind of ID
	* 0x0c - Offset from Header / Size of file (can be around 0x400 less than what Windows shows the file size to be, possibly due to padding)

---