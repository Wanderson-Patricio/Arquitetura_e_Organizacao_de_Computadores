.data
	msg: .asciiz "Digite um número"
	

.text
	#Impressão da mensagem
	li $v0, 4
	la $a0, msg
	syscall
	
	#leitura do teclado
	li $v0, 5
	syscall
	
	move $t0, $v0s
	
	li $a0, 0
	add $a0, $0, $v0
	