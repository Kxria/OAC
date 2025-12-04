.model tiny
locals 
.data
    PA              DW 0040h
    PB              DW 0041h
    PC              DW 0042h
    RCtr            DW 0043h
    PTOs_all_out    DB 80h  ; 80h Indica que todos los puertos son de salida
    
.code
    org 100h

principal PROC
    mov sp, 0fffh
    
    mov dx, 43h     ; RCtr
    mov al, 80h     ; PTOs_all_out
    call outportb
    
    ; 2. a)
    mov ax, 4h
    mov cl, 3
    call setBit
    call printbin ; debe mostrar 0000 1100
    call salto
    
    ; 2. b)
    mov cl, 2
    call clearBit
    call printbin ; debe mostrar 0000 1000
    call salto
    
    ; 2. c)
    mov cl, 0
    call notBit
    call printbin ; debe mostrar 0000 1001
    call salto
    
    ; - - - - - - - - - - - - - - - - - - - -
    ; 3.
    mov dx, 40h
    mov al, 4Ch
    out dx, al
    in al, dx
    call printbin ; debe imprimir 0100 1100
    
    ; 3. a)
    ; mov dx, 40h
    ; mov cl, 4
    ; call setBitPort ; debe mostrar 0101 0100
    
    ; 3. b)
    mov dx, 40h
    mov cl, 3
    call clearBitPort ; debe mostrar 0100 0100 
    
    ; 3. c)
    ; mov dx, 40h
    ; mov cl, 7
    ; call notBitPort ; debe mostrar 1100 1100
    
@@fin:            
    jmp @@fin
    ret
    endp

; - - - - - - - - - - - - - - - - - - - -    
outportb proc ; DX recibe el puerto | AL el dato a sacar
    out dx, al
    ret
endp

; - - - - - - - - - - - - - - - - - - - -    

setBit PROC
    push cx     ; se guarda BX en la pila
    mov bx, 1   ; se coloca 1 en BX para hacer la mascara
    shl bx, cl  ; se recorre a la izquierda CL veces
    
    or ax, bx   ; se aplica la mascara en AX
    pop cx      ; se restaura el valor de bx
    ret
    ENDP

clearBit PROC
    push cx     ; se guarda BX en la pila
    mov bx, 1   ; se coloca 1 en BX para hacer la mascara
    shl bx, cl  ; se recorre a la izquierda CL veces
    not bx      ; se niega BX para tener en 0 el bit que queremos apagar
    
    and ax, bx   ; se aplica la mascara en AX
    pop cx      ; se restaura el valor de bx
    ret
    ENDP

notBit PROC
    push cx     ; se guarda BX en la pila
    mov bx, 1   ; se coloca 1 en BX para hacer la mascara
    shl bx, cl  ; se recorre a la izquierda CL veces
    
    xor ax, bx   ; se aplica la mascara en AX
    pop cx      ; se restaura el valor de bx
    ret
    ENDP
    
; - - - - - - - - - - - - - - - - - - - -
setBitPort PROC
    push bx     ; se guarda BX en la pila
    in al, dx
    mov bx, 1   ; se coloca 1 en BX para hacer la mascara
    shl bx, cl  ; se recorre a la izquierda CL veces
    
    or ax, bx   ; se aplica la mascara en AX
    out dx, al
    pop bx      ; se restaura el valor de BX
    ret
    ENDP

clearBitPort PROC
    push bx     ; se guarda BX en la pila
    in al, dx   
    mov bx, 1   ; se coloca 1 en BX para hacer la mascara
    shl bx, cl  ; se recorre a la izquierda CL veces
    not bx      ; se niega BX para tener en 0 el bit que queremos apagar
    
    and ax, bx  ; se aplica la mascara en AX
    out dx, al
    pop bx      ; se restaura el valor de BX
    ret
    ENDP

notBitPort PROC
    push bx     ; se guarda BX en la pila
    in al, dx
    mov bx, 1   ; se coloca 1 en BX para hacer la mascara
    shl bx, cl  ; se recorre a la izquierda CL veces
    
    xor ax, bx  ; se aplica la mascara en AX
    out dx, al
    pop bx      ; se restaura el valor de BX
    ret
    ENDP    
; - - - - - - - - - - - - - - - - - - - -
printbin PROC
    push ax
    push cx 
    mov ah, al
    mov cx, 8

    @@ciclo:
        shl ah, 1
        jnc @@cero

        mov al, '1'
        jmp @@imprimir

    @@cero:
        mov al, '0'
    @@imprimir: 
        call putchar
        loop @@ciclo
    pop cx
    pop ax
    ret
    ENDP

putchar  PROC
    push ax    
        mov dl, al
        mov ah, 2h
        int 21h
    pop ax
    ret
    ENDP
;- - - - - - - - - - - - - - - - - -
salto   PROC
    push ax
    mov ah, 2
    mov dl, 13
    int 21h
    
    mov dl, 10
    int 21h
    pop ax
    ret
    ENDP
end principal