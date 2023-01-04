This file is based on the changes originally done by Ribiveer.
Changes marked with '+' are new additions/contributions that were not part of Ribiveer's original set of changes.

## Music Changes
- [ ] There is now music on the title screen: an alternate version of the underwater theme.
- [x] The final victory song has been extended, with a B-section and an ending. (ported over from Vs.SMB; may need to adjust further)
+ [x] Level music now uses a smoother volume envelope from Vs.SMB (most noticable in castles). Other envelopes are left unchanged.

## Sound Changes
+ [x] Skidding now has a sound effect, in line with SMB2J and later entries.
+ [x] Springboards now make the block bump sound effect when bounced on, in line with SMM/SMM2.
+ [x] The unused notes at the beginning of the power-up sound have been restored, as originally intended.
+ [x] The 1-up sound now has top priority in its queue, fixing a bug where one sound can be initialized and play for a single frame, but continued as a corrupted 1-up sound.
+ [x] 1-up mushrooms no longer play the power-up sound for a single frame before the 1-up sound plays. (unrelated to the aforementioned bug).

## Bug Fixes & Small Tweaks
+ [x] Scroll lock object in underground warp zone now works as intended. (no more minus world)
+ [x] An erroneous increment of the warp zone value has been removed. (1-2 warpzone pipe destination stays at 1-2 exit until warp zone loads)
- [x] Lakitus now throw their spinies as originally intended.
+ [x] Warm start detection & continue functions now check ContinueWorld for a valid value. (no more glitch worlds)
- [x] Falling while crouching now keeps your sprite crouched. Additionally, the down input now nullifies left/right inputs while crouching on the ground.
- [x] While underwater, crouching no longer messes up the hitbox.
- [x] Small Mario's walking animation now flows better.
- [x] Stars are now guaranteed to jump out of their blocks, as opposed to sometimes falling down.
+ [x] The lives system now uses the zero flag instead of the negative flag for game over detection. (no more 128 lives glitch, even if you could reach it)
- [x] The lives counter now displays the number of lives above 9 like normal, until the 10's digit exceeds 9 in which it will be displayed as 👑 (crown).
- [x] Lives are now capped at 👑👑 (two crowns) to prevent overflows.
- [ ] The lives screen now properly reflects Mario's power-up state.
- [x] Player status is now correctly set to falling while collecting a power-up. (no more item jump)
- [x] Getting the flagpole stops the star invincibility, to prevent audio glitches.
- [x] Holding the run button while Fire Mario no longer makes him fire a fireball while entering an area.
- [x] Holding the jump button no longer makes Mario jump while entering an area.
+ [x] PlayerStatus & PlayerSize is now kept in sync when getting hit on the same frame as touching the axe. (no more Small Fire Mario, sorry)
+ [x] Dying on the same frame as touching the axe no longer decrements the lives counter. (you can still do this without penalty, though)
+ [x] FireballThrowingTimer & PlayerAnimTimer will now stay in sync. (no more skating/sliding glitch)
- [x] Enemies & kicked shells now keep their momentum while going off a ledge. Some enemy placements were adjusted to compensate for this but oddities may still be visible.
- [x] The fortress in 5-1 has been changed to a castle, for consistency.
+ [x] The bridge railing no longer overshoots the first gap in 2-3/7-3.
- [x] Fire Mario and Fire Luigi now have separate palettes. (Luigi uses the palettes from SMM2)
- [x] Green Cheep Cheeps now appear green underwater. (they are still called grey internally)
- [x] When entering a horizontal warp-pipe, Small Mario will now always stand still and Big Mario will now always crouch.
+ [x] When entering a vertical warp-pipe, Mario will now always stand still like in later entries.
- [x] Both players can now always pause the game. Some other input checks will also check for both players when appropriate.
+ [x] The locations of some warp destination change and loop command triggers have been tweaked. (no more wrong warps; notably 4-2, 8-4)
+ [x] Hidden coin/1up blocks no longer mess with the tile directly to its right. (notably 2-1, 5-1)
+ [ ] Scroll padding/centering is more robust. (todo?)
+ [x] Tweaked parameters of the PAL optimized Cheep Cheep code to better replicate the behavior of the NTSC version. (jump-height and gravity)
+ [x] Tweaked brick-shattering behavior to consistently bump the player downwards when hitting an enemy from below or shattering from the corner with high momentum.
+ [x] Ported a few miscellaneous tweaks, bug fixes, and optimizations from SMB2J, SMAS, and Vs.SMB.
+ [x] Moved the main game loop out of NMI and added proper interrupt and lag frame handling to the NMI routine.
+ [x] Optimized, tweaked, and trimmed code wherever possible. (ongoing effort)

