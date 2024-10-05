; ==================================================================================================================================
; ----------------------------------------------------------------------------------------------------------------------------------
; Super Mario Bros. Bugfix Disassembly
; ----------------------------------------------------------------------------------------------------------------------------------
; Sound Engine Source File
;
; Formatting:
; - Width: 132 Columns
; - Tab Size: 4, using tab
; - Comments: Column 57
; ----------------------------------------------------------------------------------------------------------------------------------

; ==================================================================================================================================
; ----------------------------------------------------------------------------------------------------------------------------------
; Sound Engine Entry Point
; ----------------------------------------------------------------------------------------------------------------------------------

SoundEngine:
		lda #$ff
		sta JOYPAD_PORT2								; manually tick APU frame counter to maintain sync
		
		lda #$0f
		sta SND_MASTERCTRL_REG							; enable first four channels
		
		lda PauseModeFlag								; is sound already in pause mode?
		bne InPause
		
		ldx PauseSoundQueue								; if not, check pause sfx queue
		dex
		bne RunSoundSubroutines							; if queue is empty, skip pause mode routine

; ==================================================================================================================================
; ----------------------------------------------------------------------------------------------------------------------------------
; Pause Sound Handler
; ----------------------------------------------------------------------------------------------------------------------------------

InPause:
		lda PauseSoundBuffer							; check pause sfx buffer
		bne ContPau
		
		lda PauseSoundQueue								; check pause queue
		beq SkipSoundSubroutines
		
		sta PauseSoundBuffer							; if queue full, store in buffer and activate
		sta PauseModeFlag								; pause mode to interrupt game sounds
		
		lda #$00										; disable sound and clear sfx buffers
		sta SND_MASTERCTRL_REG
		sta Square1SoundBuffer
		sta Square2SoundBuffer
		sta NoiseSoundBuffer
		
		lda #$0f
		sta SND_MASTERCTRL_REG							; enable sound again
		
		lda #$2a										; store length of sound in pause counter
		sta Squ1_SfxLenCounter

PTone1F:
		lda #$44										; play first tone
		bne PTRegC										; [unconditional branch]

; ----------------------------------------------------------------------------------------------------------------------------------

ContPau:
		lda Squ1_SfxLenCounter							; check pause length left
		cmp #$24										; time to play second?
		beq PTone2F
		
		cmp #$1e										; time to play first again?
		beq PTone1F
		
		cmp #$18										; time to play second again?
		bne DecPauC										; only load regs during times, otherwise skip

PTone2F:
		lda #$64										; store reg contents and play the pause sfx

PTRegC:
		ldx #$84
		ldy #$7f
		jsr PlaySqu1Sfx

DecPauC:
		dec Squ1_SfxLenCounter							; decrement pause sfx counter
		bne SkipSoundSubroutines
		
		lda #$00										; disable sound if in pause mode and
		sta SND_MASTERCTRL_REG							; not currently playing the pause sfx
		
		lda PauseSoundBuffer							; if no longer playing pause sfx, check to see
		lsr												; if we need to be playing sound again
		beq SkipPIn
		
		lda #$00										; clear pause mode to allow game sounds again
		sta PauseModeFlag

SkipPIn:
		lda #$00										; clear pause sfx buffer
		sta PauseSoundBuffer
		beq SkipSoundSubroutines

; ==================================================================================================================================
; ----------------------------------------------------------------------------------------------------------------------------------
; Main Playback Routine
; ----------------------------------------------------------------------------------------------------------------------------------

RunSoundSubroutines:
		lda OperMode									; if on title screen,
		beq NoSFX										; skip SFX
		
		jsr Square1SfxHandler							; play sfx on square channel 1
		jsr Square2SfxHandler							; '''''' square channel 2
		jsr NoiseSfxHandler								; '''''' noise channel

NoSFX:
		jsr MusicHandler								; play music on all channels
		
		lda #$00										; clear the music queues
		sta AreaMusicQueue
		sta EventMusicQueue

SkipSoundSubroutines:
		lda #$00										; clear the sound effects queues
		sta Square1SoundQueue
		sta Square2SoundQueue
		sta NoiseSoundQueue
		sta PauseSoundQueue
		
		ldy DAC_Counter									; load DAC counter
		lda AreaMusicBuffer
		and #%00000011									; check for specific music
		beq NoIncDAC
		
		inc DAC_Counter									; increment and check counter
		cpy #$30
		bcc StrWave										; if not there yet, just store it

NoIncDAC:
		tya
		beq StrWave										; if we are at zero, do not decrement

		dec DAC_Counter									; decrement counter

StrWave:
		sty SND_DELTA_VAL								; store into delta counter (abuse non-linear mixing)
		rts												; we are done here

; ----------------------------------------------------------------------------------------------------------------------------------

