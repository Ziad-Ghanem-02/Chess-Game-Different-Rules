FLUSH MACRO 
    PUSH AX
    MOV AX, 0C00H
    INT 21h
    POP AX
ENDM FLUSH