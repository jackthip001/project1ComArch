# Programs for SPIM
# MSDredixSort
# By Jackthip Phureesatian & Sorapol Sroysuwan [ 5610500966 && 5610503990 ]
# 28 Feb. 2015

.data # data section

array_data: .word 132470, 324545, 73245, 93245, 80324542, 244, 2, 66, 236, 327, 236, 21544
new_line: .asciiz "\n"
print_sort: .asciiz "Sorted"
print_d1: .asciiz "data ["
print_d2: .asciiz "] = "

.text # text section

.globl main # call main by SPIM

partition:
	addiu	$sp,	$sp,	-8
	sw		$ra,	4($sp)
	sw		$fp,	0($sp)
	move 	$fp,	$sp

	lw		$a0,	8($fp)			# load first into $a0
	lw		$a1,	12($fp)			# load last into $a1
	lw		$a2,	16($fp)			# load msb into $a2
	move	$s0,	$a0				# copy first to $s0
	move	$s1,	$a1				# copy last to $s1

whileLoop:
	slt 	$s2,	$s0,	$s1		# f < l ? 1 : 0 into $s2
	beqz	$s2,	exit_partition	# f >= l goto exit_partition

loopF:
	lw		$s3,	0($s0)			# load *f into $s3
	srlv	$s4,	$s3,	$a2		# *f shift right msb
	andi	$s4,	$s4,	1 		# (*f >> msb) & 0x1 into $s4
	bnez	$s4,	exit_loopF		# $s4 != 0 goto exit_loopF
	slt 	$s4,	$s0,	$a1		# f < last ? 1 : 0 save to $s4
	beqz	$s4,	exit_loopF		# f >= last goto exit_loopF
	addiu 	$s0,	$s0,	4 		# f++

	j 		loopF

exit_loopF:
loopL:
	lw		$s5,	0($s1)			# load *l into $s5
	srlv	$s4,	$s5,	$a2		# *l shift right msb
	andi	$s4,	$s4,	1 		# (*l >> msb) & 0x1 into $s4
	beqz	$s4,	exit_loopL		# $s4 == 0 goto exit_loopL
	slt 	$s4,	$a0,	$s1		# first < l ? 1 : 0 save to $s4
	beqz	$s4,	exit_loopL		# first >= l goto exit_loopL
	addiu 	$s1,	$s1,	-4 		# l--
	j 		loopL

exit_loopL:
	slt 	$s2,	$s0,	$s1		# f < l ? 1 : 0 into $s2
	beqz	$s2,	whileLoop		# l <= f goto whileLoop
	lw		$s4,	0($s0)			# *f to $s4
	lw		$s6,	0($s1)			# *l to $s6

	sw		$s4,	0($s1)
	sw		$s6,	0($s0)

	j 		whileLoop

exit_partition:
	move	$v0,	$s1				# return l

	lw		$ra,	4($fp)
	lw		$fp,	0($fp)
	addiu	$sp,	$sp,	8
	jr		$ra

msd_radix_sort:	
	addiu 	$sp,	$sp,	-8
	sw		$ra,	4($sp)
	sw		$fp,	0($sp)
	move	$fp,	$sp

	lw		$t0,	8($fp)			# load &Data[0]
	lw		$t1,	12($fp)			# load &Data[N-1] <Last element>
	lw		$t2,	16($fp)			# load 31 <MSB>

	slt		$t3,	$t0,	$t1		# &Data[0] < &Data[N-1] ? 1 : 0 into $t3
	beqz	$t3,	exit_radix		# &Data[0] >= &Data[N-1] goto exit_radix
	slti	$t3,	$t2,	0		# MSB < 0 ? 1 : 0 into $t3
	beq 	$t3,	1,	exit_radix	# MSB < 0 goto exit_radix

	addiu	$sp,	$sp,	-16
	sw		$t0,	0($sp)			# store $t0 <&Data> into stack
	sw		$t1,	4($sp)			# store $t1 <&Data[N-1]> into stack
	sw		$t2,	8($sp)			# store $t2 <31> into stack
	sw		$t3,	12($sp)

	jal		partition

	move	$t3,	$v0				# move $v0 into $t3 //return l

	lw		$t1,	4($sp)			# load $t1 <&Data[N-1]> form stack
	lw		$t0,	0($sp)			# load $t0 <&Data> form stack
	lw		$t2,	8($sp)			# load $t2 <31> form stack
	addiu 	$sp,	$sp,	16

	addiu	$t2,	$t2,	-1 		# MSB--