Dump_Squ1_Regs:
		sty SND_SQUARE1_REG+1							; dump the contents of X and Y into square 1's control regs
		stx SND_SQUARE1_REG
		rts

PlaySqu1Sfx:
		jsr Dump_Squ1_Regs								; do sub to set ctrl regs for square 1, then set frequency regs

SetFreq_Squ1:
		ldx #$00										; set frequency reg offset for square 1 sound channel

Dump_Freq_Regs:
		tay
		lda FreqRegLookupTbl+1,y						; use previous contents of A for sound reg offset
		beq NoTone										; if zero, then do not load
		
		sta SND_REGISTER+2,x							; first byte goes into LSB of frequency divider
		
		lda FreqRegLookupTbl,y							; second byte goes into 3 MSB plus extra bit for
		ora #%00001000									; length counter
		sta SND_REGISTER+3,x

NoTone:
		rts

Dump_Sq2_Regs:
		stx SND_SQUARE2_REG								; dump the contents of X and Y into square 2's control regs
		sty SND_SQUARE2_REG+1
		rts

PlaySqu2Sfx:
		jsr Dump_Sq2_Regs								; do sub to set ctrl regs for square 2, then set frequency regs

SetFreq_Squ2:
		ldx #$04										; set frequency reg offset for square 2 sound channel
		bne Dump_Freq_Regs								; [unconditional branch]

SetFreq_Tri:
		ldx #$08										; set frequency reg offset for triangle sound channel
		bne Dump_Freq_Regs								; [unconditional branch]

; ----------------------------------------------------------------------------------------------------------------------------------

PlayFlagpoleSlide:
		lda #$40										; store length of flagpole sound
		sta Squ1_SfxLenCounter
		
		lda #$62										; load part of reg contents for flagpole sound
		jsr SetFreq_Squ1
		
		ldx #$99										; now load the rest
		bne FPS2nd

PlaySmallJump:
		lda #$26										; branch here for small mario jumping sound
	.db $2c												; [skip 2 bytes]

PlayBigJump:
		lda #$18										; branch here for big mario jumping sound

JumpRegContents:
		ldx #$82										; note that small and big jump borrow each others' reg contents
		ldy #$a7										; anyway, this loads the first part of mario's jumping sound
		jsr PlaySqu1Sfx
		
		lda #$28										; store length of sfx for both jumping sounds
		sta Squ1_SfxLenCounter							; then continue on here

ContinueSndJump:
		lda Squ1_SfxLenCounter							; jumping sounds seem to be composed of three parts
		cmp #$25										; check for time to play second part yet
		bne N2Prt
		
		ldx #$5f										; load second part
		ldy #$f6
		bne DmpJpFPS									; [unconditional branch]

N2Prt:
		cmp #$20										; check for third part
		bne DecJpFPS

		ldx #$48										; load third part

FPS2nd:
		ldy #$bc										; the flagpole slide sound shares part of third part

DmpJpFPS:
		jsr Dump_Squ1_Regs
		bne DecJpFPS									; [unconditional branch]

PlayFireballThrow:
		lda #$05
		ldy #$99										; load reg contents for fireball throw sound
		bne Fthrow										; [unconditional branch]

PlayBump:
		lda #$0a										; load length of sfx and reg contents for bump sound
		ldy #$93

Fthrow:
		ldx #$9e										; the fireball sound shares reg contents with the bump sound
		sta Squ1_SfxLenCounter

		lda #$0c										; load offset for bump sound
		jsr PlaySqu1Sfx

ContinueBumpThrow:
		lda Squ1_SfxLenCounter							; check for second part of bump sound
		cmp #$06
		bne DecJpFPS

		lda #$bb										; load second part directly
		sta SND_SQUARE1_REG+1

DecJpFPS:
		bne BranchToDecLength1							; [unconditional branch]


Square1SfxHandler:
		ldy #$00
		lda Square1SoundQueue							; check for sfx in queue
		beq CheckSfx1Buffer
		
		sty Square1SoundQueue							; if found, clear sfx in queue
		sta Square1SoundBuffer							; and put sfx in buffer to check for the following
		bmi PlaySmallJump								; small jump
		
		lsr
		bcs PlayBigJump									; big jump
		
		lsr
		bcs PlayBump									; bump
		
		lsr
		bcs PlaySwimStomp								; swim/stomp
		
		lsr
		bcs PlaySmackEnemy								; smack enemy
		
		lsr
		bcs GoPlayPipeDownInj							; pipedown/injury
		
		lsr
		bcs PlayFireballThrow							; fireball throw
		
		lsr
		bcs PlayFlagpoleSlide							; slide flagpole

