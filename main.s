	.code16
	.text
	.globl main
main:

inicio:
	movw $0x9000, %sp
	xorw %dx, %dx
	movw %dx, %ss			# inicializo el stack, ss:sp = 0x0000:0x9000

	movw $1, %cx				# indice de la iteracion (se repite 4 veces)
	movw $0x7fbe, %bx			# lugar donde comienza la tabla de particiones
	
	xorw %si, %si
	movw $0xb800, %dx
	movw %dx, %es			# inicializo %es:%si para mostrar los caracteres por video mapeado en memoria

######################################################################
########################### MOSTRAR PARTICIONES ############################
######################################################################

bucle_principal:

type:
	addw $0x4, %bx			# voy hasta el byte de tipo de particion
	movb (%bx), %al
	
	cmpb $0, %al				# si es una particion vacia
	je empty_part

	addw $0xa0, %si			# paso a un nuevo renglon de la pantalla
	pushw %si				# PILA: %si
	addw $0x68, %si
	
	cmpb $0x83, %al			# sistema de archivos de "linux"
	je print_linux
	cmpb $0x82, %al			# sistema de archivos de "linux swap/solaris"
	je print_linux_swap
	cmpb $0x85, %al			# sistema de archivos de "linux extendida"
	je print_linux_extend
	cmpb $0x07, %al			# sistema de archivos HPFS/NTFS
	je print_ntfs
	jmp print_unknow			# sistema de archivos desconocido

print_linux:
	movw $0x0778, %es:(%si)		# letra 'x'
	subw $0x2, %si
	movw $0x0775, %es:(%si)		# letra 'u'
	subw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	subw $0x2, %si
	movw $0x0769, %es:(%si)		# letra 'i'
	subw $0x2, %si
	movw $0x076c, %es:(%si)		# letra 'l'
	jmp fin_type

print_linux_swap:
	movw $0x0770, %es:(%si)		# letra 'p'
	subw $0x2, %si
	movw $0x0761, %es:(%si)		# letra 'a'
	subw $0x2, %si
	movw $0x0777, %es:(%si)		# letra 'w'
	subw $0x2, %si
	movw $0x0773, %es:(%si)		# letra 's'
	subw $0x2, %si
	movw $0x072f, %es:(%si)			# letra '/'
	subw $0x2, %si
	movw $0x0778, %es:(%si)		# letra 'x'
	subw $0x2, %si
	movw $0x0775, %es:(%si)		# letra 'u'
	subw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	subw $0x2, %si
	movw $0x0769, %es:(%si)		# letra 'i'
	subw $0x2, %si
	movw $0x076c, %es:(%si)		# letra 'l'
	jmp fin_type
	
print_linux_extend:
	movw $0x0764, %es:(%si)		# letra 'd'
	subw $0x2, %si
	movw $0x0765, %es:(%si)		# letra 'e'
	subw $0x2, %si
	movw $0x0764, %es:(%si)		# letra 'd'
	subw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	subw $0x2, %si
	movw $0x0765, %es:(%si)		# letra 'e'
	subw $0x2, %si
	movw $0x0774, %es:(%si)		# letra 't'
	subw $0x2, %si
	movw $0x0778, %es:(%si)		# letra 'x'
	subw $0x2, %si
	movw $0x0765, %es:(%si)		# letra 'e'
	subw $0x2, %si
	movw $0x0720, %es:(%si)		# letra ' '
	subw $0x2, %si
	movw $0x0778, %es:(%si)		# letra 'x'
	subw $0x2, %si
	movw $0x0775, %es:(%si)		# letra 'u'
	subw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	subw $0x2, %si
	movw $0x0769, %es:(%si)		# letra 'i'
	subw $0x2, %si
	movw $0x076c, %es:(%si)		# letra 'l'
	jmp fin_type
	
