        DB $86,"(LINE",$A9 ; (LINE)
        DW STOD - 7
PLINE:  DW NEST
        DW GR
        DW LIT
        DW $0040
        DW BBUF
        DW SSMOD
        DW RG
        DW BSCR
        DW STAR
        DW PLUS
        DW BLOCK
        DW PLUS
        DW LIT
        DW $0040
        DW SEMIS
        ;
        DB $85,".LIN",$C5 ; .LINE
        DW PLINE - 9
DLINE:  DW NEST
        DW PLINE
        DW TRLG
        DW TYPE
        DW SEMIS
        ;
        DB $83,"US",$C5  ; USE (ADDR OF
        DW DLINE - 8       ; NEXT BUFFER TO USE)
USE:    DW VAR
        DW FIRSTB
        ;
        DB $84,"PRE",$D6 ; PREV   (ADDR OF
        DW USE - 6         ; PREVIOUSLY USED BUFFER)
PREV:   DW VAR
        DW FIRSTB
        ;
        DB $84,"+BU",$C6 ; +BUF
        DW PREV - 7        ; ADVANCE
PBUF:   DW NEST            ;    BUFFER
        DW BBUF
        DW LIT
        DW $0004
        DW PLUS
        DW PLUS
        DW DUP
        DW LIMIT
        DW EQL
        DW ZBRCH
        DW PBUF1
        DW DROP
        DW FIRST
PBUF1:  DW DUP
        DW PREV
        DW AT
        DW MINS
        DW SEMIS
        ;
        DB $86,"UPDAT",$C5 ; UPDATE
        DW PBUF - 7
UPDAT:  DW NEST
        DW PREV
        DW AT
        DW AT
        DW LIT
        DW $8000
        DW FFOR
        DW PREV
        DW AT
        DW EX
        DW SEMIS
        ;
        DB $8D,"EMPTY-BUFFER",$D3 ; EMPTY-BUFFER
        DW UPDAT - 9
MTBUF:  DW NEST
        DW FIRST
        DW LIMIT
        DW OVER
        DW MINS
        DW ERS
        DW SEMIS
        ;
        ;
        DB $86,"BUFFE",$D2 ; BUFFER
        DW MTBUF - 16
BUFFE:  DW NEST
        DW USE
        DW AT
        DW DUP
        DW GR
BUFF1:  DW PBUF
        DW ZBRCH
        DW BUFF1
        DW USE
        DW EX
        DW R
        DW AT
        DW ZLESS
        DW ZBRCH
        DW BUFF2
        DW R
        DW PLUS2
        DW R
        DW AT
        DW LIT
        DW $7FFF
        DW FAND
        DW ZERO
        DW RSLW
BUFF2:  DW R
        DW EX
        DW R
        DW PREV
        DW EX
        DW RG
        DW PLUS2
        DW SEMIS
        ;
        DB $85,"BLOC",$CB ; BLOCK
        DW BUFFE - 9
BLOCK:  DW NEST
        DW OFST
        DW AT
        DW PLUS
        DW GR
        DW PREV
        DW AT
        DW DUP
        DW AT
        DW R
        DW MINS
        DW DUP
        DW PLUS
        DW ZBRCH
        DW BLOC1
BLOC2:  DW PBUF
        DW ZEQAL
        DW ZBRCH
        DW BLOC3
        DW DROP
        DW R
        DW BUFFE
        DW DUP
        DW R
        DW ONE
        DW RSLW
        DW TWO
        DW MINS
BLOC3:  DW DUP
        DW AT
        DW R
        DW MINS
        DW DUP
        DW PLUS
        DW ZEQAL
        DW ZBRCH
        DW BLOC2
        DW DUP
        DW PREV
        DW EX
BLOC1:  DW RG
        DW DROP
        DW PLUS2
        DW SEMIS
        ;
        DB $83,$52,$2F,$D7 ; R/W
        DW BLOCK - 8
RSLW:   DW NEST
        DW SWAP
        DW LIT
        DW $00FA
        DW SLMOD
        DW DUP
        DW LIT
        DW $0003
        DW GTR
        DW LIT
        DW $0005
        DW QERR
        DW SWAP
        DW LIT
        DW $0008
        DW STAR
        DW LIT
        DW $0001
        DW PLUS
        DW LIT
        DW $001A
        DW SLMOD
        DW DV
        DW CEX
        DW ONE
        DW MINS
        DW SWAP
        DW LIT
        DW $0040
        DW STAR
        DW PLUS
        DW DV
        DW PLUS1
        DW CEX
        DW ZERO
        DW DV
        DW PLUS2
        DW CEX
        DW DV
        DW BBUF
        DW ROT
        DW ZBRCH
        DW RWELSE
        DW BLKRD
        DW BRCH
        DW RWEND
RWELSE: DW BLKWT
RWEND:  DW SEMIS
        DB $0A,"BLOCK-REA",$C4 ; BLOCKREAD
        DW RSLW - 6
BLKRD:  DW $ + 2
        LDI $83
        PHI R4
        PHI R5
        LDI $64
        PLO R4
        LDI $74
        PLO R5
        ;
        SEX R2
        GHI RC
        STXD
        GLO RC
        STXD
        LDA R9
        PHI R7
        LDN R9
        PLO R7
        DEC R9
        DEC R9
        LDN R9
        PLO RC
        DEC R9
        LDN R9
        PHI RC
        INC RC
        INC RC
        DEC R9
        LDN R9
        PLO R8
        DEC R9
        LDN R9
        PHI R8
        DEC R9
        DEC R9
