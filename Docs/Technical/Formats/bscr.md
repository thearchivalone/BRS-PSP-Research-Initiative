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
	* Script Data values can be found in the padding data section; see Script structure section below
	* Each script file has a somewhat different structure based on purpose
	* Most of the models use the same scripting structure but EGG and BEE ones are buggy
* Structure:
	* 0x04 - 32-byte script file string name; first byte begins with any Ascii character followed by a blank space and then the full name of the bms file in the archive to write the script to
	* 0x24 - size of file
	* 0x2c - Address of function string start (All of 0x34 is here but separated by 0x2c bytes from the next one)
	* 0x34 - Address of scripting payload (You'll see a large chunk of text that includes multiple filenames from this directory and things like _INIT_ACTION_FROM here
	* 0x38 - Offset from the address that 0x3c leads to; if padding, this is the end of that or end of file
	* 0x3c - Address to end of scripting string chunk (can be padding, another file format or end of file)
* Script Data structure (starting from offsets at 0x2c to 0x34)
	* 0x00 - 2-byte Offset to next script string chunk (up to where 0x34 points to)
	* 0x02 - Unknown 2-byte value; usually 0xe0 or 0xe1 (but needs more testing)
	* 0x04 - 28-byte scripting function string
	* 0x24 - Unknown 4-byte value
	* 0x28 - Default initial value of function at 0x04
	* 0x2c - Same as 0x24 unless value is 0x81
---