print_ntfs:
	movw $0x0753, %es:(%si)		# letra 'S'
	subw $0x2, %si
	movw $0x0746, %es:(%si)		# letra 'F'
	subw $0x2, %si
	movw $0x0754, %es:(%si)		# letra 'T'
	subw $0x2, %si
	movw $0x074e, %es:(%si)		# letra 'N'
	subw $0x2, %si
	movw $0x072f, %es:(%si)			# letra '/'
	subw $0x2, %si
	movw $0x0753, %es:(%si)		# letra 'S'
	subw $0x2, %si
	movw $0x0746, %es:(%si)		# letra 'F'
	subw $0x2, %si
	movw $0x0750, %es:(%si)		# letra 'P'
	subw $0x2, %si
	movw $0x0748, %es:(%si)		# letra 'H'
	jmp fin_type
	
print_unknow:
	movw $0x0777, %es:(%si)		# letra 'w'
	subw $0x2, %si
	movw $0x076f, %es:(%si)			# letra 'o'
	subw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	subw $0x2, %si
	movw $0x076b, %es:(%si)		# letra 'k'
	subw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	subw $0x2, %si
	movw $0x0755, %es:(%si)		# letra 'U'
	jmp fin_type

empty_part:
	pushw %cx				# PILA: cx
	addw $0xc, %bx			# para que apunta a la sig particion dentro de la tabla
	jmp fin_bucle_principal

fin_type:
	popw %si					# obtengo el comienzo del renglon donde estoy en pantalla. PILA:

	subw $0x4, %bx
	movb (%bx), %al			# byte de marca de arranque --> %al
	cmpb $0x80, %al
	jne numero_de_particion
	
boot:							# si es igual muestro el '*' en "Boot"
	addw $0x6, %si
	movw $0x072a, %es:(%si)		# caracter '*'
	subw $0x6, %si

numero_de_particion:
	pushw %cx				# pongo en la pila el contador, para poder usar ese reg. 	PILA: cx
	movb $0x07, %ch
	addb $48, %cl
	addw $0x10, %si			# movimiento relativo al primer caracter del renglon
	movw %cx, %es:(%si)		# muestro el numero de particion
	subw $0x10, %si

start:
	addw $0x2, %bx			# asi apunta al segundo byte del CHS de inicio
	call get_cylinder
	pushw %si				# pongo en la pila la columna de la pantalla. PILA: cx, si
	addw $0x22, %si
	call mostrar_dig
	pop %si					# restauro el si. PILA: cx
	
end:
	addw $0x3, %bx			# asi apunta al segundo byte del CHS del final
	call get_cylinder
	push %si					# PILA:cx, si
	addw $0x34, %si
	call mostrar_dig
	pop %si					# restauro el si. PILA: cx

size:
	push %si					# PILA: cx, si
	movw $4, %cx
	pushw %cx				# indice de la iteracion en %cx, 	PILA: cx, si, cx

	addw $0x5, %bx			# apunta al primer byte de numero de sectores
	movw (%bx), %ax
	addw $0x2, %bx			# apunta  al tercer byte de numero de sectores
	movw (%bx), %dx			# dx:ax <---  size
	addw $0x3c, %si

mostrar_hex:
	movw %si, %di
	subw $0x4, %di			# guardo la pos donde despues poner "0x"
	cmpb $0, %dh				# si comienza en cero, los ignoro
	jne comienzo_no_cero
	
comienzo_cero:
	movw %si, %di				# actualizo la pos donde despues poner "0x"
	addw $0x4, %si
	movb %dl, %dh
	movb %ah, %dl
	movb %al, %ah
	popw %cx				# obtengo el contador de la iteracion para compararlo. PILA: cx, si
	decw %cx
	pushw %cx				# PILA: cx, si, cx
	cmpw $0, %cx
	jne mostrar_hex
	
	addw $0x2, %di			# en caso de q sean todos ceros, muestro "0x0"
	movw $0x0730, %es:(%di)	# caracter '0'
	subw $0x4, %di				
	jmp fin_mostrar_hex

comienzo_no_cero:
	pushw %dx				#PILA: cx, si, cx, dx
	shrb $4, %dh
	call mostrar_dig_hexa
	addw $0x2, %si
	popw %dx					# PILA: cx, si, cx
	call mostrar_dig_hexa
	addw $0x2, %si

	movb %dl, %dh
	movb %ah, %dl
	movb %al, %ah
	
	popw %cx					# PILA: cx, si
	decw %cx
	cmpw $0, %cx
	pushw %cx				# PILA: cx, si, cx
	jne comienzo_no_cero
	
