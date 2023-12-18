.data
	#Tamanho máximo de uma palavra
	size: .word 32
	msg_inicial: .asciiz "Introduza um número: "
	msg_de_comeco: .asciiz "O número digitado em binário é: "
	espaco: .asciiz " "
	
.text
	#Leitura do Teclado
	li $v0, 4
	la $a0, msg_inicial
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0  	#t0 receberá o valor digitado
	
	li $v0, 4
	la $a0, msg_de_comeco
	syscall
	
	li $t1, 0 	#t1 será o nosso iterador principal (i)
	lw $t2, size    #t2 será o controle de tamanho
	
	li $t7, 0	#t7 será o iterador para verificar os espaços

loop:
	li $v0, 1 ##Imprime inteiros
	andi $t3, $t0, 0x80000000
	beq $t3, $zero, if_i
else_i:
	li $a0, 1
	jal end_i
if_i:
	li $a0, 0
end_i:	
	syscall
	sll $t0, $t0, 1
	
	addi $t1, $t1, 1
	addi $t7, $t7, 1
	
	bne $t7, 4, end_t7
if_t7:
	la $a0, espaco
	li $v0, 4
	syscall
	li $t7, 0
end_t7:
	blt $t1, $t2, loop
