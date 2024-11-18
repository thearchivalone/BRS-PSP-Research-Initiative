# 3 D Pipeline, Rigging and Animation Observations

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

 ---

This documentation is meant to be a simple way to convey concepts based on my observations related to how the game's rendering system works with a heavy focus on the 3D rendering pipeline and design decisions. It's a fluid document and will be changed where needed as new discoveries are found but hopefully will help others understand how the game was built.

---

* Models may be built on quads using a single straight line from one corner to the opposite and filling in the other corners by alternating which x and y go where in each end coordinates

* Extracting most of the internal files like lpks, efps, etc is probably not the best way to handle them since they are essentially the entire model package shredded into smaller pieces so that they can be swapped out and reused when needed for battles; much of the data needed for converting to a more friendly format won't be found in just one part of each but instead spread out a bit.

* Outside of the SSCR sections of SC containers, most of the scripting language used in the `bms` files are exclusive to combat meaning that figuring out how the scripting system works would be less important to rendering and more gameplay related, although, they do tell what modules are used where in each encounter; this could theoretically help stitch together the pieces required to make a functional battle model that modders can work with

* Most of the modularization is exclusive to the the battle system but figuring out how everything interacts there applies to anything on the field or in the gallery (which uses meshes and materials for their assets)

* Cameras and the maps themselves are built on the same general rigging system as the models

* The formats used for storing assets are non-standard but do seem to have a fairly strict structure with some having shared general locations of tables and other important data

* Some of the interface elements may be 3D but are viewed as 2D, so any discoveries related to character models should apply here