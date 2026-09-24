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
RX		EQU	7
TX		EQU 8
DLY1	EQU 9		; DELAY1 es un delay corto para la transmisión
DLY2	EQU 10		; DELAY2 es un delay largo
DLY3	EQU	11		; DELAY3 es un delay corto para la transmisión
CONT1DOT5BT	EQU	185D	; contador para un bit-time y medio
CONT1BT	EQU 123D		; contador para el delay de 1 bit-time
CONTLONG	EQU 050H	; contador para el delay largo (delay 2)

; Start code segment

; antes de empezar suponemos que el dato a enviar está cargado en el registro R2.1 (porque R0 es el contador de programa)
INICIO				; esta parte son solo definiciones
		LDI 00H
		PHI RX
		LDI 040H
		PLO RX		; se cargó "" en RX = R7, que es la SUB de transmisión
		LDI 00H
		PHI TX
		LDI 0B0H
		PLO TX		; se cargó "" en TX = R8, que es la SUB de transmisión
		LDI 00H
		PHI DLY1
		LDI 0E0H
		PLO DLY1	; se cargó "" en DLY1 = R9, que es la SUB de DELAY1 (para la SUB de transmisión)
		LDI 00H
		PHI DLY2
		LDI 0F0H
		PLO DLY2	; se cargó "" en DLY2 = RA, que es la SUB de DELAY2 (para el programa principal)
		LDI 00H
		PHI DLY3
		LDI 0D0H
		PLO DLY3	; se cargó "" en DLY3 = RB, que es la SUB de DELAY3 (para la SUB de recepción)
; acá está la rutina principal
		SEQ				; empezamos ponindo la línea estado inactivo
LOOP	LDI 65D			; caracter ascii A (mayúscula)
	; envio CRLF para hacer el salto de línea
		LDI 13D			; caracter ascii CR (carriage return)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		SEP TX			; llamo a la SUB que transmite lo que está en R2
		SEP DLY2		; llamo a la SUB DELAY2
		LDI 10D			; caracter ascii  (line feed)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		SEP TX			; llamo a la SUB que transmite lo que está en R2
		SEP DLY2		; llamo a la SUB DELAY2
		BR LOOP			; salto incondicional

;---------subrutina de recepción de datos--------------------------
		ORG	00040H
BACK5	SEP R0
RECEP	

;---------subrutina de trasmisión de datos-------------------------
		ORG  000AFH
BACK1	SEP R0		; retorna a la subrutina principal
TRANSM
		SEQ			; Q = 1 (línea en estado inactivo)
		REQ  		; Q = 0 (bit de start)
		SEP DLY1	; llamar subrutina de demora de 1 bit-time
		LDI 08H		; carga el valor inmediato en D
		PLO R3		; carga el valor de D en R3.0 (este es el contador para iterar cada bit del dato en R2)
					; tiene que ser la parte baja de R3, porque DEC R3 decrementa el registro entero de 16 bits
SHIFT	GHI R2		; carga el valor de R2.1 en D (acá se supone que está el byte que queremos transmitir)
		SHR			; desplaza D a la deracha, cargando el LSB en el bit DF
		PHI R2		; carga el valor de D en R2.1
		BNF ESCERO	; salta si DF = 0
		SEQ			; salida Q igual a 1
		SKP			; salta la siguiente instrucción de manera incondicional
ESCERO	REQ			; salida Q igual a 0
		SEP DLY1	; llamar subrutina de demora de 1 bit-time
		DEC R3		; decremento el contador
		GLO R3		; carga la parte baja de R3 en D
		BNZ SHIFT	; salta si D != 0
		SEQ			; Q = 1 (bit de stop) (el ingeniero Korpys dijo que ponga dos bits de stop (dos bit-time))
		SEP DLY1	; llamar subrutina de demora de 1 bit-time dos veces
		SEP DLY1
		BR BACK1	; salto incondicional



;---------subrutina de ratardo de recepción-------------------------
; notar que hay que asignar el valor a R1 antes de llamar a esta subrutina
		ORG  000CFH
BACK4	SEP RX			; retorna a subrutina de transmisión 1-Byte	2-Machine Cycles	1 time
TIMER3
		DEC  R1     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  R1     	; carga la parte alta de R1 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  TIMER3   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
		BR   BACK4		; salto incondicional				2-Byte	2-Machine Cycles	1 time


;---------subrutina de ratardo de tranmisión-------------------------
		ORG  000DFH
BACK2	SEP TX			; retorna a subrutina de transmisión 1-Byte	2-Machine Cycles	1 time
DELAY1
		LDI  CONT1BT	; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  R1			; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
TIMER1
		DEC  R1     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  R1     	; carga la parte alta de R1 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  TIMER1   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
		BR   BACK2		; salto incondicional				2-Byte	2-Machine Cycles	1 time


;---------subrutina de retardo del programa principal-------------------------
		ORG  000EFH
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
