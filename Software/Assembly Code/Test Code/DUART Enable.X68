*-----------------------------------------------------------
* Program    : Test Loop
* Written by : Instructor
* Date       : 2010
* Description: Testing RAM with a subroutine jump. To jump
*              to a subroutine, the PC and SR are pushed onto
*              the stack which is a location in RAM. If the
*              program continually loops, the RAM is working
*-----------------------------------------------------------
; *******************************************************************
; Constants:	(Note the offsets to account for no A0)
DUART   	EQU	    $300000     loaded in A0 when needed, regs are offsets
MR1A   	    EQU   	1	  Mode Register1
MR2A  	    EQU   	1	  points here after MR1A is set
SRA    	    EQU   	3     Status Register (read)
CSRA   	    EQU   	3     Clock Select Register
CRA   	    EQU   	5	  Command Register
TBA		    EQU   	7     Transfer Holding Register
RBA		    EQU   	7	  Receive Holding Register
ACR		    EQU	  	9	  Auxiliary control register
RxRDY		EQU		0	  Recieve ready bit position
TxRDY		EQU		2	  Transmit ready bit position
BAUD		EQU	  	$CC   baud rate value = 19,200 baud
; *******************************************************************



SUPER_STACK     EQU     $F00800	; MUST BE A VALID RAM LOCATION


START   	ORG     $000000
        	DC.L    SUPER_STACK
        	DC.L    INIT

        	ORG     $000100    
INIT        JSR RAM_TEST
            JSR INIT_DUART
MAIN    	JSR	RAM_TEST
		    JMP	MAIN
        
RAM_TEST 	NOP
        	NOP
		    NOP
		    RTS


INIT_DUART  LEA	  	DUART,A0		A0 points to base DUART address

; Software reset:
      	MOVE.B	#$30,CRA(A0)	Reset TxA
		MOVE.B	#$20,CRA(A0)	Reset RxA
		MOVE.B	#$10,CRA(A0)	Reset MRA pointer

; Initialization:
        MOVE.B  	#$80,ACR(A0)	    selects baud rate set 2
        MOVE.B  	#BAUD,CSRA(A0)  	set 19.2k baud Rx/Tx
      	MOVE.B  	#$13,MR1A(A0)   	8-bits, no parity, 1 stop bit

; This is the most important register to set in the 68681 DUART.
; 07 sets: Normal mode, CTS and RTS disabled, stop bit length = 1
; For testing load $#47 to enable auto-echo
      	MOVE.B	#$47,MR2A(A0)	

      	MOVE.B	#$05,CRA(A0)	enable Tx and Rx
      	RTS



        	END     INIT



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
