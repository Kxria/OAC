%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
	global _start:

_start:
    ; capturar una cadena e invertirla sin utilizar memoria de datos, dos ciclos, uno para guardar en pila y otro para sacar de la pila

    mov edx, cad_prompt
    call newputs
    call salto

    ; capturar cadena    
    mov edi, 0          ; se coloca EDI en 0 para usarlo como la longitud de la cadena
    ciclo_cap:
        call getche     ; se captura un caracter en AL
        cmp al, '*'     ; se compara AL si ese caracter es el final de la cadena
        je fin          ; de ser cierto, se termina el bucle de captura

        push ax         ; si no es el fin de la cadena, ese caracter se manda a la pila
        inc edi         ; se incrementa EDI porque se capturo un caracter
        jmp ciclo_cap   ; se continua el ciclo
    fin:
    call salto
    
    ; se imprime el prompt de cadena invertida
    mov edx, inv_prompt
    call newputs
    call salto

    ; sacar de la pila la cadena
    mov ecx, edi ; se manda el contenido de EDI a ECX para usarlo como numero de iteraciones
    ciclo_imprimir:
        pop ax                  ; se extrae de la pila el caracter previamente capturado, en este caso, el ultimo antes del *
        call putchar            ; se imprime ese caracter
        loop ciclo_imprimir     ; se continua el ciclo
    call salto

; ================================================================
    ; se imprime el mensaje de numero de corrimientos
    mov edx, bin_prompt
    call newputs        
    call salto

    ; se captura el numero de corrimientos y se imprime
    ; se captura el primer numero y se guarda
    call getche
    mov ebx, corr
    mov [ebx], al
    call salto

    ; se convierte a numero
    mov ebx, corr
    sub byte[ebx], '0'

    ; se imprime el prompt del numero original
    mov edx,num_prompt
    call newputs
    call salto

    ; se imprime el numero
    mov edx, num
    call newputs
    call salto

    mov edx, corr       ; se manda la direccion de la cantidad de corrimientos a EDX
    mov ecx, [edx]      ; se mandan la cantidad de corrimientos a ECX para usarlo en el loop
    corrimientos:
        mov ebx, num        ; se manda la direccion del numero binario a EDX
        mov ah, [edx + 3]   ; se guarda en AL el ultimo bit (menos significativo)
        sub ah, '0'         ; se actualiza el formato a su valor decimal
        SAHF                ; se manda al CF el bit menos significativo guardado en AH

        ; EBX = 0 1 1 0 % = 0 1 1 1 
        ;       0 1 2 3 4
        mov al, [ebx + 2]  ; bit 2 a bit 3
        mov [ebx + 3], al

        mov al, [ebx + 1]  ; bit 1 a bit 2
        mov [ebx + 2], al

        mov al, [ebx + 0]  ; bit 0 a bit 1
        mov [ebx + 1], al

        mov byte [ebx + 0], '0' ; se reemplaza el bit mas significativo con un 0
        loop corrimientos

    ; se imprime el prompt del numero binario con corrimientos
    mov edx, corrimiento_prompt
    call newputs
    call salto
    
    ; se imprime el numero ya con los corrimientos
    mov edx, num
    call newputs
    call salto

    ; SYS_EXIT
    mov eax, 1
    mov ebx, 0
    int 80h

; ================================================================
newputs:
    pushad
    mov esi, 0
    prnt:
        mov al, [edx + esi]     ; se manda a al el caracter incial
        cmp al, '%'             ; se compara al con % 
        je finputs              ; si es verdadero, se sale del ciclo

        call putchar            ; se imprime al caracter actual
        inc esi                 ; se incrementa el indice
        jmp prnt                ; se reincia el cilo de impresionJ
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
    cad_prompt: db "Ingresa una cadena:%"
    inv_prompt: db "Cadena invertida:%"
    bin_prompt: db "Ingresa el numero de corrimientos hacia la derecha:%"
    corrimiento_prompt: db "Cadena binaria recorrida:%"
    conv_prompt: db "valor convertido: %"
    num: db '0110%'
    num_prompt: db "Numero de 4 bits original:%"
    tabla: db 1,2,4,8,16

section .bss
    cad resb 8
    corr resb 1
    conv resb 1