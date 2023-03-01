include Draw.asm
include Load.asm
include Load2.asm
include getRC.asm
include Draw2.asm
include light.asm
include dark.asm
include FLUSH.asm
include srec.asm
include saveCS.asm
include saveCR.asm
include setCurs.asm
include ssend.asm
.Model HUGE
.286
.Stack 1024
.Data


;piece color:
;------------
;White pieces from 1H-6H
;Black pieces from 7H-0CH
;No piece = 0H

;pieces codes:
;----------------------
;whitepawn 1h
;blackpawn 7h
;whiterook 2h
;blackrook 08h
;whiteknight 3h
;blackknight 9h
;whitebishop 4h
;blackbishop 0Ah
;whiteking 05h
;blackking 0Bh
;whitequeen 06h
;blackqueen 0Ch
;empty square 0h
;-----------------------------
;square codes:
;---------------
;lightsquare 1h
;darksquare 0h

GridArr DW 18h, 09h, 1Ah, 00Ch, 1Bh, 0Ah, 19h, 008h
	    DW 07h, 17h, 07h, 17h, 07h, 17h, 07h, 17h
	    DW 10h, 00h, 10h, 00h, 10h, 00h, 10h, 00h
	    DW 00h, 10h, 00h, 10h, 00h, 10h, 00h, 10h
	    DW 10h, 00h, 10h, 00h, 10h, 00h, 10h, 00h
	    DW 00h, 10h, 00h, 10h, 00h, 10h, 00h, 10h 
        DW 11h, 01h, 11h, 01h, 11h, 01h, 11h, 01h
	    DW 02h, 13h, 04h, 16h, 005h, 14h, 03h, 12h

Checkmate DB ?
SystemTime DW ?
;White pieces move variables
;---------------------------
WSource DB ?            ;OUTSIDE ARRAY LIMIT
WDestination DB ?
WSelectedNo DW 0H
ValidMoveW DW ?         ;1 for invalid & 0 for Valid
ValidTimeW DW ?          ;1 for invalid & 0 for Valid
SIxW DB 52
;OUTBoundW DW 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Grid Data

GridWidth EQU 160
GridHeight EQU 160
GridFilename DB 'board.bin', 0
GridFilehandle DW ?
GridData DB 160*160 dup(0)

;------------------------------------------------------
;Black pieces move variables
;---------------------------
BSource DB ?            ;OUTSIDE ARRAY LIMIT
BDestination DB ?
BSelectedNo DW 0H
ValidMoveB DW ?         ;1 for invalid & 0 for Valid
ValidTimeB DW ?         ;1 for invalid & 0 for Valid
SIxB DB 12
;OUTBoundB DW 0

;String data:
OGINDEX DB ?  
DrawIndex DB ? 
VALID DB 1   
STOPLOOP DB 0

OGC DW ?
OGD DW ?

message  db ?     
user1 db 'User1','$'
user2 db 'User2','$'
scancode db 0 
xposS db 0     
yposS db 1     
xposR db 0     
yposR db 13  
leavemsg db 'Press F3 to end chatting','$'

MES1              DB 'WELCOME TO OUR PROGRAM ^_^','$'
MES               DB 'Please enter your name:','$'
InData            DB 15,?,15 DUP('$')
CONT              DB 'Press Enter key to continue','$'
chatting          DB 'To start chatting press F1','$'
game              DB 'To start the game press F2','$'
line3             DB 'To end the program press ESC','$'
line              DB 80 DUP('-'),'$'
invitation        DB 'You sent a chat invitation!',10,13,'$'
inline            DB 10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10
                  DB 13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,'/Inline/','$'
timelabel         DB 10,13,10,13,'Time Elapsed: ','$'

seconds           db ?
numbuf            db 6 dup(?)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Piece Data
;----------
;white pawns
WPawnFilename DB 'WPawn.bin', 0
WPawnFilehandle DW ?
WPawnData DB 20*20 dup(0)

;black pawns
BPawnFilename DB 'BPawn.bin', 0
BPawnFilehandle DW ?
BPawnData DB 20*20 dup(0)

;black king
BKingFilename DB 'BKing.bin', 0
BKingFilehandle DW ?
BKingData DB 20*20 dup(0)

;white king
WKingFilename DB 'WKing.bin', 0
WKingFilehandle DW ?
WKingData DB 20*20 dup(0)

;black rook
BRookFilename DB 'BRook.bin', 0
BRookFilehandle DW ?
BRookData DB 20*20 dup(0)

;white rook
WRookFilename DB 'WRook.bin', 0
WRookFilehandle DW ?
WRookData DB 20*20 dup(0)

;white queen
WQueenFilename DB 'WQueen.bin', 0
WQueenFilehandle DW ?
WQueenData DB 20*20 dup(0)

;black queen
BQueenFilename DB 'BQueen.bin', 0
BQueenFilehandle DW ?
BQueenData DB 20*20 dup(0)

;white knight
WKnightFilename DB 'WKnight.bin', 0
WKnightFilehandle DW ?
WKnightData DB 20*20 DUP(0)

;black knight
BKnightFilename DB 'BKnight.bin', 0
BKnightFilehandle DW ?
BKnightData DB 20*20 DUP(0)

;white bishop
WBishopFilename DB 'WBishop.bin', 0
WBishopFilehandle DW ?
WBishopData DB 20*20 DUP(0)

