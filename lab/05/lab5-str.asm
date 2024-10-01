# Lab assignment: Display numbers 0..99 on a seven-segment display

	.data
	# HINT: Make a look-up table

digits_table:
	.byte  0x3f	# 0011 1111 # 0
	.byte  0x06	# 0000 0110 # 1
	.byte  0x5b	# 0101 1011 # 2
	.byte  0x4f	# 0100 1111 # 3
	.byte  0x66	# 0110 0110 # 4
	.byte  0x6d	# 0110 1101 # 5
	.byte  0x7d	# 0111 1101 # 6
	.byte  0x27	# 0010 0111 # 7
	.byte  0x7f	# 0111 1111 # 8
	.byte  0x6f	# 0110 1111 # 9

line_break:
	.asciiz "\n"

numbers:
	.ascii " 000 "
	.ascii "0   0"
	.ascii "0   0"
	.ascii " 000 "
	.ascii "  0  "
	.ascii " 00  "
	.ascii "  0  "
	.ascii " 000 "
	.ascii " 000 "
	.ascii "0   0"
	.ascii "  00 "
	.ascii "00000"
	.ascii " 0000"
	.ascii "  000"
	.ascii "    0"
	.ascii " 0000"
	.ascii "0  0 "
	.ascii "00000"
	.ascii "   0 "
	.ascii "   0 "
	.ascii " 000 "
	.ascii "0   0"
	.ascii "0   0"
	.ascii " 000 "
	.ascii "  0  "
	.ascii " 00  "
	.ascii "  0  "
	.ascii " 000 "
	.ascii " 000 "
	.ascii "0   0"
	.ascii "  00 "
	.ascii "00000"
	.ascii " 0000"
	.ascii "  000"
	.ascii "    0"
	.ascii " 0000"
	.ascii "0  0 "
	.ascii "00000"
	.ascii "   0 "
	.ascii "   0 "

	.text
main:

	li $s0, 0		# s0 is counter: cycles through 0..99
	li $s1, 99		# s1 = upper limit

main_loop:
	move	$a0, $s0	# ready to display $s0 on the LEDs
	jal	display_number

	li	$v0, 32		# sleep (system call)
	li	$a0, 200	     # 200 ms
	syscall

	add	$s0, $s0, 1	     # bump number to display
	ble	$s0, $s1, main_loop  # next if $s0 <= 99
	li	$s0, 0		     # reset to 0
	b	main_loop

display_number:
	# On entry:
	#   $a0 contains number in range 0..99 to show on 7-segment display.
	# On exit:
	#   All the s_ registers are preserved (as is normal for MIPS
	#   subroutines).

	# YOUR CODE GOES HERE
	move    $s0, $a0
	la   	$s6, digits_table
	li   	$s4, 0xffff0010

	li   	$t8, 10
	
	
	div  	$a0, $t8
	mfhi 	$t0 # t0 -> tens digit
	mflo 	$t1 # t1 -> ones digit

	
	add  	$t2, $s6, $t0
	lb   	$t3, 0($t2)
	sb   	$t3, 0($s4)
		
	add     $t4, $s6, $t1
	lb      $t6, 0($t4)
	sb      $t6, 1($s4)

	la $s3 numbers

	lb $s0 ($t0) # left digit
	lb $s1 ($t1) # right digit

	li $t7 0 # line_counter = 0
print_line:
	la $a0 line_break
	li $v0 4
	syscall

	li $t8 0 # char_counter = 0
print_char:
	# li $v0 11
	#
	# add $a0 numbers $t8
	# lb $a0 ($a0)
	# syscall

	add $t0 $s0 $s3
	add $t1 $t1 $s3

	addi $t8 $t8 1
	bne $t8 5 print_char

	addi $t7 $t7 1
	bne $t7 4 print_line
	
	jr	$ra
