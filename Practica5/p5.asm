%include "../Libreria/pc_io.inc"  ; se incluye la libreria
section .text
	global _start:

_start:
    ; imprimir prompt
    mov edx, msg
    call puts
    call salto
    
    ; esi = inicio 
    mov ebx, cad
    mov edi, 0

    capturar:
        call getche         ; se captura el caracter y se almacena el al
        cmp al, '*'         ; se compara con el indicador de fin de cadena
        je fin             ; si al == *, se sale del ciclo capturar

        cmp al, 13          ; si al == ENTER, no se captura
        je capturar

        cmp al, 10          ; si al == NUEVA_LINEA, no se captura
        je capturar
        
        mov [ebx + edi], al ; se coloca el caracter capturado en ebx + indice (edi)
        inc edi             ; se incrementa el indice
        jmp capturar        ; se reinicia el ciclo


    ; imprimir cadena capturada
fin:
    call salto          ; se imprime un salto de linea
    mov edx, msg2       ; se manda el contenido a ebx con el prompt para poder ser impreso
    call puts           ; se imprime el prompt de cadena capturada
    call salto

    mov edx, cad
    call puts
    call salto

    mov ebx, cad            ; se manda la direccion de la cadena a ebx
    mov al, '%'             ; se coloca el caracter '%' en al
    mov [ebx + edi], al     ; se coloca el % al final de la cadena
    
    ; imprime el prompt de la cadena con %
    mov edx, msg3
    call puts
    call salto

    ; se imprime la cadena actualizada
    mov edx, cad
    call puts
    call salto

    ; impresion del prompt para la cadena actualizda
    mov edx, msg4
    call puts
    call salto

    ; imprime la cadena actualizada
    mov edx, cad
    call newputs
    call salto

    ; SYS_EXIT
    mov eax, 1
    mov ebx, 0
    int 80h

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

section data
    msg: db "Ingresa una cadena: (que termine en *)", 0x0
    len: equ $-msg

    msg2: db "Cadena ingresada: ", 0x0
    len2: equ $-msg2

    msg3: db "Cadena con %:", 0x0
    len3: equ $-msg3

    msg4: db "Cadena impresa con newputs:", 0x0
    len4: equ $-msg4

    pal: db "Si es palindromo.", 0x0
    len5: equ $-pal

    noPal: db "No es palindromo.", 0x0
    len5: equ $-noPal

section .bss
    cad resb 256
