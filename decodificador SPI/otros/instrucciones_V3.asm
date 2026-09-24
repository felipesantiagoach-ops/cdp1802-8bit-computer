;--------------DEFINICIONES PREVIAS-----------------------------
; Se usan registros y valores especificos para que se entienda mejor, pero se pueden usar otros registros y otros valores

; Para controlar el 82C55, debe estar en la memoria lo siguiente (Esas posiciones de memoria no deben ser utilizadas por otra rutina, de otro modo, elegir otras direcciones; pero tienen que ser consecutivas y apuntar a la RAM. Notese que asi como estan, en el sistema medio y final no funcionaria, debido a que la RAM embieza en 8000 hex, se comenta esto para que quede claro que estos valores son meramente ilustrarivos, y que a la hora de implementar la rutina deben ser elegidos correctamente y escritos en la RAM en una rutina previa, preferentemente la rutina que configura los puertos del 82C55, la cual debe se ejecutada antes de intentar utlizar el 82C55 o esta rutina)
; los bits de datos son las instruciones que se escriben en la palabra de control (control Word) del 82C55 para controlar sus salidas, para entender de donde salieron ver la seccion de control del puerto C a traves de la palabra de control en la hoja de datos del 82C55

; Direccion |    Dato   | Accion sobre el 82C55
;   7F00    |  0XXX1100	|  para PC6 -> 0
;   7F01    |  0XXX1110	|  para PC7 -> 0
;   7F02    |  0XXX1111	|  para PC7 -> 1
;   7F03    |  0XXX1110	|  para PC7 -> 0
;   7F04    |  XXXXXXXX |  EL MICRO VA A ESCRIBIR AQUI, SE UTILIZA PARA LEER EL PUERTO A
;   7F05    |  0XXX1101	|  para PC6 -> 1

;------------REGISTROS UTILIZADOS--------------------------------

;

; R3 -> F800	R3 apunta a la primera direccion del SPI

; R4 -> 7F00	R4 apunta a la direccion donde estan las instrucciones para hacer Set y Reset de PC6 y PC7 del 82C55, tambien para la lectura del puerto A

; Estos registros deben ser cargados en una rutina previamente, y no deben modificarse en el transcurso de otras rutinas no relacionadas a la del circuito para la comunicacion SPI de manera que siempre esten listas para ser utilizados


;-------------RUTINA DE ESCRITURA Y LECTURA JUNTAS------------------

		; Se parte de que el dato que se quiere escribir esta en el acumulador D, si no se quiere transmitir y solo recibir, entonces no importa que tiene D

	    STR R3	; D -> M(R3)	se escribe el dato a enviar al CD4014
    	SEX R4	; 4 -> X    equivale a decir que ahora R(X) = R4
	    OUT 7	; M(R(X)) -> BUS; R(X) + 1 -> R(X)	Esto hace PC6 -> 0
	    OUT 7	; M(R(X)) -> BUS; R(X) + 1 -> R(X)	Esto hace PC7 -> 0
	    OUT 7	; M(R(X)) -> BUS; R(X) + 1 -> R(X)	Esto hace PC7 -> 1
	    OUT 7	; M(R(X)) -> BUS; R(X) + 1 -> R(X)	Esto hace PC7 -> 0
CHECK:	INP 4	; BUS -> M(R(X)); BUS -> D  se lee el puerto A del 82C55
	    LDX	    ; M(R(X)) -> D
	    SHR	    ; SHIFT D RIGHT, LSB(D) -> DF, 0 -> MSB(D)
	    SHR
	    SHR	    ; Ahora DF = PA2
	    BNF CHECK
	    INC R4
	    OUT 7	; M(R(X)) -> BUS; R(X) + 1 -> R(X)	Esto hace PC6 -> 1
	    DEC R4
	    DEC R4
	    DEC R4
	    DEC R4
	    DEC R4
	    DEC R4	; decremento R4 seis veces para ponerlo en su valor inicial (la instruccion OUT lo modifico, lo quiero dejar como estaba)
	    LDN R3	; M(R(N)) -> D; R(N) + 1 -> R(N)	Hay que tener cuidado porque aumenta R(N)
	    DEC R3	; Decrementa R3 porque la instruccion anterior lo aumento