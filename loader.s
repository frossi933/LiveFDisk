	.code16
	.text
	.globl main
main:

print_start:
	movw $0xb800, %bx			# 0xb8000 comienzo de video mapeado en memoria
	movw %bx, %es
	movw $0x4, %si
	
	movw $0x0442, %es:(%si)		# letra 'B'
	addw $0x2, %si
	movw $0x046f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x046f, %es:(%si)			# letra 'o'
	addw $0x2, %si
	movw $0x0474, %es:(%si)		# letra 't'
	addw $0x6, %si
	
	movw $0x0423, %es:(%si)		# letra '#'
	addw $0xa, %si
	
	movw $0x0453, %es:(%si)		# letra 'S'
	addw $0x2, %si
	movw $0x0474, %es:(%si)		# letra 't'
	addw $0x2, %si
	movw $0x0461, %es:(%si)		# letra 'a'
	addw $0x2, %si
	movw $0x0472, %es:(%si)		# letra 'r'
	addw $0x2, %si
	movw $0x0474, %es:(%si)		# letra 't'
	addw $0xe, %si
	
	movw $0x0445, %es:(%si)		# letra 'E'
	addw $0x2, %si
	movw $0x046e, %es:(%si)		# letra 'n'
	addw $0x2, %si
	movw $0x0464, %es:(%si)		# letra 'd'
	addw $0x10, %si
	
	movw $0x0453, %es:(%si)		# letra 'S'
	addw $0x2, %si
	movw $0x0469, %es:(%si)		# letra 'i'
	addw $0x2, %si
	movw $0x047a, %es:(%si)		# letra 'z'
	addw $0x2, %si
	movw $0x0465, %es:(%si)		# letra 'e'
	addw $0x18, %si
	
	movw $0x0454, %es:(%si)		# letra 'T'
	addw $0x2, %si
	movw $0x0479, %es:(%si)		# letra 'y'
	addw $0x2, %si
	movw $0x0470, %es:(%si)		# letra 'p'
	addw $0x2, %si
	movw $0x0465, %es:(%si)		# letra 'e'

load_MBR:
	movb $0x02, %ah			# tipo de interrupcion: Leer sectores
	movb $1, %al				# cantidad de sectores a leer
	xorb %ch, %ch				# 8 bits bajos del numero de cilindros
	movb $1, %cl				# nro de sector(bits0-5),2 bits altos de n° de cilindro(bits 6-7,solo HD)
	xorb %dh, %dh				# Numero de cabeza
	movb $0x80, %dl			# Numero de unidad (primer disco duro == 0x80, seg disco duro == 0x81)
	xorw %bx, %bx
	movw %bx, %es			# pongo en cero es
	movw $0x7e00, %bx		# Buffer de datos (lugar donde termina este MBR) en es:bx
	int $0x13					#	MBR		    	       --> 0x7e00 
							#	tabla de particiones --> 0x7fbe

load_main:
	movb $0x02, %ah			# tipo de interrupcion: Leer sectores
	movb $3, %al				# cantidad de sectores
	xorb %ch, %ch				# 8 bits bajos del numero de cilindros
	xorb %dl, %dl				# numero de unidad (primera disquetera = 00)
	movb $2, %cl				# numero de sector
	xorb %dh, %dh				# Numero de cabeza
	xorw %bx, %bx
	movw %bx, %es			# pongo en cero es
	movw $0x8000, %bx		# buffer de datos en es:bx
	int $0x13					#      main.s			--> 0x8000

	jmp *%bx					# salto al main recien cargado

.org 510
.byte 0xAA
.byte 0x55
