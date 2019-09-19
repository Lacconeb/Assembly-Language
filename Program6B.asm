TITLE Program 6B			(Program6B.asm)

; Author: Brian Laccone
; Email: lacconeb@oregonstate.edu
; Class Number: CS_271_400_S2017
; Assignment Number: Program 6B
; Due Date: 6/8/2017 

INCLUDE Irvine32.inc

HIGHEST = 12
NLOW = 3
RLOW = 1


.data
intro1		BYTE "Welcome to the Combinations Calculator",0
intro2		BYTE "Implemented by Brian Laccone",0
desc1		BYTE "I'll give you a combinations problem. You enter your answer,",0
desc2		BYTE "and I'll let you know if you're right.",0
dir1			BYTE	"Problem:", 0
dir2			BYTE	"Number of elements in the set: ", 0
dir3			BYTE	"Number of elements to choose from the set: ", 0
dir4			BYTE	"How many ways can you choose? ", 0
string		BYTE 33 DUP(0)
error1		BYTE "Invalid Response",0
error2		BYTE "Input is not a number",0
resMes1		BYTE "There are ",0
resMes2		BYTE " combinations of ",0
resMes3		BYTE " items from a set of ",0
correct		BYTE "You are correct!",0
incorrect		BYTE "You were wrong.",0
tryAgainMes	BYTE "Another problem (y/n)?",0
userResponse	BYTE 10 DUP(0)
no			BYTE "n, N",0
yes			BYTE "y, Y",0
goodbyeMes	BYTE "Thanks for playing, GoodBye!",0

nVal			DWORD	?
rVal			DWORD	?
userInput		DWORD	?
totalNum		DWORD	?


display_string		MACRO buffer
	push		edx
	mov		edx, OFFSET buffer
	call		WriteString
	pop		edx
ENDM

.code
main PROC

	call	Randomize

	pushad

	call	introduction			;displays the introduction messages

nextProb:		;used to ask another probelm if the user chooses too

	;generate the random numbers and displays the problem
	push		OFFSET nVal
	push		OFFSET rVal
	call		showProblem

	;prompt and get the user's answer to the probelm
	push		OFFSET userInput
	call		getData

	;start calculating the answer
	push		nVal
	push		rVal
	push		OFFSET totalNum
	call		combinations

	;displays the results and wether the user's answer was right or wrong
	push		nVal
	push		rVal
	push		userInput
	push		totalNum
	call		showResults
	
	;asks if the user wants to try another problem or exit the program
	call		tryAgain

	;if the user inputs yes then jump to nextProb
	mov		esi, OFFSET userResponse
	mov		edi, OFFSET yes
	cmpsb
	je		nextProb

	;if the user wants to exit, display a goodbye message
	call		CrLf
	display_string		goodbyeMes
	call		CrLf
	

	popad
;Exit
	exit

main ENDP

introduction PROC

	display_string		intro1
	call		CrLf

	display_string		intro2
	call		CrLf
	call		CrLf
	
	display_string		desc1
	call		CrLf

	display_string		desc2
	call		CrLf
	call		CrLf

	ret	8

introduction ENDP

showProblem PROC

	push		ebp
	mov		ebp, esp
	pushad

	mov		eax, HIGHEST			
	sub		eax, NLOW	
	inc		eax

	call		RandomRange
	
	add		eax, NLOW
	mov		ebx, [ebp+12]	
	mov		[ebx], eax

	mov		eax, [ebx]
	sub		eax, RLOW
	inc		eax
	
	call		RandomRange

	add		eax, RLOW
	mov		ebx, [ebp+8]	
	mov		[ebx], eax

	call		CrLf
	display_string		dir1
	call		CrLf

	display_string		dir2
	mov		ebx, [ebp+12]
	mov		eax, [ebx]
	call		WriteDec
	call		CrLf
	
	display_string		dir3
	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	call		WriteDec
	call		CrLf

	popad
	pop		ebp

	ret		8

