;
;	$Id: tb0.asm,v 1.9.2.4.2.7 2018/04/19 23:16:50 loren Exp $
;
; TB-MON.ASM					    PAGE  1
	INCL "1802reg.asm"	;R0-RF defined HRJ

;
; AVOCET XASM18 MACRO-ASSEMBLER SYNONYMS
;
;	CALL ADDRESS	IS A SYNONYM FOR	SEP R4 (D4)
;						DW ADDR
;	EXIT		IS A SYNONYM FOR	SEP R5 (D5)
;	POP		IS A SYNONYM FOR	LDXA (72)
;	PUSH		IS A SYNONYM FOR	STXD (73)
;
; I had to change these pseudo-ops to actual code HRJ	

; L. Christensen 22 Feb 2018, (Membership Card Rev. J)
; sense of EF3 and Q for TTL is +5V idle on P4 pins 4 and 5;
;
; Rx - Pin 4, /EF3, MARK High, (no inversion, 1K resistor R2),
; Tx - Pin 5,    Q, MARK Low,  (inverted by Q7).
;
EFHI    EQU     0       ; 0=active low EF for serial, (0 = +5V MARK,  0V SPACE).
QHI     EQU     0       ; 0=active low Q for serial,  (1 =  0V MARK, +5V SPACE).

; L. Christensen 10 April 2018,
AUTORUN EQU     0       ;  Define a Tiny BASIC Autorun program at $0D00.

; Herb Johnson July 20 2018, EFHI=0 and QHI=1 for Rev J and USB/TTL FTDI dongle.
; Autorun program starts on reset after delay, ends after short loop.
; 1200 baud fixed baud rate at 2Mhz, 2400 baud at 4Mhz, no start CR needed.