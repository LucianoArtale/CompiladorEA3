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
}t_infoTerceto;

typedef struct s_nodoTerceto{
    t_infoTerceto info;
    struct s_nodoTerceto* psig;
}t_nodoTerceto;

typedef t_nodoTerceto *t_terceto;


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
int posicionTerceto;

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

///Contadores y variables
int elemEnLista;
char elemEnListaStr[] = "@elemEnLista";
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

      rdIND = insertarTerceto(&tercetos, "READ", $2, "");

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

      char idTake[] = "_";
      strcat(idTake, $5);
      insertarTerceto(&tercetos, "CMP", idTake, cero);
      insertarTerceto(&tercetos, "BLE", "EtiqError1", "");

      insertarTerceto(&tercetos, "CMP", elemEnListaStr, idTake);
      insertarTerceto(&tercetos, "BLT", "EtiqError2", "");

      insertarTerceto(&tercetos, "=", elemTakeVar, idTake);
    }
    PYC CA lista CC PC 
    {
      printf("\nRegla 6.1\n");

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
      sprintf(strAuxASM,"@aux%d",listaIND);
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

      //asigno el valor de la lista al auxiliar
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

      //asigno el valor de la lista al auxiliar
      sprintf(cteNombre, "@cte_int%d", elemEnLista);
      sprintf(strAuxASM2, "@aux%d", valorListaIND2);
      insertarTerceto(&tercetos, "=", strAuxASM2, cteNombre);

      sprintf(aux2ListaIND,"[%d", valorListaIND2);
      listaIND = insertarTerceto(&tercetos, "+", aux1ListaIND, aux2ListaIND);

      //Apilo el auxiliar 2 del terceto para el ASM
      sprintf(strAuxASM,"@aux%d",valorListaIND2);
      t_info *tInfoAuxASM=(t_info*) malloc(sizeof(t_info));
      if(!tInfoAuxASM)
      {
        return;
      }
      tInfoAuxASM->nro = valorListaIND2;
      tInfoAuxASM->cadena = strAuxASM;
      apilar(&auxiliaresASM, tInfoAuxASM);
      contAuxASM++;

      //Apilo el auxiliar suma del terceto para el ASM
      sprintf(strAuxASM,"@aux%d",listaIND);
      t_info *tInfoAuxASM2=(t_info*) malloc(sizeof(t_info));
      if(!tInfoAuxASM2)
      {
        return;
      }
      tInfoAuxASM2->nro = listaIND;
      tInfoAuxASM2->cadena = strAuxASM;
      apilar(&auxiliaresASM, tInfoAuxASM2);

      contAuxASM++;

      insertarTerceto(&tercetos, "=", resTake, strAuxASM);

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
    }
    ;

%%


/////////////////////////////////////MAIN Y ERROR/////////////////////////////////////

int main(int argc,char *argv[])
{
  posicionTerceto = 1;
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

  t_nodoTerceto* aux;
    
  //Pongo la posicion en el terceto
  int indice = posicionTerceto++;
  nue->info.nro = indice;

  //Asignamos las cadenas al nodo
  strcpy(nue->info.cad1,cad1);
  strcpy(nue->info.cad2,cad2);
  strcpy(nue->info.cad3,cad3);

  //Hacemos que sea el último nodo en la lista de tercetos
  nue->psig=NULL;
      
  while(*p)
  {
      p=&(*p)->psig;
  }
  *p=nue;

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
    
    sprintf(cteStringNom,"cte_string%d", pcs);
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
      }
      numTerceto = strchr(tercera, corchete);
      if(numTerceto!=NULL)
      {
        numTerceto++;
        fprintf(pf,"\tfiadd \t@aux%s\n", numTerceto);
        fprintf(pf,"\tfistp \t@aux%d\n", nro);
      }
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
      fprintf(pf,"\tfild \t%s\n", segunda);
      fprintf(pf,"\tfild \t%s\n", tercera);

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
