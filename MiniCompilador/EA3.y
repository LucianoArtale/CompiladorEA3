%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

#define ERROR -1
#define OK 1
#define MAXINT 50
#define MAXCAD 50


////////////////////ESTRUCTURAS////////////////////


//Terceto
typedef struct
{
    int nro;
    char cad1[MAXCAD];
    char cad2[MAXCAD];
    char cad3[MAXCAD];
    //int result;
}t_infoTerceto;

typedef struct s_nodoTerceto{
    t_infoTerceto info;
    struct s_nodoTerceto* psig;
}t_nodoTerceto;

typedef t_nodoTerceto *t_terceto;


//Tabla de simbolos
struct datoTS {
	char *nombre;
	char *tipoDato;
	char *valor;
	char *longitud;
};

struct datoTS tablaDeSimbolos[100];
int cantFilasTS = 0;

//Pila
typedef struct
{
    char* cadena;
    int nro;
    char* tipoDeDato;
}t_info;

typedef struct s_nodoPila
{
    t_info info;
    struct s_nodoPila* sig;
}t_nodoPila;

typedef t_nodoPila *t_pila;





////////////////////FUNCIONES////////////////////

//internas del compilador
int mostrarTS();
void insertarTipoDatoEnTS(char*, char*);
void insertarEnNuevaTS(char*,char*,char*,char*);
int existeEnTS(char *);
void guardarTS();
int validarTipoDatoEnTS(char*, char*); 
int ponerValorEnTS(char*, char*);
char* tieneTipoDatoEnTS(char*);
//char* obtenerNroParaTipoEnTS(char*, char*)

//Definición funciones de pilas
int vaciarPila(t_pila*);
t_info* desapilar(t_pila*);
void desapilar_str(t_pila*, char*);
int desapilar_nro(t_pila *);
void crearPila(t_pila*);
int apilar(t_pila*,t_info*);
t_info* verTopeDePila(t_pila*);
int pilaVacia (const t_pila*);

//Funciones de Tercetos
void crearTerceto(t_terceto*);
int insertarTerceto(t_terceto*, char*, char*, char*);
int guardarTercetos(t_terceto*);




/////////////////VARIABLES///////////////////

//Tercetos
t_pila pilaIds;
t_terceto tercetos;
int posicionTerceto; //sacar?

//Indices
//int progIND;
//int sentIND;
int asigIND;
int rdIND;
int takeIND;
int listaIND;
int wrtIND;

//otras
int contadorElemAOperar;
int elemEnLista;
int elemTake;



/////////////////////////////////////////INICIO REGLAS/////////////////////////////////////////

%}



%union {
    int int_val;
    double float_val;
    char *str_val;
}

%type <str_val> prog
%type <str_val> sent
%type <str_val> asig
%type <str_val> take
%type <str_val> lista
%type <str_val> WRITE
%type <str_val> READ


%token TAKE
%token WRITE
%token READ
%token PA
%token PC
%token ASIGNA
%token MAS
%token CA
%token CC
%token PYC
%token COMA
%token <str_val> ID
%token <str_val> CTE_S
%token <int_val> CTE


%%

prog:
    sent {printf("\nRegla 1\n");}
    | prog sent {printf("\nRegla 2\n");}
    ;

sent:
    rd {printf("\nRegla 3\n");}
    | asig {printf("\nRegla 3\n");}
    | wrt {printf("\nRegla 3\n");}
    ;

asig:
    ID ASIGNA take {printf("\nRegla 4\n");}
    ;

rd:
    READ ID 
    {
      printf("\nRegla 5\n");

      t_info *tInfoPilaId=(t_info*) malloc(sizeof(t_info));
      tInfoPilaId->cadena = (char *) malloc (MAXCAD * sizeof (char));
      strcpy(tInfoPilaId->cadena,$1);
      apilar(&pilaIds,tInfoPilaId);
    }
    ;

