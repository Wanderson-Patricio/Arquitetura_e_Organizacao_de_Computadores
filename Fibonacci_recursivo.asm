#Código para calcular  n-ésimo número da sequência de Fibonacci
.data
	space: .asciiz " - "

.text
	li $t0, 15
	li $t1, 0		#iterador
	main_loop:
	move $a0, $t1
	jal fib
	addi $t1, $t1, 1
	
	move $a0, $v0
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	ble $t1, $t0, main_loop

	li $v0, 10
	syscall


fib:
	#Salvando os valores guardados nos registradores
	addi $sp, $sp, -20
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)
	sw $t9, 0($sp)
	
	move $t3, $a0 			#t4 guardará o valor de n
	li $t9, 0 			#t9 será o iterador
	li $t0, 0			#a = 0
	li $t1, 1			#b = 0
	beq $t3, $zero, end_loop	#if n == 0 goto end_loop
	
	loop:
	add $t2, $t0, $t1		#c = a+b
	move $t0, $t1			#a = b
	move $t1, $t2			#b = c
	addi $t9, $t9, 1		#i = i + 1
	blt $t9, $t3, loop		#i<n goto loop
	
	end_loop:
	move $v0, $t0
	
	#Retornando os valores guardados na memória para os registradores
	lw $t9, 0($sp)
	lw $t3, 4($sp)
	lw $t2, 8($sp)
	lw $t1, 12($sp)
	lw $t0, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra
