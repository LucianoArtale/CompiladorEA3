include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@cte_string2 db "El resultado es: ", '$', 30 dup (?)
@cte_string1 db "Ingrese un digito del uno al veinte: ", '$', 30 dup (?)
@cte_int5 dd 5
@cte_int4 dd 4
@cte_int3 dd 3
@cte_int2 dd 2
@cte_int1 dd 1
_resu dd ?
_n dd ?
@aux36 dd ?
@aux34 dd ?
@aux29 dd ?
@aux27 dd ?
@aux22 dd ?
@aux20 dd ?
@aux15 dd ?
@aux13 dd ?
@aux8 dd ?
@elemTake dd ?
@elemEnLista dd 5
@cero dd 0
@uno dd 1
@contadorTake dd 0
@resTake dd 0
@error1 db "Error: El numero de elementos a operar debe ser mayor a 0", '$', 30 dup (?)
@error2 db "Error: El numero de elementos en la lista es menor al indicado para operar", '$', 30 dup (?)

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
;READ
	getInteger 	_n,3
	newLine 1
;COMPARACION
	fild 	_n
	fild 	@cero
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jbe 	EtiqError1
;COMPARACION
	fild 	@elemEnLista
	fild 	_n
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jb 	EtiqError2
;ASIGNACION
	fild 	_n
	fistp 	@elemTake
;ASIGNACION
	fild 	@cte_int1
	fistp 	@aux8
;AUMENTAR CONTADOR TAKE
	fild 	@uno
	fiadd 	@contadorTake
	fistp 	@contadorTake
;COMPARACION
	fild 	@contadorTake
	fild 	@elemTake
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jae 	ETIQFINTAKE
;ASIGNACION
	fild 	@cte_int2
	fistp 	@aux13
;SUMA
	fild 	@aux8
	fiadd 	@aux13
	fistp 	@aux15
;ASIGNACION
	fild 	@aux15
	fistp 	@resTake
;AUMENTAR CONTADOR TAKE
	fild 	@uno
	fiadd 	@contadorTake
	fistp 	@contadorTake
;COMPARACION
	fild 	@contadorTake
	fild 	@elemTake
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jae 	ETIQFINTAKE
;ASIGNACION
	fild 	@cte_int3
	fistp 	@aux20
;SUMA
	fild 	@aux15
	fiadd 	@aux20
	fistp 	@aux22
;ASIGNACION
	fild 	@aux22
	fistp 	@resTake
;AUMENTAR CONTADOR TAKE
	fild 	@uno
	fiadd 	@contadorTake
	fistp 	@contadorTake
;COMPARACION
	fild 	@contadorTake
	fild 	@elemTake
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jae 	ETIQFINTAKE
;ASIGNACION
	fild 	@cte_int4
	fistp 	@aux27
;SUMA
	fild 	@aux22
	fiadd 	@aux27
	fistp 	@aux29
;ASIGNACION
	fild 	@aux29
	fistp 	@resTake
;AUMENTAR CONTADOR TAKE
	fild 	@uno
	fiadd 	@contadorTake
	fistp 	@contadorTake
;COMPARACION
	fild 	@contadorTake
	fild 	@elemTake
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jae 	ETIQFINTAKE
;ASIGNACION
	fild 	@cte_int5
	fistp 	@aux34
;SUMA
	fild 	@aux29
	fiadd 	@aux34
	fistp 	@aux36
;ASIGNACION
	fild 	@aux36
	fistp 	@resTake
;AUMENTAR CONTADOR TAKE
	fild 	@uno
	fiadd 	@contadorTake
	fistp 	@contadorTake
;COMPARACION
	fild 	@contadorTake
	fild 	@elemTake
	fxch
 	fcomp
 	fstsw 	ax
 	sahf
 	jae 	ETIQFINTAKE
ETIQFINTAKE:
;ASIGNACION
	fild 	@resTake
	fistp 	_resu
;WRITE
	displayString 	@cte_string2
	newLine 1
;WRITE
	displayInteger 	_resu,3
	newLine 1
	jmp 	ETIQFINPROG
;ERROR 1
EtiqError1:
	displayString 	@error1
	newLine 1
	jmp 	ETIQFINPROG
;ERROR 2
EtiqError2:
	displayString 	@error2
	newLine 1
	jmp 	ETIQFINPROG

ETIQFINPROG:

	MOV EAX, 4c00h
	INT 21h
END MAIN

;FIN DEL PROGRAMA DE USUARIO
