.model tiny
locals
.code
    org 100h
    
main    PROC
    mov sp, 0FFFh

    mov ax, 15d     ; AX = numero a imprimir
    call printHex
    call salto
    
    mov ax, 0Fh     ; AX = Numero a imprimir
    call printDecimal
    call salto

    ; sys_exit
    mov ah, 04Ch
    int 21h
    ret        
    endp
;- - - - - - - - - - - - - - - - - -

printHex    PROC
    push ax
    push bx
    push cx
    push dx
    mov dx, ax
    mov bx, 0Fh
    mov cl, 12

    @@nxt:  shr ax, cl
    @@msk:  and ax, bx               ; Mascara, solo tener nibble mas bajo
            cmp al, 9                ; Comparar si es numero o letra
            jbe @@menor              ; Si AL <= 0xAh
            add al, 7                ; Mascara por si es letra
    @@menor: add al, '0'             ; Convertir en caracter ASCII
            call putchar
            
            cmp cl, 0
            je @@fin
            
            mov ax, dx              ; Reestablecer valor en AX                        
            sub cl, 4               ; Se le resta 4 para avanzar en nibble
            cmp cl, 0               ; Ver si aun quedan corrimientos
            ja @@nxt                ; Si aun quedan
            je @@msk
    @@fin:  pop DX
            pop CX
            pop BX
            pop AX
            ret
    ENDP
;- - - - - - - - - - - - - - - - - -
printDecimal    PROC
    push ax
    push bx
    push cx
    push dx
    mov bx, 0       ; Contador de longitud
    mov cx, 10      ; Divisor Base 10
    
    @@convertir: 
        cmp ax, 0       ; se compara AX para ver si la base es 0          
        je @@imprimir
        
        mov dx, 0       ; resetea DX para almacenar los reciduos
        div cx          ; se divide entre la base 10
        
        add DL, '0'     ; se convierte a ASCII
        push dx         ; se guarda el caracter en la pila
        inc bx          ; se incrementa en 1 el cont de len
        jmp @@convertir

    @@imprimir: 
        cmp bx, 0       ; se compara para ver si ya terminamos la impresion
        je @@terminar
        
        dec bx          ; len - 1
        pop dx          ; extraemos el dato de la pila
        mov al, dl      ; movemos el dato DL a AL para imprimirlo con putchar
        call putchar
        jmp @@imprimir

    @@terminar:  
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    ENDP
;- - - - - - - - - - - - - - - - - -
putchar  PROC
    push ax
    push dx
        mov dl, al
        mov AH, 02h
        int 21h
    pop dx
    pop ax
    ret
    ENDP
;- - - - - - - - - - - - - - - - - -
salto   PROC
    push ax
    push dx
        mov dl, 13
        mov ah, 02h
        int 21h
        
        mov dl, 10
        mov ah, 02h
        int 21h
    pop dx
    pop ax
    ret
    ENDP
end main