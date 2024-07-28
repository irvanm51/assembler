section .data
    msg_sub db "Hasil pengurangan: ", 0
    len_sub equ $-msg_sub

section .bss
    result_sub resb 10 ; Ruang untuk menyimpan hasil dalam bentuk karakter

section .text
    global _start

_start:
    ; Input bilangan pertama 
    mov eax, 15
    
    ; Input bilangan kedua 
    mov ebx, 3

    ; Melakukan pengurangan
    sub eax, ebx ; EAX = EAX - EBX

    ; Simpan hasil pengurangan ke dalam result_sub sebagai string
    mov edi, result_sub + 9 ; Start from the end of the buffer
    mov byte [edi], 0 ; Null-terminate the string
    dec edi

    ; Convert the result to ASCII
    test eax, eax
    jz zero_case_sub ; If result is zero, print it directly

convert_to_ascii_sub:
    xor edx, edx
    mov ecx, 10
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convert_to_ascii_sub

    inc edi
    jmp print_result_sub

zero_case_sub:
    mov byte [edi], '0'
    jmp print_result_sub

print_result_sub:
    ; Menampilkan pesan
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_sub
    mov edx, len_sub
    int 0x80

    ; Menampilkan hasil pengurangan
    mov eax, 4
    mov ebx, 1
    mov edx, result_sub + 9
    sub edx, edi
    mov ecx, edi
    int 0x80

    ; Keluar dari program
    mov eax, 1
    xor ebx, ebx
    int 0x80
