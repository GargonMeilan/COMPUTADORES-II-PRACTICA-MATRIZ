.module print

;Biblioteca para manejar la lectura e impresion de numeros 

.globl imprimir_cadena
.globl leer_num


pantalla .equ 0xFF00
teclado .equ  0xFF02


;Variables

num1: .byte 0
num2: .byte 0
num3: .byte 0
temp: .word 0

imprimir_cadena:	;Esta funcion saca por pantalla cadenas acabadas en '\0' apuntadas por x
	pshs	a
	
	sgte:	
		lda	,x+
		beq	ret_imprimir_cadena
		sta	0xFF00
		bra	sgte

		ret_imprimir_cadena:
			puls	a
rts	


leer_num: 
	
	lda teclado
	suba #48
	sta num1
	lda teclado

	cmpa #'\n
	beq UnNumero

	suba #48
	sta num2
	lda teclado

	cmpa #'\n
	beq DosNumero	

	suba #48
	sta num3
	

	ldb #100
	lda num1
	mul
	
	std temp

	ldb #10
	lda num2
	mul
	addb num3
	addd temp

	bra fin

	UnNumero:
	ldb num1
	lda #0
	bra fin

	DosNumero:
	ldb #10
	lda num1
	mul
	addb num2
	lda #0
	
fin:
rts
