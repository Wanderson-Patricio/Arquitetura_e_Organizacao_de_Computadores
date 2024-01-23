.include "macros.asm"

.globl play

play:
	save_context
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	sll $t0, $s1, 5 # i*8
  	sll $t1, $s2, 2 # j
  	add $t0, $t0, $t1
  	add $t0, $t0, $s0
	move $s1, $t0
	
	li $v0, 0
	beq $s1, -1 , end_play
	bne $s1, -2, end_if_play
	
	move $s6, $ra
	jal countAdjacentBombs
	move $ra, $s6
	
	sw $v0, 0($s1)
	bne $v0, $0, end_reveal
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		jal revealNeighboringCells
	end_reveal:
	
	end_if_play:
	li $v0, 1
	end_play:
	restore_context
	jr $ra