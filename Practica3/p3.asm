%include "./pc_io.inc"  ; se incluye la libreria
section .text
	global _start:

_start:
    ; se muestra el mensaje de captura del primer numero
    mov edx, msg
    call puts
    call salto

    ; se captura el primer numero y se guarda
    mov eax, 0          ; puede estar comentado
    call getch
    mov ebx, numero
    mov [ebx], al
    mov esi, cad        ; puede estar comentado
    call printHex       ; puede estar comentado
    call salto          ; puede estar comentado

    ; se convierte a numero
    mov ebx, numero
    sub byte[ebx], '0'

    ; se muestra el mensaje de conversion
    mov edx, msg2       ; puede estar comentado
    call puts           ; puede estar comentado
    call salto          ; puede estar comentado

    ; se imprime el numero convertido
    mov eax, 0
    mov ebx, numero
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto
    call salto

    ; se muestra el mensaje de captura n2
    mov edx, msg
    call puts
    call salto

    ; se captura el segundo numero y se guarda
    mov eax, 0          ; puede estar comentado
    call getch
    mov ebx, numero2
    mov [ebx], al
    mov esi, cad        ; puede estar comentado
    call printHex       ; puede estar comentado
    call salto          ; puede estar comentado

    ; se convierte a numero
    mov ebx, numero2
    sub byte [ebx], '0'

    ; se muestra el mensaje de conversion
    mov edx, msg2       ; puede estar comentado
    call puts           ; puede estar comentado
    call salto          ; puede estar comentado

    ; se imprime el numero convertido
    mov eax, 0
    mov ebx, numero2
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto
    call salto

; ================================================= SUMA

    ; se muestra el mensaje de suma
    mov edx, suma
    call puts
    call salto

    ; se hace la suma de ambos digitos (usando el reg. al)
    mov ebx, numero
    add byte[ebx], al
    mov al, [ebx]

    ; se imprume la suma
    mov eax, 0
    mov ebx, numero
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto

    ; SYS_EXIT
    mov eax, 1
    mov ebx, 0
    int 80h

; ========================================

salto:
    pushad
    mov al, 13
    call putchar

    mov al, 10
    call putchar
    popad
    ret

printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
.nxt: shr eax,cl
.msk: and eax,ebx
    cmp al, 9
    jbe .menor
    add al,7
.menor:add al,'0'
    mov byte [esi],al
    inc esi
    mov eax, edx
    cmp cl, 0
    je .print
    sub cl, 4
    cmp cl, 0
    ja .nxt
    je .msk
.print: mov eax, 4
    mov ebx, 1
    sub esi, 8
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret

section .data
    msg: db "Ingresa un numero (0-9)", 0x0
    len: equ $-msg

    msg2: db "Numero convertido: ", 0x0
    len2: equ $-msg2

    suma: db "Suma", 0x0
    len3: equ $-suma

    multi: db "Multiplicacion", 0x0
    len4: equ $-multi

    divi: db "Division", 0x0
    len5: equ $-divi

    cont: db "Contador del 1 al 100", 0x0
    len6: equ $-cont

    cont2: db "Contador del 1 al 100 (de 2 en 2)", 0x0
    len7: equ $-cont2

section .bss
    numero resb 1
    numero2 resb 1
    cad resb 12
    resultado resb 10
    contador resb 10