# XTC Interface Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Extensible Text Container
* Type: Container
* Extension: .xtc
* Header: XTC
* Purpose: Render text on screen
* Notes:
	* Primarily related to user interface elements
	* Files can vary in size on disc depending on region and language
	* Text is allocated to the end of the data structure
* Data Typings:
	* \b(#) - Button text with event tied to it (such as changing a setting or zooming the camera in or out in the Gallery)
	* \z(#) - Zone text; zones include time of day variants of game stages
	* Untyped - Readable but not interactive
* Structure:
	* 0x08 - X ID

---