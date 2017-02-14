.data
_MASK_MANTI:	
	.word	0x007fffff
.text
	.globl	min_caml_float_of_int	
min_caml_float_of_int:
	beq	%r1,%r0,.itof_ret_zero
	slt	%r2,%r1,%r0
	beq	%r2,%r0,.itof_search_upper
	sub	%r1,%r0,%r1
.itof_search_upper:
	addi	%r3,%r0,0x7f
	sll	%r3,%r3,24
	and	%r3,%r1,%r3
	beq	%r3,%r0,.itof_search_upper_l
.itof_search_upper_g:
	addi	%r3,%r0,1
	sll	%r3,%r3,30
	addi	%r4,%r0,0x80
	addi	%r5,%r0,0x7f
	addi	%r6,%r0,30
.itof_loop1:
	and	%r7,%r1,%r3
	bne	%r7,%r0,.itof_calc_manti
	srl	%r3,%r3,1
	srl	%r4,%r4,1
	srl	%r5,%r5,1
	addi	%r6,%r6,-1
	j	.itof_loop1
.itof_calc_manti:
	addi	%r7,%r6,-23
	and	%r4,%r1,%r4
	slt	%r4,%r0,%r4
	and	%r5,%r1,%r5
	slt	%r5,%r0,%r5
.itof_loop2:
	srl	%r1,%r1,1
	addi	%r7,%r7,-1
	slt	%r8,%r0,%r7
	bne	%r8,%r0,.itof_loop2
.itof_ret:
	and	%r7,%r4,%r5
	andi	%r8,%r1,1
	or	%r7,%r8,%r7
	add	%r1,%r1,%r7
	addi	%r8,%r0,1
	sll	%r8,%r8,24
	and	%r8,%r1,%r8
	beq	%r8,%r0,.itof_L1
	srl	%r1,%r1,1
	addi	%r6,%r6,1
.itof_L1:
	la	%r3,_MASK_MANTI
	lw	%r3,0(%r3)
	and	%r1,%r3,%r1
	addi	%r6,%r6,127
	andi	%r6,%r6,0xff
	sll	%r6,%r6,23
	sll	%r2,%r2,31
	or	%r1,%r1,%r6
	or	%r1,%r1,%r2
	sw	%r1,0(%r30)
	lwc1	%f0,0(%r30)
	jr	%r31
.itof_search_upper_l:
	addi	%r3,%r0,1
	sll	%r3,%r3,23
	addi	%r4,%r0,150
.itof_loop3:
	and	%r5,%r3,%r1
	bne	%r5,%r0,.itof_ret_l
	sll	%r1,%r1,1
	addi	%r4,%r4,-1
	j	.itof_loop3
.itof_ret_l:	
	la	%r3,_MASK_MANTI
	lw	%r3,0(%r3)
	and	%r1,%r3,%r1
	sll	%r4,%r4,23
	or	%r1,%r4,%r1
	sll	%r2,%r2,31
	or	%r1,%r2,%r1
	sw	%r1,0(%r30)
	lwc1	%f1,0(%r30)
	jr	%r31
.itof_ret_zero:
	sub.s	%f1,%f1,%f1
	jr	%r31
	.globl min_caml_create_array
min_caml_create_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	move	%r29,%r28
	add	%r28,%r28,%r1
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_exit
	move	%r3,%r29
_create_array_loop:
	sw	%r2,0(%r3)
	addi	%r3,%r3,1
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_loop
_create_array_exit:	
	move	%r1,%r29
	jr	%r31

	.globl min_caml_create_float_array
min_caml_create_float_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	move	%r29,%r28
	add	%r28,%r28,%r1
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_float_exit
	move	%r2,%r29
