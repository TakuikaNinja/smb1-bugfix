; ==================================================================================================================================
; ----------------------------------------------------------------------------------------------------------------------------------
; Super Mario Bros. Bugfix Disassembly
; ----------------------------------------------------------------------------------------------------------------------------------
; Disk Structure
	.org $0000
	
; ----------------------------------------------------------------------------------------------------------------------------------
; Disk definitions taken from SMB2J's disassembly
	DiskInfoBlock     = 1
	FileAmountBlock   = 2
	FileHeaderBlock   = 3
	FileDataBlock     = 4
	PRG = 0
	CHR = 1
	VRAM = 2
	FILE_COUNT = 4 ; 1 more than actual file count to distract the FDS before NMI kicks in
	
; ----------------------------------------------------------------------------------------------------------------------------------
; Macros
	.include "src/macros.asm"

; ----------------------------------------------------------------------------------------------------------------------------------
; Definitions
	.enum $0000
	.include "src/defs.asm"
	.ende

; RAM definitions
	.enum $0000
	.include "src/ram.asm"
	.ende

; ----------------------------------------------------------------------------------------------------------------------------------
; Disk info + file amount blocks
	.db DiskInfoBlock
	.db "*NINTENDO-HVC*"
	.db 0												; manufacturer
	.db "SMA "											; game title + space for normal disk
	.db 0, 0, 0, 0, 0									; game version, side, disk, disk type, unknown
	.db FILE_COUNT										; boot file count
	.db $ff, $ff, $ff, $ff, $ff
	.db $61, $08, $28									; FDS version release date according to nointro dump (1986/08/28)
	.db $49, $61, 0, 0, 2, 0, 0, 0, 0, 0				; region stuff
	.db $98, $06, $29									; use disk write date as date of hack release for now
	.db 0, $80, 0, 0, 7, 0, 0, 0, 0						; unknown data, disk writer serial no., actual disk side, price

	.db FileAmountBlock
	.db FILE_COUNT

; ----------------------------------------------------------------------------------------------------------------------------------
; CHR
	.db FileHeaderBlock
	.db $00, $00
	.db "SMB1CHAR"
	.dw $0000
	.dw chr_end - chr_start
	.db CHR
	
	.db FileDataBlock
	chr_start:
	.incbin "smb1.chr"
	chr_end:

; ----------------------------------------------------------------------------------------------------------------------------------
; PRG
	.db FileHeaderBlock
	.db $01, $01
	.db "SMB1PRGM"
	.dw $6000
	.dw prg_length
	.db PRG
	
	.db FileDataBlock
	oldaddr = $
	.base $6000
	prg_start:
	.include "src/prg.asm"
	prg_length = $ - prg_start
	.base oldaddr + prg_length
	
; ----------------------------------------------------------------------------------------------------------------------------------
; kyodaku file
	.db FileHeaderBlock
	.db $02, $02
	.db "-BYPASS-"
	.dw PPU_CTRL_REG1
	.dw $0001
	.db PRG

	.db FileDataBlock
	.db $90 ; enable NMI byte loaded into PPU control register - bypasses "KYODAKU-" file check
	
	.pad 65500

