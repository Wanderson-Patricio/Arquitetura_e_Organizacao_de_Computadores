.include "macros.asm"
.globl initializeBoard

initializeBoard:
	save_context
	
	move $s0, $a0			#s0 := &board
	
	li $s1, 0				# i = 0
	begin_ib_i_loop:
		li $t0, SIZE
		bge $s1, $t0, end_ib_i_loop
		
		li $s2, 0			#j = 0
		begin_ib_j_loop:
			li $t0, SIZE
			bge $s2, $t0, end_ib_j_loop
		
			move $a1, $s1
			move $a2, $s2
			get_ij_address
			add $t0, $t0, $s0
			li $t1, -2			#-2 means no bomb
			sw $t1, 0($t0)		#board[i][j] = -2
		
			addi $s2, $s2, 1
			j begin_ib_j_loop
		end_ib_j_loop:
		
		addi $s1, $s1, 1
		j begin_ib_i_loop
	end_ib_i_loop:
	
	restore_context
	jr $ra
