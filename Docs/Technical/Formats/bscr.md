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
* Structure:
	* 0x04 - 32-byte script file string name; first byte begins with any Ascii character followed by a blank space and then the full name of the bms file in the archive to write the script to
	* 0x34 - Offset to scripting payload (You'll see a large chunk of text that includes multiple filenames from this directory and things like _INIT_ACTION_FROM here
	* 0x38 - Offset from the address that 0x3c leads to; Use this to move to where EDXD starts
	* 0x3c - Script File Offset in VOL (can be used as the size when writing to file)

---