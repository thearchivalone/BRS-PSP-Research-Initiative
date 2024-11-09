![BRS The Game Logo](https://i.pcmag.com/imagery/articles/00TDe6o92GcpKxsquqx6JK7-1.fit_lim.v1569485038.jpg)

This repository will host my findings and various scripts, tools and documentation I've put together from diving into [Black Rock Shooter: The Game](https://web.archive.org/web/20150328084959/http://brs.jrpg.jp/) for the Playstation Portable handheld console. It's a work in progress and contributions are welcomed. All that I ask is that any projects that use anything from this repository will link back here and not claim ownership of anything within.

=====================================================================
## How to Extract the Game Files for Beginners

* Download and install a modern version of Windows Powershell: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4

* Copy the `PSP_GAME` directory from a ripped and extracted release of Black Rock Shooter: the Game into the `Game` folder in this directory

* Open the folder this Directory is in and right-click->Open in Terminal

* Run: `.\BRS-Extract.ps1`

* If you don't have the `Tools` directory or any of the tools installed, it will ask you if you want to download and install them. Type 'y' for yes. This should be the only time you'll need to input anything.

* Wait for the script to finish. It can take 15+ minutes due to just how many files there are.

* NOTE: Depending on your security settings, Windows may say it can't run Powershell scripts. If this happens, you'll either need to run the script with elevated privileges or temporarily set your policy to allow it. See [here](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4) for more information

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

* Game - Where the game files go

* Scripts - QuickBMS scripts can be found here. See accompanying README in the directory and notes in the script if you need to learn how to use them. Also, feel free to open an issue and / or pull request (if you want to improve the documentation) if they're not clear enough.

* Specifications - The documentation here is meant to be more for tool makers, modders and developers. It's all technical and deals heavily with memory structures of different formats, encryption, etc.

* Tools - Where the tools are downloaded and installed for extracting the game files; right now, this only supports Windows but shouldn't be super hard to get working on the BSDs, Linux, Mac, etc

* Assets - When running the automatic extraction script, any sound files, models, and possibly other asset types will be found in their own directories here. This is for convenience but do note that on subsequent extractions, there will be duplicates of everything unless you remove or move this folder somewhere else

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