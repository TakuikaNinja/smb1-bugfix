;-------------------------------------------------------------------------------------
; MACROS

macro ASL4
asl
asl
asl
asl
endm

macro LSR4
lsr
lsr
lsr
lsr
endm

macro INY4
iny
iny
iny
iny
endm

macro NEG_A
eor #$ff
sec
adc #$00
endm
