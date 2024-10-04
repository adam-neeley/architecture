# fib

main:
    addi    $sp $sp     -4
    sw      $ra ($sp)
    addi    $a0 $zero   7
    jal     fibo
    b       end
L0:
    lw      $ra ($sp)
    addi    $sp $sp     4
    jr      $ra
fibo:
    addi    $sp $sp     -12
    sw      $s0 0($sp)
    sw      $t1 4($sp)
    sw      $ra 8($sp)
    slti    $t0 $a0     3
    beq     $t0 $zero   else
    addi    $v0 $zero   1
    b       exit
else:
    add     $s0 $a0     $zero
    addi    $a0 $a0     -1
    jal     fibo
ret1:
    add     $t1 $v0     $zero
    addi    $a0 $s0     -2
    jal     fibo
ret2:
    add     $v0 $t1     $v0
exit:
    lw      $s0 0($sp)
    lw      $t1 4($sp)
    lw      $ra 8($sp)
    addi    $sp $sp     12
    jr      $ra

end:
    add $a0 $zero $v0
    li $v0 1
    syscall

    li $v0 10
    syscall
