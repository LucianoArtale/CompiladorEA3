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


///Terceto
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


///Tabla de simbolos              ----->            SACAR
struct datoTS {
	char *nombre;
	char *tipoDato;
	char *valor;
	char *longitud;
};

struct datoTS tablaDeSimbolos[100];
int cantFilasTS = 0;

///Pila
typedef struct
{
    char* cadena;
    int nro;
    //char* tipoDeDato;
}t_info;

typedef struct s_nodoPila
{
    t_info info;
    struct s_nodoPila* sig;
}t_nodoPila;

typedef t_nodoPila *t_pila;





////////////////////FUNCIONES////////////////////

///internas del compilador
int mostrarTS();
void insertarTipoDatoEnTS(char*, char*);
void insertarEnNuevaTS(char*,char*,char*,char*);
int existeEnTS(char *);
void guardarTS();
int validarTipoDatoEnTS(char*, char*); 
int ponerValorEnTS(char*, char*);
char* tieneTipoDatoEnTS(char*);
//char* obtenerNroParaTipoEnTS(char*, char*)

///Definición funciones de pilas
int vaciarPila(t_pila*);
t_info* desapilar(t_pila*);
void desapilar_str(t_pila*, char*);
int desapilar_nro(t_pila *);
void crearPila(t_pila*);
int apilar(t_pila*,t_info*);
t_info* verTopeDePila(t_pila*);
int pilaVacia (const t_pila*);

///Funciones de Tercetos
void crearTerceto(t_terceto*);
int insertarTerceto(t_terceto*, char*, char*, char*);
int guardarTercetos(t_terceto*);

///Assembler
void generarAssembler(t_terceto*);



/////////////////VARIABLES///////////////////

///Tercetos
t_terceto tercetos;
int posicionTerceto; //sacar?

///Pilas
t_pila pilaCteString;
t_pila pilaCteStringTP;
t_pila pilaCteInt;
t_pila pilaVarInt;
t_pila auxiliaresASM;

///Indices
int progIND;
int sentIND;
int asigIND;
int rdIND;
int takeIND;
int listaIND;
int wrtIND;

///otras
//int contadorElemAOperar;
int elemEnLista;
char elemEnListaStr[] = "@elemEnLista";
//int elemTake;
char elemTakeVar[] = "@elemTake";
int contPilaCteString;
int contPilaVarInt;
char resTake[] = "@resTake";
char contadorTake[] = "@contadorTake";
char cero[] = "@cero";
char strAuxASM[] = "@aux";
int contAuxASM;

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

s:
  prog 
  {
    printf("\nRegla 0\n");
  }
  ;


prog:
    sent 
    {
      printf("\nRegla 1\n");

      progIND = sentIND;
    }
    | prog sent 
    {
      printf("\nRegla 2\n");

      progIND = sentIND;
    }
    ;

sent:
    rd 
    {
      printf("\nRegla 3\n");

      sentIND = rdIND;
    }
    | asig 
    {
      printf("\nRegla 3\n");

      sentIND = asigIND;
    }
    | wrt 
    {
      printf("\nRegla 3\n");

      sentIND = wrtIND;
    }
    ;

asig:
    ID ASIGNA take 
    {
      printf("\nRegla 4\n");

      char listaINDStr[MAXINT], varId[] = "_";
      sprintf(listaINDStr,"[%d", listaIND);
      strcat(varId, $1);
      //asigIND = insertarTerceto(&tercetos, "=", varId, listaINDStr);
      asigIND = insertarTerceto(&tercetos, "=", varId, resTake);

      t_info *tInfoVarInt=(t_info*) malloc(sizeof(t_info));
      if(!tInfoVarInt)
      {
        return;
      }
      tInfoVarInt->cadena = $1;
      apilar(&pilaVarInt, tInfoVarInt);
      contPilaVarInt++;
    }
    ;

