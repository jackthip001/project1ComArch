# Programs for SPIM
# gcd
# 25 Feb. 2015

.data # data section

new_line: .asciiz "\n"
print_gcd: .asciiz "gcd of 1890 and 3315 is "

.text # text section

.globl main # call main by SPIM

gcd:
	addiu	$sp,	$sp,	-8
	sw		$ra,	4($sp)
	sw		$fp,	0($sp)
	move	$fp,	$sp
	lw		$t0,	8($sp)
	lw		$t1,	12($sp)

	bne		$t0,	$t1,	mMoreN
	lw		$ra,	4($fp)
	lw		$fp,	0($fp)
	addiu	$sp,	$sp,	8
	move	$v0,	$t0
	jr 		$ra

mMoreN:
	slt		$t2,	$t1,	$t0
	beqz	$t2,	exit_if
	subu	$t0,	$t0,	$t1
	addiu	$sp,	$sp,	-12
	sw		$t0,	0($sp)
	sw		$t1,	4($sp)
	sw		$t2,	8($sp)
	jal		gcd
	lw		$ra,	4($fp)
	lw		$fp,	0($fp)
	addiu	$sp,	$sp,	12
	addu	$v0,	$v0,	$zero
	jr		$ra

exit_if:
	subu	$t1,	$t1,	$t0
	addiu	$sp,	$sp,	-8
	sw		$t0,	0($sp)
	sw		$t1,	4($sp)
	jal 	gcd
	lw		$ra,	4($fp)
	lw		$fp,	0($fp)
	addiu	$sp,	$sp,	8
	addu	$v0,	$v0,	$zero
	jr		$ra	

main:
	li 		$v0,	4
	la		$a0,	print_gcd
	syscall

	li 		$t0,	1980
	li 		$t1,	3315
	move	$fp,	$sp
	addiu	$sp,	$sp,	-8
	sw		$t0,	0($sp)
	sw		$t1,	4($sp)
	jal		gcd

	move	$a0,	$v0
	li 		$v0,	1
	syscall

	li 		$v0,	4
	la		$a0,	new_line
	syscall

	addiu	$sp,	$sp,	8
	lw		$fp,	0($fp)

# call exit once everything is done
	li		$v0, 	10
	syscall