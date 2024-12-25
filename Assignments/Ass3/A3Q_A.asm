data segment							
	iNum db  225					

	promptMsg db 'Enter a 16-bit binary number: ', '$'
	userInput db 17, 18 dup(?)
	answerMsg db 'The decimal unsigned integer equivalent is ', '$'
;can You believe I struggle with this part!!!! I should have said dw instead of db :|
	ten dw 10		
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




	call prompt_user
	call convert_ascci_to_binary
	call print_decimal_number

	mov ah, 4ch 					
	int 21h							

	
prompt_user proc
;simple prompting the user, did it before

	lea dx, promptMsg
	mov ah, 9
	int 21h

	lea dx, userInput
	mov ah, 10
	int 21h
	
	mov dl, 10
	mov ah, 2
	int 21h

	ret
prompt_user endp

convert_ascci_to_binary proc
;write each char in a bit of bx register

	lea si, userInput+2
	mov cl, [userInput+1]
	mov bx, 0
	
l:

;shifting allows us to add padding automatically since the bx is already set to 0
	shl bx, 1

	mov al, [si]
	cmp al, '0'
	je zero
	
;here we know there would be only 1 or 0 so if it is not zero it is one
;one:
	add bx, 1

zero:
;if the value is one we also need to do the sift
;in that way there is no need to add padding of zeros!

;things for continueing the loop!
	inc si
	dec cl
	jnz l	
		
	ret
convert_ascci_to_binary endp


print_decimal_number proc
;now bx contain the binary number!
;for 16 bit division we set ax to bx
;and do the same algorithm of dividing and push remainder
;continue till you get 0 at quotient
	mov dx, '$'
	push dx
	

	mov ax, bx
division:
	mov dx, 0
	div ten

	push dx

	
	cmp ax, 0
	jne division 
	
	
;print the answer message
	lea dx, answerMsg
	mov ah, 9
	int 21h

	mov ah, 2
print:
	pop dx	

	cmp dx, '$'
	je done

	add dl, 30h
	int 21h

	jmp print
	
	
done:
;print the last char ','
	mov dl, '.'
	mov ah, 2
	int 21h

	ret
print_decimal_number endp


code ends
end start
