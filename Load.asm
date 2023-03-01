Load MACRO filename, filehandle, data
LEA BX,filename
LEA SI, filehandle
CALL OpenFile

MOV DX, [filehandle]
LEA SI, data
CALL ReadData

;close file
LEA DX,filehandle
CALL CloseFile
ENDM Load