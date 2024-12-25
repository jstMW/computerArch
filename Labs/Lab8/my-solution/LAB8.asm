data segment
        promptMsg db 'Input a word: ', 10, '$'
        isPalindromeMsg db 'The word is a palindrome ', 10, '$'
        notPalindromeMsg db 'The word is NOT a palindrome ', 10, '$'
        userInput db 21, 22 dup(?)
data ends


stack1 segment stack
        db 100 dup(?)
stack1 ends


code segment 
        assume cs:code, ds:data, ss:stack1

start:

        mov ax, data
        mov ds, ax

        mov ax, stack1
        mov ss, ax


	lea dx, promptMsg
	mov ah, 9
	int 21h
	
	lea dx, userInput
	mov ah, 10
	int 21h

;regular stuff till here!
	
;read the inputed string and push them to stack
	mov cl, [userInput+1]
	lea bx, userInput+2

push_to_stack:

	push [bx]
	
	inc bx
	dec cl
	jnz push_to_stack


	mov cl, [userInput+1]
	lea bx, userInput+2

;now i try to pop it out to dx and check with
;the bx which is teh beggining
;and as soon as they didn't match
;print the msg verifying that they're not
;palindrome other wise the program will continue
;and print they are in fact palindrome
pop_out_and_check:

	pop dx

	;mov ax, [bx]
	cmp dl, [bx]
;I just realized that comparing dx and ax is wrong
;because the other part of the registers(dh, ah) might be
;different :)

;I was stuck this part for a loooooong time
;I print them they were the same but not equal!!
;I really need to use that debugging tool  :)

	jne not_palindrome

	


	inc bx
	dec cl
	jnz pop_out_and_check

	
	lea dx, isPalindromeMsg
	mov ah, 9
	int 21h

        mov ah, 4Ch
        int 21h



not_palindrome:
	
	lea dx, notPalindromeMsg
	mov ah, 9
	int 21h

        mov ah, 4Ch
        int 21h

	

code ends
end start
