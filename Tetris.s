# Versión incompleta del tetris 
# Sincronizada con tetris.s:r3150
        
	.data	
pantalla:
	.word	0
	.word	0
	.space	1024

campo:
	.word	0
	.word	0
	.space	1024

pieza_actual:
	.word	0
	.word	0
	.space	1024

pieza_actual_x:
	.word 0

pieza_actual_y:
	.word 0

imagen_auxiliar:
	.word	0
	.word	0
	.space	1024

pieza_jota:
	.word	2
	.word	3
	.ascii		"\0#\0###\0\0"

pieza_ele:
	.word	2
	.word	3
	.ascii		"#\0#\0##\0\0"

pieza_barra:
	.word	1
	.word	4
	.ascii		"####\0\0\0\0"

pieza_zeta:
	.word	3
	.word	2
	.ascii		"##\0\0##\0\0"

pieza_ese:
	.word	3
	.word	2
	.ascii		"\0####\0\0\0"

pieza_cuadro:
	.word	2
	.word	2
	.ascii		"####\0\0\0\0"

pieza_te:
	.word	3
	.word	2
	.ascii		"\0#\0###\0\0"

piezas:
	.word	pieza_jota
	.word	pieza_ele
	.word	pieza_zeta
	.word	pieza_ese
	.word	pieza_barra
	.word	pieza_cuadro
	.word	pieza_te
acabar_partida:
	.byte	0
	.align	2
procesar_entrada.opciones:
	.byte	'x'
	.space	3
	.word	tecla_salir
	.byte	'j'
	.space	3
	.word	tecla_izquierda
	.byte	'l'
	.space	3
	.word	tecla_derecha
	.byte	'k'
	.space	3
	.word	tecla_abajo
	.byte	'i'
	.space	3
	.word	tecla_rotar
	.byte	't'
	.space	3
	.word	tecla_truco

str000:
	.asciiz		"Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opción:\n"
str001:
	.asciiz		"\n¡Adiós!\n"
str002:
	.asciiz		"\nOpción incorrecta. Pulse cualquier tecla para seguir.\n"

cadena_caract:
	.space 256

puntuacion:
	.word 0
puntuacion_cadena:
	.asciiz	"PUNTUACION:"	
	
fin_de_partida:
	.asciiz "+------------------+|  FIN DE PARTIDA  ||  Pulse una tecla |+------------------+"

	
pieza_sig:
	.word	0
	.word	0
	.space	1024
		
pieza_sig1:
	.asciiz	"+------+"
pieza_sig2:
	.asciiz "|      |"
	
	.text		
nueva_pieza_siguiente:
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)
	jal	pieza_aleatoria
	
	la	$a0,pieza_sig
	move	$a1,$v0
	jal	imagen_copy
	
	lw	$ra,0($sp)
	addiu	$sp,$sp,4	
	jr	$ra
	
mostrar_la_pieza_siguiente:
	addiu	$sp,$sp,-8
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	
	la	$a0,pantalla
	li	$a1,17
	li	$a2,4
	la	$a3,pieza_sig1	
	jal	imagen_dibuja_cadena
	
	la	$a0,pantalla
	li	$a1,17
	li	$a2,9
	la	$a3,pieza_sig1	
	jal	imagen_dibuja_cadena
	
	la	$a0,pantalla
	li	$a1,17
	li	$a2,5
	la	$a3,pieza_sig2	
	jal	imagen_dibuja_cadena
	
	la	$a0,pantalla
	li	$a1,17
	li	$a2,6
	la	$a3,pieza_sig2	
	jal	imagen_dibuja_cadena
	
	la	$a0,pantalla
	li	$a1,17
	li	$a2,7
	la	$a3,pieza_sig2	
	jal	imagen_dibuja_cadena
	
	la	$a0,pantalla
	li	$a1,17
	li	$a2,8
	la	$a3,pieza_sig2	
	jal	imagen_dibuja_cadena
	
	la	$a0,pantalla
	la	$a1,pieza_sig
	li	$a2,20
	li	$a3,5
	jal	imagen_dibuja_imagen
	
	lw	$ra,0($sp)
	lw	$s0,4($sp)
	addiu	$sp,$sp,8
	jr	$ra	
	
eliminando_lineas:		#($s0,$s1,$s2)=(i,j,campo->anchura,campo->altura)
	addiu 	$sp,$sp,-20
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	sw	$s2,12($sp)
	sw	$s3,16($sp)
	
	la	$t0,campo
	move	$s2,$a0		#i=desde
	lw	$s3,0($t0)
A3_0:	beqz	$s2,A3_1	
	li	$s1,0
A3_2:	bgt	$s1,$s3,A3_3	
	
	la	$a0,campo
	move	$a1,$s1
	addi	$a2,$s2,-1	
	jal	imagen_get_pixel
	la	$a0,campo
	move	$a1,$s1
	move	$a2,$s2
	move	$a3,$v0
	jal	imagen_set_pixel
	addi	$s1,$s1,1
	j	A3_2

