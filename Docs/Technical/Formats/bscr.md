# bscr Scripting Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: bRS scrIPTING BMS
* Extension: .bms
* Header: bscr
* Purpose: The core scripting language for handling a variety of tasks that don't need to be performed using C / C++.
* Notes:
	* These have some kind of offset mechanism that ties the string name to the function data
	* Each script file has a somewhat different structure based on purpose
* Structure:
	* 0x04 - 32-byte script file string name; first byte begins with any Ascii character followed by a blank space and then the full name of the bms file in the archive to write the script to
	* 0x2c - Offset from header to function string start (All of 0x34 is here but separated by 0x2c bytes from the next one)
	* 0x34 - Offset to scripting payload (You'll see a large chunk of text that includes multiple filenames from this directory and things like _INIT_ACTION_FROM here
	* 0x38 - Offset from the address that 0x3c leads to; if padding, this is the end of that or end of file
	* 0x3c - Offset from header to end of script data (can be padding, another file format or end of file)

---