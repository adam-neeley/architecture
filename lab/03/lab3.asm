# Lab assignment: print (unsigned) numbers in binary
    .data
exit_msg: .asciiz    "Exiting..."

    .text
main:

    li  $a0, 2
    jal print_binary

    li  $a0, -1
    jal print_binary

    li  $a0, 0xF0CACC1A
    jal print_binary

    j exit

print_binary:
    li     $t0, 32              # t0 -> iteration count
    move   $t5, $a0             # load input number

loop:
    slti   $t7, $t0, 32
    srlv   $t5, $t5, $t7         # shift right

    # extract i-th digit
    and    $t2, $t5, $t7

    # character
    addi   $t6, $t2, 0x30

    li     $v0, 11
    move   $a0, $t6
    syscall

    subi   $t0, $t0, 1         # decrement counter

    bne    $t0, 0, loop     # loop 32 times

    li     $v0, 11             # print char
    li     $a0, '\n'
    syscall

    jr    $ra

exit:
    li  $v0, 4              # print str
    la  $a0, exit_msg
    syscall

    li  $v0, 10
    syscall