CheckSfx1Buffer:
		lda Square1SoundBuffer							; check sfx in buffer for the following
		beq ExS1H										; if not found, exit sub
		bmi ContinueSndJump								; small mario jump
		
		lsr
		bcs ContinueSndJump								; big mario jump
		
		lsr
		bcs ContinueBumpThrow							; bump
		
		lsr
		bcs ContinueSwimStomp							; swim/stomp
		
		lsr
		bcs ContinueSmackEnemy							; smack enemy
		
		lsr
		bcs GoContinuePipeDownInj						; pipedown/injury
		
		lsr
		bcs ContinueBumpThrow							; fireball throw
		
		lsr
		bcs DecrementSfx1Length							; slide flagpole

ExS1H:
		rts

PlaySwimStomp:
		lda #$0e										; store length of swim/stomp sound
		sta Squ1_SfxLenCounter
		
		ldy #$9c										; store reg contents for swim/stomp sound
		ldx #$9e
		lda #$26
		jsr PlaySqu1Sfx

ContinueSwimStomp:
		ldy Squ1_SfxLenCounter							; look up reg contents in data section based on
		lda SwimStompEnvelopeData-1,y					; length of sound left, used to control sound's
		sta SND_SQUARE1_REG								; envelope

		cpy #$06
		bne BranchToDecLength1
		
		lda #$13										; manipulate pitch of stomp sound  
		sec
		sbc EnemyDefeatPitch
		asl
		asl
		asl
		ora #%00000110									; set these bits to ensure pitch 0 matches the original
		sta SND_SQUARE1_REG+2

BranchToDecLength1:
		bne DecrementSfx1Length							; [unconditional branch]

; -------------------------------------------------------------------------------------
; these branches are only here to work around the branch instruction limit

GoPlayPipeDownInj:
        bcs PlayPipeDownInj

GoContinuePipeDownInj:
        bcs ContinuePipeDownInj

; -------------------------------------------------------------------------------------

PlaySmackEnemy:
		lda #$0e										; store length of smack enemy sound
		ldy #$cb
		ldx #$9f
		sta Squ1_SfxLenCounter

		lda #$28										; store reg contents for smack enemy sound
		jsr PlaySqu1Sfx
		bne DecrementSfx1Length							; [unconditional branch]

ContinueSmackEnemy:
		ldy Squ1_SfxLenCounter							; check about halfway through
		cpy #$08
		bne SmSpc

		lda #$14										; manipulate pitch of smack enemy sound
        sec
        sbc EnemyDefeatPitch
        asl
        asl
        asl
        sta SND_SQUARE1_REG+2							; this sequence ensures that pitch 0 matches the original

		lda #$9f
		bne SmTick

SmSpc:
		lda #$90										; this creates spaces in the sound, giving it its distinct noise

SmTick:
		sta SND_SQUARE1_REG

DecrementSfx1Length:
		dec Squ1_SfxLenCounter							; decrement length of sfx
		bne ExSfx1

StopSquare1Sfx:
		ldx #$00										; if end of sfx reached, clear buffer
		stx Square1SoundBuffer							; and stop making the sfx
		stx EnemyDefeatPitch							; clear defeat pitch as well

		ldx #$0e
		stx SND_MASTERCTRL_REG

		ldx #$0f
		stx SND_MASTERCTRL_REG

ExSfx1:
		rts

PlayPipeDownInj:
		lda #$2f										; load length of pipedown sound
		sta Squ1_SfxLenCounter

ContinuePipeDownInj:
		lda Squ1_SfxLenCounter							; some bitwise logic, forces the regs
		lsr 											; to be written to only during six specific times
		bcs NoPDwnL										; during which d3 must be set and d1-0 must be clear

		lsr
		bcs NoPDwnL

		and #%00000010
		beq NoPDwnL

		ldy #$91										; and this is where it actually gets written in
		ldx #$9a
		lda #$44
		jsr PlaySqu1Sfx

NoPDwnL:
		jmp DecrementSfx1Length

; ----------------------------------------------------------------------------------------------------------------------------------

PlayCoinGrab:
		lda #$35										; load length of coin grab sound
		ldx #$8d										; and part of reg contents
		bne CGrab_TTickRegL

PlayTimerTick:
		lda #$06										; load length of timer tick sound
		ldx #$98										; and part of reg contents

CGrab_TTickRegL:
		sta Squ2_SfxLenCounter

		ldy #$7f										; load the rest of reg contents
		lda #$42										; of coin grab and timer tick sound
		jsr PlaySqu2Sfx

ContinueCGrabTTick:
		lda Squ2_SfxLenCounter							; check for time to play second tone yet
		cmp #$30										; timer tick sound also executes this, not sure why
		bne N2Tone

		lda #$54										; if so, load the tone directly into the reg
		sta SND_SQUARE2_REG+2

N2Tone:
		bne DecrementSfx2Length

PlayBlast:
		lda #$20										; load length of fireworks/gunfire sound
		sta Squ2_SfxLenCounter

		ldy #$94										; load reg contents of fireworks/gunfire sound
		lda #$5e
		bne SBlasJ

