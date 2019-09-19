TITLE Program 2			(Program2.asm)

; Author: Brian Laccone
; Email: lacconeb@oregonstate.edu
; Class Number: CS_271_400_S2017
; Assignment Number: Program 2
; Due Date: 4/23/2017 

INCLUDE Irvine32.inc

UPPERLIMIT EQU <46>

.data
intro1		BYTE	"Program 2 by Brian Laccone",0
prompt1		BYTE	"Please enter your name: ",0
userName		BYTE 33 DUP(0)
greeting		BYTE "Hello, ",0
fibError		BYTE "Out of Range. Enter a number in [1-46]",0
fibInstruct1	BYTE "Enter the number of Fibonacci terms to be displayed",0
fibInstruct2	BYTE "Give the number as an integer in the range [1-46]",0
prompt2		BYTE "Please enter the number of Fibonnaci terms to be displayed (integer between [1-46]): ",0
spaces		BYTE "     ",0
goodbye		BYTE "Goodbye, ",0
userNumber	DWORD	?	;User input int 1
numb1		DWORD	?	;fibonnaci number 1
numb2		DWORD	?	;fibonnaci number 2
rowCheck		DWORD	?	;simple check to tell when to drop to the next row after 5
fibNumb		DWORD	?	;the fibonnaci number we will be displaying



.code
main PROC

;Display program title and programmer's name
	mov		edx, OFFSET intro1
	call	WriteString
	call CrLf
	call CrLf

;Ask user for their name, save it in a variable, and greet the user
	mov		edx, OFFSET prompt1
	call WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call ReadString
	mov		edx, OFFSET greeting
	call WriteString
	mov		edx, OFFSET userName
	call WriteString
	call CrLf
	

;Display Fibonnaci instructions
	mov		edx, OFFSET fibInstruct1
	call WriteString
	call CrLf
	mov		edx, OFFSET fibInstruct2
	call WriteString
	call CrLf
	call CrLf
	jmp		fibInput

inputError: ;Display error if number is out of range
	mov		edx, OFFSET fibError
	call WriteString
	call CrLf

fibInput: ;Ask user to enter the number of Fibonnaci terms to be displayed 
	mov		edx, OFFSET prompt2
	call WriteString
	call ReadInt
	mov		userNumber, eax

;Check if input is above 46
	mov		ebx, UPPERLIMIT
	cmp		eax, ebx
	jg		inputError

;Check if input is below 1
	mov		eax, userNumber
	mov		ebx, 1
	cmp		eax, ebx
	jb		inputError
	
;Calculate Fibonacci sequence using loop
	mov		eax, 1
	mov		numb1, eax
	call WriteDec
	mov		edx, OFFSET spaces
	call WriteString

	mov		eax, 1
	cmp		eax, userNumber
	jz		endFib				;if userNumber equals 1 then end the fibonacci sequence

	mov		eax, 1		 
	mov		numb2, eax
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString

	mov		eax, 2
	cmp		eax, userNumber
	jz		endFib				;if userNumber equals 2 then end the fibonacci sequence

	mov		ecx, userNumber		;set the ecx to the usernumber
	dec		ecx					
	dec		ecx					;decrease ecx by 2 because we did the first two numbers already to get the base two numbers for the fib sequence loop

	mov		eax, 2				
	mov		rowCheck, eax			;set rowCheck to 2 because we already have the first two numbers

fibLoop:
	mov		eax, numb1		
	add		eax, numb2
	mov		fibNumb, eax
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString

	inc		rowCheck
	mov		eax, rowCheck
	mov		ebx, 5
	cmp		eax, ebx				;if rowCheck is at 5 then add a new row
	je		newRow
	jmp		noNewRow

newRow:	;set a new row and reset rowCheck
	call CrLf
	mov		rowCheck, 0			;reset rowCheck back to 0

noNewRow:	 ;set numb2 to numb1 and fibNumb to numb2
	mov		eax, numb2
	mov		numb1, eax			;set numb2 to numb1
	mov		eax, fibNumb
	mov		numb2, eax			;set new fibNumb to numb2
	loop fibLoop


endFib:
	call	CrLf
	call CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf



;Exit
	exit

main ENDP

END main