## Modernised Quality of Life Mechanics
- [x] Holding A now allows you to bounce on enemies higher, like in later entries.
- [x] Getting a Fire Flower as Small Mario now turns Mario into Fire Mario, as opposed to Super Mario.
- [x] Getting hit as Fire Mario now turns Mario into Super Mario, as opposed to Small Mario.
+ [x] Fireballs will now remain onscreen when Fire Mario has been hit. They will freeze during the hit animation, just like enemies do.
- [x] Hidden 1-up blocks no longer despawn after dying. The requirement to spawn them has been retained.
- [ ] Hitting the top of the flagpole now gives Mario a 1-up.
- [ ] The scoring system has been adjusted to that of later entries.
- [ ] Defeating consecutive enemies with a Super Star now gives you more points, eventually giving 1-ups!
- [ ] Defeating consecutive enemies now increases the sound effect pitch with every enemy.

## Enemy Behaviour Changes
- [x] Hammers now travel along their arc, regardless of whether they touch Mario.
- [x] Enemies like Goombas, Koopas, Buzzy Beetles and Spinies will only turn around when colliding with walls or other enemies.
- [x] It is now possible to defeat Spinies by hitting blocks underneath them.
+ [x] Paratroopas will now be set to the falling state instead of the grounded state when stomped. 
+ [x] Red Paratroopas will now be properly demoted to Red Koopas when stomped.
+ [x] Bullet Bills fired from cannons are now able to collide with enemies, including kicked shells. (notably 7-1, now you can farm lives there)
+ [x] Jumping Green Paratroopas now move faster in Quest 2 and demote to the appropriate speed in Quest 2.
+ [x] Swimming Cheep Cheeps now move up and down farther after 5-3.
+ [x] Lakitus respawn more quickly after 5-3.
+ [x] Enemies will now clear more of their variables when unloading, in order to minimize oddities. (e.g. Collecting a star when it has negative Y speed no longer causes mushrooms to jump)

## PAL Version Changes
- [x] Cheep Cheep code has been optimised.
- [x] Pipes at the end of underwater levels now don't have an empty block above them.
- [x] The system that detects whether Mario has stomped an enemy has been improved.
- [x] Fixed springs being able to get overwritten in memory, or overwriting other memory.
- [x] Some enemies now have a slightly higher hitbox.
+ [x] Bloopers are now able to go lower onscreen, therefore standing big Mario will be hit now.
+ [x] Mario's initial downward acceleration is higher.
- [x] Springboard vertical acceleration is now defined. (whatever that means)

## Graphical Changes (IPS patch required)
- [x] Added small one-pixel graphics tweaks to Buzzy Beetles, Hammer Bros. (including hammers), and Toad.
+ [x] Tweaked Koopa & Buzzy Beetle shells to look like their SMM2 counterparts. 
+ [x] Bowser's flames have been mirrored.
- [x] Made the outlines of bushes and clouds continuous.
+ [x] The top half of Goombas are now mirrored to save a tile. (based on Ribiveer's sprite optimisations)
- [x] Utulised an extra sprite to add a small animation to Piranha Plants.
- [x] Made Toad smile more. :)
- [x] The hands of Mario's growing sprite and jump sprite have been fixed.
- [x] Hammer Bros. now bob up and down in their animation as well.
- [x] Super Mario's jump sprite has been fixed to match the eyes and cap of the other sprites.
+ [x] Blank tiles ($fc) are now kept offscreen to ease the 8 sprites per scanline limit.
