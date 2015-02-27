# Programs for SPIM
# gcd
# By Jackthip Phureesatian & Sorapol Sroysuwan [ 5610500966 && 5610503990 ]
# 27 Feb. 2015

.data # data section

gcd_of: .asciiz "gcd of 1890 and 3315 is "
new_line: .asciiz "\n"

.text

.globl main


gcd:
	#save ra and fp
	addiu 	$sp, 	$sp, 	-8
	sw 		$ra, 	4($sp)
	sw 		$fp, 	0($sp)

	#move fp to sp 
	move 	$fp, 	$sp

	#load m,n from stack
	lw 		$t0, 	12($fp)	# m_value
	lw 		$t1, 	8($fp)	# n_value

	#check if it not eq go to mMTn
	bne 	$t0, 	$t1, 	mMTn

	#return fp and ra
	lw 		$ra, 	4($fp)
	lw 		$fp, 	0($fp)
	addiu 	$sp, 	$sp, 	8
	jr 		$ra

mMTn:
	slt 	$t2, 	$t1, 	$t0 # n>m ? 1 : 0
	beqz 	$t2, 	mLTn

	#save t0,t1,t2
	addiu 	$sp, 	$sp, 	-12
	subu 	$t0, 	$t0,	$t1
	sw 		$t2, 	8($sp)
	sw 		$t1, 	0($sp)
	sw 		$t0, 	4($sp)
	jal		gcd
	lw 		$ra, 	4($fp)
	lw 		$fp, 	0($fp)
	addiu 	$sp, 	$sp, 	12
	jr 		$ra


mLTn:
	addiu 	$sp, 	$sp, 	-8
	subu 	$t1, 	$t1,	$t0
	sw 		$t0, 	4($sp)
	sw 		$t1, 	0($sp)
	jal		gcd
	lw 		$ra, 	4($fp)
	lw 		$fp, 	0($fp)
	addiu 	$sp, 	$sp, 	8
	jr 		$ra

main:
	li 		$v0, 	4
	la		$a0,	gcd_of
	syscall

	#add sp for m,n
	addiu 	$sp, 	$sp,	-8
	######################
	li 		$t0, 	1890
	li 		$t1, 	3315
	######################
	# add m,n to stack
	sw 		$t0, 	4($sp)
	sw 		$t1, 	0($sp)
	# bring fp same as sp
	move	$fp,	$sp
	# go to function
	jal 	gcd
	lw  	$ra, 	4($fp)
	lw 		$fp, 	0($fp)
	addiu 	$sp, 	$sp, 	8

	li 		$v0, 	1
	move 	$a0, 	$t0
	syscall

	li 		$v0, 	4
	la 		$a0, 	new_line
	syscall

# call exit once everything is done
	li		$v0, 	10
	syscall

