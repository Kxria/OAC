%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
    global _start:

_start:
    mov eax, b9h
    mov esi, cad
    call printbin
    call salto

    mov eax, 1
    mov ebx, 0
    int 80h

    ; 1111 0000 1111 0000 | 1111 0000 1111 0000
printbin:
    pushad
    mov edx, eax
    mov edi, esi
    mov ecx, 32

    ciclo:
        shl edx, 1
        jnc cero

        mov al, '1'
        jmp guardar

    cero:
        mov al, '0'
    guardar: 
        mov [esi], al
        inc esi
        loop ciclo

    sub esi, 32

    mov edx, edi
    call puts

    popad
    ret

salto:
    pushad
    mov al, 13
    call putchar

    mov al, 10
    call putchar
    popad
    ret

section .bss
    cad resb 32 


; ////////////////////////////////////////////////////////////

; printbin:
;     pushad
;     mov ecx, 32     ; contador de conversiones
;     mov ebx, 2      ; base en la que se va a dividir
;     add esi, 31     ; se recorre al final de la cadena

;     .ciclo:
;         mov edx, 0  ; se limpia el registro para guardar el residuo
;         div ebx     ; se divide ax:dx / ebx y se guarda el residuo en edx

;         add dl, 48      ; se convierte a caracter
;         mov [esi], dl   ; se guarda en la cadena
;         dec esi         ; se retrocede para la siguiente conversion
;         loop ciclo

;     mov ecx, 32     ; contador de impresiones
;     imprimir:       
;         mov al, [esi]     ; se extrae el caracter a imprimir
;         call putchar    ; se imprime
;         inc esi         ; se avanza al siguiente caracter a imprimir
;         loop imprimir
;     popad
;     ret

; ordenar:
;     push ebp
;     mov ebp, esp

;     pushad
;     mov esi, [ebp + 8]  ; -> arreglo
;     mov ecx, [ebp + 12] ; -> len
;     mov dl, [ebp + 16]  ; -> orden
    
;     dec ecx             ; -> len - 1

;     for_externo:
;         push ecx     ; -> guardar iteracion actual
;         mov edi, esi ; -> puntero al arreglo
;         mov ebx, ecx ; -> iterador interno

;         for_interno:
;             mov al, [edi]       ; -> elemento actual
;             mov ah, [edi + 1]   ; -> elemento siguiente
;             cmp dl, 0           ; -> identificar modo (DL = 0 -> menor a mayor)
;             je menor_mayor

;             mayor_menor:        ; orden descendente
;                 cmp al, ah      
;                 jb cambio       ; si AL < AH, intercambia

;                 jmp continuar   ; si no, siguiente iteracion

;             menor_mayor:        ; orden ascendente
;                 cmp al, ah
;                 ja cambio       ; si AL > AH, intercambia

;                 jmp continuar   ; si no, siguiente iteracion

;             cambio:
;                 mov [edi], ah       ; -> AH en AL
;                 mov [edi + 1], al   ; -> AL en AH

;             continuar:
;                 inc edi     ; siguiente elemento
;                 dec ebx     ; decrementar iterador interno
;                 jnz for_interno ; si no es cero, avanza el for interno

;         pop ecx ; de lo contrario, extrae el contador externo de la pila
;         dec ecx ; decrementa en 1 el contador externo
;         jnz for_externo ; si no es cero, avanza el for externo

;     ; si es cero, quiere decir que hemos terminado
;     popad
;     mov esp, ebp    ; actualiza a la nueva direccion a apuntar
;     pop ebp
;     ret


; printbin:
;     pushad
;     mov ecx, 32
;     mov ebx, 2
;     mov esi 31

;     push ecx
;     convertir:
;         mov edx, 0
;         div ebx

;         add dl, 48
;         mov [esi], dl
;         dec esi
;         loop convertir
;     pop ecx

;     imprimir:
;         mov al, [esi]
;         call putchar
;         inc esi
;         loop inmprimir
;     popad
;     ret

; ordenar:
;     push ebp
;     mov ebp, esp
;     pushad

;     mov esi, [ebp + 8]
;     mov ecx, [ebp + 12]
;     mov dl, [ebp + 16]

