#include <stdio.h>

// prototipos de los procedimientos hechos en ASM
extern void gets(int* cad);             // GETS -> Captura cadena
extern int newputs(const char* cad);    // NEWPUTS -> Imprime cadenas
extern unsigned int atoi(int* cad);     // ATOI -> ASCII to INT
extern void printHex(unsigned int n);   // PRINT-HEX
extern void printDec(unsigned int n);   // PRINT-DEC


int main(void) {
    // Variable para que el usuario ingrese un numero a convertir
    char cad[50] = {0};
    
    // Se obtiene la cadena con GETS
    printf("Ingrese una cadena de numeros (Terminada con *): ");
    fflush(stdout);
    gets((int*)cad);

    // Se imprime en pantalla la cadena de numeros con NEWPUTS
    printf("\nSalida en pantalla de puts:     ");
    fflush(stdout);
    newputs(cad);

    // se convierte la cadena de caracteres a numero
    unsigned int numero = atoi((int*)cad);

    // se imprime el numero con print-Hex
    printf("\nSalida en pantalla de printHex: ");
    fflush(stdout);
    printHex(numero);

    // se imprime el numero con print-Dec
    printf("\nSalida en pantalla de printDec: ");
    fflush(stdout);
    printDec(numero);
    printf("\n");

    return 0;
}