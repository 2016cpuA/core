addi %r1.%r0,0
addi %r2,%r0,1
sll %r2,%r2,18
addi %r2,%r2,-1
out %r2
addi %r3,%r0,0
loop1:
	sw %r1,0(%r1)
	beq %r1,%r2,loop2
	addi %r1,%r1,1
	j loop1
loop2:
	lw %r4,0(%r3)
	out %r4
	beq %r3,%r2,next
	addi %r3,%r3,1
	j loop2
next:
	addi %r1.%r0,0
	addi %r2,%r0,1
	sll %r2,%r2,18
	addi %r2,%r2,-1
	out %r2
	addi %r3,%r0,0
loop3:
	sw %r1,0(%r1)
	lwc1 %f1,0(%r1)
	swc1 %f1,0(%r1)
	beq %r1,%r2,loop4
	addi %r1,%r1,1
	j loop3
loop4:
	lw %r4,0(%r3)
	out %r4
	beq %r3,%r2,end
	addi %r3,%r3,1
	j loop4
end:
	halt
