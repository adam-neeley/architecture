# find sqrt(a) using Newton's method

# f(x)  = x^2 - 3
# f'(x) = 2x
# y     = x - f(x) / f'(x)
#       = x - (0.5x - 1.5/x)
#       = 0.5x + 1.5/x
#       = x/(two) + (z)/two/x

        .data
loop_msg:       .asciiz     ":\t"
break_msg:      .asciiz     "\n"
iterations:     .word       20
a:              .float      3.0           # sqrt(a)
initial_guess:  .float      2.0
two:            .float      2.0

        .text
main:
    lw          $s0,        iterations
    lwc1        $f0,        initial_guess
    lwc1        $f2,        a
    lwc1        $f4,        two

print:
    li          $v0,        1            # print iteration (int)
    la          $a0,        ($s0)
    syscall

    li          $v0,        4            # print string
    la          $a0,        loop_msg
    syscall

    li          $v0,        2            # print float
    mov.s       $f12,       $f0
    syscall

    li          $v0,        4            # print string
    la          $a0,        break_msg
    syscall

loop:

    div.s       $f8,    $f0,    $f4    # calc x/2
    div.s       $f10,   $f2,    $f4    # calc 3/2
    div.s       $f6,    $f10,   $f0    # calc (3/2)/x
    add.s       $f0,    $f8,    $f6

    sub         $s0,    $s0,    1      # loop if iteration > 0
    beq         $s0,    0,      exit

    j           print

exit:
    li          $v0,    10
    syscall
