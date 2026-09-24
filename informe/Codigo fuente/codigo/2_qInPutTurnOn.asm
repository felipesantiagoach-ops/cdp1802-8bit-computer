; CPU Type:
		CPU 1802
		
; Register Definitions:
R0		EQU 0
R1		EQU 1
R2		EQU 2
R3		EQU 3
R4		EQU 4
R5		EQU 5
R6		EQU 6
R7		EQU 7
R8		EQU 8
R9		EQU 9
RA		EQU 10
RB		EQU 11
RC		EQU 12
RD		EQU 13
RE		EQU 14
RF		EQU 15

; Start code segment
		ORG  00000H
START
		REQ				; reset Q
ENCENDIDO
		BN4  START		; salta si EF4 esta en estado bajo
		SEQ				; set Q
		BR   ENCENDIDO	; salto incondicional
		END
