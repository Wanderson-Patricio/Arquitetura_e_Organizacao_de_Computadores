.include "macros.asm"

.globl checkVictory

checkVictory:
	save_context
	move $s0, $a0 
	
	li $s7, 0			#count = 0
  
  	li $s1,0 # i = 0
  	begin_for_i_it:						# for (int i = 0; i < 8; ++i) {
  		li $t0,8
  		bge $s1,$t0,end_for_i_it 
  
  		li $s2,0 # j = 0
  		begin_for_j_it:						# for (int j = 0; j < 8; ++j) {
  			li $t0, 8
  			bge $s2,$t0,end_for_j_it
  			sll $t0, $s1, 5 # i*8
  			sll $t1, $s2, 2 # j
  			add $t0, $t0, $t1
  			add $t0, $t0, $s0
  			
  			blt $t0, $zero, end_if_check
  				addi $s7, $s7, 1			#count++
  			end_if_check: 
  																	
  			addi $s2,$s2,1
  			j begin_for_j_it
  		end_for_j_it:
  		addi $s1, $s1, 1
  		j begin_for_i_it
  	end_for_i_it:
  
  	li $t0, 8
  	mul $t0, $t0, $t0
  	li $t1, 10
  	sub $t0, $t0, $t1
  	
  	blt $s7, $t0, if_external_check			# count < SIZE * SIZE - BOMB_COUNT
  		li $v0, 1
  		j end_if_external
  	if_external_check:
  		li $v0, 0
  	end_if_external:
  
  	restore_context
  	jr $ra 