take:
    TAKE PA MAS PYC ID 
    {
        printf("\nRegla 6\n");

        /*t_info *tInfoPilaId=(t_info*) malloc(sizeof(t_info));
        tInfoPilaId->cadena = (char *) malloc (MAXCAD * sizeof (char));
        strcpy(tInfoPilaId->cadena,"@n");
        apilar(&pilaIds,tInfoPilaId);*/

        /*if(CTE > 0)
        {
            elemTake=cte;
        }
        else
        {
            printf("Error: El número de elementos a operar debe ser mayor a 0");
            exit(0);
        }*/
    }
    PYC CA lista CC 
    {
        printf("\nRegla 6.1\n");
        /*if(elemEnLista < elemTake)
        {
            printf("Error: El número de elementos en la lista es menor al indicado para operar");
            exit(0);
        }*/
    }
    PC {printf("\nRegla 6.2\n");}
    ;

lista:
    CTE
    {
        printf("\nRegla 7\n");

        contadorElemAOperar = 1; 
        char numStr[MAXINT];
        sprintf(numStr,"%d",$1);
        listaIND = insertarTerceto(&tercetos, numStr, "", "");
        printf("LISTA CTE: %d", listaIND);
        elemEnLista = 1;
    }
    | lista COMA CTE
    {
        printf("\nRegla 8\n");

        if(contadorElemAOperar < elemTake)
        {
          char aux1ListaIND[MAXINT], numStr[MAXINT], aux2ListaIND[MAXINT]; 
          sprintf(aux1ListaIND,"%d", listaIND);
          sprintf(numStr,"%d",$3);
          sprintf(aux2ListaIND,"%d", insertarTerceto(&tercetos, numStr, "", ""));
          listaIND = insertarTerceto(&tercetos, "+", aux1ListaIND, aux2ListaIND);
          contadorElemAOperar++;
        }
        elemEnLista++;
    }
    ;

wrt:
    WRITE CTE_S 
    {
      printf("\nRegla 9\n");

      wrtIND = insertarTerceto(&tercetos, "WRITE", $2, "");
      printf("WRITE: %d", wrtIND);
    }
    | WRITE ID 
    {
      printf("\nRegla 10\n");
    }
    ;

%%


/////////////////////////////////////MAIN Y ERROR/////////////////////////////////////

int main(int argc,char *argv[])
{ 
  //char cadena[] = "ID";
  //int value = 0;
  //fprintf(archTabla,"%s\n","NOMBRE\t\t\tTIPODATO\t\tVALOR");
  posicionTerceto = 1;
  elemTake = 5; //                   ->            LUEGO BORRAR

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
    printf("\nIniciando main\n");
    crearPila(&pilaIds);
    crearTerceto(&tercetos);
    //crearPila(&pilaCMP);
    //crearPila(&pilaTipoDato);
    printf("Iniciando Parsing\n");
    yyparse();
    printf("Fin Parsing\n");
  }
  if(guardarTercetos(&tercetos) < 0)
  {
    printf("\nError generando el archivo de notacion intermedia\n");
    return 0;
  }
  
  //printf("Validando tipo de dato: %d",validarTipoDatoEnTS("a1","STRING"));
  //mostrarTS();
  //guardarTS();
  //generarAssembler(&polaca);
  fclose(yyin);
  printf("Fin main\n");

  return 0;
}


int yyerror(void)
{
    printf("Syntax Error\n");
    system ("Pause");
    exit (1);
}


/////////////////////////////////////FUNCIONES DE TS/////////////////////////////////////

mostrarTS(){
  int i=0;
  for(i; i<cantFilasTS;i++)
  { 
    printf("Verificando: %s\t\t\t%s\t\t\t%s\t\t\t\n",tablaDeSimbolos[i].nombre,tablaDeSimbolos[i].tipoDato,tablaDeSimbolos[i].valor);
  }
  return 0;
}


int existeEnTS(char *nombre){
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);
    
    int i=0;
    for(i; i<cantFilasTS;i++)
    { 
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        return 1;
      }
    }
    return 0;
  }

