TITLE Lottery, Version 3 (lotterySIM.asm)
;This procedure will mimic a lottery draw by creating a structure with two instances. One will accept
;randomized, computer generated numbers utilizing the EAX register and procedures Randomize and RandomRange
;from Irvine. This program will use registers esi and edi to point to locations in memory such as Ldraw and
;and Uticket. Uticket will be moved into EAX, compared to locations in memory, and the results will either inc
;EBX or make no changes to signal a match is found or not. EBX will then be moved into EAX, output, and then used
;to determine what strings should be output. Register ECX will be used to establish loop for checking white balls
;and then will be used to determine if the red ball is found by comparing EDX and EBX. If ball is found ECX will
;have a value of 1, if not it will have a value of 0. One Macro will be used in this procedure.

; Name: Lewis Green
; CPEN 3710
; Date: 4/5/24

INCLUDE Irvine32.inc

lotteryBalls STRUCT		;This structure stores variables for the lottery draw which will
	whiteB1 dword ?		;be randomized. The randomized values will be compared to the 
	whiteB2 dword ?		;inputted user values to see if the user wins a prize or not
	whiteB3 dword ?
	whiteB4 dword ?
	whiteB5 dword ?
	redBall dword ?
lotteryBalls Ends

.data
Ldraw lotteryBalls <>		;This initializes an instance of the structures to be used
Uticket lotteryBalls <>		;this initializes another instance of the structure to be used
prompt byte "Enter 6 integers. First five ranging from 1 to 69, and last ranging from 1 to 26: ",0
first byte "Enter your first white ball number: ",0
second byte "Enter second white ball number:  ",0
third byte "Enter third white ball number: ",0
fourth byte "Enter fourth white ball number: ",0
fifth byte "Enter fifth white ball number: ",0
sixth byte "Please enter your final integer - your red ball number: ",0
invalidPrompt byte "Invalid integer, input again. ",0
wNum byte "The lottery number drawn: ",0
leavePrompt byte "Enter 0 to restart or press enter. Enter any other integer to exit.",0

;This will be the results if matches or no matches found							
totalWbMatch byte " White Ball matches found ",0
yesRed byte "along with a red ball: ",0
noRed byte "without a red ball: ",0

;This will be the results WITHOUT a red ball in the match
zero_wbnoRed byte "No matches, better luck next time.",0
one_wbnoRed byte " Your ticket wins nothing, better luck next time.",0
two_wbnoRed byte "Your ticket wins nothing, better luck next time.",0
three_wbnoRed byte "Your ticket wins $7!",0
four_wbnoRed byte "Your ticket wins $100!",0
five_wbnoRed byte "Your ticket wins $1,000,000!",0

;This will be  the results WITH a red ball in the match
one_rednoWhite byte "Your ticket wins $4!",0
one_red1White byte "Your ticket wins $4!",0
one_red2White byte "Your ticket wins $7!",0
one_red3White byte "Your ticket wins $100!",0
one_red4White byte "Your ticket wins $50,000!",0
one_red5White byte "Your ticket wins the Grand Prize!",0

RandomizerWB MACRO	;creating macro to produce random integers in range
mov eax, 69			;sets randomizes range to 0 to 69 - 1 (0-68)
push eax			;saving range of values
call RandomRange	;randomizes 
inc eax				;adds 1 to eax incase of 0 and to make sure it can reach 69.
endm

notValid MACRO
mov edx, offset invalidPrompt
call WriteString
endm

.code
main PROC
call Randomize	;generates unique seeds
Beginning:
;first white ball randomize
RandomizerWB	;using macro
mov Ldraw.whiteB1, eax		;moving random value from eax into white ball 1
mov edx, offset wNum	;points to wNum
call WriteString		;writes wNum string
call WriteDec			;calls to write randomized value
pop eax			;restoring range of values
call crlf

