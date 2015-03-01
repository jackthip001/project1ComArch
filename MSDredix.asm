# Programs for SPIM
# MSDredixSort
# By Jackthip Phureesatian & Sorapol Sroysuwan [ 5610500966 && 5610503990 ]
# 28 Feb. 2015

.data # data section

array_data: .word 132470, 324545, 73245, 93245, 80324542, 244, 2, 66, 236, 327, 236, 21544
print_sorted: .asciiz "Sorted"
print_data_open_parentless: .asciiz "data ["
print_close_parentless: .asciiz "] = "
new_line: .asciiz "\n"
line: .asciiz "-----------------------"
N_value: .word 12

.text

.globl main

partition:
	addiu 	$sp,	$sp, 	-8
	sw 		$ra, 	4($sp)
	sw  	$fp, 	0($sp)
	move 	$fp, 	$sp
	lw 		$a0, 	8($sp)					# &first_data -> $a0
	lw 		$a1, 	12($sp)					# &last_data -> $a1
	lw 		$a2, 	16($sp)					# msb -> $a2
	move 	$s0, 	$a0 					# f= first -> $s0
	move 	$s1, 	$a1 					# l= last -> $s1

	loop_partition:
		slt 	$s2, 	$s0, 	$s1 			# f < l ? 1 : 0
		beqz 	$s2, 	exit_loop_partition
		loop_partition_f:
			lw 		$s3, 	0($s0)			# first_data's value -> $s3
			srlv	$s4, 	$s3, 	$a2	 	# shift first_data equal msb -> $s4
			andi 	$s2,	$s4, 	1 		# s4 & 0x1 -> $s2	
			bnez 	$s2, 	exit_loop_partition_f
			slt 	$s2, 	$s0, 	$a1		# f < last ? 1 : 0
			beqz 	$s2, 	exit_loop_partition_f
			addiu 	$s0, 	$s0, 	4

			j 		loop_partition_f
		exit_loop_partition_f:

		loop_partition_l:
			lw 		$s5, 	0($s1)			# last_data's value -> $s5
			srlv 	$s4, 	$s5, 	$a2 	# shift last_data equal msb -> $s4
			andi 	$s2, 	$s4,	1 		# s6 & 0x1 -> $s2
			beqz	$s2, 	exit_loop_partition_l
			slt 	$s2, 	$a0, 	$s1 	# first < l ? 1 : 0
			beqz 	$s2, 	exit_loop_partition_l
			addiu 	$s1, 	$s1, 	-4

			j 		loop_partition_l
		exit_loop_partition_l:

		slt 	$s2, 	$s0, 	$s1 			# f < l ? 1 : 0
		beqz 	$s2, 	loop_partition
		move 	$s6, 	$s3
		move	$s3, 	$s5
		sw 		$s3, 	0($s0)
		move 	$s5, 	$s6
		sw 		$s6, 	0($s1)

		j 		loop_partition
		exit_loop_partition:
		###############################################################
#		move 	$t4, 	$a0 	
#		li 		$v0, 	4
#		la 		$a0, 	line
#		syscall

#		li 		$t1, 	0
#		loop_test:
#		slti 	$t2, 	$t1,	12  			# i < n ? 1 : 0 when N = 12
#		beqz 	$t2, 	exit_loop_test
		#print value in data[i]
#		sll 	$t2, 	$t1, 	2 				# i*4 ->$t2
#		addu 	$t2, 	$t4, 	$t2 			# &data[i] -> $t2
#		lw 		$t2, 	0($t2) 					# data[i] ->$t2
#		li 		$v0, 	1
#		move 	$a0, 	$t2
#		syscall

#		li 		$v0, 	4
#		la 		$a0, 	new_line
#		syscall

#		addiu 	$t1, 	$t1, 	1
#		j 		loop_test

#	exit_loop_test:
#		li 		$v0, 	4
#		la 		$a0, 	line
#		syscall

#		li 		$v0, 	4
#		la 		$a0, 	new_line
#		syscall
	###############################################################
		move 	$v1,	$s1
		lw 		$ra, 	4($fp)
		lw 		$fp, 	0($fp)
		addiu 	$sp, 	$sp, 	8
		jr 		$ra

