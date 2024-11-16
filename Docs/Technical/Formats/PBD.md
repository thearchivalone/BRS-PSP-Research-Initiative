# PBD Data Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Probably Bad Data
* Type: Debug
* Extension: .pbd
* Header: Variable 4-byte with at least one single Ascii Character
* Purpose: Contain data that could be anything, but most likely is debug related or for padding between elements in a container
* Structure:
	* 0x04 (2 bytes) - U ID
	* 0x08 - X ID + 0x01

---