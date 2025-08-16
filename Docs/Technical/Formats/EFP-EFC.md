# EFP/EFC Container Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Name: Effects Format Pack
* Type: Container
* Extension: .efp
* Header: EFP
* Purpose: Stores multiple different types of data inside, most of which seem to be related to effects
* Notes:
	* Can contain multiple INSM mdls and PTMD ptms embedded with names
* Structure:
	* 0x18 - 24-byte first internal INSM mdl or PTMD ptm name string
	* 0x30 - Address of first internal INSM mdl structure

---

* Name: Effects Format Container
* Type: Container
* Extension: .efc
* Header: EFC
* Purpose: Alternative version of EFP found heavily inside of SCs.
* Notes:
	* Originally thought a unique type but `BTL\CHR\BCHR_CAT00` contains an EFP with multiple ESB files inside

---