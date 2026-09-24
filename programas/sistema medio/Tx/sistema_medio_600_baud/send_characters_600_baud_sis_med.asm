; aclarar que valor darle al contador de delay para qué baudrate
; aclarar que registros son modificados por esta rutina
; CPU Type:
		CPU 1802

; Labels:

; Register Definitions:

RA		EQU 10
RB		EQU 11
RC		EQU 12

; Name Definitions
CONTB	EQU RA
DATO	EQU RB
CONTD 	EQU RC

BITDLY	EQU 138D ; bit time delay counter value (600 BAUD a 4 MHz crystal)

; Origin set to 00000H
		ORG  00000H
LOOP	
		LDI 85D
		PLO DATO		;carga el caracter U en DATO
;----------------------------transmito bit de inicio----------------------------------			
		REQ				; Q=0 start bit
; bit time delay
		LDI  BITDLY		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
		LDI	00H
		PHI  CONTD
DEL1
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL1   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
;-------------------------aquí termina el bit de inicio-------------------------------
;-----------------aquí comienza a transmitirse los bits de datos----------------------
		LDI 08D			; cargo el contador de bits a enviar 
		PLO CONTB
		LDI 00H
		PHI CONTB
TDAT
		GLO DATO		; carga dato en D
		SHR				; shift right D (carga en DF el LSB de DATO)
		PLO DATO		; guarda el valor de DATOS desplazado de nuevo en su registro correspondiente
		BNF	ESCERO		; salta si DF = 0
		SEQ				; Q=1
		SKP				; saltea la siguiente instrucción
ESCERO	REQ				; Q=0
; bit time delay
		LDI  BITDLY		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
		LDI	00H
		PHI  CONTD
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
		LDI  BITDLY		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
		LDI	00H
		PHI  CONTD
DEL3
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL3   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
; bit time delay
		LDI  BITDLY		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  CONTD		; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
		LDI	00H
		PHI  CONTD
DEL4
		DEC  CONTD     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  CONTD     	; carga la parte alta de R1.0 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  DEL4   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
		BR LOOP
		END
