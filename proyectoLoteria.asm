.data  
												
	lowerlim: .word 0							# [lowerlim,upperlim) Coge desde lim inferio hasta superior
	upperlim: .word 11							# Puede cambiar a su gusto el intervalo
    
    sizeList: .word 12							# 12 porque ocuparemos 3 espacios en los arreglos
    
    list: .space 12								
	listWin: .space 12     	
    											# desde lowerlim hasta (upperlim - 1)
	msgEnter: .asciiz "Debe ingresar 3 numeros entre el rango especificado para participar en la loteria: \n"     											
    prompt: .asciiz "Ingrese un numero participante desde el 0 hasta el 10: \n" 
    msgWinner: .asciiz "GANANCIA: $ "    
	msgListWin: .asciiz "\nNUMEROS PREMIADOS: "      
	spac: .asciiz " "      	      
		
.text
	main:
	
		li $v0, 4
		la $a0, msgEnter
		syscall	
		
		lw $s0, sizeList						# tamaño listas s0
		addi $s1, $zero, 0						# puntos en s1
		
		lw $s2, upperlim						#$s4 es la lista de numeros ganadores. $s5 es la lista de numeros del usuario
		lw $s3, lowerlim			
		
		addi $t1, $zero, 0						# contador de 4 en 4 para cuestiones de arreglos y while
		while1:
					slt $t2, $t1, $s0			# mientras t1 < s0       
					beq $t2,$zero, exitWhile1
								
					jal inputArray				# pide un numero por consola mediante funcion
					
					addi $t3, $v1, 0			# guardar input
					
					addi $a0, $t3, 0			# guardar valores para funcion								
					addi $a1, $s2, 0
					addi $a2, $s3, 0								
						
					jal beetweenRange			# verifica que la entrada este en el rango mediante funcion												
																																																
					bne $v0, $zero, cnt
						j while1		
					
			cnt:	
					jal randomNumber			# numero aleatorio mediante funcion														
					sw $v1, listWin($t1)			# guarda numeros en arreglos	sw $v1, listWin($s4)		
					sw $t3, list($t1)
					
					addi $t1, $t1, 4							
										
					j while1        
		exitWhile1: 
		
												# NOTA: En el codigo c esto esta dentro del main y no una funcion, es solo por estetica
		jal checkWin							# Compara lista ganadora con la lista que tiene los nros seleccionados
		jal showNumbers							# Imprime cuanto gano y cuales nros salieron ganador
		j exitMain
	
	randomNumber:								# funcion randomNumber
		li $v0, 42  							# 42 funcion del sistema para aleatorio
		sub $a1, $a1, $a2
		syscall     							# en $a0 se guarda aleatorio

		add $t0, $a0, $a2 						# aumenta para cuestiones de intervalo
		add $v1, $t0, $zero 					# retorno v1
		
		jr $ra		  							

	inputArray:									# funcion que pide por consola nro
		li $v0, 4
		la $a0, prompt
		syscall
		
		li $v0, 5
		syscall
		
		move $v1, $v0 							# En v1 se guarda ingreso

		jr $ra									 
		
	beetweenRange:								# funcion que evalua si un nro esta dentro un intervalo			
				slt $t4, $a0, $a1				# a0 < a1, a0 es valor a evaluar
				addi $t5, $a0, 1
				slt $t5, $a2, $t5				# a2 < t5
								
				and $t0, $t4, $t5								
								
				bne $t0, $zero, ElseBR 	 
				addi $v0, $zero, 0  
  		  
				j ExitBR				 				 
		ElseBR:	
				addi $v0, $zero, 1 
		ExitBR: 
				jr $ra						 		    	        
	        	
	        	        	   
	checkWin:
		addi $t1, $zero, 0						# Inicializamos el valor de cero en t1
		
		lw $t3, listWin($t1)					# Cargamos los elementos de la listaWin
		addi $t1, $t1, 4
		lw $t4, listWin($t1)
		addi $t1, $t1, 4
		lw $t5, listWin($t1)
		
		addi $t1, $zero, 0
		
		for1:
			addi $t6, $s0, -1					# Verificamos que este sea mayor a sizeList	                     	        
			slt $t0, $t1, $t6					# $t1 es el contador
			beq $t0,$zero,exitFor
		
			lw $t9, list($t1)					# Cargamos el valor de la lista del usuario
						
			beq $t9, $t3, addPoints					# t9 = t3 || t9 = t4 || t9 = t5
			beq $t9, $t4, addPoints
			beq $t9, $t5, addPoints
			
			j go
			addPoints:
				addi $s1, $s1, 1
			
			go:
				addi $t1, $t1, 4				# Incremento del contador t1
				j for1
											
		exitFor:
			jr $ra 			   	                     	               	        
			
	showNumbers: 	

		addi $t0, $zero, 10						# Multiplica por 10 el nro de aciertos y muestra el premio
		mul $t1, $t0, $s1
		la $a0, msgWinner
				
		li $v0, 4
		syscall
		
		li $v0, 1
		move $a0, $t1
    	syscall			
	
												# Se puede usar una funcion para no hacer tan grande el codigo
		li $v0, 4								# Muestra los nros del sorteo
		la $a0, msgListWin
		syscall			
		
		addi $t1, $zero, 0						# t1 es un contador para el arreglo
		li $v0, 1
		lw $a0, listWin($t1)		
		syscall				
		
		li $v0, 4
		la $a0, spac							# Imprime un espacio
		syscall		

		addi $t1, $t1, 4					
		li $v0, 1
		lw $a0, listWin($t1)
		syscall			
				
		li $v0, 4
		la $a0, spac
		syscall			

		addi $t1, $t1, 4				
		
		li $v0, 1
		lw $a0, listWin($t1)
		syscall		
		
    	li $v0, 10							# Finalizar Programa
    	syscall			            	                     	               	                     	                     	        
	            
		jr $ra 			
	
	exitMain:
				
			
		
