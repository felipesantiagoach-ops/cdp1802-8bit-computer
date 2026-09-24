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
;------------------------------------------------------
INICIO1
		REQ				; reset Q
START1
		LDI  010H 		; al parecer el cero va adelante para indicar que es hexadecimal
		PHI  R1			; carga el valor de D a R1.1
LOOP1
		DEC  R1			; decrementa R1.1
		GHI  R1			; carga R1.1 en D
		BNZ  LOOP1		; salta si D es 0
		BQ   INICIO1	; salta si Q == 1 (para que Q conmute)
		SEQ				; set Q
		BR   START1		; salto incondicional

;----------------------------------------------------
		ORG  00100H
START2
		REQ				; reset Q
ENCENDIDO2
		BN1  START2		; salta si EF1 está en estado bajo
		SEQ				; set Q
		BR   ENCENDIDO2	; salto incondicional


;-------------------------------------------------------
		ORG  00200H
START3
		REQ				; reset Q
INICIO3
		LDI  10H		; carga 10 en D
		PHI  R1			; carga el valor de D en R1.1
LOOP3
		DEC  R1			; decremanta R1
		GHI  R1			; carga el valor de R1.1 en D
		BNZ  LOOP3		; salta si D = 0
		BQ   START3		; salta si Q = 1
		SEQ				; set Q
ENCENDIDO3
		BN1  START3		; salta si EF1 está en estado bajo
		SEQ				; set Q
		BR   INICIO3	; salto incondicional

;-----------------------------------------------------------
		ORG   00300H

; antes de empezar suponemos que el dato a enviar está cargado en el registro R2.1 (porque R0 es el contador de programa)
INICIO				; esta parte son solo definiciones
		LDI 00H
		PHI R8
		LDI 40H
		PLO R8		; se cargó 0040H en R8, que es la SUB de transmisión
		LDI 00H
		PHI R9
		LDI 60H
		PLO R9		; se cargó 0060H en R9, que es la SUB de DELAY1 (para la SUB de transmisión)
		LDI 00H
		PHI RA
		LDI 70H
		PLO RA		; se cargó 0070H en RA, que es la SUB de DELAY2 (para el programa principal)
;acá está la rutina principal
		SEQ				; empezamos ponindo la línea estado inactivo
LOOP	LDI 65D			; caracter ascii A (mayúscula)
		PLO R4			; cargo el valor de D a R4 (para tener guardado el último caracter enviado)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		LDI 07H			; cargo 7 en D
		PLO R5			; cargo D en R5.0 (para hacer 7 repeticiones en la rutina SEND)
SEND	SEP R8			; llamo a la SUB que transmite lo que está en R2
		SEP RA			; llamo a la SUB DELAY2
		INC R4			; incremento R4 (paso al siguiente caracter)
		GLO R4			; carga R4.0 en D
		PHI R2			; carga D en R2.1
		DEC R5			; decremento R5
		GLO R5			; carga la parte baja de R3 en D
		BNZ SEND		; salta si D != 0 (va a saltar 7 veces, enviando ABCDEFG)
	; envio CRLF para hacer el salto de línea
		LDI 13D			; caracter ascii CR (carriage return)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		SEP R8			; llamo a la SUB que transmite lo que está en R2
		SEP RA			; llamo a la SUB DELAY2
		LDI 10D			; caracter ascii  (line feed)
		PHI R2			; cargo el valor de D a R2 (para la subrutina)
		SEP R8			; llamo a la SUB que transmite lo que está en R2
		SEP RA			; llamo a la SUB DELAY2
		BR LOOP			; salto incondicional


;---------subrutina de trasmisión de datos-------------------------
		ORG  0033FH	; se le sumó 0300H porque el código empieza allí
BACK1	SEP R0		; retorna a la subrutina principal
TRANSM
		SEQ			; Q = 1 (línea en estado inactivo)
		REQ  		; Q = 0 (bit de start)
		SEP R9		; llamar subrutina de demora de 1 bit-time
		LDI 08H		; carga el valor inmediato en D
		PLO R3		; carga el valor de D en R3.0 (este es el contador para iterar cada bit del dato en R2)
					; tiene que ser la parte baja de R3, porque DEC R3 decrementa el registro entero de 16 bits
SHIFT	GHI R2		; carga el valor de R2.1 en D (acá se supone que está el byte que queremos transmitir)
		SHR			; desplaza D a la derecha, cargando el LSB en el bit DF
		PHI R2		; carga el valor de D en R2.1
		BNF ESCERO	; salta si DF = 0
		SEQ			; salida Q igual a 1
		SKP			; salta la siguiente instrucción de manera incondicional
ESCERO	REQ			; salida Q igual a 0
		SEP R9		; llamar subrutina de demora de 1 bit-time
		DEC R3		; decremento el contador
		GLO R3		; carga la parte baja de R3 en D
		BNZ SHIFT	; salta si D != 0
		SEQ			; Q = 1 (bit de stop) (el ingeniero Korpys dijo que ponga dos bits de stop (dos bit-time))
		SEP R9		; llamar subrutina de demora de 1 bit-time dos veces
		SEP R9
		BR BACK1	; salto incondicional





;---------subrutina de ratardo de tranmisión-------------------------
		ORG  0035FH		; se le sumó 0300H porque el código empieza allí
BACK2	SEP R8			; retorna a subrutina de transmisión 1-Byte	2-Machine Cycles	1 time
DELAY1
		LDI  123D		; carga el valor inmediato en D		2-Byte	2-Machine Cycles	1 time
		PLO  R1			; carga el valor de D en R1.0		1-Byte	2-Machine Cycles	1 time
TIMER1
		DEC  R1     	; decrementa R1						1-Byte	2-Machine Cycles	R1 times
		GLO  R1     	; carga la parte baja de R1 en D	1-Byte	2-Machine Cycles	R1 times
		BNZ  TIMER1   	; salta si D != 0					2-Byte	2-Machine Cycles	R1 times
		BR   BACK2		; salto incondicional				2-Byte	2-Machine Cycles	1 time


;---------subrutina de retardo del programa principal-------------------------
		ORG  0036FH		; se le sumó 0300H porque el código empieza allí
BACK3	SEP R0			; retorna a la rutina principal
DELAY2
		LDI  050H		; carga el valor inmediato en D
		PHI  R1			; carga el valor de D en R1.1
TIMER2
		DEC  R1     	; decrementa R1
		GHI  R1     	; carga la parte alta de R1 en D
		BNZ  TIMER2   	; salta si D != 0
		BR   BACK3		; salto incondicional
		END