ContinueBlast:
		lda Squ2_SfxLenCounter							; check for time to play second part
		cmp #$18
		bne DecrementSfx2Length

		ldy #$93										; load second part reg contents then
		lda #$18

SBlasJ:
		bne BlstSJp										; store them [unconditional branch]

PlayPowerUpGrab:
		lda #$3c										; load length of power-up grab sound
		sta Squ2_SfxLenCounter

ContinuePowerUpGrab:
		lda Squ2_SfxLenCounter							; load frequency reg based on length left over
		lsr 											; divide by 2
		bcs DecrementSfx2Length							; alter frequency every other frame

		tay
		lda PowerUpGrabFreqData-1,y						; use length left over / 2 for frequency offset
		ldx #$5d										; store reg contents of power-up grab sound
		ldy #$7f

LoadSqu2Regs:
		jsr PlaySqu2Sfx

DecrementSfx2Length:
		dec Squ2_SfxLenCounter							; decrement length of sfx
		bne ExSfx2

EmptySfx2Buffer:
		ldx #$00										; initialize square 2's sound effects buffer
		stx Square2SoundBuffer

StopSquare2Sfx:
		ldx #$0d										; stop playing the sfx
		stx SND_MASTERCTRL_REG

		ldx #$0f
		stx SND_MASTERCTRL_REG

ExSfx2:
		rts

Square2SfxHandler:
		lda Square2SoundBuffer							; special handling for the 1-up sound to keep it
		bmi ContinueExtraLife							; from being interrupted by square 2 sfx
		
		ldy #$00
		lda Square2SoundQueue							; check for sfx in queue
		beq CheckSfx2Buffer

		sty Square2SoundQueue							; if found, clear sfx in queue
		sta Square2SoundBuffer							; and put sfx in buffer to check for the following
		bmi PlayExtraLife								; 1-up

		lsr
		bcs PlayCoinGrab								; coin grab

		lsr
		bcs PlayGrowPowerUp								; power-up reveal

		lsr
		bcs PlayGrowVine								; vine grow

		lsr
		bcs PlayBlast									; fireworks/gunfire

		lsr
		bcs PlayTimerTick								; timer tick

		lsr
		bcs PlayPowerUpGrab								; power-up grab

		lsr
		bcs PlayBowserFall								; bowser fall

CheckSfx2Buffer:
		lda Square2SoundBuffer							; check sfx in buffer for the following
		beq ExS2H										; if not found, exit sub

		lsr
		bcs Cont_CGrab_TTick							; coin grab

		lsr
		bcs ContinueGrowItems							; power-up reveal

		lsr
		bcs ContinueGrowItems							; vine grow

		lsr
		bcs ContinueBlast								; fireworks/gunfire

		lsr
		bcs Cont_CGrab_TTick							; timer tick

		lsr
		bcs ContinuePowerUpGrab							; power-up grab

		lsr
		bcs ContinueBowserFall							; bowser fall

ExS2H:
		rts

Cont_CGrab_TTick:
		jmp ContinueCGrabTTick

JumpToDecLength2:
		jmp DecrementSfx2Length

PlayBowserFall:
		lda #$38										; load length of bowser defeat sound
		sta Squ2_SfxLenCounter

		ldy #$c4										; load contents of reg for bowser defeat sound
		lda #$18

BlstSJp:
		bne PBFRegs

ContinueBowserFall:
		lda Squ2_SfxLenCounter							; check for almost near the end
		cmp #$08
		bne DecrementSfx2Length

		ldy #$a4										; if so, load the rest of reg contents for bowser defeat sound
		lda #$5a

PBFRegs:
		ldx #$9f										; the fireworks/gunfire sound shares part of reg contents here

EL_LRegs:
		bne LoadSqu2Regs								; [unconditional branch]

PlayExtraLife:
		lda #$30										; load length of 1-up sound
		sta Squ2_SfxLenCounter

ContinueExtraLife:
		lda Squ2_SfxLenCounter
		ldx #$03										; load new tones only every eight frames

DivLLoop:
		lsr
		bcs JumpToDecLength2							; if any bits set here, branch to dec the length

		dex
		bne DivLLoop									; do this until all bits checked, if none set, continue

		tay
		lda ExtraLifeFreqData-1,y						; load our reg contents
		ldx #$82
		ldy #$7f
		bne EL_LRegs									; [unconditional branch]

PlayGrowPowerUp:
		lda #$10										; load length of power-up reveal sound
		bne GrowItemRegs

PlayGrowVine:
		lda #$20										; load length of vine grow sound

GrowItemRegs:
		sta Squ2_SfxLenCounter

		lda #$7f										; load contents of reg for both sounds directly
		sta SND_SQUARE2_REG+1

		lda #$00										; start secondary counter for both sounds
		sta Sfx_SecondaryCounter

