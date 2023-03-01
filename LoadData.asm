LoadData MACRO
Load BKnightFilename, BKnightFilehandle, BKnightData
Load WBishopFilename, WBishopFilehandle, WBishopData
Load BBishopFilename, BBishopFilehandle, BBishopData
Load BKingFilename, BKingFilehandle, BKingData
Load WQueenFilename, WQueenFilehandle, WQueenData
Load BQueenFilename, BQueenFilehandle, BQueenData
Load WKnightFilename, WKnightFilehandle, WKnightData
Load WKingFilename, WKingFilehandle, WKingData
Load WRookFilename, WRookFilehandle, WRookData
Load BRookFilename, BRookFilehandle, BRookData
Load BPawnFilename, BPawnFilehandle, BPawnData
Load WPawnFilename, WPawnFilehandle, WPawnData

LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B1PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B2PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B3PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B4PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B5PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B6PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B7PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B8PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W1PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W2PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W3PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W4PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W5PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W6PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W7PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WPawnData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W8PawnData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WBishopData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W1BishopData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WBishopData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W2BishopData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BBishopData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B1BishopData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BBishopData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B2BishopData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BKnightData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B1KnightData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BKnightData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B2KnightData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WKnightData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W1KnightData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WKnightData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W2KnightData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BRookData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B1RookData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, BRookData      ;SI = POINTER TO FREQUENCY.
LEA  DI, B2RookData          ;DI = POINTER TO ARRAY.
CALL Loadin  
LEA  SI, WRookData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W1RookData          ;DI = POINTER TO ARRAY.
CALL Loadin
LEA  SI, WRookData      ;SI = POINTER TO FREQUENCY.
LEA  DI, W2RookData          ;DI = POINTER TO ARRAY.
CALL Loadin
ENDM LoadData