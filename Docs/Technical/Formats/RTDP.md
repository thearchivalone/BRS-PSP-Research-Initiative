# RTDP Volume Archive Format Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

* Tentative Name: Rudimentary Typed Data Pack
* Type: Data archive
* Extension: .vol
* Header: RTDP
* Purpose: Store vast majority of the game's data
* Notes:
	* Compression is on a per file basis and often are found within internal BIN, LPK, and PTMD archives
	* Files in all caps are typically upper level archive files
	* Lower case files (example: pack.vol from SYSTEM.VOL) are suspicious files that need to be examined further (this applies to all file types)
	* These are also hidden data files (must be decrypted); the names of the files listed and anything past the EOF section can be encrypted data (hence some of the weird file names and / or specific sizes of files within their respective archives)
* Structure:
	* 0x04 - Offset to Encrypted Data Section (varies per archive)
	* 0x08 - Number of files within the archive (extremely important for decryption)
	* 0x0c - Total file size of archive (not that important now that decryption has been figured out)
	* 0x10 - The first byte here seems to be the main encryption key for everything; the other bytes might be backups
	* 0x20 - File list starts here; each name takes up 32 bytes
	* For every file listed, it follows this structure (offset used instead of specific address and begins 32 bytes after the start)
		* 0x04 - Data Offset from the start of the Encrypted Data Section
		* 0x08 - Data Size after extraction; may be compressed in some instances but so far that has been on a file by file basis within nested archives

---