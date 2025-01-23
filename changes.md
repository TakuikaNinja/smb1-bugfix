This file is based on the changes originally done by Ribiveer.
Changes marked with '+' are new additions/contributions that were not part of Ribiveer's original set of changes.

## Repository Changes
+ [x] Added a Makefile equivilant of the build script.
+ [x] Updated the iNES header to NES2.0 and matched it with the nointro dump.
+ [x] Updated the ROM hash in build.sh with that of the nointro dump.
+ [x] Replaced CHR-ROM dump with a patch file for the graphical changes.
+ [x] Replaced the build script's "test" option with "patch", which produces a BPS patch. This requires the nointro dump and `flips`.

## Music Changes
- [x] There is now music on the title screen: an alternate version of the underwater theme.
- [x] The final victory song has been extended, with a B-section and an ending. (ported over from Vs.SMB; may need to adjust further)
+ [x] Level music now uses a smoother volume envelope from Vs.SMB (most noticable in castles). Other envelopes are left unchanged.
+ [x] Off-by-one errors in the initial envelope length counters have been corrected. (no more underwater pluck, sorry)
+ [x] Underground bonus areas will now use the Coin Heaven/Super Star music, following the same logic as SMAS.
+ [x] The underwater section of 8-4 now keeps the castle music, in line with SMAS.

## Sound Changes
- [x] Defeating consecutive enemies now increases the sound effect pitch with every enemy.
+ [x] Skidding now has a sound effect, in line with SMB2J and later entries.
+ [x] Springboards now make the block bump sound effect when bounced on, in line with SMM/SMM2.
+ [x] The unused notes at the beginning of the power-up sound have been restored, as originally intended.
+ [x] The 1-up sound now has top priority in its queue, fixing a bug where one sound can be initialized and play for a single frame, but continued as a corrupted 1-up sound.
+ [x] 1-up mushrooms no longer play the power-up sound for a single frame before the 1-up sound plays. (unrelated to the aforementioned bug).
+ [x] The warp-pipe sound effect will now also play when exiting vertical warp-pipes, in line with later entries.
+ [x] The timer countdown sequence and fireworks bonus will now wait until the level clear fanfare has finished playing.
+ [x] Sound effects will now play when hammers are thrown, in line with SMAS.
+ [x] Flying Cheep-Cheeps, Spinies, and Podoboos will now play sound effects when launched.
+ [x] Sound effects will now play when fireballs hit Buzzy Beetles or Bowser.
+ [x] Sound effects will now play when climbing vines.
+ [x] Sound effects will now play to indicate progress within castle maze levels, in line with SMBDX.