rd:
    READ ID 
    {
      printf("\nRegla 5\n");

      /*t_info *tInfoPilaId=(t_info*) malloc(sizeof(t_info));
      tInfoPilaId->cadena = (char *) malloc (MAXCAD * sizeof (char));
      strcpy(tInfoPilaId->cadena,$2);
      apilar(&pilaIds,tInfoPilaId);*/

      rdIND = insertarTerceto(&tercetos, "READ", $2, "");
      //printf("READ: %d", rdIND);
      t_info *tInfoVarInt=(t_info*) malloc(sizeof(t_info));
      if(!tInfoVarInt)
      {
        return;
      }
      tInfoVarInt->cadena = $2;
      apilar(&pilaVarInt, tInfoVarInt);
      contPilaVarInt++;
    }
    ;

take:
    TAKE PA MAS PYC ID 
    {
      printf("\nRegla 6\n");

      /*if(CTE > 0)
      {
          elemTake=cte;
      }
      else
      {
          printf("Error: El número de elementos a operar debe ser mayor a 0");
          exit(0);
      }*/

      char idTake[] = "_";
      //sprintf(cero,"%d",0);
      strcat(idTake, $5);
      printf("CMP - %s - %s\n", idTake, cero);
      insertarTerceto(&tercetos, "CMP", idTake, cero);
      insertarTerceto(&tercetos, "BLE", "EtiqError1", "");

      insertarTerceto(&tercetos, "CMP", elemEnListaStr, idTake);
      insertarTerceto(&tercetos, "BLT", "EtiqError2", "");

      insertarTerceto(&tercetos, "=", elemTakeVar, idTake);
    }
    PYC CA lista CC 
    {
      printf("\nRegla 6.1\n");
      /*if(elemEnLista < elemTake)
      {
          printf("Error: El número de elementos en la lista es menor al indicado para operar");
          exit(0);
      }*/
      /*char elemEnListaStr[MAXINT];
      sprintf(elemEnListaStr,"%d",elemEnLista);
      
      insertarTerceto(&tercetos, "CMP", elemEnListaStr, elemTakeVar);
      insertarTerceto(&tercetos, "BGE", "EtiqError2", "");*/

    }
    PC 
    {
      printf("\nRegla 6.2\n");

      takeIND = listaIND;
      insertarTerceto(&tercetos, "ETIQ", "ETIQFINTAKE", "");
    }
    ;

