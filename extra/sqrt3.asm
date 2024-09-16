# find sqrt(3) using Newton's method

# f(x)  = x^2 - 3
# f'(x) = 2x
# y     = x - 0.5x - 1.5/x

		.data
prompt_guess:   .asciiz "Enter initial guess:\n"
prompt_iters:   .asciiz "Enter iterations:\n"

		.text
		
main:
get_input:
	
	li $v0, 4		# iteration -> $t0 (integer)
	la $a0, prompt_iters
	syscall
	li $v0, 6
	syscall
	move $t0, $v0
	
	
	li $v0, 4		# guess -> $t1 (float)
	la $a0, prompt_guess
	syscall
	li $v0, 6
	syscall
	movf $t1, $v0

iterate:
	div $t2, $t1, 2.0     # calc 0.5x
	div.s $t3, 1.5, $t1	# calc 1.5/x
	sub.s $t1, $t1, $t2
	sub.s $t1, $t1, $t3
	
	li $v0, 2
	la $a0, $t1
	syscall
	
	sub $t0, $t0, 1		# loop if iteration > 1
	bge $t0, 1, iterate

exit:
	li $v0, 10
	syscall
