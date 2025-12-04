section .text

global ordenar

ordenar:
    push ebp
    mov ebp, esp
    pushad
    
    mov esi, [ebp + 8]
    mov edi, [ebp + 12]
    mov dh, [ebp + 16]

    dec edi

    .for_externo:
        mov ecx, 0
        
        .for_interno:
            movzx eax, byte [esi + ecx]
            movzx ebx, byte [esi + ecx + 1]

            cmp dh, 0
            je .menor_mayor

            .mayor_menor:
                cmp eax, ebx
                jge .continuar
                jmp .cambio

            .menor_mayor:
                cmp eax, ebx
                jle .continuar

            .cambio:
                mov al, [esi + ecx]
                xchg al, [esi + ecx + 1]
                mov [esi + ecx], al

            .continuar:
                inc ecx
                cmp ecx, edi
                jl .for_interno

                dec edi
                jne .for_externo

                .fin:
                    popad
                    mov eax, 1
                    pop ebp
                    ret

printbin: ; 
    pushad
        mov edx, eax
        mov ecx, 32

        ciclo:
            shl edx, 1
            jnc cero

            mov al, '1'
            jmp guardar

        cero:
            mov al, '0'
        guardar: 
            mov [esi], al
            inc esi
            loop ciclo

        sub esi, 32

        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        mov edx, 32
        int 80h

        popad
        ret