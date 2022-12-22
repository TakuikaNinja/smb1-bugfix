smb1 disassembly but it has the PAL bugfixes, QoL improvements & more
========================================
There have been rumours that Rare was once working on a revision of SMB1 which could fit in a 16KiB PRG-ROM. We will probably never know if this was true but it does make one wonder - what could have been improved? This repo is my attempt at answering that question. 
None of this work is my own - I simply researched all the bugs/oddities I could find and fixed them to the best of my ability. See the special thanks section for the real contributors. 

so what's different?
========================================
See [changes.md](changes.md) for details. 

what hasn't changed?
========================================
- The game
- Every bug/oddity which either isn't documented well, or I lack the understanding/capacity to fix
- Visual glitches and lag caused by the "everything in NMI" approach used in this game (glitched scanlines, HUD flickering, etc). This will never change unless a coordinated effort is made to restructure the game logic. 
- The ROM file size & mapper type. This will also never change as I want to show that these improvements would have been possible in the 80's. 

special thanks
========================================
- Nintendo - for creating such a legendary yet broken game, plus their console line
- Rare & other 2nd/3rd party developers - for making accuracy a requirement in NES emulators
- 1wErt3r - for the orginal dissassembly: https://gist.github.com/1wErt3r/4048722
- Xkeeper0 - for the asm6f port which this is based off of: https://github.com/Xkeeper0/smb1
- Retro Game Mechanics Explained, Displaced Gamers, Bismuth, Kosmic & other YouTubers I may have missed - for making excellent videos about SMB1 oddities
- Every speedrunner, glitch-hunter, researcher & wiki contributor - for extensively breaking, researching & documenting the games they love
- Ribiveer - for originally doing some of the QoL improvements which got me interested in this project

(original readme) smb1 disassembly but it works with asm6f
========================================

based on the original smbdis.asm

https://gist.github.com/1wErt3r/4048722

	SMBDIS.ASM - A COMPREHENSIVE SUPER MARIO BROS. DISASSEMBLY
	by doppelganger (doppelheathen@gmail.com)

	This file is provided for your own use as-is.  It will require the character rom data
	and an iNES file header to get it to work.

	There are so many people I have to thank for this, that taking all the credit for
	myself would be an unforgivable act of arrogance. Without their help this would
	probably not be possible.  So I thank all the peeps in the nesdev scene whose insight into
	the 6502 and the NES helped me learn how it works (you guys know who you are, there's no 
	way I could have done this without your help), as well as the authors of x816 and SMB 
	Utility, and the reverse-engineers who did the original Super Mario Bros. Hacking Project, 
	which I compared notes with but did not copy from.  Last but certainly not least, I thank
	Nintendo for creating this game and the NES, without which this disassembly would
	only be theory.

	Assembles with x816.
