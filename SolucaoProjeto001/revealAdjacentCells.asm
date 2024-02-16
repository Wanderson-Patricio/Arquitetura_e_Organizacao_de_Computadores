.include "macros.asm"
.globl revealAdjacentCells

revealAdjacentCells:
	
	addi $sp, $sp, -48
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
	sw $ra, 32($sp)
	sw $a0, 36($sp)
	sw $a1, 40($sp)
	sw $a2, 44($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	jal countAdjacentBombs
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	get_ij_address
	add $t0, $t0, $s0
	sw $v0, 0($t0)
	
	addi $s3, $s1, -1				# s3 := row - 1
	rv_i_loop:
		addi $t0, $s1, 1				# t0 := row + 1
		bgt $s3, $t0, end_rv_i_loop
		
		addi $s4, $s2, -1				# s4 := col - 1
		rv_j_loop:
			addi $t0, $s2, 1				# t0 := col + 1
			bgt $s4, $t0, end_rv_j_loop
		
			li $t1, SIZE
			bltz $s3, end_if			# i < 0
			bge $s3, $t1, end_if		# i >= SIZE
			bltz $s4, end_if			# j < 0
			bge $s4, $t1, end_if		# j >= SIZE
			
			move $a1, $s3
			move $a2, $s4
			get_ij_address
			add $t0, $t0, $s0
			lw $t0, 0($t0)
			bne $t0, -2, end_if			# board[i][j] != -2
			
			#Entrou no caso recursivo
			jal recursive_case
		
			end_if:
		
			addi $s4, $s4, 1
			j rv_j_loop
		end_rv_j_loop:
		
		addi $s3, $s3, 1
		j rv_i_loop
	end_rv_i_loop:
	
	#se chegou aqui não entrou na recursão, ou saiu do loop
	end_reveal:
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)
	lw $ra, 32($sp)
	lw $a0, 36($sp)
	lw $a1, 40($sp)
	lw $a2, 44($sp)
  	addi $sp, $sp, 48
	
	jr $ra
	
	
recursive_case:
	move $a1, $s3
	move $a2, $s4
	jal revealAdjacentCells
	
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)
	lw $ra, 32($sp)
	lw $a0, 36($sp)
	lw $a1, 40($sp)
	lw $a2, 44($sp)
  	addi $sp, $sp, 48
	
	jr $ra
	
	
