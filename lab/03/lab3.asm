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
    li     $t9, 0x80000000
    move   $t5, $a0             # load input number

loop:

    and   $a0, $t5, $t9        # extract left-most digit
    sltu  $a0, $0,  $a0
    ori   $a0, $a0, 0x30       # set character

    li       $v0, 11              # print character
    syscall

    srl    $t9, $t9, 1          # shift mask right

    bnez   $t9, loop        # loop 32 times

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
