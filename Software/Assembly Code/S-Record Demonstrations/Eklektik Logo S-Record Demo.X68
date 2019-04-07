*------------------ S-Record Demo -----------------------------------
* Title      : S-Record Demo
* Written by : Micah Richards
*              Eklektik Design
* Date       : 04/11/18
* Description: For S-Record Demonstration Program
*--------------------------------------------------------------------
*---- Characters ----------
_BS         EQU     $08                     * Backspace
_CR         EQU     $0D                     * Carriage Return
_EC         EQU	    $04                     * End Character
_LF         EQU     $0A                     * Line Feed
_SPACE      EQU     $20                     * Space
_CTRL_C     EQU     $03                     * Ctrl-c 

*---- Memory Locations ----
_MORG       EQU     $00F03000               * Monitor origin
_PRT_STRG   EQU     $00001230               * Print String routine location

            ORG     $00F02100
*---- Strings -------------
_E1        DC.B    ' '                                                                              ,_CR, _LF  
_E2        DC.B    '                                     `o-'                                       ,_CR, _LF  
_E3        DC.B    '                                     `dNmy/`'                                   ,_CR, _LF  
_E4        DC.B    '                                      `.+ymNh+-'                                ,_CR, _LF  
_E5        DC.B    '                         `                `:sdNms/-'                            ,_CR, _LF  
_E6        DC.B    '                      -+s`                   `-ohNNh+:'                         ,_CR, _LF  
_E7        DC.B    '                  `:smNd.                       `./ymNdo/'                      ,_CR, _LF  
_E8        DC.B    '               ./ymMMMh`                            `:sdNmy/-'                  ,_CR, _LF  
_E9        DC.B    '           `-odNMMMMMs`                                `-+hmNdo:'               ,_CR, _LF  
_E10       DC.B    '        ./ymNMMMMMMMo  /oooooooooooooooooooooooooooooooo.  .:ydNmy/'            ,_CR, _LF  
_E11       DC.B    '    `-+hmMMMMMMMMMN+  +NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:     `-odNmh+-'        ,_CR, _LF  
_E12       DC.B    ' `:sdNMMMMMMMMMMMN/ `sMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:         ./ymNds:.'    ,_CR, _LF  
_E13       DC.B    'smMMMMMMMMMMMMMMm:  yMMMMMMNNNNNNNNNNNNNNNNNNNNNNNNNNNNN:            .:sdNms'   ,_CR, _LF  
_E14       DC.B    'mMMMMMMMMMMMMMMm-  .MMMMMMm-----------------------------`               `:Mm'   ,_CR, _LF  
_E15       DC.B    'mMMMMMMMMMMMMMd.   -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E16       DC.B    'mMMMMMMMMMMMMy`    -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E17       DC.B    'mMMMMMMMMMMMs`     -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E18       DC.B    'mMMMMMMMMMMo       -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E19       DC.B    'mMMMMMMMMN+        -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E20       DC.B    'mMMMMMMMN:         -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E21       DC.B    'mMMMMMMN-          -MMMMMMm                                              `Mm'   ,_CR, _LF  
_E22       DC.B    'mMMMMMm.           :MMMMMMm                                              :Mm'   ,_CR, _LF  
_E23       DC.B    'mMMMMd`            :MMMMMMMNNNNNNNNNNNNNNNNNNNNNNNN                     /MMm'   ,_CR, _LF  
_E24       DC.B    'mMMMh`             :MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                    oMMMm'   ,_CR, _LF  
_E25       DC.B    'mMMs               :MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM                   sMMMMm'   ,_CR, _LF  
_E26       DC.B    'mMo                :MMMMMMNhhhhhhhhhhhhhhhhhhhhhhhh                 `hMMMMMm'   ,_CR, _LF  
_E27       DC.B    'mM`                :MMMMMMd                                        `dMMMMMMm'   ,_CR, _LF  
_E28       DC.B    'mM`                :MMMMMMd                                       .mMMMMMMMm'   ,_CR, _LF  
_E29       DC.B    'mM`                :MMMMMMd                                      -mMMMMMMMMm'   ,_CR, _LF  
_E30       DC.B    'mM`                :MMMMMMd                                     :NMMMMMMMMMm'   ,_CR, _LF  
_E31       DC.B    'mM`                :MMMMMMd                                    +NMMMMMMMMMMm'   ,_CR, _LF  
_E32       DC.B    'mM`                :MMMMMMd                                   oMMMMMMMMMMMMm'   ,_CR, _LF  
_E33       DC.B    'mM`                :MMMMMMd                                 `sMMMMMMMMMMMMMm'   ,_CR, _LF  
_E34       DC.B    'mM`                /MMMMMMd-----------------------------`  `yMMMMMMMMMMMMMMm'   ,_CR, _LF  
_E35       DC.B    'dMms:.             /MMMMMMMNNNNNNNNNNNNNNNNNNNNNNNNNNNNs  .dMMMMMMMMMMMMMMMh'   ,_CR, _LF  
_E36       DC.B    '`:sdNmh+-`         /MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMs` -mMMMMMMMMMMMMNdo-`'   ,_CR, _LF  
_E37       DC.B    '   `-+hmNdo:`      /MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMo  :mMMMMMMMMMMmy/.'       ,_CR, _LF  
_E38       DC.B    '       .:sdNmy/.   -ssssssssssssssssssssssssssssssss/  /NMMMMMMMNds:.'          ,_CR, _LF  
_E39       DC.B    '          `-+hNNh+-`                                  +NMMMMMmh+-`'             ,_CR, _LF  
_E40       DC.B    '             `./ymNds:.                              oMMMNmy/.'                 ,_CR, _LF  
_E41       DC.B    '                 `:odNmy+.`                        `sMNdo:`'                    ,_CR, _LF  
_E42       DC.B    '                   ``./ymNdo-`                    `sh+-'                        ,_CR, _LF  
_E43       DC.B    '                        `:sdNmy/`                 ``'                           ,_CR, _LF  
_E44       DC.B    '                            -+hNNh+.`'                                          ,_CR, _LF  
_E45       DC.B    '                               `:smNds'                                         ,_CR, _LF  
_E46       DC.B    '                                   -+h.'                                        ,_CR, _LF,  0

*------------------ Functions ---------------------------------------

*------------------ Main Code ---------------------------------------
* Purpose: Prints the Eklektik Design Logo
*
*--------------------------------------------------------------------
            ORG     _MORG                   * Hard Reset
            DC.L    START
            
START       LEA     _E1,    A4
            JSR     _PRT_STRG
            RTS
            SIMHALT                         * Halt simulator
            END     START                  	* last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
