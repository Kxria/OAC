#include <stdio.h>

extern int ordenar(unsigned char *lista, int tam, char orden);

int main(void) {
    // Lista de datos
    unsigned char lista[] = {0x3A, 0x1F, 0xFF, 0x10, 0xAB, 0x01};
    int tam = 6;  // Tamaño de la lista
    char orden = 0;  // 0 para ascendente, 1 para descendente

    // Imprimir lista antes del ordenamiento
    printf("Antes de ordenar:\n");
    for (int i = 0; i < tam; i++) {
        printf("0x%X ", lista[i]);
    }

    printf("\n");

    // Llamamos a la función en ensamblador
    int f = ordenar(lista, tam, orden);
    printf("\n%d\n", f);

    // Imprimir lista después del ordenamiento
    printf("\nDespués de ordenar: \n");
    for (int i = 0; i < tam; i++) {
        printf("0x%X ", lista[i]);
    }

    printf("\n");
    return 0;
}