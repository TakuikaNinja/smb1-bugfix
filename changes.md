This file is based on the changes originally done by Ribiveer.

## Music Changes
- [ ] There is now music on the title screen: an alternate version of the underwater theme.
- [ ] The final victory song has been extended, with a B-section and an end.

## Bug Fixes & Small Tweaks
- [x] Scroll lock object in underground warpzone now works as intended. (no more minus world)
- [x] An erroneous increment of the warp zone value has been removed (1-2 warp zone pipe destination stays at 1-2 exit)
- [x] Lakitus now throw their spinies as originally intended.
- [x] Warm start detection & continue functions now check ContinueWorld for a valid value. (no more glitch worlds)
- [ ] Falling while crouching now keeps your sprite crouched.
- [ ] While underwater, crouching no longer messes up the hitbox.
- [x] Small Mario's walking animation now flows better.
- [ ] Stars are now guaranteed to jump out of their blocks, as opposed to sometimes falling down.
- [x] The lives system now uses the zero flag instead of the negative flag for game over detection. (no more 128 lives glitch)
- [ ] The lives counter now displays the number of lives above 9 like normal. (todo?)
- [ ] Lives are now capped at 99(?) to prevent overflows.
- [ ] The lives screen now properly reflects Mario's power-up state.
- [x] Player status is now correctly set to falling while collecting a power-up. (no more item jump)
- [ ] Getting the flagpole stops the star invincibility, to prevent audio glitches.
- [ ] Holding the run button while Fire Mario no longer makes him fire a fireball while entering an area.
- [ ] Holding the jump button no longer makes Mario jump while entering an area.
- [x] PlayerStatus & PlayerSize is now always kept in sync (no more Small Fire Mario)
- [x] FireballThrowingTimer & PlayerAnimTimer will now stay in sync (no more skating/sliding glitch)
- [ ] Faulty warp pipes have now been linked to Bowser's sewage system. (what?)
- [ ] Kicked shells now keep their momentum while going off a ledge.
- [x] The fortress in 5-1 has been changed to a castle, for consistency.
- [x] The bridge railing no longer overshoots the first gap in 2-3/7-3.
- [ ] Fire Mario and Fire Luigi now have separate palettes.
- [ ] Green Cheep Cheeps now appear green underwater.
- [ ] When entering a warp-pipe, Small Mario will now always stand still and Big Mario will now always crouch.
- [x] Both players can now always pause the game.
- [ ] The locations of some warp destination change and enemy despawn triggers have been tweaked.
- [ ] Scroll padding/centering is more robust (todo?)

## Modernised Quality of Life Mechanics
- [ ] Holding A now allows you to bounce on enemies higher, like in later entries.
- [x] Getting a Fire Flower as Small Mario now turns Mario into Fire Mario, as opposed to Super Mario.
- [x] Getting hit as Fire Mario now turns Mario into Super Mario, as opposed to Small Mario.
- [x] Hidden 1-up blocks no longer despawn after dying.
- [ ] Hitting the top of the flagpole now gives Mario a 1-up.
- [ ] Defeating consecutive enemies with a Super Star now gives you more points, eventually giving 1-ups!
- [ ] Defeating consecutive enemies now increases the sound effect pitch with every enemy.

## Enemy Behaviour Changes
- [x] Hammers now travel along their arc, regardless of whether they touch Mario.
- [x] Enemies like Goombas, Koopas, Buzzy Beetles and Spinies will no longer turn around when colliding with Mario.
- [ ] It is now possible to defeat Spinies by hitting blocks underneath them.

## PAL Version Changes
- [x] Cheep Cheep code has been optimised.
- [x] Pipes at the end of underwater levels now don't have an empty block above them.
- [x] The system that detects whether Mario has stomped an enemy has been improved.
- [x] Fixed springs being able to get overwritten in memory, or overwriting other memory.
- [x] Some enemies now have a slightly higher hitbox.
- [x] Bloopers are now able to go lower onscreen, therefore standing big Mario will be hit now.
- [x] Mario's initial downward acceleration is higher.
- [x] Springboard vertical acceleration is now defined (whatever that means).

## Graphics Changes
- [ ] Added small one-pixel graphics tweaks to Buzzy Beetles, Hammer Bros. and Toad.
- [ ] Made the outlines of bushes and clouds continuous.
- [ ] Utulised an extra sprite to add a small animation to Piranha Plants.
- [ ] Made Toad smile more :) (might revert this change honestly)
- [ ] The hands of Mario's growing sprite and jump sprite have been fixed. (partial)
- [ ] Hammer Bros. now bob up and down in their animation as well.
- [ ] Super Mario's jump sprite has been fixed to match the eyes and cap of the other sprites. (partial)
