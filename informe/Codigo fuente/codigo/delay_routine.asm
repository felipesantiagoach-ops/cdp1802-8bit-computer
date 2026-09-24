;---------subrutina de ratardo de tranmision-------------------------
		ORG  0005FH		; Num de bytes|	Nnum Ciclos Maq|Nnum de ejecuciones
BACK	SEP TX			;   1-Byte	  |	2-Cliclos Maq  |     1 vez
DELAY					;			  |				   |
		LDI  CONT1BT	;   2-Byte	  |	2-Cliclos Maq  |     1 vez
		PLO  R1			;   1-Byte	  |	2-Cliclos Maq  |     1 vez
TIMER					;			  |				   |
		DEC  R1     	;   1-Byte	  |	2-Cliclos Maq  | CONT1BT veces
		GLO  R1     	;   1-Byte	  |	2-Cliclos Maq  | CONT1BT veces
		BNZ  TIMER   	;   2-Byte	  |	2-Cliclos Maq  | CONT1BT veces
		BR   BACK		;   2-Byte	  |	2-Cliclos Maq  |     1 vez