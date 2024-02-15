.include "macros.asm"

.globl play

play:
	save_context
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	get_ij_address
	add $t0, $t0, $s0
	lw $t0, 0($t0)				# t0 := board[i][j]
	
	li $v0, 0
	beq $t0, -1, end_zero
	
	bne $t0, -2, end_one
	
	move $s3, $ra
	jal countAdjacentBombs
	move $ra, $s3
	
	move $a1, $s1
	move $a2, $s2
	get_ij_address
	add $t0, $t0, $s0
	sw $v0, 0($t0)
	
	bne $v0, $0, end_if_play
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		jal revealAdjacentCells
	end_if_play:
	
	end_one:
	li $v0, 1
	
	end_zero:
	restore_context
	jr $ra