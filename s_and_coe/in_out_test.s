	j start
	.globl	min_caml_read_int
min_caml_read_int:
	in	%r1
	jr	%r31
	.globl	min_caml_read_float
min_caml_read_float:
	in	%r29	
	sw	%r29,0(%r30)
	lwc1	%f1,0(%r30)
	jr	%r31
	
start:
	addi %r2,%r0,10
	addi %r10, %r0,315
	addi %r4,%r0,1
	addi %r1,%r1,0x459c
	sll	 %r1,%r1,16
	addi %r1,%r1,0x4000
	addi %r11,%r0,0
	sw %r1,0(%r0)
	lwc1 %f1,0(%r0)
loop1:	
	in %r3
	out %r3
	addi %r2,%r2,-1
	beq %r2,%r0,loop2
	j loop1
loop2:
	jal min_caml_read_int
	sw %r1,1(%r0)
	lwc1 %f2,1(%r0)
	swc1 %f2,2(%r0)
	lw %r2,2(%r0)
	out %r2
	addi %r10,%r10,-1
	bne %r10,%r11,loop2
	halt