lista:
    CTE
    {
      printf("\nRegla 7\n");

      char numStr[MAXINT];
      sprintf(numStr,"%d",$1);
      listaIND = insertarTerceto(&tercetos, numStr, "", "");

      //Apilo el auxiliar del terceto para el ASM
      //strcpy(strAuxASM, "@aux");
      sprintf(strAuxASM,"@aux%d",listaIND);
      //strcat(strAuxASM, listaINDStr);
      //printf("Numero de terceto por apilarse: %s\n", strAuxASM);
      t_info *tInfoAuxASM=(t_info*) malloc(sizeof(t_info));
      if(!tInfoAuxASM)
      {
        return;
      }
      tInfoAuxASM->nro = listaIND;
      tInfoAuxASM->cadena = strAuxASM;
      apilar(&auxiliaresASM, tInfoAuxASM);
      contAuxASM = 1;

      elemEnLista = 1;

      t_info *tInfoCteInt=(t_info*) malloc(sizeof(t_info));
      if(!tInfoCteInt)
      {
        return;
      }
      tInfoCteInt->nro = $1;
      apilar(&pilaCteInt, tInfoCteInt);

      insertarTerceto(&tercetos, "=", strAuxASM, "@cte_int1");
      //aumentar contador en asm
      insertarTerceto(&tercetos, "CONT++", contadorTake, "");
      //agregar comparacion
      insertarTerceto(&tercetos, "CMP", contadorTake, elemTakeVar);
      insertarTerceto(&tercetos, "BGE", "ETIQFINTAKE", "");
    }
    | lista COMA CTE
    {
      printf("\nRegla 8\n");

      int valorListaIND2;
      char aux1ListaIND[MAXINT], numStr[MAXINT], aux2ListaIND[MAXINT], cteNombre[MAXCAD], strAuxASM2[MAXCAD]; 
      sprintf(aux1ListaIND,"[%d", listaIND);
      sprintf(numStr,"%d",$3);
      valorListaIND2 = insertarTerceto(&tercetos, numStr, "", "");

      elemEnLista++;
      //printf("ACTUALMENTE EN LA LISTA HAY %d ELEMENTOS\n", elemEnLista);
      sprintf(cteNombre, "@cte_int%d", elemEnLista);
      sprintf(strAuxASM2, "@aux%d", valorListaIND2);
      insertarTerceto(&tercetos, "=", strAuxASM2, cteNombre);

      sprintf(aux2ListaIND,"[%d", valorListaIND2);
      listaIND = insertarTerceto(&tercetos, "+", aux1ListaIND, aux2ListaIND);

      //Apilo el auxiliar 2 del terceto para el ASM
      sprintf(strAuxASM,"@aux%d",valorListaIND2);
      //printf("Numero de terceto por apilarse: %s\n", strAuxASM);
      t_info *tInfoAuxASM=(t_info*) malloc(sizeof(t_info));
      if(!tInfoAuxASM)
      {
        return;
      }
      tInfoAuxASM->nro = valorListaIND2;
      tInfoAuxASM->cadena = strAuxASM;
      apilar(&auxiliaresASM, tInfoAuxASM);
      contAuxASM++;

      //asigno el terceto a la var resultado del take
      //insertarTerceto(&tercetos, "=", resTake, strAuxASM);
      //strcpy(strAuxASM2, strAuxASM);

      //Apilo el auxiliar suma del terceto para el ASM
      sprintf(strAuxASM,"@aux%d",listaIND);
      //printf("Numero de terceto por apilarse: %s\n", strAuxASM);
      t_info *tInfoAuxASM2=(t_info*) malloc(sizeof(t_info));
      if(!tInfoAuxASM2)
      {
        return;
      }
      tInfoAuxASM2->nro = listaIND;
      tInfoAuxASM2->cadena = strAuxASM;
      apilar(&auxiliaresASM, tInfoAuxASM2);
      contAuxASM++;

      //insertarTerceto(&tercetos, "=", strAuxASM, strAuxASM2);
      insertarTerceto(&tercetos, "=", resTake, strAuxASM);

      //elemEnLista++;

      t_info *tInfoCteInt=(t_info*) malloc(sizeof(t_info));
      if(!tInfoCteInt)
      {
        return;
      }
      tInfoCteInt->nro = $3;
      apilar(&pilaCteInt, tInfoCteInt);

      //aumento contador take
      insertarTerceto(&tercetos, "CONT++", contadorTake, "");
      //agregar comparacion
      insertarTerceto(&tercetos, "CMP", contadorTake, elemTakeVar);
      insertarTerceto(&tercetos, "BGE", "ETIQFINTAKE", "");
    }
    ;

