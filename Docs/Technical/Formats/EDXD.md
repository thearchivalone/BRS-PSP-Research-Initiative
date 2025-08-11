# EDXD Data Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Everything Does eXtensive Duties
* Type: Data
* Extension: .edx
* Header: EDXD
* Purpose: In engine model and animation resolution data component tied directly to the bms scripting component
* Notes:
	* All are of 1.5 KB in size and found only inside of `GAMEDATA\BTL\BCHR` directory
	* Lots of speculation on this one due to just not knowing exactly what it's for yet; will notate with (spec) on addresses
	* Where there's a bms, there is always going to be one of these files
* Structure:
	* (spec) - Following [PMF format docs](https://hitmen.c02.at/files/yapspd/psp_doc/chap26.html#sec26.8), if you add a 0 to these values, you get resolution and possibly buffer data values
		* 0x10 - always 0x3c = 60; as 0x3c0 = 960
		* 0x12 - always 0xb4 = 180; as 0xb40 = 2880
		* 0x14 - always 0x1e = 30; as 0x1e0 = 480
		* 0x18 - always 0x14 = 20; as 0x140 = 320
	* 0x5c - Shared value among most if not all edx files - 8FED8D55

---