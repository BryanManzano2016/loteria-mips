#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int randomNumber(int upperLim, int lowerLim);
int beetweenRange(int upperLim, int lowerLim, int num);

int main(void) {
  /*
    upperLim: limite superior hasta donde pueden llegar los nros aleatorios y los ingresados
    lowerLim: limite inferior hasta donde pueden llegar los nros aleatorios y los ingresados
    sizeList: tamaño de la lista ganadora y la de nros seleccionados
    list: lista con nros seleccionados
    listWin: lista con nros aleatorios ganadores
    points: puntos 
  */
  int upperLim = 10;
  int lowerLim = 0;
  int sizeList = 3;
  int list[sizeList];
  int listWin[sizeList];
  int points = 0;

  printf("Ingrese %d numeros de loteria del %d al %d:\n", sizeList, 
    lowerLim, upperLim);
  
  // Crea los numeros ganadores y pide al usuario ingresar los apostados
  int x = 0;
  while( x < sizeList ) {

    printf( "Ingrese su nro %d:\n", x + 1);   

    int tmp;
    scanf("%d", &tmp);    // ingreso por consola

    // ingresa un nro hasta que este en el rango sino reinicia el bucle
    if(beetweenRange(upperLim, lowerLim, tmp) == 0) {
      printf("Fuera del %d al %d, repita:\n", lowerLim, upperLim);
      continue;
    }
    
    // guarda los nros en las listas
    list[x] = tmp;
    listWin[x] = randomNumber(upperLim, lowerLim);
    x++;
  }

  // Verifica si hubo ganador
  printf("Lista de numeros ganadora: ");
  for(int x = 0; x < sizeList; x++){
    // Si algun nro seleccionado es igual a los que estan en la lista ganadora suman puntos
    if(list[x] == listWin[0] || list[x] == listWin[1] || list[x] == listWin[2]){
        points++;
    }
    printf("%d ", listWin[x]);
  }
  printf("\n");

  if(points > 0){
      printf("!Has ganado %d dolares!. Atinastes a %d!", points*10, points);
  }else{
      printf("No has acertado ningun numero. :c");
  }  
  
  return 0;
}

// Numero aleatorio
int randomNumber(int upperLim, int lowerLim){
    srand(time(NULL));
    int num = rand() % (upperLim - lowerLim + 1) + lowerLim;           
    return num;
}
// Verificar si el numero esta en intervalo, 1:si -1:no
int beetweenRange(int upperLim, int lowerLim, int num) { 
  if(num >= lowerLim && num <= upperLim){
    return 1;
  }
  return 0;
}