_create_array_float_loop:
	swc1	%f1,0(%r2)
	addi	%r2,%r2,1
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_float_loop
_create_array_float_exit:	
	move	%r1,%r29
	jr	%r31
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
	lw	%r4,1(%r2)
	sll	%r3,%r3,8
	andi	%r1,%r1,255	#念の為マスク
	or	%r3,%r1,%r3
	addi	%r27,%r0,3
	slt	%r27,%r4,%r27
	beq	%r27,%r0,_print_char_flush_4
	addi	%r4,%r4,1
	sw	%r3,0(%r2)
	sw	%r4,1(%r2)
	jr	%r31
_print_char_flush_4:
	out	%r3
	ori	%r4,%r0,0
	ori	%r3,%r0,0
	sw	%r3,0(%r2)
	sw	%r4,1(%r2)
	jr	%r31
	.globl _print_char_flush
_print_char_flush:	
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,1(%r2)
	addi	%r5,%r0,3
	beq	%r4,%r5,_print_char_flush_do
	addi	%r5,%r5,1
	jr	%r31
_print_char_flush_loop:
	sll	%r3,%r3,8
	ori	%r3,%r3,0x20
	addi	%r4,%r4,1
	bne	%r4,%r5,_print_char_flush_loop
_print_char_flush_do:
	out	%r3
	sw	%r0,0(%r2)
	sw	%r0,1(%r2)
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
	addi	%r8,%r30,1
	slt	%r27,%r1,%r0
	beq	%r27,%r0,_print_int_loop
	sub	%r9,%r0,%r1
	addi	%r1,%r0,45
	jal	min_caml_print_char
	addi	%r1,%r9,0
_print_int_loop:
	jal	div10
	sw	%r2,0(%r8)
	addi	%r8,%r8,1
	bne	%r1,%r0,_print_int_loop
_print_int_out:
	addi	%r8,%r8,-1
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
_BUF_READ:
	.word 0			#バッファ
	.word 0			#マスク
	.word 0			#カウンタ
	.text
	.globl min_caml_read_byte
min_caml_read_byte:
	la	%r2,_BUF_READ
	lw	%r3,0(%r2)
	lw	%r4,1(%r2)
	lw	%r5,2(%r2)
	bne	%r4,%r0,_read_byte_do
	in	%r3
	ori	%r4,%r0,255
	sll	%r4,%r4,24
	addi	%r5,%r0,3
_read_byte_do:
	and	%r1,%r3,%r4
	srl	%r4,%r4,8
	beq	%r5,%r0,_read_byte_exit
	add	%r6,%r0,%r5
_read_byte_loop:
	srl	%r1,%r1,8
	addi	%r6,%r6,-1
	bne	%r6,%r0,_read_byte_loop
_read_byte_exit:
	addi	%r5,%r5,-1
	sw	%r3,0(%r2)
	sw	%r4,1(%r2)
	sw	%r5,2(%r2)
	jr	%r31
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


	.data
_CONST_NEG:
	.word	0xbf800000
.text
	.globl min_caml_print_newline
min_caml_print_newline:	
	addi	%r1,%r0,$10
	out	%r1
	jr 	%r31
	.globl min_caml_abs_float	
min_caml_abs_float:
	sub.s 	%f1,%f1,%f1
	c.lt.s	%r1,%f0,%f1
	beq	%r1,%r0,.ret_abs
.lt0_abs:
	la 	%r1,_CONST_NEG
	lwc1	%f1,0(%r1)
	mul.s	%f0,%f0,%f1
.ret_abs:
	jr 	%r31
	.globl 	min_caml_sqrt

.text
	.globl min_caml_create_array
min_caml_create_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	move	%r29,%r28
	add	%r28,%r28,%r1
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_exit
	move	%r3,%r29
_create_array_loop:
	sw	%r2,0(%r3)
	addi	%r3,%r3,1
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_loop
_create_array_exit:	
	move	%r1,%r29
	jr	%r31

	.globl min_caml_create_float_array
min_caml_create_float_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	move	%r29,%r28
	add	%r28,%r28,%r1
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_float_exit
	move	%r2,%r29
