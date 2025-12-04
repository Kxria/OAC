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
    
    mov dx, 40h          ; Cargar direcci?n del puerto 40h
    mov al, 54h
    out dx, al
    call inportb        ; Leer dato del puerto en AL
    
    mov dx, 40h          ; Cargar direcci?n del puerto 40h
    call outportb       ; Enviar dato invertido al puerto
@@fin:
    jmp @@fin
    ret
    endp
    
outportb proc ; DX recibe el puerto | AL el dato a sacar (invierte los bits)
    out dx, al
    ret
endp

inportb proc ; DX recibe el puerto | Retorna el dato en AL
    in al, dx
    ret
endp
end principal

