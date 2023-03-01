saveCursorS MACRO
mov ah,3h
mov bh,0h
int 10h
mov xposS,dl
mov yposS,dh
ENDM saveCursorS  