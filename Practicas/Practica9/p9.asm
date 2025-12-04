%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
	global _start:

_start:
    ; se imprime el prompt RCL
    mov edx, rcl_prompt
    call newputs
    call salto

    ; imprime el numero binario
    mov edx, num
    call newputs
    call salto

    ; se hacen las rotaciones
    mov edx, num
    mov cl, 1
    call rotacionCarryLeft


    ; se imprime el numero rotado con RCL
    mov edx, num
    call newputs
    call salto

; ========================================================================

    ; NUMERO ROTADO CON RCR
    mov edx, rcr_prompt
    call newputs
    call salto

    mov edx, num2
    call newputs
    call salto

    ; se hacen las rotaciones RCR
    mov cl, 1
    call rotacionCarryRight

    ; se imprime el numero rotado
    mov edx, num2
    call newputs
    call salto

; =======================================================================

    ; se imprime el prompt de SHR
    mov edx, shr_prompt
    call newputs
    call salto

    mov edx, num3
    call newputs
    call salto

    mov cl, 1
    call corrimientoRight

    ; se imprime el numero rotado
    mov edx, num3
    call newputs
    call salto

; ========================================================================
    ; se imprime el prompt SHL
    mov edx, shl_prompt
    call newputs
    call salto

    mov edx, num4
    call newputs
    call salto
    mov cl, 1
    call corrimientoLeft

    ; se imprime el numero rotado
    mov edx, num4
    call newputs
    call salto

; ========================================================================
    ; ROL
    mov edx, rol_prompt
    call newputs
    call salto

    mov edx, num5
    call newputs
    call salto
    mov cl, 1
    call rotacionLeft

    ; se imprime el numero rotado
    mov edx, num5
    call newputs
    call salto

; =======================================================================

    ; se imprime la rotacion ROR
    mov edx, ror_prompt
    call newputs
    call salto

    mov edx, num6
    call newputs
    call salto
    mov cl, 1
    call rotacionRight

    ; se imprime el numero rotado
    mov edx, num6
    call newputs
    call salto

    ; sys_exit
    mov eax, 1
    mov ebx, 0
    int 80h

; =========================================== RCL ============================================

rotacionCarryLeft: ; CL = N. CORRIMIENTOS, AH = CF, AL = -bit
    pushad
        mov ah, 1 ; FUERZO LA ENTRADA DE 1 EN EL CF
        SAHF

        ; PASO 1 EXTRAER EL CARRY
        LAHF            ; se extrae EFLAGS en AH
        and ah, 1       ; se extrae CF
        add ah, '0'     ; se convierte a caracter
    
        loop_RCL:
        cmp cl, 0       ; se compara CL con 0 para ver si se acabaron las rotaciones
        je fin_RCL

        ; PASO 2; EXTRAER EL BIT MAS SIGNIFICATIVO
        mov al, [edx]   ; se guarda el bit menos significativo en AL
        sub al, '0'     ; se convierte a numero

        ; PASO 3: CORRIMIENTOS
        ; indices para corrimientos
        mov edi, 1
        mov esi, 0  
        loop_CR:
            cmp edi, 8          ; se compara EDI para verificar el fin de corrimientos
            je fin_CL

            ; se realizan los desplazamientos
            mov bl, [edx + edi]
            mov [edx + esi], bl

            ; se decrementan los indices
            inc edi
            inc esi
            jmp loop_CR
        fin_CL:

        ; PASO 4; GUARDAR EL CF EN -BIT
        mov [edx + 7], ah  ; se reemplaza el bit menos significativo con CF
        
        mov ah, al      ; se manda el bit mas significativo a AH
        SAHF            ; se manda a EFLAGS

        LAHF            ; se extrae EFLAGS en AH
        and ah, 1       ; se extrae CF
        add ah, '0'     ; se convierte a caracter

        dec cl          ; se decrementa el corrimiento
        jmp loop_RCL  ; se reinicia el ciclo
    fin_RCL:
    popad
    ret

; ========================================= ROL ==============================================

rotacionLeft: ; CL = número de rotaciones
    pushad
    loop_rol:
        cmp cl, 0
        je fin_rol

        ; Extraer bit más significativo
        mov ah, [edx]
        sub ah, '0'     ; convertir a número

        ; Corrimiento hacia la izquierda
        mov edi, 0
        mov esi, 1
        loop_corrimientoROL:
            cmp edi, 7
            je fin_corrimientoROL

            mov al, [edx + esi]
            mov [edx + edi], al

            inc edi
            inc esi
            jmp loop_corrimientoROL
        
        fin_corrimientoROL:
        ; Insertar el bit extraído en el menos significativo
        add ah, '0'     ; convertir a carácter
        mov [edx + 7], ah

        dec cl          ; se decrementa el contador de las r
        jmp loop_rol
    fin_rol:
    popad
    ret

; ========================================= ROR ==============================================

rotacionRight: ; CL = número de rotaciones
    pushad
    loop_ror:
        cmp cl, 0
        je fin_ror

        ; Extraer bit menos significativo
        mov ah, [edx + 7]
        sub ah, '0'     ; convertir a número

        ; Corrimiento hacia la derecha
        mov edi, 7
        mov esi, 6
        loop_corrimientoROR:
            cmp edi, 0
            je fin_corrimientoROR

            mov al, [edx + esi]
            mov [edx + edi], al

            dec edi
            dec esi
            jmp loop_corrimientoROR
        
        fin_corrimientoROR:
        ; Insertar el bit extraído en el más significativo
        add ah, '0'     ; convertir a carácter
        mov [edx], ah

        dec cl
        jmp loop_ror
    fin_ror:
    popad
    ret

