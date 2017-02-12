	addi %r1,%r0,325
	addi %r2,%r0,325
	addi %r5,%r0,32767
	addi %r6,%r0,1024
	addi %r7,&r0,32768
inloop:
	in %r3
	sw %r3,0(%r1)
	addi %r1,%r1,-1
	jal loop
	beq %r1,%r0,outloop
	j inloop
outloop:
	lw %r4,0(%r2)
	addi %r2,%r2,-1
	out %r4
	beq %r2,%r0,end
	j outloop
loop:
	sw %r31,0(%r7)
	j loop_sub
	addi %r5,%r5,32767
	addi %r6,%r6,-1
	bne %r6,%r0,loop
	jr %r31
loop_sub:
	addi %r5,%r5,-1
	bne %r5,%r0,loop_sub
	jr
end:
	halt
