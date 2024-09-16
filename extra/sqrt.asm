# find sqrt(3) using Newton's method

# f(x)  = x^2 - 3
# f'(x) = 2x
# y     = x - 0.5x - 1.5/x

        .data
loop_msg:  .asciiz "\nLoop\n"
x:         .float  3.0
c1:        .float  0.5
c2:        .float  1.5

        .text
main:

    li         $t0, 10

    lwc1       $f0, x
    lwc1       $f2, c1
    lwc1       $f4, c2

    cvt.s.w    $f0, $f0
    cvt.s.w    $f2, $f2
    cvt.s.w    $f4, $f4
            
loop:
    # TAKE IT FROM THERE
    div.s $f5, $f4, $f0    # calc 1.5/x
    div.s $f6, $f0, $f2    # calc x/2
    sub.s $f0, $f0, $f5
    sub.s $f0, $f0, $f6
    
    sub $t0, $t0, 1        # loop if iteration > 0

    jal print

    beq $t0, 0, exit
    j loop

print:
    li $v0, 1              # print string
    la $a0, ($t0)
    syscall

    li $v0, 4              # print string
    la $a0, loop_msg
    syscall

    li $v0, 2              # print float
    mov.s $f12, $f0
    syscall

    jr $ra

exit:
    li $v0, 10
    syscall
