bigsum1:
    add     $v0, $0, $0
    add     $t0, $0, $0
loop1:
    slt     $t1, $t0, $a0
    beq     $t1, $0, return1
    add     $v0, $v0, $t0
    addi    $t0, $t0, 1
    b       loop1
return1:
    jr      $ra
