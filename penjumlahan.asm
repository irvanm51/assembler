section .data
    msg_add db "Hasil penambahan: ", 0
    len_add equ $-msg_add

section .bss
    result_add resb 10 ; Ruang untuk menyimpan hasil dalam bentuk karakter

section .text
    global _start

_start:
    ; Input bilangan pertama 
    mov eax, 7
    
    ; Input bilangan kedua 
    mov ebx, 2

    ; Melakukan penambahan
    add eax, ebx ; EAX = EAX + EBX

    ; Simpan hasil penambahan ke dalam result_add sebagai string
    mov edi, result_add + 9 ; Start from the end of the buffer
    mov byte [edi], 0 ; Null-terminate the string
    dec edi

    ; Convert the result to ASCII
    test eax, eax
    jz zero_case_add ; If result is zero, print it directly

convert_to_ascii_add:
    xor edx, edx
    mov ecx, 10
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convert_to_ascii_add

    inc edi
    jmp print_result_add

zero_case_add:
    mov byte [edi], '0'
    jmp print_result_add

print_result_add:
    ; Menampilkan pesan
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_add
    mov edx, len_add
    int 0x80

    ; Menampilkan hasil penambahan
    mov eax, 4
    mov ebx, 1
    mov edx, result_add + 9
    sub edx, edi
    mov ecx, edi
    int 0x80

    ; Keluar dari program
    mov eax, 1
    xor ebx, ebx
    int 0x80
