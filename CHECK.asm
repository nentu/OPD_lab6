ORG 0x0
V0: WORD $DEFAULT, 0x180
V1: WORD $DEFAULT, 0x180
V2: WORD $INT2, 0x180
V3: WORD $INT3, 0x180
V4: WORD $DEFAULT, 0x180
V5: WORD $DEFAULT, 0x180
V6: WORD $DEFAULT, 0x180
V7: WORD $DEFAULT, 0x180

DEFAULT: IRET

ORG 0x020
START:
IO: WORD 0x25				;X
CLA							;Игнор других
OUT 1
OUT 3

LD #0xA 					;1010 -> 2 ВЕКТОР
OUT 5
LD #0xB 					; 1011 -> 3 ВЕКТОР
OUT 7

CLA
EI

INCLP:						;Main loop
LD IO
INC
ST IO
JUMP INCLP


INT2:						;Mask
DI
NOP
LD IO
PUSH
IN 4
AND #0x7
AND &0x0
SWAP
POP
ST IO
EI
IRET


ORG 0x060
INT3:
DI
PUSH

PUSH
CALL CHECK
CMP #0x7F
BNE CONT
LD #24				;МИНИМАЛЬНОЕ ЧИСЛО
NEG
ST IO
CONT: PUSH
CALL FUNC
PRINT: OUT 6
POP
IRET

FUNC: LD &0x1		;-5X + 6
ASL
ASL
ADD &0x1 			;5X
NEG 				;-5X
ADD #0x6
			
SWAP
ST &0x1
SWAP

SWAP
POP
RET

CHECK:LD &0x1		;Cheack
CMP #0xE8
BPL K1
LD #0x7F
JUMP K2
K1: CMP #0x1B
BMI K2
LD #0x7F

K2: SWAP
ST &0x1
SWAP
SWAP
POP
RET