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

principal proc
    mov sp, 0fffh
    
    mov dx, 43h     ; RCtr
    mov al, 80h     ; PTOs_all_out
    call outportb
    
    mov dx, 40h     ; DX contiene el puerto (En este caso, PA)
    mov ax, 4h     ; AL contiene el dato a sacar por el puerto
    call outportb
.rep:
    jmp .rep
    ret
    endp
    
outportb proc ; DX recibe el puerto | AL el dato a sacar
    out dx, al
    ret
endp
end principal