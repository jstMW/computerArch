data segment
        promptMsg db 'Enter a string (max 20 char.)', 10,'$'
        echoMsg db 'The string you entered is: ', 10, '$'
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

        ;show the prompt
        lea dx, promptMsg
        mov ah, 9
        int 21h

        ;get the userInput and write it on memory
        lea dx, userInput
        mov ah, 10
        int 21h        

  
        ;show echo message
        lea dx, echoMsg
        mov ah, 9
        int 21h

        ;set up the loop to go over each char of userInput
        mov cl, [userInput+1]; to set up the counter for loop using the real inputed length!
        lea si, userInput+2  ;to get the very first char        

print_loop:

        mov dl, [si]
        mov ah, 2
        int 21h

        inc si
        dec cl

        jnz print_loop

        ;termination!
        mov ah, 4Ch
        int 21h
code ends 
end start
