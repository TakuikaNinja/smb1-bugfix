smb1 disassembly but it has the PAL bugfixes, QoL improvements & more
========================================
There have been rumours that Rare was once working on a revision of SMB1 which could fit in a 16KiB PRG-ROM. We will probably never know if this was true but it does make one wonder - what could have been improved? This repo is my attempt at ansering that question. 
None of this work is my own - I simply researched all the bugs/oddities I could find and fixed them to the best of my ability. See the special thanks section for the real contributors. 

so what's different?
========================================
- Implemented all bugfixes from the PAL release (excluding 8-2 paratroopa placement, hitbox & framerate specific changes)
- Scroll lock object in underground warpzone works as intended + erroneous increment of warp zone value removed (no more minus world)
- Spiny egg throwing logic is fixed (has horizontal movement)
- Warm start detection & continue functions now check ContinueWorld for a valid value (no more glitch worlds)
- 5-1 starting castle is the correct 3-tier one (like other levels starting a world beyond world 1)
- 2-3/7-3 bridge railing no longer overshoots at the first gap
- Reordered small mario walk cycle so it flows better
- Added "missing" pixels in big mario jump sprite
- Keep PlayerStatus (power-up) & PlayerSize (big/small) in sync when taking damage (no more small fiery mario)
- Getting hit as fiery mario will only downgrade to super mario (like modern entries)
- Keep FireballThrowingTimer & PlayerAnimTimer in sync (no more skating/sliding glitch)
- and more to come?

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
- Retro Game Mechanics Explained, Displaced Gamers & Kosmic - for making excellent videos about SMB1 oddities
- Every speedrunner, glitch-hunter, researcher & wiki contributor - for extensivly breaking, researching & documenting the games they love
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
