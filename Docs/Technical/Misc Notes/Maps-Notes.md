# Maps Notes

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

 ---

This documentation is meant to be a simple way to convey concepts based on my observations related to how the maps are structured that aren't necessarily set in stone or  fully supported by the data in the game's files. There will be theories and speculation in this that can always be revised later on.

---

* Map coordinates consist of 5 different coordinates (bones and models may use a similar system)

  * X

  * Y

  * Z

  * ZS - Looks like this is how they calculated cheap memory light fog and lod

  * ZE - This could be radial fog (more resource intense but also more accurate) and use a Euclidian scale for its calculations (hense the E in ZE)