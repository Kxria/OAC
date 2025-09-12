; se incluye la libreria pc_io
%include "./pc_io.inc"

section .text
	global _start:

_start:
    ; se muestra el mensaje de captura del primer numero
    mov edx, msg
    call puts
    call salto

    ; se captura el primer numero y se guarda
    mov eax, 0 ; puede estar comentado
    call getch
    mov ebx, numero
    mov [ebx], al
    mov esi, cad ; puede estar comentado
    call printHex ; puede estar comentado
    call salto ; puede estar comentado

    ; se convierte a numero
    mov ebx, numero
    sub byte[ebx], '0'

    ; se muestra el mensaje de conversion
    mov edx, msg2 ; puede estar comentado
    call puts ; puede estar comentado
    call salto ; puede estar comentado

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
    mov eax, 0 ; puede estar comentado
    call getch
    mov ebx, numero2
    mov [ebx], al
    mov esi, cad ; puede estar comentado
    call printHex ; puede estar comentado
    call salto ; puede estar comentado

    ; se convierte a numero
    mov ebx, numero2
    sub byte [ebx], '0'

    ; se muestra el mensaje de conversion
    mov edx, msg2 ; puede estar comentado
    call puts ; puede estar comentado
    call salto ; puede estar comentado

    ; se imprime el numero convertido
    mov eax, 0
    mov ebx, numero2
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto
    call salto

; ================================================= SUMA

    ; ; se muestra el mensaje de suma
    ; mov edx, suma
    ; call puts
    ; call salto

    ; ; se hace la suma de ambos digitos (usando el reg. al)
    ; mov ebx, numero
    ; add byte[ebx], al
    ; mov al, [ebx]

    ; ; se imprume la suma
    ; mov eax, 0
    ; mov ebx, numero
    ; mov al, [ebx]
    ; mov esi, cad
    ; call printHex
    ; call salto

; ============================================ CICLO PRUEBA

;     ciclo de prueba
;     mov cx, 5
;     ciclo:
;         mov al, 48
;         call putchar
;     loop ciclo
;     call salto
;     call salto

; ============================================ MULTIPLICACION

    ; se muestra el mensaje de multiplicacion
    mov edx, multi
    call puts
    call salto

    ; se setean los registros para comenzar la multiplicacion
    mov ebx, resultado      ; *EBX = &resultado
    mov byte [ebx], 0       ; *EBX = 0 ==> resultado = 0
    mov ebx, numero2        ; *EBX = &numero2
    mov dl, [ebx]           ; DL = *EBX ==> DL = *numero2

    mov ebx, numero         ; *EBX = &numero
    mov cl, [ebx]           ; se usa el primer numero como contador de iteraciones para la realizacion de la multiplicacion

    ; se genera la multiplicacion
    mult:
        mov ebx, resultado
        add byte[ebx], dl
        
        ; se imprime la suma
        mov ebx, resultado
        mov eax, [ebx]
        mov esi, cad
        call printHex
        call salto
    loop mult
    call salto

    ; se imprime la multiplicacion
    mov eax, 0
    mov ebx, resultado
    mov al, [ebx]
    mov esi, cad
    call printHex
    call salto
    call salto

; =========================================== DIVISION

    ; se muestra el mensaje de division
    mov edx, divi
    call puts
    call salto

    ; se setean los registros para comenzar la division
    mov ebx, numero         ; *EBX = &numero = 3
    mov dl, [ebx]           ; DL = *EBX ==> DL = *numero = 3
    mov cl, 0         ; se usa el primer numero como contador de iteraciones para la realizacion de la division
    mov ebx, resultado      ; resultado 3 x 4 = 12

    ; se genera la division
    div:
        sub byte[ebx], dl
        add cl, 1
        cmp al, 0
        je fin
        jmp div
    fin:
    call salto

    ; se imprime la division
    mov eax, 0
    mov al, cl
    mov esi, cad
    call printHex
    call salto
    call salto


; ====================================== contador del 1 al 100 (64h)
; FALTA HACER QUE IMPRIMA SOLO LOS PARES

; USAR cmp al, 0 ; el 0 debe irse sumando 2 en 2
; USAR DOS SUBRUTINAS. UNA PARA IMPRIMIR Y SUMAR + 2 Y OTRA PARA SOLO SUMAR + 2

    ; se muestra el mensaje del contador
    mov edx, cont
    call puts
    call salto

    mov ebx, contador
    mov byte[ebx], 0

    mov cl, 100
    ciclo:
        mov ebx, contador
        add byte[ebx], 1
        
        ; se imprime la suma
        mov ebx, contador
        mov eax, [ebx]
        mov esi, cad
        call printHex
        call salto
    loop ciclo

; =======================================

    ; SYS_EXIT
	mov eax, 1
	mov ebx, 0
	int 80h

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

    cont: db "Contador del 1 al 100 (de 2 en 2)", 0x0
    len6: equ $-cont

section .bss	;Datos no inicializados
    numero resb 1
    numero2 resb 1
    cad resb 12
    resultado resb 10
    contador resb 10