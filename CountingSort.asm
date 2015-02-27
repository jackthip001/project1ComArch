# Programs for SPIM
# CountingSort
# 25 Feb. 2015

.data # data section

array_output: .space 1000
array_count: .space 1028
str: .asciiz "cadljgarhtoxAHdgdsJKhYEasduwBRLsdgHoptxnaseurh"
#str: .asciiz "sadkjfahoijdfjkkjskkkjfasjsdjvlsd;jSAJDSAKLFJfaj;fjfiwlksdafjsSLDUFIWEMLJVISDJFSDUoSMDFJJFJKhdfajsojKLJDSFOSLJFDHSOJIEW{QIJWKFJDSOIMNSDJOUODI"
new_line: .asciiz "\n"

.text # text section

.globl main # call main by SPIM

countSort:
	addiu	$sp,	$sp,	-8
	sw		$ra,	4($sp)
	sw		$fp,	0($sp)
	move	$fp,	$sp
	lw		$t0,	8($fp)			## & base str --> $t0
	la 		$t1,	array_output	## & base array_output --> $t1
	la 		$t2,	array_count		## & base array_count --> $t2
	li 		$t3,	0				# & i = 0 --> $t3
	addiu	$t4,	$gp,	1 		# RANGE + 1 --> $t4

loop1:
	slt 	$t5,	$t3,	$t4		# i < RANGE ? 1 : 0 --> $t5
	beqz	$t5,	exit_loop1		# if(i >= RANGE) goto exit_loop1
	sll 	$t5,	$t3,	2 		# i * 4 --> $t5
	addu 	$t6,	$t2,	$t5		# &count[0] --> &count[i] --> $t6
	sw		$zero,	0($t6)			# save 0 into &count[i]
	addiu 	$t3,	$t3,	1 		# i++
	j 		loop1

exit_loop1:
	addu 	$t3,	$zero,	$zero

loop2:
	addu 	$t4,	$t0,	$t3		# &str[0] --> &str[i] into $t4
	lbu		$t4,	0($t4)			# load str[i] --> $t4
	beqz 	$t4,	exit_loop2		# if(str[i] == '\0') goto exit_loop2
	sll 	$t4,	$t4,	2 		# ascii(str[i]) * 4 --> $t4
	addu 	$t4,	$t4,	$t2		# &count[0] --> &count[str[i]] --> $t4
	lw		$t5,	0($t4)			# load count[str[i]] --> $t5
	addiu 	$t5,	$t5,	1 		# ++count[str[i]]
	sw		$t5,	0($t4)			# save $t5 into count[str[i]] <$t4>
	addiu 	$t3,	$t3,	1 		# ++i
	j 		loop2

exit_loop2:
	addiu 	$t3,	$zero,	1 		# i = 1 --> $t3

loop3:
	slt 	$t4,	$gp,	$t3		# RANGE < i ? 1 : 0
	bnez 	$t4,	exit_loop3		# RANGE < i --> goto exit_loop3
	sll 	$t4,	$t3,	2 		# i * 4 --> $t4
	addiu  	$t5,	$t4,	-4 		# i-1 * 4 --> $t5
	addu 	$t4,	$t4,	$t2		# &count[0] --> &count[i] --> $t4
	addu 	$t5,	$t5,	$t2 	# &count[0] --> &count[i-1] --> $t5
	lw		$t6,	0($t4)			# load count[i] --> $t6
	lw		$t7,	0($t5)			# load count[i-1] --> $t7
	addu 	$t6,	$t6,	$t7		# count[i] += count[i-1]
	sw		$t6,	0($t4)			# save count[i] --> &count[i]
	addiu 	$t3,	$t3,	1 		# ++i
	j 		loop3

exit_loop3:
	addu	$t3,	$zero,	$zero	# i = 0 --> $t3

loop4:
	addu 	$t4,	$t0,	$t3		# str[i]
	lbu		$t4,	0($t4)			# load ascii(str[i]) --> $t4
	beq 	$t4,	0,	exit_loop4	# if(str[i] == '\0') goto exit_loop4 edit
	sll 	$t5,	$t4,	2 		# ascii(str[i]) * 4 --> $t5
	addu 	$t6,	$t2,	$t5		# &count[0] --> &count[str[i]] --> $t6
	lw		$t8,	0($t6)			# load count[str[i]] into $t6
	addiu 	$t7,	$t8,	-1 		# count[str[i]] - 1 --> $t7
	addu 	$t7,	$t7,	$t1		# &output[0] --> &output[count[str[i]]-1] --> $t7
	sb		$t4,	0($t7)			# save str[i] into output[count[str[i]]-1]
	addiu	$t8,	$t8,	-1 		# --count[str[i]] --> $t7
	sw		$t8,	0($t6)			# save count[str[i]]
	addiu	$t3,	$t3,	1 		# ++i
	j 		loop4

exit_loop4:
	addu	$t3,	$zero	$zero	# i = 0 --> $t3

loop5:
	addu 	$t4,	$t0,	$t3		# &str[0] --> &str[i] --> $t4
	lbu		$t6,	0($t4)			# load ascii(str[i]) --> $t6
	beq 	$t6,	0,	exit_loop5	# if(str[i] == '\0') goto exit_loop5
	addu 	$t5,	$t3,	$t1		# &output[0] --> &output[i] --> $t5
	lbu		$t5,	0($t5)			# load output[i] into $t5
########################################
#	li 		$v0,	1
#	move	$a0,	$t3
#	syscall

#	li 		$v0,	11
#	move    $a0,	$t5
#	syscall

#	li 		$v0,	4
#	la 		$a0,	new_line
#	syscall
########################################
	sb		$t5,	0($t4)			# save ascii(output[i]) into &str[i]
	addiu	$t3,	$t3,	1 		# ++i
	j 		loop5

exit_loop5:
	lw		$ra,	4($fp)
	lw		$fp,	0($fp)
	addiu	$sp,	$sp,	8
	jr 		$ra

main:
	li 		$gp,	255				# 255 --> $gp
	move	$fp,	$sp
	la 		$t0,	str
	addiu	$sp,	$sp,	-4
	sw		$t0,	0($sp)
	jal		countSort
	lw		$t0,	0($sp)
	addiu	$sp,	$sp,	4
	lw		$fp,	0($fp)

	li 		$v0,	4
	la 		$a0,	0($t0)
	syscall

# call exit once everything is done
	li		$v0, 	10
	syscall