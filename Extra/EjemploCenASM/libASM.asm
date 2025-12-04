section .data
section .bss
section .text

global sumaLista:

sumaLista:
    push EBP
    mov ebp, esp
    push EBX
    push EDI
    push ESI

    mov esi, [ebp + 8]
    mov ecx, [ebp + 12]
    mov eax, 0
    mov edi, 0

    .continue:
        add eax, [esi + edi * 4]
        inc edi
        loop .continue

    pop ESI
    pop EDI
    pop EBX

    mov esp, ebp
    pop EBP
    ret