fin_mostrar_hex:
	popw %cx					# PILA: cx, si
	movw %di, %si				# posicion donde agregarle el "0x"
	movw $0x0730, %es:(%si)		# caracter '0'
	addw $0x2, %si
	movw $0x0778, %es:(%si)		# caracter 'x'

	popw %si					# restauro el si. PILA: cx
	addw $0x2, %bx			# apunta a la sig particion dentro de la tabla

fin_bucle_principal:
	popw %cx					# PILA:
	incw %cx
	cmpw $5, %cx
	jne bucle_principal

###############################################################################
################################## FIN MOSTRAR PARTICIONES ###########################
###############################################################################


###############################################################################
########################### MOSTRAR NRO CILINDROS LOGICOS ##############################
###############################################################################


	pushw %es				# guardo el valor que tiene %es
	call leer_parametros_disco
	popw %es					# restauro el valor de %es
	movb %ch, %al
	movb %cl, %ah
	shrb $6, %ah
	addw $1, %ax				# ya que en %ax tengo el max nro de cilindro y le tengo q sumar el numero cero tmb
	pushw %si
	addw $0x144, %si
print_nro_cilindro:
	movw $0x024e, %es:(%si)		# letra 'N'
	addw $0x2, %si
	movw $0x0272, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x026f, %es:(%si)			# letra 'o'
	addw $0x4, %si
	movw $0x0274, %es:(%si)		# letra 't'
	addw $0x2, %si
	movw $0x026f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x0274, %es:(%si)		# letra 't'
	addw $0x2, %si
	movw $0x0261, %es:(%si)		# letra 'a'
	addw $0x2, %si
	movw $0x026c, %es:(%si)		# letra 'l'
	addw $0x4, %si
	movw $0x0263, %es:(%si)		# letra 'c'
	addw $0x2, %si
	movw $0x0269, %es:(%si)		# letra 'i'
	addw $0x2, %si
	movw $0x026c, %es:(%si)		# letra 'l'
	addw $0x2, %si
	movw $0x0269, %es:(%si)		# letra 'i'
	addw $0x2, %si
	movw $0x026e, %es:(%si)		# letra 'n'
	addw $0x2, %si
	movw $0x0264, %es:(%si)		# letra 'd'
	addw $0x2, %si
	movw $0x0272, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x026f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x0273, %es:(%si)		# letra 's'
	addw $0x4, %si
	movw $0x026c, %es:(%si)		# letra 'l'
	addw $0x2, %si
	movw $0x026f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x0267, %es:(%si)		# letra 'g'
	addw $0x2, %si
	movw $0x023a, %es:(%si)		# letra ':'
	addw $0x10, %si
	
	call mostrar_dig				# mostramos el nro guardado en %ax
	popw %si						# restauramos el %si


##################################################################################
########################### FIN MOSTRAR NRO CILINDROS LOGICOS ##############################
##################################################################################


	cmpw $0, %si
	jne leer_tecla
	
no_hay_particiones:
	movw $0x0600, %ax		# tipo de interrupcion en ah (scroll up)
	movw $0x07, %bx			# color de fondo de la nueva porcion de pantalla
	xorw %cx, %cx				# comienzo
	movw $0x184f, %dx			# fin
	int $0x10					# borro la pantalla
	call mostrar_mensaje_error
	
esperar:
	movb $0x86, %ah
	movw $0x001e, %cx
	movw $0x8480, %dx
	int $0x15					# espero 2 seg mientras se muestra el mensaje de error y luego apago el sistema
	jmp salir
	

##################################################################################
################################## DETECTAR TECLAS ####################################
##################################################################################


leer_tecla:
	xorw %ax, %ax
	int $0x16					# leo un caracter del teclado
	cmpb $0x64, %al			# me fijo si es la 'd'
	je delete
	cmpb $0x71, %al			# me fijo si es la 'q'
	je salir
	jmp leer_tecla


###################################################################################
################################# COMANDO DELETE ######################################
###################################################################################

delete:
	pushw %si				# pongo en la pila la pos del ultimo renglon que se mostro. PILA: si
	call resaltar_renglon
	
