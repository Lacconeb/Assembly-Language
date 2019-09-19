TITLE Program 3			(Program3.asm)

; Author: Brian Laccone
; Email: lacconeb@oregonstate.edu
; Class Number: CS_271_400_S2017
; Assignment Number: Program 3
; Due Date: 5/7/2017 

INCLUDE Irvine32.inc

LOWERLIMIT EQU <-100>

.data
intro1		BYTE	"Program 2 by Brian Laccone",0
EC1			BYTE "**EC1: Number the lines during using input",0
prompt1		BYTE	"Please enter your name: ",0
userName		BYTE 33 DUP(0)
greeting		BYTE "Hello, ",0
goodbye		BYTE "Goodbye, ",0
instruct1		BYTE "Please enter numbers in [-100, -1]", 0
instruct2		BYTE "Enter a non-negative when you are finished to see results.",0
error1		BYTE "You entered a number below -100",0
prompt2		BYTE ") Enter number: ",0
countMes1		BYTE "You entered ",0
countMes2		BYTE " valid numbers.",0
sumMes		BYTE "The sum of your valid numbers is: ",0
avgMess		BYTE "The rounded average is: ",0
exCount		DWORD	?	;keep count of Extra Credit lines
numCount		DWORD	?	;keep count of how many numbers are entered
inputNum		DWORD	?	;number that the user will input
sumNum		DWORD	?	;sum of all inputted numbers
avgNum		DWORD	?	;average of the sum



.code
main PROC

;Display program title and programmer's name
	mov		edx, OFFSET intro1
	call	WriteString
	call CrLf
	mov		edx, OFFSET EC1
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

;Display Instructions
	mov		edx, OFFSET instruct1
	call WriteString
	call CrLf
	mov		edx, OFFSET instruct2
	call WriteString
	call CrLf


incExCount:		;Set count number to plus 1 for extra credit
	inc		exCount				;Extra Credit #1
	

promptNumbers:		;Prompt input
	mov		eax, exCount
	call WriteDec
	mov		edx, OFFSET prompt2
	call	WriteString
	mov		edx, OFFSET inputNum
	call ReadInt
	mov		inputNum, eax
	call CrLf

;Validate if the users input is a non negativ number
	mov		eax, inputNum
	mov		ebx, -1
	cmp		eax, ebx
	jg		endPrompt
	
;Validate if the users input is in [-100, -1]
	mov		eax, inputNum
	mov		ebx, LOWERLIMIT	
	cmp		eax, ebx
	jb		inputError

	jmp		addSum


inputError:		;Display error and jump to promptNumbers if input is below -100
	mov		edx, OFFSET error1
	call WriteString
	call CrLf
	jmp		promptNumbers


addSum:			;Adds the input number to the sum and increases number count then loops back to ask for more numbers
	mov		eax, sumNum
	add		eax, inputNum
	mov		sumNum, eax
	inc		numCount
	jmp		incExCount


endPrompt:		;Ends the prompt loop and displays the count and the sum
	call CrLf
	mov		edx, OFFSET countMes1
	call WriteString
	mov		eax, numCount
	call WriteInt
	mov		edx, OFFSET countMes2
	call WriteString
	call CrLf
	mov		edx, OFFSET sumMes
	call WriteString
	mov		eax, sumNum
	call WriteInt
	call CrLf

;Calculate average
	sub		edx, edx
	mov		ebx, numCount
	cdq
	idiv	ebx
	mov		avgNum, eax
	

;Round if needed
	shr		ebx,1	;half the divisor
	neg ebx
	cmp		edx, ebx
	jge		displayAverage
	
	dec		avgNum

displayAverage:
	mov		edx, OFFSET avgMess
	call WriteString
	mov		eax, avgNum
	call WriteInt
	call CrLf

goodbyeMessage:
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