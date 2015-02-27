# Programs for SPIM
# 
# By Jackthip Phureesatian & Sorapol Sroysuwan [ 5610500966 && 5610503990 ]
# 27 Feb. 2015

.data # data section

gcd_of: .asciiz "gcd of 1890 and 3315 is "
new_line: .asciiz "\n"

.text

.globl main

main:
	#print word
	li $v0, 4
	la $a0, gcd_of
	#print value of gcd
	li $v0, 1
	move $a0, $t7 #<---- Have to change this temp register
	#print new line
	li $v0, 4
	la $a0, new_line 
