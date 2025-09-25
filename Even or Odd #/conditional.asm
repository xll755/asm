TITLE Conditional, Version 1 (conditional.asm)

; This program allows a user to input an integer which will go
; through a series of checks to see if it is positive/negative,
; even/odd, or if it is represented in 8-bits or not.
; it will also exit only when zero is inputted.
; In this program, we will use register edx for WriteString,
; register eax will be used to exit program,for call WriteInt,
; and ReadInt. This procedure calls three sub-procedures to performs
; the checks needed. Uses register ebx for sub-procedures math/checking

; Name: Lewis Green
; CPEN 3710-0
; Date: 02/28/24

INCLUDE Irvine32.inc

.data
inputBox byte "Enter a decimal integer:  ", 0
positive byte " is a positive number.  ", 0
negative byte " is a negative number.  ", 0
evenValue byte " is an even integer.  ", 0
oddValue byte " is an odd integer.  ", 0
represented byte " Can be represented in 8 bits.", 0
notRepresented byte " Cannot be represented in 8 bits.", 0

.code
main PROC
Entry:
mov edx, OFFSET inputBox		;Getting prompting for input
call WriteString				;displays input prompt
call ReadInt					;Reading decimal input and putting it into eax
mov ebx, eax					;moving eax into ebx for calculations in sub-procs
cmp eax, 0						;if user enters zero, exit program
jz exitProgram					;jump to exit to leave infinite loop

call EvenOdd					;Calls subprogram that checks if value is even or odd
call WriteInt					;Displays inputted value before text string
call WriteString				;writes the output for an even or odd value
call crlf						;creates a new line.
call represent  				;Calls subprogram that performs calculations to see if represented in bits
call WriteInt
call WriteString				;writes the output if the value is represented or not
call crlf						
call ValueSign					;Calls subprogram that checks if value is negative or positive
call WriteInt
call WriteString				;writes if the value negative or positive value
call crlf						
call crlf
jmp Entry						;inifinite loop unless user enters zero.

exitProgram:					;once user enters zero, we jump here to exit.
	exit
main ENDP


EvenOdd PROC					;This subprocedure checks if the integer is even or odd.
								;It will use eax and ecx for signed division. It also uses
								;register edx for WriteString. Pushes eax onto the stack to
								;save value for WriteInt and then pops to restore.
;Checking if the number is divible by 2
push eax						;saving value stored in eax for WriteDec
xor edx, edx					;zeroing out edx
mov ecx, 2
idiv ecx						;Divide signed value by 2
cmp edx, 0						;Compare value to 0 to see if zero flag triggered
jz EvenV						;If equal to zero, jump to Even

mov edx, offset oddValue    	;If not, it is not even then odd, then continue
pop eax							;restoring value of eax for WriteDec
ret								;Returns back to the original procedure

EvenV:
pop eax
mov edx, offset evenValue
	ret
EvenOdd ENDP					;End of subprogram


Represent PROC					;This procedure checks if the value the user inputted can be represented within
								;8-bits or not. The register ebx is to compare against values -128 and 127. it
								;also uses register edx to get an offset needed for call WriteString.
cmp ebx, 127					;Comparing to 127
jle notRep						;If it is less than 127, then jump to notRep
mov edx, offset notRepresented	;If it is not less than, then it is out of bounds
	ret

notRep:
; Checks if the number is less than -128
cmp ebx, -128
jl outBounds					;If it is less than or equal to -128, it's not represented
mov edx, offset represented
	ret

outBounds:
mov edx, offset notRepresented	;If it is outside of 127 or -128, write the string that it is not represented
	ret							;Returns back to the original procedure
Represent ENDP					;End of subprogram


ValueSign PROC					;This sub-procedure checks if the value the user entered is negative or positive.
								;The procedure uses register ebx which holds the users inputted value.
								;This program also uses register edx to get an offset needed for call WriteString
;Checking if value is positive or negative
cmp ebx, 0						;comparing value to 0
jl negativeV
mov edx, offset positive		;if it is not less than zero then it is positive
ret

negativeV:
mov edx, offset negative		;if it is negative then output is negative
ret								;return to main program
ValueSign ENDP					;End of subprogram

END main