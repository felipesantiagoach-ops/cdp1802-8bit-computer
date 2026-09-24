; CPU Type:
		CPU 1802

; Labels:

; Register Definitions:
	INCL "1802reg.asm"	;R0-RF defined HRJ

; Subroutines name definitions
TX		EQU 8
DLY1	EQU 9		; DELAY1 es un delay corto
DLY2	EQU 10		; DELAY2 es un delay largo
CONT1BT	EQU 138D		; contador para el delay de 1 bit-time
CONTLONG	EQU 050H	; contador para el delay largo (delay 2)

; Origin set to 00000H
	ORG  00000H
; Start code segment

; antes de empezar suponemos que el dato a enviar está cargado en el registro R2.1 (porque R0 es el contador de programa)
INICIO				; esta parte son solo definiciones
		LDI 00H
		PHI TX
		LDI 40H
		PLO TX		; se cargó 0040H en TX = R8, que es la SUB de transmisión
		LDI 00H
		PHI DLY1
		LDI 60H
		PLO DLY1	; se cargó 0060H en DLY1 = R9, que es la SUB de DELAY1 (para la SUB de transmisión)
		LDI 00H
		PHI DLY2
		LDI 70H
		PLO DLY2	; se cargó 0070H en DLY2 = RA, que es la SUB de DELAY2 (para el programa principal)
;acá está la rutina principal
		REQ				; empezamos ponindo la línea estado inactivo
LOOP	LDI 65D			; caracter ascii A (mayúscula)
		PLO R4			; cargo el valor de D a R4 (para tener guardado el último caracter enviado)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		LDI 07H			; cargo 7 en D
		PLO R5			; cargo D en R5.0 (para hacer 7 repeticiones en la rutina SEND)
SEND	SEP TX			; llamo a la SUB que transmite lo que está en R2
		SEP DLY2		; llamo a la SUB DELAY2
		INC R4			; incremento R4 (paso al siguiente caracter)
		GLO R4			; carga R4.0 en D
		PHI R2			; carga D en R2.1
		DEC R5			; decremento R5
		GLO R5			; carga la parte baja de R3 en D
		BNZ SEND		; salta si D != 0 (va a saltar 7 veces, enviando ABCDEFG)
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


;---------subrutina de trasmisión de datos-------------------------
		ORG  0003FH
BACK1	SEP R0		; retorna a la subrutina principal
TRANSM
		REQ			; Q = 1 (línea en estado inactivo)
		SEQ  		; Q = 0 (bit de start)
		SEP DLY1	; llamar subrutina de demora de 1 bit-time
		LDI 08H		; carga el valor inmediato en D
		PLO R3		; carga el valor de D en R3.0 (este es el contador para iterar cada bit del dato en R2)
					; tiene que ser la parte baja de R3, porque DEC R3 decrementa el registro entero de 16 bits
SHIFT	GHI R2		; carga el valor de R2.1 en D (acá se supone que está el byte que queremos transmitir)
		SHR			; desplaza D a la deracha, cargando el LSB en el bit DF
		PHI R2		; carga el valor de D en R2.1
		BNF ESCERO	; salta si DF = 0
		REQ			; salida Q igual a 1
		SKP			; salta la siguiente instrucción de manera incondicional
ESCERO	SEQ			; salida Q igual a 0
		SEP DLY1	; llamar subrutina de demora de 1 bit-time
		DEC R3		; decremento el contador
		GLO R3		; carga la parte baja de R3 en D
		BNZ SHIFT	; salta si D != 0
		REQ			; Q = 1 (bit de stop) (el ingeniero Korpys dijo que ponga dos bits de stop (dos bit-time))
		SEP DLY1	; llamar subrutina de demora de 1 bit-time dos veces
		SEP DLY1
		BR BACK1	; salto incondicional





;---------subrutina de ratardo de tranmisión-------------------------
		ORG  0005FH
BACK2	SEP TX			; retorna a subrutina de transmisión 1-Byte	2-Machine Cycles	1 time
DELAY1
		LDI  CONT1BT	; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  R1			; carga el valor de D en R1.1		1-Byte	2-Machine Cycles	1 time
TIMER1
		DEC  R1     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  R1     	; carga la parte alta de R1 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  TIMER1   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
		BR   BACK2		; salto incondicional				2-Byte	2-Machine Cycles	1 time


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
