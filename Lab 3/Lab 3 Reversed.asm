
	.ORIG	x3000

;Clears All the Registers

START	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0

;*******************************************************************************************************************
;
;	Eduardo Saul Ruiz
;	Lab 3
;	4/6/17
;	I DID IT ANIKET!!!!!!!!!!!!!!!!
;
;*******************************************************************************************************************

	TRAP	x20		;Gets character and inputs it in R0
	TRAP	x21		;Outputs the character typed in
	ADD	R1, R0, #0	;Saves first character into R1	

	TRAP	x20		;Gets character and inputs it in R0
	TRAP	x21		;Outputs the character typed in
	ADD	R2, R0, #0	;Saves second character into R2

	TRAP	x20		;Gets character and inputs it in R0
	TRAP	x21		;Outputs the character typed in
	ADD	R3, R0, #0	;Saves third character into R3

	TRAP	x20		;Gets character and inputs it in R0
	TRAP	x21		;Outputs the character typed in
	ADD	R4, R0, #0	;Saves fourth character into R4

	TRAP	x20		;Gets character and inputs it in R0
	TRAP	x21		;Outputs the character typed in
	ADD	R5, R0, #0	;Saves fifth character into R5
	
	LD	R0, ASCII0	;Loads the opposite of the ASCII 0

	ADD	R6, R1, R0	;The five ADD and BR opcodes check if 00000 was inputed in a row by the user
	BRNP	CONT

	ADD	R6, R2, R0
	BRNP	CONT	

	ADD	R6, R3, R0
	BRNP	CONT

	ADD	R6, R4, R0
	BRNP	CONT
	
	ADD	R6, R5, R0
	BRNP	CONT

	BR	END

CONT	ST	R1, IDSAVE	;Stores each character in a seperate memory space. Frees up Registers
	LEA	R1, IDSAVE
	STR	R2, R1, #1
	STR	R3, R1, #2
	STR	R4, R1, #3
	STR	R5, R1, #4

;*******************************************************************************************************************
;306 Directory Check
;*******************************************************************************************************************
	
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0


	LD	R0, PTR		;Loads x3800 into R0
	LDR	R0, R0, #0	;Loads Memory inside x3800 into R0
	BRZ	NOMORE		;Checks if 306 has a list, if null, then it proceeds to UT list

;********************************************************************************************************************
;Checks the LIST
;********************************************************************************************************************
CHK	LDR	R4, R0, #0	;Loads the next PTR	
	ADD	R7, R7, #5	;Counter has #5
	LEA	R1, IDSAVE	;Loads address of the block, NOT THE MEMORY INSIDE BLOCK

MAYBE	LDR	R2, R0, #2	;Loads character that is in the UTDirectory
	LDR	R3, R1, #0	;Loads character that is in the Block
	
	
	NOT	R3, R3		;Opposite of character that user input
	ADD	R3, R3, #1
	ADD	R3, R3, R2	;Compares Input character with 306 ID

	BRNP	SKIP

	ADD	R1, R1, #1	;Selects next character in the block
	ADD	R7, R7, #-1	;Decrements Match Counter by 1
	BRZ	SAME
	ADD	R0, R0, #1	;Increments PTR by 1, selects next character
	BR	MAYBE	

SKIP	AND	R7, R7, #0
	ADD	R4, R4, #0
	BRZ	NOMORE
	ADD	R0, R4, #0
	BR	CHK

	


;*********************************************************************************************************************
;UT Directory Check
;*********************************************************************************************************************


	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0

NOMORE	LD	R0, PTR		;Loads x3800 into R0
	LDR	R0, R0, #1	;Loads the memory inside x3801.
	BRZ	NOMORE2		;Checks if UT has a list, if null, then theres no list

;**********************************************************************************************************************
;Checks the LIST
;**********************************************************************************************************************

