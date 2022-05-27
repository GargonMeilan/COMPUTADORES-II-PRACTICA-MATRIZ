.module matriz

;Biblioteca creada para manejar la matriz

.globl carga_matriz
.globl imprime_matriz
.globl leer_num
.globl	imprimir_Num
.globl imprimir_cadena
.globl calcular_max
.globl marco

fin		.equ 0xFF01
pantalla .equ 0xFF00
teclado .equ  0xFF02
m .equ 0xF000


;Variables

cadena_data: .asciz "Dato:"
cadena_fila: .asciz "Introduzca la fila donde desea buscar: \n"
cadena_maximo: .asciz "Valor/es maximo/s de la fila: "
posicion: .asciz "Posiciones: "
Marco: .asciz "\nEs Marco \n"
NoMarco: .asciz "\nNO es Marco \n"
flag: .word 0
filN: .byte 0
colN: .byte 0
total: .word 0
fil: .byte 0
col: .byte 0
max: .word 0
maxdir: .word 0
maxcol: .byte 0
abuscar: .byte 0
temp: .word 0 
tot_marco: .word 0
tot_interior: .word 0
salto_columna: .byte 0
salto_fila: .byte 0


;Funciones


carga_matriz:
;Colocacion en la primera direccion de memoria de la matriz
	ldy #m 
	std total
	lda #09
	sta pantalla

	bucle:
		ldx #cadena_data
		jsr	imprimir_cadena
		jsr leer_num
		;numero en registro d
		std ,y++
		lda #09
		sta pantalla	
		ldd flag
		addd #1 
		std flag
		cmpd total
		bne bucle
	
		lda #'\n
		sta pantalla
	rts
		
		
imprime_matriz:		
;Carga de variables y de la direccion de memoria de la matriz 
	sta fil
	stb col
	mul
	std total
	ldy #m 

	bucle_f:
		ldd ,y++
		jsr	imprimir_Num
		lda #09
		sta pantalla
		ldb filN 
		addb #1
		stb filN
		cmpb col
		bne bucle_f
		ldd #0
		stb filN	
		ldb colN
		addb #1
		stb colN
		lda #'\n
		sta pantalla
		cmpb fil
		bne bucle_f	
	rts	



;Esta funcion recorre dos veces la matriz. La primera es para encontrar el valor maximo la segunda para guardarlo 

calcular_max:
;Carga de la direccion de la matriz puesta a cero del flag
	sta fil
	stb col
	mul
	std total
	ldy #m
	ldb #0
	stb colN


	ldx #cadena_fila
	jsr imprimir_cadena
	jsr leer_num
	stb abuscar
	
;Colocacion de la memoria al primer elemento de la fila a leer 
	lda col
	subb #1
	mul
	addd #1
	std temp
	addd temp
	subd #2
	std temp
	leay d,y

	busqueda:
		
		ldb colN
		cmpb col
		beq resultado		
		addd #1		
		stb colN
		
		ldd ,y++
		cmpd max
		bhi cambio
		bra busqueda
		
		fin_max:
			lda #'\n
			sta pantalla
			rts
		
cambio:

	std max
	ldb colN 
	stb maxcol
	bra busqueda
	
resultado: 
	
	ldx #cadena_maximo
	jsr imprimir_cadena
	ldd max
	jsr imprimir_Num
	
;Coloca la memoria en el primer elemento maximo de la columna 
	ldy #m 	
	ldb maxcol
	addb maxcol
	subb #2
	lda #0
	addd temp
	leay d,y
	
	ldb maxcol
	stb colN
	

;Esta funcion comprueba si el elemento maximo se repite en la fila con la que estamos trabajando
		
comprobarSirepite:	
			
	ldd ,y++
	cmpd max
	beq repite
	cont:
	ldb colN
	cmpb col
	beq fin_max
	addb #1
	stb colN
	bra comprobarSirepite


;Cuando el elemento se repite salta a esta funcion para imprimir la posicion exacta del dato
repite:
	
	lda #09
	sta pantalla	
	ldx #posicion
	jsr imprimir_cadena
	clra
	ldb abuscar
	jsr imprimir_Num
	ldb #',
	stb pantalla
	lda #0
	ldb colN
	jsr imprimir_Num
	
	bra cont


;Funcion encargada de comprobar si la matriz introducida es una matriz marco
marco: 
	sta fil
	stb col

;Calculo del salto exacto entre los elemntos de los laterales
	lda #0
	addb col
	subb #2
	std temp

;Carga de la direccion de la matriz
	ldy #m
	ldb #0
	stb colN
	
	
;Saca el total de los valores de la primrera fila de la matriz
	primera_fila: 
		
		ldb colN
		cmpb col
		beq laterales		
		addd #1		
		stb colN
		ldd ,y++
		addd tot_marco
		std tot_marco
		
		bra primera_fila

		laterales:
			lda #0
			sta filN
			ldb fil
			subb #2
			stb salto_fila
							
;Bucle que sigue calculando el valor del marco de lo que llamamos laterales
			bucle_laterales:
				ldb filN
				cmpb salto_fila
				beq ultima_fila
				addb #1
				stb filN
				ldd ,y
				addd tot_marco
				std tot_marco
				ldd temp
				leay d,y
				ldd ,y++
				addd tot_marco
				std tot_marco
				bra bucle_laterales
			
			
				ultima_fila: 
		
					ldb #0
					stb colN
		
					bucle_ultima_fila:
					ldb colN
					cmpb col
					beq interior	
					addd #1		
					stb colN
					ldd ,y++
					addd tot_marco
					std tot_marco
					bra bucle_ultima_fila

interior:
;Coloacion al primer elemento del interior 
	ldy #m
	lda #0
	sta filN
	stb colN
	ldb col
	addb col
	addb #2
	std temp
	leay d,y

;Calculo del numero de elementos interiores que hay por fila
	ldb fil
	subb #2
	stb salto_fila
	ldb col
	subb #2
	stb salto_columna

	bucle_interior:
		ldb #0
		stb colN
		ldb filN
		cmpb salto_fila
		beq fin_marco
		addb #1
		stb filN

		bucle_fila_int:
			ldb colN
			cmpb salto_columna
			beq salta_fila
			addb #1
			stb colN
			ldd ,y++
			addd tot_interior
			std tot_interior
			bra bucle_fila_int
	

			salta_fila:
				leay 4,y
				bra bucle_interior


;Funcion que concluye al calculo de la matriz marco 
fin_marco:
	ldd #0
	ldd tot_marco
	cmpd tot_interior
	bhi esMarco
	ldx #NoMarco
	jsr imprimir_cadena
	bra marcofinal


esMarco:
	ldx #Marco
	jsr imprimir_cadena


marcofinal:
	rts 
