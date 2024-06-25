org 100h

jmp start       

msg:    db      "1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide", 0Dh,0Ah, "5-Decimal to Binary", 0dh,0ah, "6-Logical AND", 0Dh, 0Ah, "7-Logical OR", 0Dh, 0Ah, "8-Logical XOR", 0Dh, 0Ah, "0-Exit", 0Dh,0Ah, '$'
msg2:    db      0dh,0ah,"Enter First No: $"
msg3:    db      0dh,0ah,"Enter Second No: $"
msg4:    db      0dh,0ah,"Choice Error $" 
msg5:    db      0dh,0ah,"Result : $" 
msg6:    db      0dh,0ah ,'thank you for using the simple calculator! press any key to exit... ', 0Dh,0Ah, '$'
msg7:    db      0dh,0ah,"Enter the decimal number: $" 
msg8:    db      0dh,0ah,"Binary Number is: $"
 
start:  mov ah,9
        mov dx, offset msg  
        int 21h
        mov ah,0                       
        int 16h   
        cmp al,31h  
        je Addition
        cmp al,32h
        je Multiply
        cmp al,33h
        je Subtract
        cmp al,34h
        je Divide
        cmp al,35h
        je DecimalToBinary
        cmp al,36h
        je LogicalAND
        cmp al,37h
        je LogicalOR
        cmp al,38h
        je LogicalXOR
        cmp al,30h
        je Exit
        mov ah,09h
        mov dx, offset msg4
        int 21h
        mov ah,0
        int 16h
        jmp start
        
Addition:   mov ah,9  ;then let us handle the case of addition operation
            mov dx, offset msg2  ;first we will display this message enter first no also using int 21h
            int 21h
            mov cx,0 ;we will call InputNo to handle our input as we will take each number seprately
            call InputNo  ;first we will move to cx 0 because we will increment on it later in InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            add dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 
            
InputNo:    mov ah,0
            int 16h ;then we will use int 16h to read a key press     
            mov dx,0  
            mov bx,1 
            cmp al,0dh ;the keypress will be stored in al so, we will comapre to  0d which represent the enter key, to know wheter he finished entering the number or not 
            je FormNo ;if it's the enter key then this mean we already have our number stored in the stack, so we will return it back using FormNo
            sub al,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ascii to decimal
            call ViewNo ;then call ViewNo to view the key we pressed on the screen
            mov ah,0 ;we will mov 0 to ah before we push ax to the stack bec we only need the value in al
            push ax  ;push the contents of ax to the stack
            inc cx   ;we will add 1 to cx as this represent the counter for the number of digit
            jmp InputNo ;then we will jump back to input number to either take another number or press enter          
   

;we took each number separatly so we need to form our number and store in one bit for example if our number 235
FormNo:     pop ax; Take the last input from the stack  
            push dx      
            mul bx;Here we are multiplying the value of ax with the value of bx
            pop dx;After multiplication we will remove it from stack
            add dx,ax;After removing from stack add the value of dx with the value of ax
            mov ax,bx;Then set the value of bx in ax       
            mov bx,10
            push dx;push the dx value again in stack before multiplying to resist any kind of accidental effect
            mul bx;Multiply bx value by 10
            pop dx;pop the dx after multiplying
            mov bx,ax;Result of the multiplication is still stored in ax so we need to move it in bx
            dec cx;After moving the value we will decrement the digit counter value
            cmp cx,0;Check if the cx counter is 0
            jne FormNo;If the cx counter is not 0 that means we have multiple digit input and we need to run format number function again
            ret;If the cx counter is 0 that means all of our digits are fully formatted and stored in bx we just need to return the function   

View:  mov ax,dx
       mov dx,0
       div cx 
       call ViewNo
       mov bx,dx 
       mov dx,0
       mov ax,cx 
       mov cx,10
       div cx
       mov dx,bx 
       mov cx,ax
       cmp ax,0
       jne View
       ret
ViewNo:    push ax ;we will push ax and dx to the stack because we will change there values while viewing then we will pop them back from
           push dx ;the stack we will do these so, we don't affect their contents
           mov dx,ax ;we will mov the value to dx as interrupt 21h expect that the output is stored in it
           add dl,30h ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h
           pop dx  
           pop ax
           ret
     exit:   mov dx,offset msg6
        mov ah, 9
        int 21h  
       mov ah, 0
        int 16h

        ret
                       
Multiply:   mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,dx
            mul bx 
            mov dx,ax
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 


Subtract:   mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            sub bx,dx
            mov dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 
    
            
Divide:     mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            mov bx,0
            div cx
            mov bx,dx
            mov dx,ax
            push bx 
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View
            pop bx
            cmp bx,0
            je exit 
            jmp exit  
DecimalToBinary:
               mov ax,@data
             mov ds,ax             
             mov ah,09h
             lea dx,msg7
             int 21h             
             mov ah,01h
             int 21h               
             sub al,48  
             mov ah,0                 
             mov bx,2
             mov dx,0  
             mov cx,0
          again:   
             div bx  
             push dx
             inc cx
             cmp ax,0
             jne again  
             mov ah,09h
             lea dx,msg8
             int 21h
          disp:   
             pop dx
             add dx,48
             mov ah,02h
             int 21h 
             loop disp     
             mov ah,4ch
             int 21h
             
        
            
LogicalAND:
            mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            and dx, bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 

LogicalOR:
            mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            or dx, bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 
            
LogicalXOR:
            mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            xor dx, bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit 


        jmp exit


    mov ah, 0
    int 16h ; Read character from keyboard
    cmp al, 0Dh ; Check if Enter key pressed
    je EndInput ; If Enter key pressed, jump to EndInput
    sub al, '0' ; Convert character to numeric value
    mov ah, 0
    int 10h ; Display character
    mov bx, 10
    mul bx ; Multiply current value by 10
    add dx, ax ; Add new value to existing value
    mov ax, dx ; Move new value to AX for next iteration
    mov dx, 0 ; Clear DX for next iteration
    jmp InputNo ; Repeat until Enter key pressed
EndInput:
    ret
  mov bx, 10 ; Divisor for decimal conversion
    mov cx, 0 ; Counter for number of digits
    mov ah, 0 ; Clear AH for division
ViewLoop:
    mov dx, 0 ; Clear DX for division
    div bx ; Divide DX:AX by 10
    add dl, '0' ; Convert remainder to ASCII
    push dx ; Push remainder onto stack
    inc cx ; Increment digit count
    test ax, ax ; Check if quotient is zero
    jnz ViewLoop ; If not zero, repeat loop
ViewPrint:
    pop dx ; Pop remainder from stack
    mov ah, 02h ; BIOS function to display character
    int 21h ; Call interrupt
    loop ViewPrint ; Repeat for all digits
    ret
