# Lab assignment: Display numbers 0..99 on a seven-segment display

	.data
	# HINT: Make a look-up table

	.text
main:
	li	$s0, 0		# s0 is counter: cycles through 0..99
	li	$s1, 99		# s1 = upper limit
main_loop:
	move	$a0, $s0	# ready to display $s0 on the LEDs
	jal	display_number

	li	$v0, 32		# sleep (system call)
	li	$a0, 200	# 200 ms
	syscall

	add	$s0, $s0, 1	# bump number to display
	ble	$s0, $s1, main_loop  # next if $s0 <= 99
	li	$s0, 0		# reset to 0
	b	main_loop

display_number:
	# On entry:
	#   $a0 contains number in range 0..99 to show on 7-segment display.
	# On exit:
	#   All the s_ registers are preserved (as is normal for MIPS
	#   subroutines).

	# YOUR CODE GOES HERE

	jr	$ra
