%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
	global _start:

_start:
    ; se imprime la cadena binaria a modificar
    mov edx, bin
    call newputs
    call salto

    mov cx, 1                ; se indica la cantidad de corrimientos deseados
    call corrimientoRight    ; se manda a llamar a la rutina

    ; se imprime la cadena binaria modificada
    mov edx, bin        
    call newputs
    call salto

    ; sys_exit
    mov eax, 1
    mov ebx, 0
    int 80h

; ==========================================================================

    ; bin = 0 1 0 1 0 0 0 0
        ;   | | | | | | |
        ;   0 1 2 3 4 5 6 7

    ; SHR
    corrimientoRight:
    pushad
    loop_corrimientoRight:
        mov edi, 7      ; apuntador al final de la cadena antes del '%'
        mov esi, 6      ; apuntador al antepenultimo caracter de la cadena antes del "%"
        cmp cl, 0       ; se compara CL con 0 para verificar si se terminaron los corrimientos
        je fin          ; si es verdadero, se sale de la rutina

        mov ah, [edx + edi]     ; se almacena el -bit de la cadena
        sub ah, '0'             ; se convierte a su valor numerico
        SAHF                    ; se manda ese bit al CF

        loop2:
            cmp edi, 0          ; se compara EDI para verificar el fin del corrimiento
            je fin_loop2        ; si es verdadero, se sale del ciclo de corrimientos

            mov ah, [edx + esi] ; se almacena en AH el caracter anterior al que apunta EDI
            mov [edx + edi], ah ; se reemplaza el caracter apuntado por EDI con el anterior a este

            ; se decrementan los indices para seguir con el siguiente par a recorrer
            dec esi
            dec edi
            jmp loop2

        ; una vez terminados los corrimientos
        fin_loop2:
            mov byte [edx], '0'     ; se ingresa un 0 en el bit mas significativo
            dec cl                  ; se decrementa CL para indicar que se realizo un corrimiento
            jmp loop_corrimientoRight
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
    bin: db "01010000%", 0x0A
section .bss
    cad resb 5