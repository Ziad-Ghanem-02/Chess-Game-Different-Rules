scrollsenderscreen MACRO
mov ah, 6               
mov al, 1              
mov bh, 7              
mov ch, 1              
mov cl, 0              
mov dh, 10             
mov dl, 79             
int 10h   
ENDM scrollsenderscreen