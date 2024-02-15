.include "macros.asm"
.globl checkVictory

checkVictory:
	save_context
	
	move $s0, $a0			#s0 := &board
	
	li $s4, 0				# count = 0
	
	li $s1, 0				# i = 0
	begin_cv_i_loop:
		li $t0, SIZE
		bge $s1, $t0, end_cv_i_loop
		
		li $s2, 0			#j = 0
		begin_cv_j_loop:
			li $t0, SIZE
			bge $s2, $t0, end_cv_j_loop
		
			move $a1, $s1
			move $a2, $s2
			get_ij_address
			add $t0, $t0, $s0
			lw $t0, 0($t0)
			
			blt $t0, 0, end_if_cv
				addi $s4, $s4, 1
			end_if_cv:
		
			addi $s2, $s2, 1
			j begin_cv_j_loop
		end_cv_j_loop:
		
		addi $s1, $s1, 1
		j begin_cv_i_loop
	end_cv_i_loop:
	
	li $t0, SIZE
	mul $t0, $t0, $t0
	li $t1, BOMB_COUNT
	sub $t0, $t0, $t1
	
	li $v0, 0
	blt $s4, $t0, end_check
		li $v0, 1
	end_check:
	
	restore_context
	jr $ra
