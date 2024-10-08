# Sample assembly-language program for the MARS MIPS simulator.
# Written by Pat Troy, modified by Scott Burgess and Ben Kovitz.

	.data
prompt:	.asciiz "Enter an integer: "
str1:	.asciiz "The answer is: "
newline: .asciiz "\n"
bye:	.asciiz	"Goodbye!\n"
	
	.text
main:
	
	# prompt for input
	li	$v0, 4
	la	$a0, prompt
	syscall

	# read in the value
	li	$v0, 5
	syscall
	move 	$s0, $v0
	
loop:	
	# print str1
	li	$v0, 4
	la	$a0, str1
	syscall

	# print loop value
	li	$v0, 1
	move	$a0, $s0
	syscall

	# print newline
	li	$v0, 4
	la	$a0, newline
	syscall

	# decrement loop value and branch if not negative
	sub	$s0, $s0, 1
	bgez	$s0, loop

	# print goodbye message then exit
	li	$v0, 4
	la	$a0, bye
	syscall

    	#exit program
	li 	$v0, 10
        syscall

