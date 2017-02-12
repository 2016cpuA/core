	ADDI %r2,%r0,100
	addi %r10, %r0,100
	addi %r4,%r0,1
	addi %r1,%r1,0x3f80
	addi %r11,%r0,0
	sll %r1,%r1,16
	sw %r1,0(%r0)
	lwc1 %f1,0(%r0)
loop1:	
	IN %r3
	add %r3,%r3,%r4
	OUT %r3
	ADDI %r2,%r2,$-1
	BEQ %r2,%r0,loop2
	J loop1
loop2:
	in %r1
	sw %r1,1(%r0)
	lwc1 %f2,1(%r0)
	c.eq.s %r5,%f1,%f2
	c.eq.s %r6,%f2,%f1
	c.lt.s %r7,%f1,%f2
	c.lt.s %r8,%f2,%f1
	add %r2,%r1,%r5
	add %r3,%r1,%r6
	add %r4,%r1,%r7
	add %r5,%r1,%r8
	out %r2
	out %r3
	out %r4
	out %r5
	addi %r10,%r10,-1
	bne %r10,%r11,end
	j loop2
end:
	HALT
