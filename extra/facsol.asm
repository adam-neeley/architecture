main:
	li	$a0, 5		# arg to pass to 'factorial'
	jal	factorial	# v0 = 5!
	move	$a0, $v0	# save result in a0 to print it
	li	$v0, 1		# syscall to print integer
	syscall
	
	li	$v0, 10		# syscall to exit
	syscall
	
factorial:
	# on entry:
	#   a0 = n, the number to take factorial of
	# on exit:
	#   v0 = factorial of a0
	addi	$sp, $sp, -8    # create stack frame
	sw	$ra, 0($sp)     # save caller's return address
	sw	$s0, 4($sp)     # save caller's s0
		
	li	$s0, 1		# ready to compare
	ble	$a0, $s0, return1 # if n <= 1, return 1
	move	$s0, $a0	# save n in s0
	addi	$a0, $a0, -1	# read to call factorial(n - 1)
	jal	factorial	# v0 = factorial(n - 1)
	mult	$v0, $s0	# hi/lo = n * factorial(n - 1)
	mflo	$v0		# v0 = n * factorial(n - 1)
	b	done
return1:
	li	$v0, 1		# return 1
done:
	lw	$s0, 4($sp)     # restore caller's s0
	lw	$ra, 0($sp)     # restore caller's return address
	addi	$sp, $sp, 8     # remove stack frame
	jr	$ra
