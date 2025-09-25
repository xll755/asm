;TITLE quadratic Procedure, version 1 (callee.asm)

;This procedure will be called by a high level procedure.
;it will use real numbers, utilizing the floating point unit
;and will be using the eax register. This procedure uses the integers
;from the HLL procedure, evaluates them using the quadratic formula,
;and places their roots in memory. If the roots are valid, eax will return
;0 and if they are complex/invalid, it returns -1.
;formula: [-(b)+/-sqrt(b^2-4ac)]/2a
 
; Lewis Green
; CPEN 3710
; 4/12/24

.386
.model FLAT, C 

public quadratic		;quadratic is able to be found by external code

.data
Constant4 REAL4 -4.0F
Constant2 REAL4 2.0F

.code
quadratic proc

push ebp				;Saving (pushing) ebp on the stack
mov ebp, esp			;creating stack frame (saving ebp location)
finit					;creates FPU and sets flags
fld REAL4 ptr [ebp+12]	;loading a into st0
fld REAL4 ptr [ebp+16]	;loading c into st0, moving a to st1,

;(-2ac)
fmul			;multiplying a and c (st0 and st1)
fld Constant4	;loading -4 into st0, moving ac to st1
fmul			;multiplying -4 by ac
				;st0 contains -4ac
				
;(b^2-2ac)
fld REAL4 ptr [ebp+8]	;loading b into st0, moving -4ac to st1
fld REAL4 ptr [ebp+8]	;loading b into st0, b to st1, -4ac to st2
fmul					;b^2
fadd					;adding b^2 to -4ac, now (b^2)-4ac in st0

;checking if a negative is under radical
fldz		;loading 0 into st0
fcomp		;comparing st0 to st1 and popping, st1 value will be in st0 again
fnstsw ax	;fpu status is stored in AX
sahf		;setting the flags from AH
ja complexRoot	;if below or equal to 0, complex or invalid

;finding the square root if not complex
fsqrt	;gets the square root of st0

;adding and subtracting square root
fld REAL4 ptr [ebp+8]	;loading b into st0, sqrt((b^2)-4ac) in st1 and st2
fchs					;flipping b's sign so -b
fsub st(0), st(1)		;subtracts st0 from st1, result in st0, st1 now sqrt((b^2)-4ac)
fld REAL4 ptr [ebp+8]	;loading b into st0, shifting stack
fchs
faddp st(2), st(0)		;adds b to sqrt((b^2)-4ac), popping st0.
						;now results are in st0 and st1
						;subtraction in st0, addition in st1

;finally dividing by 2a
fld Constant2
fld REAL4 ptr [ebp+12]
fmul
fld st(0)				;st0&1 are 2a, st2&3 are sub&add
fdivp st(2),st(0)		;divides st2 by st0, popping st0
						;now st0 is 2a, st1 [-(b)-sqrt(b^2-4ac)]/2a, st2 -(b)+sqrt(b^2-4ac)
fdivp st(2), st(0)		;divides st2 by st0, making st2 -(b)+sqrt(b^2-4ac)/2a
						;st0 contains [-(b)-sqrt(b^2-4ac)]/2a, st1 contains [-(b)+sqrt(b^2-4ac)]/2a

;moving answer1&2 into edi, moving results into answer1&2
mov edi, [ebp+20]
fstp REAL4 ptr [edi]
mov edi, [ebp+24]
fstp REAL4 ptr [edi]
jmp validRoot

complexRoot:
mov eax, -1		;if invalid root/complex 
pop ebp
ret

validRoot:
mov eax, 0		;if roots are valid
pop ebp			;restoring ebp
ret				;returning back to HLL procedure
quadratic endp
END