wrt:
    WRITE CTE_S 
    {
      printf("\nRegla 9\n");

      wrtIND = insertarTerceto(&tercetos, "WRITES", $2, "");
      //printf("WRITE: %d", wrtIND);
      t_info *tInfoCteString=(t_info*) malloc(sizeof(t_info));
      if(!tInfoCteString)
      {
        return;
      }
      tInfoCteString->cadena = $2;
      apilar(&pilaCteString, tInfoCteString);
      contPilaCteString++;
    }
    | WRITE ID 
    {
      printf("\nRegla 10\n");

      wrtIND = insertarTerceto(&tercetos, "WRITEI", $2, "");

      /*t_info *tInfoVarInt=(t_info*) malloc(sizeof(t_info));
      if(!tInfoVarInt)
      {
        return;
      }
      tInfoVarInt->cadena = $2;
      apilar(&pilaVarInt, tInfoVarInt);*/
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
  //elemTake = 20; //                   ->            LUEGO BORRAR
  contPilaCteString = 0;
  contPilaVarInt = 0;

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
    printf("\nIniciando main\n");
    crearPila(&pilaCteString);
    crearPila(&pilaCteInt);
    crearPila(&pilaVarInt);
    crearTerceto(&tercetos);
    printf("Iniciando Parsing\n");
    yyparse();
    printf("Fin Parsing\n");

    printf("---> elemEnLista = %d\n", elemEnLista);
    printf("contPilaCteString = %d\n", contPilaCteString);
    printf("contPilaVarInt = %d\n", contPilaVarInt);

  }
  if(guardarTercetos(&tercetos) < 0)
  {
    printf("\nError generando el archivo de notacion intermedia\n");
    return 0;
  }
  generarAssembler(&tercetos);
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
  //printf("Iniciando insertarTerceto\n");
  t_nodoTerceto* aux;
    
  //Ponemos la posicion en el terceto
  int indice = posicionTerceto++;
  nue->info.nro = indice;
  //printf("posicionTerceto++\n");
  //Asignamos las cadenas al nodo
  strcpy(nue->info.cad1,cad1);
  //printf("cad1 asignada\n");
  strcpy(nue->info.cad2,cad2);
  //printf("cad2 asignada\n");
  strcpy(nue->info.cad3,cad3);
  //printf("cad3 asignada\n");
  //Hacemos que sea el último nodo en la lista de tercetos
  nue->psig=NULL;
  //printf("psig creado\n");
      
  while(*p)
  {
      p=&(*p)->psig;
  }
  *p=nue;
  //printf("p apunta a nue, fin insertarTerceto\n");

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


////////////////////////////////////////////////ASSEMBLER////////////////////////////////////////////////


