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


REF: WORD $IO
CASREF: WORD $IO
IO: WORD 0x0				;X
I: WORD 0x0
START:CLA					;Игнор других
OUT 2
OUT 3

LD #0xA 					;1010 -> 2 ВЕКТОР
OUT 5
LD #0xB 					;1011 -> 3 ВЕКТОР
OUT 7

CLA
EI

INCLP:						;Main loop
PUSH						;ЛОКАЛЬНАЯ ПЕРЕМЕННАЯ

LD IO		
PUSH						;OLD
INC
PUSH						;NEW
ST &0x2
LD REF
PUSH						;REF
CALL CAS
BEQ INCLP
CALL AC_PRINT
JUMP INCLP

AC_PRINT:
IN 0xD
AND #0x40
BEQ AC_PRINT
LD #0x0A
OUT 0xC
LD #16
ST I
LD &0x1
PRINT_LOOP:
ROL
PUSH
LD #0x30
ADC #0x0
PUSH
S1: IN 0xD
AND #0x40
BEQ S1
POP
OUT 0xC
POP
LOOP I
JUMP PRINT_LOOP
LD &0x1
SWAP
ST &0x1
SWAP
SWAP
POP
RET

CAS:
PUSHF
DI
LD &0x2
ST CASREF

LD (CASREF)
CMP &0x4
BEQ THEN
JUMP ELSE

THEN:
LD &0x3
ST (CASREF)
LD #0x1
JUMP EXIT
ELSE: 
CLA

EXIT:
POPF

SWAP
ST &0x3
SWAP
SWAP
POP
SWAP
POP
SWAP
POP

RET


INT2:						;Mask

IN 4
AND #0x7
PUSH		;Маска

LOOP1:
LD IO
PUSH

AND &0x1
PUSH

LD REF
PUSH

CALL CAS
BEQ LOOP1

POP			;MASK
IRET

INT3:
PUSHF
PUSH

LD IO
PUSH
CALL CHECK
CMP #0x7F
BNE CONT

AGAIN: LD IO
PUSH

PUSH
CALL CHECK
CMP #0x7F
BNE CONT

LD #24				;МИНИМАЛЬНОЕ ЧИСЛО
NEG
PUSH

LD REF
PUSH

CALL CAS
BEQ AGAIN

LD IO
CONT: PUSH
CALL FUNC
PRINT: OUT 6
POP
POPF
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

CHECK:LD &0x1		;Check
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