A3_3:	addi	$s2,$s2,-1
	j	A3_0
	
A3_1:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)
	addiu	$sp,$sp,20
	jr	$ra

completado_lineas:
	# $s0=i $s1=j $s2=campo->anchura $s3=campo->altura
	
	addiu	$sp,$sp,-20
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	sw	$s2,12($sp)
	sw	$s3,16($sp)
	
	la	$t0,campo
	lw	$s2,0($t0)
	lw	$s3,4($t0)
	li	$s0,0
A2_0:	bge	$s0,$s3,A2_5
	li	$s1,0
A2_1:	bge	$s1,$s2,A2_4
	la	$a0,campo
	move	$a1,$s1
	move	$a2,$s0
	jal	imagen_get_pixel
	bnez	$v0,A2_2
A2_3:	addi	$s0, $s0, 1		#i++
	j	A2_0
A2_2:	addi	$s1,$s1,1
	j	A2_1
A2_4:	
	lw	$t0,puntuacion
	addi	$t0,$t0,10
	sw	$t0,puntuacion
	move	$a0,$s0
	jal	eliminando_lineas
	
	addi	$s0,$s0,1
	j	A2_0
A2_5:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)
	
	addiu	$sp,$sp,20	
	jr	$ra

final_de_la_partida:
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)
	jal	clear_screen
	la	$a0,pantalla
	li	$a1,20
	li	$a2,22
	li	$a3,32
	jal	imagen_init
	
	la	$a0,pantalla
	li	$a1,0
	li	$a2,5
	la	$a3,fin_de_partida
	jal	imagen_dibuja_cadena
        
	la	$a0,pantalla
	jal 	imagen_print
	
	jal	read_character
	
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra
					
integer_to_string:			# ($a0, $a1, $a2) = (n, buf)
	move    $t0, $a1		# char *p = buff# ($a0, $a1) = (n, buf)
	# for (int i = n; i > 0; i = i / base) {
        move	$t1, $a0		# int i = n
        move	$t6, $t1	   	#Ponemos en t6 el valor original para mantener y luego poder hacer la comparacion			
        abs 	$t1, $t1		#Hacemos el valor absoluto del numero en cuestion 	
 	beqz 	$t1,A1_4		#Si es ugual a 0 sata a B4_4 hace una vez el bucle y luego sigue normal
 	
A1_3:   blez	$t1, A1_me		# si i <= 0 salta el bucle
	li	$t7,10
A1_4:	div	$t1, $t7		# i / base
	mflo	$t1			# i = i / base
	mfhi	$t2			# d = i % base

	blt	$t2, 10, A1_6		#Salta a B4_6 si la es menor que 0 y asi no suma y va en base 10
	bge	$t2, 10, A1_5		#Salta a B4_6 si es mayor o igual que 10 para hacerlo en base 10
A1_5:	addiu 	$t2, $t2, 7		#Solo suma 7 porque es la diferencia entre el caracter ASCII que vale 48 y 55, 55 porque 65 es la A y le tienes que restar 10
A1_6:	addiu	$t2, $t2, '0'		# d + '0'
	sb	$t2, 0($t0)		# *p = $t2 
	addiu	$t0, $t0, 1		# ++p
	j	A1_3			# sigue el bucle
        # }
        
A1_me:  bgez  	$t6, A1_7		#Salto a B7 si el valor es mayor que 0 es decir si es negativo se hace las 3 lineas si no sigue hacia abajo
	addi	$t5, $zero,'-'		#Añadimos el signo - para ponerlo
	sb	$t5, 0($t0)		#Ponemos en memoria el signo -
	addiu	$t0, $t0, 1		#p++
        
        
A1_7:	sb	$zero, 0($t0)		# *p = '\0'
	addi	$t0,$t0,-1		# accedemos al elemento anterior a la marca de fin
	move 	$t9,$a1			# movemos el contenido del registro de entrada a el temporal 9
	
A1_8:	ble 	$t0,$t9, A1_10		# salta si es menor o igual
	lb	$t3,0($t0)		# movemos el contenido apuntado por el t0 a t3 pasamos a registro 
	lb 	$t4,0($t9)		# pasamos a registro lo que tenemos en memoria con t4 
	sb	$t3,0($t9)		# cargamos de registro a memoria
	sb	$t4,0($t0)		# cargamos de registro a memoria
	addi	$t0,$t0,-1		#restamos uno al puntero $t0, para ir retrocediendo
	addi 	$t9,$t9,+1		#sumamos uno al puntero $t9 para avanzar en la siguiente posción de memoria
	j	A1_8			#salta para seguir con el bucle
				
A1_10:	jr	$ra
	
