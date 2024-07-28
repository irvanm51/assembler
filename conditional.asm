section .data
    num1 db 1             
    num2 db 5              
    msg_gt db 'num1 lebih besar dari num2', 0 ; Pesan jika num1 > num2
    len_gt equ $-msg_gt
    msg_le db 'num1 lebih kecil atau sama dengan num2', 0 ; Pesan jika num1 <= num2
    len_le equ $-msg_le
    newline db 0xA, 0     

section .bss 

section .text
    global _start          

_start:
    mov al, [num1]         
    mov bl, [num2]         
    cmp al, bl             
    jg greater_than        

    ; Jika num1 <= num2
    mov eax, 4             
    mov ebx, 1            
    mov ecx, msg_le        
    mov edx, len_le        
    int 0x80               
    jmp end_program        

greater_than:
    ; Jika num1 > num2
    mov eax, 4             
    mov ebx, 1             
    mov ecx, msg_gt        
    mov edx, len_gt        
    int 0x80               

end_program:
    ; Tampilkan newline
    mov eax, 4             
    mov ebx, 1             
    mov ecx, newline       
    mov edx, 1             
    int 0x80               

    ; Keluar dari program
    mov eax, 1             
    xor ebx, ebx           
    int 0x80               
