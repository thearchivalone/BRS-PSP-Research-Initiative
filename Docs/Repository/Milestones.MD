# Milestone Docs

---

*Copyright 2024 - Brad D*

*See LICENSE for copyright information.*

*Please include this header and that license for any derivative works.*

*NOTE: Only the documentation, tools and anything that's not directly a part of the game's data fall under this copyright. I don't claim any ownership of the game or any of its assets*

---

This document is intended to give structure to my process and the steps I've mapped out in my mind for this project. Before I go any further, a definition is in order: a milestone for me is not necessarily the end to my journey or me reaching a set goal but instead a point where a big revelation was uncovered or something was mostly set in stone.

1. Have enough base tools set up that I can tear into data with vigor and you can join me if you choose. Most of the extraction code right now is set in stone and not going to have too much changed until it's needed.

2. Find a specific part of the game that could act as a foundation for the next milestone or two. After looking at enough battle data and discovering how the models and animations were handled, I chose to make the 3D models and rendering systems my core priority because they are currently the most time consuming parts to get through.

3. Work on both improving the documentation and base structures of the repository and incrementally progressing with the part chosen from milestone 2. This is also a good time to start setting up backups (like repository mirrors and at least one non-version control archival system).

4. Put my discoveries in practice in a consumable, visual way. Getting something in Blender and then dressing it up like a doll sounds like both a good time and also can lead to testing mechanics and making visual modifications in real time. Having control over what the models can do during something like say combat means being to able test the enemy ai scripting a bit and other systems in the game. This will hopefully be the milestone where some of the texture data and the majority of the modeling system has been figured out.

5. Tear into the mapping systems more. They weren't a high priority early on because they connect most of the other systems on a large scale. I'm building up to being able to immediately look at parts of the data and watch the events of the game without having to fully play it if that makes sense.

6. This milestone will be heavily dependent on the previous ones. If I'm lucky, there will be enough data at this point that I could theoretically start remaking the game from scratch. I hope to have the battle system fully figured out by this point and know what all is going on with the models.

7. Work towards properly having modding tools available at this time. The biggest hurdle at my current step is that most of the file formats can't be parsed or modified in a form that the game can probably use.

8. Whatever's left over, grab it. The user interface, gallery and things like the minimap are all going to come towards the end. I could get some of them heavily figured out right now but I plan to save them for when I need to consolidate my documentation; I want my findings to be useful for as long as the community wants to preserve the game.

---

Anything past milestone 4 is heavily subject to change. If someone wants to have a crack at the PTMD texture format while I continue with the bone, rigging and mesh generation dissection I'm currently working on, that would immediately allow access to the interface, gallery and some of the other visual elements. The scripting system should be safe to look at too. I'm using some of it right now but most of it seems pretty independent from the other systems.
