TITLE Program 5			(Program5.asm)

; Author: Brian Laccone
; Email: lacconeb@oregonstate.edu
; Class Number: CS_271_400_S2017
; Assignment Number: Program 5
; Due Date: 5/28/2017 

INCLUDE Irvine32.inc


MINNUM = 10
MAXNUM = 200
MINRANDOMNUM = 100
MAXRANDOMNUM = 999

.data

intro1		BYTE	"Sorted Random Integers		Program 5 by Brian Laccone",0
EC1			BYTE "**EC #2: Use a recursive sorting algorithm**",0
intro2		BYTE	"This program generates random numbers in the range [100 .. 999],",0
intro3		BYTE	"displays the original list, sorts the list, and calculates the",0
intro4		BYTE	"median value. Finally, it displays the list sorted in descending order.",0
prompt		BYTE "How many numbers should be generated? [10 .. 200]: ",0
error		BYTE "Invalid Input",0
arrayUnsort	BYTE "The unsorted random numbers: ",0
spaces		BYTE "  ",0
medianSTR		BYTE "The median is: ",0
arraysort		BYTE "The sorted list: ",0
goodbye		BYTE "Results Verified by Brian Laccone, GoodBye!",0
userInput		DWORD	?
array		DWORD	MAXNUM DUP(0)


.code
main PROC

	call		Randomize		;call library function

	call		introduction

	push		OFFSET userInput 
	call		getData

	;Fill the arrray with random numbers within the range
	push		userInput 
	push		OFFSET array
	call		fillArray

	;Display the unsorted random number message before displaying the array
	mov		edx, OFFSET arrayUnsort
	call		WriteString
	call		CrLf

	;Display the current state of the array. In this case it is unsorted
	push		userInput
	push		OFFSET array
	call		displayList

	;Sort array
	push		OFFSET array 
	push		0
	mov		eax, userInput
	dec		eax
	push		eax 
	call		sortList

	;Display the median message before displaying the median value
	mov		edx, OFFSET medianSTR
	call		WriteString

	;Calculate and display the median value
	push		userInput
	push		OFFSET array
	call		displayMedian

	;Display the sorted list message before displaying the array
	mov		edx, OFFSET arraySort
	call		WriteString
	call		CrLf

	;Display the current state of the array. In this case it is sorted
	push		userInput
	push		OFFSET array
	call		displayList

	;Display a goodbye message
	call		farewell


;Exit
	exit

main ENDP

introduction PROC		;displays intro then returns

	mov		edx, OFFSET intro1
	call		WriteString
	call		CrLf

	mov		edx, OFFSET EC1
	call		WriteString
	call		CrLf
	call		CrLf
	
	mov		edx, OFFSET intro2
	call		WriteString
	call		CrLf

	mov		edx, OFFSET intro3
	call		WriteString
	call		CrLf

	mov		edx, OFFSET intro4
	call		WriteString
	call		CrLf
	call		CrLf

	ret

introduction ENDP

getData PROC USES eax edx ebp

	mov		ebp, esp

	input:	;Prompt the user and receive input
		mov		edx, OFFSET prompt
		call		WriteString
		call		Readint

		cmp		eax, MAXNUM
		jle		checkLessThan
		jg		rangeError

	checkLessThan:
		cmp		eax, MINNUM
		jl		rangeError
		jmp		finished

	rangeError:						;if userInput is not within range display an error and jmp to input again
		mov		edx, OFFSET error
		call		WriteString
		call		CrLf
		jmp		input

	finished:							;set userInput and return
		mov		ebx, [ebp+16] 
		mov		[ebx], eax    
		call		CrLf
      
	ret 4


getData ENDP

fillArray PROC USES esi ecx eax ebp

	mov		ebp, esp
	mov		esi, [ebp+20] 
	mov		ecx, [ebp+24]			; Use as counter

	mov		eax, MAXRANDOMNUM
	sub		eax, MINRANDOMNUM
	inc		eax

	fillLoop:
		call		RandomRange
		add		eax, MINRANDOMNUM
		mov		[esi], eax
		add		esi, SIZEOF DWORD
		loop		fillLoop

	ret 8

fillArray ENDP

displayList PROC USES ebx ecx esi ebp

	mov		ebp, esp
	mov		esi, [ebp + 20]
	mov		ecx, [ebp + 24]
	mov		ebx, 0

	print:
		mov		eax, [esi]
		call		WriteDec
		
		;display spaces after each number
		mov		edx, OFFSET spaces
		call		WriteString

		add		esi, SIZEOF DWORD

		inc		ebx

		;compares to see if a new line needs to be created after 10 numbers
		cmp		ebx, 10
		jl		nextNum

		;add a new line if the jmp doesn't happen
		call		CrLf
		mov		ebx, 0

	nextNum:
		loop		print


	call		CrLf
	call		CrLf

	ret 8