_create_array_float_loop:
	swc1	%f1,0(%r2)
	addi	%r2,%r2,1
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_float_loop
_create_array_float_exit:	
	move	%r1,%r29
	jr	%r31
	
.data
_MASK_MANTI:	
	.word	0x007fffff
.text
	.globl	min_caml_float_of_int	
min_caml_float_of_int:
	beq	%r1,%r0,.itof_ret_zero
	slt	%r2,%r1,%r0
	beq	%r2,%r0,.itof_search_upper
	sub	%r1,%r0,%r1
.itof_search_upper:
	addi	%r3,%r0,0x7f
	sll	%r3,%r3,24
	and	%r3,%r1,%r3
	beq	%r3,%r0,.itof_search_upper_l
.itof_search_upper_g:
	addi	%r3,%r0,1
	sll	%r3,%r3,30
	addi	%r4,%r0,0x80
	addi	%r5,%r0,0x7f
	addi	%r6,%r0,30
.itof_loop1:
	and	%r7,%r1,%r3
	bne	%r7,%r0,.itof_calc_manti
	srl	%r3,%r3,1
	srl	%r4,%r4,1
	srl	%r5,%r5,1
	addi	%r6,%r6,-1
	j	.itof_loop1
.itof_calc_manti:
	addi	%r7,%r6,-23
	and	%r4,%r1,%r4
	slt	%r4,%r0,%r4
	and	%r5,%r1,%r5
	slt	%r5,%r0,%r5
.itof_loop2:
	srl	%r1,%r1,1
	addi	%r7,%r7,-1
	slt	%r8,%r0,%r7
	bne	%r8,%r0,.itof_loop2
.itof_ret:
	and	%r7,%r4,%r5
	andi	%r8,%r1,1
	or	%r7,%r8,%r7
	add	%r1,%r1,%r7
	addi	%r8,%r0,1
	sll	%r8,%r8,24
	and	%r8,%r1,%r8
	beq	%r8,%r0,.itof_L1
	srl	%r1,%r1,1
	addi	%r6,%r6,1
.itof_L1:
	la	%r3,_MASK_MANTI
	lw	%r3,0(%r3)
	and	%r1,%r3,%r1
	addi	%r6,%r6,127
	andi	%r6,%r6,0xff
	sll	%r6,%r6,23
	sll	%r2,%r2,31
	or	%r1,%r1,%r6
	or	%r1,%r1,%r2
	sw	%r1,0(%r30)
	lwc1	%f0,0(%r30)
	jr	%r31
.itof_search_upper_l:
	addi	%r3,%r0,1
	sll	%r3,%r3,23
	addi	%r4,%r0,150
.itof_loop3:
	and	%r5,%r3,%r1
	bne	%r5,%r0,.itof_ret_l
	sll	%r1,%r1,1
	addi	%r4,%r4,-1
	j	.itof_loop3
.itof_ret_l:	
	la	%r3,_MASK_MANTI
	lw	%r3,0(%r3)
	and	%r1,%r3,%r1
	sll	%r4,%r4,23
	or	%r1,%r4,%r1
	sll	%r2,%r2,31
	or	%r1,%r2,%r1
	sw	%r1,0(%r30)
	lwc1	%f1,0(%r30)
	jr	%r31
.itof_ret_zero:
	sub.s	%f1,%f1,%f1
	jr	%r31

	.data
	.align 2
_BUF:
	.word 0
	.word 0
.text
	.globl min_caml_print_char
min_caml_print_char:
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,1(%r2)
	sll	%r3,%r3,8
	andi	%r1,%r1,255
	or	%r3,%r1,%r3
	addi	%r27,%r0,3
	slt	%r27,%r4,%r27
	beq	%r27,%r0,_print_char_flush_4
	addi	%r4,%r4,1
	sw	%r3,0(%r2)
	sw	%r4,1(%r2)
	jr	%r31
