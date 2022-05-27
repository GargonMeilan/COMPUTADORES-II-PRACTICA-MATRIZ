.module	ImprimirNum
;Biblioteca de impresion de numeros(complementaria de print.asm)

teclado	.equ	0xFF02
pantalla	.equ	0xFF00

	.globl	imprimir_Num

; imprime_decimal
;	imprime en decimal el numero contenido en D interpretado sin signo
;
;	Entrada: D -> Numero de 16 bit sin signo
;	Salida: ninguna
;	Registros afectados: D y CC
imprimir_Num:
	pshs	x,y	

	ldx	#0x0000		; para almacenar d
	ldy	#0x0000		; para almacenar d

;Se mete la variable primera en la pila de usuario
	



;Tercera CIFRA	

centenas_cifra:

;Le resta 100 en 100 hasta dar C 
	subd	#100
	bcs	imprime_centenas_cifra
	exg	d,x
	incb	
	exg	d,x	
	bra	centenas_cifra


imprime_centenas_cifra:

	exg	d,x
	tstb	
	bne	imprime_centenas
	; es 0	
	exg	d,y	
	tstb
	exg	d,y
	beq	centenas_cero
	;Si es 0 es no ha habido una cifra


imprime_centenas:

	addb	#'0
	stb	pantalla
	exg	d,y
	incb
	exg	d,y


centenas_cero:

	exg	d,x
	;Se le añade lo que no debio de ser restado	
	addd	#100
	;Contador a 0
	exg	d,x
	ldd	#0
	exg	d,x



;Segunda CIFRA	

decenas_cifra:

;Le resta 10 en 10 hasta dar C 
	subd	#10
	bcs	imprime_decenas_cifra
	exg	d,x
	incb	
	exg	d,x	
	bra	decenas_cifra


imprime_decenas_cifra:

	exg	d,x
	tstb	
	bne	imprime_decenas
	; es 0	
	exg	d,y	
	tstb
	exg	d,y
	beq	decenas_cero
	;Si es 0 es no ha habido una cifra


imprime_decenas:
	addb	#'0
	stb	pantalla
	exg	d,y
	incb
	exg	d,y


decenas_cero:
	exg	d,x

	; se le añade lo que no debio de ser restado	
	addd	#10
	; contador a 0
	exg	d,x
	ldd	#0
	exg	d,x

;Primera cifra

unidades:
	subd	#1
	bcs	imprime_unidades
	exg	d,x
	incb	
	exg	d,x
	bra	unidades


imprime_unidades:
	exg	d,x
	addb	#'0
	stb	pantalla
	exg	d,x
	
	
	; RETORNO
	puls 	x,y
	rts