void insertarEnNuevaTS(char* nombre, char* tipoDato, char* valor, char* longitud)
{
  struct datoTS dato;

  dato.nombre = nombre;
  dato.tipoDato = tipoDato;
  dato.valor = valor;
  dato.longitud = longitud;
  tablaDeSimbolos[cantFilasTS] = dato;
  
  cantFilasTS++; 
}

void insertarTipoDatoEnTS(char* nombre, char* tipoDato){
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;
    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        tablaDeSimbolos[i].tipoDato = tipoDato;
        return;
      }
    }
    printf("Error! No existe la variable %s en la tabla de simbolos", nombre);	
    system ("Pause");
		exit(1);
    return;
  }

int validarTipoDatoEnTS(char* nombre, char* tipoDato){
    
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;

    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        if(strcmpi(tipoDato,tablaDeSimbolos[i].tipoDato) == 0)
        {
          return OK;
        }
        else{
          printf("\nError! La variable %s es de tipo %s y no coinciden los tipos asignados\n",nombreVariable,tablaDeSimbolos[i].tipoDato);
          return ERROR;
          }
      }
    }
    printf("\nError! No existe la variable %s en la tabla de simbolos",nombre);	  
    return ERROR;
  }

  int ponerValorEnTS(char* nombre, char* nuevoValor){
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;

    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        tablaDeSimbolos[i].valor = nuevoValor;
      }
    }
    printf("\nError! No existe la variable en la tabla de simbolos");
    system ("Pause");
									exit(1);
    return ERROR;
  }


void guardarTS()
{
	FILE *file = fopen("ts.txt", "w+");
	
	if(file == NULL) 
	{
    	printf("\nERROR: No se pudo abrir el txt correspondiente a la tabla de simbolos\n");
	}
	else 
	{
		int i = 0;
		for (i; i < cantFilasTS; i++) 
		{
			fprintf(file, "%s\t\t%s\t\t%s\t\t%s\n", tablaDeSimbolos[i].nombre, tablaDeSimbolos[i].tipoDato, tablaDeSimbolos[i].valor, tablaDeSimbolos[i].longitud);
		}		
		fclose(file);
	}
}

char* tieneTipoDatoEnTS(char* nombre){
    
    char* nombreVariable = (char*) malloc(sizeof(nombre)+1);
    sprintf(nombreVariable,"_%s",nombre);

    int i=0;

    for(i; i<cantFilasTS;i++)
    {
      if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0){
        return tablaDeSimbolos[i].tipoDato;
      }
    }
    printf("\nError! No existe la variable en la tabla de simbolos");	  
    return "";
}   
/*
char* obtenerNroParaTipoEnTS(char* linea, char* tipoDato){
    char* nombreVariable = (char*) malloc(sizeof(linea)+1);
    sprintf(nombreVariable,"_%s",linea);    

    int i=0;
    int cont = 0;

    for(i; i<cantFilasTS;i++)
    { 

      if(strcmpi(tipoDato,tablaDeSimbolos[i].tipoDato) == 0)
      {
          cont++;
          
        if(strcmpi(nombreVariable,tablaDeSimbolos[i].nombre) == 0)
        {
          char* nombreARetornar = (char*) malloc(MAXCAD);
          sprintf(nombreARetornar,"%s%d",tablaDeSimbolos[i].tipoDato,cont);
          return nombreARetornar;
        }
      }
    }
    return "";
}
*/


/////////////////////////////////////FUNCIONES DE PILA/////////////////////////////////////

void crearPila(t_pila* p){
		*p=NULL;
    printf("Pila creada\n");
}

int vaciarPila(t_pila* p)
{
    t_nodoPila *aux;
    if(*p==NULL)
        return(0);
   while(*p)
   {
    aux=*p;
    *p=(*p)->sig;
    free(aux);}
    return(1);
}

int apilar(t_pila* p,t_info* d)
{   
	t_nodoPila *nue=(t_nodoPila*) malloc(sizeof(t_nodoPila));
    
    if(nue==NULL)
        return(0);

    nue->info=*d;

    nue->sig=*p;

    *p=nue;

    return(1);
}