msd_radix_sort:
	addiu 	$sp,	$sp, 	-8
	sw 		$ra, 	4($sp)
	sw  	$fp, 	0($sp)
	move 	$fp, 	$sp
	lw 		$a0, 	8($sp)
	lw 		$a1, 	12($sp)
	lw 		$a2, 	16($sp)
	slt 	$t0, 	$a0, 	$a1 			# first < last ? 1 : 0
	beqz 	$t0, 	exit_sort_function

	bltz 	$a2, 	exit_sort_function
	addiu 	$sp, 	$sp, 	-16
	sw 		$a0, 	0($sp)
	sw 		$a1, 	4($sp)
	sw 		$a2, 	8($sp)
	sw 		$t0, 	12($sp) 	
	jal 	partition
	lw 		$a0, 	0($sp)
	lw 		$a1, 	4($sp)
	lw 		$a2, 	8($sp)
	lw 		$t0, 	12($sp) 
	addiu 	$sp, 	$sp, 	16
	move 	$t1, 	$v1				# return value of partition value
	addiu 	$a2, 	$a2, 	-1
	addiu 	$sp, 	$sp, 	-16
	sw 		$a0, 	0($sp) 				# store &first_element
	sw 		$t1, 	4($sp) 				# store &last_element
	sw 		$a2, 	8($sp) 				# store msb
	sw 		$a1, 	12($sp)
	jal 	msd_radix_sort
	lw 		$a0, 	0($sp)
	lw 		$t1, 	4($sp)
	lw 		$a2, 	8($sp)
	lw 		$a1, 	12($sp)
	addiu 	$sp, 	$sp, 	16

	addiu 	$t1, 	$t1, 	4
	addiu 	$sp, 	$sp, 	-16
	sw 		$t1, 	0($sp)				# store mid + 1
	sw 		$a1, 	4($sp)				# store &last_element
	sw 		$a2, 	8($sp)				# store msb
	sw 		$a0, 	12($sp)				# &first_element
	jal 	msd_radix_sort
	lw 		$t1, 	0($sp)
	lw 		$a1, 	4($sp)
	lw 		$a2, 	8($sp)
	lw 		$a0, 	12($sp)
	addiu 	$sp, 	$sp, 	16

	exit_sort_function:
	lw 		$ra, 	4($fp)
	lw 		$fp, 	0($fp)
	addiu 	$sp, 	$sp, 	8 	
	jr 		$ra 

main:
	la 		$t0, 	array_data 				# & array_data -> $t0
	li 		$t1, 	0 						# i = 0 -> $t1
	la 		$t3, 	N_value
	lw 		$t3, 	0($t3) 					# N = 12 -> $t3

loop_main1:
	slt 	$t2, 	$t1,	$t3  			# i < n ? 1 : 0 when N = 12
	beqz 	$t2, 	exit_loop_main1
	#print "data ["
	li 		$v0, 	4
	la 		$a0, 	print_data_open_parentless
	syscall
	#print " i "
	li 		$v0, 	1
	move 	$a0, 	$t1
	syscall
	#print " ] = "
	li 		$v0, 	4
	la 		$a0, 	print_close_parentless
	syscall
	#print value in data[i]
	sll 	$t2, 	$t1, 	2 				# i*4 ->$t2
	addu 	$t2, 	$t0, 	$t2 			# &data[i] -> $t2
	lw 		$t2, 	0($t2) 					# data[i] ->$t2
	li 		$v0, 	1
	move 	$a0, 	$t2
	syscall
	#new line
	li 		$v0, 	4
	la 		$a0, 	new_line
	syscall
	addiu 	$t1, 	$t1, 	1

	j loop_main1

exit_loop_main1:
	addiu 	$t4, 	$t3, 	-1 				# N-1 -> $t4
	sll 	$t4, 	$t4, 	2 				# (N-1)*4 -> $t4
	li 		$t2, 	26
	addu 	$t4, 	$t4, 	$t0 			# &last_element of array_data->$t4
	addiu 	$sp, 	$sp, 	-20
	sw 		$t0, 	0($sp)					# store &array_data 
	sw 		$t4, 	4($sp)					# store &last_element
	sw 		$t2, 	8($sp)					# store msb
	sw 		$t1, 	12($sp)					# store i
	sw 		$t3, 	16($sp)					# store N
 	
	jal msd_radix_sort

	li 		$v0, 	4
	la 		$a0, 	new_line
	syscall

	li 		$v0, 	4
	la 		$a0, 	new_line
	syscall

	li 		$v0, 	4
	la 		$a0, 	print_sorted
	syscall

	li 		$v0, 	4
	la 		$a0, 	new_line
	syscall

	lw 		$t0, 	0($sp)					# store &array_data 
#	lw 		$t4, 	4($sp)					# store &last_element
#	lw 		$t2, 	8($sp)					# store msb
#	lw 		$t1, 	12($sp)					# store i
	lw 		$t3, 	16($sp)					# store N

	li 		$t1, 	0 						# i = 0 -> $t1
	loop_main2:
	slt 	$t2, 	$t1,	$t3  			# i < n ? 1 : 0 when N = 12
	beqz 	$t2, 	exit_loop_main2
	#print "data ["
	li 		$v0, 	4
	la 		$a0, 	print_data_open_parentless
	syscall
	#print " i "
	li 		$v0, 	1
	move 	$a0, 	$t1
	syscall
	#print " ] = "
	li 		$v0, 	4
	la 		$a0, 	print_close_parentless
	syscall
	#print value in data[i]
	sll 	$t2, 	$t1, 	2 				# i*4 ->$t2
	addu 	$t2, 	$t0, 	$t2 			# &data[i] -> $t2
	lw 		$t2, 	0($t2) 					# data[i] ->$t2
	li 		$v0, 	1
	move 	$a0, 	$t2
	syscall
	#new line
	li 		$v0, 	4
	la 		$a0, 	new_line
	syscall
	addiu 	$t1, 	$t1, 	1
	j 		loop_main2

exit_loop_main2:
	
	addiu 	$sp, 	$sp, 	20

# call exit once everything is done
	li		$v0, 	10
	syscall