;second white ball randomize
retry1:
RandomizerWB
mov Ldraw.whiteB2, eax
cmp eax, Ldraw.whiteB1
jz retry1
mov edx, offset wNum	;points to wNum
call WriteString		;writes wNum string
call WriteDec			;calls to write randomized value
pop eax			;restoring range of values
call crlf		

;third white ball randomize
retry2:
RandomizerWB
mov Ldraw.whiteB3, eax
cmp eax, Ldraw.whiteB1
jz retry2
cmp eax, Ldraw.whiteB2
jz retry2
mov edx, offset wNum	;points to wNum
call WriteString		;writes wNum string
call WriteDec			;calls to write randomized value
pop eax			;restoring range of values
call crlf

;fourth white ball randomize
retry3:
RandomizerWB
mov Ldraw.whiteB4, eax
cmp eax, Ldraw.whiteB1
jz retry3
cmp eax, Ldraw.whiteB2
jz retry3
cmp eax, Ldraw.whiteB3
jz retry3
mov edx, offset wNum	;points to wNum
call WriteString		;writes wNum string
call WriteDec			;calls to write randomized value
pop eax			;restoring range of values
call crlf

;fift white ball randomize
retry4:
RandomizerWB
mov Ldraw.whiteB5, eax
cmp eax, Ldraw.whiteB1
jz retry4
cmp eax, Ldraw.whiteB2
jz retry4
cmp eax, Ldraw.whiteB3
jz retry4
cmp eax, Ldraw.whiteB4
jz retry4
mov edx, offset wNum	;points to wNum
call WriteString		;writes wNum string
call WriteDec			;calls to write randomized value
pop eax			;restoring range of values
call crlf

retry5:
mov eax, 26 ;establishes range for 26 - 1 (0 to 25)
call RandomRange ;randomizes from 0 to 25
inc eax	;changes range to 1 to 26.
mov Ldraw.redBall, eax
mov edx, offset wNum	;points to wNum
call WriteString		;writes wNum string
call WriteDec			;calls to write randomized value
call crlf

;start for user input	
mov edx, offset prompt		;prompt to alert user of steps
call WriteString
call crlf

;First user input
input1:
mov edx, offset first		;prompt for the first value
call WriteString
call ReadInt		;This section will ask for user input and move them
cmp eax, 0			;using ReadInt, stores input in eax
jz badInput1		;compares to 0 and 69, if outside of range
jb badInput1		;it is invalid and user needs to input another
cmp eax, 69			;integer.
ja badInput1	
mov Uticket.whiteB1,eax
jmp input2

badInput1:
notValid	;using macro to writestring
jmp input1

;Second user input
input2:
mov edx, offset second
call WriteString
Call ReadInt
cmp eax, 0			;using ReadInt, stores input in eax
jz badInput2		;compares to 0 and 69, if outside of range
jb badInput2		;it is invalid and user needs to input another
cmp eax, 69			;integer.
ja badInput2
cmp eax, Uticket.whiteB1	;compares to see if value exists already
jz badInput2				;if exists, jump to badinput to reiterate input
mov Uticket.whiteB2,eax
jmp input3

badInput2:
notValid
jmp input2

;third input
input3:
mov edx, offset third
call WriteString
Call ReadInt
cmp eax, 0			;using ReadInt, stores input in eax
jz badInput3		;compares to 0 and 69, if outside of range
jb badInput3		;it is invalid and user needs to input another
cmp eax, 69			;integer.
ja badInput3
cmp eax, Uticket.whiteB1	;compares to see if value exists already
jz badInput3				;if exists, jump to badinput to reiterate input
cmp eax, Uticket.whiteB2
jz	badInput3
mov Uticket.whiteB3,eax
jmp input4

badInput3:
notValid
jmp input3