t_info* desapilar(t_pila *p)
{   
		t_nodoPila *aux;

	if(*p==NULL)
        return(0);

	  aux=*p;
	  t_info *infoDePila;
    
	  *infoDePila = (*p)->info;    

    *p=(*p)->sig;

    free(aux);

	return (infoDePila);
}

int desapilar_nro(t_pila *p)
{   
		t_nodoPila *aux;

	if(*p==NULL)
        return(0);

	  aux=*p;

	  int nro;
    
	  nro = (*p)->info.nro;    

    *p=(*p)->sig;

    free(aux);

	return (nro);
}

void desapilar_str(t_pila *p, char* str)
{   
	t_nodoPila *aux;
	if(*p==NULL)
        return;

	  aux=*p;

	  strcpy(str,(*p)->info.cadena);   

    *p=(*p)->sig;

    free(aux);
}
/*
t_info * desapilarASM(t_pila *p)
{   
	t_info* info = (t_info *) malloc(sizeof(t_info));
	    if(!*p){
	    	return NULL;
	    }
	    *info=(*p)->info;
	    *p=(*p)->sig;
	    return info;
}
*/
t_info* verTopeDePila(t_pila* p)
{   if(*p==NULL)
    return(0); 

	  t_info* info;

    *info =(*p)->info;

    return(info);
}

int pilaVacia(const t_pila* p)
{
    return *p==NULL;
}


/////////////////////////////////////FUNCIONES DE TERCETOS/////////////////////////////////////

//Creo el terceto
void crearTerceto(t_terceto* p)
{
  *p=NULL;
  return;
}


//Pongo el nodo del terceto a lo último, con sus respectivos datos y hago que apunte a null su siguiente
int insertarTerceto(t_terceto* p, char *cad1, char *cad2, char *cad3)
{
  t_nodoTerceto* nue = (t_nodoTerceto*)malloc(sizeof(t_nodoTerceto));
  if(!nue){
      printf("\nError al insertar terceto\n");
      return ERROR;
  }
  printf("Iniciando insertarTerceto\n");
  t_nodoTerceto* aux;
    
  //Ponemos la posicion en el terceto
  int indice = posicionTerceto++;
  nue->info.nro = indice;
  printf("posicionTerceto++\n");
  //Asignamos las cadenas al nodo
  strcpy(nue->info.cad1,cad1);
  printf("cad1 asignada\n");
  strcpy(nue->info.cad2,cad2);
  printf("cad2 asignada\n");
  strcpy(nue->info.cad3,cad3);
  printf("cad3 asignada\n");
  //Hacemos que sea el último nodo en la lista de tercetos
  nue->psig=NULL;
  printf("psig creado\n");
      
  while(*p)
  {
      p=&(*p)->psig;
  }
  *p=nue;
  printf("p apunta a nue, fin insertarTerceto\n");

  return indice;
}


//Guardo los tercetos en el archivo de intermedia
int guardarTercetos(t_terceto *p)
{
  FILE*pf=fopen("Intermedia.txt","w+");
  
  t_nodoTerceto* aux;
  
  aux=*p;

  if(!pf){
    //No se creó el archivo de intermedia en el main
    return ERROR;
  }

  t_nodoTerceto* nodoActual;

  while(aux)
    {
        nodoActual=aux;

        fprintf(pf, "%d %s %s %s\n",nodoActual->info.nro, nodoActual->info.cad1, nodoActual->info.cad2, nodoActual->info.cad3);
        
    aux=(aux)->psig;
    
    //free(nodoActual);
    }
  fclose(pf);
}



/*int ponerEnTercetosPosicion(t_terceto* p,int pos, char *cadena){
		t_nodoPolaca* aux;
		
		aux=*p;
		
	    while(aux!=NULL && aux->info.nro != pos){
	    	aux=aux->psig;
	    }
	    
		if(aux->info.nro==pos){
	    	strcpy(aux->info.cadena,cadena);
	    	return OK;
	    }

	    return ERROR;
}*/