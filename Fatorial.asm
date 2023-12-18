.data
	msg_inicial: .asciiz "Digite um número: "
	msg_final: .asciiz "O resultado final é: "

.text
main:
	#Impressão da mensagem
	li $v0, 4
	la $a0, msg_inicial
	syscall
	
	#leitura do teclado
	li $v0, 5
	syscall
	
	move $t0, $v0 #Salva o valor digitado em t0
	
	#Inicio do loop for
	#for(int i=1; i <= number; i++)
	li $t1, 1                       #t1 <- 0
	li $t2, 1                       #t2 será utilizado para fazer a multiplicação

loop:	
	mul $t2, $t2, $t1		#t2 <- t2*i
	addi $t1, $t1, 1                #i <- i + 1
	ble $t1, $t0, loop		#i < t0
	
	la $a0, msg_final
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
