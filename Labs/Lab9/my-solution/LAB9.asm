data segment
	inputXMsg db 'Input X: ', '$'
	inputYMsg db 'Input Y: ', '$'
	answerMsg db 'The answer is: ', '$'
	x db 1
	y db 1
	ten db 0Ah
data ends

stack1 segment stack
	db 100 dup(?)
stack1 ends

code segment
	assume cs:code, ds:data, ss:stack1
start:

;setting up the ds
	mov ax, data
	mov ds, ax
;setting up the ss
	mov ax, stack1
	mov ss, ax
	
;get x
	lea bx, x
	lea dx, InputXMsg
	call get_input 


;get y
	lea bx, y
	lea dx, InputYMsg
	call get_input 



	mov al, x
	mov bl, y
	mov cl, al
	call calculate 
;I wasn't able to put this in recursive :(
	add al, bl

;printing the result
	mov ah, 0
	call print_int

	mov ah, 4Ch
	int 21h


get_input proc
;first get the user input then
;convert to number and save it
;I use bx to save at both x and y

;prompt the user
	mov ah, 9
	int 21h

;get the value
	mov ah, 1
	int 21h

;convert to digit and save it
	sub al, 30h
	mov [bx], al

;print a linefeed
	mov dl, 10
	mov ah, 2
	int 21h

	ret

get_input endp

calculate proc
;inputs(x-->al, number_of_addition--->cl)
;end result--> al *modified in place


;	dec cl		;dec cl to add to x, we do it first since it is equal to x right now!
;	jz calcDone	;if it gets 0 no need to add and we are done so all the stack should return
;this was my previous code and i realize if x=0 then it will return 128!
;I guess since it will overflow(decrementing cl=0) and start adding 127 then 126 till 
;it hit 0 but at that point ((255*(255+1)/2)%128) is equal to 128 so the bits of al
;will be 1000 0000 = 128D. when printing we clear ah by mov ah, 0. so it will print 128
;when inputs are both 0.

;my first solution was this just changing the order adn I thought I should work just fine
;and it give 0 when both inputs are 0 but in any other numbers it gives x if y is 0
;and return y if y is not zero no matter waht is x!!  I don't know why :(
	;jz calcDone
	;dec cl

;but then I realize I can just change the condition from equal to 0 to less or equal to 0 :)
	dec cl
	cmp cl, 0
	jle calcDone
	add al, cl	;if not zero we add the cl and then call for next addition
	call calculate

;the only problem is no matter how I try I can't add y here!!
;all the recursive call add y at the end any way

calcDone:
	ret

calculate endp
	
print_int proc
;print final msg

	lea dx,answerMsg 
	mov ah, 9
	int 21h

	mov dx, '$'
	push dx

extract_digit:

	mov ah, 0
	div ten 
	mov dl, ah
	push dx
	cmp al, 0
	jne extract_digit

	mov ah, 2
print_digit:
	
	pop dx

	cmp dl, '$'
	je pDone

	add dl, 30h
	int 21h
	jmp print_digit

pDone:
	ret


print_int endp


code ends
end start 
