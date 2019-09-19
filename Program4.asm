TITLE Program 4			(Program4.asm)

; Author: Brian Laccone
; Email: lacconeb@oregonstate.edu
; Class Number: CS_271_400_S2017
; Assignment Number: Program 4
; Due Date: 5/14/2017 

INCLUDE Irvine32.inc

LOWERLIMIT EQU <1>
UPPERLIMIT EQU <400>

.data
intro		BYTE	"Composite Numbers		Program 4 by Brian Laccone",0
description1	BYTE	"Enter the number of composite numbers you would like to see.",0
description2	BYTE	"I'll accept orders for up to 400 composites.",0
prompt		BYTE	"Enter the number of composites to display [1 ... 400]: ",0
error1		BYTE "Out of range. Tray again.",0
goodbyeMess	BYTE	"Results certified by Brian Laccone. Goodbye.",0
spaces		BYTE	"     ",0
userInput		DWORD	?	;user input
currNum		DWORD	?	;keep track of current number for composite
success		DWORD	?	;boolean to keep track of successful composites
linebreak		DWORD	?	;keep track of column breaks when displaying composites



.code
main PROC

	call introduction		;call introduction procedure

	call getUserData		;get user input and validate

	call showComposites		;displays all the composites

	call farewell			;display goodbye message


;Exit
	exit

main ENDP

introduction PROC		;displays intro then returns

	mov		edx, OFFSET intro
	call		WriteString
	call		CrLf
	call		CrLf

	ret

introduction ENDP

getUserData PROC

	;Display all the descriptions for the user to see
		mov		edx, OFFSET description1
		call		WriteString
		call		CrLf
		mov		edx, OFFSET description2
		call		WriteString
		call		CrLf
		call		CrLf

	input:		;Prompt the user and receive input
		mov		edx, OFFSET prompt
		call		WriteString
		call		Readint

		mov		ecx, 0				;using ecx to determine if the validation is successful
	
		call		validateUserData		;validate if the user input is in the correct range

		cmp		ecx, 1				;if the validation is successful then exit this procedure
		je		finished				

	rangeError:						;if userInput is not within range display an error and jmp to input again
		mov		edx, OFFSET error1
		call		WriteString
		call		CrLf
		jmp		input

	finished:							;set userInput and return
		mov		userInput, eax
		call		CrLf
		ret


getUserData ENDP

validateUserData Proc

		
		
	;check if input is above 400
		cmp		eax, UPPERLIMIT
		jg		exitValidate

	;check if input is below 1
		cmp		eax, LOWERLIMIT
		jl		exitValidate

	;if input is in the [1...400] range then exit validation and ret
		mov		ecx, 1
		

	exitValidate:
		ret



validateUserData ENDP

showComposites PROC

	mov		ecx, 0
	mov		eax, 4
	mov		currNum, eax			;set currNum to 4 because that is the first composite number

	display:
		call		isComposite		

		cmp		success, 1
		je		incComposite		;if isComposite id successful then jmp to display it

		jmp		incCurrNum		;else go to the next number and try again
		
	
	incComposite:

		mov		eax, currNum		;display the number that is composite
		call		WriteDec

		mov		edx, OFFSET spaces	;space out the numbers
		call		WriteString
		
		inc		lineBreak			
		
		inc		ecx

		cmp		ecx, userInput		;if the amount of composites that the user has specified are displayed, return
		jge		endComposites

		cmp		lineBreak, 10		;if linebreak count is at 10 then call CrLf and reset line break
		je		breakLine

		jmp		incCurrNum		

	breakLine:					;call CrLf and reset lineBreak
		call		CrLf
		mov		eax, 0
		mov		lineBreak, eax

	incCurrNum:					;inc currNum to test the next number
		inc		currNum
		jmp		display

	endComposites:
		ret

showComposites ENDP

isComposite PROC
	
	mov		ebx,2
	mov		eax, 0
	mov		success, eax

	compCheck:
		mov		edx,0
		mov		eax, currNum
		div		ebx
		
	;if division doesn't have a remainder than we found a composite
		cmp		edx,0
		je		compSuccess

		inc		ebx

	;if none of the numbers are successful then return without setting success to 1
		cmp		ebx, currNum
		jge		endIsComposite

		jmp		compCheck

	compSuccess:					;if a composite is found set the success variable and return
		mov		ebx, 1
		mov		success, ebx

	endIsComposite:
		ret

isComposite ENDP

farewell PROC

	call		CrLf
	call		CrLf
	
	mov		edx, OFFSET goodbyeMess		;display a simple goodbye message
	call		WriteString

	call		CrLf

	ret

farewell ENDP

END main