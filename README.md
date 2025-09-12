# OAC

**ACTUALIZA**
sudo apt update

**INSTALA NASM**
sudo apt install nasm -y

**CREA CARPETAS**
mkdir <NOMBRE>

**MUEVE EL DIRECTORIO**
cd /workspaces/OAC/<CARPETA>

**CREAR ARCHIVOS**
<NOMBRE>.<EXT>

**ENSAMBLAJE Y EJECUCION**
nasm -f elf p3.asm
ld -m elf_i386 -s -o <CARPETA> <ARCHIVO>.o libpc_io.apt
./<CARPETA>