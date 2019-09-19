TITLE Program 1			(Program1.asm)

; Author: Brian Laccone
; Email: lacconeb@oregonstate.edu
; Class Number: CS_271_400_S2017
; Assignment Number: Program 1
; Due Date: 4/16/2017 

INCLUDE Irvine32.inc

.data
intro		BYTE	"Program 1 by Brian Laccone",0
EC1			BYTE "**EC1: Program repeats until the user chooses to quit",0
EC2			BYTE "**EC2: Program verifies that the second number is less or equal to the first",0
description	BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder",0
prompt1		BYTE	"Please enter the first number: ",0
prompt2		BYTE	"Please enter another number that is less than the first number: ",0
prompt3		BYTE "Press 1 to try again. Press any other integer to exit: ",0
sumMessage	BYTE	"Sum: ",0
diffMessage	BYTE	"Difference: ",0
prodMessage	BYTE	"Product: ",0
quotMessage	BYTE	"Quotient: ",0
remMessage	BYTE	"Remainder: ",0
goodbye		BYTE	"Thank You for Playing! Goodbye",0
number1		DWORD	?	;User input int 1
number2		DWORD	?	;User input int 2
sum			DWORD	?	;sum result
difference	DWORD	?	;diff result
product		DWORD	?	;prod result
quotient		DWORD	?	;qout resutl
remainder		DWORD	?	;rem result
exitInt		DWORD	?	;int to check if Label1 should be called again


.code
main PROC

;Introduction
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf	
	mov		edx, OFFSET EC1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET EC2
	call	WriteString
	call	CrLf

;Instructions
	mov		edx, OFFSET description
	call	WriteString
	call	CrLf
	

Label1:

;Get user input for both numbers
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		number1, eax
	call	CrLf
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		number2, eax
	call	CrLf

	cmp		eax, number1		
	jge		Label1				;EXTRA CREDIT - If the second int that the user inputs is greater than or equal to the first one then it will ask for the numbers again

;Calc sum
	mov		eax, number1
	add		eax, number2 
	mov		sum, eax

;Display sum
	mov		edx, OFFSET sumMessage	
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

;Calc difference
	mov		eax, number1
	mov		ebx, number2
	sub		eax, ebx
	mov		difference, eax

;Display difference
	mov		edx, OFFSET	diffMessage
	call	WriteString
	mov		eax, difference
	call	WriteInt
	call	CrLf

;Calc product
	mov		eax, number1 
	mov		ebx, number2
	mul		ebx
	mov		product, eax

;Display product
	mov		edx, OFFSET prodMessage
	call	WriteString
	mov		eax, product
	call	WriteInt
	call	CrLf

;Calc quotient and remainder	
	sub		edx, edx
	mov		eax, number1
	mov		ebx, number2
	div		ebx
	mov		quotient, eax
	mov		remainder, edx
	
;Display quotient
	mov		edx, OFFSET quotMessage
	call	WriteString
	mov		eax, quotient
	call	WriteInt
	call	CrLf

;Display remainder
	mov		edx, OFFSET remMessage
	call	WriteString
	mov		eax, remainder
	call	WriteInt
	call	CrLf
	call	CrLf

;Check if user wants to try again or exit
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	mov		exitInt, 1

	cmp		eax, exitInt
	je		Label1				;EXTRA CREDIT - If the user inputs a 1 then the program will jump back to Label1

;Display goodbye message
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

;Exit
	exit

main ENDP

END main