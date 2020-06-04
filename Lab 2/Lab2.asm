	.ORIG	X3000

;*****************************************
;		Lab 2
;*****************************************
;	Eduardo Saul Ruiz
;	March 9, 2018
;*****************************************

;Clears all Registers

	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0

;Initializing Pointers

CODA	LD R0, PTR	;Base is x4005	

LOOP	LDR R1, R0, #0	;R1 contains 1st student's ASCII only
	BRZ CTR		;If ASCII is x0000, then its no longer the array
	
	LDR R2, R0, #2	;R2 contains 2nd student's ASCII only
	BRZ CTR		;If ASCII is x0000, then its no longer the array

	LDR R3, R0, #1	;R3 contains ASCII and Grade of 1st Student
	LDR R4, R0, #3	;R4 contains ASCII and Grade of 2nd Student

;Isolates Scores

	LD R7, MASK	;Loads x00ff(0000000011111111) into R7
	AND R3, R3, R7	;R3 now contains only 1st student's score
	AND R4, R4, R7	;R4 now contains only 2nd student's score

;************Bubble Sort Program*************

;Switching comparison number into negative 2's compliments

	NOT R4, R4	;Turns 2nd score into 1's compliment
	ADD R4, R4, #1	;Converts 1's compliment to 2's by adding #1

;Comparison

	ADD R5, R5, 1 ;R5 is a comparison counter

	ADD R4, R3, R4	;Adds 1st score with the (-)2nd score and stores into R5

	BRP SWAP

	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing
	BR LOOP



;Different Scenarios
			
SWAP	STR R2, R0, #0	;Stores ASCII of Student 2 where Student 1 was
	STR R1, R0, #2	;Stores ASCII of Student 1 where Student 2 was


	LDR R3, R0, #1	;R3 contains ASCII and Grade of 1st Student
	LDR R4, R0, #3	;R4 contains ASCII and Grade of 2nd Student
	
	
	STR R4, R0, #1	;Stores Score of Student 2 where Student 1 was
	STR R3, R0, #3	;Stores Score of Student 1 where Student 2 was

	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing	
	
	BR LOOP

CTR	ADD R6, R6, -1	;Decrements ever full run, number of runs=number of comparisons
	BRn SETR6	;should only branch on first run

CONT	BRZ HIS
	BR CODA	

SETR6	AND R6, R6, 0	;clear R6; don't really need this
	NOT R6, R6	;Or R5 and R6
	NOT R5, R5	;
	AND R6, R5, R6	;
	NOT R6, R6	;
	BR CONT



;****************HISTOGRAM*************

HIS	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0


;Loads Pointer

	LD R0, PTR	;Loads x4005 as the base

RPT	LDR R1, R0, #0

	BRZ END		;If ASCII is x0000, then its no longer the array

	LDR R1, R0, #1	;Loads the ASCII and Score




;0-19 Range Check

	LD R7, MASK	;Loads x00ff(0000000011111111) into R7
	AND R1, R1, R7	;R1 now contains only 1st student's score
	LD R7, FAIL
	ADD R1, R1, R7
	BRNZ F

;20-39 Range Check
	
	LDR R1, R0, #1	;Loads the ASCII and Score
	LD R7, MASK	;Loads x00ff(0000000011111111) into R7
	AND R1, R1, R7	;R1 now contains only 1st student's score
	LD R7, DUMB	;Loads the -19
	ADD R1, R1, R7	;Adds -19 to R1
	BRNZ D		;If negative or zero, its within the range

;40-59 Range Check

	LDR R1, R0, #1	;Loads the ASCII and Score
	LD R7, MASK	;Loads x00ff(0000000011111111) into R7
	AND R1, R1, R7	;R1 now contains only 1st student's score
	LD R7, COOL
	ADD R1, R1, R7
	BRNZ C

;60-79 Range Check

	LDR R1, R0, #1	;Loads the ASCII and Score
	LD R7, MASK	;Loads x00ff(0000000011111111) into R7
	AND R1, R1, R7	;R1 now contains only 1st student's score
	LD R7, BAE
	ADD R1, R1, R7
	BRNZ B

;80-100 Range Check

	LDR R1, R0, #1	;Loads the ASCII and Score
	LD R7, MASK	;Loads x00ff(0000000011111111) into R7
	AND R1, R1, R7	;R1 now contains only 1st student's score
	LD R7, AHH
	ADD R1, R1, R7
	BR A


F	ADD R2, R2, #1	;Increments F Counter by 1
	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing
	BR RPT

D	ADD R3, R3, #1	;Increments D Counter by 1
	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing
	BR RPT

C	ADD R4, R4, #1	;Increments C Counter by 1
	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing
	BR RPT

B	ADD R5, R5, #1	;Increments B Counter by 1
	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing
	BR RPT

A	ADD R6, R6, #1	;Increments A Counter by 1
	ADD R0, R0, #2	;Increments Pointer by 2 to continuing compararing
	BR RPT


END	LD R0, FNL

	LD R7, ASCF
	ADD R2, R2, R7
	STR R2, R0, #0 

	LD R7, ASCD
	ADD R3, R3, R7
	STR R3, R0, #1	

	LD R7, ASCC
	ADD R4, R4, R7
	STR R4, R0, #2

	LD R7, ASCB
	ADD R5, R5, R7
	STR R5, R0, #3

	LD R7, ASCA
	ADD R6, R6, R7
	STR R6, R0, #4

	HALT


PTR	.FILL x4005	;For base

FNL	.FILL x4000

MASK	.FILL x00FF	;For isolating scores

FAIL	.FILL XFFED	;F 0-19

DUMB	.FILL XFFD9	;D 20-39

COOL	.FILL xFFC5	;C 40-59

BAE	.FILL xFFB1	;B 60-79

AHH	.FILL xFF9C	;A 80-100

ASCF	.FILL x4600	;ASCII Character for F

ASCD	.FILL x4400	;ASCII Character for D

ASCC	.FILL x4300	;ASCII Character for C

ASCB	.FILL x4200	;ASCII Character for B

ASCA	.FILL x4100	;ASCII Character for A
	



	.END