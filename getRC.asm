getRC MACRO index

    PUSH BX
    PUSH AX

    MOV AL, index    ;AL=row   AH=Col
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

ENDM getRC