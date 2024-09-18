# find sqrt(3) using Newton's method

        .data
loop_msg:  .asciiz ":\t"
break_msg: .asciiz "\n"
x:         .float  2.0
c1:        .float  0.5
c2:        .float  1.5
zero:      .float  0.0

        .text
main:
    la         $s0, 20
    lwc1       $f0, x
    lwc1       $f2, c1
    lwc1       $f4, c2

print:
    li $v0, 1              # print iteration (int)
    la $a0, ($s0)
    syscall

    li $v0, 4              # print string
    la $a0, loop_msg
    syscall

    li $v0, 2              # print float
    mov.s $f12, $f0
    syscall

    li $v0, 4              # print string
    la $a0, break_msg
    syscall

loop:
    # TAKE IT FROM THERE

    # f(x)  = x^2 - 3
    # f'(x) = 2x
    # y     = x - f(x) / f'(x)
    #       = x - (0.5x - 1.5/x)
    #       = 0.5x + 1.5/x

    mul.s $f8, $f0, $f2    # calc 0.5*x
    div.s $f6, $f4, $f0    # calc 1.5/x
    add.s $f0, $f8, $f6

    sub $s0, $s0, 1        # loop if iteration > 0
    beq $s0, 0, exit

    j print

exit:
    li $v0, 10
    syscall