imagen_dibuja_cadena:			#($a0,$a1,$a2,$a3)=(Imagen*Img,coordenada x, coordenada y, char*c)
	addi 	$sp,$sp,-20		#($s0,$s1,$s2,$s3)=(*c,x,y,char*c)
	sw   	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	sw	$s2,12($sp)
	sw	$s3,16($sp)
	lb	$s0,0($a3)
	move	$s1,$a1
	move	$s2,$a2
	move	$s3,$a3
A0_1:	
	lb	$s0,0($s3)
	beq	$s0,'\0',A0_0
	la	$a0,pantalla
	move	$a1,$s1
	move	$a2,$s2
	move	$a3,$s0
	jal 	imagen_set_pixel
	addi	$s1,$s1,1
	addi	$s3,$s3,1
	j	A0_1
	
A0_0:	lw 	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)

	addi 	$sp,$sp,20
	jr 	$ra

imagen_pixel_addr:			# ($a0, $a1, $a2) = (imagen, x, y)
					# pixel_addr = &data + y*ancho + x
    	lw	$t1, 0($a0)		# $a0 = dirección de la imagen 
					# $t1 ? ancho
    	mul	$t1, $t1, $a2		# $a2 * ancho
    	addu	$t1, $t1, $a1		# $a2 * ancho + $a1
    	addiu	$a0, $a0, 8		# $a0 ? dirección del array data
    	addu	$v0, $a0, $t1		# $v0 = $a0 + $a2 * ancho + $a1
    	jr	$ra

imagen_get_pixel:			# ($a0, $a1, $a2) = (img, x, y)
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
	jal	imagen_pixel_addr	# (img, x, y) ya en ($a0, $a1, $a2)
	lbu	$v0, 0($v0)		# lee el pixel a devolver
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

imagen_set_pixel:
	addiu	$sp, $sp, -8
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
	sw	$s0, 4($sp)		# guardamos $s7 porque haremos un jal
	move 	$s0,$a3
	jal	imagen_pixel_addr	# (img, x, y) ya en ($a0, $a1, $a2)
	sb	$s0, 0($v0)		# escribe el pixel a devolver				
					#ya que recibimos en a3 el pixel
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra
	
imagen_clean:				#imagen_clean($a0,$a1)=imagen_clean(Imagen *img, Pixel fondo)
	addiu	$sp, $sp, -28
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
	sw	$s7, 4($sp)		# el pixel con el que vamos a rellenar | lo recibimos en $a1
	sw	$s6, 8($sp)		# la y del bucle que avanza
	sw	$s5, 12($sp)		# la x del bucle que avanza
	sw	$s4, 16($sp)		# el ancho de la pantalla que compararemos
	sw	$s3, 20($sp)		# el alto de la pantalla que compararemos 
	sw	$s2, 24($sp)		# reserva memoria para el puntero del pixel, porque lo usas en imagen set pixel
	
	move 	$s7, $a1		# el pixel de relleno lo movemos a uno que no es temporal		
	move	$s2, $a0		#Lo guardamos en uno NO temporal el pixel que modificamos
	lw	$s4, 0($s2)		# $s4 ? ancho
	lw 	$s3, 4($s2)		# $s3 ? alto
					
	move 	$s6,$zero		#inicializo y=0 (bucle)

forY:	bge	$s6,$s3,salt		#si y es menor que el ancho de la pantalla hemos terminado y finalizamos saltando a "salt:"
	move 	$s5,$zero		#incicializo x=0 (bucle)
forX:	bge	$s5,$s4,finX		#Mientras que x sea menor que el ancho de la pantalla se hace el bucle
	move	$a0, $s2
	move	$a1, $s5
	move	$a2, $s6
	move	$a3, $s7
	jal 	imagen_set_pixel	
	addi	$s5,$s5,1
	j	forX
finX:	addi	$s6,$s6,1		#vamos sumando 1 a y del bucle 
	j	forY
salt:	lw	$ra, 0($sp)
	lw	$s7, 4($sp)
	lw	$s6, 8($sp)
	lw	$s5, 12($sp)
	lw	$s4, 16($sp)
	lw	$s3, 20($sp)
	lw	$s2, 24($sp)
	addiu	$sp, $sp, 28
	jr	$ra
imagen_init:				#imagen_init($a0,$a1,$a2,$a3)=imagen_init(Imagen *img, int ancho, int alto, Pixel fondo)
	addiu	$sp, $sp, -12		
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
					#A imagen_clean($a0,$a1)=imagen_clean(Imagen *img, Pixel fondo) hay que pasarle dos parámetros
	sw	$s0,4($sp)		#Para Imagen*img
	sw	$s1,8($sp)		#Para PixelFondo
	sw	$a1,0($a0)		#Movemos el ancho dado a la imagen
	sw	$a2,4($a0)		#Movemos el alto dado a la imagen 
	move	$a1,$a3			#Movemos a $a1,$a3 para usarla en la función imagen_clean			
	jal 	imagen_clean		# $a1 está el pixel y en $a0 está la imagen 
	lw	$ra, 0($sp)		
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)				
	addiu	$sp, $sp, 12
	jr	$ra
