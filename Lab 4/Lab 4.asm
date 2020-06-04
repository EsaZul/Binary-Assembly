
	.ORIG	x3000

;--------------------------- PACMAN ---------------------------;
; Directions: Use the wasd keys to move the around the MAZE.   ;
; You win when you eat the 'o' on the screen. If you get caught;
; by the ghosts, you lose!                  	               ;
;--------------------------------------------------------------;
; Eduardo Saul Ruiz 					       ;
; 4/20/18						       ;
;--------------------------------------------------------------;

	JSR 	INIT
	JSR 	DISPLAY
REP	JSR	INPUT
	JSR	UPHP
WALL	JSR	UPDATE_MAZE
	JSR	MOVE_HEAD
NONE	JSR	DISPLAY
	JSR	CHKEND		
			
	BR 	REP

STOP	HALT

;-------------------------------------------------------------;
; Initializes the position of the head (stored at HEAD_P) and ;
; and stores the corresponding character '<' in the first     ;
; frame.						      ;
; Input		: None                                        ;
; Output	: Position of the head, stored at HEAD_P      ;
;-------------------------------------------------------------;

INIT
	ST	R7, IN_R7
	LD	R1, MAZE	; Base address of the MAZE
	LD	R2, C_OFF	; Column, has #46
	ADD	R1, R1, R2	; Adds #46 to the base of the maze, thus making it go to the next row
	ADD	R1, R1, #2	; Start at the top left corner

	LD	R0, HEAD	; Loads <
	STR	R0, R1, #0 	; Store head char (1st frame)	
	ST	R1, HEAD_P	; Head position has new frame
	
	LD	R7, IN_R7	; Restores R7 PTR
	RET

HEAD	.FILL	x3C
HEAD_P	.BLKW	#1
IN_R7	.BLKW	#1



INPUT	ST	R7, INPUT_R7
	TRAP	x20
	ST	R0, CHAR
	LD	R7, INPUT_R7
	RET

CHAR	.BLKW	#1
INPUT_R7 .BLKW	#1

UPHP	ST	R7, UPHP_R7
	LD	R0, CHAR
	LD 	R1, OPP_w
	ADD	R1, R0, R1	; Checks if player wants to move up
	BRZ	UP
	LD	R1, OPP_a
	ADD	R1, R0, R1	; Checks if player wants to move left
	BRZ	LEFT
	LD	R1, OPP_s
	ADD	R1, R0, R1	; Checks if player wants to move down
	BRZ	DOWN
	LD	R1, OPP_d
	ADD	R1, R0, R1	; Checks if player wants to move right
	BRZ	RIGHT

	BR	REP		; No character matched, thus going back to recieve character input

UP	LD	R0, HEAD_P	; Loads the current position of the head
	ST	R0, OLD_P
	LD	R1, C_OFF	; Loads #46
	NOT	R1, R1
	ADD	R1, R1, #1	; Loads #-46
	ADD	R1, R0, R1	; Subtracts #-46 from the Head position, making it load the memory address that is above the current head position
	LDR	R2, R1, #0	; Loads whatever is above the head.
	LD	R3, OPP_AST	; Loads the opposite of *
	ADD	R3, R2, R3	; Checks if the the character above the head is an *
	BRZ	WALL		; If it matches, then the < doesnt get updated, but everything else does
	ST	R1, HEAD_P	; Stores the new HEAD Position for later
	LD	R7, UPHP_R7
	RET
	
LEFT	LD	R0, HEAD_P	; Loads the current position of the head
	ST	R0, OLD_P
	ADD	R1, R0, #-2	; Loads the address two spaces before the current positon
	LDR	R2, R1, #0	; Loads whatever is two spaces left of the head
	LD	R3, OPP_AST	; Loads the opposite of *
	ADD	R3, R2, R3	; Checks if the left contains an *
	BRZ	WALL		; If it matches, then the < doesnt get updated, but everything else does
	ST	R1, HEAD_P	; Stores the new HEAD Position for later
	LD	R7, UPHP_R7
	RET		
	

DOWN	LD	R0, HEAD_P	; Loads the current position of the head
	ST	R0, OLD_P
	LD	R1, C_OFF	; Loads #46
	ADD	R1, R0, R1	; Adds #46 from the Head position, making it load the memory address that is below the current head position
	LDR	R2, R1, #0	; Loads whatever is below the head.
	LD	R3, OPP_AST	; Loads the opposite of *
	ADD	R3, R2, R3	; Checks if the the character above the head is an *
	BRZ	WALL		; If it matches, then the < doesnt get updated, but everything else does
	ST	R1, HEAD_P	; Stores the new HEAD Position for later
	LD	R7, UPHP_R7
	RET

