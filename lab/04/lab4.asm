    .data
newline:    .asciiz    "\n"
k:          .word      8

    .text
main:
    li      $t9,    0     # count number instructions

    lw      $a0,    k
    jal     bigsum1
    jal     print

    lw      $a0,    k
    jal     bigsum2
    jal     print

    lw      $a0,    k
    jal     gauss
    jal     print

    b       exit

print:
    move    $a0,    $v0
    li      $v0,    1
    syscall

    li      $v0,    4
    la      $a0,    newline
    syscall

    move    $a0,    $t9
    li      $v0,    1
    syscall

    li      $v0,    4
    la      $a0,    newline
    syscall

    jr      $ra

# on entry, a0 = k, an integer
# on exit, v0 = sum all integers from 0 to k-1
bigsum1:
    addi    $t9,    $t9,    2
    add     $v0,    $0,     $0
    add     $t0,    $0,     $0

loop1:
    addi    $t9,    $t9,    2
    slt     $t1,    $t0,    $a0
    beq     $t1,    $0,     return1
    addi    $t9,    $t9,    3
    add     $v0,    $v0,    $t0
    addi    $t0,    $t0,    1
    b       loop1

return1:
    addi    $t9,    $t9,    1
    jr      $ra

# on entry, a0 = k, an integer
# on exit, v0 = sum all integers from 0 to k-1
bigsum2:
    add     $t9,    $0,     $0
    addi    $t9,    $t9,    2
    addi    $a0,    $a0,    -1
    add     $v0,    $0,     $0

loop2:
    addi    $t9,    $t9,    3
    add     $v0,    $v0,    $a0
    add     $a0,    $a0,    -1
    bne     $a0,    $0,     loop2
    addi    $t9,    $t9,    1
    jr      $ra

gauss:
    add     $t9,    $0,     5
    addi    $t0,    $a0,    -1
    mult    $t0,    $a0
    mflo    $t0
    srl     $v0,    $t0,    1
    jr      $ra


exit:
    li      $v0,    10            # exit program
    syscall
