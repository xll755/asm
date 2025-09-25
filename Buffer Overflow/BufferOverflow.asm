; Program for Lab Exercise 12, Fall 2023
; The code as written is subject to a buffer overflow attack to execute code
; other than what is called during normal program control flow. Students are
; tasked with modifying the "badstr" content in such a way that the procedure
; "payload" is executed without being called. Procedure "vulnerable" can be
; compromised because it calls an unsafe procedure, "copystring".
;Lewis Green
;CPEN 3710
;04/17/24

	include Irvine32.inc
	.data
donestr  byte   "Finished safely.",0
alarm    byte   "Your computer is infected!",0
badstr   byte   "Green{*.*.*.*.*}",0F0h,36h,40h,00h,0

	.code
main    proc
    lea   esi, badstr         ; set up a pointer to badstr
	push  esi                 ; pass it to vulnerable procedure via stack frame
	call  vulnerable          ; call vulnerable procedure
	add   esp, 4              ; clean up stack
	mov   edx, offset donestr ; output finished message
	call  WriteString         ; display message
	call  WaitMsg             ; wait so user can observe finished safely message
	exit                      ; done
main    endp

; This procedure is vulnerable to a buffer overflow attack due to the fact that
; it calls procedure "copystring" which does not error-check its arguments.
vulnerable proc
	push   ebp
	mov    ebp, esp
	sub    esp, 12           ; create local variable for 12 char string
	mov    esi, [ebp+8]      ; get address of string pointer passed by main
	lea    edi, [esp]        ; get address of destination string (local var)
	push   esi               ; pass address of source string
	push   edi               ; pass address of destination string
	call   copystring        ; call string copy function
	add    esp, 8            ; clean up stack
	mov    eax,0             ; return code is 0
	mov    esp, ebp          ; restore stack pointer, deallocate locals
	pop    ebp               ; restore caller's base pointer
	ret                      ; return (caller to clean up arguments)
vulnerable endp

; This procedure is called with pointers to two strings. It copies the
; source string to the destination string, which seems innocent enough.
; However, like the C strcpy() function, it does not check to see if
; the source string will fit in the destination. This allows a buffer
; overflow attack to be made against the calling procedure.
copystring proc
	push  ebp              ; save caller's base pointer
	mov   ebp, esp         ; set up a new base pointer
	mov   edi, [ebp+8]     ; get pointer to destination string
	mov   esi, [ebp+12]    ; get pointer to source string
l1: mov   al, [esi]        ; get a character from source
	mov   [edi], al        ; copy it to the destination
	inc esi                ; point to next source character
	inc edi                ; point to next destination character
	cmp   al, 0            ; is this the null character?
	jne   l1               ; if not, keep copying until null found
	mov   eax, 0	       ; return 0 to indicate copy complete
	mov   esp, ebp
	pop   ebp			   ; restore caller's base pointer	
	ret				       ; return (caller to clean up args)
copystring endp

; This procedure represents possible malware. It is possible for this code
; to be executed without ever being called by exploiting the buffer overflow
; vulnerability in the code above. The task of the student is to modify
; "badstr" in such a way that this procedure is called and the code below
; is executed, without changing any of the code in main, vulnerable, or
; copystring.
payload   proc               ; procedure that represents code we want to execute
	mov   edx, offset alarm  ; string that indicates successful buffer attack
	call  WriteString        ; output string
	call  WaitMsg            ; wait so user can observe virus warning message
	exit
payload   endp

	end     main