;black bishop
BBishopFilename DB 'BBishop.bin', 0
BBishopFilehandle DW ?
BBishopData DB 20*20 DUP(0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.Code

Terminate PROC

MOV AH,0
MOV AL,3
INT 10H                      ;clear the screen
MOV AX, 4C00H
INT 21H                      ;terminate the program

Terminate ENDP

Username PROC
    MOV   AH, 0
    MOV   AL, 3
    INT   10H                      ;clear screen 80x25 chars

    MOV   AH,2
    MOV   DX,030aH
    INT   10H                   ; cursor moved
      
    MOV   AH,9
    MOV   DX,OFFSET MES1
    INT   21H                   ;display string

    MOV   AH,2
    MOV   DX,050aH
    INT   10H                      ;cursor moved
      
    MOV   AH,9
    MOV   DX,OFFSET MES
    INT   21H                      ;display string
      
     MOV   AH,2
    MOV   DX,110AH
    INT   10H                      ;cursor moved

    MOV   AH,9
    MOV   DX,OFFSET CONT
    INT   21H                      ;display string

    MOV   AH,2
    MOV   DX,070CH
    INT   10H                      ;cursor moved

    mov   ah,0AH
    mov   dx,offset InData
    INT   21H                      ;read username from keyboard
    RET
Username ENDP

MainMenu PROC
    MOV   AX,3
    INT   10H                      ; clear screen 80x25 chars

    MOV   AH,2
    MOV   DX,0718H
    INT   10H                      ;cursor moved
      
    MOV   AH,9
    MOV   DX,OFFSET chatting
    INT   21H                      ;display string
      
    MOV   AH,2
    MOV   DX,0A18H
    INT   10H                      ;cursor moved

    MOV   AH,9
    MOV   DX,OFFSET game
    INT   21H                      ;display string

    MOV   AH,2
    MOV   DX,0D18H
    INT   10H                      ;cursor moved

    MOV   AH,9
    MOV   DX,OFFSET line3
    INT   21H                      ;display string

    MOV   AH,2
    MOV   DX,1500H
    INT   10H                      ;cursor moved

    MOV   AH,9
    MOV   DX,OFFSET line
    INT   21h                      ;display notification bar

    RET
MainMenu ENDP

OpenFile PROC 

    PUSHA
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    MOV DX, BX
    INT 21h
    MOV [SI], AX
    POPA
    RET

OpenFile ENDP

ReadData PROC
    PUSHA
    MOV AH,3Fh
    MOV BX, DX
    MOV CX,20*20 ; number of bytes to read
    MOV DX, SI
    INT 21h
    POPA
    RET
ReadData ENDP 

CloseFile PROC
    PUSHA
	MOV AH, 3Eh
	MOV BX, DX
	INT 21h
    POPA
	RET
CloseFile ENDP

Loadin Proc
  PUSHA
  MOV  CX, 20*20            ;COUNTER.
  Address:
  MOV  AX, [ SI ]         ;GET TWO BYTES FROM FREQUENCY.
  MOV  [ DI ], AX         ;PUT TWO BYTES INTO ARRAY.
  ADD  SI, 1              ;NEXT TWO BYTES IN FREQUENCY.
  ADD  DI, 1              ;NEXT TWO BYTES IN ARRAY.
  sub  CX, 1              ;COUNTER-2.
  JNZ  Address   
  POPA
  RET 
Loadin ENDP

DrawGrid PROC
    PUSHA
    MOV BX, 00H     ;BH carries index of square
    MOV AX,00H      ;BL carries index of array
    LEA SI, GridArr
    Draww:
    PUSH BX
    AND BX, 00FFh
    MOV AX, [SI + BX]       ;AX holds the element in the Grid array
    POP BX                  
    SHR AX, 4
    AND AX, 0FH
    CMP AX, 0               ;compare the value with that of dark and light square
    JE DrawDark             ;draws dark if dark
    JNE DrawLight           ;draw light if light detected
    DrawDark:
    dark BH
    INC BH                  ;BH increased by 1
    MOV DrawIndex, BH
    ADD BL,2                ;BL is increased by 2 as array of words
    CMP BL,127
    JNS Break
    JMP Draww
    DrawLight:
    light BH
    INC BH
    ADD BL,2
    CMP BL,127
    JNS Break
    JMP Draww
    Break: 
    POPA
    RET
DrawGrid ENDP

CheckTimew PROC FAR
PUSHA

; Get the current time and store it in the variable "SystemTime"
PUSH DX
PUSH AX
PUSH CX

MOV AH, 2Ch
INT 21h             ;Get system time
XCHG CL, DL
XCHG DL, DH         ; DH stores minute & DL stores second
MOV SystemTime, DX ; Store the current time in the "SystemTime" variable

;POP DX
POP CX
POP AX

SHR AX, 8
CMP DL, AL
JG MoveClear

SUB AL,3
CMP AL,DL
JG MoveClear
JMP MoveNotCLear

MoveClear:
MOV CX, 0
MOV ValidTimeW, CX
JMP EndCheck

MoveNotCLear:
MOV CX, 1
MOV ValidTimeW, CX

EndCheck:
POP DX
POPA
RET
CheckTimew ENDP

CheckTimeB PROC FAR
PUSHA

; Get the current time and store it in the variable "SystemTime"
PUSH DX
PUSH AX
PUSH CX

MOV AH, 2Ch
INT 21h             ;Get system time
XCHG CL, DL
XCHG DL, DH         ; DH stores minute & DL stores second
MOV SystemTime, DX ; Store the current time in the "SystemTime" variable

;POP DX
POP CX
POP AX

SHR AX, 8
CMP DL, AL
JG MoveClearB

SUB AL,3
CMP AL,DL
JG MoveClearB
JMP MoveNotCLearB

MoveClearB:
MOV CX, 0
MOV ValidTimeB, CX
JMP EndCheckB

MoveNotCLearB:
MOV CX, 1
MOV ValidTimeB, CX

EndCheckB:
POP DX
POPA
RET
CheckTimeB ENDP

getsource PROC
PUSHA
    PUSH CX
    PUSH DX  
    
    PUSH AX
    MOV AL, SIxW
    MOV WSource, AL
    POP AX
    ;Check if square has white piece
;----------------------------------------
    LEA SI, GridArr
    ;AX holds starting square
    MOV BH,0
    MOV BL, WSource
    ADD BX,BX
    MOV AX, [SI+BX]

    PUSH AX
    AND AX, 0FH
    CMP AX, 0H
    JE InvalidS
    CMP AX, 7H
    JGE InvalidS 
    JMP ValidS

    ValidS:
    POP AX
    ;Check if downtime on piece is up
    ;----------------------------------
    CALL CheckTimew       
    CMP ValidTimeW, 1
    JE InvalidTS
    ;--------------------------------------

    MOV CX,1
    MOV WSelectedNo, CX
    JMP POPPINGS

    InvalidS:
    POP AX
    InvalidTS:
    MOV CX,0
    MOV WSelectedNo, CX
    JMP POPPINGS
;----------------------------------------------
    ;POPPING CX AND DX TO RESTORE THEIR VALUE
    POPPINGS:
    POP DX 
    POP CX

POPA
RET
getsource ENDP

getdest PROC
PUSHA
    PUSH CX
    PUSH DX  
    
    PUSH AX
    MOV AL, SIxW
    MOV WDestination, AL
    POP AX

    ;Check if square is black (opposite color)
;----------------------------------------
    LEA SI, GridArr
    ;AX holds starting square
    MOV BH,0
    MOV BL, WDestination
    ADD BX,BX
    MOV AX, [SI+BX]
    AND AX, 0FH
    CMP AX, 0H
    JE ValidW
    CMP AX, 7H
    JGE ValidW

    JMP InvalidW 

    ValidW:
    MOV CX,0
    MOV WSelectedNo, CX
    MOV ValidMoveW, CX
    JMP POPPINGD

    InvalidW:
    MOV CX,1
    MOV WSelectedNo, CX
    MOV ValidMoveW, CX
    JMP POPPINGD
;----------------------------------------------    
    
    ;POPPING CX AND DX TO RESTORE THEIR VALUE
    POPPINGD:
    POP DX 
    POP CX
POPA
RET
getdest ENDP

getsourceB PROC
PUSHA
    PUSH CX
    PUSH DX  
    
    PUSH AX
    MOV AL, SIxB
    MOV BSource, AL
    POP AX
    ;Check if square has black piece
;----------------------------------------
    LEA SI, GridArr
    ;AX holds starting square
    MOV BH,0
    MOV BL, BSource
    ADD BX,BX
    MOV AX, [SI+BX]

    PUSH AX
    AND AX, 0FH
    CMP AX, 0H
    JE InvalidSB
    CMP AX, 7H
    JS InvalidSB 
    JMP ValidSB

    ValidSB:
    POP AX
    ;Check if downtime on piece is up
    ;----------------------------------
    CALL CheckTimeB       
    CMP ValidTimeB, 1
    JE InvalidTSB
    ;--------------------------------------

    MOV CX,1
    MOV BSelectedNo, CX
    JMP POPPINGSB

    InvalidSB:
    POP AX
    InvalidTSB:
    MOV CX,0
    MOV BSelectedNo, CX
    JMP POPPINGSB
;----------------------------------------------
    ;POPPING CX AND DX TO RESTORE THEIR VALUE
    POPPINGSB:
    POP DX 
    POP CX

POPA
RET
getsourceB ENDP

getdestB PROC   
PUSHA
    PUSH CX
    PUSH DX  
    
    PUSH AX
    MOV AL, SIxB
    MOV BDestination, AL
    POP AX
    ;Check if square is white (opposite color)
;----------------------------------------
    LEA SI, GridArr
    ;AX holds starting square
    MOV BH,0
    MOV BL, BDestination
    ADD BX,BX
    MOV AX, [SI+BX]
    AND AX, 0FH
    CMP AX, 0H
    JE ValidB
    CMP AX, 7H
    JS ValidB

    JMP InvalidB

    ValidB:
    MOV CX,0
    MOV BSelectedNo, CX
    MOV ValidMoveB, CX
    JMP POPPINGDB

    InvalidB:
    MOV CX,1
    MOV BSelectedNo, CX
    MOV ValidMoveB, CX
    JMP POPPINGDB
;----------------------------------------------    
    
    ;POPPING CX AND DX TO RESTORE THEIR VALUE
    POPPINGDB:
    POP DX 
    POP CX
POPA
RET
getdestB ENDP

getRCW PROC 
    MOV DL, AL      ; MOVe index value into DL
    SHR DL, 3       ; divide DL by 8 to get the row (since 8 columns per row)
    AND DL, 7       ; use AND to mask out all bits except the last 3, which gives us the row number
    MOV DH, 0       ; clear upper 8 bits of DX
    ;MOV DX, DL      ; MOVe row value into lower 8 bits of DX
    PUSH AX
    MOV AX, 20      ; load value 20 into AX
    MUL DX          ; multiply row value by 20 and store result in DX
    MOV DX, AX
    POP AX
    MOV CL, AL      ; MOVe index value into CL
    AND CL, 7       ; use AND to mask out all bits except the last 3, which gives us the column number
    MOV AX, 20      ; load value 20 into AX
    PUSH DX
    MUL CX          ; multiply column value by 20 and store result in CX
    MOV CX, AX
    POP DX
    RET
getRCW ENDP

getRCB PROC 
    ; Input: index (0-63) in AL
    ; Output: row in DL, column in CL
    MOV DL, AL      ; MOVe index value into DL
    SHR DL, 3       ; divide DL by 8 to get the row (since 8 columns per row)
    AND DL, 7       ; use AND to mask out all bits except the last 3, which gives us the row number
    MOV DH, 0       ; clear upper 8 bits of DX
    ;MOV DX, DL      ; MOVe row value into lower 8 bits of DX
    PUSH AX
    MOV AX, 20      ; load value 20 into AX
    MUL DX          ; multiply row value by 20 and store result in DX
    MOV DX, AX
    POP AX
    MOV CL, AL      ; MOVe index value into CL
    AND CL, 7       ; use AND to mask out all bits except the last 3, which gives us the column number
    MOV AX, 20      ; load value 20 into AX
    PUSH DX
    MUL CX          ; multiply column value by 20 and store result in CX
    MOV CX, AX
    POP DX
    RET
getRCB ENDP

FillBorderW PROC FAR
    PUSHA
    
    MOV AL, SIxW
    CALL getRCW

    ADD CX,3          ;COLUMN
    ADD DX,3          ;ROW
    MOV BH,0          ;PAGE NUMBER
    
    MOV AH,0DH
    INT 10H
    
    SUB CX,3
    SUB DX,3  
    
    ;DRAWING THE BORDER
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV  BL,19
    MOV  AH,0CH
               
    LL1:         ;DRAWING UPPER LINE
        INT  10H
        INC  CX
        DEC  BL
        JNZ  LL1
        MOV  BL,19

    LL2:         ;DRAWING LINE ON THE RIGHT 
        INC  DX
        DEC  BL
        INT  10H
        JNZ  LL2
        MOV  BL,19

    LL3:         ;DRAWING LOWER LINE
        DEC  CX
        DEC  BL
        INT  10H
        JNZ  LL3
        MOV  BL,19

    LL4:         ;DRAWING LINE ON THE LEFT
        DEC  DX
        DEC  BL
        INT  10H
        JNZ  LL4
    POPA
    RET        
FillBorderW ENDP

FillBorderB PROC FAR
    PUSHA
    
    MOV AL, SIxB
    CALL getRCB

    ADD CX,3          ;COLUMN
    ADD DX,3          ;ROW
    MOV BH,0          ;PAGE NUMBER
    
    MOV AH,0DH
    INT 10H
    
    SUB CX,3
    SUB DX,3  
    
    ;DRAWING THE BORDER
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV  BL,19
    MOV  AH,0CH
               
    LL1B:         ;DRAWING UPPER LINE
        INT  10H
        INC  CX
        DEC  BL
        JNZ  LL1
        MOV  BL,19

    LL2B:         ;DRAWING LINE ON THE RIGHT 
        INC  DX
        DEC  BL
        INT  10H
        JNZ  LL2
        MOV  BL,19

    LL3B:         ;DRAWING LOWER LINE
        DEC  CX
        DEC  BL
        INT  10H
        JNZ  LL3
        MOV  BL,19

    LL4B:         ;DRAWING LINE ON THE LEFT
        DEC  DX
        DEC  BL
        INT  10H
        JNZ  LL4
    POPA
    RET        
FillBorderB ENDP

drawpiece PROC
    PUSHA
    MOV DH,DL
    ADD DH,20    ;end row
    MOV CH,CL
    ADD CH,20     ;end column
    MOV AH,0ch
    PUSH CX
    MOV CH,0
    MOV SI,CX
    POP CX
    MOV AL,[BX]
    CMP AL,00H
    JNE drawblack
    JE drawhite
drawblack:
    MOV AL,[BX]
    CMP AL,00H
    JNE NoIntB
    PUSH CX
    PUSH DX
    MOV DH,0
    MOV CH,0
    INT 10h 
    POP DX
    POP CX
NoIntB:
    INC CL
    INC BX
    CMP CL,CH      ;end column
JNE drawblack
    PUSH BX
	MOV BX,SI
    MOV CL, BL
    POP BX
    INC DL
    CMP DL , DH   ;end row
JNE drawblack
POPA
RET
drawhite:
    MOV AL,[BX]
    CMP AL,88H
    JNS NoIntW
    PUSH CX
    PUSH DX
    MOV DH,0
    MOV CH,0
    INT 10h 
    POP DX
    POP CX
NoIntW:
    INC CL
    INC BX
    CMP CL,CH      ;end column
JNE drawhite
    PUSH BX
	MOV BX,SI
    MOV CL, BL
    POP BX
    INC DL
    CMP DL , DH   ;end row
JNE drawhite
POPA
RET
drawpiece ENDP

WKnightD PROC
PUSHA
LEA BX, WKnightData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
WKnightD ENDP

BKnightD PROC
PUSHA
LEA BX, BKnightData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
BKnightD ENDP

WPawnD PROC
PUSHA
LEA BX, WPawnData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
WPawnD ENDP

BPawnD PROC
PUSHA
LEA BX, BPawnData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
BPawnD ENDP

WBishopD PROC
PUSHA
LEA BX, WBishopData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
WBishopD ENDP

BBishopD PROC
PUSHA
LEA BX, BBishopData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
BBishopD ENDP

WRookD PROC
PUSHA
LEA BX, WRookData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
WRookD ENDP

BRookD PROC
PUSHA
LEA BX, BRookData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
BRookD ENDP

WKingD PROC
PUSHA
LEA BX, WKingData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
WKingD ENDP

BKingD PROC
PUSHA
LEA BX, BKingData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
BKingD ENDP

WQueenD PROC
PUSHA
LEA BX, WQueenData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
WQueenD ENDP

BQueenD PROC
PUSHA
LEA BX, BQueenData
PUSH BX
PUSH AX
    MOV AX, DI    ;AL=row   AH=Col  ;DI holdds index
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    XCHG AH,AL     
         
    MOV DH,0     
    MOV DL,AH      ;DX=row
                   ;CX=Col 
    MOV CX, 20
    MUL CL
    
    MOV CX, AX    
    PUSH CX
   
    MOV AX, DX
    MOV CX,20  
    
    MUL CL
    MOV DX,AX
    POP CX
POP AX
POP BX
CALL drawpiece
POPA
RET
BQueenD ENDP

DrawSingle PROC
    PUSHA
    CMP AX, 1h             
    JE WhitePS
    CMP AX,7h
    JE  BlackPS
    CMP AX, 2h
    JE WhiteRS
    CMP AX, 08h
    JE BlackRS
    CMP AX, 3h
    JE WhiteKnS
    CMP AX, 9h
    JE BlackKnS
    CMP AX, 4h
    JE WhiteBS
    CMP AX, 0Ah
    JE BlackBS
    CMP AX, 05h
    JE WhiteKS
    CMP AX, 0Bh
    JE BlackKS
    CMP AX, 06h
    JE WhiteQS
    CMP AX, 0Ch
    JE BlackQS
    CMP AX,00H
    JE NoneS
          
    WhitePS:
    CALL WPawnD     ;TAKES VALUE IN DI AS INDEX
    POPA
    RET

    BlackPS:
    CALL BPawnD
    POPA
    RET

    WhiteRS:
    CALL WRookD
    POPA
    RET
    
    BlackRS:
    CALL BRookD 
    POPA
    RET

    WhiteKnS:
    CALL WKnightD
    POPA
    RET                 

    BlackKnS:
    CALL BKnightD
    POPA
    RET

    WhiteBS:
    CALL WBishopD
    POPA
    RET

    BlackBS:
    CALL BBishopD
    POPA
    RET

    WhiteKS:
    CALL WKingD
    POPA
    RET

    BlackKS:
    CALL BKingD
    POPA
    RET

    WhiteQS:
    CALL WQueenD
    POPA
    RET              
 
    BlackQS:
    CALL BQueenD
    POPA
    RET

    NoneS:
    POPA
    RET

RET
DrawSingle ENDP

DrawSquare PROC             ;TAKES VALUE IN BL AS INDEX
    PUSHA
    SHR AX, 4  
    AND AX, 0FH             
    CMP AX, 0               ;compare the value with that of dark and light square
    JE DrawDarkS             ;draws dark if dark
    JNE DrawLightS           ;draw light if light detected
    DrawDarkS:
    dark BL
    POPA
    RET
    DrawLightS:
    light BL
    POPA
    RET
DrawSquare ENDP   

MOVEW PROC
    PUSHA
    LEA SI, GridArr
    ;AX holds starting square
    MOV BH,0
    MOV BL, WSource
    ADD BX,BX
    MOV AX, [SI+BX]
    MOV BL, WSource
    
    PUSH AX
    CALL DrawSquare
    POP AX

    ;DX holds end square
    MOV BH,0
    MOV BL, WDestination     ;DX HOLDS INDEX OF PIECE IN GRID ARR
    ADD BX,BX
    MOV DX, [SI+BX]
    MOV BH, 0
    MOV BL, WDestination

    ;DRAWSQUARE REQUIRES VALUE IN BL (BX)
    ;PUSH BX
    PUSH AX
    MOV AX, DX
    CALL DrawSquare
    POP AX
    ;POP BX

    MOV DI,BX

    PUSH AX
    ;SHR AX, 4 
    AND AX, 0Fh
    CALL DrawSingle    ;DRAWSINGLE REQUIRES VALUE IN DX AS PIECE CODE AND DI AS INDEX
    POP AX
    ;UPDATING THE GRID ARRAY
    ;AX has source data and DX has destination data
    ;BX has destination index

    ;Update down time on piece
    ;-------------------------------
    ;push to maintain
    PUSH DX
    PUSH CX
    PUSH AX
    
    MOV AH, 2Ch
    INT 21h             ;Get system time
    XCHG CL, DL
    XCHG DL, DH         ; DH stores minute & DL stores second    
    ;MOV AX, DX          ;AX has time now

    AND DX,0FFH         ;DX has seconds only stored in AL
    
    ADD DX, 3
    ;POP DX
    ;PUSH DX

    ;AND DX, 0FFH
    POP AX
    AND AX, 0FFH
    OR AH, DL

    POP CX
    POP DX
    ;-------------------------------
  
    PUSH CX
    PUSH BX

    MOV CX, AX
    MOV BX, DX

    AND CX, 0FF0Fh
    AND BX, 0FF0FH

    AND AX, 0F0H
    AND DX, 0F0H

    OR DX, CX
    OR AX, BX
    
    POP BX
    POP CX

    ADD BX, BX
    MOV [SI+BX], DX


    MOV BH, 0
    MOV BL, WSource

    AND AX,0FFF0H
    ADD BX,BX
    MOV [SI+BX], AX
 
    POPA
    RET
MOVEW ENDP

MOVEB PROC
    PUSHA
    LEA SI, GridArr
    ;AX holds starting square
    MOV BH,0
    MOV BL, BSource
    ADD BX,BX
    MOV AX, [SI+BX]
    MOV BL, BSource
    
    PUSH AX
    CALL DrawSquare
    POP AX

    ;DX holds end square
    MOV BH,0
    MOV BL, BDestination     ;DX HOLDS INDEX OF PIECE IN GRID ARR
    ADD BX,BX
    MOV DX, [SI+BX]
    MOV BH, 0
    MOV BL, BDestination

    ;DRAWSQUARE REQUIRES VALUE IN BL (BX)
    ;PUSH BX
    PUSH AX
    MOV AX, DX
    CALL DrawSquare
    POP AX
    ;POP BX

    MOV DI,BX

    PUSH AX
    ;SHR AX, 4 
    AND AX, 0Fh
    CALL DrawSingle    ;DRAWSINGLE REQUIRES VALUE IN DX AS PIECE CODE AND DI AS INDEX
    POP AX
    ;UPDATING THE GRID ARRAY
    ;AX has source data and DX has destination data
    ;BX has destination index

    ;Update down time on piece
    ;-------------------------------
    ;push to maintain
    PUSH DX
    PUSH CX
    PUSH AX
    
    MOV AH, 2Ch
    INT 21h             ;Get system time
    XCHG CL, DL
    XCHG DL, DH         ; DH stores minute & DL stores second    
    ;MOV AX, DX          ;AX has time now

    AND DX,0FFH         ;DX has seconds only stored in AL
    
    ADD DX, 3
    ;POP DX
    ;PUSH DX

    ;AND DX, 0FFH
    POP AX
    AND AX, 0FFH
    OR AH, DL

    POP CX
    POP DX
    ;-------------------------------
  
    PUSH CX
    PUSH BX

    MOV CX, AX
    MOV BX, DX

    AND CX, 0FF0Fh
    AND BX, 0FF0FH

    AND AX, 0F0H
    AND DX, 0F0H

    OR DX, CX
    OR AX, BX
    
    POP BX
    POP CX

    ADD BX, BX
    MOV [SI+BX], DX


    MOV BH, 0
    MOV BL, BSource

    AND AX,0FFF0H
    ADD BX,BX
    MOV [SI+BX], AX
 
    POPA
    RET
MOVEB ENDP

FUNC PROC FAR 
    PUSH SI
    PUSH CX
    PUSH DX


    LEA SI,GridArr 
    
    
    ;THE DIVISOR AND THE COORDS
    MOV BL,20
    
    
    
    ;PUSHING THE CX AND DX TO MAINTAIN THEIR VALUE 
    PUSH CX
    PUSH DX  
    
  
    
    
    ;DIVIDING THE COLUMN PART AND INCREMENTING THE FINAL ANSWER
    MOV AX,CX
    DIV BL
    
    MOV DrawIndex,AL
    
    ;DIVIDING THE ROW PART
    MOV AX,DX
    DIV BL
    
    MOV CL,AL
    
    ;INSTEAD OF MULTIPLYING
    MOV AL,0
    ADDINGG:
    ADD AL,8
    DEC CL
    JNZ ADDINGG
    
    
    ;ADDING TO GET THE FINAL INDEX
    ADD DrawIndex,AL
  
    ;DOUBLING THE VALUE AS THE ARR IS WORD
    MOV AL,DrawIndex
    ADD AL,AL
    MOV DrawIndex,AL
    
    ;STORING THE FINAL ARRAY ELEMENT IN BX
    MOV BL,DrawIndex
    MOV BH,00 
    
    MOV BX,[SI+BX]
    
    
    ;POPPING CX AND DX TO RESTORE THEIR VALUE
    POP DX 
    POP CX  
    
    
    CMP STOPLOOP,1
    JZ RETURN
    
    
    ;CHECKING IF THE PIECE IS WHITE OR BLACK 
      
    SHL BX,12 
    SHR BX,12
    
    CMP BX,1H
    JZ WHITERSS
    
    CMP BX,7H
    JZ BLACKERSS
    
    CMP BX,5H
    JZ WHITERSS
    
    CMP BX,0AH
    JZ BLACKERSS
    
    CMP BX,4H
    JZ  WHITERSS
    
    CMP BX,8H
    JZ BLACKERSS
    
    CMP BX,3H
    JZ WHITERSS
    
    CMP BX,9H
    JZ BLACKERSS
    
    CMP BX,2H
    JZ WHITERSS
    
    CMP BX,0CH
    JZ BLACKERSS
    
    CMP BX,6H
    JZ WHITERSS
    
    CMP BX,0BH
    JZ BLACKERSS
    
    
    JMP LABEL210
    
    WHITERSS:
    MOV STOPLOOP,1
    JMP RETURN
    
    BLACKERSS:
    MOV STOPLOOP,1
    JMP RETURN
    
    
    
    LABEL210:
    
       
        
        MOV AL,7H
        
        MOV SI,CX
        ADD SI,20 
      
        
        
        MOV DI,DX
        ADD DI,20

       
        ;LOOP TO DRAW THE ROWS
        DRAW5225:
         
        MOV AH,0CH
        INT 10H
        INC CX
        CMP CX,SI
        JNE DRAW5225
       
        ;INCREMENTING THE VALUE TO DRAW THE NEXT ROW
        MOV CX,SI
        SUB CX,20
        INC DX
        CMP DX,DI
        JNE DRAW5225
        
        ;RESTORING THE VALUES OF CX AND DX
        

        POP DX
        POP CX
        POP SI
        RET
     
    RETURN:
     POP DX
        POP CX
        POP SI
    RET
     
FUNC ENDP 

WK500 PROC 
     
     MOV STOPLOOP,0
     
     PUSH CX
     PUSH DX
     
     ADD CX,20 
     CMP CX,140
     JG WK2
     
     
     CALL FUNC
     
     
     WK2:
     MOV STOPLOOP,0
     POP DX
     POP CX 
     
     
     
     PUSH CX
     PUSH DX
     
     ADD DX,20
     CMP DX,140
     JG WK3
     
     
     CALL FUNC 
     
     WK3:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     
     ;THIRD MOVE
     PUSH CX
     PUSH DX
     
     SUB CX,20 
     JS WK4
     
     CALL FUNC
    
     WK4:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
      
     ;FOURTH MOVE
     PUSH CX
     PUSH DX   
     
     SUB DX,20
     JS WK5
     
     CALL FUNC
     
     
     WK5:
     MOV STOPLOOP,0
     POP DX  
     POP CX 
     
     
     ;DIAGONAL UP RIGHT
     PUSH CX 
     PUSH DX 
     
     ADD CX,20
     SUB DX,20  
     JS WK6
     
     CMP CX,140
     JG WK6
     
     
     
     CALL FUNC
     
     WK6:
     MOV STOPLOOP,0
     POP DX
     POP CX   
     
     ;DIAGONAL UP LEFT
     PUSH CX 
     PUSH DX 
     
     SUB CX,20
     JS WK7
     SUB DX,20
     JS WK7 
      
     CALL FUNC
     
     WK7:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     ;DIAGONAL DOWN RIGHT
     PUSH CX 
     PUSH DX 
     
     ADD CX,20
     ADD DX,20
     CMP CX,140
     JG WK8
     CMP DX,140
     JG WK8
     
     CALL FUNC
    
     WK8:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     ;DIAGONAL DOWN LEFT
     PUSH CX 
     PUSH DX 
     
     SUB CX,20
     JS WK9
     ADD DX,20
     CMP DX,140
     JG WK9
     
     CALL FUNC
     
     
     WK9:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     ;TODO JUMP TO SELECTING ONE OF THE AVAILABLE SQUARES
     
     
     RET
    
WK500 ENDP

BK500 PROC FAR 

     MOV STOPLOOP,0
     
     PUSH CX
     PUSH DX
     
     ADD CX,20 
     CMP CX,140
     JG BK2
     
     
     CALL FUNC
     
     
     BK2:
     MOV STOPLOOP,0
     POP DX
     POP CX 
     
     
     
     PUSH CX
     PUSH DX
     
     ADD DX,20
     CMP DX,140
     JG BK3
     
     
     CALL FUNC 
     
     BK3:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     
     ;THIRD MOVE
     PUSH CX
     PUSH DX
     
     SUB CX,20 
     JS BK4
     
     CALL FUNC
    
     BK4:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
      
     ;FOURTH MOVE
     PUSH CX
     PUSH DX   
     
     SUB DX,20
     JS BK5
     
     CALL FUNC
     
     
     BK5:
     MOV STOPLOOP,0
     POP DX  
     POP CX 
     
     
     ;DIAGONAL UP RIGHT
     PUSH CX 
     PUSH DX 
     
     ADD CX,20
     SUB DX,20  
     JS BK6
     
     CMP CX,140
     JG BK6
     
     
     
     CALL FUNC
     
     BK6:
     MOV STOPLOOP,0
     POP DX
     POP CX   
     
     ;DIAGONAL UP LEFT
     PUSH CX 
     PUSH DX 
     
     SUB CX,20
     JS BK7
     SUB DX,20
     JS BK7 
      
     CALL FUNC
     
     BK7:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     ;DIAGONAL DOWN RIGHT
     PUSH CX 
     PUSH DX 
     
     ADD CX,20
     ADD DX,20
     CMP CX,140
     JG BK8
     CMP DX,140
     JG BK8
     
     CALL FUNC
    
     BK8:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     ;DIAGONAL DOWN LEFT
     PUSH CX 
     PUSH DX 
     
     SUB CX,20
     JS BK9
     ADD DX,20
     CMP DX,140
     JG BK9
     
     CALL FUNC
     
     
     BK9:
     MOV STOPLOOP,0
     POP DX
     POP CX
     
     ;TODO JUMP TO SELECTING ONE OF THE AVAILABLE SQUARES
     
     
     RET

BK500 ENDP

WKN500 PROC FAR

    ;MOVE1
     MOV STOPLOOP,0
     PUSH CX
     PUSH DX
     
     
     ADD CX,20
     CMP CX,140
     JG WKNLABEL1
     ADD DX,40
     CMP DX,140
     JG WKNLABEL1

     CALL FUNC
     
    
     
    
    
     WKNLABEL1:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     ;MOVE2
     PUSH CX
     PUSH DX
     
     
     SUB CX,20
     JS WKNLABEL2
     ADD DX,40
     CMP DX,140
     JG WKNLABEL2
     
     CALL FUNC
     
     
     
     WKNLABEL2:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE3
     PUSH CX
     PUSH DX
     
     SUB DX,40 
     JS WKNLABEL3
     ADD CX,20
     CMP CX,140
     JG WKNLABEL3
     
     
     CALL FUNC
     
     
     
     WKNLABEL3:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE4
     PUSH CX
     PUSH DX
     
   
     SUB CX,20 
     JS WKNLABEL4
     SUB DX,40
     JS WKNLABEL4
    
     CALL FUNC
    
     
     
     WKNLABEL4:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE5
     PUSH CX
     PUSH DX
     
     
     ADD CX,40  
     CMP CX,140
     JG WKNLABEL5
     SUB DX,20
     JS WKNLABEL5
     
     
     CALL FUNC
     
     
     
     
     WKNLABEL5:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE6
     PUSH CX
     PUSH DX
     
     
     SUB CX,40  
     JS WKNLABEL6
     SUB DX,20
     JS WKNLABEL6
     
     CALL FUNC
    
     
     WKNLABEL6:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE7
     PUSH CX
     PUSH DX
     
    
     ADD CX,40  
     CMP CX,140 
     JG WKNLABEL7
     ADD DX,20
     CMP DX,140 
     JG WKNLABEL7 
     
     CALL FUNC
     
     
     WKNLABEL7:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE8
     PUSH CX
     PUSH DX
     
     
     SUB CX,40 
     JS WKNLABEL8
     ADD DX,20 
     CMP DX,140 
     JG WKNLABEL8
     
     CALL FUNC
     
     
     
     WKNLABEL8:
     POP DX
     POP CX
      ;TODO JUMP TO SELECTING ONE OF THE AVAILABLE SQUARES  
      
      RET
    
WKN500 ENDP

BKN500 PROC FAR

    ;MOVE1
     MOV STOPLOOP,0
     PUSH CX
     PUSH DX
     
     
     ADD CX,20
     CMP CX,140
     JG BKNLABEL1
     ADD DX,40
     CMP DX,140
     JG BKNLABEL1


     CALL FUNC
     
     
    
    
     BKNLABEL1:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     ;MOVE2
     PUSH CX
     PUSH DX
     
     
     SUB CX,20
     JS BKNLABEL2
     ADD DX,40
     CMP DX,140
     JG BKNLABEL2
     
     CALL FUNC
     
     
     
     BKNLABEL2:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE3
     PUSH CX
     PUSH DX
     
     SUB DX,40 
     JS BKNLABEL3
     ADD CX,20
     CMP CX,140
     JG BKNLABEL3
     
     
     CALL FUNC
     
     
     
     BKNLABEL3:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE4
     PUSH CX
     PUSH DX
     
   
     SUB CX,20 
     JS BKNLABEL4
     SUB DX,40
     JS BKNLABEL4
    
     CALL FUNC
    
     
     
     BKNLABEL4:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE5
     PUSH CX
     PUSH DX
     
     
     ADD CX,40  
     CMP CX,140
     JG BKNLABEL5
     SUB DX,20
     JS BKNLABEL5
     
     
     CALL FUNC
     
     
     
     
     BKNLABEL5:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE6
     PUSH CX
     PUSH DX
     
     
     SUB CX,40  
     JS BKNLABEL6
     SUB DX,20
     JS BKNLABEL6
     
     CALL FUNC
    
     
     BKNLABEL6:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE7
     PUSH CX
     PUSH DX
     
    
     ADD CX,40  
     CMP CX,140 
     JG BKNLABEL7
     ADD DX,20
     CMP DX,140 
     JG BKNLABEL7 
     
     CALL FUNC
     
     
     BKNLABEL7:
     POP DX
     POP CX
     MOV STOPLOOP,0
     ;MOVE8
     PUSH CX
     PUSH DX
     
     
     SUB CX,40 
     JS BKNLABEL8
     ADD DX,20 
     CMP DX,140 
     JG BKNLABEL8
     
     CALL FUNC
     
     
     
     BKNLABEL8:
     POP DX
     POP CX
      ;TODO JUMP TO SELECTING ONE OF THE AVAILABLE SQUARES  
      
      RET
    
BKN500 ENDP 

WPA500 PROC 
    
    MOV STOPLOOP,0
     ;MOVING ONE STEP UP
     PUSH DX
     SUB DX,20 
     
     JS LABEL69
     CALL FUNC
     
     LABEL69: 
     POP DX
     RET
    
WPA500 ENDP

BPA500 PROC 
    
    MOV STOPLOOP,0
     ;MOVING ONE STEP UP
     PUSH DX
     ADD DX,20 
     CMP DX,140

     JG LABEL690
     CALL FUNC
     
     LABEL690: 
     POP DX
     RET
    
BPA500 ENDP

BQ500 PROC 

    ;;MOVING TO THE RIGHT
     PUSH CX
     PUSH DX
     MOV STOPLOOP,0
     
     MOVEBQ1:
     CMP STOPLOOP,1
     JZ MOVEBQ2S

     ADD CX,20
     CMP CX,140
     
     JG  MOVEBQ2S
     
     CALL FUNC
     
     JMP MOVEBQ1 
     
     
    
    
     MOVEBQ2S:
     POP DX
     POP CX
     MOV STOPLOOP,0
     
     ;MOVING TO THE LEFT
     PUSH CX
     PUSH DX
     
     MOVEBQ2:
     CMP STOPLOOP,1
     JZ MOVEBQ3S
     
     SUB CX,20
     JS MOVEBQ3S
     
     CALL FUNC 
     
     JMP MOVEBQ2    
     
     
     
     
     MOVEBQ3S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING UP
     PUSH CX
     PUSH DX 
     
     MOVEBQ3:
     CMP STOPLOOP,1
     JZ MOVEBQ4S
     
     SUB DX,20  
     JS  MOVEBQ4S
     
     CALL FUNC
     
     JMP MOVEBQ3
     
     
     
     MOVEBQ4S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DOWN
     PUSH CX
     PUSH DX  
     
     MOVEBQ4:
     CMP STOPLOOP,1
     JZ MOVEBQ5S 
     
     ADD DX,20  
     CMP DX,140
     JG MOVEBQ5S
     
     CALL FUNC
     
     JMP MOVEBQ4
     
     
     
     MOVEBQ5S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DOWN RIGHT
     PUSH CX
     PUSH DX  
     
     MOVEBQ5: 
     CMP STOPLOOP,1
     JZ MOVEBQ6S
     
     ADD DX,20
     CMP DX,140
     JG MOVEBQ6S
     
     ADD CX,20
     CMP CX,140
     JG MOVEBQ6S  
     
     
     CALL FUNC 
     
     JMP MOVEBQ5
     
     
     
     MOVEBQ6S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DOWN LEFT
     PUSH CX
     PUSH DX  
     
     MOVEBQ6: 
     CMP STOPLOOP,1
     JZ MOVEBQ7S
     
     SUB CX,20
     JS MOVEBQ7S
     
     ADD DX,20
     CMP DX,140
     JG  MOVEBQ7S
     
     CALL FUNC
     
     JMP MOVEBQ6
     
     
     MOVEBQ7S:
     POP DX
     POP CX  
     
     MOV STOPLOOP,0
     
     
     ;MOVING UP LEFT
     PUSH CX
     PUSH DX  
     
     MOVEBQ7: 
     CMP STOPLOOP,1
     JZ MOVEBQ8S
     
     SUB DX,20  
     JS MOVEBQ8S
     
     SUB CX,20 
     JS MOVEBQ8S
     
     CALL FUNC
     
     JMP MOVEBQ7
     
     
     MOVEBQ8S:
     POP DX
     POP CX     
     
     MOV STOPLOOP,0
     
     ;MOVING UP RIGHT
     PUSH CX
     PUSH DX  
     
     MOVEBQ8: 
     CMP STOPLOOP,1
     JZ MOVEBQ9S
     
     SUB DX,20
     JS MOVEBQ9S
     
     ADD CX,20
     CMP CX,140
     JG MOVEBQ9S
     
     CALL FUNC 
     
     JMP MOVEBQ8
     
     MOVEBQ9S:
     POP DX
     POP CX   
     
     RET
    
BQ500 ENDP

WQ500 PROC 

    ;;MOVING TO THE RIGHT
     PUSH CX
     PUSH DX
     MOV STOPLOOP,0
     
     MOVEWQ1:
     CMP STOPLOOP,1
     JZ MOVEWQ2S

     ADD CX,20
     CMP CX,140
     
     JG  MOVEWQ2S
     
     CALL FUNC
     
     JMP MOVEWQ1 
     
     
    
    
     MOVEWQ2S:
     POP DX
     POP CX
     MOV STOPLOOP,0
     
     ;MOVING TO THE LEFT
     PUSH CX
     PUSH DX
     
     MOVEWQ2:
     CMP STOPLOOP,1
     JZ MOVEWQ3S
     
     SUB CX,20
     JS MOVEWQ3S
     
     CALL FUNC 
     
     JMP MOVEWQ2    
     
     
     
     
     MOVEWQ3S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING UP
     PUSH CX
     PUSH DX 
     
     MOVEWQ3:
     CMP STOPLOOP,1
     JZ MOVEWQ4S
     
     SUB DX,20  
     JS  MOVEWQ4S
     
     CALL FUNC
     
     JMP MOVEWQ3
     
     
     
     MOVEWQ4S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DOWN
     PUSH CX
     PUSH DX  
     
     MOVEWQ4:
     CMP STOPLOOP,1
     JZ MOVEBW5S 
     
     ADD DX,20  
     CMP DX,140
     JG MOVEBW5S
     
     CALL FUNC
     
     JMP MOVEWQ4
     
     
     
     MOVEBW5S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DOWN RIGHT
     PUSH CX
     PUSH DX  
     
     MOVEWQ5: 
     CMP STOPLOOP,1
     JZ MOVEWQ6S
     
     ADD DX,20
     CMP DX,140
     JG MOVEWQ6S
     
     ADD CX,20
     CMP CX,140
     JG MOVEWQ6S  
     
     
     CALL FUNC 
     
     JMP MOVEWQ5
     
     
     
     MOVEWQ6S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DOWN LEFT
     PUSH CX
     PUSH DX  
     
     MOVEWQ6: 
     CMP STOPLOOP,1
     JZ MOVEWQ7S
     
     SUB CX,20
     JS MOVEWQ7S
     
     ADD DX,20
     CMP DX,140
     JG  MOVEWQ7S
     
     CALL FUNC
     
     JMP MOVEWQ6
     
     
     MOVEWQ7S:
     POP DX
     POP CX  
     
     MOV STOPLOOP,0
     
     
     ;MOVING UP LEFT
     PUSH CX
     PUSH DX  
     
     MOVEWQ7: 
     CMP STOPLOOP,1
     JZ MOVEWQ8S
     
     SUB DX,20  
     JS MOVEWQ8S
     
     SUB CX,20 
     JS MOVEWQ8S
     
     CALL FUNC
     
     JMP MOVEWQ7
     
     
     MOVEWQ8S:
     POP DX
     POP CX     
     
     MOV STOPLOOP,0
     
     ;MOVING UP RIGHT
     PUSH CX
     PUSH DX  
     
     MOVEWQ8: 
     CMP STOPLOOP,1
     JZ MOVEWQ9S
     
     SUB DX,20
     JS MOVEWQ9S
     
     ADD CX,20
     CMP CX,140
     JG MOVEWQ9S
     
     CALL FUNC 
     
     JMP MOVEWQ8
     
     MOVEWQ9S:
     POP DX
     POP CX   
     
     RET
    
WQ500 ENDP

BR500 PROC FAR

    ;MOVING UP 
     PUSH CX
     PUSH DX 
     
     MOV STOPLOOP,0
     
     ;MOVING UP
     BRMOVE1:  
     
     CMP STOPLOOP,1
     JZ BRMOVE2S
     
     SUB DX,20
     JS BRMOVE2S
     
     CALL FUNC
     
     JMP BRMOVE1 
     
     BRMOVE2S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
    ;MOVING DOWN
    PUSH CX
    PUSH DX
    
    BRMOVE2:
    
    CMP STOPLOOP,1
    JZ BRMOVE3S
    
    ADD DX,20
    CMP DX,140
    JG BRMOVE3S
    
    CALL FUNC
    
    JMP BRMOVE2
    
    
    BRMOVE3S:
    POP DX 
    POP CX 
    
    MOV STOPLOOP,0
    
    ;MOVING RIGHT
    PUSH CX
    PUSH DX
    
    BRMOVE3: 
    
    CMP STOPLOOP,1
    JZ BRMOVE4S
    
    ADD CX,20
    CMP CX,140
    JG BRMOVE4S
    
    CALL FUNC
    
    JMP BRMOVE3
    
    BRMOVE4S:
    POP DX 
    POP CX
    
    MOV STOPLOOP,0
    
    ;MOVING LEFT
    PUSH CX
    PUSH DX
    
    BRMOVE4:
    
    CMP STOPLOOP,1
    JZ BRMOVE5S
    
    SUB CX,20
    JS BRMOVE5S
    
    CALL FUNC
    
    JMP BRMOVE4 
    
    BRMOVE5S:
    POP DX 
    POP CX
    
    RET

BR500 ENDP

WR500 PROC FAR

    ;MOVING UP 
     PUSH CX
     PUSH DX 
     
     MOV STOPLOOP,0
     
     ;MOVING UP
     WRMOVE1:  
     
     CMP STOPLOOP,1
     JZ WRMOVE2S
     
     SUB DX,20
     JS WRMOVE2S
     
     CALL FUNC
     
     JMP WRMOVE1 
     
     WRMOVE2S:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
    ;MOVING DOWN
    PUSH CX
    PUSH DX
    
    WRMOVE2:
    
    CMP STOPLOOP,1
    JZ WRMOVE3S
    
    ADD DX,20
    CMP DX,140
    JG WRMOVE3S
    
    CALL FUNC
    
    JMP WRMOVE2
    
    
    WRMOVE3S:
    POP DX 
    POP CX 
    
    MOV STOPLOOP,0
    
    ;MOVING RIGHT
    PUSH CX
    PUSH DX
    
    WRMOVE3: 
    
    CMP STOPLOOP,1
    JZ WRMOVE4S
    
    ADD CX,20
    CMP CX,140
    JG WRMOVE4S
    
    CALL FUNC
    
    JMP WRMOVE3
    
    WRMOVE4S:
    POP DX 
    POP CX
    
    MOV STOPLOOP,0
    
    ;MOVING LEFT
    PUSH CX
    PUSH DX
    
    WRMOVE4:
    
    CMP STOPLOOP,1
    JZ WRMOVE5S
    
    SUB CX,20
    JS WRMOVE5S
    
    CALL FUNC
    
    JMP WRMOVE4 
    
    WRMOVE5S:
    POP DX 
    POP CX
    
    RET

WR500 ENDP 

BB500 PROC FAR

;MOVING DIAGONALLY UP AND RIGHT
     PUSH CX
     PUSH DX
     
     MOV STOPLOOP,0
     
     MOVEBB1:
     CMP STOPLOOP,1
     JZ BBLABEL1
     
     SUB DX,20
     JS BBLABEL1
     
     ADD CX,20
     CMP CX,140 
     JG BBLABEL1
     
     CALL FUNC 
     
     JMP MOVEBB1
     
     BBLABEL1:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DIAGONALLY DOWN AND RIGHT
     PUSH CX
     PUSH DX
     
     MOVEBB2:
     
     CMP STOPLOOP,1
     JZ BBLABEL2
     
     ADD DX,20    
     CMP DX,140
     JG BBLABEL2
     
     ADD CX,20
     CMP CX,140 
     JG BBLABEL2
     
     CALL FUNC 
     
     JMP MOVEBB2
     
     BBLABEL2:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DIAGONALLY UP AND LEFT
     PUSH CX
     PUSH DX
     
     MOVEBB3:
     
     CMP STOPLOOP,1
     JZ BBLABEL3
     
     SUB DX,20
     JS BBLABEL3
     SUB CX,20  
     JS BBLABEL3
     
     CALL FUNC 
     
     JMP MOVEBB3
     
     BBLABEL3:
     POP DX
     POP CX   
     
     MOV STOPLOOP,0
     
     
     ;MOVING DIAGONALLY LEFT AND DOWN
     PUSH CX
     PUSH DX
     
     MOVEBB4: 
     
     CMP STOPLOOP,1
     JZ BBLABEL4 
    
     ADD DX,20
     CMP DX,140
     JG BBLABEL4
     
     SUB CX,20
     JS BBLABEL4
     
     CALL FUNC 
     
     JMP MOVEBB4
     
     BBLABEL4:
     POP DX
     POP CX
      ;TODO JUMP TO SELECTING ONE OF THE AVAILABLE SQUARES
     
    RET
    
BB500 ENDP

WB500 PROC FAR

;MOVING DIAGONALLY UP AND RIGHT
     PUSH CX
     PUSH DX
     
     MOV STOPLOOP,0
     
     MOVEWB1:
     CMP STOPLOOP,1
     JZ WBLABEL1
     
     SUB DX,20
     JS WBLABEL1
     
     ADD CX,20
     CMP CX,140 
     JG WBLABEL1
     
     CALL FUNC 
     
     JMP MOVEWB1
     
     WBLABEL1:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DIAGONALLY DOWN AND RIGHT
     PUSH CX
     PUSH DX
     
     MOVEWB2:
     
     CMP STOPLOOP,1
     JZ WBLABEL2
     
     ADD DX,20    
     CMP DX,140
     JG WBLABEL2
     
     ADD CX,20
     CMP CX,140 
     JG WBLABEL2
     
     CALL FUNC 
     
     JMP MOVEWB2
     
     WBLABEL2:
     POP DX
     POP CX
     
     MOV STOPLOOP,0
     
     ;MOVING DIAGONALLY UP AND LEFT
     PUSH CX
     PUSH DX
     
     MOVEWB3:
     
     CMP STOPLOOP,1
     JZ WBLABEL3
     
     SUB DX,20
     JS WBLABEL3
     SUB CX,20  
     JS WBLABEL3
     
     CALL FUNC 
     
     JMP MOVEWB3
     
     WBLABEL3:
     POP DX
     POP CX   
     
     MOV STOPLOOP,0
     
     
     ;MOVING DIAGONALLY LEFT AND DOWN
     PUSH CX
     PUSH DX
     
     MOVEWB4: 
     
     CMP STOPLOOP,1
     JZ WBLABEL4 
    
     ADD DX,20
     CMP DX,140
     JG WBLABEL4
     
     SUB CX,20
     JS WBLABEL4
     
     CALL FUNC 
     
     JMP MOVEWB4
     
     WBLABEL4:
     POP DX
     POP CX
      ;TODO JUMP TO SELECTING ONE OF THE AVAILABLE SQUARES
     
    RET
    
WB500 ENDP 

Squares PROC 


    PUSH CX
    PUSH DX 
    PUSH SI

    LEA SI,GridArr 
    
    
    ;THE DIVISOR AND THE COORDS
    MOV BL,20
    
    
    
    ;PUSHING THE CX AND DX TO MAINTAIN THEIR VALUE 
    
    
  
    
    
    ;DIVIDING THE COLUMN PART AND INCREMENTING THE FINAL ANSWER
    MOV AX,CX
    DIV BL
    
    MOV DrawIndex,AL
    
    ;DIVIDING THE ROW PART
    MOV AX,DX
    DIV BL
    
    MOV CL,AL
    
    ;INSTEAD OF MULTIPLYING
    MOV AL,0
    ADDING780:
    ADD AL,8
    DEC CL
    JNZ ADDING780
    
    
    ;ADDING TO GET THE FINAL INDEX
    ADD DrawIndex,AL
  
    ;DOUBLING THE VALUE AS THE ARR IS WORD
    MOV AL,DrawIndex
    ADD AL,AL
    MOV DrawIndex,AL
    
    ;STORING THE FINAL ARRAY ELEMENT IN BX
    MOV BL,DrawIndex
    MOV BH,00 
    
    MOV BX,[SI+BX]
    
    POP SI
    POP DX
    POP CX
    
      
    
    SHL BX,12 
    SHR BX,12        


    
    CMP BX,1H
    JZ WPA
    
    CMP BX,7H
    JZ BPA
    
    CMP BX,2H
    JZ WR
    
    CMP BX,8H
    JZ BR
    
    CMP BX,3H
    JZ  WKN
    
    CMP BX,9H
    JZ BKN
    
    CMP BX,4H
    JZ WB
    
    CMP BX,0AH
    JZ BB
    
     CMP BX,5H
     JZ WK
    
    CMP BX,0BH
    JZ BK
    
    CMP BX,6H
    JZ WQ
    
    CMP BX,0CH
    JZ BQ
    
    RET
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
     WK:   CALL WK500
     RET
          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
     WQ:   CALL WQ500
    RET     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
        
    WB:   CALL WB500 
RET
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
    WKN:  CALL WKN500 
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
    WR:   CALL WR500
  RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
    WPA:  CALL WPA500
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
    BK:   CALL BK500
   RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
    BQ:   CALL BQ500
   RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
    BB:   CALL BB500
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
    BKN:  CALL BKN500
    RET 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
      
     
    BR:    CALL BR500
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
    BPA:   CALL BPA500
RET
    

SQUARES ENDP

DrawBoard PROC
    PUSHA
    MOV BX, 00H     ;BH carries index of square
    MOV AX,00H      ;BL carries index of array
    LEA SI, GridArr
    DrawB:
    PUSH BX
    AND BX, 00FFh
    MOV AX, [SI + BX]      
    POP BX     
    PUSH BX
    SHR BX, 8     
    MOV DI,BX   
    POP BX    
    ;SHR AX, 4               ;ISOLATE THE PIECE CODE
    AND AX, 0Fh

    CMP AX, 1h             
    JE WhiteP
    CMP AX,7h
    JE  BlackP
    CMP AX, 2h
    JE WhiteR
    CMP AX, 08h
    JE BlackR
    CMP AX, 3h
    JE WhiteKn
    CMP AX, 9h
    JE BlackKn1
    CMP AX, 4h
    JE WhiteB1
    CMP AX, 0Ah
    JE BlackB1
    CMP AX, 05h
    JE WhiteK1
    CMP AX, 0Bh
    JE BlackK1
    CMP AX, 06h
    JE WhiteQ1
    CMP AX, 0Ch
    JE BlackQ1
    CMP AX,00H
    JE None1
          
    WhiteP:
    CALL WPawnD
    INC BH                  
    MOV DrawIndex, BH
    ADD BL,2                
    CMP BL,127
    JNS BreakB1
    DrawB11: JMP DrawB

    BlackP:
    CALL BPawnD
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB1: JNS BreakB2
    DrawB10: JMP DrawB11

    WhiteR:
    CALL WRookD
    INC BH                  
    MOV DrawIndex, BH
    ADD BL,2                
    CMP BL,127
    BreakB2: JNS BreakB3
    DrawB9: JMP DrawB10
    BlackR:
    CALL BRookD 
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB3: JNS BreakB4
    DrawB8: JMP DrawB9

    WhiteB1: JMP WhiteB
    BlackB1: JMP BlackB

    BlackKn1: JMP BlackKn
    WhiteKn:
    CALL WKnightD
    INC BH                  
    MOV DrawIndex, BH
    ADD BL,2                
    CMP BL,127
    BreakB4: JMP BreakB5
    DrawB7: JMP DrawB8
    
    WhiteK1: JMP WhiteK
    BlackK1: JMP BlackK
    WhiteQ1: JMP WhiteQ
    BlackQ1: JMP BlackQ
    None1: JMP None

    BlackKn:
    CALL BKnightD
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB5: JNS BreakB6
    DrawB6: JMP DrawB7

    WhiteB:
    CALL WBishopD
    INC BH                  
    MOV DrawIndex, BH
    ADD BL,2                
    CMP BL,127
    BreakB6: JNS BreakB7
    DrawB5: JMP DrawB6
    BlackB:
    CALL BBishopD
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB7: JNS BreakB8
    DrawB4: JMP DrawB5

    WhiteK:
    CALL WKingD
    INC BH                  
    MOV DrawIndex, BH
    ADD BL,2                
    CMP BL,127
    BreakB8: JNS BreakB9
    DrawB3: JMP DrawB4
    BlackK:
    CALL BKingD
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB9: JNS BreakB10
    DrawB2: JMP DrawB3

    WhiteQ:
    CALL WQueenD
    INC BH                  
    MOV DrawIndex, BH
    ADD BL,2                
    CMP BL,127
    BreakB10: JNS BreakB11
    DrawB1: JMP DrawB2
    BlackQ:
    CALL BQueenD
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB11: JNS BreakB12
    DrawBN: JMP DrawB1

    None:
    INC BH
    ADD BL,2
    CMP BL,127
    BreakB12: JNS BreakB
    JMP DrawBN

    BreakB: 
    POPA
    RET
DrawBoard ENDP

CursorBlack PROC
    ;get start index for player2 and store the Row & Column in CX & DX
    ;getRC StartIndexB
    PUSH AX
    MOV AH,0
    MOV AL, SIxB
    CALL getRCB
    POP AX

    StartPB:
    MOV  BL,19
    MOV  AH,0CH
    MOV  AL,05H

    L1B:         ;DRAWING UPPER LINE
    INT  10H
    INC  CX
    DEC  BL
    JNZ  L1B
    MOV  BL,19

    L2B:         ;DRAWING LINE ON THE RIGHT 
    INC  DX
    DEC  BL
    INT  10H
    JNZ  L2B
    MOV  BL,19

    L3B:         ;DRAWING LOWER LINE
    DEC  CX
    DEC  BL
    INT  10H
    JNZ  L3B
    MOV  BL,19

    L4B:        ;DRAWING LINE ON THE LEFT
    DEC  DX
    DEC  BL
    INT  10H
    JNZ  L4B
RET
CursorBlack ENDP

CursorWhite PROC
    ;get start index for player2 and store the Row & Column in CX & DX
    PUSH AX
    MOV AH,0
    MOV AL, SIxW
    CALL getRCW
    POP AX

    StartP:
    MOV  BL,19
    MOV  AH,0CH
    MOV  AL,04H

    L1:         ;DRAWING UPPER LINE
    INT  10H
    INC  CX
    DEC  BL
    JNZ  L1
    MOV  BL,19

    L2:         ;DRAWING LINE ON THE RIGHT 
    INC  DX
    DEC  BL
    INT  10H
    JNZ  L2
    MOV  BL,19

    L3:         ;DRAWING LOWER LINE
    DEC  CX
    DEC  BL
    INT  10H
    JNZ  L3
    MOV  BL,19

    L4:        ;DRAWING LINE ON THE LEFT
    DEC  DX
    DEC  BL
    INT  10H
    JNZ  L4

RET
CursorWhite ENDP

DRAWANN PROC FAR

PUSH CX
PUSH DX

MOV CX,0
MOV DX,165

MOV AH,0CH
MOV AL,0FH



DRAW4201:

INT 10H

INC CX
CMP CX,320
JNZ DRAW4201

MOV CX,0
INC DX
CMP DX,167
JNZ DRAW4201

POP DX
POP CX

DRAWANN ENDP

UniversalMove PROC FAR
    ;PROGRAM WAITING FOR THE KEY TO BE PRESSED 
    CHECKB:
    MOV AH,1
    int 16h
    jz CHECKB

    MOV AH,0
    INT 16H 

    CMP AH,50H
    JZ DOWNB
    CMP AH,4DH
    JZ RIGHTB1
    CMP AH,48H
    JZ UPB
    CMP AH, 4BH
    JZ LEFTB2
    CMP AH, 12H
    JZ SELECTB2
    CMP AH,1FH
    JZ DOWN2
    CMP AH,20H
    JZ RIGHT2
    CMP AH,11H
    JZ UP2
    CMP AH,1EH
    JZ LEFT2
    CMP AH, 10H
    JZ SELECT3
    CMP AH, 01H
    JZ ENDPROGRAM
    JNZ CHECKB

    ENDPROGRAM:
    CALL Terminate
    ;black player movement
    ;-----------------------------------
    DOWNB: 
    CALL FillBorderB
    CMP SIxB, 55
    JG BOUNDDWNB
    PUSH AX
    MOV AH, 0
    MOV AL, SIxB
    ADD AL, 8
    MOV SIxB, AL
    POP AX
    ;CALL CorrectSIxB
    CALL CursorWhite
    BOUNDDWNB: CALL CursorBlack
    RET

    RIGHT2: JMP FAR PTR RIGHT
    DOWN2: JMP FAR PTR DOWN
    LEFTB2: JMP FAR PTR LEFTB
    UP2: JMP FAR PTR UP
    LEFT2: JMP FAR PTR LEFT
    SELECT3: JMP FAR PTR SELECT
    SELECTB2: JMP FAR PTR SELECTB
    RIGHTB1: JMP FAR PTR RIGHTB

    UPB: 
    CALL FillBorderB
    CMP SIxB, 8
    JS BOUNDUPB
    PUSH AX
    MOV AH, 0
    MOV AL, SIxB
    SUB AL, 8                     
    MOV SIxB, AL
    POP AX
    ;CALL CorrectSIxB
    CALL CursorWhite
    BOUNDUPB: CALL CursorBlack
    RET

    LEFTB1: JMP FAR PTR LEFTB
    SELECTB1: JMP FAR PTR SELECTB

    RIGHTB: 
    CALL FillBorderB
    PUSH AX
    MOV AH, 0
    MOV AL, SIxB
    INC AL
    MOV SIxB, AL
    POP AX
    CALL CursorWhite
    CALL CursorBlack
    RET

    LEFTB:
    CALL FillBorderB
    PUSH AX
    MOV AH, 0
    MOV AL, SIxB
    DEC AL
    MOV SIxB, AL
    POP AX 
    CALL CursorWhite 
    CALL CursorBlack
    RET

    SELECTB:   
    PUSH CX
    MOV CX, BSelectedNo
    CMP CX, 0                       ;if first click
    JE STOSRCB   
    CMP CX, 1                       ;if second click
    JE STODSTB       
    STOSRCB: 
    POP CX
    CALL getsourceB          ;store source
    CALL Squares
    RET

    STODSTB: 
    POP CX
    
    
    ;READING THE PIXEL COLOR
    PUSH CX
    PUSH DX
    
    ADD CX,5
    ADD DX,5


    MOV AH,0DH
    MOV BH,0
 
    
    INT 10H

    POP DX
    POP CX

    CMP AL,7H
    JNE NoMoveB

    CALL getdestB            ;store destination
    CMP ValidMoveB, 1
    JE NoMoveB
    CALL MOVEB
    CALL DrawGrid
    CALL DrawBoard
    CALL CursorBlack
    CALL CursorWhite

    RET
    NoMoveB:
    CALL getdestB
    CALL DrawGrid
    CALL DrawBoard
    CALL CursorBlack
    CALL CursorWhite
    RET
    ;--------------------------------------------------------
    ;white player movement
    ;-----------------------------------------------------------
    DOWN: 
    CALL FillBorderW
    CMP SIxW, 55
    JG BOUNDDWNW
    PUSH AX
    MOV AH, 0
    MOV AL, SIxW
    ADD AL, 8
    MOV SIxW, AL
    POP AX
    CALL CursorBlack
    BOUNDDWNW: CALL CursorWhite
    RET

    UP: 
    CALL FillBorderW
    CMP SIxW, 8
    JS BOUNDUPW
    PUSH AX
    MOV AH, 0
    MOV AL, SIxW
    SUB AL, 8
    MOV SIxW, AL
    POP AX
    CALL CursorBlack
    BOUNDUPW: CALL CursorWhite
    RET

    SELECT1: JMP SELECT

    RIGHT: 
    CALL FillBorderW
    PUSH AX
    MOV AH, 0
    MOV AL, SIxW
    INC AL
    MOV SIxW, AL
    POP AX
    CALL CursorBlack
    CALL CursorWhite
    RET

    LEFT:
    CALL FillBorderW 
    PUSH AX
    MOV AH, 0
    MOV AL, SIxW
    DEC AL
    MOV SIxW, AL
    POP AX
    CALL CursorBlack
    CALL CursorWhite
    RET

    SELECT:   
    PUSH CX
    MOV CX, WSelectedNo
    CMP CX, 0                       ;if first click
    JE STOSRC   
    CMP CX, 1                       ;if second click
    JE STODST       
    STOSRC: 
    POP CX
    CALL getsource          ;store source
    CALL Squares
    RET

    STODST: 
    POP CX

    PUSH CX
    PUSH DX
    
    ADD CX,5
    ADD DX,5


    MOV AH,0DH
    MOV BH,0
 
    
    INT 10H

    POP DX
    POP CX

    CMP AL,7H
    JNE NoMove

    CALL getdest          ;store destination
    CMP ValidMoveW, 1
    JE NoMove
    CALL MOVEW
    CALL DrawGrid
    CALL DrawBoard
    CALL CursorBlack
    CALL CursorWhite
    RET
    NoMove:
    CALL getdest
    CALL DrawGrid
    CALL DrawBoard
    CALL CursorBlack
    CALL CursorWhite
    RET
    ;----------------------------------------
UniversalMove ENDP

TimeElapsed PROC
    DisplayTime:
    MOV   AH,2CH                   
    INT   21H                  ;get system time

    CMP   DH,seconds
    JE    DisplayTime          ;loop untill one second passes

    MOV   seconds,DH

    MOV   AX,0
    MOV   AL,DH
    LEA   SI,numbuf

    PUSH  SI
    MOV   CX,6
    
    fill: 
    MOV   BL,'$'            ;fill variable with $
    MOV   [SI],BL
    INC   SI
    LOOP  fill
    POP   SI
    
    MOV   BX,10
    MOV   CX,0
    
    cycle1:     
    MOV   DX,0
    DIV   BX
    PUSH  DX
    INC   CX
    CMP   AX,0     ;if number is not zero loop
    JNE   cycle1
    
    cycle2:     
    POP   DX
    ADD   DL,48                    ;convert it into character
    MOV   [SI],DL
    INC   SI
    LOOP  cycle2

    MOV   DL,13
    MOV   DH,22
    MOV   AH,2
    MOV   BH,0
    INT   10H

    MOV   AH,9
    LEA   DX,numbuf
    INT   21H
    JMP   DisplayTime

RET
TimeElapsed ENDP

startchat proc
progloop:
mov ah,1    
int 16h
jnz send      
jmp jmpreceive   


send:
mov ah,0        ;clear keyboard buffer
int 16h

mov message,al  
mov scancode,ah 

CMP al, 08h    ;check backpace pressed
jnz checkEnterS
cmp xposS, 79  ;check end line
jne notendline
mov ah,2  
mov dl,' '
int 21h
notendline:
cmp xposS, 0   ;check line beginning
JE goback    
dec xposS
setCursor xposS,yposS
mov ah,2  
mov dl,' '
int 21h
inc xposS
setCursor xposS,yposS

goback: 
cmp xposS, 0 
jne checkEnterS
cmp yposS, 1
je checkEnterS
dec yposS
setCursor 80,yposS
saveCursorS

checkEnterS: CMP al,0Dh    ;check enter key pressed
jnz ContinueS
jz newlineS

jmpreceive: jmp Receive


newlineS:
CMP yposS,10   ;check upper screen ended
jnz notlastlineS
scrollsenderscreen
setCursor 0,10
jmp printS
 
notlastlineS:inc yposS     
mov xposS,0

ContinueS:
setCursor xposS,yposS  
CMP xposS,79          
JZ CheckBottomS           
jnz printS

CheckBottomS:
CMP yposS,10  
JNZ printS
scrollsenderscreen
setCursor 0,10 


printS:
mov ah,2          
mov dl,message
int 21h
  
mov dx,3FDH 		;Line Status Register
AGAIN:
In al , dx 	         ;Read Line Status
test al , 00100000b
jz Receive          ;Not empty

mov dx , 3F8H		;Transmit data register
mov al,message        
out dx , al         

mov ah,scancode
CMP ah,3Dh           ;check F3 key pressed
JZ jumpExit
saveCursorS          
jmp progloop        

jumpSend:jmp send
jumpExit:jmp exitn

receive:
mov ah,1          
int 16h
jnz jumpSend

mov dx , 3FDH		;Line Status Register
in al , dx 
test al , 1
JZ receive

mov dx , 03F8H
in al , dx 
mov message,al

CMP al, 08h   ;check backpace pressed
jnz checkEnterR
cmp xposR, 79  ;check end line
jne notendline2
mov ah,2  
mov dl,' '
int 21h
notendline2:cmp xposR, 0
JE goback2    ;check line beginning
dec xposR
setCursor xposR,yposR
mov ah,2  
mov dl,' '
int 21h
inc xposR
setCursor xposR,yposR

goback2:
cmp xposR,0  
jne checkEnterR
cmp yposR, 13   
je checkEnterR
dec yposR
setCursor 80,yposR
saveCursorR

checkEnterR:
CMP message,3dh           ;check if the Received data is Esc key to end chatting mode
JZ  jumpExitt


CMP message,0Dh           ;check enter key pressed
JNZ ContinueR

newlineR:
cmp yposR,22           ;check lower screen ended
jnz notlastlineR
scrollreceiverscreen
setCursor 0,22     
jmp printR

notlastlineR: inc yposR
mov xposR,0

ContinueR:
setCursor xposR,yposR   
CMP xposR,79             
JZ CheckBottomR                  
jnz printR

jumpExitt: jmp EXITn

CheckBottomR:
cmp yposR,22     ;check lower screen ended
jnz printR
scrollreceiverscreen
setCursor 0,22

printR:
mov ah,2         
mov dl,message
int 21h

saveCursorR

jmp progloop        

Exitn: call MainMenu
startchat endp

Execute PROC
    CALL  Username                 ;display define username screen
    CALL  MainMenu                 ;display main menu
    CHECKKEY:   MOV   AH,1
    INT   16H
    JZ    CHECKKEY

    MOV   AH,0
    INT   16H

    CMP   AH,59                    ;check if F1 key is pressef
    JZ    CHT

    CMP   AH,3CH                   ;check if F2 key is pressed
    JZ    loadg                 ; if yes -> start the game

    CMP   AH,01H                   ;check if ESC key is pressed
    JNZ   CHECKKEY

    MOV   AH,0
    MOV   AL,3
    INT   10H                      ;clear the screen

    MOV   AX, 4C00H
    INT   21H                      ;terminate the program

loadg: jmp loadgame
    CHT:        
; Set Divisor Latch Access Bit
mov dx,3fbh 			 
mov al,10000000b
out dx,al            

;Set LSB byte of the Baud Rate Divisor Latch register.
mov dx,3f8h			
mov al,0ch			
out dx,al

;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
out dx,al

;Set port configuration
mov dx,3fbh
mov al,00011011b
out dx,al     

;Text Mode
mov ah, 0      
mov al, 3
int 10h

;Display first username
mov ah, 9
mov dx, offset user1
int 21h 

;Split the screen
setCursor 0,11      
mov ah, 9
mov dx, offset LINE
int 21h

;Display second username
setCursor 0,12
mov ah, 9
mov dx, offset user2
int 21h

;Display notification bar
setCursor 0,23
mov ah, 9
mov dx, offset LINE
int 21h   
setCursor 0,24
mov ah, 9
mov dx, offset leavemsg
int 21h

setCursor 0,1 

call startchat
loadgame:   Load2

MOV   AH, 0
MOV   AL, 13h
INT   10h                      ;change to graphics mode
;-----------------------
CALL  DrawGrid
CALL  DrawBoard
CALL DRAWANN
;Draw initial borders
;Draw borders for player 2
;----------------------------------
CALL CursorBlack
;-------------------------------------------
;Draw borders for player 1
;-------------------------------------------
CALL CursorWhite
;----------------------------------------------------   
GAME1:
CALL UniversalMove
JMP GAME1

RET
Execute ENDP

MAIN PROC FAR
    MOV AX , @DATA
    MOV DS , AX
    CALL Execute
MAIN ENDP
END MAIN
;------------------------------------
;TODO: proc draw light and draw dark DONE
;TODO: drawsquare DONE & draw piece DONE
;TODO: drawboard = DONE
;TODO: Move = DONE
;TODO: Add logic to proc MOVE:    1)Can't pick up opposite color pieces DONE
                                ; 2)Can't take your own pieces          DONE
                                ; 3)Can't select an empty square        DONE
;TODO: Add second player cursor         DONE
;TODO: Add timer on pieces  DONE
;TODO: Add status bar
;TODO: Chat Module          DONE
;TODO: In-game Chatting     In Progress
