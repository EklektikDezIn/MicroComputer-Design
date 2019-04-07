
*-----------------------------------------------------------
* Subroutine : DUART enable
* Written by : Instructor
* Date       : 2013
* Description: used to initialize a 68681 DUART
*-----------------------------------------------------------

* Note, most DUART configurations are ignorant of UDS/LDS 
* and thus are only active on odd addresses (since the lower 
* data lines are usually run to the DUART data bus)

; *******************************************************************
; Constants:	(Note the offsets to account for no A0)
DUART   EQU	    $300000     loaded in A0 when needed, regs are offsets
MR1A   	EQU   	1	Mode Register1
MR2A  	EQU   	1	points here after MR1A is set
SRA    	EQU   	3     Status Register (read)
CSRA   	EQU   	3     Clock Select Register
CRA   	EQU   	5	Command Register
TBA		EQU   	7     Transfer Holding Register
RBA		EQU   	7	Receive Holding Register
ACR		EQU	  	9	Auxiliary control register
RxRDY	EQU		0	Recieve ready bit position
TxRDY	EQU		2	Transmit ready bit position
BAUD	EQU	  	$CC   baud rate value = 19,200 baud

CR         EQU     $0D                     * Carriage Return
LF         EQU     $0A                     * Line Feed

; *******************************************************************



SUPER_STACK     EQU     $F00800	; MUST BE A VALID RAM LOCATION


START   	ORG     $000000
        	DC.L    SUPER_STACK
        	DC.L    BEGIN
			DC.L    HANDLE_BERR   Berr
			DC.L    HANDLE_ADDR   Address Error
			DC.L    HANDLE_ILIS   Illegal Instruction
			DC.L    HANDLE_DIV0   Div by zero
			
        	ORG     $000100        
BEGIN       JSR RAM_TEST
            JSR INIT_DUART
MAIN    	JSR GETCHAR_A
      	    JSR PUTCHAR_A
            JSR	RAM_TEST
		    JMP	MAIN
        
        
INIT_DUART  LEA	  	DUART,A0		A0 points to base DUART address

; Software reset:
      	MOVE.B	#$30,CRA(A0)	Reset TxA
		MOVE.B	#$20,CRA(A0)	Reset RxA
		MOVE.B	#$10,CRA(A0)	Reset MRA pointer

; Initialization:
        MOVE.B  	#$80,ACR(A0)	selects baud rate set 2
        MOVE.B  	#BAUD,CSRA(A0)  	set 19.2k baud Rx/Tx
      	MOVE.B  	#$13,MR1A(A0)   	8-bits, no parity, 1 stop bit

; This is the most important register to set in the 68681 DUART.
; 07 sets: Normal mode, CTS and RTS disabled, stop bit length = 1
; For testing load $#47 to enable auto-echo
      	MOVE.B	#$07,MR2A(A0)	

      	MOVE.B	#$05,CRA(A0)	enable Tx and Rx
      	
      	RTS
      	
 ; GETCHAR puts the read character into D0
GETCHAR_A   MOVE.B SRA(A0), D0  Read the A status register
           BTST #RxRDY, D0 Test reciever ready status
           BEQ GETCHAR_A   UNTIL char recieved
           MOVE.B RBA(A0), D0  Read the character into D0
           RTS
*GETCHAR_A    MOVE.L  D1,         -(A7)       * Save working register
*            MOVE    #5,         D0          * Store 'get single char' command
*            TRAP    #15                     * Trigger simulator action
*            MOVE    D1,         D0          * Move result into output register
*            MOVE.L  (A7)+,      D1          * Restore working register
*            RTS                             * Return

; PUTCHAR_A outputs D0 to the DUART channel A
PUTCHAR_A   MOVE.W D0, -(SP)
PUTCHAR_Apl  MOVE.B SRA(A0), D0
           BTST   #TxRDY, D0
           BEQ    PUTCHAR_Apl
           MOVE.W (SP)+, D0
           MOVE.B D0, TBA(A0)
           RTS
*PUTCHAR_A    MOVE.L  A0,        -(A7)       * Save working register
*            LEA     DUART,    A0          * Store base DUART address in A0
*            MOVE.B  D0,        $A0         * Move contents of D0 to location in A0
*            MOVE.L  (A7)+,     A0          * Restore working register
*            RTS                            * Return
        
RAM_TEST 	NOP
        	NOP
		    NOP
		    RTS
		    
HANDLE_BERR LEA SUPER_STACK, SP
            MOVE.L #Err_BERR, A0
            JSR PUTSTR
            JMP BEGIN
HANDLE_ADDR LEA SUPER_STACK, SP
            MOVE.L #Err_ADDR, A0
            JSR PUTSTR
            JMP BEGIN
HANDLE_ILIS LEA SUPER_STACK, SP
            MOVE.L #Err_ILIS, A0
            JSR PUTSTR
            JMP BEGIN
HANDLE_DIV0 LEA SUPER_STACK, SP
            MOVE.L #Err_DIV0, A0
            JSR PUTSTR
            JMP BEGIN

            ; Print String in A0
PUTSTR      MOVE.W D0, -(SP)
            MOVE.W D1, -(SP)
            CLR.W D1 Length will be stored here
pst_Next    CMP.W #$200, D1 If >= 512, 
            BHS pst_Quit   quit
            MOVE.B (A0)+, D0
            ADD #1, D1
            CMP.B #0, D0   If null,
            BEQ pst_Quit   quit
            JSR PUTCHAR_A
            BRA pst_Next
pst_Quit    MOVE.W (SP)+, D1
            MOVE.W (SP)+, D0
            RTS
            
Err_BERR  DC.B 'BERR',CR,LF,0
Err_ADDR  DC.B 'ADDR',CR,LF,0
Err_ILIS  DC.B 'ILIS',CR,LF,0
Err_DIV0  DC.B 'DIV0',CR,LF,0


        END     BEGIN








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
