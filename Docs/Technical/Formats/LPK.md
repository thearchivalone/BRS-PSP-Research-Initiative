# LPK Archive Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Name: Light PaK
* Type: Container
* Extension: .lpk
* Header: LPK
* Purpose: Store data of similar or same types in a listed structure that can be quickly extracted due to being a small size
* Notes:
	* List based structure without direct encryption or compression for the most part; it's up to individual contents to handle this
	* Can either be a single archive with multiple files within or be multiple LPKs within (which aren't scripted for extraction yet due to having 
		a bit of a different structure)
	* Seems to be the standard way to store data outside of gzip compressed BIN or GZ archives
	* This container format doesn't contain the total file size in its data
* Structure:
	* 0x04 - Number of files within the archive
	* 0x08 - List of all file offsets up to value at 0x04 with 0x04 offset between them
	* Address where the count ends - List of all file sizes
---