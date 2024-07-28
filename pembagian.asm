section .data
    msg db "Hasil pembagian: ", 0
    len equ $-msg

section .bss
    result resb 10 ; Ruang untuk menyimpan hasil dalam bentuk karakter

section .text
    global _start

_start:
    ; Input bilangan pertama 
    mov eax, 6
    
    ; Input bilangan kedua 
    mov ebx, 2

    ; Melakukan pembagian
    xor edx, edx   
    div ebx        

    ; Simpan hasil pembagian ke dalam result sebagai string
    mov edi, result + 9 
    mov byte [edi], 0 
    dec edi

    ; Convert the result to ASCII
    test eax, eax
    jz zero_case 

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

    ; Menampilkan hasil pembagian
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
