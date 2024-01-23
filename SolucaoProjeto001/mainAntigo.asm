.data
	SIZE: .word 8			#It will be an SIZE x SIZE board
	BOMB_COUNT: .word 10		#At the total the board will have BOMB_COUNT bombs
	
	msg_row:  	.asciiz "Enter the row for the move: "
 	msg_column:  	.asciiz "Enter the column for the move: "
 	msg_win:  	.asciiz "Congratulations! You won!\n"
 	msg_lose:  	.asciiz "Oh no! You hit a bomb! Game over.\n"
	msg_invalid:  	.asciiz "Invalid move. Please try again.\n"
	tab: 		.asciiz "\t"
	new_line:	.asciiz "\n"

.text
main:
	jal initializeBoard
	jal plantBombs
	li $a1, 0		#at the beginning don't show the bombs
	jal printBoard
	
	
	
	li $v0, 10
	syscall
	
	
	##Após a vitória
	###############################
	# la $a0, new_line
	# li $v0, 4
	# syscall
	# syscall
	
	# jal set_adjacency_counting
	# jal print_revealed_board
	###############################
	
	
	
	
	
	
	
	
	
	
	
	



#################################################################################################
# Functions to be used in the main functin
#################################################################################################
  	
# Initialize all spots with no bombs
 initializeBoard:
	addi $sp, $sp, -32
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
	
	lw $s2, SIZE				#s2 guardará o tamanho do tabuleiro
	li $s0, 0				#s0 será o nosso iterador para i
	
	begin_for_i_it:
		bge $s0, $s2, end_for_i_it			#for(i = 0; i < SIZE; i++)
		
		li $s1, 0			#s1 será o nosso iterador em j
		begin_for_j_it:
			bge $s1, $s2, end_for_j_it
			
			## a posição board[i][j] será i * SIZE + j
			lw $t0, SIZE
			mul $t0, $t0, $s0
			add $t0, $t0, $s1
			li $t1, 4
			mul $t0, $t0, $t1
			add $t0, $t0, $gp
			
			li $t1, -2			# -2 means no bomb
			sw $t1, 0($t0)
			
			addi $s1, $s1, 1
			j begin_for_j_it
		end_for_j_it:
		
		addi $s0, $s0, 1
		j begin_for_i_it
	end_for_i_it:	
	
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)	
 	addi $sp, $sp, 32
	jr $ra
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
# This function plants the bombs in random positions
plantBombs:
	addi $sp, $sp, -32
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)

	move $s0, $a0
	
	li $a0, 0	  # srand(time(NULL));
	lw $a1, SIZE
	
	li $s1, 0   # i = 0
	begin_for_i_place_bomb:							#  for (int i = 0; i < BOMB_COUNT; ++i) {
		lw $t0, BOMB_COUNT
		bge $s1, $t0, end_for_i_place_bomb 
	
		do_cb:											# do {
		li $v0, 42
		syscall 
		move $s2, $a0  							# row = rand() % SIZE;
		syscall 
		move $s3, $a0  							# column = rand() % SIZE;
		
		lw $t0, SIZE
		mul $t0, $t0, $s2
		add $t0, $t0, $s3
		li $t1, 4
		mul $t0, $t0, $t1
		add $t0, $t0, $gp
		
		lw $t1, 0($t0)
		li $t2, -1
		
		beq $t2, $t1, do_cb 		#  while (board[row][column] == -1);
		
		sw $t2, 0($t0)			#  board[row][column] = -1; // -1 means bomb present
		addi $s1, $s1, 1    
		j begin_for_i_place_bomb
	end_for_i_place_bomb:
	
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)	
 	addi $sp, $sp, 32
	jr $ra
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
# This function prints the board
printBoard:
	addi $sp, $sp, -32
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	li $v0, 11 
  	li $a0, 32 									# printf("    ");
  	syscall							
  	syscall
  	syscall
  	syscall
  
  
  	li $t0, 0
  	begin_for_j1_pb:						# for (int j = 0; j < SIZE; ++j)	
  	lw $t1, SIZE
  	bge $t0, $t1, end_for_j1_pb
 	li $v0, 11 
  	li $a0, 32 									#print (' ')
  	syscall
  	li $v0, 1
  	move $a0, $t0 							#print ('i')
 	syscall
  	li $v0, 11
  	li $a0, 32 									#print (' ')
 	syscall
  	addi $t0, $t0, 1
  	j begin_for_j1_pb
  	end_for_j1_pb:
   
  	li $v0, 11
  	li $a0, 10 									# printf("\n");
  	syscall
    
  	li $v0, 11
  	li $a0, 32 									# printf("   ");
  	syscall
  	syscall
  	syscall
  	syscall
   
  	li $t0, 0
  	begin_for_j2_pb:						# for (int j = 0; j < SIZE; ++j)
  	lw $t1, SIZE
  	bge $t0, $t1, end_for_j2_pb
  	li $v0, 11
  	li $a0, 95 									# printf("___");
  	syscall
  	syscall
  	syscall
  	addi $t0, $t0, 1
  	j begin_for_j2_pb
  	end_for_j2_pb:
    
  	li $v0, 11
  	li $a0, 10 									# printf("\n");
  	syscall
    
  	li $t0, 0
  	begin_for_i_pb:							# for (int i = 0; i < SIZE; ++i) {
  	lw $t7, SIZE
  	bge $t0, $t7, end_for_i_pb
  	li $v0, 1
 	move $a0, $t0 							# printf(i)
  	syscall
  
  	li $v0, 11
  	li $a0, 32 									#printf(" ")
  	syscall
  
	li $v0, 11
  	li $a0, 124 								# printf("|")
  	syscall
  
  	li $v0, 11
  	li $a0, 32 									# print(" ")
  	syscall
  	
  	li $t1, 0
  	begin_for_ji_pb:						# for (int j = 0; j < SIZE; ++j) {
  	lw $t7, SIZE
  	bge $t1, $t7, end_for_ji_pb
  	li $v0, 11
  	li $a0, 32 									# print(" ")
  	syscall
  	
  	
  	lw $t4, SIZE
  	mul $t4, $t4, $t0
	add $t4, $t4, $t1
	li $t2, 4
	mul $t4, $t4, $t2
	add $t4, $t4, $gp
	
	lw  $t4, 0($t4)
	li $t7, -1
	bne $t4, $t7, elseif_imt		# if (board[i][j] == -1 && showBombs) {
	beqz $s1, elseif_imt		
		
	li $v0, 11
  	li $a0, 42 									# print (*)
  	syscall
  	j print_space
  	
	elseif_imt:
	blt $t4,$zero, else_imt			# else if (board[i][j] >= 0) {
	li $v0, 1
  	move $a0, $t4 						  # printf(" %d ", board[i][j]); // Revealed cell
  	syscall					
  	j print_space  	
		
	else_imt:
	li $v0, 11
  	li $a0, 35 									# printf(#)
 	syscall
  	print_space:
  
  	li $v0, 11
  	li $a0, 32 									# printf(' ')
  	syscall
  
  	addi $t1, $t1, 1 
  	j begin_for_ji_pb
  	end_for_ji_pb:
  	
  	li $v0, 11
  	li $a0, 10 									# printf('\n')
  	syscall
  
  	addi $t0, $t0, 1 
  	j begin_for_i_pb
  	end_for_i_pb:
  
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)	
 	addi $sp, $sp, 32
  	jr $ra
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
countAdjacentBombs:
	addi $sp, $sp, -32
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
	
	move $s0, $a0		#saves the row
	move $s1, $a1		#saves the collumn
	
	lw $t1, SIZE
	mul $t1, $t1, $s0
	add $t1, $t1, $s1
	li $t2, 4
	mul $t1, $t1, $t2
	add $t1, $t1, $gp
			
	lw $t1, 0($t1)		#t1 = board[row][col]
	li $s4, -1
	beq $t1, -1, end_count_i_it
	
	addi $s2, $s0, 2	#row + 2
	addi $s3, $s1, 2	#collumn + 2
	
	li $s4, 0		#count = 0
	addi $s5, $s0, -1	#i = row - 1
	count_i_it: 		#for(i = row - 1; i <= row + 1; i++)
		beq $s5, $s2, end_count_i_it
		
		addi $s6, $s1, -1
		count_j_it:
			beq $s6, $s3, end_count_j_it
			
			lw $t7, SIZE
			
			sge $t0, $s5, $0	
			sle $t1, $s5, $t7
			sge $t2, $s6, $0
			sle $t3, $s6, $t7
			
			and $t0, $t0, $t1	# i >= 0 && i < SIZE
			and $t1, $t2, $t3	# j >= 0 && j < SIZE
			and $t0, $t0, $t1	# i >= 0 && i < SIZE && j >= 0 && j < SIZE
			
			lw $t1, SIZE
			mul $t1, $t1, $s5
			add $t1, $t1, $s6
			li $t2, 4
			mul $t1, $t1, $t2
			add $t1, $t1, $gp
			
			lw $t1, 0($t1)		#t1 = board[i][j]
			
			seq $t1, $t1, -1	# t1 == -1
			and $t0, $t0, $t1
			
			li $t1, 1
			bne $t0, $t1, else_count
				addi $s4, $s4, 1
			else_count:
			
			addi $s6, $s6, 1
			j count_j_it
		end_count_j_it:
		
		addi $s5, $s5, 1
		j count_i_it
	end_count_i_it:
	
	move $v0, $s4
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)	
 	addi $sp, $sp, 32
	jr $ra
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
print_revealed_board:
	addi $sp, $sp, -32
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
	
	lw $s7, SIZE
	
	li $s0, 0
	main_for_i:
		beq $s0, $s7, end_main_for_i
		
		li $s1, 0
		main_for_j:
			beq $s1, $s7, end_main_for_j
			
			mul $t0, $s0, $s7
			add $t0, $t0, $s1
			li $t1, 4
			mul $t0, $t0, $t1
			add $t0, $t0, $gp
			
			lw $a0, 0($t0)
			li $v0, 1
			syscall
			
			la $a0, tab
			li $v0, 4
			syscall
		
			addi $s1, $s1, 1
			j main_for_j
		end_main_for_j:
		la $a0, new_line
		li $v0, 4
		syscall
		
		addi $s0, $s0, 1
		j main_for_i
	end_main_for_i:
  
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)	
 	addi $sp, $sp, 32
  	jr $ra
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
#################################################################################################

#################################################################################################
	
set_adjacency_counting:
	addi $sp, $sp, -36
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
	sw $ra, 32 ($sp)
	
 	lw $s7, SIZE
	
	li $s0, 0
	main_for_i1:
		beq $s0, $s7, end_main_for_i1
		
		li $s1, 0
		main_for_j1:
			beq $s1, $s7, end_main_for_j1
			
			move $a0, $s0
			move $a1, $s1
		
			jal countAdjacentBombs
			
			mul $t0, $s0, $s7
			add $t0, $t0, $s1
			li $t1, 4
			mul $t0, $t0, $t1
			add $t0, $t0, $gp
			sw $v0, 0($t0)
		
			addi $s1, $s1, 1
			j main_for_j1
		end_main_for_j1:
		
		addi $s0, $s0, 1
		j main_for_i1
	end_main_for_i1:
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)	
	lw $ra, 32 ($sp)
 	addi $sp, $sp, 36
	jr $ra
#################################################################################################	
