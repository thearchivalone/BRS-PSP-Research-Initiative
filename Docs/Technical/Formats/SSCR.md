# SSCR Scripting Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Scripted Skeletal Character Rigging
* Type: 3D Pipeline Data
* Extension: .ss
* Header: SSCR
* Purpose: Controls the animation and armatures for animated 3D Models
* Notes:
	* This was first discovered on a random hunch while out for food. A quick script to check for vertex values found BRS's model pretty quickly under the `BTL\FLD\FCHR` directory
	* Often found inside of SC containers
* Structure:
	* 0x0c - Scripted Data Section Start
	* 0x10 - Scripted Data String End Address
	* 0x14 - Scripted Data Section End Address
	* 0x18 - SSCR Data End Address (Everything below is padding)
	* 0x2c - Scripted Data String Start Address

---