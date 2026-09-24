; Origin set to 00000H
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
; Subroutines name definitions
DLY2	EQU 10		; DELAY2 es un delay largo
CONTLONG	EQU 0FFH	; contador para el delay largo (delay 2)

; Start code segment

; antes de empezar suponemos que el dato a enviar está cargado en el registro R2.1 (porque R0 es el contador de programa)
INICIO				; esta parte son solo definiciones
		LDI 00H
		PHI DLY2
		LDI 70H
		PLO DLY2	; se cargó 0070H en DLY2 = RA, que es la SUB de DELAY2 (para el programa principal)
;acá está la rutina principal
LOOP	REQ				; Q encendido
		OUT 1
		SEP DLY2		; llamo a la SUB DELAY2
		SEQ				; Q encendido
		OUT 1
		SEP DLY2		; llamo a la SUB DELAY2
		REQ				; Q apagado
		OUT 2
		SEP DLY2		; llamo a la SUB DELAY2
		SEQ				; Q encendido
		OUT 3
		SEP DLY2		; llamo a la SUB DELAY2
		REQ				; Q apagado
		OUT 4
		SEP DLY2		; llamo a la SUB DELAY2
		SEQ				; Q encendido
		OUT 5
		SEP DLY2		; llamo a la SUB DELAY2
		REQ				; Q apagado
		OUT 6
		SEP DLY2		; llamo a la SUB DELAY2
		SEQ				; Q encendido
		OUT 7
		SEP DLY2		; llamo a la SUB DELAY2
		BR LOOP			; salto incondicional

;---------subrutina de retardo del programa principal-------------------------
		ORG  0006FH
BACK3	SEP R0			; retorna a la rutina principal
DELAY2
		LDI  CONTLONG	; carga el valor inmediato en D
		PHI  R1			; carga el valor de D en R1.1
TIMER2
		DEC  R1     	; decrementa R1
		GHI  R1     	; carga la parte alta de R1 en D
		BNZ  TIMER2   	; salta si D != 0
		BR   BACK3		; salto incondicional
		END
