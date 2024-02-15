.include "macros.asm"

.globl plantBombs

plantBombs:
	save_context
	move $s0, $a0
	
	li $s1, 0   # i = 0
	begin_for_i_pb:							#  for (int i = 0; i < BOMB_COUNT; ++i) {
		li $t0, BOMB_COUNT
		bge $s1, $t0, end_for_i_pb 
	
		do_cb:											# do {
			li $v0, 42
			
			li $a0, 0	  # srand(time(NULL));
			li $a1, SIZE
			syscall 
			move $s2, $a0  							# row = rand() % SIZE;
			
			li $a0, 0	  # srand(time(NULL));
			li $a1, SIZE
			syscall 
			move $s3, $a0  							# column = rand() % SIZE;
			
			move $a1, $s2
			move $a2, $s3
			get_ij_address
			
			add $t0, $t0, $s0
			lw $t1, 0($t0)
			li $t2, -1
			beq $t2, $t1, do_cb #  while (board[row][column] == -1);
			
		sw $t2, 0($t0)			#  board[row][column] = -1; // -1 means bomb present
		addi $s1, $s1, 1    
		j begin_for_i_pb
	end_for_i_pb:
	restore_context
	jr $ra
