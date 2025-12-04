#include <stdio.h>

extern int sumaLista(int* arreglo, int tamano);

int main(void) {
    int arreglo[] = {1, 2, 3, 4, 5};

    int tamano = 5;

    int suma = sumaLista(arreglo, tamano);
    printf("Suma: %d\n", suma);

    return 0;
}