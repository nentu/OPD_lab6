;def cas(ref, new, old)
;	if (ref) == od
;		(ref) = new
;		return 1
;	else
;		return 0
;cas(IO, 20, 100)
ORG 0x1
REF: WORD $IO
IO: WORD 0x100
START:
LOOPM:
LD IO
PUSH

INC
PUSH
LD REF
PUSH
CALL CAS
BNE LOOPM
HLT
JUMP LOOPM


CAS:
PUSHF
DI
LD &0x2
ST REF

LD (REF)
CMP &0x4
BEQ THEN
JUMP ELSE

THEN:
LD &0x3
ST (REF)
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
