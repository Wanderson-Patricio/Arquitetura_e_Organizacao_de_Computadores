.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	save_context
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		# &board
	move $s1, $a1		# row
	move $s2, $a2		# col
	
	addi $s3, $a1, -1	#i = row - 1
	begin_for_reveal_i:
		addi $t0, $a1, 1
		bgt $s3, $t0, end_for_reveal_i
		
		addi $s4, $a2, -1		#j = col - 1
		begin_for_reveal_j:
			addi $t0, $a2, 1
			bgt $s4, $t0, end_for_reveal_j
		
			li $t0, 8
			sge $t1, $s3, 0			#t1 <- i >= 0
			sge $t2, $s4, 0			#t2 <- j >= 0
			slt $t3, $s3, $t0		#t3 <- i < 8
			slt $t4, $s4, $t0		#t4 <- j < 8
			and $t1, $t1, $t2
			and $t3, $t3, $t4
			and $t1, $t1, $t1		# t1 <- i >= 0 && i < SIZE && j >= 0 && j < SIZE
			
			sll $t2, $s3, 5
			sll $t3, $s4, 2
			add $t0, $t2, $t3		# t0 <- i*8 + j
			add $t0, $t0, $s0		# t0 <- board[i][j]
			move $s5, $t0			# s5 <- board[i][j]
			
			seq $t0, $t0, -2		# t0 <- board[i][j] == -1
			and $t0, $t0, $t1
			
			beq $t0, $zero, end_if_reveal
				move $a0, $s3
				move $a1, $s4
				move $s6, $ra
				jal countAdjacentBombs
				move $ra, $s6
				sw $v0, 0($s5)
				
				bne $v0, $0, recursion
				
			end_if_reveal:
		
			addi $s4, $s4, 1
			j begin_for_reveal_j
		end_for_reveal_j:
		
		addi $s3, $s3, 1
		j begin_for_reveal_i
	end_for_reveal_i:
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	restore_context
	jr $ra
	
	
recursion:
	move $a0, $s0
	move $a1, $s3
	move $a2, $s4
	jal revealNeighboringCells		#revealNeighboringCells(board, i, j)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	restore_context
	jr $ra
