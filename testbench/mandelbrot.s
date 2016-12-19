	.data
	.align 2
_BUF:
	.word 0		#buffer本体
	.word 0		#カウンタ
.text
	.globl min_caml_print_char
min_caml_print_char:
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,4(%r2)
	sll	%r3,%r3,8
	andi	%r1,%r1,255	#念の為マスク
	or	%r3,%r1,%r3
	addi	%r27,%r0,3
	slt	%r27,%r4,%r27
	beq	%r27,%r0,_print_char_flush_4
	addi	%r4,%r4,1
	sw	%r3,0(%r2)
	sw	%r4,4(%r2)
	jr	%r31
_print_char_flush_4:
	out	%r3
	ori	%r4,%r0,0
	ori	%r3,%r0,0
	sw	%r3,0(%r2)
	sw	%r4,4(%r2)
	jr	%r31
div10:
	move	%r3,%r1
	ori	%r4,%r0,1
	addi	%r2,%r0,255
	sll	%r2,%r2,24
	and	%r7,%r3,%r2
	beq	%r7,%r0,3
	sll	%r4,%r4,30
	j	div10_init2
	srl	%r2,%r2,8
	and	%r7,%r3,%r2
	beq	%r7,%r0,3
	sll	%r4,%r4,23
	j	div10_init2
	srl	%r2,%r2,8
	and	%r7,%r3,%r2
	beq	%r7,%r0,3
	sll	%r4,%r4,15
	j	div10_init2
	sll	%r4,%r4,7
div10_init2:	
	andi	%r1,%r1,0
div10_0:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_1
	bne	%r4,%r0,3
	addi	%r2,%r0,0
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_0
div10_1:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_3
	bne	%r4,%r0,3
	addi	%r2,%r0,1
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_2
div10_2:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_5
	bne	%r4,%r0,3
	addi	%r2,%r0,2
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_4
div10_3:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_7
	bne	%r4,%r0,3
	addi	%r2,%r0,3
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_6
div10_4:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_9
	bne	%r4,%r0,3
	addi	%r2,%r0,4
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_8
div10_5:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_1
	bne	%r4,%r0,3
	addi	%r2,%r0,5
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_0
div10_6:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_3
	bne	%r4,%r0,3
	addi	%r2,%r0,6
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_2
div10_7:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_5
	bne	%r4,%r0,3
	addi	%r2,%r0,7
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_4
div10_8:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_7
	bne	%r4,%r0,3
	addi	%r2,%r0,8
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_6
div10_9:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_9
	bne	%r4,%r0,3
	addi	%r2,%r0,9
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_8
	.globl min_caml_print_int
min_caml_print_int:
	bne	%r0,%r1,_print_int_init
	addi	%r1,%r1,48
	j	min_caml_print_char
_print_int_init:
	slt	%r27,%r1,%r0
	sw	%r31,0(%r30)
	addi	%r8,%r30,4
	slt	%r27,%r1,%r0
	beq	%r27,%r0,_print_int_loop
	sub	%r9,%r0,%r1
	addi	%r1,%r0,45
	jal	min_caml_print_char
	addi	%r1,%r9,0
_print_int_loop:
	jal	div10
	sw	%r2,0(%r8)
	addi	%r8,%r8,4
	bne	%r1,%r0,_print_int_loop
_print_int_out:
	addi	%r8,%r8,-4
	beq	%r8,%r30,_print_int_exit
	lw	%r1,0(%r8)
	addi	%r1,%r1,0x30
	jal	min_caml_print_char
	j	_print_int_out
_print_int_exit:
	lw	%r31,0(%r30)
	jr	%r31


	.data
	.align 2
RADIUS: #4.000000
	.word 0x40800000
MAX_FLOAT: #128.000000
	.word 0x43000000
_1:
	.word 0x3f800000
_1_5:
	.word 0x3fc00000
_0:
	.word 0x00000000
.text
.globl _min_caml_start
_min_caml_start:
	sub	%r0,%r0,%r0
	la	%r22,RADIUS
	lwc1	%f24,0(%r22)
	lwc1	%f25,4(%r22)
	lwc1	%f26,8(%r22)
	lwc1	%f27,12(%r22)
	addi	%r25,%r0,128
_print_header:
	addi	%r27,%r0,0x5031
	sll	%r27,%r27,16
	addi	%r27,%r27,0x200a
	out	%r27
	addi	%r27,%r0,0x3132
	sll	%r27,%r27,16
	addi	%r27,%r27,0x3820
	out	%r27
	out 	%r27
	addi	%r1,%r0,0x31
	jal	min_caml_print_char
	addi	%r1,%r0,0x0a
	jal	min_caml_print_char
#f24=4.0,f25=128.0,f26=1.0,f27=1.5,mem(r22+16)=0.
#r26=1,r25=128
	addi	%r24,%r0,0
#r23=x,r24=y
yloop:
	addi	%r23,%r0,0
	add	%r1,%r24,%r24
	jal	min_caml_float_of_int
	div.s	%f1,%f1,%f25
	sub.s	%f8,%f1,%f26
_xloop:
	add	%r1,%r23,%r23
	jal	min_caml_float_of_int
	div.s	%f1,%f1,%f25
	sub.s	%f9,%f1,%f27
#f8=ci,f9=cr
	lwc1	%f2,16(%r22)	
	lwc1	%f3,16(%r22)
	lwc1	%f4,16(%r22)
	lwc1	%f5,16(%r22)
	addi	%r2,%r0,8192
iloop:
#f2=zr,f3=zi,f4=zr2,f5=zi2,r2=i
	bne 	%r2,%r0,iloop_next
	addi	%r1,%r0,1
	jal	min_caml_print_int
	j	xloop_end
iloop_next:
	sub.s	%f0,%f4,%f5
	add.s	%f0,%f0,%f9
	add.s	%f1,%f2,%f2
	mul.s	%f1,%f1,%f3
	add.s	%f1,%f1,%f8
	mul.s	%f2,%f0,%f26
	mul.s	%f3,%f1,%f26
	mul.s	%f4,%f2,%f2
	mul.s	%f5,%f3,%f3
	add.s	%f0,%f4,%f5
	addi	%r2,%r2,-1	
	c.lt.s	%r1,%f24,%f0
	beq	%r1,%r0,iloop
	addi	%r1,%r0,0
	jal	min_caml_print_int
xloop_end:	
	addi	%r23,%r23,1
	slt	%r27,%r23,%r25
	bne	%r27,%r0,_xloop	
	addi	%r24,%r24,1
	slt	%r27,%r24,%r25
	bne	%r27,%r0,yloop
_print_char_flush:	
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,4(%r2)
	addi	%r5,%r0,4
_print_char_flush_loop:		#4バイトに足りない分の空白を詰める(今回はそれで一応問題ない
	sll	%r3,%r3,8
	ori	%r3,%r3,0x20
	addi	%r4,%r4,1
	bne	%r4,%r5,_print_char_flush_loop
_print_char_flush_do:
	out	%r3
	sw	%r0,0(%r2)
	sw	%r0,4(%r2)
	halt