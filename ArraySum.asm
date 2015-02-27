# Programs for SPIM
# ArraySum
# 25 Feb. 2015

.data # data section

array_a: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 # data array a
array_b: .word 0x7fffffff, 0x7ffffffe, 0x7ffffffd, 0x7ffffffc, 0x7ffffffb, 0x7ffffffa, 0x7ffffff9, 0x7ffffff8, 0x7ffffff7, 0x7ffffff6 # data array b
new_line: .asciiz "\n"
sum_a: .asciiz "Sum a is "
sum_b: .asciiz "Sum b is "

.text # text section

.globl main # call main by SPIM

main:
	la 		$t4,	array_a 	# load address array_a into $t4
	li 		$t0,	0 			# $t0 = sum = 0
	li 		$t1,	0 			# $t1 = i = 0

loopA:
	slti	$t3,	$t1,	20 			# i<20 ? 1 : 0 --> $t3
	beq 	$t3,	$zero,	exit_loopA	# $t3 == 0 --> exit_loopA
	sll		$t6,	$t1,	2 			# i * 4 --> $t6
	addu 	$t5,	$t4,	$t6			# base array a + i*4 --> $t5
	lw		$t3,	0($t5)				# load a[i] into $t3
	addu 	$t0,	$t0,	$t3			# sum += a[i] 
	addiu 	$t1,	1 					# i++
	j		loopA

exit_loopA:
	li		$v0, 	4 					# use return value as 4 [string]
	la		$a0, 	sum_a 				# use function argument $a0 to print sum_a's value
	syscall
	li		$v0, 	1 					# use return value as 1 [int]
	move	$a0, 	$t0					# use function argument $a0 to get sum's value
	syscall
	li		$v0, 	4 					# use return value as 4 [string]
	la		$a0, 	new_line			# use function argument $a0 to get "\n"
	syscall

	la 		$t4,	array_b 	# load address array_b into $t4
	li 		$t0,	0 			# $t0 = sum = 0
	li 		$t1,	0 			# $t1 = i = 0

loopB:
	slti	$t3,	$t1,	10 			# i<10 ? 1 : 0 --> $t3
	beq 	$t3,	$zero,	exit_loopB	# $t3 == 0 --> exit_loopB
	sll		$t6,	$t1,	2 			# i * 4 --> $t6
	addu 	$t5,	$t4,	$t6			# base array b + i*4 --> $t5
	lw		$t3,	0($t5)				# load b[i] into $t3
	addu 	$t0,	$t0,	$t3			# sum += b[i]
	addiu 	$t1,	1 					# i++
	j		loopB

exit_loopB:
	li		$v0, 	4 					# use return value as 4 [string]
	la		$a0, 	sum_b 				# use function argument $a0 to print sum_a's value
	syscall
	li		$v0, 	1 					# use return value as 1 [int]
	move	$a0, 	$t0					# use function argument $a0 to get sum's value
	syscall
	li		$v0, 	4 					# use return value as 4 [string]
	la		$a0, 	new_line			# use function argument $a0 to get "\n"
	syscall

# call exit once everything is done
	li		$v0, 	10
	syscall