BEG	ST	R0, STRR0	;Stores PTR
	LDR	R5, R0, #0	;Loads the Previous PTR in the current list
	LDR	R4, R0, #1	;Loads the next PTR in the current list
	ADD	R7, R7, #5	;Counter has #5
	LEA	R1, IDSAVE	;Loads address of the block,NOT THE MEMORY INSIDE BLOCK

AGAIN	LDR	R2, R0, #2	;Loads character that is in the UTDirectory
	LDR	R3, R1, #0	;Loads character that is in the Block
	
	
	NOT	R3, R3		;Opposite of character that user input
	ADD	R3, R3, #1
	ADD	R3, R3, R2	;Compares Input character with UTDirectory ID

	BRNP	NEXT

	ADD	R1, R1, #1	;Selects next character in the block
	ADD	R7, R7, #-1	;Decrements Match Counter by 1
	BRZ	MATCH
	ADD	R0, R0, #1	;Increments PTR by 1, selects next character
	BR	AGAIN		

NEXT	LD	R0, STRR0	;Reloads original PTR
	AND	R7, R7, #0	;Clears the R7 counter
	ADD	R4, R4, #0	;Recalls the Next Node
	BRZ	NOMORE2		;Checks if its the end of the list
	ADD	R0, R4, #0	;Makes the Next Node the Current Node
	BR	BEG

;***********************************************************************************************************************
;SAME, MATCH, NO MATCH SCENARIOS
;***********************************************************************************************************************

SAME	LD	R0, ENDLINE	;New Line loaded
	PUTC			;New Line Executed
	LEA	R0, THERE	;Calls the Prompt
	TRAP	x22		;PUTS
	LD	R0, ENDLINE
	PUTC	
	BR	START
;************************************************************************************************************************
MATCH	ADD	R0, R0, #-4	;Deletes the effects of the counter, has original PTR of the matched list
	LD	R1, PTR		;Loads x3800
	LD	R7, NULL	;Loads x0000

	LDR	R2, R1, #0	;Loads the PTR in address x3800
	STR	R2, R0, #0	;Stores the PTR found in 3800 into the 1st memory of new list(WILL CONTAIN A NULL or POINTER AUTO)
	ADD	R2, R2, #0	;Recalls R2
	BRZ	NOLIST
	STR	R0, R2, #1	;Stores previous last PTR in the second adrress of the one before it
NOLIST	STR	R0, R1, #0	;Puts PTR of the List at x3800 aka 306 PTR
	STR	R7, R0, #1	;Puts Null in the Second Space of the Moved list
	ADD	R5, R5, #0	;Recalls R5
	BRZ	NOOO
	STR	R4, R5, #1	;Arranges the PTR
NOLIST2	ADD	R4, R4, #0	;Recalls R4
	BRZ	DUMB		
	STR	R5, R4, #0	;Sets up new PREV PTR	
DUMB	LD	R0, ENDLINE	;New Line loaded
	PUTC			;New Line Executed
	LEA	R0, DONE	;Calls the Prompt
	TRAP	x22		;PUTS
	LD	R0, ENDLINE
	PUTC	
	BR	START
;**************************************************************************************************************************
NOMORE2	LD	R0, ENDLINE	;New Line loaded
	PUTC			;New Line Executed
	LEA	R0, NADA	;Calls the Prompt
	TRAP	x22		;PUTS
	LD	R0, ENDLINE
	PUTC	
	BR	START		

NOOO	STR	R4, R1, #1	;Updates the beginning of the list
	BR	NOLIST2 


IDSAVE	.BLKW	5

END	HALT

NADA	.STRINGZ "Cannot Find Student"
DONE	.STRINGZ "Successfully enrolled student in 306"
THERE	.STRINGZ "Student is already enrolled in 306"
ASCII0	.FILL	xFFD0
PTR	.FILL	x3800
ENDLINE	.FILL	x000A
NULL	.FILL	x0000
STRR0	.FILL	x0000
	.END