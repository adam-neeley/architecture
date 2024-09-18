	.data
target_number:
	.word	7	# preinitialized to 7 in case you want to skip
			# overwriting it with a random number
hello_msg:
	.ascii	"I have chosen a number between 0 and 9 inclusive.\n"
	.asciiz "See if you can guess it.\n\nEnter your guess: "
too_big_msg:
	.asciiz "Too big. Guess again: "
too_small_msg:
	.asciiz "Too small. Guess again: "
right_msg:
	.asciiz "Right!\n"

	.text
main:
	la	$t0, target_number	# t0 -> target number
					# (that is, t0 holds address of
					#  target number)

	# COMMENT OUT THIS BLOCK OF CODE TO SKIP RANDOM NUMBER GENERATION
	li	$v0, 42			# generate random number
	li	$a0, 1			# id of random-number generator
	li	$a1, 9			# upper bound of range: 0..9
	syscall				# $a0 = random integer
	sw	$a0, 0($t0)		# save it to memory
	#################################################################

	li	$v0, 4			# print string
	la	$a0, hello_msg
	syscall

	lw	$s0, 0($t0)		# s0 = target number
loop:
	li	$v0, 5			# input an integer
	syscall				# guess is now in $v0

	# YOUR CODE GOES HERE . . .
	bgt 	$v0, $s0, too_big
	blt 	$v0, $s0, too_small
	li	$v0, 4			# print string
	la	$a0, right_msg
	syscall
	li 	$v0, 10
	syscall
too_big:
	li	$v0, 4			# print string
	la	$a0, too_big_msg
	syscall
	b 	loop
too_small:
	li	$v0, 4			# print string
	la	$a0, too_small_msg
	syscall
	b 	loop

