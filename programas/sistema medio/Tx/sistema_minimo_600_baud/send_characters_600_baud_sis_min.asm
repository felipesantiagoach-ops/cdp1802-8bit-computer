; aclarar que valor darle al contador de delay para qué baudrate
; aclarar que registros son modificados por esta rutina
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
R10		EQU 10
R11		EQU 11
R12		EQU 12
R13		EQU 13
R14		EQU 14
R15		EQU 15

RA		EQU 10
RB		EQU 11
RC		EQU 12
RD		EQU 13
RE		EQU 14
RF		EQU 15

; Name Definitions
CONTB	EQU RA
DATO	EQU RB
CONTD 	EQU RC

bitdly	EQU 124D ; bit time delay counter value

; Origin set to 00000H
		ORG  00000H
LOOP	
		LDI 85D
		PLO DATO
;----------------------------transmito bit de inicio----------------------------------			
		REQ				; Q=0 start bit
; bit time delay
		LDI  bitdly		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
DEL1
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL1   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
;-------------------------aquí termina el bit de inicio-------------------------------
;-----------------aquí comienza a transmitirse los bits de datos----------------------
		LDI 08D			; cargo el contador de bits a enviar 
		PLO CONTB
TDAT
		GLO DATO		; carga dato en D
		SHR				; shift right D (carga en DF el LSB de DATO)
		PLO DATO		; guarda el valor de DATOS desplazado de nuevo en su registro correspondiente
		BNF	ESCERO		; salta si DF = 0
		SEQ				; Q=1
		SKP				; saltea la siguiente instrucción
ESCERO	REQ				; Q=0
; bit time delay
		LDI  bitdly		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
DEL2
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL2   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
;-------------------------fin de transmisión de un bit-----------------------------------------
		DEC CONTB		; decremento el contador de bits enviados
		GLO CONTB		; cargo valor en D
		BNZ TDAT		; continuo con el siguiente bit si todavía no llegó a cero
;-------------------------bit de parada---------------------------------------------
		SEQ				; Q=1
; bit time delay
		LDI  bitdly		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
DEL3
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL3   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
; bit time delay
		LDI  bitdly		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
DEL4
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL4   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
; delay para separar caracteres
		LDI  255D		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
DEL5
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL5   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
		BR LOOP
		END