ContinueGrowItems:
		inc Sfx_SecondaryCounter						; increment secondary counter for both sounds
		lda Sfx_SecondaryCounter						; this sound doesn't decrement the usual counter
		lsr 											; divide by 2 to get the offset
		tay
		cpy Squ2_SfxLenCounter							; have we reached the end yet?
		beq StopGrowItems								; if so, branch to jump, and stop playing sounds

		lda #$9d										; load contents of other reg directly
		sta SND_SQUARE2_REG

		lda PUp_VGrow_FreqData,y						; use secondary counter / 2 as offset for frequency regs
		jmp SetFreq_Squ2

StopGrowItems:
		jmp EmptySfx2Buffer								; branch to stop playing sounds

; ----------------------------------------------------------------------------------------------------------------------------------

PlaySkidSfx:
		lda #$06
		sta Noise_SfxLenCounter

ContinueSkidSfx:
		ldy Noise_SfxLenCounter							; use length counter as offset
		lda SkidSfxFreqData-1,y
		sta SND_TRIANGLE_REG+2							; write reg contents to triangle channel

		lda #$18
		sta SND_TRIANGLE_REG
		sta SND_TRIANGLE_REG+3							; this sets the length counter as well as timer high
		bne DecrementSfx3Length							; [unconditional branch]

PlayBrickShatter:
		lda #$20										; load length of brick shatter sound
		sta Noise_SfxLenCounter

ContinueBrickShatter:
		lda Noise_SfxLenCounter
		lsr 											; divide by 2 and check for bit set to use offset
		bcc DecrementSfx3Length

		tay
		ldx BrickShatterFreqData,y						; load reg contents of brick shatter sound
		lda ShatterFlameEnvData,y

PlayNoiseSfx:
		sta SND_NOISE_REG								; play the sfx
		stx SND_NOISE_REG+2

		lda #$18
		sta SND_NOISE_REG+3

DecrementSfx3Length:
		dec Noise_SfxLenCounter							; decrement length of sfx
		bne ExSfx3

		lda #$f0										; if done, stop playing the sfx
		sta SND_NOISE_REG

		lda #$00
		sta SND_TRIANGLE_REG
		sta NoiseSoundBuffer

ExSfx3:
		rts

NoiseSfxHandler:
		lda NoiseSoundBuffer							; special handling for skid sfx to keep it
		bmi ContinueSkidSfx								; from being interrupted by other noise sfx
		
		ldy #$00
		lda NoiseSoundQueue								; check for sfx in queue
		beq CheckNoiseBuffer
		
		sty NoiseSoundQueue								; if found, clear sfx in queue
		sta NoiseSoundBuffer							; and put sfx in buffer to check for the following
		bmi PlaySkidSfx									; skid

		lsr
		bcs PlayBrickShatter							; brick shatter

		lsr
		bcs PlayBowserFlame								; bowser flame

CheckNoiseBuffer:
		lda NoiseSoundBuffer							; check for sfx in buffer for the following
		beq ExNH										; if not found, exit sub

		lsr
		bcs ContinueBrickShatter						; brick shatter

		lsr
		bcs ContinueBowserFlame							; bowser flame

ExNH:
		rts

PlayBowserFlame:
		lda #$40										; load length of bowser flame sound
		sta Noise_SfxLenCounter

ContinueBowserFlame:
		lda Noise_SfxLenCounter
		lsr
		tay
		ldx #$0f										; load reg contents of bowser flame sound
		lda ShatterFlameEnvData-1,y
		bne PlayNoiseSfx								; [unconditional branch]

; ----------------------------------------------------------------------------------------------------------------------------------

ContinueMusic:
		jmp HandleSquare2Music							; if we have music, start with square 2 channel

MusicHandler:
		lda EventMusicQueue								; check event music queue
		bne LoadEventMusic

		lda AreaMusicQueue								; check area music queue
		bne LoadAreaMusic

		lda EventMusicBuffer							; check both buffers
		ora AreaMusicBuffer
		bne ContinueMusic

		rts												; no music, then leave

LoadEventMusic:
		ldy #$31
		sty VictoryMusicHeaderOfs						; start counter used only by victory music

		sta EventMusicBuffer							; copy event music queue contents to buffer
		cmp #DeathMusic									; is it death music?
		bne NoStopSfx									; if not, jump elsewhere

		jsr StopSquare1Sfx								; stop sfx in square 1 and 2
		jsr StopSquare2Sfx								; but clear only square 1's sfx buffer

		ldy #$00
		sty NoteLengthTblAdder							; default value for additional length byte offset
		sty AreaMusicBuffer								; clear area music buffer
		beq FindEventMusicHeader

NoStopSfx:
		ldx AreaMusicBuffer
		stx AreaMusicBuffer_Alt							; save current area music buffer to be re-obtained later

		ldy #$00
		sty NoteLengthTblAdder							; default value for additional length byte offset
		sty AreaMusicBuffer								; clear area music buffer

		cmp #TimeRunningOutMusic						; is it time running out music?
		bne CheckVictoryMusic

		ldx #$08										; load offset to be added to length byte of header
		stx NoteLengthTblAdder
		bne FindEventMusicHeader						; [unconditional branch]

