setCursor MACRO x,y
mov ah,2
mov bh,0
mov dl,x
mov dh,y
int 10h
ENDM setCursor