leer_tecla_en_delete:
	xorw %ax, %ax
	int $0x16					# leo un caracter del teclado (obtengo en ah = scancode y al = ascii)
	cmpb $0x48, %ah			# me fijo si es la tecla arriba ( usando su scancode)
	je tecla_arriba
	cmpb $0x50, %ah			# me fijo si es la tecla abajo ( usando su scancode)
	je tecla_abajo
	cmpb $0xd, %al			# me fijo si es 'ENTER' (usando su ASCII)
	je tecla_enter
	cmpb $0x71, %al			# me fijo si es la 'q' (usando su ASCII)
	je salir
	jmp leer_tecla_en_delete
	
tecla_arriba:
	cmpw $0xa0, %si			# es decir, si estoy en el primer renglon, no sigo para arriba
	je leer_tecla_en_delete
	call sacar_resaltado
	subw $0xa0, %si
	call resaltar_renglon
	jmp leer_tecla_en_delete
	
tecla_abajo:
	popw %cx					# guardo en cx la pos del ultimo renglon q se mostro. PILA: 
	cmpw %cx, %si				# los comparo y me fijo si estoy en el ultimo renglon mostrado
	pushw %cx					# guardo nuevamente la pos del ultimo renglon. PILA: cx
	je leer_tecla_en_delete			# si es el ultimo renglon, vuelvo a leer otra tecla sin hacer nada
	call sacar_resaltado
	addw $0xa0, %si
	call resaltar_renglon
	jmp leer_tecla_en_delete
		
tecla_enter:
	addw $0x10, %si			# busco el numero de particion que esta en la tabla para saber que particion borrar
	cmpw $0x7031, %es:(%si)			
	je borrar_1ra
	cmpw $0x7032, %es:(%si)			
	je borrar_2da
	cmpw $0x7033, %es:(%si)			
	je borrar_3ra
	cmpw $0x7034, %es:(%si)			
	je borrar_4ta
	jmp salir					# en caso de algun error, apago el sistema
	
borrar_1ra:
	movw $0x7fbe, %bx			# direccion de la primer entrada de la tabla de particiones
	jmp cont_delete
	
borrar_2da:
	movw $0x7fce, %bx			# direccion de la segunda entrada de la tabla de particiones
	jmp cont_delete
	
borrar_3ra:
	movw $0x7fde, %bx			# direccion de la tercera entrada de la tabla de particiones
	jmp cont_delete
	
borrar_4ta:
	movw $0x7fee, %bx			# direccion de la cuarta entrada de la tabla de particiones
	jmp cont_delete

cont_delete:
	call borrar_entrada_de_tabla
	call grabar_nueva_tabla
	
limpiar_pantalla:
	movw $0x0600, %ax
	movw $0x07, %bx
	movw $0x0100, %cx
	movw $0x184f, %dx
	int $0x10					# borro la pantalla

	jmp inicio					# vuelvo al comienzo para imprimir la tabla obtenida


##############################################################################
############################ FIN DE COMANDO DELETE ##################################
##############################################################################


salir:
	movw $0x5307, %ax
	movw $0x0003, %cx
	movw $0x0001, %bx
	int $0x15

	
################################################################################	
############################# FUNCIONES AUXILIARES ####################################
################################################################################


	.globl leer_parametros_disco
leer_parametros_disco:
	movb $0x08, %ah			# funcion de lectura de parametros del disco
	movb $0x80, %dl			# numero de unidad (primer disco duro == 0x80, seg disco duro == 0x81)
	xorw %cx, %cx
	movw %cx, %es			
	xorw %di, %di				#pongo en cero %es:%di
	int $0x13
	ret

	.globl grabar_nueva_tabla
grabar_nueva_tabla:
	movw $0x0301, %ax		# grabar sectores en disco, y cant de sectores a grabar
	xorb %ch, %ch				# 8 bits bajos del numero de cilindros
	movb $1, %cl				# nro de sector(bits0-5),2 bits altos de n° de cilindro(bits 6-7,solo HD)
	xorb %dh, %dh				# Numero de cabeza
	movb $0x80, %dl			# Numero de unidad (primer disco duro == 0x80, seg disco duro == 0x81)
	xorw %bx, %bx
	movw %bx, %es
	movw $0x7e00, %bx		# direccion de la tabla de particiones que modifiq
	int $0x13
	ret


	.globl mostrar_mensaje_error
