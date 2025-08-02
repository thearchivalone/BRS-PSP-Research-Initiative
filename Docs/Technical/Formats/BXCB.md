# BXCB Param.bin Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: BRS eXtensible Contancorous Binary
* Type: Data
* Extension: .bin
* Header: BXCB
* Notes:
	* Param1.bin
	* Param2.bin
		* Battle models are grouped based on general species type
		* Battle model data chunks have a 0x18 size header with only 0x1c being size of stat chunks
* Structure (shared):
	* 0x04 - data file size
	* 0x0c - always 0x20
* Structure (param1.bin):
	* 0x20 - battle model archive id
* Structure (param2.bin):
	* 0x10 - battle model data chunk offset
	* 0x14 - number of model groups in archive
	* 0x18 - address where battle model data strings are (with an offset based on string length and chunk index)
	* 0x5c - address to end of header data
	* 0x64 - battle species id; also counts as end of battle data chunk
	* 0xb0 - usually contains 0x1e (start of battle group data chunk)
	* 0x10c - Unknown special value
---