RIGHT	LD	R0, HEAD_P	; Loads the current position of the head
	ST	R0, OLD_P
	ADD	R1, R0, #2	; Loads the address two spaces after the current positon
	LDR	R2, R1, #0	; Loads whatever is two spaces right of the head
	LD	R3, OPP_AST	; Loads the opposite of *
	ADD	R3, R2, R3	; Checks if the left contains an *
	BRZ	WALL		; If it matches, then the < doesnt get updated, but everything else does
	ST	R1, HEAD_P	; Stores the new HEAD Position for later
	LD	R7, UPHP_R7
	RET

OPP_w	.FILL 	xFF89
OPP_a	.FILL	xFF9F
OPP_s	.FILL 	xFF8D
OPP_d	.FILL 	xFF9C
OPP_AST	.FILL	xFFD6
UPHP_R7	.BLKW 	#1
OLD_P	.BLKW	#1



;-------------------------------------------------------------;
; Loads next frame into location MAZE, and updates HEAD_P to  ;
; point to the a location on the next frame 		      ;
; Input		: Pointer to MAZE(R1), position of head(R0)   ;
; Output	: Pointer to MAZE(R1), position of head(R0)   ; 
;-------------------------------------------------------------;

UPDATE_MAZE
	ST	R7, UA_R7
	
	LD	R1, MAZE	;MY OWN CODE
	LD	R0, HEAD_P	;MY OWN CODE
	LD 	R3, FRAME_N
	LD	R4, FRAME_T
	ADD	R3, R3, #1
	ST 	R3, FRAME_N
	ADD	R3, R3, R4
	
	BRZ	REP_FRAME	
	LD	R2, MAZE_O
	ADD	R0, R0, R2
	ADD	R1, R1, R2
	ST	R0, HEAD_P
	ST	R1, MAZE
	RET

REP_FRAME
	AND	R5, R5, #0
	ST	R5, FRAME_N
	LD	R2, MAZE_N
	ADD	R0, R0, R2
	ADD	R1, R1, R2
	ST	R0, HEAD_P	;MY OWN CODE
	ST	R1, MAZE	;MY OWN CODE
	LD	R7, UA_R7
	RET

FRAME_N	.FILL	#0
FRAME_T	.FILL	#-23
UA_R7	.BLKW	#1

MAZE_O	.FILL #1058
MAZE_N	.FILL #-23276

;-------------------------------------------------------------;
; This subroutine moves the head			      ;
; Input		: None                                        ;
; Output	: None					      ;	  	
;-------------------------------------------------------------;

MOVE_HEAD
	ST	R7, MVHP_R7
	LD	R0, HEAD_P	;Memory where < will be
	LD	R1, OLD_P	;Memory where < was
	NOT	R2, R1
	ADD	R2, R2, #1
	ADD	R2, R0, R2	;Checks if the pointer got updated at all
	BRZ	NONE
	LDR	R2, R1, #0	;Loads <
	LDR	R3, R0, #0	;Loads the character that is in the new position
	ST	R3, PREV_P
	STR	R2, R0, #0	;Moves the head
	LD	R4, SPACE
	STR	R4, R1, #0	;Clears < from previous spot
	LD	R7, MVHP_R7
	RET
	
	

SPACE	.FILL	x0020
PREV_P	.BLKW	#1
MVHP_R7	.BLKW	#1

;-------------------------------------------------------------;
; This subroutine displays the MAZE			      ;
; Input		: None                                        ;
; Output	: None					      ;	  	
;-------------------------------------------------------------;

DISPLAY 
	ST	R7, DS_R7

	LD 	R1, MAZE
	LD	R2, C_OFF	; R1 is column counter
	LD	R3, R_OFF	; R2 is row counter

D_MAZE	
	ADD	R0, R1, #0
	PUTS	
	LD 	R0, LF
	OUT
	ADD	R1, R1, R2
	ADD	R3, R3, #-1
	BRP	D_MAZE		; Prints each row	 

	LD	R7, DS_R7
	RET

C_OFF	.FILL	#46
R_OFF	.FILL	#23
LF	.FILL	x0A
DS_R7	.BLKW	#1

;-------------------------------------------------------------;
; This subroutine checks the end			      ;
; Input		: None                                        ;
; Output	: None					      ;	  	
;-------------------------------------------------------------;

CHKEND	

	ST	R7, END_R7
	LD	R0, PREV_P

	
	LD	R1, OPP_U
	ADD	R1, R0, R1
	BRZ	LOSE

	LD	R1, OPP_o
	ADD	R1, R0, R1
	BRZ	WIN

	LD	R7, END_R7
	RET

LOSE	LEA	R0, GAME_OVER
	TRAP	x22
	BR	STOP

WIN	LEA	R0, GAME_GOOD
	TRAP	x22
	BR	STOP

OPP_U	.FILL	xFFAB
OPP_o	.FILL	xFF91
END_R7	.BLKW	#1
;-------------------------------------------------------------;
;-------------------------------------------------------------;

GAME_OVER
	.STRINGZ " Game Over! You Lose!"

GAME_GOOD
	.STRINGZ " Game Over! You Win!"

MAZE	.FILL	X5000


	.END