# Lab assignment: print (unsigned) numbers in binary
# SOLUTION #2, the "pro" solution

	.text
main:
	li	$a0, 2
	jal	print_binary
	li	$a0, -1
	jal	print_binary
	li	$a0, 0xF0CACC1A
	jal	print_binary

	li	$v0, 10		# exit
	syscall

	# On entry, a0 = number to print in binary
	# Prints a0 as a sequence of 32 ASCII digits, followed by a newline.
print_binary:
	move	$s0, $a0	# save number to print in s0
	li	$s1, 0x80000000	# start at msb
binary_loop:
	and	$a0, $s0, $s1	# turn off all but current bit
	sltu	$a0, $0, $a0	# 0x01 iff any bit is 1
	ori	$a0, $a0, 0x30	# convert to ASCII

	li	$v0, 11		# syscall to print one char
	syscall

	srl	$s1, $s1, 1	# move mask one bit down
	bnez	$s1, binary_loop # another, unless bit has fallen off the end

	li	$v0, 11			# syscall to print one char
	li	$a0, '\n'       # newline
	syscall
	jr	$ra
