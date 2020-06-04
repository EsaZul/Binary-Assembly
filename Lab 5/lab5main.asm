
	.ORIG	x3000

	LD	R6, STACK	;Initializing Stack PTR

	LD	R0, VECTOR	;Loads Keyboard Interrupt Vector Address
	LD	R1, ISR		;Loads the address of ISR
	STR	R1, R0, #0	;Stores the address of ISR into Keyboard Vector
	
	
	LD	R0, KBSR	;Enables KBSR Interrupt
	LD	R1, ENABLE
	STR	R1, R0, #0	
	STI	R1, KBDR		

NEW	LD	R1, CTR		;Initializes Counter


REPEAT	LD	R0, STAR	;Prints a Star
	STI	R0, DDR

	JSR	EYE

	LD	R0, SPACE	;Prints a Space
	STI	R0, DDR

	JSR	EYE
	
	LD	R0, SPACE	;Prints another Space
	STI	R0, DDR

	JSR	EYE
	
	ADD	R1, R1, #-1	;Updates Counter
	BRNP	REPEAT

	LD	R0, NEWLINE	;Prints a new line
	STI	R0, DDR

	BR	NEW




EYE	ST	R0, SAVE_R0
	ST	R7, SAVE_R7
	LD	R2, TIME
CHK	ADD	R2, R2, #-1
	BRNP	CHK
	LD	R0, SAVE_R0
	LD	R7, SAVE_R7
	RET


SAVE_R0	.BLKW	#1
SAVE_R7	.BLKW	#1

STACK	.FILL	x3000
VECTOR	.FILL	x0180
ISR	.FILL	x1500
CTR	.FILL	x0014	;#20
ENABLE	.FILL	x4000

NEWLINE	.FILL	x000A
STAR	.FILL	x002A
SPACE	.FILL	x0020

KBSR	.FILL	xFE00
KBDR	.FILL	xFE02
DSR	.FILL	xFE04
DDR	.FILL	xFE06

TIME	.FILL	x0DAC	;#3,500
	.END
