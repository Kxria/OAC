%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
	global _start:

_start:
    ; ======================== CAPTURAR CADENA Y CONTAR LAS VECES QUE APARECE UN CARACTER
    ; imprimir prompt para capturar cadena
    mov edx, cad_prompt
    call newputs
    call salto
    
    mov ebx, cad            ; se manda la direccion de la cadena a ebx
    call capturar           ; se llama al procedimiento de capturar la cadena

    call salto              
    mov edx, cad_ingresada  ; se manda el contenido a ebx con el prompt para poder ser impreso
    call newputs            ; se imprime el prompt de cadena capturada
    call salto

    ; imprime la cadena
    mov edx, cad
    call newputs
    call salto

    ; se imprime el prompt de ingresar caracter
    mov edx, char_prompt
    call newputs
    call salto

    ; se captura el caracter
    mov eax, 0
    call getche
    mov ebx, caracter
    mov [ebx], al
    call salto

    ; se imprime el prompt del caracter ingresado
    mov edx, char_ingresada
    call newputs
    call salto

    ; se imprime el caracter
    mov ebx, caracter
    mov al, [ebx]
    call putchar
    call salto

    ; =========================================== XLAT del 0 al 9

    mov ebx, cad            ; se manda la direccion de la cadena a EBX
    mov edx, caracter       ; se manda la direccion del caracter a EDX
    call contar             ; se manda a llamar a la subrutina de contar caracter

    ; SYS_EXIT
    mov eax, 1
    mov ebx, 0
    int 80h

; ============================================================================

capturar:
    pushad
    mov edi, 0
        ciclo_cap:
            call getche         ; se captura el caracter y se almacena el al
            cmp al, '*'         ; se compara con el indicador de fin de cadena
            je fin              ; si al == *, se sale del ciclo capturar

            cmp al, 13          ; si al == ENTER, no se captura
            je ciclo_cap

            cmp al, 10          ; si al == NUEVA_LINEA, no se captura
            je ciclo_cap
            
            mov [ebx + edi], al ; se coloca el caracter capturado en ebx + indice (edi)
            inc edi             ; se incrementa el indice
            jmp ciclo_cap       ; se reinicia el ciclo

        fin:
        mov al, '%'             ; se coloca el caracter '%' en al
        mov [ebx + edi], al     ; se coloca el % al final de la cadena
    popad
    ret

contar:
    push eax
    push ecx
        mov eax, 0                      ; se reinicia eax en cero para resetear AL y usarlo como contador
        mov cl, 0                       ; registro que usaremos como contador
        ciclo_contar:
            mov al, [ebx + edi]         ; se manda el caracter a comparar a AL
            cmp al, '%'                 ; se verifica si ya se llego al final de la cadena
            je fin_contar               ; si se llega al final, se sale del bucle

            cmp al, [edx]               ; se compara AL con el caracter a buscar
            je sumar                    ; de ser cierto, se le suma 1 al contador de apariciones

            inc edi                     ; se incrementa EDI para dirigirse al siguiente caracter
            jmp ciclo_contar            ; se continua el bucle
        sumar:
            inc cl                      ; se incrementa CL en 1 para acumular apariciones
            inc edi                     ; se incrementa EDI en 1 para dirigirse al siguiente caracter
            jmp ciclo_contar
        fin_contar:
        mov edx, contar_prompt          ; se imprime el prompt
        call newputs                    ; se manda a llamar la subrutina para imprimir
        call salto                      ; se imorime un salto de linea

        mov ebx, tabla                  ; se manda la direccion de la tabla a EDX
        mov al, cl                      ; se copia el contador a CL
        xlat                            ; es extrae y guarda el numero de apariciones en AL
        call putchar                    ; imprime el numero de iteraciones
        call salto
    pop eax
    pop ecx
    ret

newputs:
    pushad
    mov esi, 0
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

newputs2: ; recibe en EDX la direccion y en ESI el indice a mostrar
    pushad
    mov edi, 0
    ciclo_newputs2:
        add edx, edi
        mov al, [edx + esi * 4]
        cmp al, '%'
        je fin_ciclo_newputs2

        inc edi
        call putchar
        jmp ciclo_newputs2
    fin_ciclo_newputs2:
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
    cad_prompt: db "Ingresa una cadena: (que termine en *):%"

    cad_ingresada: db "Cadena ingresada:%"
    char_ingresada: db "Caracter ingresado:%"

    char_prompt: db "Ingresa un caracter a buscar:%"
    contar_prompt: db "El caracter ingresado aparece en la cadena:%"
    tabla: db '0','1','2','3','4','5','6','7','8','9'
    
section .bss
    cad resb 256
    caracter resb 1

    cad_len resb 1

    numero resb 1