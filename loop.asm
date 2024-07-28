section .data
    sum db 0          ; To store the sum
    count db 10       ; Counter for the loop
    output db 'Sum: ', 0
    newline db 10     ; Newline character

section .bss
    sum_str resb 4    ; To store the string representation of the sum

section .text
    global _start

_start:
    xor rax, rax                ; Clear rax register (will be our loop index)
    movzx rcx, byte [count]     ; Load the loop count into rcx

loop_start:
    cmp rcx, 0                  ; Check if the counter has reached 0
    je loop_end                 ; If zero, exit the loop

    inc rax                     ; Increment the loop index
    add byte [sum], al          ; Add the index to sum

    dec rcx                     ; Decrement the counter
    jmp loop_start              ; Repeat the loop

loop_end:
    ; Convert sum to ASCII
    movzx rax, byte [sum]       ; Move the sum into rax with zero extension
    call print_number

    ; Print the output message
    mov eax, 1                  ; syscall: write
    mov edi, 1                  ; file descriptor: stdout
    lea rsi, [output]           ; pointer to message
    mov edx, 5                  ; message length
    syscall

    ; Print the sum
    mov eax, 1                  ; syscall: write
    mov edi, 1                  ; file descriptor: stdout
    lea rsi, [sum_str]          ; pointer to sum string
    mov edx, 4                  ; sum string length (max 3 digits + null terminator)
    syscall

    ; Print the newline character
    mov eax, 1                  ; syscall: write
    mov edi, 1                  ; file descriptor: stdout
    lea rsi, [newline]          ; pointer to newline character
    mov edx, 1                  ; length of newline character
    syscall

    ; Exit the program
    mov eax, 60                 ; syscall: exit
    xor edi, edi                ; status: 0
    syscall

print_number:
    ; Converts the number in rax to a string in sum_str
    ; RAX should contain a number less than 100 for simplicity
    xor rcx, rcx                ; Clear RCX
    mov ecx, 10                 ; Base 10

    mov bl, al                  ; Move the number to BL
    xor rsi, rsi                ; Clear RSI

    ; Convert each digit to ASCII
convert_loop:
    xor rdx, rdx                ; Clear RDX
    div rcx                     ; Divide RAX by 10
    add dl, '0'                 ; Convert remainder to ASCII
    mov [sum_str + rsi], dl
    inc rsi
    test rax, rax               ; Check if RAX is zero
    jnz convert_loop            ; Repeat if not

    ; Reverse the string
    dec rsi
    xor rdi, rdi
reverse_loop:
    cmp rsi, rdi                ; Check if rsi is at the start
    jle reverse_done            ; Exit if less or equal to 0
    mov dl, [sum_str + rdi]
    mov al, [sum_str + rsi]
    mov [sum_str + rdi], al
    mov [sum_str + rsi], dl
    inc rdi
    dec rsi
    jmp reverse_loop

reverse_done:
    ret
