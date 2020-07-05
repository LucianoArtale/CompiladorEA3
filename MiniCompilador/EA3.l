%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#define TOPE_ENTERO 65536
#define TOPE_REAL 4294967296
FILE  *yyin;  
%}
%option noyywrap  
%option yylineno 


DIGITO              [0-9]
LETRA               [a-zA-Z]

CTE                 {DIGITO}+
ID                  {LETRA}({LETRA}|{DIGITO})*
TAKE                "TAKE"|"take"
WRITE               "WRITE"|"write"
READ                "READ"|"read"
PA                  "("
PC                  ")"
ASIGNA              "="
MAS                 "+"
DELIM               [ \t\r]
CARACTER_ESPECIAL   [=|>|<|:|\+|-|\*|/|\?|¿|!|¡|\(|\)|@|%|#|&|°|´|\^|`|~|/|\\|-|_|\.|,|;|¬|\|á|é|í|ó|ú|ü|\']
PALABRA             ({LETRA}|{DIGITO})+
VALID_STRING        ({PALABRA}|{DELIM}|{CARACTER_ESPECIAL})+
CTE_S               \"{VALID_STRING}\"
CA                  "["
CC                  "]"
PYC                 ";"
COMA		        ","


%%
{DIGITO}            {return DIGITO;}
{LETRA}             {return LETRA;}

{CTE}               {return CTE;}
{ID}                {return ID;}
{TAKE}              {return TAKE;}
{WRITE}             {return WRITE;}
{READ}              {return READ;}
{PA}                {return PA;}
{PC}                {return PC;}
{ASIGNA}            {return ASIGNA;}
{MAS}               {return MAS;}
{CTE_S}             {return CTE_S;}
{CA}                {return CA;}
{CC}                {return CC;}
{PYC}               {return PYC;}
{COMA}		        {return COMA;}


{ID}                {
                        yylval.str_val = yytext; 
                        char *nombreId = (char*) malloc(sizeof(yytext)+1);
                        sprintf(nombreId,"_%s",yylval.str_val);

                        if(existeEnTS(yytext)==0)
                        insertarEnNuevaTS(nombreId,"","","");

                        return ID;
                    }   

{CTE_S}             { 			
                        yylval.str_val = strdup(yytext);
                        if(strlen(yytext) <= 30) {
                            char *longitudString = (char*) malloc(sizeof(yytext)+1);
                            char *nombreString = (char*) malloc(sizeof(yytext)+1);
                            sprintf(nombreString,"_%s",yytext);
                            sprintf(longitudString,"%d",strlen(yytext));
                            if(existeEnTS(yytext)==0)
                            insertarEnNuevaTS(nombreString,"Cte_S",yylval.str_val,longitudString); 
                            
                            printf("Texto capturado: %s",yytext);

                                return CTE_S;
                        } else {
                                printf("ERROR - Constante string muy larga. Maximo 30 caracteres\n");
                                system ("Pause");
                                exit(3);
                        }
                    }	

{CTE}               {  
                        yylval.int_val = atoi(yytext);
							if(atoi(yytext) <= TOPE_ENTERO){
                                char *valorEntero = (char*) malloc(sizeof(yytext));
                                char *nombreEntero = (char*) malloc(sizeof(yytext)+1);
                                sprintf(valorEntero,"%d",atoi(yytext));
                                sprintf(nombreEntero,"_%s",valorEntero);

                                if(existeEnTS(yytext)==0)
  									insertarEnNuevaTS(nombreEntero,"Cte",valorEntero,""); 
									
                                return CTE; 
							}else{
									printf("ERROR - Int fuera de rango.\n");
									system ("Pause");
									exit(1);
							}
                    }

%%