################ Sort Left Partition ################
	addiu	$sp,	$sp,	-16
	sw		$t0,	0($sp)			# store $t0 <&Data> into stack
	sw		$t3,	4($sp)			# store $t3 <&mid> into stack
	sw		$t2,	8($sp)			# store $t2 <31> into stack
	sw		$t1,	12($sp)			# store $t1 <&Data[N-1]> into stack

	jal		msd_radix_sort

	lw		$t0,	0($sp)			# load &Data form stack
	lw		$t1,	12($sp)			# load &Data[N-1] form stack
	lw		$t2,	8($sp)			# load 31 form stack
	lw		$t3,	4($sp)			# load &Mid into $t3 //return l
	addiu 	$sp,	$sp,	16

################ Sort Right Partition ################
	
	addiu	$t3,	$t3,	4		# mid+1 into $t3

	addiu	$sp,	$sp,	-16
	sw		$t0,	12($sp)			# store $t0 <&Data> into stack
	sw		$t3,	0($sp)			# store $t3 <&mid> into stack
	sw		$t2,	8($sp)			# store $t2 <31> into stack
	sw		$t1,	4($sp)			# store $t1 <&Data[N-1]> into stack

	jal 	msd_radix_sort

	lw		$t0,	12($sp)
	addiu	$sp,	$sp,	16

exit_radix:

	addiu	$sp,	$sp,	8
	lw		$ra,	4($fp)
	lw		$fp,	0($fp)	
	jr		$ra

main:
	move	$fp,	$sp
	li 		$gp,	12 				# set N = 12 into $gp
	la		$t0,	array_data		# load &array_data into $t0
	addu 	$t1,	$zero,	$zero	# i = 0 into $t1

loop_print:
	slt		$t2,	$t1,	$gp		# i < N ? 1 : 0 into $t2
	beqz	$t2,	exit_loop_print # i >= N goto exit_loop_print

	li 		$v0,	4
	la 		$a0,	print_d1
	syscall

	li 		$v0,	1
	move 	$a0,	$t1
	syscall

	li 		$v0,	4
	la		$a0,	print_d2
	syscall

	sll 	$t2,	$t1,	2 		# i * 4 into $t2
	addu 	$t2,	$t2,	$t0		# &Data[0] --> &Data[i] into $t2
	lw		$t2,	0($t2)			# load Data[i] into $t2

	li 		$v0,	1
	move 	$a0,	$t2
	syscall

	li 		$v0,	4
	la		$a0,	new_line
	syscall

	addiu	$t1,	$t1, 	1 		# i++

	j 		loop_print

exit_loop_print:
	li 		$t3,	31				# load imm 31 into $t3
	addiu	$t4,	$gp,	-1 		# save N - 1 into $t4
	sll 	$t4,	$t4,	2 		# 4 * (N - 1) --> $t4
	addu 	$t4,	$t0,	$t4		# move &Data[0] to &Data[N-1] --> $t4

	addiu	$sp,	$sp,	-20		# move $sp
	sw		$t0,	0($sp)			# store $t0 <&Data> into stack
	sw		$t4,	4($sp)			# store $t4 <&Data[N-1]> into stack
	sw		$t3,	8($sp)			# store $t3 <31> into stack
	sw		$t2,	12($sp)			# store $t2 <Data[i]> into stack
	sw		$t1,	16($sp)			# store $t1 <i> into stack
	jal		msd_radix_sort

	sw		$t0,	0($sp)			# load &Data into $t0

	addiu	$sp,	$sp,	20
	lw		$fp,	0($fp)

	addu 	$t1,	$zero,	$zero	# i = 0 into $t1

	li 		$v0,	4
	la		$a0,	new_line
	syscall
	li 		$v0,	4
	la		$a0,	new_line
	syscall

	li 		$v0,	4
	la 		$a0,	print_sort
	syscall
	li 		$v0,	4
	la		$a0,	new_line
	syscall

loop_afterSort:
	slt		$t2,	$t1,	$gp		# i < N ? 1 : 0 into $t2
	beqz	$t2,	exit_printSort	# i >= N goto exit_loop_print

	li 		$v0,	4
	la 		$a0,	print_d1
	syscall

	li 		$v0,	1
	move 	$a0,	$t1
	syscall

	li 		$v0,	4
	la		$a0,	print_d2
	syscall

	sll 	$t2,	$t1,	2 		# i * 4 into $t2
	addu 	$t2,	$t2,	$t0		# &Data[0] --> &Data[i] into $t2
	lw		$t2,	0($t2)			# load Data[i] into $t2	
	li 		$v0,	1
	move 	$a0,	$t2
	syscall

	li 		$v0,	4
	la		$a0,	new_line
	syscall

	addiu	$t1,	$t1, 	1 		# i++

	j 		loop_afterSort


exit_printSort:

# call exit once everything is done
	li		$v0, 	10
	syscall