;fourth input
input4:
mov edx, offset fourth
call WriteString
Call ReadInt
cmp eax, 0			;using ReadInt, stores input in eax
jz badInput4		;compares to 0 and 69, if outside of range
jb badInput4		;it is invalid and user needs to input another
cmp eax, 69			;integer.
ja badInput4
cmp eax, Uticket.whiteB1	;compares to see if value exists already
jz badInput4				;if exists, jump to badinput to reiterate input
cmp eax, Uticket.whiteB2
jz badInput4
cmp eax, Uticket.whiteB3
jz badInput4
mov Uticket.whiteB4,eax
jmp input5

badInput4:
notValid
jmp input4

;fifth input
input5:
mov edx, offset fifth
call WriteString
Call ReadInt
cmp eax, 0			;using ReadInt, stores input in eax
jz badInput5		;compares to 0 and 69, if outside of range
jb badInput5		;it is invalid and user needs to input another
cmp eax, 69			;integer.
ja badInput5
cmp eax, Uticket.whiteB1	;compares to see if value exists already
jz badInput5				;if exists, jump to badinput to reiterate input
cmp eax, Uticket.whiteB2
jz badInput5
cmp eax, Uticket.whiteB3
jz badInput5
cmp eax, Uticket.whiteB4
jz badInput5
mov Uticket.whiteB5,eax
jmp input6

badInput5:
notValid
jmp input5

;sixth input
input6:
mov edx, offset sixth
call WriteString
Call ReadInt	
cmp eax, 0			;using ReadInt, stores input in eax
jz badInput6		;compares to 0 and 69, if outside of range
jb badInput6		;it is invalid and user needs to input another
cmp eax, 26			;integer.
ja badInput6	
mov Uticket.redBall,eax
jmp compare

badInput6:
notValid
jmp input6

compare:
xor edx, edx            ;zeros out register
xor ebx, ebx
mov esi, offset uticket ;points to Uticket
mov edi, offset Ldraw   ;points to beginning of Ldraw
mov ecx, 5              ;number of white balls in uticket for loop
mov eax, [esi]          ;moving user input into eax
L1:						;loop for first user input
cmp eax, [edi]          ;comparing input w/ random draw
je MatchFound           ;if match found, jump
add edi, 4              ;if no match move to next value in Ldraw
Loop L1					;end of loop1
jmp nComp

MatchFound:
inc ebx         ;if match found, increment counter


nComp:			;compares second value
mov ecx, 5      ;number of white balls in uticket for loop
mov edi, offset Ldraw   ;points to beginning of Ldraw
add esi,4		;moving a dword over for white balls
mov eax, [esi]  ;moving user input into eax
L2:
cmp eax, [edi]      ;comparing input w/ random draw
je MatchFound2      ;if match found, jump
add edi, 4          ;if no match move to next value in Ldraw
Loop L2
jmp nComp1			;compares third value

MatchFound2:
inc ebx         ;if match found, increment counter

nComp1:			;compares third value
mov ecx, 5      ;number of white balls in uticket for loop
mov edi, offset Ldraw   ;points to beginning of Ldraw
add esi,4		;moving a dword over for white balls
mov eax, [esi]  ;moving user input into eax
L3:
cmp eax, [edi]      ;comparing input w/ random draw
je MatchFound3      ;if match found, jump
add edi, 4          ;if no match move to next value in Ldraw
Loop L3
jmp ncomp2			;compares fourth value

MatchFound3:
inc ebx         ;if match found, increment counter

ncomp2:			;compares fourth value
mov ecx, 5      ;number of white balls in uticket for loop
mov edi, offset Ldraw   ;points to beginning of Ldraw
add esi,4		;moving a dword over for white balls
mov eax, [esi]  ;moving user input into eax
L4:
cmp eax, [edi]          ;comparing input w/ random draw
je MatchFound4          ;if match found, jump
add edi, 4              ;if no match move to next value in Ldraw
Loop L4
jmp ncompFinal			;compares fourth value

MatchFound4:
inc ebx			 ;if match found, increment counter