;     dec ecx
;     for_externo:
;         push ecx
;         mov edi, esi
;         mov ebx, ecx

;         for_interno:
;             mov al, [edi]
;             mov ah, [edi + 1]
            
;             cmp dl, 0
;             je menor_mayor

;             mayor_menor:
;                 cmp al, ah
;                 jb swap

;                 jmp continue

;             menor_mayor:
;                 cmp al, ah
;                 ja swap

;                 jmp continue

;             swap:
;                 mov [edi], ah
;                 mov [edi + 1], al

;             continue:
;                 inc edi
;                 dec ebx
;                 jnz for_interno

;         pop ecx
;         dec ecx
;         jnz for_externo

;     popad
;     mov esp, ebp
;     pop ebp
;     ret


printbin:
    pushad
    mov ecx, 32
    mov ebx, 10
    mov edi, esi

    push ecx
    convertir:
        mov edx, 0
        div ebx

        add dl, 48
        mov[edi], dl
        dec edi
        loop convertir

    pop ecx
    imprimir:
        mov al, [edi]
        call putchar
        loop imprimir
    popad
    ret

; ordenar:
;     push ebp
;     mov ebp, esp

;     pushad

;     mov esi, [ebp + 8]
;     mov ecx, [ebp + 12]
;     mov dl, [ebp + 16]

;     dec ecx

;     for_externo:
;         push ecx
;         mov edi, esi
;         mov ebx, ecx

;         for_interno:
;             mov al, [ebp]
;             mov ah, [ebp + 1]
;             cmp dl, 0

;             je menor_mayor

;             mayor_menor:
;                 cmp al, ah
;                 jb swap

;                 jmp continue
            
;             menor_mayor:
;                 cmp al, ah
;                 ja swap
;                 jmp continue


;             swap:
;                 mov [edi], ah
;                 mov [edi + 1], al
            
;             continue:
;                 inc edi
;                 dec ebx
;                 jnz for_interno

;     pop ecx
;     dec ecx
;     jnz for_externo

;     popad
;     mov esp, ebp
;     pop ebp
;     ret


; ; //////////////////////////////////////////////////////

; ; ------------------------------------------------------
; ; ordenar_bubble(arreglo, len, orden)
; ; arreglo -> [ebp+8]
; ; len     -> [ebp+12]
; ; orden   -> [ebp+16]   (0 = ascendente, 1 = descendente)
; ; ------------------------------------------------------

; ordenar_bubble:
;     push ebp
;     mov ebp, esp
;     pushad

;     mov esi, [ebp+8]        ; ESI -> puntero al arreglo
;     mov ecx, [ebp+12]       ; ECX -> longitud
;     mov dl, [ebp+16]        ; DL  -> orden (0 asc, 1 desc)

;     dec ecx                 ; número de pasadas externas

; for_externo:
;     push ecx                ; guardar contador externo
;     mov edi, esi            ; puntero al inicio del arreglo
;     mov ebx, 0              ; índice interno (empieza en 0)

; for_interno:
;     mov al, [edi]           ; elemento actual
;     mov ah, [edi+1]         ; siguiente elemento

;     cmp dl, 0
;     je menor_mayor          ; si orden = 0, ascendente

; mayor_menor:                ; descendente
;     cmp al, ah
;     jb cambio               ; si AL < AH, intercambiar
;     jmp continuar

; menor_mayor:                ; ascendente
;     cmp al, ah
;     ja cambio               ; si AL > AH, intercambiar
;     jmp continuar

; cambio:
;     mov [edi], ah           ; intercambiar
;     mov [edi+1], al

; continuar:
;     inc edi                 ; avanzar puntero
;     inc ebx                 ; avanzar índice interno
;     cmp ebx, ecx            ; ¿llegamos al límite interno?
;     jl for_interno          ; si EBX < ECX, repetir bucle interno

;     pop ecx                 ; recuperar contador externo
;     dec ecx                 ; decrementar pasadas externas
;     jnz for_externo         ; repetir si no es cero

;     popad
;     mov esp, ebp
;     pop ebp
;     ret
