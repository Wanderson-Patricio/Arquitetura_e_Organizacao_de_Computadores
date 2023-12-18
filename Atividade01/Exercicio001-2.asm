.text
	#Leitura do teclado
	li $v0, 5             
	syscall
	
	add $t0, $0, $v0      #t0 <- x
	li $t2, 8             #t2 <- 8
	add $t1, $t0, $t0     #t1 <- x+x = 2x
	sub $t1, $t1, $t2     #t1 <-t1 - t2 = 2x-8
	
	#Impressão no log
	add $a0, $0, $t1
	li $v0, 1
	syscall