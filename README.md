# Pre requisitos
## ACTUALIZAR
```bash
sudo apt update
```
## INSTALAR NASM
```bash
sudo apt install nasm -y
```
## SOFTWARE TJUINO
* DOSBOX
* MTTTY
* GUI TURBO ASSEMBLER
* XLOADER
* TJUINO

# ENSAMBLAJE Y EJECUCION .ASM
```bash
nasm -f elf p3.asm
ld -m elf_i386 -s -o <CARPETA> <ARCHIVO>.o ../Libreria/libpc_io.a
./<CARPETA>
```
# ENSAMBLAJE Y EJECUCION .ASM CON .C
```bash
nasm -f elf ARCHIVO.asm
gcc -m32 -c ARCHIVO.c
gcc -m32 ARCHIVO_ASM.o ARCHIVO_C.o -o NOMBRE.exe (IGNORAR WARNING)
./NOMBREEXE
```

# Documentación Librería ASM

**Rutina**: clrscr  
- Parámetros:
  - Entrada: ninguno
  - Salida: ninguno

**Rutina**: gotoxy  
- Parámetros:
  - Entrada:  
    - BH → posición x (columna)  
    - BL → posición y (renglón)  
  - Salida: ninguno

**Rutina**: putchar  
- Parámetros:
  - Entrada: AL contiene el caracter a desplegar  
  - Salida: —

**Rutina**: puts  
- Parámetros:
  - Entrada: EDX contiene el apuntador a la cadena a imprimir  
  - Salida: ninguno

**Rutina**: getche  
- Parámetros:
  - Entrada: —  
  - Salida: AL contiene el caracter tecleado

**Rutina**: getch  
- Parámetros:
  - Entrada: —  
  - Salida: AL contiene el caracter tecleado