mostrar_mensaje_error:
	movw $0x0145, %es:(%si)		# letra 'E'
	addw $0x2, %si
	movw $0x0172, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x0172, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x016f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x0172, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x013a, %es:(%si)		# letra ':'
	addw $0x4, %si
	movw $0x0755, %es:(%si)		# letra 'U'
	addw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	addw $0x2, %si
	movw $0x0770, %es:(%si)		# letra 'p'
	addw $0x2, %si
	movw $0x0761, %es:(%si)		# letra 'a'
	addw $0x2, %si
	movw $0x0772, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x0774, %es:(%si)		# letra 't'
	addw $0x2, %si
	movw $0x0769, %es:(%si)		# letra 'i'
	addw $0x2, %si
	movw $0x0774, %es:(%si)		# letra 't'
	addw $0x2, %si
	movw $0x0769, %es:(%si)		# letra 'i'
	addw $0x2, %si
	movw $0x076f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x076e, %es:(%si)		# letra 'n'
	addw $0x2, %si
	movw $0x0765, %es:(%si)		# letra 'e'
	addw $0x2, %si
	movw $0x0764, %es:(%si)		# letra 'd'
	addw $0x4, %si
	movw $0x0764, %es:(%si)		# letra 'd'
	addw $0x2, %si
	movw $0x0769, %es:(%si)		# letra 'i'
	addw $0x2, %si
	movw $0x0773, %es:(%si)		# letra 's'
	addw $0x2, %si
	movw $0x076b, %es:(%si)		# letra 'k'
	ret


	.globl borrar_entrada_de_tabla
borrar_entrada_de_tabla:
	xorw %ax, %ax
loop:
	movw $0, (%bx)
	addw $0x1, %bx
	incw %ax
	cmpw $16, %ax
	jne loop
	ret
	
	
	.globl sacar_resaltado
sacar_resaltado:
	movw %si, %ax
	addw $0x6c, %ax
bucle_:
	movw %es:(%si), %dx
	movb $0x07, %dh
	movw %dx, %es:(%si)
	addw $0x2, %si
	cmpw %si, %ax
	jne bucle_
	subw $0x6c, %si
	ret

	
	.globl resaltar_renglon
resaltar_renglon:
	movw %si, %ax
	addw $0x6c, %ax
bucle:
	movw %es:(%si), %dx
	movb $0x70, %dh
	movw %dx, %es:(%si)
	addw $0x2, %si
	cmpw %si, %ax
	jne bucle
	subw $0x6c, %si
	ret
	

	.globl get_cylinder
get_cylinder:					# toma como argumento el reg %bx que apunta a la entrada de la tabla que tiene el CHS, y devuelve el valor del cilindro correspondiente en %ax
	movb (%bx), %ah
	shrb $6, %ah
	addw $0x1, %bx
	movb (%bx), %al			# en ax tengo el numero de cilindro
	ret


	.globl mostrar_dig
mostrar_dig:					# recibe como argumento el reg %ax donde se encuentra el numero a mostrar(como max tiene 10 bits)
	movb $10, %cl				# divisor en %cl, dividendo en %ax
	divb %cl					# resto --> ah y cociente --> al
	movb $0x07, %dh			# ahora muestro el digito del resto
	movb %ah, %dl
	addb $48, %dl
	movw %dx, %es:(%si)
	subw $0x2, %si
	xorb %ah, %ah
	cmpb $0, %al
	jne mostrar_dig
	ret
	
	
	.globl mostrar_dig_hexa		# muestra los 4bits mas bajos del %dh en forma hexadecimal(IMPORTANTE: se pierde el dato de %dh)
mostrar_dig_hexa:
	movb $0x07, %ch
	andb $0x0f, %dh
	cmpb $10, %dh
	jle continuar				# %dh es menor que 10, es decir que esta entre 0 - 9
	addb $7, %dh				# en caso de ser una letra
continuar:
	addb $48, %dh
	movb %dh, %cl	
	movw %cx, %es:(%si)		# muestro en pantalla el dig hexa
	ret


.org 1536
