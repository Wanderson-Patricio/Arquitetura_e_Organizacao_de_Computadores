.include "macros.asm"
.globl revealAdjacentCells

revealAdjacentCells:
	save_context
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	move $s0, $a0			# &board
	move $s1, $a1			# row
	move $s2, $a2			# col
	
	move $s3, $ra
	jal countAdjacentBombs
	move $ra, $s3
				
	move $a1, $s1
	move $a2, $s2
	get_ij_address
	add $t0, $t0, $s0
	sw $v0, 0($t0)
	
	bne $v0, 0, end_reveal
	
	li $s4, -1
	add $s4, $s4, $s1
	rv_i_loop:
		move $t0, $s1
		addi $t0, $t0, 1
		bgt $s4, $t0, end_rv_i_loop
		
		li $s5, -1
		add $s5, $s5, $s2
		rv_j_loop:
			move $t0, $s2
			addi $t0, $t0, 1
			bgt $s5, $t0, end_rv_j_loop
		
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
			
			slt $t0, $t0, $0			# board[i][j] < 0 wich means not revealed
			and $t0, $t0, $s6
			
			beq $t0, 1, recursive_case		# i>=o && i<SIZE && j>=0 && j<SIZE && board[i][j] == -2
			
			addi $s5, $s5, 1
			j rv_j_loop
		end_rv_j_loop:
		
		addi $s4, $s4, 1
		j rv_i_loop
	end_rv_i_loop:
	
	end_reveal:
	
	addi $sp, $sp, 12
	restore_context
	jr $ra
	
	
recursive_case:
    # Save context for recursive call
    addi $sp, $sp, -12
    sw $ra, 0($sp)   # Save return address
    sw $a1, 4($sp)   # Save row
    sw $a2, 8($sp)   # Save col

    # Recursive call
    move $a1, $s4    # Restore row
    move $a2, $s5    # Restore col
    jal revealAdjacentCells

    # Restore context after recursive call
    lw $ra, 0($sp)   # Restore return address
    lw $a1, 4($sp)   # Restore row
    lw $a2, 8($sp)   # Restore col
    addi $sp, $sp, 12

    jr $ra           # Return to the caller