ncompFinal:			;compares final value
mov ecx, 5			;number of white balls in uticket for loop
mov edi, offset Ldraw   ;points to beginning of Ldraw
add esi,4			;moving a dword over for white balls
mov eax, [esi]		;moving user input into eax
L5:
cmp eax, [edi]          ;comparing input w/ random draw
je MatchFound5          ;if match found, jump
add edi, 4              ;if no match move to next value in Ldraw
Loop L5
jmp wbFound

MatchFound5:
inc ebx         ;if match found, increment counter

wbFound:
mov eax, ebx		;moving white ball matches found in eax
call WriteDec		;writes amt of matches found
mov edx, offset totalWbMatch	;points to prompt to show matches
call WriteString

rbCheck:
xor ecx, ecx		;zeros out ecx in case loop ended early
add esi, 4			;move a dword to last position - red ball
mov edx, [esi]		;move the users input red ball into edx
mov ebx, Ldraw.RedBall ;comparing red ball numbers for match
cmp edx, ebx	;cmp the random red ball to user red ball input
jne noMatches		;if red ball match not found, jmp to next section
inc ecx				;add 1 to ecx if red ball found
mov edx, offset yesRed
call WriteString
jmp noMatchesCont

noMatches:
mov edx, offset noRed
call WriteString
noMatchesCont:
cmp eax, 0			;compares matches to 0
jnz oneMatches		;if not zero, get checked elsewhere
cmp ecx, 1			;checks if red ball match is found
je gotRed			;if found, jump to found red ball part
mov edx, offset zero_wbnoRed ;if not found, write prompt
call WriteString
jmp ending		;skip further sections if this meets conditions.
gotRed:
mov edx, offset one_rednoWhite	;if red found, output prompt
call WriteString
jmp ending


oneMatches:
cmp eax, 1			;compares matches to 0
jnz twoMatches		;if not zero, get checked elsewhere
cmp ecx, 1			;checks if red ball match is found
je gotRed1			;if found, jump to found red ball part
mov edx, offset one_wbnoRed ;if not found, write prompt
call WriteString
jmp ending		;skip further sections if this meets conditions.
gotRed1:
mov edx, offset one_red1White	;if red found, output prompt
call WriteString
jmp ending

twoMatches:
cmp eax, 2			;compares matches to 0
jnz threeMatches		;if not zero, get checked elsewhere
cmp ecx, 1			;checks if red ball match is found
je gotRed2			;if found, jump to found red ball part
mov edx, offset two_wbnoRed ;if not found, write prompt
call WriteString
jmp ending		;skip further sections if this meets conditions.
gotRed2:
mov edx, offset one_red2White	;if red found, output prompt
call WriteString
jmp ending

threeMatches:
cmp eax, 3			;compares matches to 0
jnz fourMatches		;if not zero, get checked elsewhere
cmp ecx, 1			;checks if red ball match is found
je gotRed3			;if found, jump to found red ball part
mov edx, offset three_wbnoRed ;if not found, write prompt
call WriteString
jmp ending		;skip further sections if this meets conditions.
gotRed3:
mov edx, offset one_red3White	;if red found, output prompt
call WriteString
jmp ending

fourMatches:
cmp eax, 4			;compares matches to 0
jnz FiveMatches		;if not zero, get checked elsewhere
cmp ecx, 1			;checks if red ball match is found
je gotRed4			;if found, jump to found red ball part
mov edx, offset four_wbnoRed ;if not found, write prompt
call WriteString
jmp ending		;skip further sections if this meets conditions.
gotRed4:
mov edx, offset one_red4White	;if red found, output prompt
call WriteString
jmp ending

fiveMatches:
cmp ecx, 1			;checks if red ball match is found
je gotRed5			;if found, jump to found red ball part
mov edx, offset five_wbnoRed ;if not found, write prompt
call WriteString
jmp ending		;skip further sections if this meets conditions.
gotRed5:
mov edx, offset one_red5White	;if red found, output prompt
call WriteString
jmp ending

ending:
call crlf
mov edx, offset leavePrompt
call WriteString
call ReadInt
cmp eax, 0
jz Beginning

	exit
main ENDP

END main