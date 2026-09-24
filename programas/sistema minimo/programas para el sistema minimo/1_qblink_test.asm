; Origin set to 00000H, EOF = 0000DH
		ORG  00000H

; CPU Type:
		CPU 1802

; Labels:

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
INICIO
		REQ			; reset Q
START
		LDI  010H 	; al parecer el cero va adelante para indicar que es hexadecimal
		PHI  R1		; carga el valor de D a R1.1
LOOP
		DEC  R1		; decrementa R1.1
		GHI  R1     ; carga R1.1 en D
		BNZ  LOOP	; salta si D distinto de 0
		BQ   INICIO	; salta si Q == 1 (para que Q conmute)
		SEQ 		; set Q
		BR   START	; salto incondicional
		END