displayList ENDP

sortList PROC USES eax ebx ecx esi ebp
  
	mov		ebp, esp
	sub		esp, 4        
	mov		esi, [ebp+32] 

	mov		eax, [ebp+28]
	cmp		eax, [ebp+24]
	jl		sort   
	jmp		sortEnd
    
	sort:
		lea		esi, [ebp-4]
		push		esi         
		push		[ebp+32]    
		push		[ebp+28]    
		push		[ebp+24]    
		call		sortHelper   
        
		push		[ebp+32]		
		push		[ebp+28]		
		mov		eax, [ebp-4]
		dec		eax
		push		eax         
		call		sortList
        
		push		[ebp+32]    
		mov		eax, [ebp-4]
		inc		eax
		push		eax         
		push		[ebp+24]    
		call		sortList
        
	sortEnd:
		mov		esp, ebp

	ret 12

sortList ENDP


sortHelper PROC USES eax ebx ecx esi ebp
    
	mov		ebp, esp
	sub		esp, 8        
	mov		esi, [ebp+32] 
    
	mov		eax, [ebp+28]
	mov		ebx, SIZEOF DWORD
	mul		ebx
	mov		eax, [esi+eax]
	mov		[ebp-4], eax
    
	mov		eax, [ebp+28]
	mov		[ebp-8], eax
	inc		eax
	mov		ecx, eax  
    
	sortCheckLoop:
		cmp		ecx, [ebp+24] 
		jg		endLoop
        
		mov		eax, ecx       
		mov		ebx, SIZEOF DWORD
		mul		ebx
		mov		eax, [esi+eax]       
		cmp		eax, [ebp-4]   
		jl		next         
        
		;set up and exchange elements
		push		[ebp+32]    
		mov		eax, [ebp-8]
		inc		eax
		push		eax         
		push		ecx         
		call		exchangeElements

		push		[ebp+32]    
		push		[ebp-8]     
		mov		eax, [ebp-8]
		inc		eax
		push		eax   
		call		exchangeElements

		mov		eax, [ebp-8]
		inc		eax
		mov		[ebp-8], eax

		next:
		inc		ecx     
		jmp		sortCheckLoop
        
        
	endLoop:
		mov		eax, [ebp+36]
		mov		ebx, [ebp-8]
		mov		[eax], ebx
		mov		esp, ebp

    ret 12

sortHelper ENDP

exchangeElements PROC USES eax ebx ecx esi ebp 
	
	;Exchange spots in the array

    mov     ebp, esp
    sub     esp, 4        
    mov     esi, [ebp+32] 

    mov     eax, [ebp+28]      
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ebx, [esi+eax]
    mov     DWORD PTR [ebp-4], ebx
    
    mov     eax, [ebp+24]   
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ecx, [esi+eax]
    mov     eax, [ebp+28]   
    mul     ebx
    mov     [esi+eax], ecx
    
    mov     eax, [ebp+24]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ecx, [ebp-4]
    mov     [esi+eax], ecx
    
    mov     esp, ebp
    ret 12
exchangeElements ENDP

displayMedian PROC

	pushad		;save registers
    
	mov		ebp, esp
	mov		esi, [ebp+36] 
	mov		ecx, [ebp+40] 

	cdq

	;determine if the sum is even or odd
	mov		eax, ecx
	mov		ecx, 2
	div		ecx
	mov		ecx, eax 
    
	cmp		edx, 0 
	jz		evenNum
	jmp		oddNum
    
	evenNum:
		mov		ebx, SIZEOF DWORD
		mul		ebx
		mov		ebx, [esi+eax]  
    
		mov		eax, ecx
		dec		eax
		mov		ecx, SIZEOF DWORD
		mul		ecx
		mov		ecx, [esi+eax] 
    
		cdq

		mov		eax, ebx
		add		eax, ecx
		mov		ebx, 2
		div		ebx
    
		jmp		finishMedian
    
	oddNum:
		mov		ebx, SIZEOF DWORD
		mul		ebx
		mov		ebx, [esi+eax]
		mov		eax, ebx
    
	finishMedian:
		call		WriteDec
		call		CrLf
		call		CrLf
    

	popad		;load registers back

	ret 8
	

displayMedian ENDP


farewell PROC

	call		CrLf

	mov		edx, OFFSET goodbye		;display a simple goodbye message
	call		WriteString

	call		CrLf
	call		CrLf

	ret

farewell ENDP

END main