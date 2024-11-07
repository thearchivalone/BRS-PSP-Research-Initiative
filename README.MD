![BRS The Game Logo](https://i.pcmag.com/imagery/articles/00TDe6o92GcpKxsquqx6JK7-1.fit_lim.v1569485038.jpg)

This repository will host my findings and various scripts, tools and documentation I've put together from diving into [Black Rock Shooter: The Game](https://web.archive.org/web/20150328084959/http://brs.jrpg.jp/) for the Playstation Portable handheld console. It's a work in progress and contributions are welcomed. All that I ask is that any projects that use anything from this repository will link back here and not claim ownership of anything within.

=====================================================================
## Recommended Tools

* [QuickBMS](https://aluigi.altervista.org/quickbms.htm) - for running any scripts labeled with the `.bms` extension.

* [Cheat Engine](https://cheatengine.org) - for reading the game memory

* [PPSSPP](https://www.ppsspp.org/) - for playing the game (although, any PSP emulator or even the real hardware with proper tools should work)

* [HxD](https://mh-nexus.de/en/hxd/) - for reading the binaries and figuring out the structures of the game's internal workings

* [7-zip](https://www.7-zip.org/) - for extracting the game disc mostly. All of the main archive types can be extracted with BRS-extract.bms without the need of external tools.

* [Vgmstream-cli](https://github.com/vgmstream/vgmstream) - for converting at3 files into a user playable format

=====================================================================
## Optional Tools

* [Offzip](https://aluigi.altervista.org/mytoolz/offzip.zip) - for extracting data from ZZZ archives; extraction script should work with all of these without issues now

=====================================================================
## Navigating This Repository

The folder structure is meant to be pretty straight forward, but here's what they represent:

* Disc Map - To help find specific files on the disc without having to fully navigate each directory. If a file is an archive or container, the "Contents" of them will be listed once extracted (unless unnecessary).

* Scripts - QuickBMS scripts can be found here. See accompanying README in the directory and notes in the script if you need to learn how to use them. Also, feel free to open an issue and / or pull request (if you want to improve the documentation) if they're not clear enough.

* Specifications - The documentation here is meant to be more for tool makers, modders and developers. It's all technical and deals heavily with memory structures of different formats, encryption, etc.

=====================================================================
## Current TODO

- [ ] Automate and document the full extraction process

- [ ] Document the full disc structure

- [ ] Set up tools for rebuilding the data structure for use in game

=====================================================================

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*