CheckVictoryMusic:
		cmp #VictoryMusic								; is it time victory music?
		bne FindEventMusicHeader

HandleVictMusicLoopB:
		inc VictoryMusicHeaderOfs						; increment but only if playing victory music
		ldy VictoryMusicHeaderOfs						; is it time to loopback victory music?
		cpy #$37
		bne LoadHeader									; branch ahead with alternate offset

		jmp EndPlayback

LoadAreaMusic:
		cmp #UndergroundMusic							; is it underground music?
		bne NoStop1										; no, do not stop square 1 sfx

		jsr StopSquare1Sfx

NoStop1:
		ldy #$10										; start counter used only by ground level music

GMLoopB:
		sty GroundMusicHeaderOfs

HandleAreaMusicLoopB:
		ldy #$00										; clear event music buffer
		sty EventMusicBuffer

		sta AreaMusicBuffer								; copy area music queue contents to buffer
		cmp #$01										; is it ground level music?
		bne FindAreaMusicHeader

		inc GroundMusicHeaderOfs						; increment but only if playing ground level music
		ldy GroundMusicHeaderOfs						; is it time to loopback ground level music?
		cpy #$32
		bne LoadHeader									; branch ahead with alternate offset

		ldy #$11
		bne GMLoopB										; [unconditional branch]

FindAreaMusicHeader:
		ldy #$08										; load Y for offset of area music
		sty MusicOffset_Square2							; residual instruction here

FindEventMusicHeader:
		iny												; increment Y pointer based on previously loaded queue contents
		lsr 											; bit shift and increment until we find a set bit for music
		bcc FindEventMusicHeader

LoadHeader:
		lda MusicHeaderOffsetData,y						; load offset for header
		tay
		lda MusicHeaderData,y							; now load the header
		sta NoteLenLookupTblOfs

		lda MusicHeaderData+1,y
		sta MusicDataLow

		lda MusicHeaderData+2,y
		sta MusicDataHigh

		lda MusicHeaderData+3,y
		sta MusicOffset_Triangle

		lda MusicHeaderData+4,y
		sta MusicOffset_Square1

		lda MusicHeaderData+5,y
		sta MusicOffset_Noise
		sta NoiseDataLoopbackOfs

		lda #$01										; initialize music note counters
		sta Squ2_NoteLenCounter
		sta Squ1_NoteLenCounter
		sta Tri_NoteLenCounter
		sta Noise_BeatLenCounter

		lsr												; initialize music data offset for square 2
		sta MusicOffset_Square2
		sta AltRegContentFlag							; initialize alternate control reg data used by square 1

		lda #$0b										; disable triangle channel and reenable it
		sta SND_MASTERCTRL_REG

		lda #$0f
		sta SND_MASTERCTRL_REG

HandleSquare2Music:
		dec Squ2_NoteLenCounter							; decrement square 2 note length
		bne MiscSqu2MusicTasks							; is it time for more data?if not, branch to end tasks

		ldy MusicOffset_Square2							; increment square 2 music offset and fetch data
		inc MusicOffset_Square2
		lda (MusicData),y
		beq EndOfMusicData								; if zero, the data is a null terminator
		bpl Squ2NoteHandler								; if non-negative, data is a note
		bne Squ2LengthHandler							; otherwise it is length data

EndOfMusicData:
		lda OperMode									; if on title screen,
		beq EndPlayback									; do not loop
		
		lda EventMusicBuffer							; check secondary buffer for time running out music
		cmp #TimeRunningOutMusic
		bne NotTRO

		lda AreaMusicBuffer_Alt							; load previously saved contents of primary buffer
		bne MusicLoopBack								; and start playing the song again if there is one

NotTRO:
		and #VictoryMusic								; check for victory music (the only secondary that loops)
		bne VictoryMLoopBack

		lda AreaMusicBuffer								; check primary buffer for any music except pipe intro
		and #%01011111
		bne MusicLoopBack								; if any area music except pipe intro, music loops
		
EndPlayback:
		lda #$00										; clear primary and secondary buffers and initialize
		sta AreaMusicBuffer								; control regs of square and triangle channels
		sta EventMusicBuffer
		sta SND_TRIANGLE_REG

		lda #$90
		sta SND_SQUARE1_REG
		sta SND_SQUARE2_REG
		rts

MusicLoopBack:
		jmp HandleAreaMusicLoopB

VictoryMLoopBack:
		jmp HandleVictMusicLoopB