BLKRD2: SEP R4
        DW $8502
        GHI RF
        STR R8
        INC R8
        DEC R7
        GHI R7
        LBNZ BLKRD2
        GLO R7
        LBNZ BLKRD2
        ;
        SEX R2
        IRX
        LDXA
        PLO RC
        LDX
        PHI RC
        SEP RC
        ;
        DB $0B,"BLOCK-WRIT",$C5 ; BLOCK-WRITE
        DW BLKRD - 13
BLKWT:  DW $ + 2
        LDI $83
        PHI R4
        PHI R5
        LDI $64
        PLO R4
        LDI $74
        PLO R5
        ;
        SEX R2
        GHI RC
        STXD
        GLO RC
        STXD
        LDA R9
        PHI R7
        LDN R9
        PLO R7
        DEC R9
        DEC R9
        LDN R9
        PLO RC
        DEC R9
        LDN R9
        PHI RC
        INC RC
        INC RC
        DEC R9
        LDN R9
        PLO R8
        DEC R9
        LDN R9
        PHI R8
        DEC R9
        DEC R9
BLKWT2: LDA R8
        PHI RF
        SEP R4
        DW $8500
        DEC R7
        GHI R7
        LBNZ BLKWT2
        GLO R7
        LBNZ BLKWT2
        ;
        SEX R2
        IRX
        LDXA
        PLO RC
        LDX
        PHI RC
        SEP RC
        ;
        DB $84,"LOA",$C4 ; LOAD
        DW BLKWT - 14
LOAD:   DW NEST
        DW BLK
        DW AT
        DW GR
        DW FIN
        DW AT
        DW GR
        DW ZERO
        DW FIN
        DW EX
        DW BSCR
        DW STAR
        DW BLK
        DW EX
        DW INPT
        DW RG
        DW FIN
        DW EX
        DW RG
        DW BLK
        DW EX
        DW SEMIS
        ;
        DB $C3,"--",$BE ; -->
        DW LOAD - 7
ARROW:  DW NEST      
        DW QLDG
        DW ZERO
        DW FIN
        DW EX
        DW BSCR
        DW BLK
        DW AT
        DW OVER
        DW MODD
        DW MINS
        DW BLK
        DW PLUSS
        DW SEMIS
        ;
        ;
        DB $83,$44,$52,$B0 ; DR0
        DW ARROW - 6
DRZER:  DW NEST
        DW ZERO
        DW OFST
        DW EX
        DW SEMIS
        ;
        ;
        DB $83,$44,$52,$B1 ; DR1
        DW DRZER - 6
DRONE:  DW NEST
        DW BSCR
        DW LIT             ; 250 SCREENS/DISK
        DW $00FA
        DW STAR
        DW OFST
        DW EX
        DW SEMIS
        ;
        ;
        DB $84,"LIS",$D4 ; LIST
        DW DRONE - 6
LIST:   DW NEST
        DW MDCML
        DW CR
        DW DUP
        DW FSCR
        DW EX
        DW PDQ
        DB $06,"SCR # "
        DW DOT
        DW LIT
        DW $0010
        DW ZERO
        DW PDO
LIST1:  DW CR
        DW I
        DW LIT
        DW $0003
        DW DOTR
        DW SPC
        DW I
        DW FSCR
        DW AT
        DW DLINE
        DW QTERM
        DW ZBRCH
        DW LIST2
        DW LVE
LIST2:  DW LUPE
        DW LIST1
        DW CR
        DW SEMIS
        ;
        ;
        DB $85,"INDE",$D8 ; INDEX
        DW LIST - 7
INDEX:  DW NEST
        DW CR
        DW PLUS1
        DW SWAP
        DW PDO
INDE1:  DW CR      
        DW I
        DW LIT
        DW $0003
        DW DOTR
        DW SPC
        DW ZERO
        DW I
        DW DLINE
        DW QTERM
        DW ZBRCH
        DW INDE2
        DW LVE
INDE2:  DW LUPE
        DW INDE1
        DW SEMIS
        ;
        DB $85,"TRIA",$C4 ; TRIAD
        DW INDEX - 8
TRIAD:  DW NEST
        DW CR
        DW LIT
        DW $0003
        DW SLASH
        DW LIT
        DW $0003
        DW STAR
        DW LIT
        DW $0003
        DW OVER
        DW PLUS
        DW SWAP
        DW PDO
TRIA1:  DW CR
        DW I
        DW LIST
        DW QTERM
        DW ZBRCH
        DW TRIA2
        DW LVE
TRIA2:  DW LUPE
        DW TRIA1
        DW CR
        DW LIT
        DW $000F
        DW MSG
        DW CR
        DW SEMIS
        ;
        ;
        DB $85,"FLUS",$C8 ; FLUSH
        DW TRIAD - 8
FLUSH:  DW NEST
        DW LIMIT
        DW FIRST
        DW MINS
        DW BBUF
        DW LIT
        DW $0004
        DW PLUS
        DW SLASH
        DW ZERO
        DW PDO
FL1:    DW LIT
        DW $7FFF
        DW BUFFE
        DW DROP
        DW LUPE
        DW FL1
        DW SEMIS
        ;