imagen_copy:
					# ($a0,$a1)=(dst,src)
	addiu   $sp,$sp,-32
	sw	$ra,0($sp)		
	sw	$s0,4($sp)		#guarda la direccion de dst	
	sw	$s1,8($sp)		#guarda la direccion de src
	sw	$s2,12($sp)		
	sw	$s3,16($sp)	
	sw	$s4,20($sp)		#y	
	sw	$s5,24($sp)		#x
	sw	$s6,28,($sp)		
	move	$s0,$a0			
	move	$s1,$a1				
	lw	$t0,0($a1)		# src->ancho;
	sw	$t0,0($s0)		#dst->ancho = src->ancho;
	lw	$t0,4($a1)		# src->alto;
	sw	$t0,4($s0)		#dst->alto = src->alto;
	lw	$s2,0($a1)		# $s2=src->ancho;
	lw	$s3,4($a1)		# $s3=src->alto;

	#for (int y = 0; y < src->alto; ++y)
	li	$s4,0			
forY_1:	beq	$s4,$s3,finY_1
	#for (int x = 0; x < src->ancho; ++x)
	li	$s5,0
forX_1:	beq	$s5,$s2,finX_1
	move	$a0,$s1
	move	$a1,$s5
	move	$a2,$s4
	jal	imagen_get_pixel
	
	move	$s6,$v0			#movemos la salida de imagen_get_pixel a $s6
	move	$a0,$s0
	move	$a1,$s5
	move	$a2,$s4
	move	$a3,$s6
	jal	imagen_set_pixel
	addi	$s5,$s5,1
	j	forX_1
	
finX_1:	addi	$s4,$s4,1
	j	forY_1
			
finY_1:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)
	lw	$s4,20($sp)
	lw	$s5,24($sp)
	lw	$s6,28($sp)
	addiu	$sp,$sp,32
	jr	$ra							
									
imagen_print:				# $a0 = img
	addiu	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a0
	lw	$s3, 4($s0)		# img->alto
	lw	$s4, 0($s0)		# img->ancho
       #  for (int y = 0; y < img->alto; ++y)
	li	$s1, 0			# y = 0
B6_2:	bgeu	$s1, $s3, B6_5		# acaba si y = img->alto
	#    for (int x = 0; x < img->ancho; ++x)
	li	$s2, 0			# x = 0
B6_3:	bgeu	$s2, $s4, B6_4		# acaba si x = img->ancho
	move	$a0, $s0		# Pixel p = imagen_get_pixel(img, x, y)
	move	$a1, $s2
	move	$a2, $s1
	jal	imagen_get_pixel
	move	$a0, $v0		# print_character(p)
	jal	print_character
	addiu	$s2, $s2, 1		# ++x
	j	B6_3
	
	#    } // for x
B6_4:	li	$a0, 10			# print_character('\n')
	jal	print_character
	addiu	$s1, $s1, 1		# ++y
	j	B6_2
	#  } // for y
B6_5:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$ra, 20($sp)
	addiu	$sp, $sp, 24
	jr	$ra

imagen_dibuja_imagen:
				# ($a0,$a1,$a2,$a3)=(dst,src,dst_x,dst_y)
	addiu	$sp,$sp,-36
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	sw	$s2,12($sp)	#x
	sw	$s3,16($sp)	#y
	sw	$s4,20($sp)	#src-ancho
	sw	$s5,24($sp)	#src-alto
	sw	$s6,28($sp)
	sw	$s7,32($sp)	
	
	lw	$s4,0($a1)
	lw	$s5,4($a1)
	
	move	$s0,$a0
	move	$s1,$a1
	move	$s6,$a2		#dst_x
	move	$s7,$a3		#dst_y
	
	#for (int y = 0; y < src->alto; ++y) 
	li	$s3,0
forY_2:	beq	$s3,$s5,finY_2
	#for (int x = 0; x < img->ancho; ++x)
	li	$s2,0
forX_2:	beq	$s2,$s4,finX_2
	move	$a0,$s1
	move	$a1,$s2
	move	$a2,$s3
	jal	imagen_get_pixel
	beqz 	$v0,ifX_2
	move	$a0,$s0
	add	$a1,$s2,$s6
	add	$a2,$s3,$s7
	move 	$a3,$v0
	jal	imagen_set_pixel
	addi	$s2,$s2,1
	j	forX_2
	
ifX_2:	addi	$s2,$s2,1
	j	forX_2
		
finX_2:	addi	$s3,$s3,1	
	j	forY_2
				
finY_2:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	lw	$s2,12($sp)
	lw	$s3,16($sp)
	lw	$s4,20($sp)
	lw	$s5,24($sp)
	lw	$s6,28($sp)
	lw	$s7,32($sp)				
	addiu	$sp,$sp,36
	jr	$ra	

