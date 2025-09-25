
TITLE 6 Character Input Evaluator, Version 1
; Lewis Green
; CPSC 4100
; XLL755
; This program is designed to accept 6 characters from the user.
; Upon accepting the 6 characters, the program will evaluate each
; input, byte by byte, to determine if what was entered is a string, floating point,
; or integer. This program includes Irvine's library, utilizing the procedures
; ReadString (uses ecx register for character count and stores character count
; in eax), crlf (new line), and WriteString (uses edx register). Registers utilized:
; ebx, edx, ecx, esi. al, bh, and bl are used as counters. ecx is used for loop
; and esi is used for iterating through array. al with dl is also used to compare values.
; if the characters entered do not fit within the parameters, error message will be displayed.
; Entering ?????? will exit the program or closing the window will.


INCLUDE Irvine32.inc
.Data
prompt byte "Enter the 6-characters you want evaluated or input ?????? to exit: ",0
input byte 7 dup(?) ;storage for user input values (6)
int_prompt byte "This is an integer.",0
fl_prompt byte "This is a floating point.",0
str_prompt byte "This is a string.",0
error_prompt byte "Your input could not be computed. Please try again.",0


.code
main proc
start:
call Crlf ;procedure that clears screen
mov edx, offset prompt ;pointing edx to prompts location in memory
call WriteString ;calling irvine function: displaying prompt
mov ecx, 7 ;moving amount of characters into ecx (6+null)
mov edx, offset input ;pointing edx to input to accept characters entered
call ReadString ;Calling irvine function for user input
mov dl, [input] ;moving first character input into dl
cmp dl, '?' ;comparing to ascii value
je finished ;if equal, then exit program.
xor ebx, ebx ;zeroing out registers
xor esi, esi
xor edx, edx
mov ecx, 6 ;setting up ecx for loop counter
mov al, input[esi] ;moving 1st value from input into al

L1: ;Loop 1, setting up checks
cmp al, '9' ;comparing to ascii value of 9
jg alpha_check ;if al > 39, then must be alphabet.
cmp al, '0' ;comparing 1st value to ascii value of 0
jl deci_check ;if the ascii char is < 30, then it isn't a number
inc bl ;if within number range, add 1 to bl.
jmp next_char ;continue with loop
deci_check: ;2E<30, if equal to 2E, it is a period.
cmp dl, al
je complication
cmp al, '.' ;comparing al to ascii value of a period (56)
jl complication ;if < 2E out of range
jne next_char ;if not a period, get the next value
inc bh ;if decimal found, add 1 to bh
jmp next_char ;continue checking through loop

alpha_check:
cmp al, 'z' ;comparing ascii value of z
jg complication ;if > 7A it is out of range
cmp al, 'A' ;comparing ascii value of A
jl complication ;if < 41 at this point, error.
inc ah ;if letter found, add 1 to ah.

next_char:
mov dl, al ;moving al into dl if decimal point found
inc esi ;move a byte over (next value)
mov al, input[esi] ;moving 1st value from input into al
loop L1 ;end of loop
deci_alpha_check:
mov al, bh ;moving decimal count into al
cmp al, 0 ;seeing if zero
jz results
add al, ah ;adding alphabet count to decimal count
cmp al, 6 ;comparing to see if they add up to 6
je complication ;if equals 6

fl_check:
mov al, bh ;move decimal count into al
cmp al, 0
jz results
cmp bh, 3 ;comparing decimal counter to 3
jg complication ;cannot have more than three decimals w/ 6 characters
add al, bl ;add decimal count and int count
cmp al, 6 ;compare to characters
je fl_found ;if equal to 6, must be float

results:
cmp ah, 6 ;comparing if 6 letters found
je alpha_found ;if found, jump for result
cmp bl, 6 ;comparing if 6 integers found
je int_found ;if found, jump
jmp complication ;if none of the jumps are taken, its none of them
alpha_found: ;displays result for string
mov edx, offset str_prompt
call WriteString

jmp start
int_found: ;displays result for integer
mov edx, offset int_prompt
call WriteString
jmp start
fl_found: ;displays result for float
mov edx, offset fl_prompt
call WriteString
jmp start
complication: ;not within range so error display
mov edx, offset error_prompt
Call WriteString
jmp start

finished:
exit
main ENDP
END main