#.section	".rodata"
#.align	8
l0.0:	#! 0.000000
	.word 0x0
l400.0:	#! 400.000000
	.word 0x43c80000
l1.5:	#! 1.500000
	.word 0x3fc00000
l1.0:	#! 1.000000
	.word 0x3f800000
l4.0:	#! 4.000000
	.word 0x40800000
#.section	".text"
	.text
.global	min_caml_start
min_caml_start:
	addi %r26,%r0,1
	la	%r31, l0.0	#correct flwi
	sw  %r31,0(%r0)
	lwc1 %f31,0(%r0)
	la	%r30, l400.0
	sw  %r30,0(%r0)
	lwc1 %f30,0(%r0)
	la	%r29, l1.5
	sw  %r29,0(%r0)
	lwc1 %f29,0(%r0)
	la	%r28, l1.0
	sw  %r28,0(%r0)
	lwc1 %f28,0(%r0)
	la	%r27, l4.0
	sw  %r27,0(%r0)
	lwc1 %f27,0(%r0)
	la	%r0, 0
	jal	yloop
	in	%r0
	j	min_caml_start
iloop:
	beq	%r0, r10, iloop_print1 #correct bei
	sub.s	%f2, %f2, %f3 #correct float instruction
	add.s	%f0, %f0, %f0
	mul.s	%f1, %f0, %f1
	add.s	%f0, %f2, %f4
	add.s	%f1, %f1, %f5
	mul.s	%f2, %f0, %f0
	mul.s	%f3, %f1, %f1
	add.s	%f6, %f2, %f3
	c.le.s	%r11,%f6, %f27 #correct fble
	beq		%r26,%r11,iloop_next
	la	%r0, 0
	out	%r0
	jr
iloop_print1:
	la	%r0, 1
	out	%r0
return:
	jr
iloop_next:
	addi	%r0, %r0, -1
	j	iloop
xloop:
	la	%r2, 400
	ble	%r2, %r0, return
	itof	%f0, %r0
	itof	%f1, %r1
	add.s	%f0, %f0, %f0
	add.s	%f1, %f1, %f1
	div.s	%f0, %f0, %f30
	div.s	%f1, %f1, %f30
	sub.s	%f4, %f0, %f29
	sub.s	%f5, %f1, %f28
	fmov	%f0, %f31
	fmov	%f1, %f31
	fmov	%f2, %f31
	fmov	%f3, %f31
	sw	%r0, 0(%r31)
	sw	%r1, 1(%r31)
	movi	%r0, 1000
	addi	%r31, %r31, 2
	jal	iloop
	addi	%r31, %r31, -2
	lw	%r0, 0(%r31)
	lw	%r1, 1(%r31)
	addi	%r0, %r0, 1
	j	xloop
yloop:
	movi	%r1, 400
	ble	%r1, %r0, return
	sw	%r0, 0(%r31)
	mov	%r1, %r0
	movi	%r0, 0
	addi	%r31, %r31, 1
	jal	xloop
	addi	%r31, %r31, -1
	lw	%r0, 0(%r31)
	addi	%r0, %r0, 1
	j	yloop
