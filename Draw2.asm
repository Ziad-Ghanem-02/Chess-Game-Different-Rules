Draw2 MACRO data, index
PUSHA
LEA BX, data

PUSH BX
PUSH AX
    MOV AX, index    ;AL=row   AH=Col
    MOV BX,8       ;Ax = row
    DIV BL         ;DX=col   
    
    notlast: 
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
ENDM Draw2