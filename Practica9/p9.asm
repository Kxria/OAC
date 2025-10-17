%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
	global _start:

_start:
    ; imprime el prompt del numero original
    mov edx, num_prompt
    call newputs
    call salto

    ; imprime el numero binario
    mov edx, num
    call newputs
    call salto
    call salto

    ; se hacen las rotaciones
    mov edx, num
    mov cl, 2
    call rotacion

    mov edx, rot_prompt
    call newputs
    call salto

    ; se imprime el numero rotado
    mov edx, num
    call newputs
    call salto

    mov eax, 1
    mov ebx, 0
    int 80h

; ===================================================================
rotacion: ; CL = N. CORRIMIENTOS, AH = CF, AL = -bit
    pushad
        mov ah, 1
        SAHF

        ; PASO 1 EXTRAER EL CARRY
        LAHF            ; se extrae EFLAGS en AH
        and ah, 1       ; se extrae CF
        add ah, '0'     ; se convierte a caracter
    
        loop_rotar:
        cmp cl, 0       ; se compara CL con 0 para ver si se acabaron las rotaciones
        je fin

        ; PASO 2; EXTRAER EL BIT MAS SIGNIFICATIVO
        mov al, [edx]   ; se guarda el bit menos significativo en AL
        sub al, '0'     ; se convierte a numero

        ; PASO 3: CORRIMIENTOS
        ; indices para corrimientos
        mov edi, 1
        mov esi, 0
        loop_corrimiento:
            cmp edi, 8          ; se compara EDI para verificar el fin de corrimientos
            je fin_corrimiento

            ; se realizan los desplazamientos
            mov bl, [edx + edi]
            mov [edx + esi], bl

            ; se decrementan los indices
            inc edi
            inc esi
            jmp loop_corrimiento
        fin_corrimiento:

        ; PASO 4; GUARDAR EL CF EN -BIT
        mov [edx + 7], ah  ; se reemplaza el bit menos significativo con CF
        
        mov ah, al      ; se manda el bit mas significativo a AH
        SAHF            ; se manda a EFLAGS

        LAHF            ; se extrae EFLAGS en AH
        and ah, 1       ; se extrae CF
        add ah, '0'     ; se convierte a caracter

        dec cl          ; se decrementa el corrimiento
        jmp loop_rotar
    fin:
    popad
    ret

newputs:
    pushad
    prnt:
        mov al, [edx + esi]     ; se manda a al el caracter incial
        cmp al, '%'             ; se compara al con % 
        je finputs              ; si es verdadero, se sale del ciclo

        call putchar            ; se imprime al caracter actual
        inc esi                 ; se incrementa el indice
        jmp prnt                ; se reincia el cilo de impresion
    finputs:
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
section .data
    num_prompt: db "Numero original%"
    rot_prompt: db "Numero rotado con RCL%"
    terminar: db "FIN DEL PROGRAMA%"
    num: db "00000000%"

section .bss
