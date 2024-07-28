section .data
    msg_initial db "Nilai awal adalah 10", 0xA, 0
    len_initial equ $-msg_initial
    msg_push db "Push 20", 0xA, 0
    len_push equ $-msg_push
    msg_pop db "Pop value: ", 0
    len_pop equ $-msg_pop
    msg_eax db "Nilai akhir : ", 0
    len_eax equ $-msg_eax
    newline db 0xA, 0

section .bss
    stack resb 100         ; Alokasi memori untuk stack
    top resb 1             ; Indeks elemen teratas stack
    result resb 10         ; Buffer untuk menyimpan hasil pop dalam bentuk string

section .text
    global _start

_start:
    ; Inisialisasi top ke 0
    mov byte [top], 0

    ; Push nilai 10 ke stack
    mov eax, 10
    call push
    ; Tampilkan pesan nilai awal
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_initial
    mov edx, len_initial
    int 0x80

    ; Push nilai 20 ke stack
    mov eax, 20
    call push
    ; Tampilkan pesan push 20
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_push
    mov edx, len_push
    int 0x80

    ; Pop nilai dari stack dan simpan di EAX
    call pop
    ; Tampilkan nilai yang dipop
    call print_pop

    ; Tampilkan nilai akhir dari EAX
    call print_eax

    ; Keluar dari program
    mov eax, 1
    xor ebx, ebx
    int 0x80

push:
    ; Input: EAX berisi nilai yang akan di-push
    ; Output: Tidak ada
    mov esi, [top]
    mov [stack + esi], al
    inc esi
    mov [top], esi
    ret

pop:
    ; Output: EAX berisi nilai yang di-pop
    mov esi, [top]
    dec esi
    mov [top], esi
    mov al, [stack + esi]
    movzx eax, al
    ret

print_pop:
    ; Tampilkan pesan pop
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_pop
    mov edx, len_pop
    int 0x80

    ; Konversi nilai ke ASCII dan tampilkan
    mov eax, ebx
    call int_to_ascii
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80

    ; Tampilkan newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

print_eax:
    ; Tampilkan pesan nilai akhir EAX
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_eax
    mov edx, len_eax
    int 0x80

    ; Konversi nilai EAX ke ASCII dan tampilkan
    mov eax, [stack + 1] ; Pastikan kita mengambil nilai yang benar
    call int_to_ascii
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80

    ; Tampilkan newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

int_to_ascii:
    ; Konversi bilangan dalam EAX ke string ASCII di buffer 'result'
    mov edi, result + 9 ; Start from the end of the buffer
    mov byte [edi], 0 ; Null-terminate the string
    dec edi

    test eax, eax
    jz int_zero_case ; If result is zero, print it directly

int_convert_to_ascii:
    xor edx, edx
    mov ecx, 10
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz int_convert_to_ascii

    inc edi
    ret

int_zero_case:
    mov byte [edi], '0'
    ret