showProblem ENDP

getData PROC
	
	push		ebp
	mov		ebp, esp
	pushad

getInput:
	mov		eax, 0
	mov		ebx, [ebp+8]
	mov		[ebx], eax

	display_string		dir4
	mov		edx, OFFSET string
	mov		ecx, 32
	call		ReadString
	mov		ecx, eax
	mov		esi, OFFSET string

nextVal:
	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		ebx, 10
	mul		ebx
	
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	mov		al, [esi]
	cmp		al, 48
	jl		invalid

	cmp		al, 57
	jg		invalid

	inc		esi
	sub		al, 48
		
	mov		ebx, [ebp+8]
	add		[ebx], al

	loop		nextVal
	jmp		quit

invalid:
	display_string		error2
	call		CrLf
	jmp		getInput

quit:
	popad
	pop		ebp
	ret		4

getData ENDP

combinations PROC

	push		ebp
	mov		ebp, esp
	push		eax
	push		ebx
	push		edx
	sub		esp, 16

	push		[ebp+16]
	push		[ebp+8]
	call		calc

	mov		ebx, [ebp+8]				
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-4], eax

	push		[ebp+12]
	push		[ebp+8]
	call		calc

	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-8], eax

	mov		eax, [ebp+16]
	mov		ebx, [ebp+12]
	sub		eax, ebx
	cmp		eax, 0
	je		resultIsOne
	mov		DWORD PTR [ebp-12], eax

	push		[ebp-12]
	push		[ebp+8]
	call		calc

	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-16], eax

	mov		eax, [ebp-8]
	mov		ebx, [ebp-16]
	mul		ebx

	mov		edx, 0
	mov		ebx, eax
	mov		eax, [ebp-4]
	div		ebx

	mov		ebx, [ebp+8]
	mov		[ebx], eax
	jmp		quitCom

resultIsOne:

	mov		eax, 1
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	mov		eax, [ebx]

quitCom:

	pop		edx
	pop		ebx
	pop		eax
	mov		esp, ebp
	pop		ebp

	ret		12

combinations ENDP

calc PROC

	push		ebp
	mov		ebp, esp
	pushad	

	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	cmp		eax, 0
	ja		repeatcalc
	mov		esi, [ebp+8]
	mov		eax, 1
	mov		[esi], eax
	jmp		quitCalc

repeatcalc:

	dec		eax
	push		eax
	push		ebx
	call		calc
	mov		esi, [ebp+8]
	mov		ebx, [esi]
	mov		eax, [ebp+12]	
	mul		ebx
	mov		[esi], eax
	
quitCalc:		
	popad
	pop		ebp				
	ret		8

calc ENDP

showResults PROC

	push	ebp
	mov		ebp, esp
	pushad
	
	call		CrLf
	display_string		resMes1
	mov		eax, [ebp+8]
	call		WriteDec

	display_string		resMes2
	mov		eax, [ebp+16]
	call		WriteDec

	display_string		resMes3
	mov		eax, [ebp+20]
	call		WriteDec
	call		CrLF
	
	mov		eax, [ebp+12]
	cmp		eax, [ebp+8]
	je		correctAns


	display_string		incorrect
	call		CrLf
	call		CrLf
	jmp		quitShowRes

correctAns:

	display_string		correct
	call	CrLf
	call	CrLf

quitShowRes:	

	popad
	pop		ebp

	ret		16

showResults ENDP

tryAgain PROC
	
	pushad

askUser:

	display_string		tryAgainMes
	mov		edx, OFFSET userResponse
	mov		ecx, 9
	call	ReadString

	mov		esi, OFFSET userResponse
	mov		edi, OFFSET yes
	cmpsb
	je		quitTryAgain

	mov		esi, OFFSET userResponse
	mov		edi, OFFSET no
	cmpsb
	je		quitTryAgain

	display_string		error1
	call		CrLf
	jmp		askUser	

quitTryAgain:
	popad
	ret

tryAgain ENDP

END main