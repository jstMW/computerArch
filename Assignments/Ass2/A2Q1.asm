data segment
	userInput db 21, 22 dup(?)
data ends

stack1 segment stack
        db 100 dup(?)
stack1 ends

code segment
        assume cs:code, ds:data, ss:stack1
start:

;to be honest I didn't quit understand the question 1, it should be command line right?
;anyway I thought the other possibility is too easy so I guess you mean give the input in command line like
;"program.exe custom input" but because of "don’t forget about the carriage return"
;in the question 1 description, I will add the snipped code of the other possibility which is just runt the
;program and then add the input it that case the data segment will be the same 
;and here is the code

;instead of psp ds should point at data segment
;mov ax, data
;mov ds, ax
;lea dx, userInput
;mov ah, 10
;int 21h

;so here the command line argument is stored at psp(program segment prefix) from "https://stanislavs.org/helppc/program_segment_prefix.html"
;the length will be at offset(80h) and the actual chars started at offset(81h)
;there is no need to check whether there is an input or it is more than the 20 chars as mentioned
;previously I had struggle to finish this because I was following the commented code
;after this it was just like the normal load the loop counter with length and iterate over the actual bits, copy the value!
;I'm not sure that the very first char which is a space should be included or not but because
;it is stored I didn't escape that
;well I found a bug :) if i add more than 20 chars,like 30 or so, it won't stop!
;it write it in userInput! I thought it should at least crash
;because I reserved only 22 bytes! that is weird!!

        mov ax, stack1
        mov ss, ax


        mov bx, 80h
        mov cl, [bx]
        lea bx, [bx+1]

;I use this push and pop a lot to switch where ds is pointing to
	push ds

	mov ax, data
	mov ds, ax

	lea di, userInput+2

	;copying the actual length
	mov [userInput+1], cl
	
	pop ds

print_loop:
 

;so we just read a char from the command line 
        mov dl, [bx]

;for copying it we need the ds points to data again!
	push ds
	mov ax, data
	mov ds, ax

;copy the valeu
	mov [di], dl

;turn back the ds
;I don't think this is efficient or how its done but
;that's the way I could do it :(
	pop ds

	inc di
        inc bx
        dec cl
        jnz print_loop
 
	













;jsut to confirm it is actually  copied the command line vale!
;
;	mov ax, data
;	mov ds, ax
;	mov cl, [userInput+1]
;	lea bx, [userInput+2]
;l:
;
;	mov dl, [bx]
;	mov ah, 2
;	int 21h
;	inc bx
;	dec cl
;	jnz l
	

        mov ah, 4Ch
        int 21h


code ends
end start