; ========================================= RCR ==============================================

rotacionCarryRight: ; CL = N. CORRIMIENTOS, AH = CF, AL = -bit
    pushad
        mov ah, 1 ; FUERZO LA ENTRADA DE 0 EN EL CF
        SAHF

        ; PASO 1 EXTRAER EL CARRY
        LAHF            ; se extrae EFLAGS en AH
        and ah, 1       ; se extrae CF
        add ah, '0'     ; se convierte a caracter
    
        loop_rotar:
        cmp cl, 0       ; se compara CL con 0 para ver si se acabaron las rotaciones
        je fin

        ; PASO 2; EXTRAER EL BIT menos SIGNIFICATIVO
        mov al, [edx + 7]   ; se guarda el bit menos significativo en AL
        sub al, '0'     ; se convierte a numero

        ; PASO 3: CORRIMIENTOS
        ; indices para corrimientos
        mov edi, 7
        mov esi, 6  
        loop_corrimiento:
            cmp edi, 0          ; se compara EDI para verificar el fin de corrimientos
            je fin_corrimiento

            ; se realizan los desplazamientos
            mov bl, [edx + esi]
            mov [edx + edi], bl

            ; se decrementan los indices
            dec edi
            dec esi
            jmp loop_corrimiento
        fin_corrimiento:

        ; PASO 4; GUARDAR EL CF EN +BIT
        mov [edx], ah  ; se reemplaza el bit mas significativo con CF
        
        mov ah, al      ; se manda el bit mas significativo a AH
        SAHF            ; se manda a EFLAGS

        LAHF            ; se extrae EFLAGS en AH
        and ah, 1       ; se extrae CF
        add ah, '0'     ; se convierte a caracter

        dec cl          ; se decrementa el corrimiento
        jmp loop_rotar  ; se reinicia el ciclo
    fin:
    popad
    ret


; ========================================= SHR ==============================================

corrimientoRight:
    pushad
    loop_corrimientoRight:
        mov edi, 7      ; apuntador al final de la cadena antes del '%'
        mov esi, 6      ; apuntador al antepenultimo caracter de la cadena antes del "%"
        
        cmp cl, 0       ; se compara CL con 0 para verificar si se terminaron los corrimientos
        je fin_corrimientoRight          ; si es verdadero, se sale de la rutina

        mov ah, [edx + edi]     ; se almacena el -bit de la cadena
        sub ah, '0'             ; se convierte a su valor numerico
        SAHF                    ; se manda ese bit al CF

        loop2_corrimientoRight:
            cmp edi, 0          ; se compara EDI para verificar el fin del corrimiento
            je fin_loop2corrimientoRight        ; si es verdadero, se sale del ciclo de corrimientos

            mov ah, [edx + esi] ; se almacena en AH el caracter anterior al que apunta EDI
            mov [edx + edi], ah ; se reemplaza el caracter apuntado por EDI con el anterior a este

            ; se decrementan los indices para seguir con el siguiente par a recorrer
            dec esi
            dec edi
            jmp loop2_corrimientoRight

        ; una vez terminados los corrimientos
        fin_loop2corrimientoRight:
            mov byte [edx], '0'     ; se ingresa un 0 en el bit mas significativo
            dec cl                  ; se decrementa CL para indicar que se realizo un corrimiento
            jmp loop_corrimientoRight
    fin_corrimientoRight:
    popad
    ret

; ========================================= SHL ==============================================

corrimientoLeft:
    pushad
    loop_corrimientoLeft:
        mov edi, 0      ; apuntador al inicio de la cadena
        mov esi, 1      ; apuntador al siguiente caracter

        cmp cl, 0
        je fin_corrimientoLeft

        ; Extraer el bit más significativo
        mov ah, [edx + edi]
        sub ah, '0'
        SAHF            ; se manda ese bit al CF

        loop2_corrimientoLeft:
            cmp edi, 7
            je fin_loop2corrimientoLeft

            mov ah, [edx + esi]     ; se copia el siguiente bit
            mov [edx + edi], ah     ; se lo asigna al actual

            inc esi
            inc edi
            jmp loop2_corrimientoLeft

        fin_loop2corrimientoLeft:
            mov byte [edx + 7], '0' ; se inserta 0 en el bit menos significativo
            dec cl
            jmp loop_corrimientoLeft

    fin_corrimientoLeft:
    popad
    ret

; ======================================== FUNCIONES =========================================

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
    
    rol_prompt: db "Numero rotado con ROL%"
    ror_prompt: db "Numero rotado con ROR%"

    rcl_prompt: db "Numero rotado con RCL%"
    rcr_prompt: db "Numero rotado con RCR%"

    shl_prompt: db "Numero rotado con SHL%"
    shr_prompt: db "Numero rotado con SHR%"

    num:  db "10110011%"
    num2: db "10110011%"
    num3: db "10000000%"
    num4: db "00000001%"
    num5: db "10000000%"
    num6: db "00000001%"

section .bss