_print_char_flush_4:
	out	%r3
	ori	%r4,%r0,0
	ori	%r3,%r0,0
	sw	%r3,0(%r2)
	sw	%r4,1(%r2)
	jr	%r31
	.globl _print_char_flush
_print_char_flush:	
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,1(%r2)
	addi	%r5,%r0,3
	beq	%r4,%r5,_print_char_flush_do
	addi	%r5,%r5,1
	jr	%r31
_print_char_flush_loop:	
	sll	%r3,%r3,8
	ori	%r3,%r3,0x20
	addi	%r4,%r4,1
	bne	%r4,%r5,_print_char_flush_loop
_print_char_flush_do:
	out	%r3
	sw	%r0,0(%r2)
	sw	%r0,1(%r2)
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
	addi	%r8,%r30,1
	slt	%r27,%r1,%r0
	beq	%r27,%r0,_print_int_loop
	sub	%r9,%r0,%r1
	addi	%r1,%r0,45
	jal	min_caml_print_char
	addi	%r1,%r9,0
_print_int_loop:
	jal	div10
	sw	%r2,0(%r8)
	addi	%r8,%r8,1
	bne	%r1,%r0,_print_int_loop
_print_int_out:
	addi	%r8,%r8,-1
	beq	%r8,%r30,_print_int_exit
	lw	%r1,0(%r8)
	addi	%r1,%r1,0x30
	jal	min_caml_print_char
	j	_print_int_out
_print_int_exit:
	lw	%r31,0(%r30)
	jr	%r31

	.data
_QNAN:
	.word   0x7fc00000
_HALF:
	.word	0x3f000000
.text
	.globl min_caml_print_newline
min_caml_print_newline:	
	addi	%r1,%r0,$10
	out	%r1
	jr 	%r31
	.globl min_caml_abs_float
min_caml_sqrt:
	sub.s	%f4,%f4,%f4
	c.le.s	%r1,%f4,%f0
	beq	%r1,%r0,.catch_nan
.set_sqrt:
	add.s	%f1,%f0,%f2
	la	%r1,_HALF
	lwc1	%f3,0(%r1)
.calc_sqrt:
#f0=a, f1=x_k, f2=x_(k+1), f3=0.5, f4=0.0
	div.s	%f2,%f0,%f1  #tmp=a/x0
	add.s	%f2,%f2,%f1  #
	mul.s	%f2,%f2,%f3
	c.eq.s	%r1,%f1,%f2
	bne	%r1,%r0,.ret_sqrt
	add.s	%f1,%f4,%f2
	j	.calc_sqrt
.ret_sqrt:
	add.s	%f0,%f2,%f4
	jr	%r31
.catch_nan:
	la	%r1,_QNAN
	lwc1	%f0,0(%r1)
	jr	%r31


#test
.data
	.align 	2
_test_case_abs:
	.word 	0x3f212345
	.word	0xbf212345
_test_OK:
	.word	0x214b4f09 #"\tOK!"
_test_NG:
	.word	0x2e474e09 #"\tNG."
_test_result_abs:
	.word	0x3a736261 #"abs"
.text
_test_abs:
	sub.s	%f0,%f0,%f0
	la	%r1,_test_result_abs
	lw 	%r1,0(%r1)
	out	%r1
	la 	%r1,_test_case_abs
	lwc1	%f2,0(%r1)
	lwc1	%f3,4(%r1)
	add.s	%f0,%f0,%f2
	sw	%r31,0(%r30)
	jal	min_caml_abs_float
	c.eq.s	%r1,%f0,%f2
	beq	%r1,%r0,_test_result_NG
	sub.s 	%f0,%f0,%f0
	add.s	%f0,%f0,%f3
	jal	min_caml_abs_float
	c.eq.s	%r1,%f0,%f2
	beq	%r1,%r0,_test_result_NG
