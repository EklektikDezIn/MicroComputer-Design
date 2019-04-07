******************************************************************0
* Micah Richards 						   						 *
* Eklektik Design												 *
* 3/20/17	  						 							 *
* MCD									  						 *
******************************************************************5
******************************************************************
* Variables                                                      *
******************************************************************9
* remember the ending character
ENDCHAR	 EQU	 $04
* remember the start location
OSTART	 EQU	 $C000
* remember the starting index
XSTART	 EQU	 $D000

******************************************************************
* Main Code 													 *
******************************************************************
* set the origin
	 ORG 	OSTART
	 
* Load the message starting address into X
PRTWEL	 LDX 	 #WELCOME
* print carriage return and line feed
	 JSR	 OUTCRLF
* print out entire stored message
	 JSR	 OUTSTRG

* Mark the start of the prompt message loop
* Load the message starting address into X
PRTPMT	 LDX 	 #PROMPT
* print carriage return and line feed
	 JSR	 OUTCRLF
* print out entire stored message
	 JSR	 OUTSTRG
	 
* init x register to start
	 LDX 	 #XSTART
* mark getin subtroutine, get character
GETIN	 JSR	 INCHAR
* store character at X
	 STAA	 0,X
* check if the character is the end char
	 CMPA 	 #ENDCHAR
* if it is, exit
	 BEQ	 EXIT
* otherwise increment x
	 INX
* check if x is at the end
	 CPX	 #XEND
* if it is, exit
	 BEQ	 EXIT
* otherwise restart
	 JMP	 PRTPMT
* mark exit subtroutine, print carriage return and line feed
EXIT	 JSR	 OUTCRLF




* Load the message starting address into X
PRTREP	 LDX 	 #REPLY
* print carriage return and line feed
	 JSR	 OUTCRLF
* print out entire stored message
	 JSR	 OUTSTRG
	 
* move x back to starting point
	 LDX 	 #XSTART
* print out entire stored message
	 JSR	 OUTSTRG
* software interrupt
	 SWI
	 
*********************
* MESSAGE STORE     *
*********************
* Store the welcome message
WELCOME	 This the uComp of Micah Richards.  Welcome!
* Store end line
	 FCB $04

* Store the prompt message
PROMPT	 Please type some input: 
* Store end line
	 FCB $04
	 
* Store the reply message
REPLY	 You just typed: 
* Store end line
	 FCB $04