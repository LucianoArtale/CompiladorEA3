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


//Tercetos
typedef struct
{
    int nro;
    char cad1[MAXCAD];
    char cad2[MAXCAD];
    char cad3[MAXCAD];
    int result;
}t_infoTercetos;

typedef struct s_nodoTercetos{
    t_infoTercetos info;
    struct s_nodoTercetos* psig;
}t_nodoTercetos;

typedef t_nodoTercetos *t_tercetos;


//Tabla de simbolos
struct datoTS {
	char *nombre;
	char *tipoDato;
	char *valor;
	char *longitud;
};

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

//Definición funciones de pilas
int vaciarPila(t_pila*);
t_info* desapilar(t_pila*);
void desapilar_str(t_pila*, char*);
int desapilar_nro(t_pila *);
void crearPila(t_pila*);
int apilar(t_pila*,t_info*);
t_info* verTopeDePila(t_pila*);
int pilaVacia (const t_pila*);

//internas del compilador
void insertarTipoDatoEnTS(char*, char*);
int insertarEnNuevaTS(char*,char*,char*,char*);
int existeEnTS(char *);
void guardarTS();
int validarTipoDatoEnTS(char*, char*); 
int ponerValorEnTS(char*, char*);
void invertirComparador(char *);
char* tieneTipoDatoEnTS(char* nombre);


/////////////////VARIABLES///////////////////

t_pila pilaIds;
t_tercetos tercetos;

int contadorElem;
int elemEnLista;
int elemTake;


%}


/*
%union {
    int int_val;
    double float_val;
    char *str_val;
}

%type <str_val> id
%type <str_val> expresion
%type <str_val> termino
%type <str_val> factor
%type <str_val> sentencia
%type <str_val> GET
%type <str_val> DISPLAY
%type <str_val> asignacion
%type <str_val> lista_var
%type <int_val> cte
%type <str_val> cte_String
%type <float_val> cte_Real
*/

%token DIGITO
%token LETRA

%token CTE
%token ID
%token TAKE
%token WRITE
%token READ
%token PA
%token PC
%token ASIGNA
%token MAS
%token CTE_S
%token CA
%token CC
%token PYC
%token COMA


%%

prog:
    sent {printf("\nRegla 1\n");}
    | prog sent {printf("Regla 2\n");}
    ;

sent:
    read {printf("Regla 3\n");}
    | asig {printf("Regla 3\n");}
    | write {printf("Regla 3\n");}
    ;

asig:
    ID ASIGNA take {printf("Regla 4\n");}
    ;

read:
    READ ID {printf("Regla 5\n");}
    ;

take:
    TAKE PA MAS PYC CTE 
    {
        printf("Regla 6\n");
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
        /*if(elemEnLista < elemTake)
        {
            printf("Error: El número de elementos en la lista es menor al indicado para operar");
            exit(0);
        }*/
    }
    PC
    ;

lista:
    CTE
    {
        printf("Regla 7\n");
        /*contadorElemAOperar=1; 
        lp=insertarTerceto(id, "", "");
        elemEnLista=1;*/
    }
    | lista COMA CTE
    {
        printf("Regla 8\n");
        /*if(contadorElemAOperar < elemTake)
        {
            lp=insertarTerceto(op, lp, insertarTerceto (CTE, "", ""));
            contadorElemAOperar++;
        }
        elemEnLista++;*/
    }
    ;

write:
    write CTE_S {printf("Regla 9\n");}
    | write ID {printf("Regla 10\n");}
    ;

%%


/////////////////////////////////////MAIN Y ERROR/////////////////////////////////////

int main(int argc,char *argv[])
{ 
  //char cadena[] = "ID";
  //int value = 0;
  //fprintf(archTabla,"%s\n","NOMBRE\t\t\tTIPODATO\t\tVALOR");
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
    printf("Iniciando main\n");
    crearPila(&pilaIds);
    //crearPila(&pilaFactorial);
    //crearPolaca(&polaca);
    //crearPila(&pilaCMP);
    //crearPila(&pilaTipoDato);
    yyparse();
  }
  //guardarPolaca(&polaca);
  
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

    insertarEnNuevaTS(char* nombre, char* tipoDato, char* valor, char* longitud){
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



/////////////////////////////////////FUNCIONES DE PILA/////////////////////////////////////

void crearPila(t_pila* p){
		*p=NULL;
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

t_info* verTopeDePila(t_pila* p)
{   if(*p==NULL)
    return(0); 

	  t_info* info;

    *info =(*p)->info;

    return(info);
}

int pilaVacia (const t_pila* p)
{
    return *p==NULL;
}