imagen_dibuja_imagen_rotada:
	addiu	$sp,$sp,-36
	sw	$ra,0($sp)
	sw	$s0,4($sp)	# dst
	sw	$s1,8($sp)	# src
	sw	$s2,12($sp)	# x bucle
	sw	$s3,16($sp)	# y bucle
	sw	$s4,20($sp)	# src->ancho
	sw	$s5,24($sp)	# src->alto
	sw	$s6,28($sp)	# dst_x
	sw	$s7,32($sp)	# dst_y
	
	# (Imagen *dst, Imagen *src, int dst_x, int dst_y) = ($a0,$a1,$a2,$a3)
	move	$s0,$a0		# $s0?dst/$a0
	move	$s1,$a1		# $s1?src/$a1
	lw	$s4,0($a1)	# $s4?src->ancho
	lw	$s5,4($a1)	# $s5?src->alto
	move	$s6,$a2		# $s6?dst_x
	move	$s7,$a3		# $s7?dst_y
		
	# for (int y = 0; y < src->alto; ++y)
	li	$s3,0		# y = 0
forY_3: beq	$s3,$s5,finY_3	
	# for (int x = 0; x < src->ancho; ++x)
	li	$s2,0		# x = 0	
forX_3:	beq	$s2,$s4,finX_3
	move	$a0,$s1		# $a0?src
	move	$a1,$s2		# $a1?x
	move	$a2,$s3		# $a2?y
	jal	imagen_get_pixel
	beqz	$v0,ifX_3	# if (p != PIXEL_VACIO)
	move	$a0,$s0
	
	# dst_x + src->alto - 1 - y
	add	$a1,$s6,$s5	
	addi	$a1,$a1,-1
	sub	$a1,$a1,$s3
	
	# dst_y + x
	add	$a2,$s7,$s2
	move	$a3,$v0
	jal	imagen_set_pixel
	addi	$s2,$s2,1	# x++
	j	forX_3

ifX_3:	addi	$s2,$s2,1	# x++
	j	forX_3
			
finX_3:	addi	$s3,$s3,1 	# y++
	j	forY_3		
	
finY_3:	lw	$ra,0($sp)
	lw	$s0,4($sp)	
	lw	$s1,8($sp)	
	lw	$s2,12($sp)	
	lw	$s3,16($sp)	
	lw	$s4,20($sp)
	lw	$s5,24($sp)
	lw	$s6,28($sp)
	lw	$s7,32($sp)	
	addiu	$sp,$sp,36
	jr	$ra

pieza_aleatoria:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$a0, 0
	li	$a1, 7
	jal	random_int_range	# $v0 ? random_int_range(0, 7)
	sll	$t1, $v0, 2
	la	$v0, piezas
	addu	$t1, $v0, $t1		# $t1 = piezas + $v0*4
	lw	$v0, 0($t1)		# $v0 ? piezas[$v0]
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

actualizar_pantalla:
    	addiu    $sp, $sp, -12
   	sw    	$ra, 8($sp)
    	sw    	$s2, 4($sp)
    	sw    	$s1, 0($sp)
    	la    	$s2, campo
    	la    	$a0, pantalla
   	li    	$a1, ' '
    	jal    imagen_clean        # imagen_clean(pantalla, ' ')
        
    	la    	$a0,pantalla
    	li    	$a1,2	
    	li    	$a2,0
    	la    	$a3,puntuacion_cadena
    	jal     imagen_dibuja_cadena
        
    	lw    	$a0,puntuacion
   	la    	$a1,cadena_caract
    	jal   	integer_to_string
    	jal	mostrar_la_pieza_siguiente
    	
    	la    	$a0,pantalla
    	li    	$a1,13
    	li    	$a2,0
    	la    	$a3,cadena_caract
    	jal    	imagen_dibuja_cadena 
			  		# for (int y = 0; y < campo->alto; ++y) {
  	li    	$s1, 0           		# y = 0
B10_2:  lw    	$t1, 4($s2)       	# campo->alto
    	bge    	$s1, $t1, B10_3        	# sigue si y < campo->alto
   	la    	$a0, pantalla
    	li    	$a1, 0                  	# pos_campo_x - 1
    	addi    $a2, $s1, 2             	# y + pos_campo_y
    	li    	$a3, '|'
    	jal    	imagen_set_pixel    		# imagen_set_pixel(pantalla, 0, y, '|')
    	la    	$a0, pantalla
    	lw    	$t1, 0($s2)        		# campo->ancho
    	addiu   $a1, $t1, 1        	# campo->ancho + 1
    	addiu   $a2, $s1, 2             # y + pos_campo_y
    	li    	$a3, '|'
    	jal    	imagen_set_pixel    # imagen_set_pixel(pantalla, campo->ancho + 1, y, '|')
        addiu   $s1, $s1, 1        # ++y
        j       B10_2
        # } // for y
    # for (int x = 0; x < campo->ancho + 2; ++x) { 
