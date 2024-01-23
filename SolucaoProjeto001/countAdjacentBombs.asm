.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context
	
	move $s0, $a0
	
	li $s7, 0			#count = 0
	addi $s1, $a1, -1	#i = row - 1
	begin_for_count_i:
		addi $t0, $a1, 1
		bgt $s1, $t0, end_for_count_i
		
		addi $s2, $a2, -1		#j = col - 1
		begin_for_count_j:
			addi $t0, $a2, 1
			bgt $s2, $t0, end_for_count_j
		
			li $t0, 8
			sge $t1, $s1, 0			#t1 <- i >= 0
			sge $t2, $s2, 0			#t2 <- j >= 0
			slt $t3, $s1, $t0		#t3 <- i < 8
			slt $t4, $s2, $t0		#t4 <- j < 8
			and $t1, $t1, $t2
			and $t3, $t3, $t4
			and $t1, $t1, $t1		# t1 <- i >= 0 && i < SIZE && j >= 0 && j < SIZE
			
			sll $t2, $s1, 5
			sll $t3, $s2, 2
			add $t0, $t2, $t3		# t0 <- i*8 + j
			add $t0, $t0, $s0		# t0 <- board[i][j]
			
			seq $t0, $t0, -1		# t0 <- board[i][j] == -1
			and $t0, $t0, $t1
			
			beq $t0, $zero, end_if_count
				addi $s7, $s7, 1		#count++
			end_if_count:
		
			addi $s2, $s2, 1
			j begin_for_count_j
		end_for_count_j:
		
		addi $s1, $s1, 1
		j begin_for_count_i
	end_for_count_i:
	
	move $v0, $s7
	
	restore_context
	jr $ra