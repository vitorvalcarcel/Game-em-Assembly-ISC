.data

# Sprites
	.include "sprites/fundoGame.data"
	.include "sprites/felixParado.data"
	.include "sprites/felixmenor.data"

# Dados
	POS_00: .half 0,0			
	POS_PERSON: .half 77, 198		# x, y
	POS_PERSON_ANTE: .half 0,0		# x, y

#altura periodo e duração do#
	notas: .word 41, 0, 0,

	67,240, 0,
	67,240, 0,
	67,240, 0,
	67,480, 0,
	64,240, 0,
	64,240, 0,
	64,240, 0,
	65,240, 0,
	65,480, 0,
	65,720, 0,
	62,240, 0,
	62,240, 0,
	65,240, 0,
	65,480, 0,
	65,720, 0,
	62,240, 0,
	62,240, 0,
	65,240, 0,
	64,240, 0,
	62,240, 0,
	60,1200, 0,
	67,240, 0,
	67,240, 0,
	67,240, 0,
	67,480, 0,
	64,240, 0,
	64,240, 0,
	64,240, 0,
	65,240, 0,
	65,480, 0,
	65,720, 0,
	60,240, 0,
	60,240, 0,
	64,480, 0,
	62,240, 0,
	60,1200, 0,
	64,480, 0,
	64,480, 0,
	64,480, 0,
	60,240, 0,
	60,240, 0,

.text
SETUP:		# Faz o carregamento dos dados iniciais do jogo

		la a0,fundoGame			# carrega o endereco do sprite 'map' em a0
		li a1,0				# x = 0
		li a2,0				# y = 0
		li a3,0				# frame = 0
		call PRINT			# imprime o sprite
		li a3,1				# frame = 1
		call PRINT			# imprime o sprite
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar

GAME_LOOP:	# � o loop do jogo que vai ficar rodando todo o tempo

## Musica ##

		la s1, notas
		lw s2, 0(s1) #quantas notas existem
		lw s3, 4(s1) #em que nota eu estou
		lw s4, 8(s1) #quand a ultima nota foi tocada do 6

		li t0, 12
		mul s5, t0, s3
		add s5, s5, s1  #endereço da nota atual do 6

		li a7, 30
		ecall

		sub s6, a0, s4 # quanto tempo já se passou desde que a última nota foi tocada

		lw t1, 4(s5)
		bgtu t1, s6, MF0 
				#se já for pra tocar a próxima nota do, 6
			
			bne s3, s2, MF1
				li s3, 0
				mv s5, s1
			MF1:
				addi s5, s5, 12

				li a7, 31
				lw a0, 0(s5)
				lw a1, 4(s5)
				li a2, 1
				li a3, 90
				ecall

				li a7, 30
				ecall

				sw a0, 8(s1)

				addi s3, s3, 1
				sw s3, 4(s1)
				
		MF0:

		## Termina musica ##

		call TECLADO			# chama o procedimento de entrada do teclado
		
		xori s0,s0,1			# inverte o valor frame atual (somente o registrador)
		
		la t0,POS_PERSON		# carrega em t0 o endereco de CHAR_POS
		
		la a0,felixParado			# carrega o endereco do sprite 'felix parado' em a0
		beq s0, zero, FELIXMENOR
	volta:
		lh a1,0(t0)			# carrega a posicao x do personagem em a1
		lh a2,2(t0)			# carrega a posicao y do personagem em a2
		mv a3,s0			# carrega o valor do frame em a3
		call PRINT			# imprime o sprite
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		
		#########################################
		# Limpeza do "rastro" do personagem 	#
		#########################################
		la t0,POS_00				# carrega em t0 o endereco de OLD_CHAR_POS
							#
		la a0,fundoGame				# carrega o endereco do sprite 'tile' em a0
		lh a1,0(t0)				# carrega a posicao x antiga do personagem em a1
		lh a2,2(t0)				# carrega a posicao y antiga do personagem em a2
							#
		mv a3,s0				# carrega o frame atual (que esta na tela em a3)
		xori a3,a3,1				# inverte a3 (0 vira 1, 1 vira 0)
		call PRINT				# imprime

		j GAME_LOOP			# continua o loop

TECLADO:	# Verifica se o teclado foi pressionado e se foi, chama o procedimento de teclado

		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,'w'
		beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama CHAR_CIMA
		
		li t0,'a'
		beq t2,t0,CHAR_ESQ		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'s'
		beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0,'d'
		beq t2,t0,CHAR_DIR		# se tecla pressionada for 'd', chama CHAR_CIMA
	
FIM:		ret				# retorna

#############################################################################################################
# Procedimentos de teclado

CHAR_ESQ:	la t0,POS_PERSON			# carrega em t0 o endereco de CHAR_POS
		la t1,POS_PERSON_ANTE		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS

		li a0, 75
		li a1, 250
		li a2, 1
		li a3, 127
		li a7, 31
		ecall
		
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,-16			# decrementa 16 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_DIR:	la t0,POS_PERSON			# carrega em t0 o endereco de CHAR_POS
		la t1,POS_PERSON_ANTE		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS

		li a0, 75
		li a1, 250
		li a2, 1
		li a3, 127
		li a7, 31
		ecall
		
		la t0,POS_PERSON
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,16			# incrementa 16 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_CIMA:	la t0,POS_PERSON		# carrega em t0 o endereco de CHAR_POS
		la t1,POS_PERSON_ANTE		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS

		li a0, 75
		li a1, 250
		li a2, 1
		li a3, 127
		li a7, 31
		ecall
		
		la t0,POS_PERSON
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,-16			# decrementa 16 pixeis
		sh t1,2(t0)			# salva
		ret

CHAR_BAIXO:	la t0,POS_PERSON			# carrega em t0 o endereco de CHAR_POS
		la t1,POS_PERSON_ANTE		# carrega em t1 o endereco de OLD_CHAR_POS
		lw t2,0(t0)
		sw t2,0(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS

		li a0, 75
		li a1, 250
		li a2, 1
		li a3, 127
		li a7, 31
		ecall
		
		la t0,POS_PERSON
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,16			# incrementa 16 pixeis
		sh t1,2(t0)			# salva
		ret

###############################################################################################################
# Efeitos sonoros#
EFEITOS:
	li a0, 40
	li a1, 250
	li a2, 1
	li a3, 100
	li a7, 31
	ecall
	
		

###############################################################################################################

# Procedimentos de print

#################################################
#	a0 = endere�o imagem			#
#	a1 = x					#
#	a2 = y					#
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################

PRINT:		li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320			# t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		
		addi t1,a0,8			# t1 = a0 + 8
		
		mv t2,zero			# zera t2
		mv t3,zero			# zera t3
		
		lw t4,0(a0)			# carrega a largura em t4
		lw t5,4(a0)			# carrega a altura em t5
		
PRINT_LINHA:	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi t1,t1,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
		
		ret				# retorna

	FELIXMENOR:
		la a0, felixmenor
		j volta