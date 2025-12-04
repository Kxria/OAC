.model tiny
.code

    public _putchar
    public _suma

_putchar PROC
    push bp
    mov bp, sp
    push dx
    push ax

    mov dl, [bp + 4]
    mov ah, 2
    int 21h

    pop ax
    pop dx
    pop bp
    ret
_putchar ENDP

_suma PROC
    push bp
    mov bp, sp

    mov ax, [bp + 4]    ; parametro A en AX de suma (A, B, C)
    mov bx, [bp + 6]    ; parametro B en BX de suma (A, B, C)
    mov cx, [bp + 8]    ; parametro C en CX de suma (A, B, C)

    ; if BX == 0 then suma A + C
    ; if BX == 1 then suma A + B + C
    cmp bl, 0
    je .solo_suma
    add ax, bx

    .solo_suma: 
        add ax, cx
        pop bp
        ret
        ENDP
END
