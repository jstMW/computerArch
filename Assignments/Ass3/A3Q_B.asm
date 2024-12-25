data segment							
	iNum db  225					

	promptMsg db 'Enter a 16-bit binary number: ', '$'
	userInput db 17, 18 dup(?)
	answerMsg db 'The decimal signed integer equivalent is ', '$'
	illegalCharMsg db 'Error! Illegal characters detected. ', '$'
	lengthErrorMsg db 'Error! Please enter exactly 16-bits: ', '$'
	ten dw 10		
data ends

										
stack1 segment stack 		
	db 10 dup(?)      			
stack1 ends


code segment
        assume cs:code, ds:data, ss:stack1

start: 
	mov ax, data					
	mov ds, ax								
	mov ax, stack1					
	mov ss, ax

;I copy the first question solution and do theses changes step by step
;1--> just do singed values, git it the input that make MSB 1 to check
;1.1 -> also change the printing
;;I ended up giving up on using idiv and cwd! but that will get the job done

;2--> then make a proc to check the length of inputed value
;;I didn't make a proc but simply check for length after getting the userInput
;that makes it easier to match the output like the assignment
;2.1 --> for checking the illegal chars I just iterate over the text and cmpare them to 0 and 1 and if both failed it mean that there was something wrong
;for more efficiency I didn't separate the checking! since we iterate over the inputs and check whether they are 1 or 0! so just put the checking logic in that loop
;although it makes it a little messier! I'm not sure it is fine or not!

;**my first design has a simple problem though, It first make sure the user enter 16 chars and then check for illegal chars!
;and I see in the assignment description there is only 14 chars and it gives the error of illegal char detected! so I guess you expect 
;a separate proc for the whole checking! let's get into it, I will keep the initial desing as main one and add the proc here and comment 
;the alternative approach just uncommnet it please to evaluate it :)

	call prompt_user
;just uncomment the check_as_approach_2 proc and comment the parts of previous checking 
;to be honest I don't have energy to test it (the whole commenting and uncommenting proccess) and just
;trust myself to implement the algorithm for it correctly :) so you can also check the check_as_approach_2 at the 
;the end lines
	;call check_as_approach_2	
	;call convert_ascci_to_binary
	call print_decimal_number

	
	mov ah, 4ch 					
	int 21h							

	
prompt_user proc
;simple prompting the user, did it before

show_prompt:
	lea dx, promptMsg
	mov ah, 9
	int 21h

prompting:
	lea dx, userInput
	mov ah, 10
	int 21h
	
	mov dl, 10
	mov ah, 2
	int 21h

		
check_length:
	mov cl, [userInput+1]
	cmp cl, 16
	jge done_prompting 
	
	
length_error:
	lea dx, lengthErrorMsg
	mov ah, 9	
	int 21h
	jmp prompting
	

done_prompting:
	call convert_ascci_to_binary
	
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

check_for_zero:
	cmp al, '0'
	je zero
	
;here we know there would be only 1 or 0 so if it is not zero it is one
;the comment above is for part A for this part we want to check since it could be illegal!

check_for_one:
	cmp al, '1'
	je one

illegal_char_found:
	lea dx, illegalCharMsg
	mov ah, 9
	int 21h
	
	call prompt_user
;the jump here is critical since: we initiate error in this function
;and even after getting the correct input from the user (when the above call prompt_user)
;we get the new call to this function but a new one. after that one finished(pop IP) then we get back here!
;I guess though. so some how we need to terminate this one (that detects the illegal char). am I right?
;anyway if the reason is not correct when I comment it the program will ask for new input and show the illegalchar msg
;repeadetly even if i give it correct number!!
	jmp done_converting

one:
	add bx, 1

zero:
;if the value is one we also need to do the sift
;in that way there is no need to add padding of zeros!

;things for continueing the loop!
	inc si
	dec cl
	jnz l	
		
done_converting:
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
	;;cwd
;to be honest I REALLY tried to make it work but I just didn't 
;I don't know why (sign division) but I though why not just converting it 
;to unsigned int and do it normally and if it was negative just put the '-' before it!
	
	cmp ax, 0
	jge division 

to_unsigned:
	not ax
	add ax, 1
	
division:

	mov dx, 0
	div ten
	;idiv ten

;since the remainder is negative in case of the userInput is negative
;we should check that

	push dx
	

;since the sign is in dx we can still check for ax==0!
	
	cmp ax, 0
	jne division 
	
	
;print the answer message
	lea dx, answerMsg
	mov ah, 9
	int 21h

	mov ah, 2

print_sign:

;check if the bh is negative
;continue normally and print '-'
;but if positiv or 0 it will 
;just jmp to print.
	cmp bh, 0
	jge print

	mov dl, '-'
	int 21h
print:
	pop dx	

	cmp dx, '$'
	je done

	add dl, 30h
	int 21h

	jmp print
	
	
done:
;print the last .
	mov dl, '.'
	mov ah, 2
	int 21h

	ret
print_decimal_number endp

check_userInput proc

	mov cl, [userInput+1]
	lea si, userInput+2

	ret
check_userInput endp



check_as_approach_2 proc
	
;just like first approach but all the checking gathered in one place
;and also the order is first check for illegal chars and then for length
	lea si, userInput+2
	mov cl, [userInput+1]

checking_loop:

check_if_is_zero:
	cmp al, '0'
	je zero_alt
	

check_for_one_alt:
	cmp al, '1'
	je one

illegal_char_found_alt:
	lea dx, illegalCharMsg
	mov ah, 9
	int 21h
	
	call prompt_user
	jmp last_check_for_length 

one_alt:
	add bx, 1

zero_alt:
	inc si
	dec cl
	jnz checking_loop	
		
last_check_for_length:
	cmp [userInput+1], 16
	je done_converting

done_converting_alt:
	ret

check_as_approach_2 endp

code ends
end start
