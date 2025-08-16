# PTMD Mesh Data Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Name: Packed Texture Model Data
* Type: Compressed Data Archive
* Extension: .ptm
* Header: PTMD, PTM, PTMD-XP
* Purpose: Contains textures, materials and other data related to models and user interface elements
* Notes:
	* The compression file signature was left in the debug models and found using Signsearch (from the same developer of QuickBMS)
	* This signature was stripped out of all texture files and was only found by complete accident
	* Imageepoch used the Dynamic Markov Compression algorithm written about [here](https://plg.uwaterloo.ca/~gvcormac/manuscripts/dmc.pdf)
	* This format wasn't used much since its inception in 1986
	* The Tentative Name was originally `Plot Thickens, My Dear` but feedback suggested I name this something more correct
	* A 6MB texture file was compressed into 200KB
	* Contains a PTR Texture file
* Structure:
	* 0x08 - This looks like it may be some kind of ID
	* 0x0c - Address to end of file or beginning of padding section (which may contain extra data); expect this to be around 0x400 off of what the file system shows for size
---