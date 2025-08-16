# SC Model Container Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Name: Skeletal Container
* Type: Container / 3D Pipeline Data
* Extension: .sc
* Header: SC
* Purpose: Houses the main models, riggings and animation data
* Notes:
	* SC's have a multilevel hierarchy based on the bit value of the byte after the header
* Structure:
	* 0x00 - (2-bytes) Header + (1-byte) Hierarchy level + 0 = Magic Number
		* Hierarchy (by Bit Flag; rest are internals)
			* 0x80 (Bit8) - Unknown
			* 0x40 (Bit7) - Field Event Armateur Skeleton (Internal to 0x10)
			* 0x3D - Field Object/Enemy Armateur Skeleton (Probably destructable or interactive)
			* 0x34 - Field Player Character Armateur Skeleton
			* 0x20 (Bit6) - Field Map EFC Skeleton
			* 0x1D - Field SUM00P Armateur Skeleton
			* 0x16 - Field Enemy Armateur Skeleton
			* 0x14 - Field Skill (?) Armateur Skeleton
			* 0x10 (Bit4) - Field Event/Map Skeleton Top Level (Probably related to Cutscenes) - Can contain multiple 0x40 SC's / SSCR's
			* 0x0A - Field SUM00 Armateur Skeleton
			* 0x0B - Field SUM Armateur Skeleton (Rest of SUM's use this + RID Gimmicks)
			* 0x0C - Field Test Enemy Armateur Skeleton
			* 0x09 - Same as 0x03 (Multiple TEST FEVTs)
			* 0x08 (Bit 3) - Field Character/Map Skeleton Top Level (Can contain an internal STCM if a Map)
			* 0x04 (Bit2) - Unknown
			* 0x03 - Test Field Event with BTL Model data (FEVT_TEST_AOIK00)
			* 0x02 (Bit1) - Field Event PHD Skeleton
			* 0x01 (Bit0) - Field Character Skeleton Without Armateur
			* 0x00 - Field Event Unused SC data + types (FEVT_TEST_KAMI00) - There were multiple different data types unique to this section found here

	* 0x04 - Internal Container list start - Can be 0x3c for some models; that's a bug that doesn't seem to affect the game but will break the extraction process
	* 0x08 - First internal object ends here but not guaranteed to help with any extra extraction
	* 0x10 - 0x28 - These vary but the bigger value of these is usually the file/chunk total size
	* The rest of this section is variable based on how big the SC container is, so may have to wing it quite a bit to get anything extracted

---