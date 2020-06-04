
	.ORIG	x1500

	ST	R0, R0SAVE	;Saves registers
	ST	R1, R1SAVE
	ST	R2, R2SAVE
	ST	R3, R3SAVE
	ST	R4, R4SAVE
	ST	R5, R5SAVE
	ST	R7, R7SAVE


	LDI	R0, KBDR	;Loads character that was typed

	LD	R1, OPPe	;Checks if keyboard inputted e
	ADD	R2, R0, R1
	BRZ	eee
	
MAYBE	LD	R1, OPPc	;Checks if keyboard inputted c
	ADD	R2, R0, R1
	BRZ	ccc

	LD	R0, ASCIIE	;Displays ECE if other character was typed
	STI	R0, DDR
	LD	R0, ASCIIC
	STI	R0, DDR
	LD	R0, ASCIIE
	STI	R0, DDR

DONE	LD	R0, R0SAVE
	LD	R1, R1SAVE
	LD	R2, R2SAVE
	LD	R3, R3SAVE
	LD	R4, R4SAVE
	LD	R5, R5SAVE
	LD	R7, R7SAVE

	RTI


eee	LD	R2, TEN		;Displays e 10 times
COPY	STI	R0, DDR
	ADD	R2, R2, #-1
	BRNP	COPY
	BR	DONE

ccc	LD	R2, TEN		;Displays c 10 times
AGAIN	STI	R0, DDR
	ADD	R2, R2, #-1
	BRNP	AGAIN
	BR	DONE

R0SAVE	.BLKW	#1
R1SAVE	.BLKW	#1
R2SAVE	.BLKW	#1
R3SAVE	.BLKW	#1
R4SAVE	.BLKW	#1
R5SAVE	.BLKW	#1
R7SAVE	.BLKW	#1
OPPe	.FILL	xFF9B
OPPc	.FILL	xFF9D
TEN	.FILL	x000A

KBSR	.FILL	xFE00
KBDR	.FILL	xFE02
DSR	.FILL	xFE04
DDR	.FILL	xFE06

ASCIIE	.FILL	x0045
ASCIIC	.FILL	x0043


	.END