void generarAssembler(t_terceto *p)
{
  t_nodoTerceto *aux;
  int nro; 
  char *primera;
  char *segunda;
  char *tercera;

  char corchete = '[';
  char *numTerceto;
  int contCteInt = 1;

  FILE* pf=fopen("final.asm","w+");
  if(!pf){
    printf("Error al guardar el archivo assembler.\n");
    exit(1);
  }

  ///INICIO ARCHIVO ASM

  fprintf(pf,"include macros2.asm\n");
  //fprintf(pf,"include macros.asm\n");
  fprintf(pf,"include number.asm\n\n");
  fprintf(pf,".MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n");


  ///DECLARACIONES
  
  int pcs, pci, pvi, paa;
  char cteString[MAXCAD], varInt[MAXCAD], cteStringNom[MAXCAD], auxASM[MAXCAD];


  for(pcs=contPilaCteString; pcs >= 1; pcs--)
  {
    desapilar_str(&pilaCteString, cteString);
    fprintf(pf,"@cte_string%d db %s, '$', 30 dup (?)\n", pcs, cteString);
    
    //printf("Numero a asignarse: %d\n", pcs);
    sprintf(cteStringNom,"cte_string%d", pcs);
    //printf("Nombre a asignarse: %s\n", cteStringNom);
    t_info *tInfoCteStringTP=(t_info*) malloc(sizeof(t_info));
    if(!tInfoCteStringTP)
    {
      return;
    }
    //tInfoCteStringTP->cadena = cteStringNom;
    tInfoCteStringTP->nro = pcs;
    apilar(&pilaCteStringTP, tInfoCteStringTP);
  }

  for(pci=elemEnLista; pci >= 1; pci--)
  {
    fprintf(pf,"@cte_int%d dd %d\n", pci, desapilar_nro(&pilaCteInt));
  }

  for(pvi=contPilaVarInt; pvi >= 1; pvi--)
  {
    desapilar_str(&pilaVarInt, varInt);
    fprintf(pf,"_%s dd ?\n", varInt);
  }

  for(paa=contAuxASM; paa >= 1; paa--)
  {
    //desapilar_str(&auxiliaresASM, auxASM);
    //fprintf(pf,"%s dd ?\n", auxASM);
    fprintf(pf,"@aux%d dd ?\n", desapilar_nro(&auxiliaresASM));
  }

  fprintf(pf,"%s dd ?\n", elemTakeVar);

  fprintf(pf,"@elemEnLista dd %d\n", elemEnLista);

  ///Declaraciones de constantes fijas
  fprintf(pf,"@cero dd 0\n");
  fprintf(pf,"@uno dd 1\n");
  fprintf(pf,"@contadorTake dd 0\n");
  fprintf(pf,"@resTake dd 0\n");
  char error1[] = "Error: El numero de elementos a operar debe ser mayor a 0";
  fprintf(pf,"@error1 db \"%s\", '$', 30 dup (?)\n", error1);
  char error2[] = "Error: El numero de elementos en la lista es menor al indicado para operar";
  fprintf(pf,"@error2 db \"%s\", '$', 30 dup (?)\n", error2);


  ///CODIGO

  fprintf(pf,"\n.CODE\n");

  ///Procedures
  fprintf(pf,"\ncopy proc\n\tcpy_nxt:\n\tmov al, [si]\n\tmov [di], al\n\tinc si\n\tinc di\n\tcmp byte ptr [si],0\n\tjne cpy_nxt\n\tret\n\tcopy endp\n");

  fprintf(pf,"\nMAIN:\n");

  fprintf(pf,"MOV EAX,@DATA\n");
  fprintf(pf,"MOV DS,EAX\n");
  fprintf(pf,"MOV ES,EAX\n\n");

  printf("\n");

  ///Recorrer Tercetos
  while(*p)
  {
    aux = *p;

    ///Obtengo el terceto en partes
    nro = (*p)->info.nro;
    primera = (char *) malloc (sizeof((*p)->info.cad1));
    sprintf(primera,"%s",(*p)->info.cad1);
    segunda = (char *) malloc (sizeof((*p)->info.cad2));
    sprintf(segunda,"%s",(*p)->info.cad2);
    tercera = (char *) malloc (sizeof((*p)->info.cad3));
    sprintf(tercera,"%s",(*p)->info.cad3);

    printf("nro: %d | 1: %s | 2: %s | 3: %s\n", nro, primera, segunda, tercera);

    ///WRITE
    if(strcmpi(primera,"WRITES")==0)
    {
      char cteStringTP[MAXCAD];
      fprintf(pf,";WRITE\n");
      //desapilar_str(&pilaCteStringTP, cteStringTP);
      //fprintf(pf,"\tdisplayString \t@%s\n\tnewLine 1\n", cteStringTP);
      fprintf(pf,"\tdisplayString \t@cte_string%d\n\tnewLine 1\n", desapilar_nro(&pilaCteStringTP));
    }
    else
    {
      if(strcmpi(primera,"WRITEI")==0)
      {
        fprintf(pf,";WRITE\n");
        fprintf(pf,"\tdisplayInteger \t_%s,3\n\tnewLine 1\n", segunda);
      }
    }

    ///READ
    if(strcmpi(primera,"READ")==0)
    {
      fprintf(pf,";READ\n");
      fprintf(pf,"\tgetInteger \t_%s,3\n\tnewLine 1\n",segunda);
    }

    ///ASIGNACION
    if(strcmpi(primera,"=")==0)
    {
      fprintf(pf,";ASIGNACION\n");
      numTerceto = strchr(tercera, corchete);
      if(numTerceto==NULL)
      {
        fprintf(pf,"\tfild \t%s\n", tercera);
      }
      else
      {
        numTerceto++;
        fprintf(pf,"\tfild \t@aux%s\n", numTerceto);
      }
      //fprintf(pf,"\tfild \t%s\n", tercera);
      /*fprintf(pf,"\tfild \t@cte_int%s\n", contCteInt);
      contCteInt++;*/
      numTerceto = strchr(segunda, corchete);
      if(numTerceto==NULL)
      {
        fprintf(pf,"\tfistp \t%s\n", segunda);
      }
      else
      {
        numTerceto++;
        fprintf(pf,"\tfistp \t@aux%s\n", numTerceto);
      }
      //fprintf(pf,"\tfistp \t%s\n", segunda);
    }

    ///SUMA
    if(strcmpi(primera,"+")==0)
    {
      fprintf(pf,";SUMA\n");
      numTerceto = strchr(segunda, corchete);
      if(numTerceto!=NULL)
      {
        numTerceto++;
        fprintf(pf,"\tfild \t@aux%s\n", numTerceto);
        /*fprintf(pf,"\tfild \t@cte_int%s\n", contCteInt);
        contCteInt++;*/
      }
      numTerceto = strchr(tercera, corchete);
      if(numTerceto!=NULL)
      {
        numTerceto++;
        fprintf(pf,"\tfiadd \t@aux%s\n", numTerceto);
        fprintf(pf,"\tfistp \t@aux%d\n", nro);
      }
      //fprintf(pf,"\tfiadd \t%s\n", segunda);
      //fprintf(pf,"\tfistp \t%s\n", segunda);
    }

    ///AUMENTO CONTADOR TAKE
    if(strcmpi(primera,"CONT++")==0)
    {
      fprintf(pf,";AUMENTAR CONTADOR TAKE\n");
      fprintf(pf,"\tfild \t@uno\n");
      fprintf(pf,"\tfiadd \t%s\n", segunda);
      fprintf(pf,"\tfistp \t%s\n", segunda);
    }

    ///ETIQUETAS
    if(strcmpi(primera, "ETIQ")==0)
    {
      fprintf(pf,"%s:\n", segunda);
    }
    

    
    ///COMPARACION
    if(strcmpi(primera,"CMP")==0)
    {
      fprintf(pf,";COMPARACION\n");
      //numTerceto = strchr(segunda, corchete);
      //if(numTerceto==NULL)
      //{
        fprintf(pf,"\tfild \t%s\n", segunda);
      /*}
      else
      {
        fprintf(pf,"\tfild \t@aux%s\n", numTerceto);
      }*/

      //numTerceto = strchr(tercera, corchete);
      //if(numTerceto==NULL)
      //{
        fprintf(pf,"\tfild \t%s\n", tercera);
      /*}
      else
      {
        fprintf(pf,"\tfild \t@aux%s\n", numTerceto);
      }*/

      ///Leo un terceto mas
      *p=(*p)->psig;
      free(aux);
      aux = *p;
      primera = (char *) malloc (sizeof((*p)->info.cad1));
      sprintf(primera,"%s",(*p)->info.cad1);
      segunda = (char *) malloc (sizeof((*p)->info.cad2));
      sprintf(segunda,"%s",(*p)->info.cad2);

      if(strcmpi(primera,"BLE")==0)
      {
        fprintf(pf,"\tfxch\n \tfcomp\n \tfstsw \tax\n \tsahf\n \tjbe \t%s\n", segunda);
      }

      if(strcmpi(primera,"BLT")==0)
      {
        fprintf(pf,"\tfxch\n \tfcomp\n \tfstsw \tax\n \tsahf\n \tjb \t%s\n", segunda);
      }

      if(strcmpi(primera,"BGE")==0)
      {
        fprintf(pf,"\tfxch\n \tfcomp\n \tfstsw \tax\n \tsahf\n \tjae \t%s\n", segunda);
      }
    }

    //printf("Llego al final del while\n");

    *p=(*p)->psig;
    free(aux);
  }

  ///Salto para evitar errores
  fprintf(pf,"\tjmp \tETIQFINPROG\n");

  ///Errores
  fprintf(pf,";ERROR 1\n");
  fprintf(pf,"EtiqError1:\n");
  fprintf(pf,"\tdisplayString \t@error1\n\tnewLine 1\n");
  fprintf(pf,"\tjmp \tETIQFINPROG\n");

  fprintf(pf,";ERROR 2\n");
  fprintf(pf,"EtiqError2:\n");
  fprintf(pf,"\tdisplayString \t@error2\n\tnewLine 1\n");
  fprintf(pf,"\tjmp \tETIQFINPROG\n");


  ///FINAL ARCHIVO ASM

  fprintf(pf,"\nETIQFINPROG:\n");

  fprintf(pf,"\n\tMOV EAX, 4c00h\n\tINT 21h\n");
  fprintf(pf,"END MAIN\n\n;FIN DEL PROGRAMA DE USUARIO\n");

  fclose(pf);

  printf("\n------------ Archivo assembler generado ------------\n");

}
