#define BYTE unsigned char
#define WORD unsigned int

#define PA           0x40
#define PB           0x41
#define PC           0x42
#define RCtr         0x43
#define PTOs_all_out 0x80

char dato;

void main(void) {
    puts("Practica \n\r");
    outportb(RCtr, PTOs_all_out);
    outportb(PA, 0x55);

    while(1) {
        dato = getch();
        outportb(PB, dato);
        printBin(dato);
        puts("\n\r");
    }
}

void outportb(WORD port, BYTE dato) {
    asm mov dx, port
    asm mov al, dato
    asm out dx, al
}

void printBin(BYTE dato) {
    BYTE msk = 0x80;

    do {
        putchar((dato & msk) ? '1' : '0');
        msk >>= 1;
    } while(msk);
}