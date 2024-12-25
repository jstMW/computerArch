data segment
        promptMsg db 'Enter a string: ', 10, '$'
        reversedMsg db 'The reversed string is: ', 10, '$'
        bufferStr db 16, 17 dup(?)
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
        mov ah, 09
        int 21h


        lea dx, bufferStr
        mov ah, 0Ah
        int 21h

      
        lea dx, reversedMsg
        mov ah, 9
        int 21h



        mov cl, [bufferStr+1]
        lea si, bufferStr+2
        add si, cx

        dec si
         
        
simpleLoop:
        mov dl, [si] 
        mov ah, 2
        int 21h

        dec si
        dec cl
       
        jnz simpleLoop

        
        mov ah, 4Ch
        int 21h

code ends
end start