B10_3:  li    	$s1, 0            	# x = 0
B10_5:  lw    	$t1, 0($s2)       	# campo->ancho
        addiu   $t1, $t1, 2             # campo->ancho + 2
        bge    	$s1, $t1, B10_6        	# sigue si x < campo->ancho + 2
    	la    	$a0, pantalla
    	move    $a1, $s1                # pos_campo_x - 1 + x
        lw    	$t1, 4($s2)        	# campo->alto
    	addiu   $a2, $t1, 2        	# campo->alto + pos_campo_y
    	li    	$a3, '-'
    	jal    	imagen_set_pixel    	# imagen_set_pixel(pantalla, x, campo->alto + 1, '-')
    	addiu   $s1, $s1, 1        	# ++x
    	j       B10_5
        # } // for x
B10_6:  la    	$a0, pantalla
    	move    $a1, $s2
    	li   	$a2, 1                  	# pos_campo_x
    	li    	$a3, 2                  	# pos_campo_y
    	jal    	imagen_dibuja_imagen    	# imagen_dibuja_imagen(pantalla, campo, 1, 2)
    	la    	$a0,pantalla
    	la    	$a1,pieza_actual
    	lw    	$t1, pieza_actual_x
    	addiu   $a2, $t1, 1        	# pieza_actual_x + pos_campo_x
    	lw    	$t1, pieza_actual_y
    	addiu   $a3, $t1, 2        	# pieza_actual_y + pos_campo_y
    	jal    	imagen_dibuja_imagen    	# imagen_dibuja_imagen(pantalla, pieza_actual, pieza_actual_x + pos_campo_x, pieza_actual_y + pos_campo_y)
    	jal    	clear_screen        	# clear_screen()
    	la    	$a0, pantalla
    	jal    	imagen_print        	# imagen_print(pantalla)
    	lw    	$s1, 0($sp)
    	lw    	$s2, 4($sp)
    	lw    	$ra, 8($sp)
    	addiu   $sp, $sp, 12
    	jr    	$ra
nueva_pieza_actual:
    	addiu   $sp,$sp,-4
    	sw    	$ra,0($sp)
    	lw    	$t0,puntuacion
    	addi    $t0,$t0,1
    	sw    	$t0,puntuacion

    	la    	$a0,pieza_actual
    	la    	$a1,pieza_sig
    	jal    	imagen_copy
    	jal	nueva_pieza_siguiente
    	la    	$t0,pieza_actual_x
    	la    	$t1,pieza_actual_y
    	li    	$t2,8
    	sw    	$t2,0($t0)
    	sw    	$zero,0($t1)
    	la    	$a0,pieza_actual
    	lw    	$a1,pieza_actual_x
    	lw    	$a2,pieza_actual_y
    	jal    	probar_pieza	
    	lw    	$ra,0($sp)
    	addiu   $sp,$sp,4
    	jr     	$ra
probar_pieza:				# ($a0, $a1, $a2) = (pieza, x, y)
	addiu	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s7, 24($sp)
	sw	$s6, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a2		# y
	move	$s1, $a1		# x
	move	$s2, $a0		# pieza
	li	$v0, 0
	bltz	$s1, B12_13		# if (x < 0) return false
	lw	$t1, 0($s2)		# pieza->ancho
	addu	$t1, $s1, $t1		# x + pieza->ancho
	la	$s4, campo
	lw	$v1, 0($s4)		# campo->ancho
	bltu	$v1, $t1, B12_13	# if (x + pieza->ancho > campo->ancho) return false
	bltz	$s0, B12_13		# if (y < 0) return false
	lw	$t1, 4($s2)		# pieza->alto
	addu	$t1, $s0, $t1		# y + pieza->alto
	lw	$v1, 4($s4)		# campo->alto
	bltu	$v1, $t1, B12_13	# if (campo->alto < y + pieza->alto) return false
	# for (int i = 0; i < pieza->ancho; ++i) {
	lw	$t1, 0($s2)		# pieza->ancho
	beqz	$t1, B12_12
	li	$s3, 0			# i = 0
	#   for (int j = 0; j < pieza->alto; ++j) {
	lw	$s7, 4($s2)		# pieza->alto
B12_6:	beqz	$s7, B12_11
	li	$s6, 0			# j = 0
B12_8:	move	$a0, $s2
	move	$a1, $s3
	move	$a2, $s6
	jal	imagen_get_pixel	# imagen_get_pixel(pieza, i, j)
	beqz	$v0, B12_10		# if (imagen_get_pixel(pieza, i, j) == PIXEL_VACIO) sigue
	move	$a0, $s4
	addu	$a1, $s1, $s3		# x + i
	addu	$a2, $s0, $s6		# y + j
	jal	imagen_get_pixel
	move	$t1, $v0		# imagen_get_pixel(campo, x + i, y + j)
	li	$v0, 0
	bnez	$t1, B12_13		# if (imagen_get_pixel(campo, x + i, y + j) != PIXEL_VACIO) return false