Squ2LengthHandler:
		jsr ProcessLengthData							; store length of note
		sta Squ2_NoteLenBuffer

		ldy MusicOffset_Square2							; fetch another byte (MUST NOT BE LENGTH BYTE!)
		inc MusicOffset_Square2
		lda (MusicData),y

Squ2NoteHandler:
		ldx Square2SoundBuffer							; is there a sound playing on this channel?
		bne SkipFqL1

		jsr SetFreq_Squ2								; no, then play the note
		beq Rest										; check to see if note is rest

		jsr LoadControlRegs								; if not, load control regs for square 2

Rest:
		sta Squ2_EnvelopeDataCtrl						; save contents of A
		jsr Dump_Sq2_Regs								; dump X and Y into square 2 control regs

SkipFqL1:
		lda Squ2_NoteLenBuffer							; save length in square 2 note counter
		sta Squ2_NoteLenCounter

MiscSqu2MusicTasks:
		lda Square2SoundBuffer							; is there a sound playing on square 2?
		bne HandleSquare1Music

		lda EventMusicBuffer							; check for death music or d4 set on secondary buffer
		and #%10010001									; note that regs for death music or d4 are loaded by default
		bne HandleSquare1Music

		ldy Squ2_EnvelopeDataCtrl						; check for contents saved from LoadControlRegs
		beq NoDecEnv1

		dec Squ2_EnvelopeDataCtrl						; decrement unless already zero

NoDecEnv1:
		jsr LoadEnvelopeData							; do a load of envelope data to replace default
		sta SND_SQUARE2_REG								; based on offset set by first load unless playing

		ldx #$7f										; death music or d4 set on secondary buffer
		stx SND_SQUARE2_REG+1

HandleSquare1Music:
		ldy MusicOffset_Square1							; is there a nonzero offset here?
		beq HandleTriangleMusic							; if not, skip ahead to the triangle channel

		dec Squ1_NoteLenCounter							; decrement square 1 note length
		bne MiscSqu1MusicTasks							; is it time for more data?

FetchSqu1MusicData:
		ldy MusicOffset_Square1							; increment square 1 music offset and fetch data
		inc MusicOffset_Square1
		lda (MusicData),y
		bne Squ1NoteHandler								; if nonzero, then skip this part

		lda #$83
		sta SND_SQUARE1_REG								; store some data into control regs for square 1

		lda #$94										; and fetch another byte of data, used to give
		sta SND_SQUARE1_REG+1							; death music its unique sound
		sta AltRegContentFlag
		bne FetchSqu1MusicData							; [unconditional branch]

Squ1NoteHandler:
		jsr AlternateLengthHandler
		sta Squ1_NoteLenCounter							; save contents of A in square 1 note counter

		ldy Square1SoundBuffer							; is there a sound playing on square 1?
		bne HandleTriangleMusic

		txa
		and #%00111110									; change saved data to appropriate note format
		jsr SetFreq_Squ1								; play the note
		beq SkipCtrlL

		jsr LoadControlRegs

SkipCtrlL:
		sta Squ1_EnvelopeDataCtrl						; save envelope offset
		jsr Dump_Squ1_Regs

MiscSqu1MusicTasks:
		lda Square1SoundBuffer							; is there a sound playing on square 1?
		bne HandleTriangleMusic

		lda EventMusicBuffer							; check for death music or d4 set on secondary buffer
		and #%10010001
		bne DeathMAltReg

		ldy Squ1_EnvelopeDataCtrl						; check saved envelope offset
		beq NoDecEnv2

		dec Squ1_EnvelopeDataCtrl						; decrement unless already zero

NoDecEnv2:
		jsr LoadEnvelopeData							; do a load of envelope data
		sta SND_SQUARE1_REG								; based on offset set by first load

DeathMAltReg:
		lda AltRegContentFlag							; check for alternate control reg data
		bne DoAltLoad

		lda #$7f										; load this value if zero, the alternate value

DoAltLoad:
		sta SND_SQUARE1_REG+1							; if nonzero, and let's move on

HandleTriangleMusic:
		lda MusicOffset_Triangle
		dec Tri_NoteLenCounter							; decrement triangle note length
		bne HandleNoiseMusic							; is it time for more data?

		ldy MusicOffset_Triangle						; increment square 1 music offset and fetch data
		inc MusicOffset_Triangle
		lda (MusicData),y
		beq LoadTriCtrlReg								; if zero, skip all this and move on to noise
		bpl TriNoteHandler								; if non-negative, data is note

		jsr ProcessLengthData							; otherwise, it is length data
		sta Tri_NoteLenBuffer							; save contents of A

		lda #$1f
		sta SND_TRIANGLE_REG							; load some default data for triangle control reg

		ldy MusicOffset_Triangle						; fetch another byte
		inc MusicOffset_Triangle
		lda (MusicData),y
		beq LoadTriCtrlReg								; check once more for nonzero data

