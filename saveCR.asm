saveCursorR MACRO
mov ah,3h
mov bh,0h
int 10h
mov xposR,dl
mov yposR,dh
ENDM saveCursorR 