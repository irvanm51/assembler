section .data
    msg db "Hasil perkalian: ", 0
    len equ $-msg

section .bss
    result resb 10 ; Ruang untuk menyimpan hasil dalam bentuk karakter

section .text
    global _start

_start:
    ; Input bilangan pertama
    mov ebx, 2
    
    ; Input bilangan kedua 
    mov ecx, 5

    ; Melakukan perkalian
    imul ebx, ecx ; EBX = EBX * ECX

    ; Simpan hasil perkalian ke dalam result sebagai string
    mov edi, result + 9 ; Start from the end of the buffer
    mov byte [edi], 0 ; Null-terminate the string
    dec edi

    ; Convert the result to ASCII
    mov eax, ebx
    test eax, eax
    jz zero_case ; If result is zero, print it directly

convert_to_ascii:
    xor edx, edx
    mov ecx, 10
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convert_to_ascii

    inc edi
    jmp print_result

zero_case:
    mov byte [edi], '0'
    jmp print_result

print_result:
    ; Menampilkan pesan
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Menampilkan hasil perkalian
    mov eax, 4
    mov ebx, 1
    mov edx, result + 9
    sub edx, edi
    mov ecx, edi
    int 0x80

    ; Keluar dari program
    mov eax, 1
    xor ebx, ebx
    int 0x80