TriNoteHandler:
		jsr SetFreq_Tri

		ldx Tri_NoteLenBuffer							; save length in triangle note counter
		stx Tri_NoteLenCounter

		lda EventMusicBuffer
		and #%01101110									; check for death music or d4 set on secondary buffer
		bne NotDOrD4									; if playing any other secondary, skip primary buffer check

		lda AreaMusicBuffer								; check primary buffer for water or castle level music
		and #%00001010
		beq HandleNoiseMusic							; if playing any other primary, or death or d4, go on to noise routine

NotDOrD4:
		txa												; if playing water or castle music or any secondary
		cmp #$12										; besides death music or d4 set, check length of note
		bcs LongN

		lda EventMusicBuffer							; check for win castle music again if not playing a long note
		and #EndOfCastleMusic
		beq MediN

		lda #$0f										; load value $0f if playing the win castle music and playing a short
		bne LoadTriCtrlReg								; note, load value $1f if playing water or castle level music or any

MediN:
		lda #$1f										; secondary besides death and d4 except win castle or win castle and playing
		bne LoadTriCtrlReg								; a short note, and load value $ff if playing a long note on water, castle

LongN:
		lda #$ff										; or any secondary (including win castle) except death and d4

LoadTriCtrlReg:
		sta SND_TRIANGLE_REG							; save final contents of A into control reg for triangle

HandleNoiseMusic:
		lda AreaMusicBuffer								; check if playing underground or castle music
		and #%11110011
		beq ExitMusicHandler							; if so, skip the noise routine

		dec Noise_BeatLenCounter						; decrement noise beat length
		bne ExitMusicHandler							; is it time for more data?

FetchNoiseBeatData:
		ldy MusicOffset_Noise							; increment noise beat offset and fetch data
		inc MusicOffset_Noise
		lda (MusicData),y								; get noise beat data, if nonzero, branch to handle
		bne NoiseBeatHandler

		lda NoiseDataLoopbackOfs						; if data is zero, reload original noise beat offset
		sta MusicOffset_Noise							; and loopback next time around
		bne FetchNoiseBeatData							; [unconditional branch]

NoiseBeatHandler:
		jsr AlternateLengthHandler
		sta Noise_BeatLenCounter						; store length in noise beat counter

		txa
		and #%00111110									; reload data and erase length bits
		beq SilentBeat									; if no beat data, silence

		cmp #$30										; check the beat data and play the appropriate
		beq LongBeat									; noise accordingly

		cmp #$20
		beq StrongBeat

		and #%00010000
		beq SilentBeat

		lda #$1c										; short beat data
		ldx #$03
		ldy #$18
		bne PlayBeat

StrongBeat:
		lda #$1c										; strong beat data
		ldx #$0c
		ldy #$18
		bne PlayBeat

LongBeat:
		lda #$1c										; long beat data
		ldx #$03
		ldy #$58
		bne PlayBeat

SilentBeat:
		lda #$10										; silence

PlayBeat:
		sta SND_NOISE_REG								; load beat data into noise regs
		stx SND_NOISE_REG+2
		sty SND_NOISE_REG+3

ExitMusicHandler:
		rts

AlternateLengthHandler:
		tax												; save a copy of original byte into X
		ror												; save LSB from original byte into carry
		txa												; reload original byte and rotate three times
		rol												; turning xx00000x into 00000xxx, with the
		rol												; bit in carry as the MSB here
		rol

ProcessLengthData:
		and #%00000111									; clear all but the three LSBs
		clc
		adc NoteLenLookupTblOfs							; add offset loaded from first header byte
		adc NoteLengthTblAdder							; add extra if time running out music
		tay
		lda MusicLengthLookupTbl,y						; load length
		rts

LoadControlRegs:
		lda EventMusicBuffer							; check secondary buffer for win castle music
		and #EndOfCastleMusic
		beq NotECstlM

		lda #$03										; this value is only used for win castle music
		bne AllMus										; [unconditional branch]

NotECstlM:
		lda AreaMusicBuffer
		and #%01111101									; check primary buffer for water music
		beq WaterMus

		lda #$07										; this is the default value for all other music
		bne AllMus

WaterMus:
		lda #$27										; this value is used for water music and all other event music

AllMus:
		ldx #$82										; load contents of other sound regs for square 2
		ldy #$7f
		rts

LoadEnvelopeData:
		lda EventMusicBuffer							; check secondary buffer for win castle music
		and #EndOfCastleMusic
		beq LoadUsualEnvData

		lda EndOfCastleMusicEnvData,y					; load data from offset for win castle music
		rts

LoadUsualEnvData:
		lda AreaMusicBuffer								; check primary buffer for water music
		and #%01111101
		beq LoadWaterEventMusEnvData

		lda AreaMusicEnvData,y							; load default data from offset for all other music
		rts

LoadWaterEventMusEnvData:
		lda WaterEventMusEnvData,y						; load data from offset for water music and all other event music
		rts
