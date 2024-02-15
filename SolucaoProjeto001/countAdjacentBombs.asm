.include "macros.asm"
.globl countAdjacentBombs

countAdjacentBombs:
	save_context
	
	move $s0, $a0			# &board
	move $s1, $a1			# row
	move $s2, $a2			# col
	
	li $s3, 0				# count = 0
	
	li $s4, -1
	add $s4, $s4, $s1
	cb_i_loop:
		move $t0, $s1
		addi $t0, $t0, 1
		bgt $s4, $t0, end_cb_i_loop
		
		li $s5, -1
		add $s5, $s5, $s2
		cb_j_loop:
			move $t0, $s2
			addi $t0, $t0, 1
			bgt $s5, $t0, end_cb_j_loop
		
			sge $t0, $s4, $0			# i >= 0
			li $t1, SIZE
			slt $t1, $s4, $t1			# i < SIZE
			sge $t2, $s5, $0			# j >= 0
			li $t3, SIZE				
			slt $t3, $s4, $t3			# j < SIZE
			
			and $t0, $t0, $t1
			and $t2, $t2, $t3
			and $s6, $t0, $t2			
			
			move $a1, $s4
			move $a2, $s5
			get_ij_address
			add $t0, $t0, $s0
			lw $t0, 0($t0)				# t0 := board[i][j]
			
			seq $t0, $t0, -1
			and $t0, $t0, $s6
			
			bne $t0, 1, end_if_cb		# i>=o && i<SIZE && j>=0 && j<SIZE && board[i][j] == -1
				addi $s3, $s3, 1		#count ++
			end_if_cb:
			addi $s5, $s5, 1
			j cb_j_loop
		end_cb_j_loop:
		
		addi $s4, $s4, 1
		j cb_i_loop
	end_cb_i_loop:
	
	move $v0, $s3
	
	restore_context
	jr $ra