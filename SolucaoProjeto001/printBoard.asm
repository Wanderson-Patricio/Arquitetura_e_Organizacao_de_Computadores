.include "macros.asm"
.globl printBoard

.data
	new_line: .asciiz "\n"
	single_space: .asciiz " "
	four_spaces: .asciiz "    "
	underline: .asciiz "___"
	bar: .asciiz " | "
	star: .asciiz " * "
	hashtag: .asciiz " # "

.text
printBoard:
	save_context
	move $s0, $a0			#&board
	move $s1, $a1			#showBombs
	
	#printf("    ")
	la $a0, four_spaces
	li $v0, 4
	syscall
	
	li $s2, 0				#j = 0
	first_loop:
		li $t0, SIZE
		bge $s2, $t0, end_first_loop
		
		# printf(" %d ", j)
		la $a0, single_space
		li $v0, 4
		syscall
		move $a0, $s2
		li $v0, 1
		syscall
		la $a0, single_space
		li $v0, 4
		syscall
		
		addi $s2, $s2, 1
		j first_loop
	end_first_loop:
	
	# printf("\n")
	la $a0, new_line
	li $v0, 4
	syscall
	
	#printf("    ")
	la $a0, four_spaces
	li $v0, 4
	syscall
	
	li $s2, 0				#j = 0
	second_loop:
		li $t0, SIZE
		bge $s2, $t0, end_second_loop
		
		# printf("___")
		la $a0, underline
		li $v0, 4
		syscall
		
		addi $s2, $s2, 1
		j second_loop
	end_second_loop:
	
	# printf("\n")
	la $a0, new_line
	li $v0, 4
	syscall
	
	li $s2, 0				#i = 0
	pb_i_loop:
		li $t0, SIZE
		bge $s2, $t0, end_pb_i_loop
		
		#printf("%d | ", i)
		move $a0, $s2
		li $v0, 1
		syscall
		la $a0, bar
		li $v0, 4
		syscall
		
		li $s3, 0			#j = 0
		pb_j_loop:
			li $t0, SIZE
			bge $s3, $t0, end_pb_j_loop
			
			move $a1, $s2
			move $a2, $s3
			get_ij_address
			add $t0, $t0, $s0			
			lw $s4, 0($t0)			# s4 := board[i][j]
			
			li $t1, -1
			seq $t0, $t1, $s4
			seq $t1, $s1, 1
			and $t0, $t0, $t1		#board[i][j] == -1 && showBombs == 1
			li $t1, 1
			beq $t0, $t1, if
			
			bge $s4, $0, else_if	#board[i][j] >= 0
			
			j else
			
			if:
				la $a0, star
				li $v0, 4
				syscall
				j end_if
			else_if:
				la $a0, single_space
				li $v0, 4
				syscall
				
				move $a0, $s4
				li $v0, 1
				syscall
				
				la $a0, single_space
				li $v0, 4
				syscall
				j end_if
			else:
				la $a0, hashtag
				li $v0, 4
				syscall
			end_if:
			
			addi $s3, $s3, 1
			j pb_j_loop
		end_pb_j_loop:
		
		addi $s2, $s2, 1
		# printf("\n")
		la $a0, new_line
		li $v0, 4
		syscall
		j pb_i_loop
	end_pb_i_loop:
	
	restore_context
	jr $ra