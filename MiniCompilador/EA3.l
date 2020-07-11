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



TAKE                "TAKE"|"take"
WRITE               "WRITE"|"write"
READ                "READ"|"read"
PA                  "("
PC                  ")"
ASIGNA              "="
MAS                 "+"
CA                  "["
CC                  "]"
PYC                 ";"
COMA		        ","

DIGITO              [0-9]
LETRA               [a-zA-Z]

CTE                 {DIGITO}+
ID                  {LETRA}({LETRA}|{DIGITO})*

DELIM               [ \t\r]
CARACTER_ESPECIAL   [=|>|<|:|\+|-|\*|/|\?|¿|!|¡|\(|\)|@|%|#|&|°|´|\^|`|~|/|\\|-|_|\.|,|;|¬|\|á|é|í|ó|ú|ü|\']
VALID_STRING        ({LETRA}+|{DELIM}|{CARACTER_ESPECIAL})+
CTE_S               \"{VALID_STRING}\"


%%

{TAKE}              {return TAKE;}
{WRITE}             {return WRITE;}
{READ}              {return READ;}
{PA}                {return PA;}
{PC}                {return PC;}
{ASIGNA}            {return ASIGNA;}
{MAS}               {return MAS;}
{CA}                {return CA;}
{CC}                {return CC;}
{PYC}               {return PYC;}
{COMA}		        {return COMA;}

{ID}                {
                        yylval.str_val = strdup(yytext); 
                        //char *nombreId = (char*) malloc(sizeof(yytext)+1);
                        char *nombreId = (char*) malloc(50*sizeof(char));
                        sprintf(nombreId,"_%s",yylval.str_val);

                        //if(existeEnTS(yytext)==0)
                        //insertarEnNuevaTS(nombreId,"","","");

                        return ID;
                    }   

{CTE_S}             { 			
                        yylval.str_val = strdup(yytext);
                        if(strlen(yytext) <= 100) 
                        {
                            //char *longitudString = (char*) malloc(sizeof(yytext)+1);
                            char *longitudString = (char*) malloc(50*sizeof(char));
                            //char *nombreString = (char*) malloc(sizeof(yytext)+1);
                            char *nombreString = (char*) malloc(50*sizeof(char));
                            sprintf(nombreString,"_%s",yytext);
                            sprintf(longitudString,"%d",strlen(yytext));
                            //if(existeEnTS(yytext)==0)
                            //insertarEnNuevaTS(nombreString,"Cte_S",yylval.str_val,longitudString); 
                            
                            printf("Texto capturado: %s",yytext);

                                return CTE_S;
                        } else {
                                printf("ERROR - Constante string muy larga. Maximo 100 caracteres\n");
                                system ("Pause");
                                exit(3);
                        }
                    }	

{CTE}               {  
                        yylval.int_val = atoi(yytext);
							if(atoi(yytext) <= TOPE_ENTERO){
                                //char *valorEntero = (char*) malloc(sizeof(yytext));
                                char *valorEntero = (char*) malloc(50*sizeof(char));
                                //char *nombreEntero = (char*) malloc(sizeof(yytext)+1);
                                char *nombreEntero = (char*) malloc(50*sizeof(char));
                                sprintf(valorEntero,"%d",atoi(yytext));
                                sprintf(nombreEntero,"_%s",valorEntero);

                                //if(existeEnTS(yytext)==0)
  								//	insertarEnNuevaTS(nombreEntero,"Cte",valorEntero,""); 
									
                                return CTE; 
							}else{
									printf("ERROR - Int fuera de rango.\n");
									system ("Pause");
									exit(1);
							}
                    }

%%