B12_10:	addiu	$s6, $s6, 1		# ++j
	bltu	$s6, $s7, B12_8		# sigue si j < pieza->alto
        #   } // for j
B12_11:	lw	$t1, 0($s2)		# pieza->ancho
	addiu	$s3, $s3, 1		# ++i
	bltu	$s3, $t1, B12_6 	# sigue si i < pieza->ancho
        # } // for i
B12_12:	li	$v0, 1			# return true
B12_13:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s6, 20($sp)
	lw	$s7, 24($sp)
	lw	$ra, 28($sp)
	addiu	$sp, $sp, 32
	jr	$ra


intentar_movimiento:
	# $a0,$a1=x,y
	addi	$sp,$sp,-12
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	
	move	$s0,$a0
	move	$s1,$a1
	
	la	$a0,pieza_actual
	move	$a1,$s0
	move	$a2,$s1
	
	jal	probar_pieza
	beqz	$v0,if_4
	la	$t0,pieza_actual_x
	la	$t1,pieza_actual_y
	sw	$s0,0($t0)
	sw	$s1,0($t1)
	li	$v0,1
	j	fin_4

if_4:	li	$v0,0
	
fin_4:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	addi	$sp,$sp,12
	jr	$ra

bajar_pieza_actual:
	addiu	$sp,$sp,-12
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	
	lw	$s0,pieza_actual_x
	lw	$s1,pieza_actual_y
	move	$a0,$s0
	addi	$a1,$s1,1
	jal	intentar_movimiento
	bnez	$v0,fin_6
	
	la	$a0,campo
	la	$a1,pieza_actual
	move	$a2,$s0
	move	$a3,$s1
	jal	imagen_dibuja_imagen
	jal	nueva_pieza_actual
	
fin_6:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	addi	$sp,$sp,12
	jr	$ra

intentar_rotar_pieza_actual:
	addi	$sp,$sp,-12
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
	
	la	$s0,imagen_auxiliar		# pieza_rotada<-imagen_auxliar
	
	la	$s1,pieza_actual
	lw	$t2,0($s1)			# $t2,Imagen_actual->ancho
	lw	$t3,4($s1)			# $t3,Imagen_actual->alto
	
	move	$a0,$s0
	move	$a1,$t3
	move	$a2,$t2
	li	$a3,0
	jal	imagen_init
	
	move	$a0,$s0
	move	$a1,$s1
	li	$a2,0
	li	$a3,0
	jal	imagen_dibuja_imagen_rotada
	
	move	$a0,$s0
	lw	$a1,pieza_actual_x
	lw	$a2,pieza_actual_y
	jal	probar_pieza
	beqz	$v0,fin_5
	
	move	$a0,$s1
	move	$a1,$s0
	jal	imagen_copy
	
fin_5:	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	addi	$sp,$sp,12
	jr	$ra

tecla_salir:
	li	$v0, 1
	sb	$v0, acabar_partida	# acabar_partida = true
	jr	$ra

tecla_izquierda:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, -1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x - 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_derecha:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, 1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x + 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_abajo:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	bajar_pieza_actual	# bajar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_rotar:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	intentar_rotar_pieza_actual	# intentar_rotar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_truco:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s4, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
       	li	$s4, 18
	#  for (int y = 13; y < 18; ++y) {         
	li	$s0, 13
	#  for (int x = 0; x < campo->ancho - 1; ++x) {
B21_1:	li	$s1, 0
B21_2:	lw	$t1, campo
	addiu	$t1, $t1, -1
	bge	$s1, $t1, B21_3
	la	$a0, campo
	move	$a1, $s1
	move	$a2, $s0
	li	$a3, '#'
	jal	imagen_set_pixel	# imagen_set_pixel(campo, x, y, '#'); 
	addiu	$s1, $s1, 1	# 245   for (int x = 0; x < campo->ancho - 1; ++x) { 
	j	B21_2
B21_3:	addiu	$s0, $s0, 1
	bne	$s0, $s4, B21_1
	la	$a0, campo
	li	$a1, 10
	li	$a2, 16
	li	$a3, 0
	jal	imagen_set_pixel	# imagen_set_pixel(campo, 10, 16, PIXEL_VACIO); 
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s4, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra

procesar_entrada:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s4, 12($sp)
	sw	$s3, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	jal	keyio_poll_key
	move	$s0, $v0		# int c = keyio_poll_key()
        # for (int i = 0; i < sizeof(opciones) / sizeof(opciones[0]); ++i) { 
	li	$s1, 0			# i = 0, $s1 = i * sizeof(opciones[0]) // = i * 8
	la	$s3, procesar_entrada.opciones	
	li	$s4, 48			# sizeof(opciones) // == 5 * sizeof(opciones[0]) == 5 * 8
