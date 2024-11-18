# Bones Notes, Theories and Random Observations

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

 ---

This documentation is meant to be a simple way to convey concepts based on my observations related to how the bones are structured that aren't necessarily set in stone or  fully supported by the data in the game's files. There will be theories and speculation in this that can always be revised later on.

---

* Possibly built using the math chain found early on in the INSA structure; if so, vector math was used to rotate a straight line of an even amount from a central location with each calculation being a straight line from one point to the next on the edge to create a polygonal base. Then, they extrude the center point to a predetermined height and apply rotation and / or a shift in position to match the mesh on the model

* Bone groups don't seem to have a set form of identification built into the data, so I tested how much padding (garbage data created to fill up space) was used to offset each bone from the next; whatever algorithm they used for the player and boss models (the rest of the models are up in the air on how much padding was used where if at all) was used on an array of bones that all belong together. See `Technical\Models\Field\FCHR_B_NAF00P.MD` for the first example of this discovery

	* Note: the final bone in some models may be a part of a different group if the amount of padding at the end is variable. For her Arms, the padding had an 8-byte offset from the end of the file but others may require specific checks to get right. I'll save that step for a more permanent solution (like moving the notes to a spreadsheet) down the road

	* Assume that the final bone is a part of the group it should be in if there's one missing

* Outside of Zig and possibly a small handful of other models, most use a blanket calculation chain early on in their data for their bones; the members of bone groups (such as fingers on a hand) should be all of equal length, size and depth due to the same generation mechanisms (theoretical) being used for them. The only real differences I've noticed would the amount of space taken up by each bone's data being variable

* If bones aren't generated like I assume, then an alternative way could be protruding from a central point to each corner using a variable length; bones would look like a cross between a Fidget Spinner, a cone and a thumb tack in this scenario (could be way off there but that's what I'm invisioning in this scenario)