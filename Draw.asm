Draw MACRO data, row, col
PUSHA
LEA BX, data
MOV CX, col		      ;start column
MOV DX, row           ;start row  
CALL drawpiece
POPA
ENDM Draw