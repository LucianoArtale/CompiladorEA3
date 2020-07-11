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
_resu dd ?
_n dd ?
@aux141 dd ?
@aux139 dd ?
@aux134 dd ?
@aux132 dd ?
@aux127 dd ?
@aux125 dd ?
@aux120 dd ?
@aux118 dd ?
@aux113 dd ?
@aux111 dd ?
@aux106 dd ?
@aux104 dd ?
@aux99 dd ?
@aux97 dd ?
@aux92 dd ?
@aux90 dd ?
@aux85 dd ?
@aux83 dd ?
@aux78 dd ?
@aux76 dd ?
@aux71 dd ?
@aux69 dd ?
@aux64 dd ?
@aux62 dd ?
@aux57 dd ?
@aux55 dd ?
@aux50 dd ?
@aux48 dd ?
@aux43 dd ?
@aux41 dd ?
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
@elemEnLista dd 20
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
;ASIGNACION
	fild 	@cte_int6
	fistp 	@aux41
;SUMA
	fild 	@aux36
	fiadd 	@aux41
	fistp 	@aux43
;ASIGNACION
	fild 	@aux43
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
	fild 	@cte_int7
	fistp 	@aux48
;SUMA
	fild 	@aux43
	fiadd 	@aux48
	fistp 	@aux50
;ASIGNACION
	fild 	@aux50
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
	fild 	@cte_int8
	fistp 	@aux55
;SUMA
	fild 	@aux50
	fiadd 	@aux55
	fistp 	@aux57
;ASIGNACION
	fild 	@aux57
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
	fild 	@cte_int9
	fistp 	@aux62
;SUMA
	fild 	@aux57
	fiadd 	@aux62
	fistp 	@aux64
;ASIGNACION
	fild 	@aux64
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
	fild 	@cte_int10
	fistp 	@aux69
;SUMA
	fild 	@aux64
	fiadd 	@aux69
	fistp 	@aux71
;ASIGNACION
	fild 	@aux71
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
	fild 	@cte_int11
	fistp 	@aux76
;SUMA
	fild 	@aux71
	fiadd 	@aux76
	fistp 	@aux78
;ASIGNACION
	fild 	@aux78
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
	fild 	@cte_int12
	fistp 	@aux83
;SUMA
	fild 	@aux78
	fiadd 	@aux83
	fistp 	@aux85
;ASIGNACION
	fild 	@aux85
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
	fild 	@cte_int13
	fistp 	@aux90
;SUMA
	fild 	@aux85
	fiadd 	@aux90
	fistp 	@aux92
;ASIGNACION
	fild 	@aux92
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
	fild 	@cte_int14
	fistp 	@aux97
;SUMA
	fild 	@aux92
	fiadd 	@aux97
	fistp 	@aux99
;ASIGNACION
	fild 	@aux99
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
	fild 	@cte_int15
	fistp 	@aux104
;SUMA
	fild 	@aux99
	fiadd 	@aux104
	fistp 	@aux106
;ASIGNACION
	fild 	@aux106
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
	fild 	@cte_int16
	fistp 	@aux111
;SUMA
	fild 	@aux106
	fiadd 	@aux111
	fistp 	@aux113
;ASIGNACION
	fild 	@aux113
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
	fild 	@cte_int17
	fistp 	@aux118
;SUMA
	fild 	@aux113
	fiadd 	@aux118
	fistp 	@aux120
;ASIGNACION
	fild 	@aux120
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
	fild 	@cte_int18
	fistp 	@aux125
;SUMA
	fild 	@aux120
	fiadd 	@aux125
	fistp 	@aux127
;ASIGNACION
	fild 	@aux127
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
	fild 	@cte_int19
	fistp 	@aux132
;SUMA
	fild 	@aux127
	fiadd 	@aux132
	fistp 	@aux134
;ASIGNACION
	fild 	@aux134
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
	fild 	@cte_int20
	fistp 	@aux139
;SUMA
	fild 	@aux134
	fiadd 	@aux139
	fistp 	@aux141
;ASIGNACION
	fild 	@aux141
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
