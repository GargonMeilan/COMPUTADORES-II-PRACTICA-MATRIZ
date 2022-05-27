;TRABAJO COMPUTADORES II
;EJERCICIO GESTION DE UNA MATRIZ
;Martin Domingo Sánchez 
;Jon García Gozález 


.module trabajo

;Main del trabajo

.globl imprimir_cadena
.globl main
.globl leer_num
.globl carga_matriz
.globl imprimir_Num
.globl imprime_matriz
.globl calcular_max
.globl marco


fin		.equ 0xFF01
pantalla .equ 0xFF00
teclado .equ  0xFF02
m .equ 0xF000


;Variables
fila: .byte 0
columna: .byte 0
elem: .word 0
cadena_filas: .asciz "Introduzca el numero de filas(1 a 99): "
cadena_columnas: .asciz "\nIntroduzca el numero de columnas(1 a 99): "



main: 

;Lecturas de filas
	lds #0xFF00
	ldx #cadena_filas
	jsr imprimir_cadena
	
	jsr leer_num
	stb fila

;Lectura de columnas
	ldx #cadena_columnas
	jsr imprimir_cadena

	jsr leer_num
	stb columna

;Calculo del numero de elementos totales
	lda fila
	ldb columna
	mul
	std elem

;Carga de los elementos de la matriz
	jsr carga_matriz
		
	lda fila
	ldb columna	
	jsr imprime_matriz
	
;Calculo de la matriz marco
	lda fila
	ldb columna
	jsr marco
	


;busqueda del elemento maximo segun la fila 
	lda fila
	ldb columna
	jsr calcular_max


acabar:

	clra
	sta 0xFF01



.area FIJA (ABS)
.org 0xFFFE
.word main



	
	
	