_test_result_OK:
	la 	%r1,_test_OK
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31
_test_result_NG:
	la 	%r1,_test_NG
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31


	.globl _test_create_array
_test_create_array:
	li	%r1,33
	li	%r2,-1023
	jal	min_caml_create_array
	move	%r3,%r1
	li	%r2,33
loop1:
	lw	%r1,0(%r3)
	add	%r1,%r1,%r2
	jal	min_caml_print_int
	li	%r1,10
	jal	min_caml_print_char
	addi	%r3,%r3,4
	addi	%r2,%r2,-1
	slt	%r27,%r2,%r0
	beq	%r27,%r0,loop1
	jr	%r31


.data
	.align 	2
_test_OK:
	.word	0x214b4f09 #"\tOK!"
_test_NG:
	.word	0x2e474e09 #"\tNG."
_2_i:
	.word	0x00000009
_2_f:
	.word   0x41100000
_-2147483647_i:
	.word	0x80000001
_-2147483648_f:
	.word	0xcf000000
_test_result_atoi:
	.word	0x3a693261
.text
_test_itof:
	sw	%r31,0(%r30)
	addi	%r30,%r30,4
	la	%r1,_test_result_atoi
	lw	%r1,0(%r1)
	out	%r1
	la 	%r1,_2_i
	lw	%r1,0(%r1)
	jal	min_caml_itof
	la 	%r1,_2_f
	lwc1	%f1,0(%r1)
	c.eq.s	%r1,%f1,%f0
	addi	%r30,%r30,-4
	beq	%r1,%r0,_test_result_NG
	j	_test_result_OK
_test_result_OK:
	la 	%r1,_test_OK
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31
_test_result_NG:
	la 	%r1,_test_NG
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31

.globl _test_print_char
_test_print_char:
	addi	%r1,%r0,0x41
	jal	min_caml_print_char
	addi	%r1,%r0,0x72
	jal	min_caml_print_char
	jal	_print_char_flush
	addi	%r1,%r0,0x6f
	jal	min_caml_print_char
	addi	%r1,%r0,0x6e
	jal	min_caml_print_char
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	jal	_print_char_flush
	addi	%r1,%r0,765
	jal	min_caml_print_int
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	addi	%r1,%r0,0
	jal	min_caml_print_int
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	addi	%r1,%r0,-216
	jal	min_caml_print_int
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	jal	_print_char_flush
	jr 	%r31

.data
_2:
	.word   0x40000000
_sqrt2:
	.word	0x3fb504f3
_sqrt0_5:
	.word	0x3f3504f3
_test_result_sqrt:	
	.word   0x3a747173 #"sqt"
_test_OK:
	.word	0x214b4f09 #"\tOK!"
_test_NG:
	.word	0x2e474e09 #"\tNG."
.text
_test_sqrt:
	sw	%r31,0(%r30)
	la 	%r1,_test_result_sqrt
	lw 	%r1,0(%r1)
	out 	%r1
	la	%r1,_2
	lwc1	%f0,0(%r1)
	jal	min_caml_sqrt
	la	%r1,_sqrt2
	lwc1	%f1,0(%r1)
	c.eq.s	%r1,%f0,%f1
	beq	%r1,%r0,_test_result_NG
	la	%r1,_HALF	
	lwc1	%f0,0(%r1)
	jal	min_caml_sqrt
	la	%r1,_sqrt0_5
	lwc1	%f1,0(%r1)
	c.eq.s	%r1,%f0,%f1
	beq	%r1,%r0,_test_result_NG
	j	_test_result_OK
_test_result_OK:
	la 	%r1,_test_OK
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31
_test_result_NG:
	la 	%r1,_test_NG
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31

	.globl _min_caml_start
_min_caml_start:
	jal	_test_abs
	jal	_test_create_array
	jal	_test_itof
	jal	_test_print_char
	jal	_test_sqrt
	j	SYS_EXIT


