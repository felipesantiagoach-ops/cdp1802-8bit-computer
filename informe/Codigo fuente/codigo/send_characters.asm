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
; definicion de constantes
TX		EQU 8
DLY1	EQU 9			; DELAY1 es un delay corto
DLY2	EQU 10			; DELAY2 es un delay largo
CONT1BT	EQU 123D			; contador para el delay de 1 bit-time
CONTLONG	EQU 050H	; contador para el delay largo (delay 2)

; Start code segment

; antes de empezar suponemos que el dato a enviar esta cargado en el registro R2.1 (porque R0 es el contador de programa)
		ORG  00000H
INICIO				; esta parte son solo definiciones
		LDI 00H
		PHI TX
		LDI 40H
		PLO TX		; se cargo 0040H en TX = R8, que es la SUB de transmision
		LDI 00H
		PHI DLY1
		LDI 60H
		PLO DLY1	; se cargo 0060H en DLY1 = R9, que es la SUB de DELAY1 (para la SUB de transmision)
		LDI 00H
		PHI DLY2
		LDI 70H
		PLO DLY2	; se cargo 0070H en DLY2 = RA, que es la SUB de DELAY2 (para el programa principal)
;aca empieza la rutina principal
		SEQ				; empezamos ponindo la linea estado inactivo
LOOP	LDI 65D			; caracter ascii A (mayuscula)
		PLO R4			; cargo el valor de D a R4 (para tener guardado el ultimo caracter enviado)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		LDI 07H			; cargo 7 en D
		PLO R5			; cargo D en R5.0 (para hacer 7 repeticiones en la rutina SEND)
SEND	SEP TX			; llamo a la SUB que transmite lo que esta en R2
		SEP DLY2		; llamo a la SUB DELAY2
		INC R4			; incremento R4 (paso al siguiente caracter)
		GLO R4			; carga R4.0 en D
		PHI R2			; carga D en R2.1
		DEC R5			; decremento R5
		GLO R5			; carga la parte baja de R3 en D
		BNZ SEND		; salta si D != 0 (va a saltar 7 veces, enviando ABCDEFG)
	; envio CRLF para hacer el salto de linea
		LDI 13D			; caracter ascii CR (carriage return)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		SEP TX			; llamo a la SUB que transmite lo que esta en R2
		SEP DLY2		; llamo a la SUB DELAY2
		LDI 10D			; caracter ascii  (line feed)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		SEP TX			; llamo a la SUB que transmite lo que esta en R2
		SEP DLY2		; llamo a la SUB DELAY2
		BR LOOP			; salto incondicional
		
;---------subrutina de trasmision de datos-------------------------
		ORG  0003FH
BACK1	SEP R0		; retorna a la subrutina principal
TRANSM
		SEQ			; Q = 1 (linea en estado inactivo)
		REQ  		; Q = 0 (bit de start)
		SEP DLY1	; llamar subrutina de demora de 1 bit-time
		LDI 08H		; carga el valor inmediato en D
		PLO R3		; carga el valor de D en R3.0 (este es el contador para iterar cada bit del dato en R2)
					; tiene que ser la parte baja de R3, porque DEC R3 decrementa el registro entero de 16 bits
SHIFT	GHI R2		; carga el valor de R2.1 en D (aca se supone que esta el byte que queremos transmitir)
		SHR			; desplaza D a la deracha, cargando el LSB en el bit DF
		PHI R2		; carga el valor de D en R2.1
		BNF ESCERO	; salta si DF = 0
		SEQ			; salida Q igual a 1
		SKP			; salta la siguiente instruccion de manera incondicional
ESCERO	REQ			; salida Q igual a 0
		SEP DLY1	; llamar subrutina de demora de 1 bit-time
		DEC R3		; decremento el contador
		GLO R3		; carga la parte baja de R3 en D
		BNZ SHIFT	; salta si D != 0
		SEQ			; Q = 1 (bit de stop)
		SEP DLY1	; llamar subrutina de demora de 1 bit-time dos veces
		SEP DLY1
		BR BACK1	; salto incondicional

;---------subrutina de ratardo de tranmision-------------------------
		ORG  0005FH
BACK2	SEP TX			; retorna a subrutina de transmision
DELAY1
		LDI  CONT1BT	; carga el valor inmediato en D
		PLO  R1			; carga el valor de D en R1.1
TIMER1
		DEC  R1     	; decrementa R1	
		GLO  R1     	; carga la parte alta de R1 en D
		BNZ  TIMER1   	; salta si D != 0
		BR   BACK2		; salto incondicional

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