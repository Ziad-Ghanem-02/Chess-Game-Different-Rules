scrollreceiverscreen MACRO
mov ah, 6               
mov al, 1               
mov bh, 7               
mov ch, 13              
mov cl, 0               
mov dh, 22              
mov dl, 79              
int 10h 
ENDM scrollreceiverscreen