## Bug Fixes & Small Tweaks
+ [x] The scroll unlock objects in underground warp zones now work as intended. (no more minus world)
+ [x] An erroneous increment of the warp zone value has been removed. (1-2 warpzone pipe destination stays at 1-2 exit until warp zone loads)
+ [x] Flagpoles will no longer set the scroll lock. Instead, extra scroll lock objects have been added to prevent the player from running past the flagpole.
+ [x] Scroll lock objects now explicitly set the scroll lock instead of toggling it.
- [x] Lakitus now throw their spinies as originally intended.
+ [x] The initial number of lives is now set to 5 like in later entries, to compensate for the difficulty change.
+ [x] Warm start detection & continue functions now check ContinueWorld & WorldSelectEnableFlag for valid values. (no more glitch worlds)
- [x] Falling while crouching now keeps your sprite crouched. Additionally, the down input now nullifies left/right inputs while crouching on the ground.
- [x] While underwater, crouching no longer messes up the hitbox.
- [x] Small Mario's walking animation now flows better.
- [x] Super Stars are now guaranteed to jump out of their blocks, as opposed to sometimes falling down.
+ [x] The lives system now uses the zero flag instead of the negative flag for game over detection. (no more 128 lives glitch, even if you could reach it)
- [x] The lives counter now displays the number of lives above 9 like normal, until the 10's digit exceeds 9 in which it will be displayed as 👑 (crown).
- [x] Lives are now capped at 👑👑 (two crowns) to prevent overflows.
- [x] The lives screen now properly reflects Mario's power-up state.
- [x] Player status is now correctly maintained while collecting a power-up or getting injured. (no more item jump)
- [x] Getting the flagpole stops the Super Star invincibility, to prevent audio glitches.
+ [x] Super Star invincibility will no longer interfere with sideways warp-pipe sound effects. (primarily 4-2)
- [x] Holding the run button while Fire Mario no longer makes him fire a fireball while entering an area.
- [x] Holding the jump button no longer makes Mario jump while entering an area.
+ [x] PlayerSize is now changed immediately when PlayerStatus is changed. (no more Small Fire Mario, sorry)
+ [x] Dying and touching the axe at the same time will no longer decrease the player's lives. (you can still do this, though)
+ [x] Mario's palette and visibility will now be reset when time runs out. (i.e. no longer affected by Fire/Star status & injury timer)
+ [x] FireballThrowingTimer & PlayerAnimTimer will now stay in sync. (no more skating/sliding glitch)
+ [x] The interval timer control (primarily used for level completion framerules) now runs for 20 frames instead of 21.
- [x] Enemies & kicked shells now keep their momentum while going off a ledge. Some enemy placements were adjusted to compensate for this but oddities may still be visible.
+ [x] The offscreen bounds check will now check if the enemy is active first, to prevent enemies from being erased twice.
+ [x] The enemy's high Y coordinate is now checked instead of relying on addition overflow in SubtEnemyYPos. (e.g. enemies will no longer hover when stomped in pits)
+ [x] BlockBufferCollision will now account for over/underflow to prevent reading garbage data. (SubtEnemyYPos seems to have been an attempt to work around it)
+ [x] When Mario enters/exits a warp-pipe or falls into a pit, the gameplay will now halt in the same manner as being killed by an enemy. (prevents getting hit)
+ [x] Power-ups, jumping coins/blocks, shattered brick chunks, Bowser's flames, fireballs/explosions, bubbles, springboards, and growing vines will now properly halt in the above situations.
- [x] The fortress in 5-1 has been changed to a castle, for consistency.
+ [x] An off-by-one error in the enemy ID has been fixed in 5-3 to properly end the Bullet Bill frenzy. The redundant level object has also been removed. (moving platforms will now load consistently)
+ [x] The "end frenzy" object will now check if Lakitus are defeated before setting their states. (prevents instances of Lakitu revival)
+ [x] The pipe intro and exit screens now use the snow theme in 7-2.
+ [x] The bridge railing no longer overshoots the first gap in 2-3/7-3.
+ [x] 2-3/7-3 now have the water backdrop for better continuity from the previous level.
+ [x] Coin Heavens (cloud levels accessed via vines) now have the cloud backdrop.
+ [x] Dying while autoclimbing vines will no longer cause a vine to grow when respawing the player.
+ [x] Vines can no longer be grabbed once they are offscreen. (no more teleports)
+ [x] Vines are now horizontally centred relative to the block it grew out of.
+ [x] Mario can longer bump his head on climbable metatiles.
+ [x] The underwater section of 8-4 now uses the grey colour scheme for better continuity within the level.
- [x] Fire Mario and Fire Luigi now have separate palettes. (Luigi uses the palettes from SMM2)
- [x] Grey Cheep Cheeps now appear green underwater, in line with later entries.
+ [x] Underwater whirlpools are now only active at low hights.
+ [x] Underwater whirlpools are now less likely to pull Mario inside walls.
+ [x] Stomped Goombas can no longer be defeated again using a Super Star or shell.
+ [x] Mario can no longer stay inside enemies after the injury timer has expired.
- [x] After entering a horizontal warp-pipe, Small Mario will now always stand still and Big Mario will now always crouch. (hides visible pixels)
+ [x] Mario now only enters horizontal warp-pipes when pressing right. (i.e. residual speed will no longer cause pipe entries)
+ [x] The warp-pipe intro screens are now properly checked for when determining the area change timer. (i.e. transition timings will be consistent regardless of the camera's page location)
+ [x] When entering a vertical warp-pipe, Mario will now always stand still like in later entries.
- [x] Both players can now always pause the game. Some other input checks will also check for both players when appropriate.
+ [x] The locations of some warp destination change and loop command triggers have been tweaked. (no more wrong warps; notably 4-2, 8-4)
+ [x] Hidden coin/1up blocks no longer mess with the tile directly to its right. (notably 2-1, 5-1)
+ [x] The scroll handler has been overhauled and is now more robust. (e.g. getting ejected from a wall updates the scroll properly)
+ [x] Firebar blocks will no longer cause head injuries as big Mario.
+ [x] Firebar collision detection now checks the relative player position instead of querying the OAM buffer. (yes, really)
+ [x] Instances of recalculating the player's relative position have been replaced with variable reads when appropriate.
+ [x] Tweaked parameters of the PAL optimized Cheep Cheep code to better replicate the behavior of the NTSC version. (jump-height and gravity)
+ [x] Tweaked brick-shattering behavior to consistently bump the player downwards when hitting an enemy from below or shattering from the corner with high momentum.
+ [x] The shattered brick sprites will now appear even when the brick block is partially offscreen.
+ [x] Hitting enemies from under blocks near the left edge of the screen will no longer cause Koopas to appear.
+ [x] Bowser will no longer leave a lingering hitbox (which fireballs could hit) after being defeated with fireballs.
+ [x] Made floatey numbers (the score sprites) stay within the screen better. (less position under/overflows)
+ [x] Mario's sprite will no longer be cut off when he is pushed against the left screen edge by blocks or platforms.
+ [x] Momentarily "landing" in walls is now less likely, if not impossible for it to occur. (no more wall jump, sorry)
+ [x] Similarly, landing inside walls by jumping into a small gap at the screen edges is no longer possible.
+ [x] The logic for ejecting Mario from walls has been improved. (no more quick power-up grab, walking through walls, etc)
+ [x] Grabbing the flagpole while inside the base block will no longer skip the flag slide animation.
+ [x] Mario will now always fully slide down the flagpole. (no more advantage from grabbing it near the top)
+ [x] Fixed a case of the Y speed not being clamped when it should have been. (high byte > max Y speed && low byte < $80)
+ [x] The Game Text system has been overhauled and now utilises a command byte ($fe) to denote the player name.
+ [x] The routine for displaying victory messages in castle levels has been overhauled and now uses the Game Text system.
+ [x] Status bar updates which only change the score will no longer include the coin display. (reduces risk of VRAM buffer overflow)
+ [x] Sprite 0 (used for the status bar scroll split) is better hidden, and the scroll split timing has been adjusted to account for this.
+ [x] There is now a failsafe/recovery mechanism for NMI re-entries caused by sprite 0 detection misses. (1-frame glitches at worst, hopefully)
+ [x] RenderUnderPart now does the row check at the start of the loop to prevent out-of-bounds writes.
+ [x] Tiles with the coin palette will now always be overwritten in RenderUnderPart. (instead of only coin ? blocks)
+ [x] Ported a few miscellaneous tweaks, bug fixes, and optimizations from SMB2J, SMAS, Vs.SMB, and SMBDX.
+ [x] Tweaked controller reading code to mask out left+right/up+down inputs. Additionally, the polling loop now uses the ring counter technique.
+ [x] Moved the main game loop out of NMI and made the NMI handler more robust. (no more glitched scanlines, HUD flickering, or music slowdown)
+ [x] The reset handler has been tweaked to better resemble the sample implementation on NESdev Wiki.
+ [x] Optimized, tweaked, and trimmed code wherever possible. (ongoing effort)

## Modernised Quality of Life Mechanics
+ [x] Mario's physics have been tweaked to feel less stiff.
+ [x] Mario can no longer uncrouch while underneath a solid block.
- [x] Holding A now allows you to bounce on enemies higher, like in later entries.
- [x] Getting a Fire Flower as Small Mario now turns Mario into Fire Mario, as opposed to Super Mario.
- [x] Getting hit as Fire Mario now turns Mario into Super Mario, as opposed to Small Mario.
+ [x] Fireballs will now remain onscreen when Fire Mario has been hit. They will freeze during the hit animation, just like enemies do.
- [x] Hidden 1-up blocks will now always spawn.
- [x] Hitting the top of the flagpole now gives Mario a 1-up.
- [x] The scoring system has been adjusted to that of later entries.
- [x] Defeating consecutive enemies with a Super Star now gives you more points, eventually giving 1-ups!
+ [x] Mario will now start at a higher position when exiting vertical warp-pipes, making transitions faster.
+ [x] The timer countdown sequence is faster, in line with SMB3 and later entries.
+ [x] The timer countdown sequence now also occurs in castle levels, in line with SMB2J and later entries.
+ [x] Princess Peach will now give you bonus points for each remaining life, in line with SMB2J. Her text will pause to accomodate for this.
+ [x] Princess Peach's message will now be different if you beat the second quest, in line with SMBDX.

## Enemy Behaviour Changes
- [x] Hammers now travel along their arc, regardless of whether they touch Mario.
+ [x] Hammers hitboxes now behave more consistently.
- [x] Enemies like Goombas, Koopas, Buzzy Beetles and Spinies will only turn around when colliding with walls or other enemies.
- [x] It is now possible to defeat Spinies by hitting blocks underneath them.
+ [x] Paratroopas will now be set to the falling state instead of the grounded state when stomped. 
+ [x] Red Paratroopas will now be properly demoted to Red Koopas when stomped.
+ [x] Stomped Goombas will now stay in midair, like later entries.
+ [x] Bullet Bills fired from cannons and those spawned from frenzy objects now behave more similarly, including enemy collisions.
+ [x] Handling of Bullet Bills launched by cannons are no longer delayed by 1 frame. (no more Phantom Bullet Bills)
+ [x] Hammer Bros can now be defeated reliably using kicked shells.
+ [x] Jumping Green Paratroopas now move faster in Quest 2 and demote to the appropriate speed in Quest 2.
+ [x] Swimming Cheep Cheeps now move up and down farther after 5-3.
+ [x] Lakitus respawn more quickly after 5-3. Additionally, they will now always spawn at the correct height with the correct hitbox.
+ [x] Podoboos now jump higher, as seen in SMAS.
+ [x] Piranha Plants are now slightly braver, as seen in SMBDX. (the range for staying inside pipes is smaller)
+ [x] Piranha Plants are now able to collide with enemies, including kicked shells.
+ [x] Bowser's flames now use the larger hitbox from SMBDX.
+ [x] Platforms moving downwards will now properly drop the player into pits.
+ [x] Moving Platforms now behave as semi-solid platforms, in line with SMM/SMM2.
+ [x] Small Moving Platforms are now moved before they are drawn, eliminating visual inconsistencies.
+ [x] Balance Platforms now have more checks in place to prevent collision oddities (notably 4-3).
+ [x] Balance Platforms will no longer move if the left platform has been unloaded, or has been replaced by another enemy. (prevents the 6-3 "Bullet on a string" glitch)
+ [x] Landing on Moving Platforms will now clear the stomp chain counter.
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
