.text
	li $a0, 5
	jal fact
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	

fact:
	addi $sp, $sp, -8 # Reserva espaço para 2 itens
 	sw $ra, 4($sp) # Salva o endereço de retorno
 	sw $a0, 0($sp) # Salva o argumento
 	slti $t0, $a0, 1 # Corpo da função, testa se n < 1
 	beq $t0, $zero, L1
 	addi $v0, $zero, 1 # Se chegou aqui, resultado é 1
 	addi $sp, $sp, 8 # Restaura pilha, pop 2 itens
 	jr $ra # Retorna
L1:
 	addi $a0, $a0, -1 # decrementa n
 	jal fact # chamada recursiva
 	lw $a0, 0($sp) # restaura n original
 	lw $ra, 4($sp) # restaura $ra
 	addi $sp, $sp, 8 # Restaura pilha, pop 2 itens
 	mul $v0, $a0, $v0 # muliplica pra pegar o resultado
 	jr $ra # retorna
