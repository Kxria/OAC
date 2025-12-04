#define true 1
#define false !true

typedef unsigned int word;
typedef unsigned char byte;

extern int suma(word A, word B, word C);
void printdec(word dato);
extern void putchar(byte dato);
byte getchar(void);
void puts(byte *);
byte capturarNum(void);

byte *msg1 = {"Ingrese el primer valor A del 0-9:"};
byte *msg2 = {"Ingrese el segundo valor C del 0-9:"};
byte *msg3 = {"Ingrese el modo de suma B del 0 -> (A + C) y 1 -> (A + C + 1):"};
byte *msg4 = {"El resultado es:"};
byte *msg5 = {"Presionar cualquier tecla para repetir.\r\n"};
byte *msg6 = {"\r\n"};

void main(void) {
    word A, B, C, Res;

    while(true) {
        puts(msg1);
        A = capturarNum();
        puts(msg6);
        puts(msg2);

        C = capturarNum();
        puts(msg6);
        puts(msg3);

        B = capturarNum();
        puts(msg6);

        Res = suma(A, B, C);
        puts(msg4);

        printdec(Res);
        puts(msg6);
        puts(msg5);
        getchar();
    }
}

void printdec(word dato) {
    putchar(dato/100 + 0x30);
    dato %= 100;
    putchar(dato/10 + 0x30);
    putchar(dato%10 + 0x30);
}

byte capturarNum(void) {
    byte temp;
    do {
        temp = getchar();
    } while(temp < '0' || temp > '9');
    return temp - 48;
}

byte getchar(void) {
    byte dato;
    asm mov ah, 1
    asm int 0x21
    asm mov dato, al
    return dato;
}

void puts(byte *str) {
    while(*str) {
        putchar(*str++);
    }
}