%include "../Libreria/pc_io.inc"  ; se incluye la libreria

section .text
	global _start:

_start:
    ; mov eax, num
    ; mov ebx, num
    ; mov eax, [ebx]
    ; mov esi, cad
    ; call printHex

    mov eax, num
    mov esi, cad
    call printHex
    call salto

    mov eax, cad
    mov esi, cad
    call printHex
    call salto

    mov eax, cad2
    mov esi, cad2
    call printHex
    call salto

    mov eax, cad3
    mov esi, cad3
    call printHex
    call salto

    mov eax, 1
    mov ebx, 0
    int 80h

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
    ; num2: db 123456789ABCDEF0h

section .bss
    num resb 8
    cad resb 1
    cad2 resb 7
    cad3 resb 3

    num2 resb 8
