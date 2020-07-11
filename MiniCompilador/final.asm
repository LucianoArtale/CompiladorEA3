include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@cte_string2 db "El resultado es: ", '$', 30 dup (?)
@cte_string1 db "Ingrese un digito del uno al veinte: ", '$', 30 dup (?)
@cte_int20 dd 20
@cte_int19 dd 19
@cte_int18 dd 18
@cte_int17 dd 17
@cte_int16 dd 16
@cte_int15 dd 15
@cte_int14 dd 14
@cte_int13 dd 13
@cte_int12 dd 12
@cte_int11 dd 11
@cte_int10 dd 10
@cte_int9 dd 9
@cte_int8 dd 8
@cte_int7 dd 7
@cte_int6 dd 6
@cte_int5 dd 5
@cte_int4 dd 4
@cte_int3 dd 3
@cte_int2 dd 2
@cte_int1 dd 1
@resu dd ?
@n dd ?
@elemEnLista dd 20
@cero dd 0
@uno dd 1
@contadorTake dd 0
@resTake dd 0
@error1 db Error: El numero de elementos a operar debe ser mayor a 0, '$', 30 dup (?)
@error2 db Error: El numero de elementos en la lista es menor al indicado para operar, '$', 30 dup (?)

.CODE

copy proc
	cpy_nxt:
	mov al, [si]
	mov [di], al
	inc si
	inc di
	cmp byte ptr [si],0
	jne cpy_nxt
	ret
	copy endp

MAIN:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX

;WRITE
	displayString 	@cte_string1
	newLine 1
;WRITE
	displayString 	@cte_string1
	newLine 1
;WRITE
	displayInteger 	@resu,3
	newLine 1

	MOV EAX, 4c00h
	INT 21h
END MAIN

;FIN DEL PROGRAMA DE USUARIO
