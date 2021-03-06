org 0x0000

main0:
        #initialization
        ori $s0, $zero, 256  #counter
        ori $s2, $zero, 0x0000  #sum
        ori $s3, $zero, 0xFFFF  #min
        ori $s4, $zero, 0x0000  #max
        lw $sp, global_sp($0)
loop0:  
        beq $s0, $zero, exit0
lock0:    
        jal lock
        lw $sp, global_sp($0)
        bne $zero, $sp, work0
        jal unlock
        j lock0

exit0:
        sw $s2, sum_variable($0)
        sw $s3, min_variable($0)
        sw $s4, max_variable($0)
	addu $a0, $zero, $s2
        ori $a1, $zero, 256
        jal divide
        sw $v0, mean_variable($0)
        halt

work0:  
        pop $s1
        sw $sp, global_sp($0)
        jal unlock
        andi $s1, $s1, 0xFFFF
        addu $s2, $s2, $s1
	addu $a0, $zero, $s1
	addu $a1, $zero, $s4
        jal max
	addu $s4, $v0, $zero
	addu $a0, $zero, $s1
	addu $a1, $s3, $zero	
        jal min
        addu $s3, $zero, $v0
        addi $s0, $s0, -1
        j loop0

# Generate random number
org 0x0200

main1:
        lw $sp, global_sp($0)
        ori $s0, $zero, 256
        ori $s2, $zero, 0x1500
        lw $s1, seed($zero)
loop1:
        beq $s0, $zero, exit1
	addu $a0, $zero, $s1
        jal crc32
	addu $s1, $zero, $v0
        jal lock
        lw $sp, global_sp($0)
        push $s1
        addi $s2, $s2, 4
        sw $sp, global_sp($0)
        jal unlock
        addi $s0, $s0, -1
        j loop1

exit1:
        halt

#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
        
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------


        
# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------

lock:
acquire:
        ll $t0, lock_variable($0)
        bne $zero, $t0, acquire
	addiu $t1, $t1, 1
        sc $t1, lock_variable($0)
        beq $t1, $zero, lock
        jr $ra
unlock:
        sw $zero, lock_variable($0)
        jr $ra


org 0x1000
sum_variable:
        cfw 0x0000
mean_variable:
        cfw 0x0000
seed:
        cfw 0x0010
global_sp:
        cfw 0x0000
lock_variable:
        cfw 0x0000 
max_variable:
        cfw 0x0000
min_variable:
        cfw 0xFFFF


org 0x1500
value:  
        cfw 0x0000

