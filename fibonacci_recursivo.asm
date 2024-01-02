.data
	space: .asciiz "\n"
	msg_1: .asciiz "fib("
	msg_2: .asciiz ") = "
	max: .word 25

.text
	li $a0, 0
	lw $s1, max
	
	loop:
		move $s0, $a0
		la $a0, msg_1
		li $v0, 4
		syscall
		
		move $a0, $s0
		li $v0, 1
		syscall
		
		la $a0, msg_2
		li $v0, 4
		syscall
		
		move $a0, $s0
		jal fib
		move $a0, $v0
		li $v0, 1
		syscall
		
		la $a0, space
		li $v0, 4
		syscall
		
		addi $a0, $s0, 1
	bne $a0, $s1, loop
		
	
	li $v0, 10
	syscall

fib:
	#Guarda na memória os valores a serem recuperados mais tarde
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	
	#verifica se n <= 1
	move $s0, $a0
	slti $t0, $s0, 2
	beq $t0, $0, recursion
	
	#Se chegou aqui é o caso base
	move $v0, $s0
	
	#restaura a pilha
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	#retorna para onde a função foi chamada		
	jr $ra
	
	
recursion:
	#Faz o caso n-1
	addi $a0, $s0, -1
	jal fib
	move $s1, $v0
	
	#Faz o caso n-2
	addi $a0, $s0, -2
	jal fib
	add $v0, $v0, $s1
	
	#restaura a pilha
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	#retorna para onde a função foi chamada		
	jr $ra