B22_1:	addu	$t1, $s3, $s1		# procesar_entrada.opciones + i*8
	lb	$t2, 0($t1)		# opciones[i].tecla
	bne	$t2, $s0, B22_3		# if (opciones[i].tecla != c) siguiente iteración
	lw	$t2, 4($t1)		# opciones[i].accion
	jalr	$t2			# opciones[i].accion()
	jal	actualizar_pantalla	# actualizar_pantalla()
B22_3:	addiu	$s1, $s1, 8		# ++i, $s1 += 8
	bne	$s1, $s4, B22_1		# sigue si i*8 < sizeof(opciones)
        # } // for i
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s3, 8($sp)
	lw	$s4, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra

jugar_partida:
    	addiu   $sp, $sp, -12    
    	sw	$ra, 8($sp)
    	sw   	$s1, 4($sp)
    	sw    	$s0, 0($sp)
    	la    	$a0, pantalla
    	li    	$a1, 32
    	li      $a2, 22
    	li	$a3, 32
    	lw    	$t0,puntuacion
    	li    	$t0,0
    	sw    	$t0,puntuacion
    	jal    	imagen_init        	# imagen_init(pantalla, 20, 22, ' ')
   
    	la    	$a0, campo
    	li    	$a1, 14
    	li    	$a2, 18
    	li    	$a3, 0
    	jal    	imagen_init        	# imagen_init(campo, 14, 18, PIXEL_VACIO)
    	jal    	nueva_pieza_siguiente
    	jal    	nueva_pieza_actual    	# nueva_pieza_actual()
 
    	jal	mostrar_la_pieza_siguiente
    	sb    	$zero, acabar_partida    	# acabar_partida = false
   	jal    	get_time        		# get_time()
    	move    $s0, $v0        	# Hora antes = get_time()
    	jal    	actualizar_pantalla    	# actualizar_pantalla()
    	j    	B23_2
        # while (!acabar_partida) { 
B23_2:  lbu    	$t1, acabar_partida
   	bnez    $t1, B23_5        	# if (acabar_partida != 0) sale del bucle
    	jal    	procesar_entrada    	# procesar_entrada()
    	jal    	get_time        	# get_time()
    	move    $s1, $v0        	# Hora ahora = get_time()
    	subu    $t1, $s1, $s0        	# int transcurrido = ahora - antes
    	ble    	$t1, 1000, B23_2    	# if (transcurrido < pausa) siguiente iteración
B23_1:  jal    	completado_lineas
    	jal    	bajar_pieza_actual    	# bajar_pieza_actual()

    	la    	$a0,pieza_actual
    	lw    	$a1,pieza_actual_x
    	lw    	$a2,pieza_actual_y

    	jal    	probar_pieza
    	beqz    $v0,B23_12
    
    	j    	B23_13
B23_12:    
    	jal     final_de_la_partida
    	j    	B23_5
        
B23_13: jal    	actualizar_pantalla    	# actualizar_pantalla()
    	move    $s0, $s1        	# antes = ahora
        j    	B23_2            		# siguiente iteración
           # } 
B23_5:  lw    	$s0, 0($sp)
    	lw    	$s1, 4($sp)
    	lw    	$ra, 8($sp)
    	addiu   $sp, $sp, 12
    	jr    	$ra
    	.globl    main
    

main:					# ($a0, $a1) = (argc, argv) 
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
B24_2:	jal	clear_screen		# clear_screen()
	la	$a0, str000
	jal	print_string		# print_string("Tetris\n\n 1 - Jugar\n 2 - Salir\n\nElige una opción:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '2', B24_1		# if (opc == '2') salir
	bne	$v0, '1', B24_5		# if (opc != '1') mostrar error
	jal	jugar_partida		# jugar_partida()
	j	B24_2
B24_1:	la	$a0, str001
	jal	print_string		# print_string("\n¡Adiós!\n")
	li	$a0, 0
	jal	mips_exit		# mips_exit(0)
	j	B24_2
B24_5:	la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	B24_2
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra			

#
# Funciones de la librería del sistema
#

print_character:
	li	$v0, 11
	syscall	
	jr	$ra

print_string:
	li	$v0, 4
	syscall	
	jr	$ra

get_time:
	li	$v0, 30
	syscall	
	move	$v0, $a0
	move	$v1, $a1
	jr	$ra

read_character:
	li	$v0, 12
	syscall	
	jr	$ra

clear_screen:
	li	$v0, 39
	syscall	
	jr	$ra

mips_exit:
	li	$v0, 17
	syscall	
	jr	$ra

random_int_range:
	li	$v0, 42
	syscall	
	move	$v0, $a0
	jr	$ra

keyio_poll_key:
	li	$v0, 0
	lb	$t0, 0xffff0000
	andi	$t0, $t0, 1
	beqz	$t0, keyio_poll_key_return
	lb	$v0, 0xffff0004
keyio_poll_key_return:
	jr	$ra