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
_print_char_flush_loop:		#4バイトに足りない分の空白を詰める(今回はそれで一応問題ない
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
l.23064:	 # 128.000000
	.word	1124073472
l.22869:	 # 0.900000
	.word	1063675494
l.22868:	 # 0.200000
	.word	1045220557
l.22131:	 # 150.000000
	.word	1125515264
l.22097:	 # -150.000000
	.word	-1021968384
l.22037:	 # 0.100000
	.word	1036831949
l.21943:	 # -2.000000
	.word	-1073741824
l.21929:	 # 0.003906
	.word	998244352
l.21816:	 # 100000000.000000
	.word	1287568416
l.21812:	 # 1000000000.000000
	.word	1315859240
l.21807:	 # 20.000000
	.word	1101004800
l.21806:	 # 0.050000
	.word	1028443341
l.21801:	 # 0.250000
	.word	1048576000
l.21797:	 # 10.000000
	.word	1092616192
l.21791:	 # 0.300000
	.word	1050253722
l.21790:	 # 255.000000
	.word	1132396544
l.21789:	 # 0.150000
	.word	1041865114
l.21785:	 # 16777216.000000
	.word	1266679808
l.21784:	 # -16777216.000000
	.word	-880803840
l.21783:	 # 3.141593
	.word	1078530011
l.21782:	 # 30.000000
	.word	1106247680
l.21781:	 # 15.000000
	.word	1097859072
l.21780:	 # 0.000100
	.word	953267991
l.21553:	 # -0.100000
	.word	-1110651699
l.21474:	 # 0.010000
	.word	1008981770
l.21473:	 # -0.200000
	.word	-1102263091
l.20867:	 # -200.000000
	.word	-1018691584
l.20865:	 # 200.000000
	.word	1128792064
l.20861:	 # 0.017453
	.word	1016003125
l.20817:	 # 1.570796
	.word	1070141403
l.20816:	 # 0.000000
	.word	786163455
l.20815:	 # 4.000000
	.word	1082130432
l.20814:	 # 3.000000
	.word	1077936128
l.20813:	 # 0.500000
	.word	1056964608
l.20812:	 # -1.000000
	.word	-1082130432
l.20801:	 # 2147483648.000000
	.word	1325400064
l.20790:	 # -2147483648.000000
	.word	-822083584
l.20771:	 # 2.000000
	.word	1073741824
l.20768:	 # 1.000000
	.word	1065353216
l.20767:	 # 0.000000
	.word	0
	.text
	.globl  _min_caml_start
fiszero.2599:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27454
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27454:
	ADDI	%r1, %r0, 1
	JR	%r31
fispos.2601:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27455
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27455:
	ADDI	%r1, %r0, 1
	JR	%r31
fisneg.2603:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27456
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27456:
	ADDI	%r1, %r0, 1
	JR	%r31
fneg.2605:
	SUB.s	%f1, %f0, %f1
	JR	%r31
fless.2607:
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27457
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27457:
	ADDI	%r1, %r0, 1
	JR	%r31
fsqr.2612:
	MUL.s	%f1, %f1, %f1
	JR	%r31
abs_float.2614:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27458
	JR	%r31
BEQ_else.27458:
	SUB.s	%f1, %f0, %f1
	JR	%r31
fabs.2616:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27459
	JR	%r31
BEQ_else.27459:
	SUB.s	%f1, %f0, %f1
	JR	%r31
set_arr_x.6362:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27460
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27461
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27462
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27463
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	J	set_arr_x.6362
BEQ_else.27463:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.27462:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.27461:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.27460:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
calc_floor.6367:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.27464
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27465
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.27466
BEQ_else.27465:
	SUB.s	%f2, %f1, %f2
BEQ_cont.27466:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27467
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.27468
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27469
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.27470
BEQ_else.27469:
	SUB.s	%f2, %f1, %f2
BEQ_cont.27470:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27471
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.27471:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.27468:
	JR	%r31
BEQ_else.27467:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.27472
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27473
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.27474
BEQ_else.27473:
	SUB.s	%f2, %f1, %f2
BEQ_cont.27474:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27475
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.27475:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.27472:
	JR	%r31
BEQ_else.27464:
	JR	%r31
int_of_float.2622:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27476
	LA	%r29, l.20801
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27477
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27477:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r3, 1(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27478
	SWC1	%f1, 0(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27480
	SWC1	%f1, 1(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27482
	SWC1	%f1, 2(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 3
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27483
BEQ_else.27482:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 2(%r3)
	ADDI	%r1, %r0, 2
BEQ_cont.27483:
	J	BEQ_cont.27481
BEQ_else.27480:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 1(%r3)
	ADDI	%r1, %r0, 1
BEQ_cont.27481:
	J	BEQ_cont.27479
BEQ_else.27478:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r1, %r0, 0
BEQ_cont.27479:
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27484
	ADDI	%r2, %r1, 1
	LW	%r4, 1(%r30)
	ADD	%r29, %r4, %r2
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	LW	%r3, 0(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27485
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.27486
BEQ_else.27485:
	SUB.s	%f2, %f1, %f2
BEQ_cont.27486:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27487
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 1
	ADDI	%r1, %r1, -1
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	J	calc_floor.6367
BEQ_else.27487:
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	J	calc_floor.6367
BEQ_else.27484:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27476:
	LA	%r29, l.20790
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27488
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27488:
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r3, 1(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27489
	SWC1	%f1, 0(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27491
	SWC1	%f1, 1(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27493
	SWC1	%f1, 2(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 3
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27494
BEQ_else.27493:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 2(%r3)
	ADDI	%r1, %r0, 2
BEQ_cont.27494:
	J	BEQ_cont.27492
BEQ_else.27491:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 1(%r3)
	ADDI	%r1, %r0, 1
BEQ_cont.27492:
	J	BEQ_cont.27490
BEQ_else.27489:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r1, %r0, 0
BEQ_cont.27490:
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27495
	ADDI	%r2, %r1, 1
	LW	%r4, 1(%r30)
	ADD	%r29, %r4, %r2
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	LW	%r3, 0(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27497
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.27498
BEQ_else.27497:
	SUB.s	%f2, %f1, %f2
BEQ_cont.27498:
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27499
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 1
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6367
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27500
BEQ_else.27499:
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6367
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27500:
	J	BEQ_cont.27496
BEQ_else.27495:
	ADDI	%r1, %r0, 0
BEQ_cont.27496:
	SUB	%r29, %r0, %r1
	ADDI	%r1, %r29, 0
	JR	%r31
calc_cos.6332.12353:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27501
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27501:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27503
	JR	%r31
BEQ_else.27503:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332.12353
calc_cos.6332:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27505
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27505:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27507
	JR	%r31
BEQ_else.27507:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27509
	JR	%r31
BEQ_else.27509:
	SW	%r1, 10(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27511
	JR	%r31
BEQ_else.27511:
	SW	%r1, 14(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 14(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332
mycos_step1.2626:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27513
	ADDI	%r1, %r0, 16
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 0(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 14
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 0(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 12
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 0(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 10
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332
BEQ_else.27513:
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27514
	ADDI	%r1, %r0, 16
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 14
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	calc_cos.6332.12353
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27515
BEQ_else.27514:
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
BEQ_cont.27515:
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	JR	%r31
calc_sin.6307.12304:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27516
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27516:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27518
	JR	%r31
BEQ_else.27518:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 8(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307.12304
calc_sin.6307:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27520
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27520:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27522
	JR	%r31
BEQ_else.27522:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 8(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27524
	JR	%r31
BEQ_else.27524:
	SW	%r1, 10(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 12(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27526
	JR	%r31
BEQ_else.27526:
	SW	%r1, 14(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 16(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	LW	%r1, 14(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307
mysin_step1.2628:
	LA	%r29, l.20813
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27528
	ADDI	%r1, %r0, 17
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 0(%r30)
	DIV.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 15
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 2(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 0(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 13
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 0(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	ADDI	%r1, %r0, 11
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307
BEQ_else.27528:
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20813
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27529
	ADDI	%r1, %r0, 17
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 6(%r30)
	DIV.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	ADDI	%r1, %r0, 15
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	calc_sin.6307.12304
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27530
BEQ_else.27529:
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20815
	LWC1	%f3, 0(%r29)
	MUL.s	%f3, %f3, %f1
	MUL.s	%f3, %f3, %f1
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
BEQ_cont.27530:
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20815
	LWC1	%f3, 0(%r29)
	MUL.s	%f3, %f3, %f1
	MUL.s	%f3, %f3, %f1
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
	JR	%r31
calc_cos.6332.12249:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27531
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27531:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27533
	JR	%r31
BEQ_else.27533:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332.12249
calc_cos.6332.12276:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27535
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27535:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27537
	JR	%r31
BEQ_else.27537:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332.12276
cos.2630:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27539
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27540
	ADDI	%r1, %r0, 16
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 0(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 14
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332.12276
BEQ_else.27540:
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.27539:
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27541
	ADDI	%r1, %r0, 16
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 14
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332.12249
BEQ_else.27541:
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	JR	%r31
calc_sin.6307.12198:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27542
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27542:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27544
	JR	%r31
BEQ_else.27544:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 8(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307.12198
calc_sin.6307.12224:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27546
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.27546:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.27548
	JR	%r31
BEQ_else.27548:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 8(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307.12224
sin.2632:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27550
	LA	%r29, l.20813
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27551
	ADDI	%r1, %r0, 17
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 0(%r30)
	DIV.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	ADDI	%r1, %r0, 15
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307.12224
BEQ_else.27551:
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20815
	LWC1	%f3, 0(%r29)
	MUL.s	%f3, %f3, %f1
	MUL.s	%f3, %f3, %f1
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.27550:
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20813
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27552
	ADDI	%r1, %r0, 17
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 2(%r30)
	DIV.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	ADDI	%r1, %r0, 15
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sin.6307.12198
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27553
BEQ_else.27552:
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20814
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20815
	LWC1	%f3, 0(%r29)
	MUL.s	%f3, %f3, %f1
	MUL.s	%f3, %f3, %f1
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
BEQ_cont.27553:
	SUB.s	%f1, %f0, %f1
	JR	%r31
ev_error.6243:
	LA	%r29, l.20816
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27554
	ADDI	%r2, %r1, 1
	ADD	%r1, %r1, %r1
	SW	%r2, 0(%r30)
	SWC1	%f2, 2(%r30)
	SWC1	%f3, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 2(%r30)
	ADD.s	%f2, %f4, %f2
	LA	%r29, l.20816
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27556
	LW	%r1, 0(%r30)
	ADDI	%r2, %r1, 1
	ADD	%r1, %r1, %r1
	SW	%r2, 8(%r30)
	SWC1	%f2, 10(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 10(%r30)
	ADD.s	%f2, %f4, %f2
	LA	%r29, l.20816
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27558
	LW	%r1, 8(%r30)
	ADDI	%r2, %r1, 1
	ADD	%r1, %r1, %r1
	SW	%r2, 14(%r30)
	SWC1	%f2, 16(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 16(%r30)
	ADD.s	%f2, %f4, %f2
	LA	%r29, l.20816
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27560
	LW	%r1, 14(%r30)
	ADDI	%r2, %r1, 1
	ADD	%r1, %r1, %r1
	SW	%r2, 20(%r30)
	SWC1	%f2, 22(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 22(%r30)
	ADD.s	%f2, %f4, %f2
	LW	%r1, 20(%r30)
	J	ev_error.6243
BEQ_else.27560:
	LW	%r1, 14(%r30)
	JR	%r31
BEQ_else.27558:
	LW	%r1, 8(%r30)
	JR	%r31
BEQ_else.27556:
	LW	%r1, 0(%r30)
	JR	%r31
BEQ_else.27554:
	JR	%r31
calc_atan.6249:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27562
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.27562:
	ADD	%r2, %r1, %r1
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f3, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27564
	JR	%r31
BEQ_else.27564:
	ADD	%r2, %r1, %r1
	SW	%r1, 8(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 8(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27566
	JR	%r31
BEQ_else.27566:
	ADD	%r2, %r1, %r1
	SW	%r1, 12(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27568
	JR	%r31
BEQ_else.27568:
	ADD	%r2, %r1, %r1
	SW	%r1, 16(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 16(%r30)
	ADDI	%r1, %r1, -1
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_atan.6249
atan.2634:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27570
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27571
BEQ_else.27570:
	ADDI	%r1, %r0, 1
BEQ_cont.27571:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27572
	J	BEQ_cont.27573
BEQ_else.27572:
	SUB.s	%f1, %f0, %f1
BEQ_cont.27573:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27574
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27575
BEQ_else.27574:
	ADDI	%r2, %r0, 1
BEQ_cont.27575:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27576
	J	BEQ_cont.27577
BEQ_else.27576:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
BEQ_cont.27577:
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f3, %f3, %f2
	DIV.s	%f3, %f2, %f3
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f2, %f4, %f2
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	SW	%r1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r2, 6(%r30)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27579
	ADDI	%r3, %r0, 2
	SWC1	%f2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 8(%r30)
	ADD.s	%f4, %f4, %f2
	LA	%r29, l.20816
	LWC1	%f5, 0(%r29)
	MUL.s	%f5, %f5, %f4
	C.le.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.27582
	ADDI	%r1, %r0, 4
	SWC1	%f4, 10(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 10(%r30)
	ADD.s	%f2, %f4, %f2
	LA	%r29, l.20816
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27584
	ADDI	%r1, %r0, 4
	ADDI	%r2, %r0, 6
	SW	%r1, 14(%r30)
	SWC1	%f2, 16(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 16(%r30)
	ADD.s	%f2, %f4, %f2
	LW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	ev_error.6243
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27585
BEQ_else.27584:
	ADDI	%r1, %r0, 3
BEQ_cont.27585:
	J	BEQ_cont.27583
BEQ_else.27582:
	ADDI	%r1, %r0, 2
BEQ_cont.27583:
	J	BEQ_cont.27580
BEQ_else.27579:
	ADDI	%r1, %r0, 1
BEQ_cont.27580:
	LW	%r2, 6(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27587
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27589
	LWC1	%f1, 4(%r30)
	J	BEQ_cont.27590
BEQ_else.27589:
	ADD	%r2, %r1, %r1
	SW	%r1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 20(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27591
	J	BEQ_cont.27592
BEQ_else.27591:
	ADD	%r2, %r1, %r1
	SW	%r1, 21(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 22(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 4(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 21(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27593
	J	BEQ_cont.27594
BEQ_else.27593:
	ADD	%r2, %r1, %r1
	SW	%r1, 24(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 26(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 4(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 24(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f31, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	calc_atan.6249
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27594:
BEQ_cont.27592:
BEQ_cont.27590:
	J	BEQ_cont.27588
BEQ_else.27587:
	LA	%r29, l.20817
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 28(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27596
	LWC1	%f2, 4(%r30)
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.27597
BEQ_else.27596:
	ADD	%r2, %r1, %r1
	SW	%r1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 20(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27598
	J	BEQ_cont.27599
BEQ_else.27598:
	ADD	%r2, %r1, %r1
	SW	%r1, 30(%r30)
	SWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 4(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 30(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27601
	J	BEQ_cont.27602
BEQ_else.27601:
	ADD	%r2, %r1, %r1
	SW	%r1, 34(%r30)
	SWC1	%f1, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 36(%r30)
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 4(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 34(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f31, %f0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	calc_atan.6249
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27602:
BEQ_cont.27599:
BEQ_cont.27597:
	LWC1	%f2, 28(%r30)
	SUB.s	%f1, %f2, %f1
BEQ_cont.27588:
	LW	%r1, 0(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27604
	JR	%r31
BEQ_else.27604:
	SUB.s	%f1, %f0, %f1
	JR	%r31
xor.2670:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27605
	ADDI	%r1, %r2, 0
	JR	%r31
BEQ_else.27605:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27606
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.27606:
	ADDI	%r1, %r0, 0
	JR	%r31
sgn.2673:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27607
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27608
BEQ_else.27607:
	ADDI	%r1, %r0, 1
BEQ_cont.27608:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27609
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27610
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27611
BEQ_else.27610:
	ADDI	%r1, %r0, 1
BEQ_cont.27611:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27612
	LA	%r29, l.20812
	LWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.27612:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.27609:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	JR	%r31
add_mod5.2678:
	ADD	%r1, %r1, %r2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27613
	ADDI	%r1, %r1, -5
	JR	%r31
BEQ_else.27613:
	JR	%r31
vecfill.2686:
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	JR	%r31
vecbzero.2689:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	JR	%r31
veccpy.2691:
	LWC1	%f1, 0(%r2)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r2)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r2)
	SWC1	%f1, 2(%r1)
	JR	%r31
veciprod.2702:
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	JR	%r31
veciprod2.2705:
	LWC1	%f4, 0(%r1)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 1(%r1)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	JR	%r31
vecaccumv.2723:
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 0(%r2)
	LWC1	%f3, 0(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 1(%r2)
	LWC1	%f3, 1(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r1)
	LWC1	%f2, 2(%r2)
	LWC1	%f3, 2(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
	JR	%r31
o_form.2729:
	LW	%r1, 1(%r1)
	JR	%r31
o_isinvert.2733:
	LW	%r1, 6(%r1)
	JR	%r31
o_isrot.2735:
	LW	%r1, 3(%r1)
	JR	%r31
o_param_a.2737:
	LW	%r1, 4(%r1)
	LWC1	%f1, 0(%r1)
	JR	%r31
o_param_b.2739:
	LW	%r1, 4(%r1)
	LWC1	%f1, 1(%r1)
	JR	%r31
o_param_c.2741:
	LW	%r1, 4(%r1)
	LWC1	%f1, 2(%r1)
	JR	%r31
o_param_abc.2743:
	LW	%r1, 4(%r1)
	JR	%r31
o_param_x.2745:
	LW	%r1, 5(%r1)
	LWC1	%f1, 0(%r1)
	JR	%r31
o_param_y.2747:
	LW	%r1, 5(%r1)
	LWC1	%f1, 1(%r1)
	JR	%r31
o_param_z.2749:
	LW	%r1, 5(%r1)
	LWC1	%f1, 2(%r1)
	JR	%r31
o_param_r1.2761:
	LW	%r1, 9(%r1)
	LWC1	%f1, 0(%r1)
	JR	%r31
o_param_r2.2763:
	LW	%r1, 9(%r1)
	LWC1	%f1, 1(%r1)
	JR	%r31
o_param_r3.2765:
	LW	%r1, 9(%r1)
	LWC1	%f1, 2(%r1)
	JR	%r31
p_intersection_points.2771:
	LW	%r1, 1(%r1)
	JR	%r31
p_surface_ids.2773:
	LW	%r1, 2(%r1)
	JR	%r31
p_calc_diffuse.2775:
	LW	%r1, 3(%r1)
	JR	%r31
p_energy.2777:
	LW	%r1, 4(%r1)
	JR	%r31
p_received_ray_20percent.2779:
	LW	%r1, 5(%r1)
	JR	%r31
p_group_id.2781:
	LW	%r1, 6(%r1)
	LW	%r1, 0(%r1)
	JR	%r31
p_nvectors.2786:
	LW	%r1, 7(%r1)
	JR	%r31
d_vec.2788:
	LW	%r1, 0(%r1)
	JR	%r31
d_const.2790:
	LW	%r1, 1(%r1)
	JR	%r31
rad.2798:
	LA	%r29, l.20861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	JR	%r31
read_screen_settings.2800:
	LW	%r1, 5(%r26)
	LW	%r2, 4(%r26)
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SW	%r1, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 6(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27619
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27620
BEQ_else.27619:
	SUB.s	%f2, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27620:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 6(%r30)
	SWC1	%f1, 8(%r30)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27621
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27622
BEQ_else.27621:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.27622:
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 12(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27623
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27624
BEQ_else.27623:
	SUB.s	%f2, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27624:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 12(%r30)
	SWC1	%f1, 14(%r30)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27625
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27626
BEQ_else.27625:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.27626:
	LWC1	%f2, 8(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.20865
	LWC1	%f4, 0(%r29)
	MUL.s	%f3, %f3, %f4
	LW	%r1, 3(%r30)
	SWC1	%f3, 0(%r1)
	LA	%r29, l.20867
	LWC1	%f3, 0(%r29)
	LWC1	%f4, 10(%r30)
	MUL.s	%f3, %f4, %f3
	SWC1	%f3, 1(%r1)
	LWC1	%f3, 14(%r30)
	MUL.s	%f5, %f2, %f3
	LA	%r29, l.20865
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	SWC1	%f5, 2(%r1)
	LW	%r2, 2(%r30)
	SWC1	%f3, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	SWC1	%f5, 1(%r2)
	SUB.s	%f5, %f0, %f1
	SWC1	%f5, 2(%r2)
	SUB.s	%f5, %f0, %f4
	MUL.s	%f1, %f5, %f1
	LW	%r2, 1(%r30)
	SWC1	%f1, 0(%r2)
	SUB.s	%f1, %f0, %f2
	SWC1	%f1, 1(%r2)
	SUB.s	%f1, %f0, %f4
	MUL.s	%f1, %f1, %f3
	SWC1	%f1, 2(%r2)
	LW	%r2, 4(%r30)
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 0(%r1)
	SUB.s	%f1, %f1, %f2
	LW	%r3, 0(%r30)
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r2)
	LWC1	%f2, 1(%r1)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r2)
	LWC1	%f2, 2(%r1)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r3)
	JR	%r31
rotate_quadratic_matrix.2804:
	LWC1	%f1, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27628
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27629
BEQ_else.27628:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27629:
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 2(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27630
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27631
BEQ_else.27630:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.27631:
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 4(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27632
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27633
BEQ_else.27632:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27633:
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 6(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27634
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27635
BEQ_else.27634:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.27635:
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 8(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27636
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27637
BEQ_else.27636:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27637:
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 10(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27638
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27639
BEQ_else.27638:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.27639:
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 6(%r30)
	MUL.s	%f4, %f3, %f2
	LWC1	%f5, 8(%r30)
	LWC1	%f6, 4(%r30)
	MUL.s	%f7, %f6, %f5
	MUL.s	%f7, %f7, %f2
	LWC1	%f8, 2(%r30)
	MUL.s	%f9, %f8, %f1
	SUB.s	%f7, %f7, %f9
	MUL.s	%f9, %f8, %f5
	MUL.s	%f9, %f9, %f2
	MUL.s	%f10, %f6, %f1
	ADD.s	%f9, %f9, %f10
	MUL.s	%f10, %f3, %f1
	MUL.s	%f11, %f6, %f5
	MUL.s	%f11, %f11, %f1
	MUL.s	%f12, %f8, %f2
	ADD.s	%f11, %f11, %f12
	MUL.s	%f12, %f8, %f5
	MUL.s	%f1, %f12, %f1
	MUL.s	%f2, %f6, %f2
	SUB.s	%f1, %f1, %f2
	SUB.s	%f2, %f0, %f5
	MUL.s	%f5, %f6, %f3
	MUL.s	%f3, %f8, %f3
	LW	%r1, 0(%r30)
	LWC1	%f6, 0(%r1)
	LWC1	%f8, 1(%r1)
	LWC1	%f12, 2(%r1)
	MUL.s	%f13, %f4, %f4
	MUL.s	%f13, %f6, %f13
	MUL.s	%f14, %f10, %f10
	MUL.s	%f14, %f8, %f14
	ADD.s	%f13, %f13, %f14
	MUL.s	%f14, %f2, %f2
	MUL.s	%f14, %f12, %f14
	ADD.s	%f13, %f13, %f14
	SWC1	%f13, 0(%r1)
	MUL.s	%f13, %f7, %f7
	MUL.s	%f13, %f6, %f13
	MUL.s	%f14, %f11, %f11
	MUL.s	%f14, %f8, %f14
	ADD.s	%f13, %f13, %f14
	MUL.s	%f14, %f5, %f5
	MUL.s	%f14, %f12, %f14
	ADD.s	%f13, %f13, %f14
	SWC1	%f13, 1(%r1)
	MUL.s	%f13, %f9, %f9
	MUL.s	%f13, %f6, %f13
	MUL.s	%f14, %f1, %f1
	MUL.s	%f14, %f8, %f14
	ADD.s	%f13, %f13, %f14
	MUL.s	%f14, %f3, %f3
	MUL.s	%f14, %f12, %f14
	ADD.s	%f13, %f13, %f14
	SWC1	%f13, 2(%r1)
	LA	%r29, l.20771
	LWC1	%f13, 0(%r29)
	MUL.s	%f14, %f6, %f7
	MUL.s	%f14, %f14, %f9
	MUL.s	%f15, %f8, %f11
	MUL.s	%f15, %f15, %f1
	ADD.s	%f14, %f14, %f15
	MUL.s	%f15, %f12, %f5
	MUL.s	%f15, %f15, %f3
	ADD.s	%f14, %f14, %f15
	MUL.s	%f13, %f13, %f14
	LW	%r1, 1(%r30)
	SWC1	%f13, 0(%r1)
	LA	%r29, l.20771
	LWC1	%f13, 0(%r29)
	MUL.s	%f14, %f6, %f4
	MUL.s	%f9, %f14, %f9
	MUL.s	%f14, %f8, %f10
	MUL.s	%f1, %f14, %f1
	ADD.s	%f1, %f9, %f1
	MUL.s	%f9, %f12, %f2
	MUL.s	%f3, %f9, %f3
	ADD.s	%f1, %f1, %f3
	MUL.s	%f1, %f13, %f1
	SWC1	%f1, 1(%r1)
	LA	%r29, l.20771
	LWC1	%f1, 0(%r29)
	MUL.s	%f3, %f6, %f4
	MUL.s	%f3, %f3, %f7
	MUL.s	%f4, %f8, %f10
	MUL.s	%f4, %f4, %f11
	ADD.s	%f3, %f3, %f4
	MUL.s	%f2, %f12, %f2
	MUL.s	%f2, %f2, %f5
	ADD.s	%f2, %f3, %f2
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
	JR	%r31
calc_sqrt.6353.20308:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27641
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27642
	J	calc_sqrt.6353.20308
BEQ_else.27642:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.27641:
	ADD.s	%f1, %f2, %f0
	JR	%r31
read_nth_object.2807:
	LW	%r2, 1(%r26)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27643
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27643:
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	SWC1	%f1, 2(%r1)
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27644
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27645
BEQ_else.27644:
	ADDI	%r1, %r0, 1
BEQ_cont.27645:
	ADDI	%r2, %r0, 2
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	SWC1	%f1, 2(%r1)
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27646
	J	BEQ_cont.27647
BEQ_else.27646:
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 11(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 11(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 11(%r30)
	SWC1	%f1, 2(%r1)
BEQ_cont.27647:
	LW	%r2, 3(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.27648
	ADDI	%r3, %r0, 1
	J	BEQ_cont.27649
BEQ_else.27648:
	LW	%r3, 8(%r30)
BEQ_cont.27649:
	ADDI	%r4, %r0, 4
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r3, 12(%r30)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 11
	SW	%r1, 10(%r2)
	LW	%r1, 11(%r30)
	SW	%r1, 9(%r2)
	LW	%r3, 10(%r30)
	SW	%r3, 8(%r2)
	LW	%r3, 9(%r30)
	SW	%r3, 7(%r2)
	LW	%r3, 12(%r30)
	SW	%r3, 6(%r2)
	LW	%r3, 7(%r30)
	SW	%r3, 5(%r2)
	LW	%r3, 6(%r30)
	SW	%r3, 4(%r2)
	LW	%r4, 5(%r30)
	SW	%r4, 3(%r2)
	LW	%r5, 4(%r30)
	SW	%r5, 2(%r2)
	LW	%r5, 3(%r30)
	SW	%r5, 1(%r2)
	LW	%r6, 2(%r30)
	SW	%r6, 0(%r2)
	LW	%r6, 0(%r30)
	LW	%r7, 1(%r30)
	ADD	%r29, %r7, %r6
	SW	%r2, 0(%r29)
	ADDI	%r27, %r0, 3
	BNE	%r5, %r27, BEQ_else.27650
	LWC1	%f1, 0(%r3)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27652
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27653
BEQ_else.27652:
	ADDI	%r2, %r0, 1
BEQ_cont.27653:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27654
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27656
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27657
BEQ_else.27656:
	ADDI	%r2, %r0, 1
BEQ_cont.27657:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27658
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27660
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27661
BEQ_else.27660:
	ADDI	%r2, %r0, 1
BEQ_cont.27661:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27662
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	J	BEQ_cont.27663
BEQ_else.27662:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
BEQ_cont.27663:
	J	BEQ_cont.27659
BEQ_else.27658:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
BEQ_cont.27659:
	MUL.s	%f1, %f1, %f1
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.27655
BEQ_else.27654:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.27655:
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r3)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27664
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27665
BEQ_else.27664:
	ADDI	%r2, %r0, 1
BEQ_cont.27665:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27666
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27668
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27669
BEQ_else.27668:
	ADDI	%r2, %r0, 1
BEQ_cont.27669:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27670
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27672
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27673
BEQ_else.27672:
	ADDI	%r2, %r0, 1
BEQ_cont.27673:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27674
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	J	BEQ_cont.27675
BEQ_else.27674:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
BEQ_cont.27675:
	J	BEQ_cont.27671
BEQ_else.27670:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
BEQ_cont.27671:
	MUL.s	%f1, %f1, %f1
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.27667
BEQ_else.27666:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.27667:
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r3)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27676
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27677
BEQ_else.27676:
	ADDI	%r2, %r0, 1
BEQ_cont.27677:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27678
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27680
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27681
BEQ_else.27680:
	ADDI	%r2, %r0, 1
BEQ_cont.27681:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27682
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27684
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27685
BEQ_else.27684:
	ADDI	%r2, %r0, 1
BEQ_cont.27685:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27686
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	J	BEQ_cont.27687
BEQ_else.27686:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
BEQ_cont.27687:
	J	BEQ_cont.27683
BEQ_else.27682:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
BEQ_cont.27683:
	MUL.s	%f1, %f1, %f1
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.27679
BEQ_else.27678:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.27679:
	SWC1	%f1, 2(%r3)
	J	BEQ_cont.27651
BEQ_else.27650:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.27688
	LW	%r2, 8(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27690
	ADDI	%r2, %r0, 1
	J	BEQ_cont.27691
BEQ_else.27690:
	ADDI	%r2, %r0, 0
BEQ_cont.27691:
	LWC1	%f1, 0(%r3)
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 1(%r3)
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r3)
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r2, 13(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27692
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27694
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27696
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	calc_sqrt.6353.20308
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27697
BEQ_else.27696:
	ADD.s	%f1, %f2, %f0
BEQ_cont.27697:
	J	BEQ_cont.27695
BEQ_else.27694:
BEQ_cont.27695:
	J	BEQ_cont.27693
BEQ_else.27692:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.27693:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27698
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27699
BEQ_else.27698:
	ADDI	%r1, %r0, 1
BEQ_cont.27699:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27700
	LW	%r1, 13(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27702
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.27703
BEQ_else.27702:
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
BEQ_cont.27703:
	J	BEQ_cont.27701
BEQ_else.27700:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.27701:
	LW	%r1, 6(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.27689
BEQ_else.27688:
BEQ_cont.27689:
BEQ_cont.27651:
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27704
	J	BEQ_cont.27705
BEQ_else.27704:
	LW	%r1, 6(%r30)
	LW	%r2, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	rotate_quadratic_matrix.2804
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.27705:
	ADDI	%r1, %r0, 1
	JR	%r31
read_object.2809:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27706
	JR	%r31
BEQ_else.27706:
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27708
	LW	%r1, 2(%r30)
	LW	%r2, 3(%r30)
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.27708:
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27710
	JR	%r31
BEQ_else.27710:
	LW	%r26, 1(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27712
	LW	%r1, 2(%r30)
	LW	%r2, 4(%r30)
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.27712:
	LW	%r1, 4(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27714
	JR	%r31
BEQ_else.27714:
	LW	%r26, 1(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27716
	LW	%r1, 2(%r30)
	LW	%r2, 5(%r30)
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.27716:
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.27718
	JR	%r31
BEQ_else.27718:
	LW	%r26, 1(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27720
	LW	%r1, 2(%r30)
	LW	%r2, 6(%r30)
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.27720:
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, 1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
read_net_item.2813:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27722
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	J	min_caml_create_array
BEQ_else.27722:
	LW	%r2, 0(%r30)
	ADDI	%r3, %r2, 1
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27723
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27724
BEQ_else.27723:
	LW	%r2, 2(%r30)
	ADDI	%r3, %r2, 1
	SW	%r1, 3(%r30)
	SW	%r3, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27725
	LW	%r1, 4(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27726
BEQ_else.27725:
	LW	%r2, 4(%r30)
	ADDI	%r3, %r2, 1
	SW	%r1, 5(%r30)
	SW	%r3, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27727
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27728
BEQ_else.27727:
	LW	%r2, 6(%r30)
	ADDI	%r3, %r2, 1
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	LW	%r3, 7(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.27728:
	LW	%r2, 4(%r30)
	LW	%r3, 5(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.27726:
	LW	%r2, 2(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.27724:
	LW	%r2, 0(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
	JR	%r31
read_or_network.2815:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27729
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27730
BEQ_else.27729:
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27731
	ADDI	%r1, %r0, 2
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27732
BEQ_else.27731:
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27733
	ADDI	%r1, %r0, 3
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27734
BEQ_else.27733:
	ADDI	%r2, %r0, 3
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r2, 2(%r1)
BEQ_cont.27734:
	LW	%r2, 2(%r30)
	SW	%r2, 1(%r1)
BEQ_cont.27732:
	LW	%r2, 1(%r30)
	SW	%r2, 0(%r1)
	ADDI	%r2, %r1, 0
BEQ_cont.27730:
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27735
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 1
	J	min_caml_create_array
BEQ_else.27735:
	LW	%r1, 0(%r30)
	ADDI	%r3, %r1, 1
	SW	%r2, 4(%r30)
	SW	%r3, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27736
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27737
BEQ_else.27736:
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27738
	ADDI	%r1, %r0, 2
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27739
BEQ_else.27738:
	ADDI	%r2, %r0, 2
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r2, 1(%r1)
BEQ_cont.27739:
	LW	%r2, 6(%r30)
	SW	%r2, 0(%r1)
	ADDI	%r2, %r1, 0
BEQ_cont.27737:
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27740
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27741
BEQ_else.27740:
	LW	%r1, 5(%r30)
	ADDI	%r3, %r1, 1
	SW	%r2, 8(%r30)
	SW	%r3, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27742
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27743
BEQ_else.27742:
	ADDI	%r2, %r0, 1
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	SW	%r2, 0(%r1)
	ADDI	%r2, %r1, 0
BEQ_cont.27743:
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27744
	LW	%r1, 9(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27745
BEQ_else.27744:
	LW	%r1, 9(%r30)
	ADDI	%r3, %r1, 1
	ADDI	%r4, %r0, 0
	SW	%r2, 11(%r30)
	SW	%r3, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27746
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27747
BEQ_else.27746:
	LW	%r1, 12(%r30)
	ADDI	%r3, %r1, 1
	SW	%r2, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	read_or_network.2815
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 12(%r30)
	LW	%r3, 13(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.27747:
	LW	%r2, 9(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.27745:
	LW	%r2, 5(%r30)
	LW	%r3, 8(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.27741:
	LW	%r2, 0(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
	JR	%r31
read_and_network.2817:
	LW	%r2, 1(%r26)
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27748
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27749
BEQ_else.27748:
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27750
	ADDI	%r1, %r0, 2
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27751
BEQ_else.27750:
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27752
	ADDI	%r1, %r0, 3
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27753
BEQ_else.27752:
	ADDI	%r2, %r0, 3
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r2, 2(%r1)
BEQ_cont.27753:
	LW	%r2, 4(%r30)
	SW	%r2, 1(%r1)
BEQ_cont.27751:
	LW	%r2, 3(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.27749:
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.27754
	JR	%r31
BEQ_else.27754:
	LW	%r2, 1(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27756
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27757
BEQ_else.27756:
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27758
	ADDI	%r1, %r0, 2
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27759
BEQ_else.27758:
	ADDI	%r2, %r0, 2
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	SW	%r2, 1(%r1)
BEQ_cont.27759:
	LW	%r2, 7(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.27757:
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.27760
	JR	%r31
BEQ_else.27760:
	LW	%r2, 6(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.27762
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27763
BEQ_else.27762:
	ADDI	%r2, %r0, 1
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.27763:
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.27764
	JR	%r31
BEQ_else.27764:
	LW	%r2, 9(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	ADDI	%r2, %r0, 0
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.27766
	JR	%r31
BEQ_else.27766:
	LW	%r2, 11(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solver_rect.2830:
	LW	%r3, 1(%r26)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27768
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27769
BEQ_else.27768:
	ADDI	%r4, %r0, 1
BEQ_cont.27769:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27770
	LW	%r4, 4(%r1)
	LW	%r5, 6(%r1)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27772
	ADDI	%r6, %r0, 0
	J	BEQ_cont.27773
BEQ_else.27772:
	ADDI	%r6, %r0, 1
BEQ_cont.27773:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27774
	ADDI	%r5, %r6, 0
	J	BEQ_cont.27775
BEQ_else.27774:
	ADDI	%r27, %r0, 0
	BNE	%r6, %r27, BEQ_else.27776
	ADDI	%r5, %r0, 1
	J	BEQ_cont.27777
BEQ_else.27776:
	ADDI	%r5, %r0, 0
BEQ_cont.27777:
BEQ_cont.27775:
	LWC1	%f4, 0(%r4)
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27778
	SUB.s	%f4, %f0, %f4
	J	BEQ_cont.27779
BEQ_else.27778:
BEQ_cont.27779:
	SUB.s	%f4, %f4, %f1
	LWC1	%f5, 0(%r2)
	DIV.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f2
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27780
	J	BEQ_cont.27781
BEQ_else.27780:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27781:
	LWC1	%f6, 1(%r4)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27782
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27783
BEQ_else.27782:
	ADDI	%r5, %r0, 1
BEQ_cont.27783:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27784
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27785
BEQ_else.27784:
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f3
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27786
	J	BEQ_cont.27787
BEQ_else.27786:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27787:
	LWC1	%f6, 2(%r4)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27788
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27789
BEQ_else.27788:
	ADDI	%r4, %r0, 1
BEQ_cont.27789:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27790
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27791
BEQ_else.27790:
	SWC1	%f4, 0(%r3)
	ADDI	%r4, %r0, 1
BEQ_cont.27791:
BEQ_cont.27785:
	J	BEQ_cont.27771
BEQ_else.27770:
	ADDI	%r4, %r0, 0
BEQ_cont.27771:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27792
	LWC1	%f4, 1(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27793
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27794
BEQ_else.27793:
	ADDI	%r4, %r0, 1
BEQ_cont.27794:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27795
	LW	%r4, 4(%r1)
	LW	%r5, 6(%r1)
	LWC1	%f4, 1(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27797
	ADDI	%r6, %r0, 0
	J	BEQ_cont.27798
BEQ_else.27797:
	ADDI	%r6, %r0, 1
BEQ_cont.27798:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27799
	ADDI	%r5, %r6, 0
	J	BEQ_cont.27800
BEQ_else.27799:
	ADDI	%r27, %r0, 0
	BNE	%r6, %r27, BEQ_else.27801
	ADDI	%r5, %r0, 1
	J	BEQ_cont.27802
BEQ_else.27801:
	ADDI	%r5, %r0, 0
BEQ_cont.27802:
BEQ_cont.27800:
	LWC1	%f4, 1(%r4)
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27803
	SUB.s	%f4, %f0, %f4
	J	BEQ_cont.27804
BEQ_else.27803:
BEQ_cont.27804:
	SUB.s	%f4, %f4, %f2
	LWC1	%f5, 1(%r2)
	DIV.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f3
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27805
	J	BEQ_cont.27806
BEQ_else.27805:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27806:
	LWC1	%f6, 2(%r4)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27807
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27808
BEQ_else.27807:
	ADDI	%r5, %r0, 1
BEQ_cont.27808:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27809
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27810
BEQ_else.27809:
	LWC1	%f5, 0(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f1
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27811
	J	BEQ_cont.27812
BEQ_else.27811:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27812:
	LWC1	%f6, 0(%r4)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27813
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27814
BEQ_else.27813:
	ADDI	%r4, %r0, 1
BEQ_cont.27814:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27815
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27816
BEQ_else.27815:
	SWC1	%f4, 0(%r3)
	ADDI	%r4, %r0, 1
BEQ_cont.27816:
BEQ_cont.27810:
	J	BEQ_cont.27796
BEQ_else.27795:
	ADDI	%r4, %r0, 0
BEQ_cont.27796:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27817
	LWC1	%f4, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27818
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27819
BEQ_else.27818:
	ADDI	%r4, %r0, 1
BEQ_cont.27819:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27820
	LW	%r4, 4(%r1)
	LW	%r1, 6(%r1)
	LWC1	%f4, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27822
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27823
BEQ_else.27822:
	ADDI	%r5, %r0, 1
BEQ_cont.27823:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27824
	ADDI	%r1, %r5, 0
	J	BEQ_cont.27825
BEQ_else.27824:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27826
	ADDI	%r1, %r0, 1
	J	BEQ_cont.27827
BEQ_else.27826:
	ADDI	%r1, %r0, 0
BEQ_cont.27827:
BEQ_cont.27825:
	LWC1	%f4, 2(%r4)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27828
	SUB.s	%f4, %f0, %f4
	J	BEQ_cont.27829
BEQ_else.27828:
BEQ_cont.27829:
	SUB.s	%f3, %f4, %f3
	LWC1	%f4, 2(%r2)
	DIV.s	%f3, %f3, %f4
	LWC1	%f4, 0(%r2)
	MUL.s	%f4, %f3, %f4
	ADD.s	%f1, %f4, %f1
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27830
	J	BEQ_cont.27831
BEQ_else.27830:
	SUB.s	%f1, %f0, %f1
BEQ_cont.27831:
	LWC1	%f4, 0(%r4)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27832
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27833
BEQ_else.27832:
	ADDI	%r1, %r0, 1
BEQ_cont.27833:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27834
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27835
BEQ_else.27834:
	LWC1	%f1, 1(%r2)
	MUL.s	%f1, %f3, %f1
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27836
	J	BEQ_cont.27837
BEQ_else.27836:
	SUB.s	%f1, %f0, %f1
BEQ_cont.27837:
	LWC1	%f2, 1(%r4)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27838
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27839
BEQ_else.27838:
	ADDI	%r1, %r0, 1
BEQ_cont.27839:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27840
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27841
BEQ_else.27840:
	SWC1	%f3, 0(%r3)
	ADDI	%r1, %r0, 1
BEQ_cont.27841:
BEQ_cont.27835:
	J	BEQ_cont.27821
BEQ_else.27820:
	ADDI	%r1, %r0, 0
BEQ_cont.27821:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27842
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27842:
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.27817:
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.27792:
	ADDI	%r1, %r0, 1
	JR	%r31
quadratic.2842:
	MUL.s	%f4, %f1, %f1
	LW	%r2, 4(%r1)
	LWC1	%f5, 0(%r2)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r2, 4(%r1)
	LWC1	%f6, 1(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r2, 4(%r1)
	LWC1	%f6, 2(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27843
	ADD.s	%f1, %f4, %f0
	JR	%r31
BEQ_else.27843:
	MUL.s	%f5, %f2, %f3
	LW	%r2, 9(%r1)
	LWC1	%f6, 0(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r2, 9(%r1)
	LWC1	%f5, 1(%r2)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r1, 9(%r1)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
	JR	%r31
calc_sqrt.6353.11363:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27844
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27845
	J	calc_sqrt.6353.11363
BEQ_else.27845:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.27844:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_second.2855:
	LW	%r3, 1(%r26)
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 2(%r2)
	MUL.s	%f7, %f4, %f4
	LW	%r4, 4(%r1)
	LWC1	%f8, 0(%r4)
	MUL.s	%f7, %f7, %f8
	MUL.s	%f8, %f5, %f5
	LW	%r4, 4(%r1)
	LWC1	%f9, 1(%r4)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	MUL.s	%f8, %f6, %f6
	LW	%r4, 4(%r1)
	LWC1	%f9, 2(%r4)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	LW	%r4, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27846
	ADD.s	%f4, %f7, %f0
	J	BEQ_cont.27847
BEQ_else.27846:
	MUL.s	%f8, %f5, %f6
	LW	%r4, 9(%r1)
	LWC1	%f9, 0(%r4)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	MUL.s	%f6, %f6, %f4
	LW	%r4, 9(%r1)
	LWC1	%f8, 1(%r4)
	MUL.s	%f6, %f6, %f8
	ADD.s	%f6, %f7, %f6
	MUL.s	%f4, %f4, %f5
	LW	%r4, 9(%r1)
	LWC1	%f5, 2(%r4)
	MUL.s	%f4, %f4, %f5
	ADD.s	%f4, %f6, %f4
BEQ_cont.27847:
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27848
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27849
BEQ_else.27848:
	ADDI	%r4, %r0, 1
BEQ_cont.27849:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27850
	LWC1	%f5, 0(%r2)
	LWC1	%f6, 1(%r2)
	LWC1	%f7, 2(%r2)
	MUL.s	%f8, %f5, %f1
	LW	%r2, 4(%r1)
	LWC1	%f9, 0(%r2)
	MUL.s	%f8, %f8, %f9
	MUL.s	%f9, %f6, %f2
	LW	%r2, 4(%r1)
	LWC1	%f10, 1(%r2)
	MUL.s	%f9, %f9, %f10
	ADD.s	%f8, %f8, %f9
	MUL.s	%f9, %f7, %f3
	LW	%r2, 4(%r1)
	LWC1	%f10, 2(%r2)
	MUL.s	%f9, %f9, %f10
	ADD.s	%f8, %f8, %f9
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27851
	ADD.s	%f5, %f8, %f0
	J	BEQ_cont.27852
BEQ_else.27851:
	MUL.s	%f9, %f7, %f2
	MUL.s	%f10, %f6, %f3
	ADD.s	%f9, %f9, %f10
	LW	%r2, 9(%r1)
	LWC1	%f10, 0(%r2)
	MUL.s	%f9, %f9, %f10
	MUL.s	%f10, %f5, %f3
	MUL.s	%f7, %f7, %f1
	ADD.s	%f7, %f10, %f7
	LW	%r2, 9(%r1)
	LWC1	%f10, 1(%r2)
	MUL.s	%f7, %f7, %f10
	ADD.s	%f7, %f9, %f7
	MUL.s	%f5, %f5, %f2
	MUL.s	%f6, %f6, %f1
	ADD.s	%f5, %f5, %f6
	LW	%r2, 9(%r1)
	LWC1	%f6, 2(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f5, %f7, %f5
	LA	%r29, l.20813
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f5, %f8, %f5
BEQ_cont.27852:
	MUL.s	%f6, %f1, %f1
	LW	%r2, 4(%r1)
	LWC1	%f7, 0(%r2)
	MUL.s	%f6, %f6, %f7
	MUL.s	%f7, %f2, %f2
	LW	%r2, 4(%r1)
	LWC1	%f8, 1(%r2)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f7, %f3, %f3
	LW	%r2, 4(%r1)
	LWC1	%f8, 2(%r2)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27853
	ADD.s	%f1, %f6, %f0
	J	BEQ_cont.27854
BEQ_else.27853:
	MUL.s	%f7, %f2, %f3
	LW	%r2, 9(%r1)
	LWC1	%f8, 0(%r2)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f3, %f3, %f1
	LW	%r2, 9(%r1)
	LWC1	%f7, 1(%r2)
	MUL.s	%f3, %f3, %f7
	ADD.s	%f3, %f6, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r2, 9(%r1)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.27854:
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.27855
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.27856
BEQ_else.27855:
BEQ_cont.27856:
	MUL.s	%f2, %f5, %f5
	MUL.s	%f1, %f4, %f1
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27857
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27858
BEQ_else.27857:
	ADDI	%r2, %r0, 1
BEQ_cont.27858:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27859
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27859:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	SWC1	%f4, 2(%r30)
	SWC1	%f5, 4(%r30)
	SW	%r1, 6(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27861
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27863
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f3, %f3, %f6
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27865
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	calc_sqrt.6353.11363
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27866
BEQ_else.27865:
	ADD.s	%f1, %f2, %f0
BEQ_cont.27866:
	J	BEQ_cont.27864
BEQ_else.27863:
BEQ_cont.27864:
	J	BEQ_cont.27862
BEQ_else.27861:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.27862:
	LW	%r1, 6(%r30)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27867
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.27868
BEQ_else.27867:
BEQ_cont.27868:
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r30)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.27850:
	ADDI	%r1, %r0, 0
	JR	%r31
calc_sqrt.6353.19119:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27869
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.27870
	J	calc_sqrt.6353.19119
BEQ_else.27870:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.27869:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver.2861:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r5, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 0(%r3)
	LW	%r5, 5(%r1)
	LWC1	%f2, 0(%r5)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LW	%r5, 5(%r1)
	LWC1	%f3, 1(%r5)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r3)
	LW	%r3, 5(%r1)
	LWC1	%f4, 2(%r3)
	SUB.s	%f3, %f3, %f4
	LW	%r3, 1(%r1)
	ADDI	%r27, %r0, 1
	BNE	%r3, %r27, BEQ_else.27871
	LWC1	%f4, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27872
	ADDI	%r3, %r0, 0
	J	BEQ_cont.27873
BEQ_else.27872:
	ADDI	%r3, %r0, 1
BEQ_cont.27873:
	SW	%r4, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f3, 4(%r30)
	SWC1	%f2, 6(%r30)
	SW	%r1, 8(%r30)
	SW	%r2, 9(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.27875
	LW	%r3, 4(%r1)
	LW	%r5, 6(%r1)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27877
	ADDI	%r6, %r0, 0
	J	BEQ_cont.27878
BEQ_else.27877:
	ADDI	%r6, %r0, 1
BEQ_cont.27878:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27879
	ADDI	%r5, %r6, 0
	J	BEQ_cont.27880
BEQ_else.27879:
	ADDI	%r27, %r0, 0
	BNE	%r6, %r27, BEQ_else.27881
	ADDI	%r5, %r0, 1
	J	BEQ_cont.27882
BEQ_else.27881:
	ADDI	%r5, %r0, 0
BEQ_cont.27882:
BEQ_cont.27880:
	LWC1	%f4, 0(%r3)
	SW	%r3, 10(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27883
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	fneg.2605
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27884
BEQ_else.27883:
	ADD.s	%f1, %f4, %f0
BEQ_cont.27884:
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f1, %f2
	LW	%r1, 9(%r30)
	LWC1	%f3, 0(%r1)
	DIV.s	%f1, %f1, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f1, %f3
	LWC1	%f4, 6(%r30)
	ADD.s	%f3, %f3, %f4
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	abs_float.2614
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LWC1	%f2, 1(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27886
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27887
BEQ_else.27886:
	ADDI	%r2, %r0, 1
BEQ_cont.27887:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27888
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27889
BEQ_else.27888:
	LW	%r2, 9(%r30)
	LWC1	%f1, 2(%r2)
	LWC1	%f2, 12(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 4(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	abs_float.2614
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LWC1	%f2, 2(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27890
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27891
BEQ_else.27890:
	ADDI	%r1, %r0, 1
BEQ_cont.27891:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27892
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27893
BEQ_else.27892:
	LW	%r1, 0(%r30)
	LWC1	%f1, 12(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
BEQ_cont.27893:
BEQ_cont.27889:
	J	BEQ_cont.27876
BEQ_else.27875:
	ADDI	%r1, %r0, 0
BEQ_cont.27876:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27894
	LW	%r1, 9(%r30)
	LWC1	%f1, 1(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27895
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27896
BEQ_else.27895:
	ADDI	%r2, %r0, 1
BEQ_cont.27896:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27897
	LW	%r2, 8(%r30)
	LW	%r3, 4(%r2)
	LW	%r4, 6(%r2)
	LWC1	%f1, 1(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27899
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27900
BEQ_else.27899:
	ADDI	%r5, %r0, 1
BEQ_cont.27900:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27901
	ADDI	%r4, %r5, 0
	J	BEQ_cont.27902
BEQ_else.27901:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27903
	ADDI	%r4, %r0, 1
	J	BEQ_cont.27904
BEQ_else.27903:
	ADDI	%r4, %r0, 0
BEQ_cont.27904:
BEQ_cont.27902:
	LWC1	%f1, 1(%r3)
	SW	%r3, 14(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27905
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	fneg.2605
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27906
BEQ_else.27905:
BEQ_cont.27906:
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f1, %f2
	LW	%r1, 9(%r30)
	LWC1	%f3, 1(%r1)
	DIV.s	%f1, %f1, %f3
	LWC1	%f3, 2(%r1)
	MUL.s	%f3, %f1, %f3
	LWC1	%f4, 4(%r30)
	ADD.s	%f3, %f3, %f4
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	abs_float.2614
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LWC1	%f2, 2(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27908
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27909
BEQ_else.27908:
	ADDI	%r2, %r0, 1
BEQ_cont.27909:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27910
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27911
BEQ_else.27910:
	LW	%r2, 9(%r30)
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 16(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	abs_float.2614
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LWC1	%f2, 0(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27912
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27913
BEQ_else.27912:
	ADDI	%r1, %r0, 1
BEQ_cont.27913:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27914
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27915
BEQ_else.27914:
	LW	%r1, 0(%r30)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
BEQ_cont.27915:
BEQ_cont.27911:
	J	BEQ_cont.27898
BEQ_else.27897:
	ADDI	%r1, %r0, 0
BEQ_cont.27898:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27916
	LW	%r1, 9(%r30)
	LWC1	%f1, 2(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27917
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27918
BEQ_else.27917:
	ADDI	%r2, %r0, 1
BEQ_cont.27918:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27919
	LW	%r2, 8(%r30)
	LW	%r3, 4(%r2)
	LW	%r2, 6(%r2)
	LWC1	%f1, 2(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27921
	ADDI	%r4, %r0, 0
	J	BEQ_cont.27922
BEQ_else.27921:
	ADDI	%r4, %r0, 1
BEQ_cont.27922:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27923
	ADDI	%r2, %r4, 0
	J	BEQ_cont.27924
BEQ_else.27923:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.27925
	ADDI	%r2, %r0, 1
	J	BEQ_cont.27926
BEQ_else.27925:
	ADDI	%r2, %r0, 0
BEQ_cont.27926:
BEQ_cont.27924:
	LWC1	%f1, 2(%r3)
	SW	%r3, 18(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27927
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	fneg.2605
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27928
BEQ_else.27927:
BEQ_cont.27928:
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f1, %f2
	LW	%r1, 9(%r30)
	LWC1	%f2, 2(%r1)
	DIV.s	%f1, %f1, %f2
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f2, %f2, %f3
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	abs_float.2614
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 18(%r30)
	LWC1	%f2, 0(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27930
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27931
BEQ_else.27930:
	ADDI	%r2, %r0, 1
BEQ_cont.27931:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27932
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27933
BEQ_else.27932:
	LW	%r2, 9(%r30)
	LWC1	%f1, 1(%r2)
	LWC1	%f2, 20(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 6(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	abs_float.2614
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 18(%r30)
	LWC1	%f2, 1(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27934
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27935
BEQ_else.27934:
	ADDI	%r1, %r0, 1
BEQ_cont.27935:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27936
	ADDI	%r1, %r0, 0
	J	BEQ_cont.27937
BEQ_else.27936:
	LW	%r1, 0(%r30)
	LWC1	%f1, 20(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
BEQ_cont.27937:
BEQ_cont.27933:
	J	BEQ_cont.27920
BEQ_else.27919:
	ADDI	%r1, %r0, 0
BEQ_cont.27920:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27938
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27938:
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.27916:
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.27894:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.27871:
	ADDI	%r27, %r0, 2
	BNE	%r3, %r27, BEQ_else.27939
	LW	%r1, 4(%r1)
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 0(%r1)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 1(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r2)
	LWC1	%f6, 2(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.27940
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27941
BEQ_else.27940:
	ADDI	%r2, %r0, 1
BEQ_cont.27941:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27942
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27942:
	LWC1	%f5, 0(%r1)
	MUL.s	%f1, %f5, %f1
	LWC1	%f5, 1(%r1)
	MUL.s	%f2, %f5, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	DIV.s	%f1, %f1, %f4
	SWC1	%f1, 0(%r4)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.27939:
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 2(%r2)
	MUL.s	%f7, %f4, %f4
	LW	%r3, 4(%r1)
	LWC1	%f8, 0(%r3)
	MUL.s	%f7, %f7, %f8
	MUL.s	%f8, %f5, %f5
	LW	%r3, 4(%r1)
	LWC1	%f9, 1(%r3)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	MUL.s	%f8, %f6, %f6
	LW	%r3, 4(%r1)
	LWC1	%f9, 2(%r3)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	LW	%r3, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.27943
	ADD.s	%f4, %f7, %f0
	J	BEQ_cont.27944
BEQ_else.27943:
	MUL.s	%f8, %f5, %f6
	LW	%r3, 9(%r1)
	LWC1	%f9, 0(%r3)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	MUL.s	%f6, %f6, %f4
	LW	%r3, 9(%r1)
	LWC1	%f8, 1(%r3)
	MUL.s	%f6, %f6, %f8
	ADD.s	%f6, %f7, %f6
	MUL.s	%f4, %f4, %f5
	LW	%r3, 9(%r1)
	LWC1	%f5, 2(%r3)
	MUL.s	%f4, %f4, %f5
	ADD.s	%f4, %f6, %f4
BEQ_cont.27944:
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.27945
	ADDI	%r3, %r0, 0
	J	BEQ_cont.27946
BEQ_else.27945:
	ADDI	%r3, %r0, 1
BEQ_cont.27946:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.27947
	LWC1	%f5, 0(%r2)
	LWC1	%f6, 1(%r2)
	LWC1	%f7, 2(%r2)
	MUL.s	%f8, %f5, %f1
	LW	%r2, 4(%r1)
	LWC1	%f9, 0(%r2)
	MUL.s	%f8, %f8, %f9
	MUL.s	%f9, %f6, %f2
	LW	%r2, 4(%r1)
	LWC1	%f10, 1(%r2)
	MUL.s	%f9, %f9, %f10
	ADD.s	%f8, %f8, %f9
	MUL.s	%f9, %f7, %f3
	LW	%r2, 4(%r1)
	LWC1	%f10, 2(%r2)
	MUL.s	%f9, %f9, %f10
	ADD.s	%f8, %f8, %f9
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27948
	ADD.s	%f5, %f8, %f0
	J	BEQ_cont.27949
BEQ_else.27948:
	MUL.s	%f9, %f7, %f2
	MUL.s	%f10, %f6, %f3
	ADD.s	%f9, %f9, %f10
	LW	%r2, 9(%r1)
	LWC1	%f10, 0(%r2)
	MUL.s	%f9, %f9, %f10
	MUL.s	%f10, %f5, %f3
	MUL.s	%f7, %f7, %f1
	ADD.s	%f7, %f10, %f7
	LW	%r2, 9(%r1)
	LWC1	%f10, 1(%r2)
	MUL.s	%f7, %f7, %f10
	ADD.s	%f7, %f9, %f7
	MUL.s	%f5, %f5, %f2
	MUL.s	%f6, %f6, %f1
	ADD.s	%f5, %f5, %f6
	LW	%r2, 9(%r1)
	LWC1	%f6, 2(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f5, %f7, %f5
	LA	%r29, l.20813
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f5, %f8, %f5
BEQ_cont.27949:
	MUL.s	%f6, %f1, %f1
	LW	%r2, 4(%r1)
	LWC1	%f7, 0(%r2)
	MUL.s	%f6, %f6, %f7
	MUL.s	%f7, %f2, %f2
	LW	%r2, 4(%r1)
	LWC1	%f8, 1(%r2)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f7, %f3, %f3
	LW	%r2, 4(%r1)
	LWC1	%f8, 2(%r2)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27950
	ADD.s	%f1, %f6, %f0
	J	BEQ_cont.27951
BEQ_else.27950:
	MUL.s	%f7, %f2, %f3
	LW	%r2, 9(%r1)
	LWC1	%f8, 0(%r2)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f3, %f3, %f1
	LW	%r2, 9(%r1)
	LWC1	%f7, 1(%r2)
	MUL.s	%f3, %f3, %f7
	ADD.s	%f3, %f6, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r2, 9(%r1)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.27951:
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.27952
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.27953
BEQ_else.27952:
BEQ_cont.27953:
	MUL.s	%f2, %f5, %f5
	MUL.s	%f1, %f4, %f1
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.27954
	ADDI	%r2, %r0, 0
	J	BEQ_cont.27955
BEQ_else.27954:
	ADDI	%r2, %r0, 1
BEQ_cont.27955:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.27956
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.27956:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r4, 0(%r30)
	SWC1	%f4, 22(%r30)
	SWC1	%f5, 24(%r30)
	SW	%r1, 8(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27957
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.27959
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f3, %f3, %f6
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.27961
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	calc_sqrt.6353.19119
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.27962
BEQ_else.27961:
	ADD.s	%f1, %f2, %f0
BEQ_cont.27962:
	J	BEQ_cont.27960
BEQ_else.27959:
BEQ_cont.27960:
	J	BEQ_cont.27958
BEQ_else.27957:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.27958:
	LW	%r1, 8(%r30)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.27963
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.27964
BEQ_else.27963:
BEQ_cont.27964:
	LWC1	%f2, 24(%r30)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 22(%r30)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.27947:
	ADDI	%r1, %r0, 0
	JR	%r31
solver_rect_fast.2865:
	LW	%r4, 1(%r26)
	LWC1	%f4, 0(%r3)
	SUB.s	%f4, %f4, %f1
	LWC1	%f5, 1(%r3)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f2
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27965
	J	BEQ_cont.27966
BEQ_else.27965:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27966:
	LW	%r5, 4(%r1)
	LWC1	%f6, 1(%r5)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27967
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27968
BEQ_else.27967:
	ADDI	%r5, %r0, 1
BEQ_cont.27968:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27969
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27970
BEQ_else.27969:
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f3
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27971
	J	BEQ_cont.27972
BEQ_else.27971:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27972:
	LW	%r5, 4(%r1)
	LWC1	%f6, 2(%r5)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27973
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27974
BEQ_else.27973:
	ADDI	%r5, %r0, 1
BEQ_cont.27974:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27975
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27976
BEQ_else.27975:
	LWC1	%f5, 1(%r3)
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.eq.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27977
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27978
BEQ_else.27977:
	ADDI	%r5, %r0, 1
BEQ_cont.27978:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27979
	ADDI	%r5, %r0, 1
	J	BEQ_cont.27980
BEQ_else.27979:
	ADDI	%r5, %r0, 0
BEQ_cont.27980:
BEQ_cont.27976:
BEQ_cont.27970:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27981
	LWC1	%f4, 2(%r3)
	SUB.s	%f4, %f4, %f2
	LWC1	%f5, 3(%r3)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 0(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f1
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27982
	J	BEQ_cont.27983
BEQ_else.27982:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27983:
	LW	%r5, 4(%r1)
	LWC1	%f6, 0(%r5)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27984
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27985
BEQ_else.27984:
	ADDI	%r5, %r0, 1
BEQ_cont.27985:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27986
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27987
BEQ_else.27986:
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f3
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27988
	J	BEQ_cont.27989
BEQ_else.27988:
	SUB.s	%f5, %f0, %f5
BEQ_cont.27989:
	LW	%r5, 4(%r1)
	LWC1	%f6, 2(%r5)
	C.le.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27990
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27991
BEQ_else.27990:
	ADDI	%r5, %r0, 1
BEQ_cont.27991:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27992
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27993
BEQ_else.27992:
	LWC1	%f5, 3(%r3)
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	C.eq.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.27994
	ADDI	%r5, %r0, 0
	J	BEQ_cont.27995
BEQ_else.27994:
	ADDI	%r5, %r0, 1
BEQ_cont.27995:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27996
	ADDI	%r5, %r0, 1
	J	BEQ_cont.27997
BEQ_else.27996:
	ADDI	%r5, %r0, 0
BEQ_cont.27997:
BEQ_cont.27993:
BEQ_cont.27987:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.27998
	LWC1	%f4, 4(%r3)
	SUB.s	%f3, %f4, %f3
	LWC1	%f4, 5(%r3)
	MUL.s	%f3, %f3, %f4
	LWC1	%f4, 0(%r2)
	MUL.s	%f4, %f3, %f4
	ADD.s	%f1, %f4, %f1
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.27999
	J	BEQ_cont.28000
BEQ_else.27999:
	SUB.s	%f1, %f0, %f1
BEQ_cont.28000:
	LW	%r5, 4(%r1)
	LWC1	%f4, 0(%r5)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.28001
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28002
BEQ_else.28001:
	ADDI	%r5, %r0, 1
BEQ_cont.28002:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28003
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28004
BEQ_else.28003:
	LWC1	%f1, 1(%r2)
	MUL.s	%f1, %f3, %f1
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28005
	J	BEQ_cont.28006
BEQ_else.28005:
	SUB.s	%f1, %f0, %f1
BEQ_cont.28006:
	LW	%r1, 4(%r1)
	LWC1	%f2, 1(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28007
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28008
BEQ_else.28007:
	ADDI	%r1, %r0, 1
BEQ_cont.28008:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28009
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28010
BEQ_else.28009:
	LWC1	%f1, 5(%r3)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28011
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28012
BEQ_else.28011:
	ADDI	%r1, %r0, 1
BEQ_cont.28012:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28013
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28014
BEQ_else.28013:
	ADDI	%r1, %r0, 0
BEQ_cont.28014:
BEQ_cont.28010:
BEQ_cont.28004:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28015
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28015:
	SWC1	%f3, 0(%r4)
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.27998:
	SWC1	%f4, 0(%r4)
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.27981:
	SWC1	%f4, 0(%r4)
	ADDI	%r1, %r0, 1
	JR	%r31
calc_sqrt.6353.11101:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28016
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28017
	J	calc_sqrt.6353.11101
BEQ_else.28017:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28016:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.11112:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28018
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28019
	J	calc_sqrt.6353.11112
BEQ_else.28019:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28018:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_second_fast.2878:
	LW	%r3, 1(%r26)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28020
	ADDI	%r4, %r0, 0
	J	BEQ_cont.28021
BEQ_else.28020:
	ADDI	%r4, %r0, 1
BEQ_cont.28021:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28022
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f5, %f1
	LWC1	%f6, 2(%r2)
	MUL.s	%f6, %f6, %f2
	ADD.s	%f5, %f5, %f6
	LWC1	%f6, 3(%r2)
	MUL.s	%f6, %f6, %f3
	ADD.s	%f5, %f5, %f6
	MUL.s	%f6, %f1, %f1
	LW	%r4, 4(%r1)
	LWC1	%f7, 0(%r4)
	MUL.s	%f6, %f6, %f7
	MUL.s	%f7, %f2, %f2
	LW	%r4, 4(%r1)
	LWC1	%f8, 1(%r4)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f7, %f3, %f3
	LW	%r4, 4(%r1)
	LWC1	%f8, 2(%r4)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	LW	%r4, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28023
	ADD.s	%f1, %f6, %f0
	J	BEQ_cont.28024
BEQ_else.28023:
	MUL.s	%f7, %f2, %f3
	LW	%r4, 9(%r1)
	LWC1	%f8, 0(%r4)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f3, %f3, %f1
	LW	%r4, 9(%r1)
	LWC1	%f7, 1(%r4)
	MUL.s	%f3, %f3, %f7
	ADD.s	%f3, %f6, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r4, 9(%r1)
	LWC1	%f2, 2(%r4)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28024:
	LW	%r4, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r4, %r27, BEQ_else.28025
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28026
BEQ_else.28025:
BEQ_cont.28026:
	MUL.s	%f2, %f5, %f5
	MUL.s	%f1, %f4, %f1
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28027
	ADDI	%r4, %r0, 0
	J	BEQ_cont.28028
BEQ_else.28027:
	ADDI	%r4, %r0, 1
BEQ_cont.28028:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28029
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28029:
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28030
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f5, 2(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28032
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28034
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28036
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.11112
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28037
BEQ_else.28036:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28037:
	J	BEQ_cont.28035
BEQ_else.28034:
BEQ_cont.28035:
	J	BEQ_cont.28033
BEQ_else.28032:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28033:
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28031
BEQ_else.28030:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f5, 2(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28038
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28040
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28042
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.11101
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28043
BEQ_else.28042:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28043:
	J	BEQ_cont.28041
BEQ_else.28040:
BEQ_cont.28041:
	J	BEQ_cont.28039
BEQ_else.28038:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28039:
	LWC1	%f2, 2(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
BEQ_cont.28031:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28022:
	ADDI	%r1, %r0, 0
	JR	%r31
calc_sqrt.6353.18833:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28044
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28045
	J	calc_sqrt.6353.18833
BEQ_else.28045:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28044:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.18852:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28046
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28047
	J	calc_sqrt.6353.18852
BEQ_else.28047:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28046:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_fast.2884:
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADD	%r29, %r6, %r1
	LW	%r6, 0(%r29)
	LWC1	%f1, 0(%r3)
	LW	%r7, 5(%r6)
	LWC1	%f2, 0(%r7)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LW	%r7, 5(%r6)
	LWC1	%f3, 1(%r7)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r3)
	LW	%r3, 5(%r6)
	LWC1	%f4, 2(%r3)
	SUB.s	%f3, %f3, %f4
	LW	%r3, 1(%r2)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	LW	%r1, 1(%r6)
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28048
	LW	%r2, 0(%r2)
	ADDI	%r1, %r6, 0
	ADDI	%r26, %r4, 0
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28048:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28049
	LWC1	%f4, 0(%r3)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28050
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28051
BEQ_else.28050:
	ADDI	%r1, %r0, 1
BEQ_cont.28051:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28052
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28052:
	LWC1	%f4, 1(%r3)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r3)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r5)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28049:
	LWC1	%f4, 0(%r3)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28053
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28054
BEQ_else.28053:
	ADDI	%r1, %r0, 1
BEQ_cont.28054:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28055
	LWC1	%f5, 1(%r3)
	MUL.s	%f5, %f5, %f1
	LWC1	%f6, 2(%r3)
	MUL.s	%f6, %f6, %f2
	ADD.s	%f5, %f5, %f6
	LWC1	%f6, 3(%r3)
	MUL.s	%f6, %f6, %f3
	ADD.s	%f5, %f5, %f6
	MUL.s	%f6, %f1, %f1
	LW	%r1, 4(%r6)
	LWC1	%f7, 0(%r1)
	MUL.s	%f6, %f6, %f7
	MUL.s	%f7, %f2, %f2
	LW	%r1, 4(%r6)
	LWC1	%f8, 1(%r1)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f7, %f3, %f3
	LW	%r1, 4(%r6)
	LWC1	%f8, 2(%r1)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	LW	%r1, 3(%r6)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28056
	ADD.s	%f1, %f6, %f0
	J	BEQ_cont.28057
BEQ_else.28056:
	MUL.s	%f7, %f2, %f3
	LW	%r1, 9(%r6)
	LWC1	%f8, 0(%r1)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f6, %f6, %f7
	MUL.s	%f3, %f3, %f1
	LW	%r1, 9(%r6)
	LWC1	%f7, 1(%r1)
	MUL.s	%f3, %f3, %f7
	ADD.s	%f3, %f6, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r1, 9(%r6)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28057:
	LW	%r1, 1(%r6)
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.28058
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28059
BEQ_else.28058:
BEQ_cont.28059:
	MUL.s	%f2, %f5, %f5
	MUL.s	%f1, %f4, %f1
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28060
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28061
BEQ_else.28060:
	ADDI	%r1, %r0, 1
BEQ_cont.28061:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28062
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28062:
	LW	%r1, 6(%r6)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28063
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r5, 0(%r30)
	SW	%r3, 1(%r30)
	SWC1	%f5, 2(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28065
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28067
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28069
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.18852
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28070
BEQ_else.28069:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28070:
	J	BEQ_cont.28068
BEQ_else.28067:
BEQ_cont.28068:
	J	BEQ_cont.28066
BEQ_else.28065:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28066:
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28064
BEQ_else.28063:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r5, 0(%r30)
	SW	%r3, 1(%r30)
	SWC1	%f5, 2(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28071
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28073
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28075
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.18833
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28076
BEQ_else.28075:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28076:
	J	BEQ_cont.28074
BEQ_else.28073:
BEQ_cont.28074:
	J	BEQ_cont.28072
BEQ_else.28071:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28072:
	LWC1	%f2, 2(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
BEQ_cont.28064:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28055:
	ADDI	%r1, %r0, 0
	JR	%r31
calc_sqrt.6353.10957:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28077
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28078
	J	calc_sqrt.6353.10957
BEQ_else.28078:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28077:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.10968:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28079
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28080
	J	calc_sqrt.6353.10968
BEQ_else.28080:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28079:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_second_fast2.2895:
	LW	%r4, 1(%r26)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28081
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28082
BEQ_else.28081:
	ADDI	%r5, %r0, 1
BEQ_cont.28082:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28083
	LWC1	%f5, 1(%r2)
	MUL.s	%f1, %f5, %f1
	LWC1	%f5, 2(%r2)
	MUL.s	%f2, %f5, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r3)
	MUL.s	%f3, %f1, %f1
	MUL.s	%f2, %f4, %f2
	SUB.s	%f2, %f3, %f2
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28084
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28085
BEQ_else.28084:
	ADDI	%r3, %r0, 1
BEQ_cont.28085:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28086
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28086:
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28087
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f1, 2(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28089
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28091
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.28093
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.10968
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28094
BEQ_else.28093:
	ADD.s	%f1, %f3, %f0
BEQ_cont.28094:
	J	BEQ_cont.28092
BEQ_else.28091:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28092:
	J	BEQ_cont.28090
BEQ_else.28089:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28090:
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28088
BEQ_else.28087:
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f1, 2(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28095
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28097
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.28099
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.10957
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28100
BEQ_else.28099:
	ADD.s	%f1, %f3, %f0
BEQ_cont.28100:
	J	BEQ_cont.28098
BEQ_else.28097:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28098:
	J	BEQ_cont.28096
BEQ_else.28095:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28096:
	LWC1	%f2, 2(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
BEQ_cont.28088:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28083:
	ADDI	%r1, %r0, 0
	JR	%r31
calc_sqrt.6353.18765:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28101
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28102
	J	calc_sqrt.6353.18765
BEQ_else.28102:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28101:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.18784:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28103
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28104
	J	calc_sqrt.6353.18784
BEQ_else.28104:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28103:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_fast2.2902:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r5, %r1
	LW	%r5, 0(%r29)
	LW	%r6, 10(%r5)
	LWC1	%f1, 0(%r6)
	LWC1	%f2, 1(%r6)
	LWC1	%f3, 2(%r6)
	LW	%r7, 1(%r2)
	ADD	%r29, %r7, %r1
	LW	%r1, 0(%r29)
	LW	%r7, 1(%r5)
	ADDI	%r27, %r0, 1
	BNE	%r7, %r27, BEQ_else.28105
	LW	%r2, 0(%r2)
	ADDI	%r26, %r3, 0
	ADDI	%r3, %r1, 0
	ADDI	%r1, %r5, 0
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28105:
	ADDI	%r27, %r0, 2
	BNE	%r7, %r27, BEQ_else.28106
	LWC1	%f1, 0(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28107
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28108
BEQ_else.28107:
	ADDI	%r2, %r0, 1
BEQ_cont.28108:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28109
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28109:
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 3(%r6)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r4)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28106:
	LWC1	%f4, 0(%r1)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28110
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28111
BEQ_else.28110:
	ADDI	%r2, %r0, 1
BEQ_cont.28111:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28112
	LWC1	%f5, 1(%r1)
	MUL.s	%f1, %f5, %f1
	LWC1	%f5, 2(%r1)
	MUL.s	%f2, %f5, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r1)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r6)
	MUL.s	%f3, %f1, %f1
	MUL.s	%f2, %f4, %f2
	SUB.s	%f2, %f3, %f2
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28113
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28114
BEQ_else.28113:
	ADDI	%r2, %r0, 1
BEQ_cont.28114:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28115
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28115:
	LW	%r2, 6(%r5)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28116
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f1, 2(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28118
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28120
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.28122
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.18784
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28123
BEQ_else.28122:
	ADD.s	%f1, %f3, %f0
BEQ_cont.28123:
	J	BEQ_cont.28121
BEQ_else.28120:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28121:
	J	BEQ_cont.28119
BEQ_else.28118:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28119:
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28117
BEQ_else.28116:
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f1, 2(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28124
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28126
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.28128
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.18765
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28129
BEQ_else.28128:
	ADD.s	%f1, %f3, %f0
BEQ_cont.28129:
	J	BEQ_cont.28127
BEQ_else.28126:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28127:
	J	BEQ_cont.28125
BEQ_else.28124:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28125:
	LWC1	%f2, 2(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
BEQ_cont.28117:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28112:
	ADDI	%r1, %r0, 0
	JR	%r31
setup_rect_table.2905:
	ADDI	%r3, %r0, 6
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LWC1	%f1, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28130
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28131
BEQ_else.28130:
	ADDI	%r3, %r0, 1
BEQ_cont.28131:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28132
	LW	%r3, 0(%r30)
	LW	%r4, 6(%r3)
	LWC1	%f1, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28134
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28135
BEQ_else.28134:
	ADDI	%r5, %r0, 1
BEQ_cont.28135:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28136
	ADDI	%r4, %r5, 0
	J	BEQ_cont.28137
BEQ_else.28136:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28138
	ADDI	%r4, %r0, 1
	J	BEQ_cont.28139
BEQ_else.28138:
	ADDI	%r4, %r0, 0
BEQ_cont.28139:
BEQ_cont.28137:
	LW	%r5, 4(%r3)
	LWC1	%f1, 0(%r5)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28140
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.28141
BEQ_else.28140:
BEQ_cont.28141:
	SWC1	%f1, 0(%r1)
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 0(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r1)
	J	BEQ_cont.28133
BEQ_else.28132:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 1(%r1)
BEQ_cont.28133:
	LWC1	%f1, 1(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28142
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28143
BEQ_else.28142:
	ADDI	%r3, %r0, 1
BEQ_cont.28143:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28144
	LW	%r3, 0(%r30)
	LW	%r4, 6(%r3)
	LWC1	%f1, 1(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28146
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28147
BEQ_else.28146:
	ADDI	%r5, %r0, 1
BEQ_cont.28147:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28148
	ADDI	%r4, %r5, 0
	J	BEQ_cont.28149
BEQ_else.28148:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28150
	ADDI	%r4, %r0, 1
	J	BEQ_cont.28151
BEQ_else.28150:
	ADDI	%r4, %r0, 0
BEQ_cont.28151:
BEQ_cont.28149:
	LW	%r5, 4(%r3)
	LWC1	%f1, 1(%r5)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28152
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.28153
BEQ_else.28152:
BEQ_cont.28153:
	SWC1	%f1, 2(%r1)
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 1(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 3(%r1)
	J	BEQ_cont.28145
BEQ_else.28144:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 3(%r1)
BEQ_cont.28145:
	LWC1	%f1, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28154
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28155
BEQ_else.28154:
	ADDI	%r3, %r0, 1
BEQ_cont.28155:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28156
	LW	%r3, 0(%r30)
	LW	%r4, 6(%r3)
	LWC1	%f1, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28158
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28159
BEQ_else.28158:
	ADDI	%r5, %r0, 1
BEQ_cont.28159:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28160
	ADDI	%r4, %r5, 0
	J	BEQ_cont.28161
BEQ_else.28160:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28162
	ADDI	%r4, %r0, 1
	J	BEQ_cont.28163
BEQ_else.28162:
	ADDI	%r4, %r0, 0
BEQ_cont.28163:
BEQ_cont.28161:
	LW	%r3, 4(%r3)
	LWC1	%f1, 2(%r3)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28164
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.28165
BEQ_else.28164:
BEQ_cont.28165:
	SWC1	%f1, 4(%r1)
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 5(%r1)
	J	BEQ_cont.28157
BEQ_else.28156:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 5(%r1)
BEQ_cont.28157:
	JR	%r31
setup_surface_table.2908:
	ADDI	%r3, %r0, 4
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 0(%r30)
	LW	%r4, 4(%r3)
	LWC1	%f2, 0(%r4)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f3, 1(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	LW	%r2, 4(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28166
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28167
BEQ_else.28166:
	ADDI	%r2, %r0, 1
BEQ_cont.28167:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28168
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28169
BEQ_else.28168:
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 0(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 1(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 1(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 2(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f2, %f1
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 3(%r1)
BEQ_cont.28169:
	JR	%r31
setup_second_table.2911:
	ADDI	%r3, %r0, 5
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 1(%r2)
	LWC1	%f3, 2(%r2)
	MUL.s	%f4, %f1, %f1
	LW	%r3, 0(%r30)
	LW	%r4, 4(%r3)
	LWC1	%f5, 0(%r4)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r4, 4(%r3)
	LWC1	%f6, 1(%r4)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r4, 4(%r3)
	LWC1	%f6, 2(%r4)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r4, 3(%r3)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28170
	ADD.s	%f1, %f4, %f0
	J	BEQ_cont.28171
BEQ_else.28170:
	MUL.s	%f5, %f2, %f3
	LW	%r4, 9(%r3)
	LWC1	%f6, 0(%r4)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r4, 9(%r3)
	LWC1	%f5, 1(%r4)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r4, 9(%r3)
	LWC1	%f2, 2(%r4)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28171:
	LWC1	%f2, 0(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f3, 0(%r4)
	MUL.s	%f2, %f2, %f3
	SUB.s	%f2, %f0, %f2
	LWC1	%f3, 1(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f4, 1(%r4)
	MUL.s	%f3, %f3, %f4
	SUB.s	%f3, %f0, %f3
	LWC1	%f4, 2(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f5, 2(%r4)
	MUL.s	%f4, %f4, %f5
	SUB.s	%f4, %f0, %f4
	SWC1	%f1, 0(%r1)
	LW	%r4, 3(%r3)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28172
	SWC1	%f2, 1(%r1)
	SWC1	%f3, 2(%r1)
	SWC1	%f4, 3(%r1)
	J	BEQ_cont.28173
BEQ_else.28172:
	LWC1	%f5, 2(%r2)
	LW	%r4, 9(%r3)
	LWC1	%f6, 1(%r4)
	MUL.s	%f5, %f5, %f6
	LWC1	%f6, 1(%r2)
	LW	%r4, 9(%r3)
	LWC1	%f7, 2(%r4)
	MUL.s	%f6, %f6, %f7
	ADD.s	%f5, %f5, %f6
	LA	%r29, l.20813
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	SUB.s	%f2, %f2, %f5
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r2)
	LW	%r4, 9(%r3)
	LWC1	%f5, 0(%r4)
	MUL.s	%f2, %f2, %f5
	LWC1	%f5, 0(%r2)
	LW	%r4, 9(%r3)
	LWC1	%f6, 2(%r4)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f2, %f2, %f5
	LA	%r29, l.20813
	LWC1	%f5, 0(%r29)
	MUL.s	%f2, %f2, %f5
	SUB.s	%f2, %f3, %f2
	SWC1	%f2, 2(%r1)
	LWC1	%f2, 1(%r2)
	LW	%r4, 9(%r3)
	LWC1	%f3, 0(%r4)
	MUL.s	%f2, %f2, %f3
	LWC1	%f3, 0(%r2)
	LW	%r2, 9(%r3)
	LWC1	%f5, 1(%r2)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.20813
	LWC1	%f3, 0(%r29)
	MUL.s	%f2, %f2, %f3
	SUB.s	%f2, %f4, %f2
	SWC1	%f2, 3(%r1)
BEQ_cont.28173:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28174
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28175
BEQ_else.28174:
	ADDI	%r2, %r0, 1
BEQ_cont.28175:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28176
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	SWC1	%f1, 4(%r1)
	J	BEQ_cont.28177
BEQ_else.28176:
BEQ_cont.28177:
	JR	%r31
iter_setup_dirvec_constants.2914:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.28178
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	LW	%r5, 1(%r1)
	LW	%r6, 0(%r1)
	LW	%r7, 1(%r4)
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r7, %r27, BEQ_else.28179
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.28180
BEQ_else.28179:
	ADDI	%r27, %r0, 2
	BNE	%r7, %r27, BEQ_else.28181
	ADDI	%r7, %r0, 4
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r6, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 5(%r30)
	LW	%r4, 4(%r3)
	LWC1	%f2, 0(%r4)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f3, 1(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	LW	%r2, 4(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28183
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28184
BEQ_else.28183:
	ADDI	%r2, %r0, 1
BEQ_cont.28184:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28185
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28186
BEQ_else.28185:
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 0(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 1(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 1(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 2(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f2, %f1
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 3(%r1)
BEQ_cont.28186:
	LW	%r2, 3(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.28182
BEQ_else.28181:
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.28182:
BEQ_cont.28180:
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.28187
	LW	%r2, 2(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	LW	%r4, 1(%r3)
	LW	%r5, 0(%r3)
	LW	%r6, 1(%r2)
	ADDI	%r27, %r0, 1
	BNE	%r6, %r27, BEQ_else.28188
	SW	%r1, 7(%r30)
	SW	%r4, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.28189
BEQ_else.28188:
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.28190
	ADDI	%r6, %r0, 4
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 7(%r30)
	SW	%r4, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r5, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 9(%r30)
	LW	%r4, 4(%r3)
	LWC1	%f2, 0(%r4)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f3, 1(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	LW	%r2, 4(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28192
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28193
BEQ_else.28192:
	ADDI	%r2, %r0, 1
BEQ_cont.28193:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28194
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28195
BEQ_else.28194:
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 0(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 1(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 1(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 2(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f2, %f1
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 3(%r1)
BEQ_cont.28195:
	LW	%r2, 7(%r30)
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.28191
BEQ_else.28190:
	SW	%r1, 7(%r30)
	SW	%r4, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.28191:
BEQ_cont.28189:
	ADDI	%r2, %r2, -1
	LW	%r1, 1(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28187:
	JR	%r31
BEQ_else.28178:
	JR	%r31
setup_dirvec_constants.2917:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	LW	%r3, 0(%r3)
	ADDI	%r3, %r3, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.28198
	ADD	%r29, %r2, %r3
	LW	%r2, 0(%r29)
	LW	%r5, 1(%r1)
	LW	%r6, 0(%r1)
	LW	%r7, 1(%r2)
	SW	%r1, 0(%r30)
	SW	%r4, 1(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r7, %r27, BEQ_else.28199
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.28200
BEQ_else.28199:
	ADDI	%r27, %r0, 2
	BNE	%r7, %r27, BEQ_else.28201
	ADDI	%r7, %r0, 4
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r6, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 4(%r30)
	LW	%r4, 4(%r3)
	LWC1	%f2, 0(%r4)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r2)
	LW	%r4, 4(%r3)
	LWC1	%f3, 1(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	LW	%r2, 4(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28203
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28204
BEQ_else.28203:
	ADDI	%r2, %r0, 1
BEQ_cont.28204:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28205
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.28206
BEQ_else.28205:
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 0(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 1(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 1(%r2)
	DIV.s	%f2, %f2, %f1
	SUB.s	%f2, %f0, %f2
	SWC1	%f2, 2(%r1)
	LW	%r2, 4(%r3)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f2, %f1
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 3(%r1)
BEQ_cont.28206:
	LW	%r2, 2(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.28202
BEQ_else.28201:
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.28202:
BEQ_cont.28200:
	ADDI	%r2, %r2, -1
	LW	%r1, 0(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28198:
	JR	%r31
setup_startp_constants.2919:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.28208
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	LW	%r5, 10(%r4)
	LW	%r6, 1(%r4)
	LWC1	%f1, 0(%r1)
	LW	%r7, 5(%r4)
	LWC1	%f2, 0(%r7)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r1)
	LW	%r7, 5(%r4)
	LWC1	%f2, 1(%r7)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r1)
	LW	%r7, 5(%r4)
	LWC1	%f2, 2(%r7)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r5)
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.28209
	LW	%r4, 4(%r4)
	LWC1	%f1, 0(%r5)
	LWC1	%f2, 1(%r5)
	LWC1	%f3, 2(%r5)
	LWC1	%f4, 0(%r4)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 1(%r4)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 3(%r5)
	J	BEQ_cont.28210
BEQ_else.28209:
	ADDI	%r27, %r0, 2
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.28211
	J	BEQ_cont.28212
BEQ_else.28211:
	LWC1	%f1, 0(%r5)
	LWC1	%f2, 1(%r5)
	LWC1	%f3, 2(%r5)
	MUL.s	%f4, %f1, %f1
	LW	%r7, 4(%r4)
	LWC1	%f5, 0(%r7)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r7, 4(%r4)
	LWC1	%f6, 1(%r7)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r7, 4(%r4)
	LWC1	%f6, 2(%r7)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r7, 3(%r4)
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.28213
	ADD.s	%f1, %f4, %f0
	J	BEQ_cont.28214
BEQ_else.28213:
	MUL.s	%f5, %f2, %f3
	LW	%r7, 9(%r4)
	LWC1	%f6, 0(%r7)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r7, 9(%r4)
	LWC1	%f5, 1(%r7)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r4, 9(%r4)
	LWC1	%f2, 2(%r4)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28214:
	ADDI	%r27, %r0, 3
	BNE	%r6, %r27, BEQ_else.28215
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28216
BEQ_else.28215:
BEQ_cont.28216:
	SWC1	%f1, 3(%r5)
BEQ_cont.28212:
BEQ_cont.28210:
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.28217
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 10(%r3)
	LW	%r5, 1(%r3)
	LWC1	%f1, 0(%r1)
	LW	%r6, 5(%r3)
	LWC1	%f2, 0(%r6)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r4)
	LWC1	%f1, 1(%r1)
	LW	%r6, 5(%r3)
	LWC1	%f2, 1(%r6)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r4)
	LWC1	%f1, 2(%r1)
	LW	%r6, 5(%r3)
	LWC1	%f2, 2(%r6)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r4)
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.28218
	LW	%r3, 4(%r3)
	LWC1	%f1, 0(%r4)
	LWC1	%f2, 1(%r4)
	LWC1	%f3, 2(%r4)
	LWC1	%f4, 0(%r3)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 1(%r3)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 3(%r4)
	J	BEQ_cont.28219
BEQ_else.28218:
	ADDI	%r27, %r0, 2
	SLT	%r27, %r27, %r5
	BNE	%r27, %r0, BEQ_else.28220
	J	BEQ_cont.28221
BEQ_else.28220:
	LWC1	%f1, 0(%r4)
	LWC1	%f2, 1(%r4)
	LWC1	%f3, 2(%r4)
	MUL.s	%f4, %f1, %f1
	LW	%r6, 4(%r3)
	LWC1	%f5, 0(%r6)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r6, 4(%r3)
	LWC1	%f6, 1(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r6, 4(%r3)
	LWC1	%f6, 2(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r6, 3(%r3)
	ADDI	%r27, %r0, 0
	BNE	%r6, %r27, BEQ_else.28222
	ADD.s	%f1, %f4, %f0
	J	BEQ_cont.28223
BEQ_else.28222:
	MUL.s	%f5, %f2, %f3
	LW	%r6, 9(%r3)
	LWC1	%f6, 0(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r6, 9(%r3)
	LWC1	%f5, 1(%r6)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r3, 9(%r3)
	LWC1	%f2, 2(%r3)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28223:
	ADDI	%r27, %r0, 3
	BNE	%r5, %r27, BEQ_else.28224
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28225
BEQ_else.28224:
BEQ_cont.28225:
	SWC1	%f1, 3(%r4)
BEQ_cont.28221:
BEQ_cont.28219:
	ADDI	%r2, %r2, -1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28217:
	JR	%r31
BEQ_else.28208:
	JR	%r31
setup_startp.2922:
	LW	%r2, 4(%r26)
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	LWC1	%f1, 0(%r1)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 2(%r2)
	LW	%r2, 0(%r5)
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.28228
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r5, 10(%r4)
	LW	%r6, 1(%r4)
	LWC1	%f1, 0(%r1)
	LW	%r7, 5(%r4)
	LWC1	%f2, 0(%r7)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r1)
	LW	%r7, 5(%r4)
	LWC1	%f2, 1(%r7)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r1)
	LW	%r7, 5(%r4)
	LWC1	%f2, 2(%r7)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r5)
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.28229
	LW	%r4, 4(%r4)
	LWC1	%f1, 0(%r5)
	LWC1	%f2, 1(%r5)
	LWC1	%f3, 2(%r5)
	LWC1	%f4, 0(%r4)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 1(%r4)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 3(%r5)
	J	BEQ_cont.28230
BEQ_else.28229:
	ADDI	%r27, %r0, 2
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.28231
	J	BEQ_cont.28232
BEQ_else.28231:
	LWC1	%f1, 0(%r5)
	LWC1	%f2, 1(%r5)
	LWC1	%f3, 2(%r5)
	MUL.s	%f4, %f1, %f1
	LW	%r7, 4(%r4)
	LWC1	%f5, 0(%r7)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r7, 4(%r4)
	LWC1	%f6, 1(%r7)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r7, 4(%r4)
	LWC1	%f6, 2(%r7)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r7, 3(%r4)
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.28233
	ADD.s	%f1, %f4, %f0
	J	BEQ_cont.28234
BEQ_else.28233:
	MUL.s	%f5, %f2, %f3
	LW	%r7, 9(%r4)
	LWC1	%f6, 0(%r7)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r7, 9(%r4)
	LWC1	%f5, 1(%r7)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r4, 9(%r4)
	LWC1	%f2, 2(%r4)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28234:
	ADDI	%r27, %r0, 3
	BNE	%r6, %r27, BEQ_else.28235
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28236
BEQ_else.28235:
BEQ_cont.28236:
	SWC1	%f1, 3(%r5)
BEQ_cont.28232:
BEQ_cont.28230:
	ADDI	%r2, %r2, -1
	ADDI	%r26, %r3, 0
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28228:
	JR	%r31
is_rect_outside.2924:
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.28238
	J	BEQ_cont.28239
BEQ_else.28238:
	SUB.s	%f1, %f0, %f1
BEQ_cont.28239:
	LW	%r2, 4(%r1)
	LWC1	%f4, 0(%r2)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.28240
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28241
BEQ_else.28240:
	ADDI	%r2, %r0, 1
BEQ_cont.28241:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28242
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28243
BEQ_else.28242:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28244
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.28245
BEQ_else.28244:
	SUB.s	%f1, %f0, %f2
BEQ_cont.28245:
	LW	%r2, 4(%r1)
	LWC1	%f2, 1(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28246
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28247
BEQ_else.28246:
	ADDI	%r2, %r0, 1
BEQ_cont.28247:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28248
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28249
BEQ_else.28248:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28250
	ADD.s	%f1, %f3, %f0
	J	BEQ_cont.28251
BEQ_else.28250:
	SUB.s	%f1, %f0, %f3
BEQ_cont.28251:
	LW	%r2, 4(%r1)
	LWC1	%f2, 2(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28252
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28253
BEQ_else.28252:
	ADDI	%r2, %r0, 1
BEQ_cont.28253:
BEQ_cont.28249:
BEQ_cont.28243:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28254
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28255
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28255:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28254:
	LW	%r1, 6(%r1)
	JR	%r31
is_plane_outside.2929:
	LW	%r2, 4(%r1)
	LWC1	%f4, 0(%r2)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 1(%r2)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 6(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28256
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28257
BEQ_else.28256:
	ADDI	%r2, %r0, 1
BEQ_cont.28257:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28258
	ADDI	%r1, %r2, 0
	J	BEQ_cont.28259
BEQ_else.28258:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28260
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28261
BEQ_else.28260:
	ADDI	%r1, %r0, 0
BEQ_cont.28261:
BEQ_cont.28259:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28262
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28262:
	ADDI	%r1, %r0, 0
	JR	%r31
is_second_outside.2934:
	MUL.s	%f4, %f1, %f1
	LW	%r2, 4(%r1)
	LWC1	%f5, 0(%r2)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r2, 4(%r1)
	LWC1	%f6, 1(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r2, 4(%r1)
	LWC1	%f6, 2(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28263
	ADD.s	%f1, %f4, %f0
	J	BEQ_cont.28264
BEQ_else.28263:
	MUL.s	%f5, %f2, %f3
	LW	%r2, 9(%r1)
	LWC1	%f6, 0(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r2, 9(%r1)
	LWC1	%f5, 1(%r2)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r2, 9(%r1)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28264:
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.28265
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28266
BEQ_else.28265:
BEQ_cont.28266:
	LW	%r1, 6(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28267
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28268
BEQ_else.28267:
	ADDI	%r2, %r0, 1
BEQ_cont.28268:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28269
	ADDI	%r1, %r2, 0
	J	BEQ_cont.28270
BEQ_else.28269:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28271
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28272
BEQ_else.28271:
	ADDI	%r1, %r0, 0
BEQ_cont.28272:
BEQ_cont.28270:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28273
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28273:
	ADDI	%r1, %r0, 0
	JR	%r31
is_outside.2939:
	LW	%r2, 5(%r1)
	LWC1	%f4, 0(%r2)
	SUB.s	%f1, %f1, %f4
	LW	%r2, 5(%r1)
	LWC1	%f4, 1(%r2)
	SUB.s	%f2, %f2, %f4
	LW	%r2, 5(%r1)
	LWC1	%f4, 2(%r2)
	SUB.s	%f3, %f3, %f4
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 1
	BNE	%r2, %r27, BEQ_else.28274
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.28275
	J	BEQ_cont.28276
BEQ_else.28275:
	SUB.s	%f1, %f0, %f1
BEQ_cont.28276:
	LW	%r2, 4(%r1)
	LWC1	%f4, 0(%r2)
	C.le.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.28277
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28278
BEQ_else.28277:
	ADDI	%r2, %r0, 1
BEQ_cont.28278:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28279
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28280
BEQ_else.28279:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28281
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.28282
BEQ_else.28281:
	SUB.s	%f1, %f0, %f2
BEQ_cont.28282:
	LW	%r2, 4(%r1)
	LWC1	%f2, 1(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28283
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28284
BEQ_else.28283:
	ADDI	%r2, %r0, 1
BEQ_cont.28284:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28285
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28286
BEQ_else.28285:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28287
	ADD.s	%f1, %f3, %f0
	J	BEQ_cont.28288
BEQ_else.28287:
	SUB.s	%f1, %f0, %f3
BEQ_cont.28288:
	LW	%r2, 4(%r1)
	LWC1	%f2, 2(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28289
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28290
BEQ_else.28289:
	ADDI	%r2, %r0, 1
BEQ_cont.28290:
BEQ_cont.28286:
BEQ_cont.28280:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28291
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28292
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28292:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28291:
	LW	%r1, 6(%r1)
	JR	%r31
BEQ_else.28274:
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.28293
	LW	%r2, 4(%r1)
	LWC1	%f4, 0(%r2)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 1(%r2)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 6(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28294
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28295
BEQ_else.28294:
	ADDI	%r2, %r0, 1
BEQ_cont.28295:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28296
	ADDI	%r1, %r2, 0
	J	BEQ_cont.28297
BEQ_else.28296:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28298
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28299
BEQ_else.28298:
	ADDI	%r1, %r0, 0
BEQ_cont.28299:
BEQ_cont.28297:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28300
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28300:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28293:
	MUL.s	%f4, %f1, %f1
	LW	%r2, 4(%r1)
	LWC1	%f5, 0(%r2)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f5, %f2, %f2
	LW	%r2, 4(%r1)
	LWC1	%f6, 1(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f5, %f3, %f3
	LW	%r2, 4(%r1)
	LWC1	%f6, 2(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28301
	ADD.s	%f1, %f4, %f0
	J	BEQ_cont.28302
BEQ_else.28301:
	MUL.s	%f5, %f2, %f3
	LW	%r2, 9(%r1)
	LWC1	%f6, 0(%r2)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f3, %f3, %f1
	LW	%r2, 9(%r1)
	LWC1	%f5, 1(%r2)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f3, %f4, %f3
	MUL.s	%f1, %f1, %f2
	LW	%r2, 9(%r1)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
BEQ_cont.28302:
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.28303
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28304
BEQ_else.28303:
BEQ_cont.28304:
	LW	%r1, 6(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28305
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28306
BEQ_else.28305:
	ADDI	%r2, %r0, 1
BEQ_cont.28306:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28307
	ADDI	%r1, %r2, 0
	J	BEQ_cont.28308
BEQ_else.28307:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28309
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28310
BEQ_else.28309:
	ADDI	%r1, %r0, 0
BEQ_cont.28310:
BEQ_cont.28308:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28311
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28311:
	ADDI	%r1, %r0, 0
	JR	%r31
check_all_inside.2944:
	LW	%r3, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r4, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28312
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28312:
	ADD	%r29, %r3, %r4
	LW	%r4, 0(%r29)
	LW	%r5, 5(%r4)
	LWC1	%f4, 0(%r5)
	SUB.s	%f4, %f1, %f4
	LW	%r5, 5(%r4)
	LWC1	%f5, 1(%r5)
	SUB.s	%f5, %f2, %f5
	LW	%r5, 5(%r4)
	LWC1	%f6, 2(%r5)
	SUB.s	%f6, %f3, %f6
	LW	%r5, 1(%r4)
	SW	%r26, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r3, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r5, %r27, BEQ_else.28314
	SWC1	%f6, 12(%r30)
	SWC1	%f5, 14(%r30)
	SW	%r4, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	abs_float.2614
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	LW	%r2, 4(%r1)
	LWC1	%f2, 0(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28317
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28318
BEQ_else.28317:
	ADDI	%r2, %r0, 1
BEQ_cont.28318:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28319
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28320
BEQ_else.28319:
	LWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	abs_float.2614
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	LW	%r2, 4(%r1)
	LWC1	%f2, 1(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28321
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28322
BEQ_else.28321:
	ADDI	%r2, %r0, 1
BEQ_cont.28322:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28323
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28324
BEQ_else.28323:
	LWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	abs_float.2614
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	LW	%r2, 4(%r1)
	LWC1	%f2, 2(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28325
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28326
BEQ_else.28325:
	ADDI	%r2, %r0, 1
BEQ_cont.28326:
BEQ_cont.28324:
BEQ_cont.28320:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28327
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28329
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28330
BEQ_else.28329:
	ADDI	%r1, %r0, 0
BEQ_cont.28330:
	J	BEQ_cont.28328
BEQ_else.28327:
	LW	%r1, 6(%r1)
BEQ_cont.28328:
	J	BEQ_cont.28315
BEQ_else.28314:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.28331
	LW	%r5, 4(%r4)
	LWC1	%f7, 0(%r5)
	MUL.s	%f4, %f7, %f4
	LWC1	%f7, 1(%r5)
	MUL.s	%f5, %f7, %f5
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r5)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LW	%r4, 6(%r4)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28333
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28334
BEQ_else.28333:
	ADDI	%r5, %r0, 1
BEQ_cont.28334:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28335
	ADDI	%r4, %r5, 0
	J	BEQ_cont.28336
BEQ_else.28335:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28337
	ADDI	%r4, %r0, 1
	J	BEQ_cont.28338
BEQ_else.28337:
	ADDI	%r4, %r0, 0
BEQ_cont.28338:
BEQ_cont.28336:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.28339
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28340
BEQ_else.28339:
	ADDI	%r1, %r0, 0
BEQ_cont.28340:
	J	BEQ_cont.28332
BEQ_else.28331:
	SWC1	%f4, 18(%r30)
	SWC1	%f6, 12(%r30)
	SWC1	%f5, 14(%r30)
	SW	%r4, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fsqr.2612
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 14(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fsqr.2612
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 22(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 12(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	fsqr.2612
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 16(%r30)
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	o_isrot.2735
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28342
	LWC1	%f1, 30(%r30)
	J	BEQ_cont.28343
BEQ_else.28342:
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 14(%r30)
	MUL.s	%f3, %f2, %f1
	LW	%r1, 16(%r30)
	SWC1	%f3, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 30(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 18(%r30)
	LWC1	%f3, 12(%r30)
	MUL.s	%f3, %f3, %f2
	LW	%r1, 16(%r30)
	SWC1	%f1, 34(%r30)
	SWC1	%f3, 36(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 36(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 34(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 18(%r30)
	MUL.s	%f2, %f3, %f2
	LW	%r1, 16(%r30)
	SWC1	%f1, 38(%r30)
	SWC1	%f2, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 40(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 38(%r30)
	ADD.s	%f1, %f2, %f1
BEQ_cont.28343:
	LW	%r1, 16(%r30)
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.28344
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.28345
BEQ_else.28344:
BEQ_cont.28345:
	LW	%r1, 6(%r1)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28346
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28347
BEQ_else.28346:
	ADDI	%r2, %r0, 1
BEQ_cont.28347:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28348
	ADDI	%r1, %r2, 0
	J	BEQ_cont.28349
BEQ_else.28348:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28350
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28351
BEQ_else.28350:
	ADDI	%r1, %r0, 0
BEQ_cont.28351:
BEQ_cont.28349:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28352
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28353
BEQ_else.28352:
	ADDI	%r1, %r0, 0
BEQ_cont.28353:
BEQ_cont.28332:
BEQ_cont.28315:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28354
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28355
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28355:
	LW	%r4, 8(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	LW	%r5, 5(%r3)
	LWC1	%f1, 0(%r5)
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r5, 5(%r3)
	LWC1	%f3, 1(%r5)
	LWC1	%f4, 4(%r30)
	SUB.s	%f3, %f4, %f3
	LW	%r5, 5(%r3)
	LWC1	%f5, 2(%r5)
	LWC1	%f6, 2(%r30)
	SUB.s	%f5, %f6, %f5
	LW	%r5, 1(%r3)
	SW	%r1, 42(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r5, %r27, BEQ_else.28356
	SWC1	%f5, 44(%r30)
	SWC1	%f3, 46(%r30)
	SW	%r3, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 49(%r30)
	ADDI	%r30, %r30, 50
	JAL	fabs.2616
	ADDI	%r29, %r0, 50
	SUB	%r30, %r30, %r29
	LW	%r29, 49(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 48(%r30)
	SWC1	%f1, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	fless.2607
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28360
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28361
BEQ_else.28360:
	LWC1	%f1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	fabs.2616
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 48(%r30)
	SWC1	%f1, 52(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 52(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	fless.2607
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28362
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28363
BEQ_else.28362:
	LWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	fabs.2616
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 48(%r30)
	SWC1	%f1, 54(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 56(%r30)
	ADDI	%r30, %r30, 57
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 57
	SUB	%r30, %r30, %r29
	LW	%r29, 56(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 54(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 56(%r30)
	ADDI	%r30, %r30, 57
	JAL	fless.2607
	ADDI	%r29, %r0, 57
	SUB	%r30, %r30, %r29
	LW	%r29, 56(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28363:
BEQ_cont.28361:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28364
	LW	%r1, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 56(%r30)
	ADDI	%r30, %r30, 57
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 57
	SUB	%r30, %r30, %r29
	LW	%r29, 56(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28366
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28367
BEQ_else.28366:
	ADDI	%r1, %r0, 0
BEQ_cont.28367:
	J	BEQ_cont.28365
BEQ_else.28364:
	LW	%r1, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 56(%r30)
	ADDI	%r30, %r30, 57
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 57
	SUB	%r30, %r30, %r29
	LW	%r29, 56(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28365:
	J	BEQ_cont.28357
BEQ_else.28356:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.28368
	SW	%r3, 48(%r30)
	SWC1	%f5, 44(%r30)
	SWC1	%f3, 46(%r30)
	SWC1	%f1, 56(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 58(%r30)
	ADDI	%r30, %r30, 59
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 59
	SUB	%r30, %r30, %r29
	LW	%r29, 58(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 56(%r30)
	LWC1	%f2, 46(%r30)
	LWC1	%f3, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 58(%r30)
	ADDI	%r30, %r30, 59
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 59
	SUB	%r30, %r30, %r29
	LW	%r29, 58(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 48(%r30)
	SWC1	%f1, 58(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 60(%r30)
	ADDI	%r30, %r30, 61
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 61
	SUB	%r30, %r30, %r29
	LW	%r29, 60(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 58(%r30)
	SW	%r1, 60(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 61(%r30)
	ADDI	%r30, %r30, 62
	JAL	fisneg.2603
	ADDI	%r29, %r0, 62
	SUB	%r30, %r30, %r29
	LW	%r29, 61(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 60(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 61(%r30)
	ADDI	%r30, %r30, 62
	JAL	xor.2670
	ADDI	%r29, %r0, 62
	SUB	%r30, %r30, %r29
	LW	%r29, 61(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28370
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28371
BEQ_else.28370:
	ADDI	%r1, %r0, 0
BEQ_cont.28371:
	J	BEQ_cont.28369
BEQ_else.28368:
	SW	%r3, 48(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADD.s	%f2, %f3, %f0
	ADD.s	%f3, %f5, %f0
	SW	%r29, 61(%r30)
	ADDI	%r30, %r30, 62
	JAL	quadratic.2842
	ADDI	%r29, %r0, 62
	SUB	%r30, %r30, %r29
	LW	%r29, 61(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 48(%r30)
	SWC1	%f1, 62(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	o_form.2729
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.28373
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 62(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.28374
BEQ_else.28373:
	LWC1	%f1, 62(%r30)
BEQ_cont.28374:
	LW	%r1, 48(%r30)
	SWC1	%f1, 64(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 66(%r30)
	ADDI	%r30, %r30, 67
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 67
	SUB	%r30, %r30, %r29
	LW	%r29, 66(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 64(%r30)
	SW	%r1, 66(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 67(%r30)
	ADDI	%r30, %r30, 68
	JAL	fisneg.2603
	ADDI	%r29, %r0, 68
	SUB	%r30, %r30, %r29
	LW	%r29, 67(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 66(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 67(%r30)
	ADDI	%r30, %r30, 68
	JAL	xor.2670
	ADDI	%r29, %r0, 68
	SUB	%r30, %r30, %r29
	LW	%r29, 67(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28375
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28376
BEQ_else.28375:
	ADDI	%r1, %r0, 0
BEQ_cont.28376:
BEQ_cont.28369:
BEQ_cont.28357:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28377
	LW	%r1, 42(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28378
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28378:
	LW	%r4, 8(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	SW	%r1, 67(%r30)
	SW	%r3, 68(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 69(%r30)
	ADDI	%r30, %r30, 70
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 70
	SUB	%r30, %r30, %r29
	LW	%r29, 69(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 68(%r30)
	SWC1	%f1, 70(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 72(%r30)
	ADDI	%r30, %r30, 73
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 73
	SUB	%r30, %r30, %r29
	LW	%r29, 72(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 68(%r30)
	SWC1	%f1, 72(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 74(%r30)
	ADDI	%r30, %r30, 75
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 75
	SUB	%r30, %r30, %r29
	LW	%r29, 74(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 68(%r30)
	SWC1	%f1, 74(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 76(%r30)
	ADDI	%r30, %r30, 77
	JAL	o_form.2729
	ADDI	%r29, %r0, 77
	SUB	%r30, %r30, %r29
	LW	%r29, 76(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28380
	LWC1	%f1, 70(%r30)
	LWC1	%f2, 72(%r30)
	LWC1	%f3, 74(%r30)
	LW	%r1, 68(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 76(%r30)
	ADDI	%r30, %r30, 77
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 77
	SUB	%r30, %r30, %r29
	LW	%r29, 76(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28381
BEQ_else.28380:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28382
	LWC1	%f1, 70(%r30)
	LWC1	%f2, 72(%r30)
	LWC1	%f3, 74(%r30)
	LW	%r1, 68(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 76(%r30)
	ADDI	%r30, %r30, 77
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 77
	SUB	%r30, %r30, %r29
	LW	%r29, 76(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28383
BEQ_else.28382:
	LWC1	%f1, 70(%r30)
	LWC1	%f2, 72(%r30)
	LWC1	%f3, 74(%r30)
	LW	%r1, 68(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 76(%r30)
	ADDI	%r30, %r30, 77
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 77
	SUB	%r30, %r30, %r29
	LW	%r29, 76(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28383:
BEQ_cont.28381:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28384
	LW	%r1, 67(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28385
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28385:
	LW	%r4, 8(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	LWC1	%f1, 6(%r30)
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 2(%r30)
	SW	%r1, 76(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 77(%r30)
	ADDI	%r30, %r30, 78
	JAL	is_outside.2939
	ADDI	%r29, %r0, 78
	SUB	%r30, %r30, %r29
	LW	%r29, 77(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28386
	LW	%r1, 76(%r30)
	ADDI	%r1, %r1, 1
	LWC1	%f1, 6(%r30)
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 2(%r30)
	LW	%r2, 9(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28386:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28384:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28377:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28354:
	ADDI	%r1, %r0, 0
	JR	%r31
shadow_check_and_group.2950:
	LW	%r3, 11(%r26)
	LW	%r4, 10(%r26)
	LW	%r5, 9(%r26)
	LW	%r6, 8(%r26)
	LW	%r7, 7(%r26)
	LW	%r8, 6(%r26)
	LW	%r9, 5(%r26)
	LW	%r10, 4(%r26)
	LW	%r11, 3(%r26)
	LW	%r12, 2(%r26)
	LW	%r13, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r14, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r14, %r27, BEQ_else.28387
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28387:
	ADD	%r29, %r2, %r1
	LW	%r14, 0(%r29)
	ADD	%r29, %r8, %r14
	LW	%r15, 0(%r29)
	LWC1	%f1, 0(%r11)
	LW	%r16, 5(%r15)
	LWC1	%f2, 0(%r16)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r11)
	LW	%r16, 5(%r15)
	LWC1	%f3, 1(%r16)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r11)
	LW	%r16, 5(%r15)
	LWC1	%f4, 2(%r16)
	SUB.s	%f3, %f3, %f4
	ADD	%r29, %r12, %r14
	LW	%r12, 0(%r29)
	LW	%r16, 1(%r15)
	SW	%r13, 0(%r30)
	SW	%r10, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r11, 3(%r30)
	SW	%r9, 4(%r30)
	SW	%r6, 5(%r30)
	SW	%r2, 6(%r30)
	SW	%r1, 7(%r30)
	SW	%r14, 8(%r30)
	SW	%r8, 9(%r30)
	SW	%r7, 10(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r16, %r27, BEQ_else.28388
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r15, 0
	ADDI	%r26, %r5, 0
	ADDI	%r3, %r12, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28389
BEQ_else.28388:
	ADDI	%r27, %r0, 2
	BNE	%r16, %r27, BEQ_else.28390
	LWC1	%f4, 0(%r12)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28392
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28393
BEQ_else.28392:
	ADDI	%r3, %r0, 1
BEQ_cont.28393:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28394
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28395
BEQ_else.28394:
	LWC1	%f4, 1(%r12)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r12)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r12)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r7)
	ADDI	%r1, %r0, 1
BEQ_cont.28395:
	J	BEQ_cont.28391
BEQ_else.28390:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r12, 0
	ADDI	%r1, %r15, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28391:
BEQ_cont.28389:
	LW	%r2, 10(%r30)
	LWC1	%f1, 0(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28396
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28397
BEQ_else.28396:
	LA	%r29, l.21473
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28398
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28399
BEQ_else.28398:
	ADDI	%r1, %r0, 1
BEQ_cont.28399:
BEQ_cont.28397:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28400
	LW	%r1, 8(%r30)
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28401
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28401:
	LW	%r1, 7(%r30)
	ADDI	%r1, %r1, 1
	LW	%r4, 6(%r30)
	ADD	%r29, %r4, %r1
	LW	%r5, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.28402
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28402:
	ADD	%r29, %r4, %r1
	LW	%r5, 0(%r29)
	LW	%r6, 4(%r30)
	LW	%r7, 3(%r30)
	LW	%r26, 5(%r30)
	SW	%r1, 11(%r30)
	SW	%r5, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r7, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	LWC1	%f1, 0(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28403
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28404
BEQ_else.28403:
	LA	%r29, l.21473
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28405
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28406
BEQ_else.28405:
	ADDI	%r1, %r0, 1
BEQ_cont.28406:
BEQ_cont.28404:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28407
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28408
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28408:
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 6(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28407:
	LA	%r29, l.21474
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 3(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r2)
	ADD.s	%f1, %f1, %f4
	LW	%r2, 6(%r30)
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28409
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28410
BEQ_else.28409:
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	SWC1	%f1, 14(%r30)
	SWC1	%f3, 16(%r30)
	SW	%r1, 18(%r30)
	SWC1	%f2, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 18(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 18(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 18(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	o_form.2729
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28413
	LWC1	%f1, 22(%r30)
	LWC1	%f2, 24(%r30)
	LWC1	%f3, 26(%r30)
	LW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28414
BEQ_else.28413:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28415
	LWC1	%f1, 22(%r30)
	LWC1	%f2, 24(%r30)
	LWC1	%f3, 26(%r30)
	LW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28416
BEQ_else.28415:
	LWC1	%f1, 22(%r30)
	LWC1	%f2, 24(%r30)
	LWC1	%f3, 26(%r30)
	LW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28416:
BEQ_cont.28414:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28417
	LW	%r2, 6(%r30)
	LW	%r1, 1(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28419
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28420
BEQ_else.28419:
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	is_outside.2939
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28421
	ADDI	%r1, %r0, 2
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 14(%r30)
	LW	%r2, 6(%r30)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28422
BEQ_else.28421:
	ADDI	%r1, %r0, 0
BEQ_cont.28422:
BEQ_cont.28420:
	J	BEQ_cont.28418
BEQ_else.28417:
	ADDI	%r1, %r0, 0
BEQ_cont.28418:
BEQ_cont.28410:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28423
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 6(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28423:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28400:
	LA	%r29, l.21474
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r3, 3(%r30)
	LWC1	%f3, 0(%r3)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r3)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r3)
	ADD.s	%f1, %f1, %f4
	LW	%r4, 6(%r30)
	LW	%r5, 0(%r4)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.28424
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28425
BEQ_else.28424:
	LW	%r6, 9(%r30)
	ADD	%r29, %r6, %r5
	LW	%r5, 0(%r29)
	LW	%r7, 5(%r5)
	LWC1	%f4, 0(%r7)
	SUB.s	%f4, %f2, %f4
	LW	%r7, 5(%r5)
	LWC1	%f5, 1(%r7)
	SUB.s	%f5, %f3, %f5
	LW	%r7, 5(%r5)
	LWC1	%f6, 2(%r7)
	SUB.s	%f6, %f1, %f6
	LW	%r7, 1(%r5)
	SWC1	%f1, 28(%r30)
	SWC1	%f3, 30(%r30)
	SWC1	%f2, 32(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r7, %r27, BEQ_else.28426
	SWC1	%f6, 34(%r30)
	SWC1	%f5, 36(%r30)
	SW	%r5, 38(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	JAL	fabs.2616
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 38(%r30)
	SWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	fless.2607
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28429
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28430
BEQ_else.28429:
	LWC1	%f1, 36(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	fabs.2616
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 38(%r30)
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	fless.2607
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28431
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28432
BEQ_else.28431:
	LWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	fabs.2616
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 38(%r30)
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	fless.2607
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28432:
BEQ_cont.28430:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28433
	LW	%r1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28435
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28436
BEQ_else.28435:
	ADDI	%r1, %r0, 0
BEQ_cont.28436:
	J	BEQ_cont.28434
BEQ_else.28433:
	LW	%r1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28434:
	J	BEQ_cont.28427
BEQ_else.28426:
	ADDI	%r27, %r0, 2
	BNE	%r7, %r27, BEQ_else.28437
	SW	%r5, 38(%r30)
	SWC1	%f6, 34(%r30)
	SWC1	%f5, 36(%r30)
	SWC1	%f4, 46(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 46(%r30)
	LWC1	%f2, 36(%r30)
	LWC1	%f3, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 38(%r30)
	SWC1	%f1, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 48(%r30)
	SW	%r1, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 51(%r30)
	ADDI	%r30, %r30, 52
	JAL	fisneg.2603
	ADDI	%r29, %r0, 52
	SUB	%r30, %r30, %r29
	LW	%r29, 51(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 51(%r30)
	ADDI	%r30, %r30, 52
	JAL	xor.2670
	ADDI	%r29, %r0, 52
	SUB	%r30, %r30, %r29
	LW	%r29, 51(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28439
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28440
BEQ_else.28439:
	ADDI	%r1, %r0, 0
BEQ_cont.28440:
	J	BEQ_cont.28438
BEQ_else.28437:
	SW	%r5, 38(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	ADD.s	%f3, %f6, %f0
	ADD.s	%f2, %f5, %f0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 51(%r30)
	ADDI	%r30, %r30, 52
	JAL	quadratic.2842
	ADDI	%r29, %r0, 52
	SUB	%r30, %r30, %r29
	LW	%r29, 51(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 38(%r30)
	SWC1	%f1, 52(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	o_form.2729
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.28442
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 52(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.28443
BEQ_else.28442:
	LWC1	%f1, 52(%r30)
BEQ_cont.28443:
	LW	%r1, 38(%r30)
	SWC1	%f1, 54(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 56(%r30)
	ADDI	%r30, %r30, 57
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 57
	SUB	%r30, %r30, %r29
	LW	%r29, 56(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 54(%r30)
	SW	%r1, 56(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 57(%r30)
	ADDI	%r30, %r30, 58
	JAL	fisneg.2603
	ADDI	%r29, %r0, 58
	SUB	%r30, %r30, %r29
	LW	%r29, 57(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 56(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 57(%r30)
	ADDI	%r30, %r30, 58
	JAL	xor.2670
	ADDI	%r29, %r0, 58
	SUB	%r30, %r30, %r29
	LW	%r29, 57(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28444
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28445
BEQ_else.28444:
	ADDI	%r1, %r0, 0
BEQ_cont.28445:
BEQ_cont.28438:
BEQ_cont.28427:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28446
	LW	%r1, 6(%r30)
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28448
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28449
BEQ_else.28448:
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	SW	%r2, 57(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 58(%r30)
	ADDI	%r30, %r30, 59
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 59
	SUB	%r30, %r30, %r29
	LW	%r29, 58(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 57(%r30)
	SWC1	%f1, 58(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 60(%r30)
	ADDI	%r30, %r30, 61
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 61
	SUB	%r30, %r30, %r29
	LW	%r29, 60(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 30(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 57(%r30)
	SWC1	%f1, 60(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 62(%r30)
	ADDI	%r30, %r30, 63
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 63
	SUB	%r30, %r30, %r29
	LW	%r29, 62(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 57(%r30)
	SWC1	%f1, 62(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	o_form.2729
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28450
	LWC1	%f1, 58(%r30)
	LWC1	%f2, 60(%r30)
	LWC1	%f3, 62(%r30)
	LW	%r1, 57(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28451
BEQ_else.28450:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28452
	LWC1	%f1, 58(%r30)
	LWC1	%f2, 60(%r30)
	LWC1	%f3, 62(%r30)
	LW	%r1, 57(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28453
BEQ_else.28452:
	LWC1	%f1, 58(%r30)
	LWC1	%f2, 60(%r30)
	LWC1	%f3, 62(%r30)
	LW	%r1, 57(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28453:
BEQ_cont.28451:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28454
	LW	%r1, 6(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28456
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28457
BEQ_else.28456:
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	LWC1	%f1, 32(%r30)
	LWC1	%f2, 30(%r30)
	LWC1	%f3, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	is_outside.2939
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28458
	ADDI	%r1, %r0, 3
	LWC1	%f1, 32(%r30)
	LWC1	%f2, 30(%r30)
	LWC1	%f3, 28(%r30)
	LW	%r2, 6(%r30)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28459
BEQ_else.28458:
	ADDI	%r1, %r0, 0
BEQ_cont.28459:
BEQ_cont.28457:
	J	BEQ_cont.28455
BEQ_else.28454:
	ADDI	%r1, %r0, 0
BEQ_cont.28455:
BEQ_cont.28449:
	J	BEQ_cont.28447
BEQ_else.28446:
	ADDI	%r1, %r0, 0
BEQ_cont.28447:
BEQ_cont.28425:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28460
	LW	%r1, 7(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 6(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28461
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28461:
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 4(%r30)
	LW	%r5, 3(%r30)
	LW	%r26, 5(%r30)
	SW	%r1, 64(%r30)
	SW	%r3, 65(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 66(%r30)
	ADDI	%r30, %r30, 67
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 67
	SUB	%r30, %r30, %r29
	LW	%r29, 66(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	LWC1	%f1, 0(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28462
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28463
BEQ_else.28462:
	LA	%r29, l.21473
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28464
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28465
BEQ_else.28464:
	ADDI	%r1, %r0, 1
BEQ_cont.28465:
BEQ_cont.28463:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28466
	LW	%r1, 65(%r30)
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28467
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28467:
	LW	%r1, 64(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 6(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28466:
	LA	%r29, l.21474
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 3(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r2)
	ADD.s	%f1, %f1, %f4
	LW	%r2, 6(%r30)
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28468
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28469
BEQ_else.28468:
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	SWC1	%f1, 66(%r30)
	SWC1	%f3, 68(%r30)
	SW	%r1, 70(%r30)
	SWC1	%f2, 72(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 74(%r30)
	ADDI	%r30, %r30, 75
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 75
	SUB	%r30, %r30, %r29
	LW	%r29, 74(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 72(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 70(%r30)
	SWC1	%f1, 74(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 76(%r30)
	ADDI	%r30, %r30, 77
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 77
	SUB	%r30, %r30, %r29
	LW	%r29, 76(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 68(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 70(%r30)
	SWC1	%f1, 76(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 78(%r30)
	ADDI	%r30, %r30, 79
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 79
	SUB	%r30, %r30, %r29
	LW	%r29, 78(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 66(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 70(%r30)
	SWC1	%f1, 78(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 80(%r30)
	ADDI	%r30, %r30, 81
	JAL	o_form.2729
	ADDI	%r29, %r0, 81
	SUB	%r30, %r30, %r29
	LW	%r29, 80(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28471
	LWC1	%f1, 74(%r30)
	LWC1	%f2, 76(%r30)
	LWC1	%f3, 78(%r30)
	LW	%r1, 70(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 80(%r30)
	ADDI	%r30, %r30, 81
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 81
	SUB	%r30, %r30, %r29
	LW	%r29, 80(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28472
BEQ_else.28471:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28473
	LWC1	%f1, 74(%r30)
	LWC1	%f2, 76(%r30)
	LWC1	%f3, 78(%r30)
	LW	%r1, 70(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 80(%r30)
	ADDI	%r30, %r30, 81
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 81
	SUB	%r30, %r30, %r29
	LW	%r29, 80(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28474
BEQ_else.28473:
	LWC1	%f1, 74(%r30)
	LWC1	%f2, 76(%r30)
	LWC1	%f3, 78(%r30)
	LW	%r1, 70(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 80(%r30)
	ADDI	%r30, %r30, 81
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 81
	SUB	%r30, %r30, %r29
	LW	%r29, 80(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28474:
BEQ_cont.28472:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28475
	LW	%r2, 6(%r30)
	LW	%r1, 1(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28477
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28478
BEQ_else.28477:
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 72(%r30)
	LWC1	%f2, 68(%r30)
	LWC1	%f3, 66(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 80(%r30)
	ADDI	%r30, %r30, 81
	JAL	is_outside.2939
	ADDI	%r29, %r0, 81
	SUB	%r30, %r30, %r29
	LW	%r29, 80(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28479
	ADDI	%r1, %r0, 2
	LWC1	%f1, 72(%r30)
	LWC1	%f2, 68(%r30)
	LWC1	%f3, 66(%r30)
	LW	%r2, 6(%r30)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 80(%r30)
	ADDI	%r30, %r30, 81
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 81
	SUB	%r30, %r30, %r29
	LW	%r29, 80(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28480
BEQ_else.28479:
	ADDI	%r1, %r0, 0
BEQ_cont.28480:
BEQ_cont.28478:
	J	BEQ_cont.28476
BEQ_else.28475:
	ADDI	%r1, %r0, 0
BEQ_cont.28476:
BEQ_cont.28469:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28481
	LW	%r1, 64(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 6(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28481:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28460:
	ADDI	%r1, %r0, 1
	JR	%r31
shadow_check_one_or_group.2953:
	LW	%r3, 9(%r26)
	LW	%r4, 8(%r26)
	LW	%r5, 7(%r26)
	LW	%r6, 6(%r26)
	LW	%r7, 5(%r26)
	LW	%r8, 4(%r26)
	LW	%r9, 3(%r26)
	LW	%r10, 2(%r26)
	LW	%r11, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r12, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r12, %r27, BEQ_else.28482
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28482:
	ADD	%r29, %r11, %r12
	LW	%r12, 0(%r29)
	LW	%r13, 0(%r12)
	SW	%r26, 0(%r30)
	SW	%r5, 1(%r30)
	SW	%r11, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r13, %r27, BEQ_else.28483
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28484
BEQ_else.28483:
	LW	%r13, 0(%r12)
	SW	%r10, 5(%r30)
	SW	%r9, 6(%r30)
	SW	%r8, 7(%r30)
	SW	%r12, 8(%r30)
	SW	%r13, 9(%r30)
	SW	%r6, 10(%r30)
	SW	%r4, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0
	ADDI	%r1, %r13, 0
	ADDI	%r26, %r3, 0
	ADDI	%r3, %r9, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 11(%r30)
	LWC1	%f1, 0(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28485
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28486
BEQ_else.28485:
	LA	%r29, l.21473
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28487
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28488
BEQ_else.28487:
	ADDI	%r1, %r0, 1
BEQ_cont.28488:
BEQ_cont.28486:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28489
	LW	%r1, 9(%r30)
	LW	%r2, 10(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28491
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28492
BEQ_else.28491:
	ADDI	%r1, %r0, 1
	LW	%r2, 8(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28492:
	J	BEQ_cont.28490
BEQ_else.28489:
	LA	%r29, l.21474
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r1, 7(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 6(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r2)
	ADD.s	%f1, %f1, %f4
	LW	%r2, 8(%r30)
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28493
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28494
BEQ_else.28493:
	LW	%r3, 10(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	SWC1	%f1, 12(%r30)
	SWC1	%f3, 14(%r30)
	SW	%r1, 16(%r30)
	SWC1	%f2, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 16(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 16(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 16(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_form.2729
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28496
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 22(%r30)
	LWC1	%f3, 24(%r30)
	LW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28497
BEQ_else.28496:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28498
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 22(%r30)
	LWC1	%f3, 24(%r30)
	LW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28499
BEQ_else.28498:
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 22(%r30)
	LWC1	%f3, 24(%r30)
	LW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28499:
BEQ_cont.28497:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28500
	LW	%r2, 8(%r30)
	LW	%r1, 1(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28502
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28503
BEQ_else.28502:
	LW	%r3, 10(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 18(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	is_outside.2939
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28504
	ADDI	%r1, %r0, 2
	LWC1	%f1, 18(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 12(%r30)
	LW	%r2, 8(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28505
BEQ_else.28504:
	ADDI	%r1, %r0, 0
BEQ_cont.28505:
BEQ_cont.28503:
	J	BEQ_cont.28501
BEQ_else.28500:
	ADDI	%r1, %r0, 0
BEQ_cont.28501:
BEQ_cont.28494:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28506
	ADDI	%r1, %r0, 1
	LW	%r2, 8(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28507
BEQ_else.28506:
	ADDI	%r1, %r0, 1
BEQ_cont.28507:
BEQ_cont.28490:
BEQ_cont.28484:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28508
	LW	%r1, 4(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28509
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28509:
	LW	%r4, 2(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r26, 1(%r30)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28510
	LW	%r1, 26(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28510:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28508:
	ADDI	%r1, %r0, 1
	JR	%r31
shadow_check_one_or_matrix.2956:
	LW	%r3, 12(%r26)
	LW	%r4, 11(%r26)
	LW	%r5, 10(%r26)
	LW	%r6, 9(%r26)
	LW	%r7, 8(%r26)
	LW	%r8, 7(%r26)
	LW	%r9, 6(%r26)
	LW	%r10, 5(%r26)
	LW	%r11, 4(%r26)
	LW	%r12, 3(%r26)
	LW	%r13, 2(%r26)
	LW	%r14, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r15, 0(%r29)
	LW	%r16, 0(%r15)
	ADDI	%r27, %r0, -1
	BNE	%r16, %r27, BEQ_else.28511
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28511:
	SW	%r9, 0(%r30)
	SW	%r14, 1(%r30)
	SW	%r15, 2(%r30)
	SW	%r26, 3(%r30)
	SW	%r8, 4(%r30)
	SW	%r7, 5(%r30)
	SW	%r12, 6(%r30)
	SW	%r11, 7(%r30)
	SW	%r6, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r16, %r27, BEQ_else.28512
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28513
BEQ_else.28512:
	ADD	%r29, %r10, %r16
	LW	%r10, 0(%r29)
	LWC1	%f1, 0(%r12)
	LW	%r17, 5(%r10)
	LWC1	%f2, 0(%r17)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r12)
	LW	%r17, 5(%r10)
	LWC1	%f3, 1(%r17)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r12)
	LW	%r17, 5(%r10)
	LWC1	%f4, 2(%r17)
	SUB.s	%f3, %f3, %f4
	ADD	%r29, %r13, %r16
	LW	%r13, 0(%r29)
	LW	%r16, 1(%r10)
	ADDI	%r27, %r0, 1
	BNE	%r16, %r27, BEQ_else.28514
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r10, 0
	ADDI	%r26, %r5, 0
	ADDI	%r3, %r13, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28515
BEQ_else.28514:
	ADDI	%r27, %r0, 2
	BNE	%r16, %r27, BEQ_else.28516
	LWC1	%f4, 0(%r13)
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28518
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28519
BEQ_else.28518:
	ADDI	%r3, %r0, 1
BEQ_cont.28519:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28520
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28521
BEQ_else.28520:
	LWC1	%f4, 1(%r13)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r13)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r13)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r7)
	ADDI	%r1, %r0, 1
BEQ_cont.28521:
	J	BEQ_cont.28517
BEQ_else.28516:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r13, 0
	ADDI	%r1, %r10, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28517:
BEQ_cont.28515:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28522
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28523
BEQ_else.28522:
	LW	%r1, 5(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28524
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28525
BEQ_else.28524:
	ADDI	%r2, %r0, 1
BEQ_cont.28525:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28526
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28527
BEQ_else.28526:
	LW	%r2, 2(%r30)
	LW	%r3, 1(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28528
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28529
BEQ_else.28528:
	LW	%r4, 1(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28530
	ADDI	%r1, %r0, 2
	LW	%r2, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28531
BEQ_else.28530:
	ADDI	%r1, %r0, 1
BEQ_cont.28531:
BEQ_cont.28529:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28532
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28533
BEQ_else.28532:
	ADDI	%r1, %r0, 1
BEQ_cont.28533:
BEQ_cont.28527:
BEQ_cont.28523:
BEQ_cont.28513:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28534
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 0(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28535
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28535:
	SW	%r3, 11(%r30)
	SW	%r1, 12(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r4, %r27, BEQ_else.28536
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28537
BEQ_else.28536:
	LW	%r5, 7(%r30)
	LW	%r6, 6(%r30)
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r6, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28538
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28539
BEQ_else.28538:
	LW	%r1, 5(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28540
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28541
BEQ_else.28540:
	ADDI	%r1, %r0, 1
BEQ_cont.28541:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28542
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28543
BEQ_else.28542:
	ADDI	%r1, %r0, 1
	LW	%r2, 11(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28544
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28545
BEQ_else.28544:
	ADDI	%r1, %r0, 1
BEQ_cont.28545:
BEQ_cont.28543:
BEQ_cont.28539:
BEQ_cont.28537:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28546
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28546:
	ADDI	%r1, %r0, 1
	LW	%r2, 11(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28547
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28547:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28534:
	LW	%r1, 2(%r30)
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28548
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28549
BEQ_else.28548:
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28550
	ADDI	%r1, %r0, 2
	LW	%r2, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28551
BEQ_else.28550:
	ADDI	%r1, %r0, 1
BEQ_cont.28551:
BEQ_cont.28549:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28552
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 0(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28553
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.28553:
	SW	%r3, 13(%r30)
	SW	%r1, 14(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r4, %r27, BEQ_else.28554
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28555
BEQ_else.28554:
	LW	%r5, 7(%r30)
	LW	%r6, 6(%r30)
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r6, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28556
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28557
BEQ_else.28556:
	LW	%r1, 5(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28558
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28559
BEQ_else.28558:
	ADDI	%r1, %r0, 1
BEQ_cont.28559:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28560
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28561
BEQ_else.28560:
	ADDI	%r1, %r0, 1
	LW	%r2, 13(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28562
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28563
BEQ_else.28562:
	ADDI	%r1, %r0, 1
BEQ_cont.28563:
BEQ_cont.28561:
BEQ_cont.28557:
BEQ_cont.28555:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28564
	LW	%r1, 14(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28564:
	ADDI	%r1, %r0, 1
	LW	%r2, 13(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28565
	LW	%r1, 14(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28565:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.28552:
	ADDI	%r1, %r0, 1
	JR	%r31
solve_each_element.2959:
	LW	%r4, 10(%r26)
	LW	%r5, 9(%r26)
	LW	%r6, 8(%r26)
	LW	%r7, 7(%r26)
	LW	%r8, 6(%r26)
	LW	%r9, 5(%r26)
	LW	%r10, 4(%r26)
	LW	%r11, 3(%r26)
	LW	%r12, 2(%r26)
	LW	%r13, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r14, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r14, %r27, BEQ_else.28566
	JR	%r31
BEQ_else.28566:
	ADD	%r29, %r9, %r14
	LW	%r15, 0(%r29)
	LWC1	%f1, 0(%r5)
	LW	%r16, 5(%r15)
	LWC1	%f2, 0(%r16)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r5)
	LW	%r16, 5(%r15)
	LWC1	%f3, 1(%r16)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r5)
	LW	%r16, 5(%r15)
	LWC1	%f4, 2(%r16)
	SUB.s	%f3, %f3, %f4
	LW	%r16, 1(%r15)
	SW	%r10, 0(%r30)
	SW	%r12, 1(%r30)
	SW	%r11, 2(%r30)
	SW	%r13, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r8, 6(%r30)
	SW	%r3, 7(%r30)
	SW	%r2, 8(%r30)
	SW	%r26, 9(%r30)
	SW	%r1, 10(%r30)
	SW	%r14, 11(%r30)
	SW	%r9, 12(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r16, %r27, BEQ_else.28568
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r15, 0
	ADDI	%r26, %r7, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28569
BEQ_else.28568:
	ADDI	%r27, %r0, 2
	BNE	%r16, %r27, BEQ_else.28570
	LW	%r6, 4(%r15)
	LWC1	%f4, 0(%r3)
	LWC1	%f5, 0(%r6)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r3)
	LWC1	%f6, 1(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r3)
	LWC1	%f6, 2(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.28572
	ADDI	%r7, %r0, 0
	J	BEQ_cont.28573
BEQ_else.28572:
	ADDI	%r7, %r0, 1
BEQ_cont.28573:
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.28574
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28575
BEQ_else.28574:
	LWC1	%f5, 0(%r6)
	MUL.s	%f1, %f5, %f1
	LWC1	%f5, 1(%r6)
	MUL.s	%f2, %f5, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r6)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	DIV.s	%f1, %f1, %f4
	SWC1	%f1, 0(%r8)
	ADDI	%r1, %r0, 1
BEQ_cont.28575:
	J	BEQ_cont.28571
BEQ_else.28570:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r15, 0
	ADDI	%r26, %r6, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28571:
BEQ_cont.28569:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28576
	LW	%r1, 11(%r30)
	LW	%r2, 12(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28577
	JR	%r31
BEQ_else.28577:
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30)
	LW	%r3, 7(%r30)
	LW	%r26, 9(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28576:
	LW	%r2, 6(%r30)
	LWC1	%f1, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28579
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28580
BEQ_else.28579:
	ADDI	%r2, %r0, 1
BEQ_cont.28580:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28581
	J	BEQ_cont.28582
BEQ_else.28581:
	LW	%r2, 5(%r30)
	LWC1	%f2, 0(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28583
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28584
BEQ_else.28583:
	ADDI	%r3, %r0, 1
BEQ_cont.28584:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28585
	J	BEQ_cont.28586
BEQ_else.28585:
	LA	%r29, l.21474
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r3, 7(%r30)
	LWC1	%f2, 0(%r3)
	MUL.s	%f2, %f2, %f1
	LW	%r4, 4(%r30)
	LWC1	%f3, 0(%r4)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r3)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r4)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r3)
	MUL.s	%f4, %f4, %f1
	LWC1	%f5, 2(%r4)
	ADD.s	%f4, %f4, %f5
	LW	%r4, 8(%r30)
	LW	%r5, 0(%r4)
	SW	%r1, 13(%r30)
	SWC1	%f4, 14(%r30)
	SWC1	%f3, 16(%r30)
	SWC1	%f2, 18(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.28587
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28588
BEQ_else.28587:
	LW	%r6, 12(%r30)
	ADD	%r29, %r6, %r5
	LW	%r5, 0(%r29)
	LW	%r7, 5(%r5)
	LWC1	%f5, 0(%r7)
	SUB.s	%f5, %f2, %f5
	LW	%r7, 5(%r5)
	LWC1	%f6, 1(%r7)
	SUB.s	%f6, %f3, %f6
	LW	%r7, 5(%r5)
	LWC1	%f7, 2(%r7)
	SUB.s	%f7, %f4, %f7
	LW	%r7, 1(%r5)
	ADDI	%r27, %r0, 1
	BNE	%r7, %r27, BEQ_else.28589
	SWC1	%f7, 22(%r30)
	SWC1	%f6, 24(%r30)
	SW	%r5, 26(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	fabs.2616
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	SWC1	%f1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	fless.2607
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28592
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28593
BEQ_else.28592:
	LWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	fabs.2616
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	fless.2607
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28594
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28595
BEQ_else.28594:
	LWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	fabs.2616
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	SWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	fless.2607
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28595:
BEQ_cont.28593:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28596
	LW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28598
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28599
BEQ_else.28598:
	ADDI	%r1, %r0, 0
BEQ_cont.28599:
	J	BEQ_cont.28597
BEQ_else.28596:
	LW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28597:
	J	BEQ_cont.28590
BEQ_else.28589:
	ADDI	%r27, %r0, 2
	BNE	%r7, %r27, BEQ_else.28600
	SW	%r5, 26(%r30)
	SWC1	%f7, 22(%r30)
	SWC1	%f6, 24(%r30)
	SWC1	%f5, 34(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 34(%r30)
	LWC1	%f2, 24(%r30)
	LWC1	%f3, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	SWC1	%f1, 36(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 36(%r30)
	SW	%r1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	JAL	fisneg.2603
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	JAL	xor.2670
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28602
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28603
BEQ_else.28602:
	ADDI	%r1, %r0, 0
BEQ_cont.28603:
	J	BEQ_cont.28601
BEQ_else.28600:
	SW	%r5, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	ADD.s	%f3, %f7, %f0
	ADD.s	%f2, %f6, %f0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	JAL	quadratic.2842
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	SWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	o_form.2729
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.28605
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 40(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.28606
BEQ_else.28605:
	LWC1	%f1, 40(%r30)
BEQ_cont.28606:
	LW	%r1, 26(%r30)
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 42(%r30)
	SW	%r1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 45(%r30)
	ADDI	%r30, %r30, 46
	JAL	fisneg.2603
	ADDI	%r29, %r0, 46
	SUB	%r30, %r30, %r29
	LW	%r29, 45(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 45(%r30)
	ADDI	%r30, %r30, 46
	JAL	xor.2670
	ADDI	%r29, %r0, 46
	SUB	%r30, %r30, %r29
	LW	%r29, 45(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28607
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28608
BEQ_else.28607:
	ADDI	%r1, %r0, 0
BEQ_cont.28608:
BEQ_cont.28601:
BEQ_cont.28590:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28609
	LW	%r2, 8(%r30)
	LW	%r1, 1(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28611
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28612
BEQ_else.28611:
	LW	%r3, 12(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	SW	%r1, 45(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 45(%r30)
	SWC1	%f1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 45(%r30)
	SWC1	%f1, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 45(%r30)
	SWC1	%f1, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	o_form.2729
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28613
	LWC1	%f1, 46(%r30)
	LWC1	%f2, 48(%r30)
	LWC1	%f3, 50(%r30)
	LW	%r1, 45(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28614
BEQ_else.28613:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28615
	LWC1	%f1, 46(%r30)
	LWC1	%f2, 48(%r30)
	LWC1	%f3, 50(%r30)
	LW	%r1, 45(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28616
BEQ_else.28615:
	LWC1	%f1, 46(%r30)
	LWC1	%f2, 48(%r30)
	LWC1	%f3, 50(%r30)
	LW	%r1, 45(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28616:
BEQ_cont.28614:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28617
	LW	%r2, 8(%r30)
	LW	%r1, 2(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28619
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28620
BEQ_else.28619:
	LW	%r3, 12(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 18(%r30)
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	is_outside.2939
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28621
	ADDI	%r1, %r0, 3
	LWC1	%f1, 18(%r30)
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 14(%r30)
	LW	%r2, 8(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28622
BEQ_else.28621:
	ADDI	%r1, %r0, 0
BEQ_cont.28622:
BEQ_cont.28620:
	J	BEQ_cont.28618
BEQ_else.28617:
	ADDI	%r1, %r0, 0
BEQ_cont.28618:
BEQ_cont.28612:
	J	BEQ_cont.28610
BEQ_else.28609:
	ADDI	%r1, %r0, 0
BEQ_cont.28610:
BEQ_cont.28588:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28623
	J	BEQ_cont.28624
BEQ_else.28623:
	LW	%r1, 5(%r30)
	LWC1	%f1, 20(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r1, 2(%r30)
	LWC1	%f1, 18(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 14(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r1, 1(%r30)
	LW	%r2, 11(%r30)
	SW	%r2, 0(%r1)
	LW	%r1, 0(%r30)
	LW	%r2, 13(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.28624:
BEQ_cont.28586:
BEQ_cont.28582:
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30)
	LW	%r3, 7(%r30)
	LW	%r26, 9(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solve_one_or_network.2963:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r6, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r6, %r27, BEQ_else.28625
	JR	%r31
BEQ_else.28625:
	ADD	%r29, %r5, %r6
	LW	%r6, 0(%r29)
	ADDI	%r7, %r0, 0
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r7, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28627
	JR	%r31
BEQ_else.28627:
	LW	%r4, 3(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r6, 1(%r30)
	LW	%r26, 2(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r5, 0
	ADDI	%r3, %r6, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28629
	JR	%r31
BEQ_else.28629:
	LW	%r4, 3(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r6, 1(%r30)
	LW	%r26, 2(%r30)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r5, 0
	ADDI	%r3, %r6, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28631
	JR	%r31
BEQ_else.28631:
	LW	%r4, 3(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 1(%r30)
	LW	%r26, 2(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	LW	%r3, 1(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
trace_or_matrix.2967:
	LW	%r4, 10(%r26)
	LW	%r5, 9(%r26)
	LW	%r6, 8(%r26)
	LW	%r7, 7(%r26)
	LW	%r8, 6(%r26)
	LW	%r9, 5(%r26)
	LW	%r10, 4(%r26)
	LW	%r11, 3(%r26)
	LW	%r12, 2(%r26)
	LW	%r13, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r14, 0(%r29)
	LW	%r15, 0(%r14)
	ADDI	%r27, %r0, -1
	BNE	%r15, %r27, BEQ_else.28633
	JR	%r31
BEQ_else.28633:
	SW	%r26, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r8, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r9, 4(%r30)
	SW	%r10, 5(%r30)
	SW	%r3, 6(%r30)
	SW	%r11, 7(%r30)
	SW	%r13, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r15, %r27, BEQ_else.28635
	LW	%r6, 1(%r14)
	ADDI	%r27, %r0, -1
	BNE	%r6, %r27, BEQ_else.28637
	J	BEQ_cont.28638
BEQ_else.28637:
	ADD	%r29, %r13, %r6
	LW	%r6, 0(%r29)
	ADDI	%r7, %r0, 0
	SW	%r14, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r7, 0
	ADDI	%r26, %r11, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28639
	J	BEQ_cont.28640
BEQ_else.28639:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28641
	J	BEQ_cont.28642
BEQ_else.28641:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r2, 11(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28642:
BEQ_cont.28640:
BEQ_cont.28638:
	J	BEQ_cont.28636
BEQ_else.28635:
	ADD	%r29, %r12, %r15
	LW	%r12, 0(%r29)
	LWC1	%f1, 0(%r5)
	LW	%r15, 5(%r12)
	LWC1	%f2, 0(%r15)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r5)
	LW	%r15, 5(%r12)
	LWC1	%f3, 1(%r15)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r5)
	LW	%r15, 5(%r12)
	LWC1	%f4, 2(%r15)
	SUB.s	%f3, %f3, %f4
	LW	%r15, 1(%r12)
	SW	%r14, 11(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r15, %r27, BEQ_else.28643
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r12, 0
	ADDI	%r26, %r7, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28644
BEQ_else.28643:
	ADDI	%r27, %r0, 2
	BNE	%r15, %r27, BEQ_else.28645
	LW	%r6, 4(%r12)
	LWC1	%f4, 0(%r3)
	LWC1	%f5, 0(%r6)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r3)
	LWC1	%f6, 1(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r3)
	LWC1	%f6, 2(%r6)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.28647
	ADDI	%r7, %r0, 0
	J	BEQ_cont.28648
BEQ_else.28647:
	ADDI	%r7, %r0, 1
BEQ_cont.28648:
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.28649
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28650
BEQ_else.28649:
	LWC1	%f5, 0(%r6)
	MUL.s	%f1, %f5, %f1
	LWC1	%f5, 1(%r6)
	MUL.s	%f2, %f5, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r6)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	DIV.s	%f1, %f1, %f4
	SWC1	%f1, 0(%r8)
	ADDI	%r1, %r0, 1
BEQ_cont.28650:
	J	BEQ_cont.28646
BEQ_else.28645:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r12, 0
	ADDI	%r26, %r6, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28646:
BEQ_cont.28644:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28651
	J	BEQ_cont.28652
BEQ_else.28651:
	LW	%r1, 2(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 1(%r30)
	LWC1	%f2, 0(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28653
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28654
BEQ_else.28653:
	ADDI	%r3, %r0, 1
BEQ_cont.28654:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28655
	J	BEQ_cont.28656
BEQ_else.28655:
	LW	%r3, 11(%r30)
	LW	%r4, 1(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28657
	J	BEQ_cont.28658
BEQ_else.28657:
	LW	%r5, 8(%r30)
	ADD	%r29, %r5, %r4
	LW	%r4, 0(%r29)
	ADDI	%r6, %r0, 0
	LW	%r7, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r7, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28659
	J	BEQ_cont.28660
BEQ_else.28659:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28661
	J	BEQ_cont.28662
BEQ_else.28661:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r2, 11(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28662:
BEQ_cont.28660:
BEQ_cont.28658:
BEQ_cont.28656:
BEQ_cont.28652:
BEQ_cont.28636:
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 0(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28663
	JR	%r31
BEQ_else.28663:
	SW	%r1, 12(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r4, %r27, BEQ_else.28665
	LW	%r4, 1(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28667
	J	BEQ_cont.28668
BEQ_else.28667:
	LW	%r5, 8(%r30)
	ADD	%r29, %r5, %r4
	LW	%r4, 0(%r29)
	ADDI	%r6, %r0, 0
	LW	%r7, 6(%r30)
	LW	%r26, 7(%r30)
	SW	%r3, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r7, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28669
	J	BEQ_cont.28670
BEQ_else.28669:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r4, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r2, 13(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28670:
BEQ_cont.28668:
	J	BEQ_cont.28666
BEQ_else.28665:
	LW	%r5, 6(%r30)
	LW	%r6, 3(%r30)
	LW	%r26, 4(%r30)
	SW	%r3, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r6, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28671
	J	BEQ_cont.28672
BEQ_else.28671:
	LW	%r1, 2(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28673
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28674
BEQ_else.28673:
	ADDI	%r1, %r0, 1
BEQ_cont.28674:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28675
	J	BEQ_cont.28676
BEQ_else.28675:
	LW	%r1, 13(%r30)
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28677
	J	BEQ_cont.28678
BEQ_else.28677:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28679
	J	BEQ_cont.28680
BEQ_else.28679:
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r4, 6(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r2, 13(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28680:
BEQ_cont.28678:
BEQ_cont.28676:
BEQ_cont.28672:
BEQ_cont.28666:
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solve_each_element_fast.2973:
	LW	%r4, 10(%r26)
	LW	%r5, 9(%r26)
	LW	%r6, 8(%r26)
	LW	%r7, 7(%r26)
	LW	%r8, 6(%r26)
	LW	%r9, 5(%r26)
	LW	%r10, 4(%r26)
	LW	%r11, 3(%r26)
	LW	%r12, 2(%r26)
	LW	%r13, 1(%r26)
	LW	%r14, 0(%r3)
	ADD	%r29, %r2, %r1
	LW	%r15, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r15, %r27, BEQ_else.28681
	JR	%r31
BEQ_else.28681:
	ADD	%r29, %r9, %r15
	LW	%r16, 0(%r29)
	LW	%r17, 10(%r16)
	LWC1	%f1, 0(%r17)
	LWC1	%f2, 1(%r17)
	LWC1	%f3, 2(%r17)
	LW	%r18, 1(%r3)
	ADD	%r29, %r18, %r15
	LW	%r18, 0(%r29)
	LW	%r19, 1(%r16)
	SW	%r10, 0(%r30)
	SW	%r12, 1(%r30)
	SW	%r11, 2(%r30)
	SW	%r13, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r14, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r8, 7(%r30)
	SW	%r3, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r26, 10(%r30)
	SW	%r1, 11(%r30)
	SW	%r15, 12(%r30)
	SW	%r9, 13(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r19, %r27, BEQ_else.28683
	LW	%r6, 0(%r3)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r18, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r16, 0
	ADDI	%r26, %r7, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28684
BEQ_else.28683:
	ADDI	%r27, %r0, 2
	BNE	%r19, %r27, BEQ_else.28685
	LWC1	%f1, 0(%r18)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28687
	ADDI	%r6, %r0, 0
	J	BEQ_cont.28688
BEQ_else.28687:
	ADDI	%r6, %r0, 1
BEQ_cont.28688:
	ADDI	%r27, %r0, 0
	BNE	%r6, %r27, BEQ_else.28689
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28690
BEQ_else.28689:
	LWC1	%f1, 0(%r18)
	LWC1	%f2, 3(%r17)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r8)
	ADDI	%r1, %r0, 1
BEQ_cont.28690:
	J	BEQ_cont.28686
BEQ_else.28685:
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r17, 0
	ADDI	%r2, %r18, 0
	ADDI	%r1, %r16, 0
	ADDI	%r26, %r6, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28686:
BEQ_cont.28684:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28691
	LW	%r1, 12(%r30)
	LW	%r2, 13(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28692
	JR	%r31
BEQ_else.28692:
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r3, 8(%r30)
	LW	%r26, 10(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.28691:
	LW	%r2, 7(%r30)
	LWC1	%f1, 0(%r2)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28694
	ADDI	%r2, %r0, 0
	J	BEQ_cont.28695
BEQ_else.28694:
	ADDI	%r2, %r0, 1
BEQ_cont.28695:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28696
	J	BEQ_cont.28697
BEQ_else.28696:
	LW	%r2, 6(%r30)
	LWC1	%f2, 0(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28698
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28699
BEQ_else.28698:
	ADDI	%r3, %r0, 1
BEQ_cont.28699:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28700
	J	BEQ_cont.28701
BEQ_else.28700:
	LA	%r29, l.21474
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r3, 5(%r30)
	LWC1	%f2, 0(%r3)
	MUL.s	%f2, %f2, %f1
	LW	%r4, 4(%r30)
	LWC1	%f3, 0(%r4)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r3)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r4)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r3)
	MUL.s	%f4, %f4, %f1
	LWC1	%f5, 2(%r4)
	ADD.s	%f4, %f4, %f5
	LW	%r3, 9(%r30)
	LW	%r4, 0(%r3)
	SW	%r1, 14(%r30)
	SWC1	%f4, 16(%r30)
	SWC1	%f3, 18(%r30)
	SWC1	%f2, 20(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28703
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28704
BEQ_else.28703:
	LW	%r5, 13(%r30)
	ADD	%r29, %r5, %r4
	LW	%r4, 0(%r29)
	LW	%r6, 5(%r4)
	LWC1	%f5, 0(%r6)
	SUB.s	%f5, %f2, %f5
	LW	%r6, 5(%r4)
	LWC1	%f6, 1(%r6)
	SUB.s	%f6, %f3, %f6
	LW	%r6, 5(%r4)
	LWC1	%f7, 2(%r6)
	SUB.s	%f7, %f4, %f7
	LW	%r6, 1(%r4)
	ADDI	%r27, %r0, 1
	BNE	%r6, %r27, BEQ_else.28705
	SWC1	%f7, 24(%r30)
	SWC1	%f6, 26(%r30)
	SW	%r4, 28(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	fabs.2616
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 28(%r30)
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	fless.2607
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28708
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28709
BEQ_else.28708:
	LWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	fabs.2616
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 28(%r30)
	SWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	fless.2607
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28710
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28711
BEQ_else.28710:
	LWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	fabs.2616
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 28(%r30)
	SWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	fless.2607
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28711:
BEQ_cont.28709:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28712
	LW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28714
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28715
BEQ_else.28714:
	ADDI	%r1, %r0, 0
BEQ_cont.28715:
	J	BEQ_cont.28713
BEQ_else.28712:
	LW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28713:
	J	BEQ_cont.28706
BEQ_else.28705:
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.28716
	SW	%r4, 28(%r30)
	SWC1	%f7, 24(%r30)
	SWC1	%f6, 26(%r30)
	SWC1	%f5, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 36(%r30)
	LWC1	%f2, 26(%r30)
	LWC1	%f3, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 28(%r30)
	SWC1	%f1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 38(%r30)
	SW	%r1, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	fisneg.2603
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	xor.2670
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28718
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28719
BEQ_else.28718:
	ADDI	%r1, %r0, 0
BEQ_cont.28719:
	J	BEQ_cont.28717
BEQ_else.28716:
	SW	%r4, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	ADD.s	%f3, %f7, %f0
	ADD.s	%f2, %f6, %f0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	quadratic.2842
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 28(%r30)
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	o_form.2729
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.28721
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 42(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.28722
BEQ_else.28721:
	LWC1	%f1, 42(%r30)
BEQ_cont.28722:
	LW	%r1, 28(%r30)
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 44(%r30)
	SW	%r1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 47(%r30)
	ADDI	%r30, %r30, 48
	JAL	fisneg.2603
	ADDI	%r29, %r0, 48
	SUB	%r30, %r30, %r29
	LW	%r29, 47(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 47(%r30)
	ADDI	%r30, %r30, 48
	JAL	xor.2670
	ADDI	%r29, %r0, 48
	SUB	%r30, %r30, %r29
	LW	%r29, 47(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28723
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28724
BEQ_else.28723:
	ADDI	%r1, %r0, 0
BEQ_cont.28724:
BEQ_cont.28717:
BEQ_cont.28706:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28725
	LW	%r2, 9(%r30)
	LW	%r1, 1(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28727
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28728
BEQ_else.28727:
	LW	%r3, 13(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	SW	%r1, 47(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 47(%r30)
	SWC1	%f1, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 47(%r30)
	SWC1	%f1, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 47(%r30)
	SWC1	%f1, 52(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	o_form.2729
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.28729
	LWC1	%f1, 48(%r30)
	LWC1	%f2, 50(%r30)
	LWC1	%f3, 52(%r30)
	LW	%r1, 47(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28730
BEQ_else.28729:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.28731
	LWC1	%f1, 48(%r30)
	LWC1	%f2, 50(%r30)
	LWC1	%f3, 52(%r30)
	LW	%r1, 47(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28732
BEQ_else.28731:
	LWC1	%f1, 48(%r30)
	LWC1	%f2, 50(%r30)
	LWC1	%f3, 52(%r30)
	LW	%r1, 47(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28732:
BEQ_cont.28730:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28733
	LW	%r2, 9(%r30)
	LW	%r1, 2(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.28735
	ADDI	%r1, %r0, 1
	J	BEQ_cont.28736
BEQ_else.28735:
	LW	%r3, 13(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 18(%r30)
	LWC1	%f3, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	is_outside.2939
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28737
	ADDI	%r1, %r0, 3
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 18(%r30)
	LWC1	%f3, 16(%r30)
	LW	%r2, 9(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28738
BEQ_else.28737:
	ADDI	%r1, %r0, 0
BEQ_cont.28738:
BEQ_cont.28736:
	J	BEQ_cont.28734
BEQ_else.28733:
	ADDI	%r1, %r0, 0
BEQ_cont.28734:
BEQ_cont.28728:
	J	BEQ_cont.28726
BEQ_else.28725:
	ADDI	%r1, %r0, 0
BEQ_cont.28726:
BEQ_cont.28704:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28739
	J	BEQ_cont.28740
BEQ_else.28739:
	LW	%r1, 6(%r30)
	LWC1	%f1, 22(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r1, 2(%r30)
	LWC1	%f1, 20(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 18(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r1, 1(%r30)
	LW	%r2, 12(%r30)
	SW	%r2, 0(%r1)
	LW	%r1, 0(%r30)
	LW	%r2, 14(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.28740:
BEQ_cont.28701:
BEQ_cont.28697:
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r3, 8(%r30)
	LW	%r26, 10(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solve_one_or_network_fast.2977:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r6, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r6, %r27, BEQ_else.28741
	JR	%r31
BEQ_else.28741:
	ADD	%r29, %r5, %r6
	LW	%r6, 0(%r29)
	ADDI	%r7, %r0, 0
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r7, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28743
	JR	%r31
BEQ_else.28743:
	LW	%r4, 3(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r6, 1(%r30)
	LW	%r26, 2(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r5, 0
	ADDI	%r3, %r6, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28745
	JR	%r31
BEQ_else.28745:
	LW	%r4, 3(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r6, 1(%r30)
	LW	%r26, 2(%r30)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r5, 0
	ADDI	%r3, %r6, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.28747
	JR	%r31
BEQ_else.28747:
	LW	%r4, 3(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 1(%r30)
	LW	%r26, 2(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	LW	%r3, 1(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
trace_or_matrix_fast.2981:
	LW	%r4, 9(%r26)
	LW	%r5, 8(%r26)
	LW	%r6, 7(%r26)
	LW	%r7, 6(%r26)
	LW	%r8, 5(%r26)
	LW	%r9, 4(%r26)
	LW	%r10, 3(%r26)
	LW	%r11, 2(%r26)
	LW	%r12, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r13, 0(%r29)
	LW	%r14, 0(%r13)
	ADDI	%r27, %r0, -1
	BNE	%r14, %r27, BEQ_else.28749
	JR	%r31
BEQ_else.28749:
	SW	%r26, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r8, 2(%r30)
	SW	%r7, 3(%r30)
	SW	%r9, 4(%r30)
	SW	%r3, 5(%r30)
	SW	%r10, 6(%r30)
	SW	%r12, 7(%r30)
	SW	%r2, 8(%r30)
	SW	%r1, 9(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r14, %r27, BEQ_else.28751
	LW	%r5, 1(%r13)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.28753
	J	BEQ_cont.28754
BEQ_else.28753:
	ADD	%r29, %r12, %r5
	LW	%r5, 0(%r29)
	ADDI	%r6, %r0, 0
	SW	%r13, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r6, 0
	ADDI	%r26, %r10, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28755
	J	BEQ_cont.28756
BEQ_else.28755:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28757
	J	BEQ_cont.28758
BEQ_else.28757:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r2, 10(%r30)
	LW	%r3, 5(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28758:
BEQ_cont.28756:
BEQ_cont.28754:
	J	BEQ_cont.28752
BEQ_else.28751:
	ADD	%r29, %r11, %r14
	LW	%r11, 0(%r29)
	LW	%r15, 10(%r11)
	LWC1	%f1, 0(%r15)
	LWC1	%f2, 1(%r15)
	LWC1	%f3, 2(%r15)
	LW	%r16, 1(%r3)
	ADD	%r29, %r16, %r14
	LW	%r14, 0(%r29)
	LW	%r16, 1(%r11)
	SW	%r13, 10(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r16, %r27, BEQ_else.28759
	LW	%r5, 0(%r3)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r14, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r11, 0
	ADDI	%r26, %r6, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28760
BEQ_else.28759:
	ADDI	%r27, %r0, 2
	BNE	%r16, %r27, BEQ_else.28761
	LWC1	%f1, 0(%r14)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28763
	ADDI	%r5, %r0, 0
	J	BEQ_cont.28764
BEQ_else.28763:
	ADDI	%r5, %r0, 1
BEQ_cont.28764:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.28765
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28766
BEQ_else.28765:
	LWC1	%f1, 0(%r14)
	LWC1	%f2, 3(%r15)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r8)
	ADDI	%r1, %r0, 1
BEQ_cont.28766:
	J	BEQ_cont.28762
BEQ_else.28761:
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r15, 0
	ADDI	%r2, %r14, 0
	ADDI	%r1, %r11, 0
	ADDI	%r26, %r5, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28762:
BEQ_cont.28760:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28767
	J	BEQ_cont.28768
BEQ_else.28767:
	LW	%r1, 2(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 1(%r30)
	LWC1	%f2, 0(%r2)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28769
	ADDI	%r3, %r0, 0
	J	BEQ_cont.28770
BEQ_else.28769:
	ADDI	%r3, %r0, 1
BEQ_cont.28770:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28771
	J	BEQ_cont.28772
BEQ_else.28771:
	LW	%r3, 10(%r30)
	LW	%r4, 1(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28773
	J	BEQ_cont.28774
BEQ_else.28773:
	LW	%r5, 7(%r30)
	ADD	%r29, %r5, %r4
	LW	%r4, 0(%r29)
	ADDI	%r6, %r0, 0
	LW	%r7, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r7, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28775
	J	BEQ_cont.28776
BEQ_else.28775:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28777
	J	BEQ_cont.28778
BEQ_else.28777:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r2, 10(%r30)
	LW	%r3, 5(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28778:
BEQ_cont.28776:
BEQ_cont.28774:
BEQ_cont.28772:
BEQ_cont.28768:
BEQ_cont.28752:
	LW	%r1, 9(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 0(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28779
	JR	%r31
BEQ_else.28779:
	SW	%r1, 11(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r4, %r27, BEQ_else.28781
	LW	%r4, 1(%r3)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.28783
	J	BEQ_cont.28784
BEQ_else.28783:
	LW	%r5, 7(%r30)
	ADD	%r29, %r5, %r4
	LW	%r4, 0(%r29)
	ADDI	%r6, %r0, 0
	LW	%r7, 5(%r30)
	LW	%r26, 6(%r30)
	SW	%r3, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r7, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 12(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28785
	J	BEQ_cont.28786
BEQ_else.28785:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r4, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r2, 12(%r30)
	LW	%r3, 5(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28786:
BEQ_cont.28784:
	J	BEQ_cont.28782
BEQ_else.28781:
	LW	%r5, 5(%r30)
	LW	%r26, 3(%r30)
	SW	%r3, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28787
	J	BEQ_cont.28788
BEQ_else.28787:
	LW	%r1, 2(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28789
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28790
BEQ_else.28789:
	ADDI	%r1, %r0, 1
BEQ_cont.28790:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28791
	J	BEQ_cont.28792
BEQ_else.28791:
	LW	%r1, 12(%r30)
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28793
	J	BEQ_cont.28794
BEQ_else.28793:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 12(%r30)
	LW	%r2, 2(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.28795
	J	BEQ_cont.28796
BEQ_else.28795:
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r4, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r2, 12(%r30)
	LW	%r3, 5(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28796:
BEQ_cont.28794:
BEQ_cont.28792:
BEQ_cont.28788:
BEQ_cont.28782:
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30)
	LW	%r3, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
calc_sqrt.6353.16236:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28797
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28798
	J	calc_sqrt.6353.16236
BEQ_else.28798:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28797:
	ADD.s	%f1, %f2, %f0
	JR	%r31
get_nvector_second.2991:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LWC1	%f1, 0(%r3)
	LW	%r4, 5(%r1)
	LWC1	%f2, 0(%r4)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LW	%r4, 5(%r1)
	LWC1	%f3, 1(%r4)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r3)
	LW	%r3, 5(%r1)
	LWC1	%f4, 2(%r3)
	SUB.s	%f3, %f3, %f4
	LW	%r3, 4(%r1)
	LWC1	%f4, 0(%r3)
	MUL.s	%f4, %f1, %f4
	LW	%r3, 4(%r1)
	LWC1	%f5, 1(%r3)
	MUL.s	%f5, %f2, %f5
	LW	%r3, 4(%r1)
	LWC1	%f6, 2(%r3)
	MUL.s	%f6, %f3, %f6
	LW	%r3, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.28799
	SWC1	%f4, 0(%r2)
	SWC1	%f5, 1(%r2)
	SWC1	%f6, 2(%r2)
	J	BEQ_cont.28800
BEQ_else.28799:
	LW	%r3, 9(%r1)
	LWC1	%f7, 2(%r3)
	MUL.s	%f7, %f2, %f7
	LW	%r3, 9(%r1)
	LWC1	%f8, 1(%r3)
	MUL.s	%f8, %f3, %f8
	ADD.s	%f7, %f7, %f8
	LA	%r29, l.20813
	LWC1	%f8, 0(%r29)
	MUL.s	%f7, %f7, %f8
	ADD.s	%f4, %f4, %f7
	SWC1	%f4, 0(%r2)
	LW	%r3, 9(%r1)
	LWC1	%f4, 2(%r3)
	MUL.s	%f4, %f1, %f4
	LW	%r3, 9(%r1)
	LWC1	%f7, 0(%r3)
	MUL.s	%f3, %f3, %f7
	ADD.s	%f3, %f4, %f3
	LA	%r29, l.20813
	LWC1	%f4, 0(%r29)
	MUL.s	%f3, %f3, %f4
	ADD.s	%f3, %f5, %f3
	SWC1	%f3, 1(%r2)
	LW	%r3, 9(%r1)
	LWC1	%f3, 1(%r3)
	MUL.s	%f1, %f1, %f3
	LW	%r3, 9(%r1)
	LWC1	%f3, 0(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20813
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f6, %f1
	SWC1	%f1, 2(%r2)
BEQ_cont.28800:
	LW	%r1, 6(%r1)
	LWC1	%f1, 0(%r2)
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 1(%r2)
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28801
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28803
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28805
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_sqrt.6353.16236
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28806
BEQ_else.28805:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28806:
	J	BEQ_cont.28804
BEQ_else.28803:
BEQ_cont.28804:
	J	BEQ_cont.28802
BEQ_else.28801:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28802:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28807
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28808
BEQ_else.28807:
	ADDI	%r1, %r0, 1
BEQ_cont.28808:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28809
	LW	%r1, 1(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28811
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.28812
BEQ_else.28811:
	LA	%r29, l.20812
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
BEQ_cont.28812:
	J	BEQ_cont.28810
BEQ_else.28809:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.28810:
	LW	%r1, 0(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r1)
	JR	%r31
calc_floor.6420.9035:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28814
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28815
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420.9035
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28817
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28818
BEQ_else.28817:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28818:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28819
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28820
BEQ_else.28819:
BEQ_cont.28820:
	J	BEQ_cont.28816
BEQ_else.28815:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28816:
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28821
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28822
BEQ_else.28821:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28822:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28823
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.28823:
	JR	%r31
BEQ_else.28814:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	JR	%r31
calc_floor.6420.8982:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28824
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28825
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420.8982
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28827
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28828
BEQ_else.28827:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28828:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28829
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28830
BEQ_else.28829:
BEQ_cont.28830:
	J	BEQ_cont.28826
BEQ_else.28825:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28826:
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28831
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28832
BEQ_else.28831:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28832:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28833
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.28833:
	JR	%r31
BEQ_else.28824:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	JR	%r31
calc_sqrt.6353.9002:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28834
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28835
	J	calc_sqrt.6353.9002
BEQ_else.28835:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28834:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.9055:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28836
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28837
	J	calc_sqrt.6353.9055
BEQ_else.28837:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28836:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.9090:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28838
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28839
	J	calc_sqrt.6353.9090
BEQ_else.28839:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28838:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_floor.6420.9125:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28840
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28841
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420.9125
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28843
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28844
BEQ_else.28843:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28844:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28845
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28846
BEQ_else.28845:
BEQ_cont.28846:
	J	BEQ_cont.28842
BEQ_else.28841:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28842:
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28847
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28848
BEQ_else.28847:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28848:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28849
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.28849:
	JR	%r31
BEQ_else.28840:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	JR	%r31
calc_sqrt.6353.9145:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28850
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28851
	J	calc_sqrt.6353.9145
BEQ_else.28851:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.28850:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_floor.6420.9211:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28852
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28853
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420.9211
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28855
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28856
BEQ_else.28855:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28856:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28857
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28858
BEQ_else.28857:
BEQ_cont.28858:
	J	BEQ_cont.28854
BEQ_else.28853:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28854:
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28859
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28860
BEQ_else.28859:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28860:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28861
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.28861:
	JR	%r31
BEQ_else.28852:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	JR	%r31
calc_floor.6420.9181:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28862
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28863
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420.9181
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28865
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28866
BEQ_else.28865:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28866:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28867
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28868
BEQ_else.28867:
BEQ_cont.28868:
	J	BEQ_cont.28864
BEQ_else.28863:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28864:
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28869
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28870
BEQ_else.28869:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28870:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28871
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.28871:
	JR	%r31
BEQ_else.28862:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	JR	%r31
utexture.2996:
	LW	%r3, 1(%r26)
	LW	%r4, 0(%r1)
	LW	%r5, 8(%r1)
	LWC1	%f1, 0(%r5)
	SWC1	%f1, 0(%r3)
	LW	%r5, 8(%r1)
	LWC1	%f1, 1(%r5)
	SWC1	%f1, 1(%r3)
	LW	%r5, 8(%r1)
	LWC1	%f1, 2(%r5)
	SWC1	%f1, 2(%r3)
	ADDI	%r27, %r0, 1
	BNE	%r4, %r27, BEQ_else.28872
	LWC1	%f1, 0(%r2)
	LW	%r4, 5(%r1)
	LWC1	%f2, 0(%r4)
	SUB.s	%f1, %f1, %f2
	LA	%r29, l.21806
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	SWC1	%f1, 4(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28874
	LA	%r29, l.21785
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28876
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.28877
BEQ_else.28876:
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28878
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 6(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	calc_floor.6420.9211
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 6(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28880
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28881
BEQ_else.28880:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28881:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28882
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28883
BEQ_else.28882:
BEQ_cont.28883:
	J	BEQ_cont.28879
BEQ_else.28878:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28879:
BEQ_cont.28877:
	J	BEQ_cont.28875
BEQ_else.28874:
	LA	%r29, l.21784
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28884
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.28885
BEQ_else.28884:
	SUB.s	%f3, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	SWC1	%f2, 6(%r30)
	C.le.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.28886
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	SWC1	%f3, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	calc_floor.6420.9211
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 8(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28888
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.28889
BEQ_else.28888:
	SUB.s	%f4, %f1, %f3
BEQ_cont.28889:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.28890
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28891
BEQ_else.28890:
BEQ_cont.28891:
	J	BEQ_cont.28887
BEQ_else.28886:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28887:
	C.eq.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28892
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.28893
BEQ_else.28892:
	LWC1	%f1, 6(%r30)
BEQ_cont.28893:
BEQ_cont.28885:
BEQ_cont.28875:
	LA	%r29, l.21807
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.21797
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28894
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28895
BEQ_else.28894:
	ADDI	%r1, %r0, 1
BEQ_cont.28895:
	LW	%r2, 2(%r30)
	LWC1	%f1, 2(%r2)
	LW	%r2, 1(%r30)
	LW	%r2, 5(%r2)
	LWC1	%f2, 2(%r2)
	SUB.s	%f1, %f1, %f2
	LA	%r29, l.21806
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r1, 10(%r30)
	SWC1	%f1, 12(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28897
	LA	%r29, l.21785
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28899
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.28900
BEQ_else.28899:
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28901
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 14(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	calc_floor.6420.9181
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 14(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28903
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.28904
BEQ_else.28903:
	SUB.s	%f3, %f1, %f3
BEQ_cont.28904:
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28905
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28906
BEQ_else.28905:
BEQ_cont.28906:
	J	BEQ_cont.28902
BEQ_else.28901:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28902:
BEQ_cont.28900:
	J	BEQ_cont.28898
BEQ_else.28897:
	LA	%r29, l.21784
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28907
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.28908
BEQ_else.28907:
	SUB.s	%f3, %f0, %f2
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	SWC1	%f2, 14(%r30)
	C.le.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.28909
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	SWC1	%f3, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	calc_floor.6420.9181
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 16(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28911
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.28912
BEQ_else.28911:
	SUB.s	%f4, %f1, %f3
BEQ_cont.28912:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.28913
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28914
BEQ_else.28913:
BEQ_cont.28914:
	J	BEQ_cont.28910
BEQ_else.28909:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28910:
	C.eq.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28915
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.28916
BEQ_else.28915:
	LWC1	%f1, 14(%r30)
BEQ_cont.28916:
BEQ_cont.28908:
BEQ_cont.28898:
	LA	%r29, l.21807
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.21797
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28917
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28918
BEQ_else.28917:
	ADDI	%r1, %r0, 1
BEQ_cont.28918:
	LW	%r2, 10(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.28919
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28921
	LA	%r29, l.21790
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.28922
BEQ_else.28921:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28922:
	J	BEQ_cont.28920
BEQ_else.28919:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28923
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.28924
BEQ_else.28923:
	LA	%r29, l.21790
	LWC1	%f1, 0(%r29)
BEQ_cont.28924:
BEQ_cont.28920:
	LW	%r1, 0(%r30)
	SWC1	%f1, 1(%r1)
	JR	%r31
BEQ_else.28872:
	ADDI	%r27, %r0, 2
	BNE	%r4, %r27, BEQ_else.28926
	LWC1	%f1, 1(%r2)
	LA	%r29, l.21801
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28927
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28928
BEQ_else.28927:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.28928:
	MUL.s	%f1, %f1, %f1
	LA	%r29, l.21790
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	LW	%r1, 0(%r30)
	SWC1	%f2, 0(%r1)
	LA	%r29, l.21790
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SUB.s	%f1, %f3, %f1
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 1(%r1)
	JR	%r31
BEQ_else.28926:
	ADDI	%r27, %r0, 3
	BNE	%r4, %r27, BEQ_else.28930
	LWC1	%f1, 0(%r2)
	LW	%r4, 5(%r1)
	LWC1	%f2, 0(%r4)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r2)
	LW	%r1, 5(%r1)
	LWC1	%f3, 2(%r1)
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f1
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28931
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28933
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.28935
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	calc_sqrt.6353.9145
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28936
BEQ_else.28935:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28936:
	J	BEQ_cont.28934
BEQ_else.28933:
BEQ_cont.28934:
	J	BEQ_cont.28932
BEQ_else.28931:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28932:
	LA	%r29, l.21797
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 18(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28937
	LA	%r29, l.21785
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28939
	J	BEQ_cont.28940
BEQ_else.28939:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28941
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	calc_floor.6420.9125
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 18(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28943
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.28944
BEQ_else.28943:
	SUB.s	%f4, %f1, %f3
BEQ_cont.28944:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.28945
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28946
BEQ_else.28945:
BEQ_cont.28946:
	J	BEQ_cont.28942
BEQ_else.28941:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28942:
BEQ_cont.28940:
	J	BEQ_cont.28938
BEQ_else.28937:
	LA	%r29, l.21784
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28947
	J	BEQ_cont.28948
BEQ_else.28947:
	SUB.s	%f2, %f0, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f2, 20(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28949
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	calc_floor.6420.9125
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 20(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28951
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.28952
BEQ_else.28951:
	SUB.s	%f4, %f1, %f3
BEQ_cont.28952:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.28953
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28954
BEQ_else.28953:
BEQ_cont.28954:
	J	BEQ_cont.28950
BEQ_else.28949:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28950:
	LWC1	%f2, 20(%r30)
	C.eq.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28955
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.28956
BEQ_else.28955:
	LWC1	%f1, 18(%r30)
BEQ_cont.28956:
BEQ_cont.28948:
BEQ_cont.28938:
	LWC1	%f2, 18(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.21783
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28957
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28958
BEQ_else.28957:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.28958:
	MUL.s	%f1, %f1, %f1
	LA	%r29, l.21790
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f2, 1(%r1)
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.21790
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.28930:
	ADDI	%r27, %r0, 4
	BNE	%r4, %r27, BEQ_else.28960
	LWC1	%f1, 0(%r2)
	LW	%r4, 5(%r1)
	LWC1	%f2, 0(%r4)
	SUB.s	%f1, %f1, %f2
	LW	%r4, 4(%r1)
	LWC1	%f2, 0(%r4)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	SWC1	%f1, 22(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28961
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28963
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.28965
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	calc_sqrt.6353.9090
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28966
BEQ_else.28965:
	ADD.s	%f1, %f3, %f0
BEQ_cont.28966:
	J	BEQ_cont.28964
BEQ_else.28963:
	ADD.s	%f1, %f2, %f0
BEQ_cont.28964:
	J	BEQ_cont.28962
BEQ_else.28961:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28962:
	LWC1	%f2, 22(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r2, 1(%r30)
	LW	%r3, 5(%r2)
	LWC1	%f3, 2(%r3)
	SUB.s	%f2, %f2, %f3
	LW	%r3, 4(%r2)
	LWC1	%f3, 2(%r3)
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	SWC1	%f1, 24(%r30)
	SWC1	%f2, 26(%r30)
	C.le.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.28967
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.28969
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.28971
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	calc_sqrt.6353.9055
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.28972
BEQ_else.28971:
	ADD.s	%f1, %f4, %f0
BEQ_cont.28972:
	J	BEQ_cont.28970
BEQ_else.28969:
	ADD.s	%f1, %f3, %f0
BEQ_cont.28970:
	J	BEQ_cont.28968
BEQ_else.28967:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28968:
	LWC1	%f2, 26(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 24(%r30)
	MUL.s	%f3, %f2, %f2
	MUL.s	%f4, %f1, %f1
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f2, %f4
	BNE	%r27, %r0, BEQ_else.28973
	ADD.s	%f4, %f2, %f0
	J	BEQ_cont.28974
BEQ_else.28973:
	SUB.s	%f4, %f0, %f2
BEQ_cont.28974:
	LA	%r29, l.21780
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.28975
	ADDI	%r1, %r0, 0
	J	BEQ_cont.28976
BEQ_else.28975:
	ADDI	%r1, %r0, 1
BEQ_cont.28976:
	SWC1	%f3, 28(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.28977
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28979
	J	BEQ_cont.28980
BEQ_else.28979:
	SUB.s	%f1, %f0, %f1
BEQ_cont.28980:
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	atan.2634
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.21782
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.21783
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.28978
BEQ_else.28977:
	LA	%r29, l.21781
	LWC1	%f1, 0(%r29)
BEQ_cont.28978:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 30(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28981
	LA	%r29, l.21785
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28983
	J	BEQ_cont.28984
BEQ_else.28983:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.28985
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	calc_floor.6420.9035
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 30(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28987
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.28988
BEQ_else.28987:
	SUB.s	%f4, %f1, %f3
BEQ_cont.28988:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.28989
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28990
BEQ_else.28989:
BEQ_cont.28990:
	J	BEQ_cont.28986
BEQ_else.28985:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28986:
BEQ_cont.28984:
	J	BEQ_cont.28982
BEQ_else.28981:
	LA	%r29, l.21784
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28991
	J	BEQ_cont.28992
BEQ_else.28991:
	SUB.s	%f2, %f0, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f2, 32(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.28993
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	calc_floor.6420.9035
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 32(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.28995
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.28996
BEQ_else.28995:
	SUB.s	%f4, %f1, %f3
BEQ_cont.28996:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.28997
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.28998
BEQ_else.28997:
BEQ_cont.28998:
	J	BEQ_cont.28994
BEQ_else.28993:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.28994:
	LWC1	%f2, 32(%r30)
	C.eq.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.28999
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.29000
BEQ_else.28999:
	LWC1	%f1, 30(%r30)
BEQ_cont.29000:
BEQ_cont.28992:
BEQ_cont.28982:
	LWC1	%f2, 30(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r1, 1(%r30)
	LW	%r2, 5(%r1)
	LWC1	%f3, 1(%r2)
	SUB.s	%f2, %f2, %f3
	LW	%r1, 4(%r1)
	LWC1	%f3, 1(%r1)
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	SWC1	%f1, 34(%r30)
	SWC1	%f2, 36(%r30)
	C.le.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.29001
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.29003
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.29005
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	calc_sqrt.6353.9002
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29006
BEQ_else.29005:
	ADD.s	%f1, %f4, %f0
BEQ_cont.29006:
	J	BEQ_cont.29004
BEQ_else.29003:
	ADD.s	%f1, %f3, %f0
BEQ_cont.29004:
	J	BEQ_cont.29002
BEQ_else.29001:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29002:
	LWC1	%f2, 36(%r30)
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 28(%r30)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29007
	ADD.s	%f2, %f3, %f0
	J	BEQ_cont.29008
BEQ_else.29007:
	SUB.s	%f2, %f0, %f3
BEQ_cont.29008:
	LA	%r29, l.21780
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f2, %f4
	BNE	%r27, %r0, BEQ_else.29009
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29010
BEQ_else.29009:
	ADDI	%r1, %r0, 1
BEQ_cont.29010:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29011
	DIV.s	%f1, %f1, %f3
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29013
	J	BEQ_cont.29014
BEQ_else.29013:
	SUB.s	%f1, %f0, %f1
BEQ_cont.29014:
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	atan.2634
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.21782
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.21783
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.29012
BEQ_else.29011:
	LA	%r29, l.21781
	LWC1	%f1, 0(%r29)
BEQ_cont.29012:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 38(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29015
	LA	%r29, l.21785
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29017
	J	BEQ_cont.29018
BEQ_else.29017:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29019
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	calc_floor.6420.8982
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 38(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.29021
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.29022
BEQ_else.29021:
	SUB.s	%f4, %f1, %f3
BEQ_cont.29022:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.29023
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.29024
BEQ_else.29023:
BEQ_cont.29024:
	J	BEQ_cont.29020
BEQ_else.29019:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29020:
BEQ_cont.29018:
	J	BEQ_cont.29016
BEQ_else.29015:
	LA	%r29, l.21784
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29025
	J	BEQ_cont.29026
BEQ_else.29025:
	SUB.s	%f2, %f0, %f1
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	SWC1	%f2, 40(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29027
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	calc_floor.6420.8982
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 40(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.29029
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.29030
BEQ_else.29029:
	SUB.s	%f4, %f1, %f3
BEQ_cont.29030:
	C.le.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.29031
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.29032
BEQ_else.29031:
BEQ_cont.29032:
	J	BEQ_cont.29028
BEQ_else.29027:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29028:
	LWC1	%f2, 40(%r30)
	C.eq.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29033
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.29034
BEQ_else.29033:
	LWC1	%f1, 38(%r30)
BEQ_cont.29034:
BEQ_cont.29026:
BEQ_cont.29016:
	LWC1	%f2, 38(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.21789
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20813
	LWC1	%f3, 0(%r29)
	LWC1	%f4, 34(%r30)
	SUB.s	%f3, %f3, %f4
	MUL.s	%f3, %f3, %f3
	SUB.s	%f2, %f2, %f3
	LA	%r29, l.20813
	LWC1	%f3, 0(%r29)
	SUB.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f1
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29035
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29036
BEQ_else.29035:
	ADDI	%r1, %r0, 1
BEQ_cont.29036:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29037
	J	BEQ_cont.29038
BEQ_else.29037:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29038:
	LA	%r29, l.21790
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.21791
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.28960:
	JR	%r31
trace_reflections.3003:
	LW	%r3, 17(%r26)
	LW	%r4, 16(%r26)
	LW	%r5, 15(%r26)
	LW	%r6, 14(%r26)
	LW	%r7, 13(%r26)
	LW	%r8, 12(%r26)
	LW	%r9, 11(%r26)
	LW	%r10, 10(%r26)
	LW	%r11, 9(%r26)
	LW	%r12, 8(%r26)
	LW	%r13, 7(%r26)
	LW	%r14, 6(%r26)
	LW	%r15, 5(%r26)
	LW	%r16, 4(%r26)
	LW	%r17, 3(%r26)
	LW	%r18, 2(%r26)
	LW	%r19, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29041
	ADD	%r29, %r13, %r1
	LW	%r20, 0(%r29)
	LW	%r21, 1(%r20)
	LA	%r29, l.21812
	LWC1	%f3, 0(%r29)
	SWC1	%f3, 0(%r4)
	ADDI	%r22, %r0, 0
	LW	%r23, 0(%r14)
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r6, 2(%r30)
	SW	%r9, 3(%r30)
	SW	%r13, 4(%r30)
	SW	%r1, 5(%r30)
	SWC1	%f2, 6(%r30)
	SW	%r5, 8(%r30)
	SW	%r12, 9(%r30)
	SW	%r2, 10(%r30)
	SWC1	%f1, 12(%r30)
	SW	%r15, 14(%r30)
	SW	%r21, 15(%r30)
	SW	%r10, 16(%r30)
	SW	%r11, 17(%r30)
	SW	%r8, 18(%r30)
	SW	%r18, 19(%r30)
	SW	%r16, 20(%r30)
	SW	%r7, 21(%r30)
	SW	%r14, 22(%r30)
	SW	%r20, 23(%r30)
	SW	%r17, 24(%r30)
	SW	%r19, 25(%r30)
	SW	%r4, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r23, 0
	ADDI	%r1, %r22, 0
	ADDI	%r26, %r3, 0
	ADDI	%r3, %r21, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29043
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29044
BEQ_else.29043:
	ADDI	%r2, %r0, 1
BEQ_cont.29044:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29045
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29046
BEQ_else.29045:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29047
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29048
BEQ_else.29047:
	ADDI	%r2, %r0, 1
BEQ_cont.29048:
BEQ_cont.29046:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29049
	J	BEQ_cont.29050
BEQ_else.29049:
	LW	%r2, 25(%r30)
	LW	%r3, 0(%r2)
	SLL	%r3, %r3, 2
	LW	%r4, 24(%r30)
	LW	%r5, 0(%r4)
	ADD	%r3, %r3, %r5
	LW	%r5, 23(%r30)
	LW	%r6, 0(%r5)
	BNE	%r3, %r6, BEQ_else.29051
	LW	%r3, 22(%r30)
	LW	%r6, 0(%r3)
	LW	%r7, 0(%r6)
	LW	%r8, 0(%r7)
	ADDI	%r27, %r0, -1
	BNE	%r8, %r27, BEQ_else.29053
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29054
BEQ_else.29053:
	SW	%r7, 27(%r30)
	SW	%r6, 28(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r8, %r27, BEQ_else.29055
	ADDI	%r1, %r0, 1
	J	BEQ_cont.29056
BEQ_else.29055:
	LW	%r9, 20(%r30)
	LW	%r10, 19(%r30)
	LW	%r26, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r10, 0
	ADDI	%r2, %r9, 0
	ADDI	%r1, %r8, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29057
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29058
BEQ_else.29057:
	LW	%r1, 18(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29059
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29060
BEQ_else.29059:
	ADDI	%r2, %r0, 1
BEQ_cont.29060:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29061
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29062
BEQ_else.29061:
	ADDI	%r2, %r0, 1
	LW	%r3, 27(%r30)
	LW	%r26, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29063
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29064
BEQ_else.29063:
	ADDI	%r1, %r0, 1
BEQ_cont.29064:
BEQ_cont.29062:
BEQ_cont.29058:
BEQ_cont.29056:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29065
	ADDI	%r1, %r0, 1
	LW	%r2, 28(%r30)
	LW	%r26, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29066
BEQ_else.29065:
	ADDI	%r1, %r0, 1
	LW	%r2, 27(%r30)
	LW	%r26, 17(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29067
	ADDI	%r1, %r0, 1
	LW	%r2, 28(%r30)
	LW	%r26, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29068
BEQ_else.29067:
	ADDI	%r1, %r0, 1
BEQ_cont.29068:
BEQ_cont.29066:
BEQ_cont.29054:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29069
	LW	%r1, 15(%r30)
	LW	%r2, 0(%r1)
	LW	%r3, 14(%r30)
	LWC1	%f1, 0(%r3)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r2, 23(%r30)
	LWC1	%f2, 2(%r2)
	LWC1	%f3, 12(%r30)
	MUL.s	%f4, %f2, %f3
	MUL.s	%f1, %f4, %f1
	LW	%r1, 0(%r1)
	LW	%r2, 10(%r30)
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 0(%r1)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 1(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r2)
	LWC1	%f6, 2(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f2, %f2, %f4
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f4, %f1
	BNE	%r27, %r0, BEQ_else.29071
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29072
BEQ_else.29071:
	ADDI	%r1, %r0, 1
BEQ_cont.29072:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29073
	J	BEQ_cont.29074
BEQ_else.29073:
	LW	%r1, 9(%r30)
	LWC1	%f4, 0(%r1)
	LW	%r4, 8(%r30)
	LWC1	%f5, 0(%r4)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 0(%r1)
	LWC1	%f4, 1(%r1)
	LWC1	%f5, 1(%r4)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 1(%r1)
	LWC1	%f4, 2(%r1)
	LWC1	%f5, 2(%r4)
	MUL.s	%f1, %f1, %f5
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r1)
BEQ_cont.29074:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29075
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29076
BEQ_else.29075:
	ADDI	%r1, %r0, 1
BEQ_cont.29076:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29077
	J	BEQ_cont.29078
BEQ_else.29077:
	MUL.s	%f1, %f2, %f2
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 9(%r30)
	LWC1	%f4, 0(%r1)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 0(%r1)
	LWC1	%f4, 1(%r1)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 1(%r1)
	LWC1	%f4, 2(%r1)
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r1)
BEQ_cont.29078:
	J	BEQ_cont.29070
BEQ_else.29069:
BEQ_cont.29070:
	J	BEQ_cont.29052
BEQ_else.29051:
BEQ_cont.29052:
BEQ_cont.29050:
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29079
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r2)
	LA	%r29, l.21812
	LWC1	%f1, 0(%r29)
	LW	%r4, 26(%r30)
	SWC1	%f1, 0(%r4)
	LW	%r5, 22(%r30)
	LW	%r6, 0(%r5)
	LW	%r7, 0(%r6)
	LW	%r8, 0(%r7)
	SW	%r1, 29(%r30)
	SW	%r3, 30(%r30)
	SW	%r2, 31(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r8, %r27, BEQ_else.29080
	J	BEQ_cont.29081
BEQ_else.29080:
	SW	%r6, 32(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r8, %r27, BEQ_else.29082
	ADDI	%r8, %r0, 1
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0
	ADDI	%r1, %r8, 0
	SW	%r29, 33(%r30)
	ADDI	%r30, %r30, 34
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29083
BEQ_else.29082:
	LW	%r26, 2(%r30)
	SW	%r7, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r8, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29084
	J	BEQ_cont.29085
BEQ_else.29084:
	LW	%r1, 18(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 26(%r30)
	LWC1	%f2, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	fless.2607
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29086
	J	BEQ_cont.29087
BEQ_else.29086:
	ADDI	%r1, %r0, 1
	LW	%r2, 33(%r30)
	LW	%r3, 30(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29087:
BEQ_cont.29085:
BEQ_cont.29083:
	ADDI	%r1, %r0, 1
	LW	%r2, 32(%r30)
	LW	%r3, 30(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29081:
	LW	%r1, 26(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29088
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29089
BEQ_else.29088:
	ADDI	%r1, %r0, 1
BEQ_cont.29089:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29090
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29091
BEQ_else.29090:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29092
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29093
BEQ_else.29092:
	ADDI	%r1, %r0, 1
BEQ_cont.29093:
BEQ_cont.29091:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29094
	J	BEQ_cont.29095
BEQ_else.29094:
	LW	%r1, 25(%r30)
	LW	%r1, 0(%r1)
	SLL	%r1, %r1, 2
	LW	%r2, 24(%r30)
	LW	%r2, 0(%r2)
	ADD	%r1, %r1, %r2
	LW	%r2, 31(%r30)
	LW	%r3, 0(%r2)
	BNE	%r1, %r3, BEQ_else.29096
	ADDI	%r1, %r0, 0
	LW	%r3, 22(%r30)
	LW	%r3, 0(%r3)
	LW	%r26, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29098
	LW	%r1, 30(%r30)
	LW	%r2, 0(%r1)
	LW	%r3, 14(%r30)
	LWC1	%f1, 0(%r3)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r2, 31(%r30)
	LWC1	%f2, 2(%r2)
	LWC1	%f3, 12(%r30)
	MUL.s	%f4, %f2, %f3
	MUL.s	%f1, %f4, %f1
	LW	%r1, 0(%r1)
	LW	%r2, 10(%r30)
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 0(%r1)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 1(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r2)
	LWC1	%f6, 2(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f2, %f2, %f4
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f4, %f1
	BNE	%r27, %r0, BEQ_else.29100
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29101
BEQ_else.29100:
	ADDI	%r1, %r0, 1
BEQ_cont.29101:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29102
	J	BEQ_cont.29103
BEQ_else.29102:
	LW	%r1, 9(%r30)
	LWC1	%f4, 0(%r1)
	LW	%r3, 8(%r30)
	LWC1	%f5, 0(%r3)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 0(%r1)
	LWC1	%f4, 1(%r1)
	LWC1	%f5, 1(%r3)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 1(%r1)
	LWC1	%f4, 2(%r1)
	LWC1	%f5, 2(%r3)
	MUL.s	%f1, %f1, %f5
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r1)
BEQ_cont.29103:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29104
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29105
BEQ_else.29104:
	ADDI	%r1, %r0, 1
BEQ_cont.29105:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29106
	J	BEQ_cont.29107
BEQ_else.29106:
	MUL.s	%f1, %f2, %f2
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 9(%r30)
	LWC1	%f4, 0(%r1)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 0(%r1)
	LWC1	%f4, 1(%r1)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 1(%r1)
	LWC1	%f4, 2(%r1)
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r1)
BEQ_cont.29107:
	J	BEQ_cont.29099
BEQ_else.29098:
BEQ_cont.29099:
	J	BEQ_cont.29097
BEQ_else.29096:
BEQ_cont.29097:
BEQ_cont.29095:
	LW	%r1, 29(%r30)
	ADDI	%r1, %r1, -1
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 6(%r30)
	LW	%r2, 10(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29079:
	JR	%r31
BEQ_else.29041:
	JR	%r31
trace_ray.3008:
	LW	%r4, 29(%r26)
	LW	%r5, 28(%r26)
	LW	%r6, 27(%r26)
	LW	%r7, 26(%r26)
	LW	%r8, 25(%r26)
	LW	%r9, 24(%r26)
	LW	%r10, 23(%r26)
	LW	%r11, 22(%r26)
	LW	%r12, 21(%r26)
	LW	%r13, 20(%r26)
	LW	%r14, 19(%r26)
	LW	%r15, 18(%r26)
	LW	%r16, 17(%r26)
	LW	%r17, 16(%r26)
	LW	%r18, 15(%r26)
	LW	%r19, 14(%r26)
	LW	%r20, 13(%r26)
	LW	%r21, 12(%r26)
	LW	%r22, 11(%r26)
	LW	%r23, 10(%r26)
	LW	%r24, 9(%r26)
	LW	%r25, 8(%r26)
	SW	%r5, 0(%r30)
	LW	%r5, 7(%r26)
	SW	%r6, 1(%r30)
	LW	%r6, 6(%r26)
	SW	%r12, 2(%r30)
	LW	%r12, 5(%r26)
	SW	%r15, 3(%r30)
	LW	%r15, 4(%r26)
	SW	%r20, 4(%r30)
	LW	%r20, 3(%r26)
	SW	%r24, 5(%r30)
	LW	%r24, 2(%r26)
	SW	%r26, 6(%r30)
	LW	%r26, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29110
	SW	%r18, 7(%r30)
	LW	%r18, 2(%r3)
	LA	%r29, l.21812
	LWC1	%f3, 0(%r29)
	SWC1	%f3, 0(%r8)
	SW	%r25, 8(%r30)
	ADDI	%r25, %r0, 0
	SW	%r10, 9(%r30)
	LW	%r10, 0(%r21)
	SWC1	%f2, 10(%r30)
	SW	%r16, 12(%r30)
	SW	%r17, 13(%r30)
	SW	%r14, 14(%r30)
	SW	%r5, 15(%r30)
	SW	%r13, 16(%r30)
	SW	%r21, 17(%r30)
	SW	%r9, 18(%r30)
	SW	%r3, 19(%r30)
	SW	%r4, 20(%r30)
	SW	%r11, 21(%r30)
	SW	%r15, 22(%r30)
	SW	%r24, 23(%r30)
	SW	%r23, 24(%r30)
	SW	%r12, 25(%r30)
	SW	%r22, 26(%r30)
	SW	%r20, 27(%r30)
	SW	%r19, 28(%r30)
	SW	%r26, 29(%r30)
	SWC1	%f1, 30(%r30)
	SW	%r6, 32(%r30)
	SW	%r2, 33(%r30)
	SW	%r1, 34(%r30)
	SW	%r18, 35(%r30)
	SW	%r8, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r2, 0
	ADDI	%r1, %r25, 0
	ADDI	%r26, %r7, 0
	ADDI	%r2, %r10, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 36(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29111
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29112
BEQ_else.29111:
	ADDI	%r2, %r0, 1
BEQ_cont.29112:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29113
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29114
BEQ_else.29113:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29115
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29116
BEQ_else.29115:
	ADDI	%r2, %r0, 1
BEQ_cont.29116:
BEQ_cont.29114:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29117
	ADDI	%r1, %r0, -1
	LW	%r2, 34(%r30)
	LW	%r3, 35(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29118
	JR	%r31
BEQ_else.29118:
	LW	%r1, 33(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 32(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29120
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29121
BEQ_else.29120:
	ADDI	%r1, %r0, 1
BEQ_cont.29121:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29122
	JR	%r31
BEQ_else.29122:
	MUL.s	%f2, %f1, %f1
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 30(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 29(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 28(%r30)
	LWC1	%f2, 0(%r1)
	ADD.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r1)
	LWC1	%f2, 1(%r1)
	ADD.s	%f2, %f2, %f1
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r1)
	ADD.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.29117:
	LW	%r2, 27(%r30)
	LW	%r3, 0(%r2)
	LW	%r4, 26(%r30)
	ADD	%r29, %r4, %r3
	LW	%r4, 0(%r29)
	LW	%r5, 2(%r4)
	LW	%r6, 7(%r4)
	LWC1	%f1, 0(%r6)
	LWC1	%f2, 30(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r6, 1(%r4)
	SW	%r5, 37(%r30)
	SWC1	%f1, 38(%r30)
	SW	%r3, 40(%r30)
	SW	%r4, 41(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r6, %r27, BEQ_else.29125
	LW	%r6, 25(%r30)
	LW	%r7, 0(%r6)
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	LW	%r8, 24(%r30)
	SW	%r7, 42(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r8, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 43(%r30)
	ADDI	%r30, %r30, 44
	JAL	vecfill.2686
	ADDI	%r29, %r0, 44
	SUB	%r30, %r30, %r29
	LW	%r29, 43(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 42(%r30)
	ADDI	%r2, %r1, -1
	ADDI	%r1, %r1, -1
	LW	%r3, 33(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f1, 0(%r29)
	SW	%r2, 43(%r30)
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	fiszero.2599
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29127
	LWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	fispos.2601
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29129
	LA	%r29, l.20812
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.29130
BEQ_else.29129:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.29130:
	J	BEQ_cont.29128
BEQ_else.29127:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29128:
	SUB.s	%f1, %f0, %f1
	LW	%r1, 43(%r30)
	LW	%r2, 24(%r30)
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	J	BEQ_cont.29126
BEQ_else.29125:
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.29131
	LW	%r6, 4(%r4)
	LWC1	%f3, 0(%r6)
	SUB.s	%f3, %f0, %f3
	LW	%r6, 24(%r30)
	SWC1	%f3, 0(%r6)
	LW	%r7, 4(%r4)
	LWC1	%f3, 1(%r7)
	SUB.s	%f3, %f0, %f3
	SWC1	%f3, 1(%r6)
	LW	%r7, 4(%r4)
	LWC1	%f3, 2(%r7)
	SUB.s	%f3, %f0, %f3
	SWC1	%f3, 2(%r6)
	J	BEQ_cont.29132
BEQ_else.29131:
	LW	%r26, 23(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29132:
BEQ_cont.29126:
	LW	%r2, 22(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r1, 21(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r2)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r2)
	SWC1	%f1, 2(%r1)
	LW	%r1, 41(%r30)
	LW	%r26, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 40(%r30)
	SLL	%r1, %r1, 2
	LW	%r2, 25(%r30)
	LW	%r3, 0(%r2)
	ADD	%r1, %r1, %r3
	LW	%r3, 34(%r30)
	LW	%r4, 35(%r30)
	ADD	%r29, %r4, %r3
	SW	%r1, 0(%r29)
	LW	%r1, 19(%r30)
	LW	%r5, 1(%r1)
	ADD	%r29, %r5, %r3
	LW	%r5, 0(%r29)
	LW	%r6, 22(%r30)
	LWC1	%f1, 0(%r6)
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r6)
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r6)
	SWC1	%f1, 2(%r5)
	LW	%r5, 3(%r1)
	LW	%r7, 41(%r30)
	LW	%r8, 7(%r7)
	LWC1	%f1, 0(%r8)
	LA	%r29, l.20813
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29133
	ADDI	%r8, %r0, 0
	J	BEQ_cont.29134
BEQ_else.29133:
	ADDI	%r8, %r0, 1
BEQ_cont.29134:
	ADDI	%r27, %r0, 0
	BNE	%r8, %r27, BEQ_else.29135
	ADDI	%r8, %r0, 1
	ADD	%r29, %r5, %r3
	SW	%r8, 0(%r29)
	LW	%r5, 4(%r1)
	ADD	%r29, %r5, %r3
	LW	%r8, 0(%r29)
	LW	%r9, 18(%r30)
	LWC1	%f1, 0(%r9)
	SWC1	%f1, 0(%r8)
	LWC1	%f1, 1(%r9)
	SWC1	%f1, 1(%r8)
	LWC1	%f1, 2(%r9)
	SWC1	%f1, 2(%r8)
	ADD	%r29, %r5, %r3
	LW	%r5, 0(%r29)
	LA	%r29, l.21929
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 38(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 0(%r5)
	MUL.s	%f3, %f3, %f1
	SWC1	%f3, 0(%r5)
	LWC1	%f3, 1(%r5)
	MUL.s	%f3, %f3, %f1
	SWC1	%f3, 1(%r5)
	LWC1	%f3, 2(%r5)
	MUL.s	%f1, %f3, %f1
	SWC1	%f1, 2(%r5)
	LW	%r5, 7(%r1)
	ADD	%r29, %r5, %r3
	LW	%r5, 0(%r29)
	LW	%r8, 24(%r30)
	LWC1	%f1, 0(%r8)
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r8)
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r8)
	SWC1	%f1, 2(%r5)
	J	BEQ_cont.29136
BEQ_else.29135:
	ADDI	%r8, %r0, 0
	ADD	%r29, %r5, %r3
	SW	%r8, 0(%r29)
BEQ_cont.29136:
	LA	%r29, l.21943
	LWC1	%f1, 0(%r29)
	LW	%r5, 33(%r30)
	LWC1	%f2, 0(%r5)
	LW	%r8, 24(%r30)
	LWC1	%f3, 0(%r8)
	MUL.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r5)
	LWC1	%f4, 1(%r8)
	MUL.s	%f3, %f3, %f4
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r5)
	LWC1	%f4, 2(%r8)
	MUL.s	%f3, %f3, %f4
	ADD.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 0(%r5)
	LWC1	%f3, 0(%r8)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 0(%r5)
	LWC1	%f2, 1(%r5)
	LWC1	%f3, 1(%r8)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 1(%r5)
	LWC1	%f2, 2(%r5)
	LWC1	%f3, 2(%r8)
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r5)
	LW	%r9, 7(%r7)
	LWC1	%f1, 1(%r9)
	LWC1	%f2, 30(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r9, 17(%r30)
	LW	%r10, 0(%r9)
	LW	%r11, 0(%r10)
	LW	%r12, 0(%r11)
	SWC1	%f1, 46(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r12, %r27, BEQ_else.29137
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29138
BEQ_else.29137:
	SW	%r11, 48(%r30)
	SW	%r10, 49(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r12, %r27, BEQ_else.29139
	ADDI	%r1, %r0, 1
	J	BEQ_cont.29140
BEQ_else.29139:
	LW	%r13, 15(%r30)
	LW	%r26, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r6, 0
	ADDI	%r2, %r13, 0
	ADDI	%r1, %r12, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29141
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29142
BEQ_else.29141:
	LW	%r1, 14(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29143
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29144
BEQ_else.29143:
	ADDI	%r2, %r0, 1
BEQ_cont.29144:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29145
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29146
BEQ_else.29145:
	ADDI	%r2, %r0, 1
	LW	%r3, 48(%r30)
	LW	%r26, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29147
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29148
BEQ_else.29147:
	ADDI	%r1, %r0, 1
BEQ_cont.29148:
BEQ_cont.29146:
BEQ_cont.29142:
BEQ_cont.29140:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29149
	ADDI	%r1, %r0, 1
	LW	%r2, 49(%r30)
	LW	%r26, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29150
BEQ_else.29149:
	ADDI	%r1, %r0, 1
	LW	%r2, 48(%r30)
	LW	%r26, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29151
	ADDI	%r1, %r0, 1
	LW	%r2, 49(%r30)
	LW	%r26, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29152
BEQ_else.29151:
	ADDI	%r1, %r0, 1
BEQ_cont.29152:
BEQ_cont.29150:
BEQ_cont.29138:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29153
	LW	%r1, 24(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 32(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	LWC1	%f2, 38(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r3, 33(%r30)
	LWC1	%f3, 0(%r3)
	LWC1	%f4, 0(%r2)
	MUL.s	%f3, %f3, %f4
	LWC1	%f4, 1(%r3)
	LWC1	%f5, 1(%r2)
	MUL.s	%f4, %f4, %f5
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r3)
	LWC1	%f5, 2(%r2)
	MUL.s	%f4, %f4, %f5
	ADD.s	%f3, %f3, %f4
	SUB.s	%f3, %f0, %f3
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f4, %f1
	BNE	%r27, %r0, BEQ_else.29155
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29156
BEQ_else.29155:
	ADDI	%r2, %r0, 1
BEQ_cont.29156:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29157
	J	BEQ_cont.29158
BEQ_else.29157:
	LW	%r2, 28(%r30)
	LWC1	%f4, 0(%r2)
	LW	%r4, 18(%r30)
	LWC1	%f5, 0(%r4)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 0(%r2)
	LWC1	%f4, 1(%r2)
	LWC1	%f5, 1(%r4)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 1(%r2)
	LWC1	%f4, 2(%r2)
	LWC1	%f5, 2(%r4)
	MUL.s	%f1, %f1, %f5
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r2)
BEQ_cont.29158:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.29159
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29160
BEQ_else.29159:
	ADDI	%r2, %r0, 1
BEQ_cont.29160:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29161
	J	BEQ_cont.29162
BEQ_else.29161:
	MUL.s	%f1, %f3, %f3
	MUL.s	%f1, %f1, %f1
	LWC1	%f3, 46(%r30)
	MUL.s	%f1, %f1, %f3
	LW	%r2, 28(%r30)
	LWC1	%f4, 0(%r2)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 0(%r2)
	LWC1	%f4, 1(%r2)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 1(%r2)
	LWC1	%f4, 2(%r2)
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r2)
BEQ_cont.29162:
	J	BEQ_cont.29154
BEQ_else.29153:
BEQ_cont.29154:
	LW	%r1, 22(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 9(%r30)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 2(%r2)
	LW	%r2, 8(%r30)
	LW	%r2, 0(%r2)
	ADDI	%r2, %r2, -1
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29163
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r2)
	LA	%r29, l.21812
	LWC1	%f1, 0(%r29)
	LW	%r4, 36(%r30)
	SWC1	%f1, 0(%r4)
	LW	%r5, 17(%r30)
	LW	%r6, 0(%r5)
	LW	%r7, 0(%r6)
	LW	%r8, 0(%r7)
	SW	%r1, 50(%r30)
	SW	%r3, 51(%r30)
	SW	%r2, 52(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r8, %r27, BEQ_else.29165
	J	BEQ_cont.29166
BEQ_else.29165:
	SW	%r6, 53(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r8, %r27, BEQ_else.29167
	ADDI	%r8, %r0, 1
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0
	ADDI	%r1, %r8, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29168
BEQ_else.29167:
	LW	%r26, 2(%r30)
	SW	%r7, 54(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r8, 0
	SW	%r29, 55(%r30)
	ADDI	%r30, %r30, 56
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 56
	SUB	%r30, %r30, %r29
	LW	%r29, 55(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29169
	J	BEQ_cont.29170
BEQ_else.29169:
	LW	%r1, 14(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 36(%r30)
	LWC1	%f2, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 55(%r30)
	ADDI	%r30, %r30, 56
	JAL	fless.2607
	ADDI	%r29, %r0, 56
	SUB	%r30, %r30, %r29
	LW	%r29, 55(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29171
	J	BEQ_cont.29172
BEQ_else.29171:
	ADDI	%r1, %r0, 1
	LW	%r2, 54(%r30)
	LW	%r3, 51(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 55(%r30)
	ADDI	%r30, %r30, 56
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 56
	SUB	%r30, %r30, %r29
	LW	%r29, 55(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29172:
BEQ_cont.29170:
BEQ_cont.29168:
	ADDI	%r1, %r0, 1
	LW	%r2, 53(%r30)
	LW	%r3, 51(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 55(%r30)
	ADDI	%r30, %r30, 56
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 56
	SUB	%r30, %r30, %r29
	LW	%r29, 55(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29166:
	LW	%r1, 36(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29173
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29174
BEQ_else.29173:
	ADDI	%r2, %r0, 1
BEQ_cont.29174:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29175
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29176
BEQ_else.29175:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29177
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29178
BEQ_else.29177:
	ADDI	%r2, %r0, 1
BEQ_cont.29178:
BEQ_cont.29176:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29179
	J	BEQ_cont.29180
BEQ_else.29179:
	LW	%r2, 27(%r30)
	LW	%r2, 0(%r2)
	SLL	%r2, %r2, 2
	LW	%r3, 25(%r30)
	LW	%r3, 0(%r3)
	ADD	%r2, %r2, %r3
	LW	%r3, 52(%r30)
	LW	%r4, 0(%r3)
	BNE	%r2, %r4, BEQ_else.29181
	ADDI	%r2, %r0, 0
	LW	%r4, 17(%r30)
	LW	%r4, 0(%r4)
	LW	%r26, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 55(%r30)
	ADDI	%r30, %r30, 56
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 56
	SUB	%r30, %r30, %r29
	LW	%r29, 55(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29183
	LW	%r1, 51(%r30)
	LW	%r2, 0(%r1)
	LW	%r3, 24(%r30)
	LWC1	%f1, 0(%r3)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r3)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r2, 52(%r30)
	LWC1	%f2, 2(%r2)
	LWC1	%f3, 38(%r30)
	MUL.s	%f4, %f2, %f3
	MUL.s	%f1, %f4, %f1
	LW	%r1, 0(%r1)
	LW	%r2, 33(%r30)
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 0(%r1)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 1(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	LWC1	%f5, 2(%r2)
	LWC1	%f6, 2(%r1)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f4, %f4, %f5
	MUL.s	%f2, %f2, %f4
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.le.s	%r27, %f4, %f1
	BNE	%r27, %r0, BEQ_else.29185
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29186
BEQ_else.29185:
	ADDI	%r1, %r0, 1
BEQ_cont.29186:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29187
	J	BEQ_cont.29188
BEQ_else.29187:
	LW	%r1, 28(%r30)
	LWC1	%f4, 0(%r1)
	LW	%r3, 18(%r30)
	LWC1	%f5, 0(%r3)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 0(%r1)
	LWC1	%f4, 1(%r1)
	LWC1	%f5, 1(%r3)
	MUL.s	%f5, %f1, %f5
	ADD.s	%f4, %f4, %f5
	SWC1	%f4, 1(%r1)
	LWC1	%f4, 2(%r1)
	LWC1	%f5, 2(%r3)
	MUL.s	%f1, %f1, %f5
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r1)
BEQ_cont.29188:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29189
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29190
BEQ_else.29189:
	ADDI	%r1, %r0, 1
BEQ_cont.29190:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29191
	J	BEQ_cont.29192
BEQ_else.29191:
	MUL.s	%f1, %f2, %f2
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 46(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 28(%r30)
	LWC1	%f4, 0(%r1)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 0(%r1)
	LWC1	%f4, 1(%r1)
	ADD.s	%f4, %f4, %f1
	SWC1	%f4, 1(%r1)
	LWC1	%f4, 2(%r1)
	ADD.s	%f1, %f4, %f1
	SWC1	%f1, 2(%r1)
BEQ_cont.29192:
	J	BEQ_cont.29184
BEQ_else.29183:
BEQ_cont.29184:
	J	BEQ_cont.29182
BEQ_else.29181:
BEQ_cont.29182:
BEQ_cont.29180:
	LW	%r1, 50(%r30)
	ADDI	%r1, %r1, -1
	LWC1	%f1, 38(%r30)
	LWC1	%f2, 46(%r30)
	LW	%r2, 33(%r30)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 55(%r30)
	ADDI	%r30, %r30, 56
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 56
	SUB	%r30, %r30, %r29
	LW	%r29, 55(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29164
BEQ_else.29163:
BEQ_cont.29164:
	LA	%r29, l.22037
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 30(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29193
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29194
BEQ_else.29193:
	ADDI	%r1, %r0, 1
BEQ_cont.29194:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29195
	JR	%r31
BEQ_else.29195:
	LW	%r1, 34(%r30)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29197
	J	BEQ_cont.29198
BEQ_else.29197:
	ADDI	%r2, %r1, 1
	ADDI	%r3, %r0, -1
	LW	%r4, 35(%r30)
	ADD	%r29, %r4, %r2
	SW	%r3, 0(%r29)
BEQ_cont.29198:
	LW	%r2, 37(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.29199
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LW	%r2, 41(%r30)
	LW	%r2, 7(%r2)
	LWC1	%f3, 0(%r2)
	SUB.s	%f1, %f1, %f3
	MUL.s	%f1, %f2, %f1
	ADDI	%r1, %r1, 1
	LW	%r2, 36(%r30)
	LWC1	%f2, 0(%r2)
	LWC1	%f3, 10(%r30)
	ADD.s	%f2, %f3, %f2
	LW	%r2, 33(%r30)
	LW	%r3, 19(%r30)
	LW	%r26, 6(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29199:
	JR	%r31
BEQ_else.29110:
	JR	%r31
trace_diffuse_ray.3014:
	LW	%r2, 18(%r26)
	LW	%r3, 17(%r26)
	LW	%r4, 16(%r26)
	LW	%r5, 15(%r26)
	LW	%r6, 14(%r26)
	LW	%r7, 13(%r26)
	LW	%r8, 12(%r26)
	LW	%r9, 11(%r26)
	LW	%r10, 10(%r26)
	LW	%r11, 9(%r26)
	LW	%r12, 8(%r26)
	LW	%r13, 7(%r26)
	LW	%r14, 6(%r26)
	LW	%r15, 5(%r26)
	LW	%r16, 4(%r26)
	LW	%r17, 3(%r26)
	LW	%r18, 2(%r26)
	LW	%r19, 1(%r26)
	LA	%r29, l.21812
	LWC1	%f2, 0(%r29)
	SWC1	%f2, 0(%r4)
	ADDI	%r20, %r0, 0
	LW	%r21, 0(%r10)
	SW	%r5, 0(%r30)
	SW	%r19, 1(%r30)
	SWC1	%f1, 2(%r30)
	SW	%r14, 4(%r30)
	SW	%r8, 5(%r30)
	SW	%r9, 6(%r30)
	SW	%r7, 7(%r30)
	SW	%r13, 8(%r30)
	SW	%r6, 9(%r30)
	SW	%r10, 10(%r30)
	SW	%r16, 11(%r30)
	SW	%r2, 12(%r30)
	SW	%r18, 13(%r30)
	SW	%r12, 14(%r30)
	SW	%r15, 15(%r30)
	SW	%r1, 16(%r30)
	SW	%r11, 17(%r30)
	SW	%r17, 18(%r30)
	SW	%r4, 19(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r21, 0
	ADDI	%r26, %r3, 0
	ADDI	%r3, %r1, 0
	ADDI	%r1, %r20, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 19(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29202
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29203
BEQ_else.29202:
	ADDI	%r1, %r0, 1
BEQ_cont.29203:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29204
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29205
BEQ_else.29204:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29206
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29207
BEQ_else.29206:
	ADDI	%r1, %r0, 1
BEQ_cont.29207:
BEQ_cont.29205:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29208
	JR	%r31
BEQ_else.29208:
	LW	%r1, 18(%r30)
	LW	%r1, 0(%r1)
	LW	%r2, 17(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 16(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 1(%r1)
	SW	%r1, 20(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r3, %r27, BEQ_else.29210
	LW	%r3, 15(%r30)
	LW	%r3, 0(%r3)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LW	%r4, 14(%r30)
	SW	%r2, 21(%r30)
	SW	%r3, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	vecfill.2686
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 22(%r30)
	ADDI	%r2, %r1, -1
	ADDI	%r1, %r1, -1
	LW	%r3, 21(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f1, 0(%r29)
	SW	%r2, 23(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	fiszero.2599
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29212
	LWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	fispos.2601
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29214
	LA	%r29, l.20812
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.29215
BEQ_else.29214:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.29215:
	J	BEQ_cont.29213
BEQ_else.29212:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29213:
	SUB.s	%f1, %f0, %f1
	LW	%r1, 23(%r30)
	LW	%r2, 14(%r30)
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	J	BEQ_cont.29211
BEQ_else.29210:
	ADDI	%r27, %r0, 2
	BNE	%r3, %r27, BEQ_else.29216
	LW	%r2, 4(%r1)
	LWC1	%f1, 0(%r2)
	SUB.s	%f1, %f0, %f1
	LW	%r2, 14(%r30)
	SWC1	%f1, 0(%r2)
	LW	%r3, 4(%r1)
	LWC1	%f1, 1(%r3)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 1(%r2)
	LW	%r3, 4(%r1)
	LWC1	%f1, 2(%r3)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 2(%r2)
	J	BEQ_cont.29217
BEQ_else.29216:
	LW	%r26, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29217:
BEQ_cont.29211:
	LW	%r1, 20(%r30)
	LW	%r2, 11(%r30)
	LW	%r26, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	LW	%r2, 0(%r1)
	LW	%r1, 0(%r2)
	LW	%r3, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.29218
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29219
BEQ_else.29218:
	SW	%r1, 26(%r30)
	SW	%r2, 27(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r3, %r27, BEQ_else.29220
	ADDI	%r1, %r0, 1
	J	BEQ_cont.29221
BEQ_else.29220:
	LW	%r4, 8(%r30)
	LW	%r5, 11(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29222
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29223
BEQ_else.29222:
	LW	%r1, 7(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29224
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29225
BEQ_else.29224:
	ADDI	%r1, %r0, 1
BEQ_cont.29225:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29226
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29227
BEQ_else.29226:
	ADDI	%r1, %r0, 1
	LW	%r2, 26(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29228
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29229
BEQ_else.29228:
	ADDI	%r1, %r0, 1
BEQ_cont.29229:
BEQ_cont.29227:
BEQ_cont.29223:
BEQ_cont.29221:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29230
	ADDI	%r1, %r0, 1
	LW	%r2, 27(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29231
BEQ_else.29230:
	ADDI	%r1, %r0, 1
	LW	%r2, 26(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29232
	ADDI	%r1, %r0, 1
	LW	%r2, 27(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29233
BEQ_else.29232:
	ADDI	%r1, %r0, 1
BEQ_cont.29233:
BEQ_cont.29231:
BEQ_cont.29219:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29234
	LW	%r1, 14(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 4(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29235
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29236
BEQ_else.29235:
	ADDI	%r1, %r0, 1
BEQ_cont.29236:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29237
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.29238
BEQ_else.29237:
BEQ_cont.29238:
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 20(%r30)
	LW	%r1, 7(%r1)
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	LW	%r2, 0(%r30)
	LWC1	%f3, 0(%r2)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 0(%r1)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.29234:
	JR	%r31
iter_trace_diffuse_rays.3017:
	LW	%r5, 18(%r26)
	LW	%r6, 17(%r26)
	LW	%r7, 16(%r26)
	LW	%r8, 15(%r26)
	LW	%r9, 14(%r26)
	LW	%r10, 13(%r26)
	LW	%r11, 12(%r26)
	LW	%r12, 11(%r26)
	LW	%r13, 10(%r26)
	LW	%r14, 9(%r26)
	LW	%r15, 8(%r26)
	LW	%r16, 7(%r26)
	LW	%r17, 6(%r26)
	LW	%r18, 5(%r26)
	LW	%r19, 4(%r26)
	LW	%r20, 3(%r26)
	LW	%r21, 2(%r26)
	LW	%r22, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.29241
	ADD	%r29, %r1, %r4
	LW	%r23, 0(%r29)
	LW	%r23, 0(%r23)
	LWC1	%f1, 0(%r23)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r23)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r23)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29242
	ADDI	%r23, %r0, 0
	J	BEQ_cont.29243
BEQ_else.29242:
	ADDI	%r23, %r0, 1
BEQ_cont.29243:
	SW	%r3, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r7, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r1, 4(%r30)
	SW	%r4, 5(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r23, %r27, BEQ_else.29244
	ADD	%r29, %r1, %r4
	LW	%r23, 0(%r29)
	LA	%r29, l.22131
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.21812
	LWC1	%f2, 0(%r29)
	SWC1	%f2, 0(%r8)
	LW	%r24, 0(%r14)
	LW	%r25, 0(%r24)
	LW	%r3, 0(%r25)
	SW	%r9, 6(%r30)
	SW	%r22, 7(%r30)
	SWC1	%f1, 8(%r30)
	SW	%r17, 10(%r30)
	SW	%r13, 11(%r30)
	SW	%r14, 12(%r30)
	SW	%r19, 13(%r30)
	SW	%r5, 14(%r30)
	SW	%r21, 15(%r30)
	SW	%r16, 16(%r30)
	SW	%r18, 17(%r30)
	SW	%r23, 18(%r30)
	SW	%r15, 19(%r30)
	SW	%r20, 20(%r30)
	SW	%r8, 21(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.29246
	J	BEQ_cont.29247
BEQ_else.29246:
	SW	%r24, 22(%r30)
	SW	%r6, 23(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r3, %r27, BEQ_else.29248
	ADDI	%r3, %r0, 1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r25, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r12, 0
	ADDI	%r3, %r23, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29249
BEQ_else.29248:
	SW	%r25, 24(%r30)
	SW	%r12, 25(%r30)
	SW	%r11, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r23, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r10, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29250
	J	BEQ_cont.29251
BEQ_else.29250:
	LW	%r1, 26(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 21(%r30)
	LWC1	%f2, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	fless.2607
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29252
	J	BEQ_cont.29253
BEQ_else.29252:
	ADDI	%r1, %r0, 1
	LW	%r2, 24(%r30)
	LW	%r3, 18(%r30)
	LW	%r26, 25(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29253:
BEQ_cont.29251:
BEQ_cont.29249:
	ADDI	%r1, %r0, 1
	LW	%r2, 22(%r30)
	LW	%r3, 18(%r30)
	LW	%r26, 23(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29247:
	LW	%r1, 21(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29254
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29255
BEQ_else.29254:
	ADDI	%r1, %r0, 1
BEQ_cont.29255:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29256
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29257
BEQ_else.29256:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29258
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29259
BEQ_else.29258:
	ADDI	%r1, %r0, 1
BEQ_cont.29259:
BEQ_cont.29257:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29260
	J	BEQ_cont.29261
BEQ_else.29260:
	LW	%r1, 20(%r30)
	LW	%r1, 0(%r1)
	LW	%r2, 19(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 18(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 1(%r1)
	SW	%r1, 27(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r3, %r27, BEQ_else.29262
	LW	%r3, 17(%r30)
	LW	%r3, 0(%r3)
	LW	%r4, 16(%r30)
	SW	%r2, 28(%r30)
	SW	%r3, 29(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	vecbzero.2689
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 29(%r30)
	ADDI	%r2, %r1, -1
	ADDI	%r1, %r1, -1
	LW	%r3, 28(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f1, 0(%r29)
	SW	%r2, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	sgn.2673
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	fneg.2605
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 30(%r30)
	LW	%r2, 16(%r30)
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	J	BEQ_cont.29263
BEQ_else.29262:
	ADDI	%r27, %r0, 2
	BNE	%r3, %r27, BEQ_else.29264
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	fneg.2605
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	fneg.2605
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	fneg.2605
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.29265
BEQ_else.29264:
	LW	%r26, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29265:
BEQ_cont.29263:
	LW	%r1, 27(%r30)
	LW	%r2, 13(%r30)
	LW	%r26, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	LW	%r2, 12(%r30)
	LW	%r2, 0(%r2)
	LW	%r26, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29266
	LW	%r1, 16(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 10(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29268
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29269
BEQ_else.29268:
	ADDI	%r1, %r0, 1
BEQ_cont.29269:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29270
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.29271
BEQ_else.29270:
BEQ_cont.29271:
	LWC1	%f2, 8(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 27(%r30)
	LW	%r1, 7(%r1)
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 7(%r30)
	LWC1	%f2, 0(%r1)
	LW	%r2, 6(%r30)
	LWC1	%f3, 0(%r2)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 0(%r1)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.29267
BEQ_else.29266:
BEQ_cont.29267:
BEQ_cont.29261:
	J	BEQ_cont.29245
BEQ_else.29244:
	ADDI	%r23, %r4, 1
	ADD	%r29, %r1, %r23
	LW	%r23, 0(%r29)
	LA	%r29, l.22097
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.21812
	LWC1	%f2, 0(%r29)
	SWC1	%f2, 0(%r8)
	LW	%r24, 0(%r14)
	LW	%r25, 0(%r24)
	LW	%r3, 0(%r25)
	SW	%r9, 6(%r30)
	SW	%r22, 7(%r30)
	SWC1	%f1, 32(%r30)
	SW	%r17, 10(%r30)
	SW	%r13, 11(%r30)
	SW	%r14, 12(%r30)
	SW	%r19, 13(%r30)
	SW	%r5, 14(%r30)
	SW	%r21, 15(%r30)
	SW	%r16, 16(%r30)
	SW	%r18, 17(%r30)
	SW	%r23, 34(%r30)
	SW	%r15, 19(%r30)
	SW	%r20, 20(%r30)
	SW	%r8, 21(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.29273
	J	BEQ_cont.29274
BEQ_else.29273:
	SW	%r24, 35(%r30)
	SW	%r6, 23(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r3, %r27, BEQ_else.29275
	ADDI	%r3, %r0, 1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r25, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r12, 0
	ADDI	%r3, %r23, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29276
BEQ_else.29275:
	SW	%r25, 36(%r30)
	SW	%r12, 25(%r30)
	SW	%r11, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r23, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r10, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29277
	J	BEQ_cont.29278
BEQ_else.29277:
	LW	%r1, 26(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 21(%r30)
	LWC1	%f2, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	fless.2607
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29279
	J	BEQ_cont.29280
BEQ_else.29279:
	ADDI	%r1, %r0, 1
	LW	%r2, 36(%r30)
	LW	%r3, 34(%r30)
	LW	%r26, 25(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29280:
BEQ_cont.29278:
BEQ_cont.29276:
	ADDI	%r1, %r0, 1
	LW	%r2, 35(%r30)
	LW	%r3, 34(%r30)
	LW	%r26, 23(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29274:
	LW	%r1, 21(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.21553
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29281
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29282
BEQ_else.29281:
	ADDI	%r1, %r0, 1
BEQ_cont.29282:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29283
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29284
BEQ_else.29283:
	LA	%r29, l.21816
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29285
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29286
BEQ_else.29285:
	ADDI	%r1, %r0, 1
BEQ_cont.29286:
BEQ_cont.29284:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29287
	J	BEQ_cont.29288
BEQ_else.29287:
	LW	%r1, 20(%r30)
	LW	%r1, 0(%r1)
	LW	%r2, 19(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 34(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 1(%r1)
	SW	%r1, 37(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r3, %r27, BEQ_else.29289
	LW	%r3, 17(%r30)
	LW	%r3, 0(%r3)
	LW	%r4, 16(%r30)
	SW	%r2, 38(%r30)
	SW	%r3, 39(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	vecbzero.2689
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 39(%r30)
	ADDI	%r2, %r1, -1
	ADDI	%r1, %r1, -1
	LW	%r3, 38(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f1, 0(%r29)
	SW	%r2, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	sgn.2673
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	fneg.2605
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 40(%r30)
	LW	%r2, 16(%r30)
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	J	BEQ_cont.29290
BEQ_else.29289:
	ADDI	%r27, %r0, 2
	BNE	%r3, %r27, BEQ_else.29291
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	fneg.2605
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 37(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	fneg.2605
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 37(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	fneg.2605
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.29292
BEQ_else.29291:
	LW	%r26, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29292:
BEQ_cont.29290:
	LW	%r1, 37(%r30)
	LW	%r2, 13(%r30)
	LW	%r26, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	LW	%r2, 12(%r30)
	LW	%r2, 0(%r2)
	LW	%r26, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29293
	LW	%r1, 16(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 10(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29295
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29296
BEQ_else.29295:
	ADDI	%r1, %r0, 1
BEQ_cont.29296:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29297
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.29298
BEQ_else.29297:
BEQ_cont.29298:
	LWC1	%f2, 32(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 37(%r30)
	LW	%r1, 7(%r1)
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 7(%r30)
	LWC1	%f2, 0(%r1)
	LW	%r2, 6(%r30)
	LWC1	%f3, 0(%r2)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 0(%r1)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r2)
	MUL.s	%f3, %f1, %f3
	ADD.s	%f2, %f2, %f3
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r2)
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.29294
BEQ_else.29293:
BEQ_cont.29294:
BEQ_cont.29288:
BEQ_cont.29245:
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29299
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	LWC1	%f1, 0(%r3)
	LW	%r4, 3(%r30)
	LWC1	%f2, 0(%r4)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LWC1	%f3, 1(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r3)
	LWC1	%f3, 2(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29300
	ADDI	%r3, %r0, 0
	J	BEQ_cont.29301
BEQ_else.29300:
	ADDI	%r3, %r0, 1
BEQ_cont.29301:
	SW	%r1, 41(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29302
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LA	%r29, l.22131
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29303
BEQ_else.29302:
	ADDI	%r3, %r1, 1
	ADD	%r29, %r2, %r3
	LW	%r3, 0(%r29)
	LA	%r29, l.22097
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29303:
	LW	%r1, 41(%r30)
	ADDI	%r4, %r1, -2
	LW	%r1, 4(%r30)
	LW	%r2, 3(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29299:
	JR	%r31
BEQ_else.29241:
	JR	%r31
trace_diffuse_ray_80percent.3026:
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	SW	%r2, 0(%r30)
	SW	%r5, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r4, 3(%r30)
	SW	%r6, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29306
	J	BEQ_cont.29307
BEQ_else.29306:
	LW	%r7, 0(%r6)
	SW	%r7, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 6(%r30)
	LW	%r2, 0(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29307:
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.29308
	J	BEQ_cont.29309
BEQ_else.29308:
	LW	%r2, 4(%r30)
	LW	%r3, 1(%r2)
	LW	%r4, 2(%r30)
	LW	%r26, 3(%r30)
	SW	%r3, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 7(%r30)
	LW	%r2, 0(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29309:
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.29310
	J	BEQ_cont.29311
BEQ_else.29310:
	LW	%r2, 4(%r30)
	LW	%r3, 2(%r2)
	LW	%r4, 2(%r30)
	LW	%r26, 3(%r30)
	SW	%r3, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 8(%r30)
	LW	%r2, 0(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29311:
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.29312
	J	BEQ_cont.29313
BEQ_else.29312:
	LW	%r2, 4(%r30)
	LW	%r3, 3(%r2)
	LW	%r4, 2(%r30)
	LW	%r26, 3(%r30)
	SW	%r3, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 9(%r30)
	LW	%r2, 0(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29313:
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 4
	BNE	%r1, %r27, BEQ_else.29314
	JR	%r31
BEQ_else.29314:
	LW	%r1, 4(%r30)
	LW	%r1, 4(%r1)
	LW	%r2, 2(%r30)
	LW	%r26, 3(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 10(%r30)
	LW	%r2, 0(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
calc_diffuse_using_1point.3030:
	LW	%r3, 8(%r26)
	LW	%r4, 7(%r26)
	LW	%r5, 6(%r26)
	LW	%r6, 5(%r26)
	LW	%r7, 4(%r26)
	LW	%r8, 3(%r26)
	LW	%r9, 2(%r26)
	LW	%r10, 1(%r26)
	LW	%r11, 5(%r1)
	LW	%r12, 7(%r1)
	LW	%r13, 1(%r1)
	LW	%r14, 4(%r1)
	ADD	%r29, %r11, %r2
	LW	%r11, 0(%r29)
	LWC1	%f1, 0(%r11)
	SWC1	%f1, 0(%r10)
	LWC1	%f1, 1(%r11)
	SWC1	%f1, 1(%r10)
	LWC1	%f1, 2(%r11)
	SWC1	%f1, 2(%r10)
	LW	%r1, 6(%r1)
	LW	%r1, 0(%r1)
	ADD	%r29, %r12, %r2
	LW	%r11, 0(%r29)
	ADD	%r29, %r13, %r2
	LW	%r12, 0(%r29)
	SW	%r10, 0(%r30)
	SW	%r6, 1(%r30)
	SW	%r2, 2(%r30)
	SW	%r14, 3(%r30)
	SW	%r8, 4(%r30)
	SW	%r3, 5(%r30)
	SW	%r11, 6(%r30)
	SW	%r5, 7(%r30)
	SW	%r7, 8(%r30)
	SW	%r12, 9(%r30)
	SW	%r4, 10(%r30)
	SW	%r9, 11(%r30)
	SW	%r1, 12(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29316
	J	BEQ_cont.29317
BEQ_else.29316:
	LW	%r13, 0(%r9)
	SW	%r13, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r12, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	veccpy.2691
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r2, %r2, -1
	LW	%r3, 9(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	d_vec.2788
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	veciprod.2702
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fisneg.2603
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29318
	LW	%r1, 13(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29319
BEQ_else.29318:
	LW	%r1, 13(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29319:
	ADDI	%r4, %r0, 116
	LW	%r1, 13(%r30)
	LW	%r2, 6(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29317:
	LW	%r1, 12(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.29320
	J	BEQ_cont.29321
BEQ_else.29320:
	LW	%r2, 11(%r30)
	LW	%r3, 1(%r2)
	LW	%r4, 10(%r30)
	LW	%r5, 9(%r30)
	SW	%r3, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	veccpy.2691
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r2, %r2, -1
	LW	%r3, 9(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	d_vec.2788
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	veciprod.2702
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fisneg.2603
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29323
	LW	%r1, 16(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 18(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29324
BEQ_else.29323:
	LW	%r1, 16(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 18(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29324:
	ADDI	%r4, %r0, 116
	LW	%r1, 16(%r30)
	LW	%r2, 6(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29321:
	LW	%r1, 12(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.29325
	J	BEQ_cont.29326
BEQ_else.29325:
	LW	%r2, 11(%r30)
	LW	%r3, 2(%r2)
	LW	%r4, 10(%r30)
	LW	%r5, 9(%r30)
	SW	%r3, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	veccpy.2691
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r2, %r2, -1
	LW	%r3, 9(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	d_vec.2788
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	veciprod.2702
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fisneg.2603
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29328
	LW	%r1, 20(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 22(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29329
BEQ_else.29328:
	LW	%r1, 20(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 22(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29329:
	ADDI	%r4, %r0, 116
	LW	%r1, 20(%r30)
	LW	%r2, 6(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29326:
	LW	%r1, 12(%r30)
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.29330
	J	BEQ_cont.29331
BEQ_else.29330:
	LW	%r2, 11(%r30)
	LW	%r3, 3(%r2)
	LW	%r4, 10(%r30)
	LW	%r5, 9(%r30)
	SW	%r3, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	veccpy.2691
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r2, %r2, -1
	LW	%r3, 9(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 24(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	d_vec.2788
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	veciprod.2702
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	fisneg.2603
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29333
	LW	%r1, 24(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 26(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29334
BEQ_else.29333:
	LW	%r1, 24(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 26(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29334:
	ADDI	%r4, %r0, 116
	LW	%r1, 24(%r30)
	LW	%r2, 6(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29331:
	LW	%r1, 12(%r30)
	ADDI	%r27, %r0, 4
	BNE	%r1, %r27, BEQ_else.29335
	J	BEQ_cont.29336
BEQ_else.29335:
	LW	%r1, 11(%r30)
	LW	%r1, 4(%r1)
	LW	%r2, 10(%r30)
	LW	%r3, 9(%r30)
	SW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	veccpy.2691
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r2, %r1, -1
	LW	%r1, 9(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 28(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	d_vec.2788
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	veciprod.2702
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	fisneg.2603
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29338
	LW	%r1, 28(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 30(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29339
BEQ_else.29338:
	LW	%r1, 28(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 30(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29339:
	ADDI	%r4, %r0, 116
	LW	%r1, 28(%r30)
	LW	%r2, 6(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29336:
	LW	%r1, 2(%r30)
	LW	%r2, 3(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 1(%r30)
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 0(%r1)
	LW	%r3, 0(%r30)
	LWC1	%f3, 0(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r2)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r2)
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r3)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r2)
	JR	%r31
calc_diffuse_using_5points.3033:
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r2, 5(%r2)
	ADDI	%r8, %r1, -1
	ADD	%r29, %r3, %r8
	LW	%r8, 0(%r29)
	LW	%r8, 5(%r8)
	ADD	%r29, %r3, %r1
	LW	%r9, 0(%r29)
	LW	%r9, 5(%r9)
	ADDI	%r10, %r1, 1
	ADD	%r29, %r3, %r10
	LW	%r10, 0(%r29)
	LW	%r10, 5(%r10)
	ADD	%r29, %r4, %r1
	LW	%r4, 0(%r29)
	LW	%r4, 5(%r4)
	ADD	%r29, %r2, %r5
	LW	%r2, 0(%r29)
	LWC1	%f1, 0(%r2)
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r2)
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r2)
	SWC1	%f1, 2(%r7)
	ADD	%r29, %r8, %r5
	LW	%r2, 0(%r29)
	LWC1	%f1, 0(%r7)
	LWC1	%f2, 0(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r7)
	LWC1	%f2, 1(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r7)
	LWC1	%f2, 2(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r7)
	ADD	%r29, %r9, %r5
	LW	%r2, 0(%r29)
	LWC1	%f1, 0(%r7)
	LWC1	%f2, 0(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r7)
	LWC1	%f2, 1(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r7)
	LWC1	%f2, 2(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r7)
	ADD	%r29, %r10, %r5
	LW	%r2, 0(%r29)
	LWC1	%f1, 0(%r7)
	LWC1	%f2, 0(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r7)
	LWC1	%f2, 1(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r7)
	LWC1	%f2, 2(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r7)
	ADD	%r29, %r4, %r5
	LW	%r2, 0(%r29)
	LWC1	%f1, 0(%r7)
	LWC1	%f2, 0(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r7)
	LWC1	%f2, 1(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r7)
	LWC1	%f2, 2(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r7)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 4(%r1)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	LWC1	%f1, 0(%r6)
	LWC1	%f2, 0(%r1)
	LWC1	%f3, 0(%r7)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r6)
	LWC1	%f1, 1(%r6)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 1(%r7)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r6)
	LWC1	%f1, 2(%r6)
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 2(%r7)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r6)
	JR	%r31
do_without_neighbors.3039:
	LW	%r3, 7(%r26)
	LW	%r4, 6(%r26)
	LW	%r5, 5(%r26)
	LW	%r6, 4(%r26)
	LW	%r7, 3(%r26)
	LW	%r8, 2(%r26)
	LW	%r9, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.29342
	LW	%r10, 2(%r1)
	ADD	%r29, %r10, %r2
	LW	%r10, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r10, %r27
	BNE	%r27, %r0, BEQ_else.29343
	LW	%r10, 3(%r1)
	ADD	%r29, %r10, %r2
	LW	%r10, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r5, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r8, 3(%r30)
	SW	%r9, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r2, 6(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r10, %r27, BEQ_else.29344
	J	BEQ_cont.29345
BEQ_else.29344:
	LW	%r10, 5(%r1)
	LW	%r11, 7(%r1)
	LW	%r12, 1(%r1)
	LW	%r13, 4(%r1)
	ADD	%r29, %r10, %r2
	LW	%r10, 0(%r29)
	LWC1	%f1, 0(%r10)
	SWC1	%f1, 0(%r8)
	LWC1	%f1, 1(%r10)
	SWC1	%f1, 1(%r8)
	LWC1	%f1, 2(%r10)
	SWC1	%f1, 2(%r8)
	LW	%r10, 6(%r1)
	LW	%r10, 0(%r10)
	ADD	%r29, %r11, %r2
	LW	%r11, 0(%r29)
	ADD	%r29, %r12, %r2
	LW	%r12, 0(%r29)
	SW	%r13, 7(%r30)
	SW	%r11, 8(%r30)
	SW	%r6, 9(%r30)
	SW	%r12, 10(%r30)
	SW	%r4, 11(%r30)
	SW	%r7, 12(%r30)
	SW	%r10, 13(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r10, %r27, BEQ_else.29346
	J	BEQ_cont.29347
BEQ_else.29346:
	LW	%r14, 0(%r7)
	SW	%r14, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r12, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 14(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 10(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29347:
	LW	%r1, 13(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.29348
	J	BEQ_cont.29349
BEQ_else.29348:
	LW	%r2, 12(%r30)
	LW	%r3, 1(%r2)
	LW	%r4, 10(%r30)
	LW	%r26, 11(%r30)
	SW	%r3, 15(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 15(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 10(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29349:
	LW	%r1, 13(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.29350
	J	BEQ_cont.29351
BEQ_else.29350:
	LW	%r2, 12(%r30)
	LW	%r3, 2(%r2)
	LW	%r4, 10(%r30)
	LW	%r26, 11(%r30)
	SW	%r3, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 16(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 10(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29351:
	LW	%r1, 13(%r30)
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.29352
	J	BEQ_cont.29353
BEQ_else.29352:
	LW	%r2, 12(%r30)
	LW	%r3, 3(%r2)
	LW	%r4, 10(%r30)
	LW	%r26, 11(%r30)
	SW	%r3, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 17(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 10(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29353:
	LW	%r1, 13(%r30)
	ADDI	%r27, %r0, 4
	BNE	%r1, %r27, BEQ_else.29354
	J	BEQ_cont.29355
BEQ_else.29354:
	LW	%r1, 12(%r30)
	LW	%r1, 4(%r1)
	LW	%r2, 10(%r30)
	LW	%r26, 11(%r30)
	SW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 18(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 10(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29355:
	LW	%r1, 6(%r30)
	LW	%r2, 7(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	LWC1	%f1, 0(%r3)
	LWC1	%f2, 0(%r2)
	LW	%r4, 3(%r30)
	LWC1	%f3, 0(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r3)
	LWC1	%f2, 1(%r2)
	LWC1	%f3, 1(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r3)
	LWC1	%f2, 2(%r2)
	LWC1	%f3, 2(%r4)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r3)
BEQ_cont.29345:
	LW	%r1, 6(%r30)
	ADDI	%r2, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.29356
	LW	%r1, 5(%r30)
	LW	%r3, 2(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29357
	LW	%r3, 3(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r2, 19(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29358
	J	BEQ_cont.29359
BEQ_else.29358:
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29359:
	LW	%r1, 19(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29360
	LW	%r2, 5(%r30)
	LW	%r3, 2(%r2)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29361
	LW	%r3, 3(%r2)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	SW	%r1, 20(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29362
	J	BEQ_cont.29363
BEQ_else.29362:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 23(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	p_energy.2777
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30)
	LW	%r3, 21(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 3(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	veccpy.2691
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30)
	LW	%r3, 22(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 23(%r30)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	LW	%r2, 24(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	LW	%r4, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29363:
	LW	%r1, 20(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29364
	LW	%r2, 5(%r30)
	SW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 25(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29365
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 25(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29366
	J	BEQ_cont.29367
BEQ_else.29366:
	LW	%r1, 5(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29367:
	LW	%r1, 25(%r30)
	ADDI	%r2, %r1, 1
	LW	%r1, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29365:
	JR	%r31
BEQ_else.29364:
	JR	%r31
BEQ_else.29361:
	JR	%r31
BEQ_else.29360:
	JR	%r31
BEQ_else.29357:
	JR	%r31
BEQ_else.29356:
	JR	%r31
BEQ_else.29343:
	JR	%r31
BEQ_else.29342:
	JR	%r31
try_exploit_neighbors.3055:
	LW	%r7, 6(%r26)
	LW	%r8, 5(%r26)
	LW	%r9, 4(%r26)
	LW	%r10, 3(%r26)
	LW	%r11, 2(%r26)
	LW	%r12, 1(%r26)
	ADD	%r29, %r4, %r1
	LW	%r13, 0(%r29)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.29376
	LW	%r14, 2(%r13)
	ADD	%r29, %r14, %r6
	LW	%r14, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r14, %r27
	BNE	%r27, %r0, BEQ_else.29377
	ADD	%r29, %r4, %r1
	LW	%r14, 0(%r29)
	LW	%r14, 2(%r14)
	ADD	%r29, %r14, %r6
	LW	%r14, 0(%r29)
	ADD	%r29, %r3, %r1
	LW	%r15, 0(%r29)
	LW	%r15, 2(%r15)
	ADD	%r29, %r15, %r6
	LW	%r15, 0(%r29)
	BNE	%r15, %r14, BEQ_else.29378
	ADD	%r29, %r5, %r1
	LW	%r15, 0(%r29)
	LW	%r15, 2(%r15)
	ADD	%r29, %r15, %r6
	LW	%r15, 0(%r29)
	BNE	%r15, %r14, BEQ_else.29380
	ADDI	%r15, %r1, -1
	ADD	%r29, %r4, %r15
	LW	%r15, 0(%r29)
	LW	%r15, 2(%r15)
	ADD	%r29, %r15, %r6
	LW	%r15, 0(%r29)
	BNE	%r15, %r14, BEQ_else.29382
	ADDI	%r15, %r1, 1
	ADD	%r29, %r4, %r15
	LW	%r15, 0(%r29)
	LW	%r15, 2(%r15)
	ADD	%r29, %r15, %r6
	LW	%r15, 0(%r29)
	BNE	%r15, %r14, BEQ_else.29384
	ADDI	%r14, %r0, 1
	J	BEQ_cont.29385
BEQ_else.29384:
	ADDI	%r14, %r0, 0
BEQ_cont.29385:
	J	BEQ_cont.29383
BEQ_else.29382:
	ADDI	%r14, %r0, 0
BEQ_cont.29383:
	J	BEQ_cont.29381
BEQ_else.29380:
	ADDI	%r14, %r0, 0
BEQ_cont.29381:
	J	BEQ_cont.29379
BEQ_else.29378:
	ADDI	%r14, %r0, 0
BEQ_cont.29379:
	ADDI	%r27, %r0, 0
	BNE	%r14, %r27, BEQ_else.29386
	ADD	%r29, %r4, %r1
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.29387
	LW	%r2, 2(%r1)
	ADD	%r29, %r2, %r6
	LW	%r2, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29388
	LW	%r2, 3(%r1)
	ADD	%r29, %r2, %r6
	LW	%r2, 0(%r29)
	SW	%r9, 0(%r30)
	SW	%r12, 1(%r30)
	SW	%r8, 2(%r30)
	SW	%r7, 3(%r30)
	SW	%r10, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r6, 6(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29389
	J	BEQ_cont.29390
BEQ_else.29389:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r26, %r12, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29390:
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29391
	LW	%r2, 5(%r30)
	LW	%r3, 2(%r2)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29392
	LW	%r3, 3(%r2)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	SW	%r1, 7(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29393
	J	BEQ_cont.29394
BEQ_else.29393:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	p_energy.2777
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	LW	%r3, 8(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 4(%r30)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	veccpy.2691
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	LW	%r3, 9(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 10(%r30)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	LW	%r2, 11(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 2(%r30)
	LW	%r4, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29394:
	LW	%r1, 7(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29395
	LW	%r2, 5(%r30)
	SW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 12(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29396
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 12(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29397
	J	BEQ_cont.29398
BEQ_else.29397:
	LW	%r1, 5(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29398:
	LW	%r1, 12(%r30)
	ADDI	%r2, %r1, 1
	LW	%r1, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29396:
	JR	%r31
BEQ_else.29395:
	JR	%r31
BEQ_else.29392:
	JR	%r31
BEQ_else.29391:
	JR	%r31
BEQ_else.29388:
	JR	%r31
BEQ_else.29387:
	JR	%r31
BEQ_else.29386:
	LW	%r13, 3(%r13)
	ADD	%r29, %r13, %r6
	LW	%r13, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r13, %r27, BEQ_else.29405
	J	BEQ_cont.29406
BEQ_else.29405:
	ADD	%r29, %r3, %r1
	LW	%r13, 0(%r29)
	LW	%r13, 5(%r13)
	ADDI	%r14, %r1, -1
	ADD	%r29, %r4, %r14
	LW	%r14, 0(%r29)
	LW	%r14, 5(%r14)
	ADD	%r29, %r4, %r1
	LW	%r15, 0(%r29)
	LW	%r15, 5(%r15)
	ADDI	%r16, %r1, 1
	ADD	%r29, %r4, %r16
	LW	%r16, 0(%r29)
	LW	%r16, 5(%r16)
	ADD	%r29, %r5, %r1
	LW	%r17, 0(%r29)
	LW	%r17, 5(%r17)
	ADD	%r29, %r13, %r6
	LW	%r13, 0(%r29)
	LWC1	%f1, 0(%r13)
	SWC1	%f1, 0(%r10)
	LWC1	%f1, 1(%r13)
	SWC1	%f1, 1(%r10)
	LWC1	%f1, 2(%r13)
	SWC1	%f1, 2(%r10)
	ADD	%r29, %r14, %r6
	LW	%r13, 0(%r29)
	LWC1	%f1, 0(%r10)
	LWC1	%f2, 0(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r10)
	LWC1	%f1, 1(%r10)
	LWC1	%f2, 1(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r10)
	LWC1	%f1, 2(%r10)
	LWC1	%f2, 2(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r10)
	ADD	%r29, %r15, %r6
	LW	%r13, 0(%r29)
	LWC1	%f1, 0(%r10)
	LWC1	%f2, 0(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r10)
	LWC1	%f1, 1(%r10)
	LWC1	%f2, 1(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r10)
	LWC1	%f1, 2(%r10)
	LWC1	%f2, 2(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r10)
	ADD	%r29, %r16, %r6
	LW	%r13, 0(%r29)
	LWC1	%f1, 0(%r10)
	LWC1	%f2, 0(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r10)
	LWC1	%f1, 1(%r10)
	LWC1	%f2, 1(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r10)
	LWC1	%f1, 2(%r10)
	LWC1	%f2, 2(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r10)
	ADD	%r29, %r17, %r6
	LW	%r13, 0(%r29)
	LWC1	%f1, 0(%r10)
	LWC1	%f2, 0(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r10)
	LWC1	%f1, 1(%r10)
	LWC1	%f2, 1(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r10)
	LWC1	%f1, 2(%r10)
	LWC1	%f2, 2(%r13)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r10)
	ADD	%r29, %r4, %r1
	LW	%r13, 0(%r29)
	LW	%r13, 4(%r13)
	ADD	%r29, %r13, %r6
	LW	%r13, 0(%r29)
	LWC1	%f1, 0(%r8)
	LWC1	%f2, 0(%r13)
	LWC1	%f3, 0(%r10)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r8)
	LWC1	%f1, 1(%r8)
	LWC1	%f2, 1(%r13)
	LWC1	%f3, 1(%r10)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r8)
	LWC1	%f1, 2(%r8)
	LWC1	%f2, 2(%r13)
	LWC1	%f3, 2(%r10)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r8)
BEQ_cont.29406:
	ADDI	%r6, %r6, 1
	ADD	%r29, %r4, %r1
	LW	%r13, 0(%r29)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.29407
	LW	%r14, 2(%r13)
	ADD	%r29, %r14, %r6
	LW	%r14, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r14, %r27
	BNE	%r27, %r0, BEQ_else.29408
	ADD	%r29, %r4, %r1
	LW	%r14, 0(%r29)
	SW	%r2, 13(%r30)
	SW	%r26, 14(%r30)
	SW	%r11, 15(%r30)
	SW	%r13, 16(%r30)
	SW	%r9, 0(%r30)
	SW	%r12, 1(%r30)
	SW	%r8, 2(%r30)
	SW	%r7, 3(%r30)
	SW	%r10, 4(%r30)
	SW	%r4, 17(%r30)
	SW	%r5, 18(%r30)
	SW	%r1, 19(%r30)
	SW	%r3, 20(%r30)
	SW	%r6, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r14, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 21(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r3, 19(%r30)
	LW	%r4, 20(%r30)
	ADD	%r29, %r4, %r3
	LW	%r5, 0(%r29)
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r5, 21(%r30)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	LW	%r2, 22(%r30)
	BNE	%r1, %r2, BEQ_else.29409
	LW	%r1, 19(%r30)
	LW	%r3, 18(%r30)
	ADD	%r29, %r3, %r1
	LW	%r4, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r5, 21(%r30)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	LW	%r2, 22(%r30)
	BNE	%r1, %r2, BEQ_else.29411
	LW	%r1, 19(%r30)
	ADDI	%r3, %r1, -1
	LW	%r4, 17(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r5, 21(%r30)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	LW	%r2, 22(%r30)
	BNE	%r1, %r2, BEQ_else.29413
	LW	%r1, 19(%r30)
	ADDI	%r3, %r1, 1
	LW	%r4, 17(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r5, 21(%r30)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	LW	%r2, 22(%r30)
	BNE	%r1, %r2, BEQ_else.29415
	ADDI	%r1, %r0, 1
	J	BEQ_cont.29416
BEQ_else.29415:
	ADDI	%r1, %r0, 0
BEQ_cont.29416:
	J	BEQ_cont.29414
BEQ_else.29413:
	ADDI	%r1, %r0, 0
BEQ_cont.29414:
	J	BEQ_cont.29412
BEQ_else.29411:
	ADDI	%r1, %r0, 0
BEQ_cont.29412:
	J	BEQ_cont.29410
BEQ_else.29409:
	ADDI	%r1, %r0, 0
BEQ_cont.29410:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29417
	LW	%r1, 19(%r30)
	LW	%r2, 17(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r5
	BNE	%r27, %r0, BEQ_else.29418
	LW	%r2, 2(%r1)
	ADD	%r29, %r2, %r5
	LW	%r2, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29419
	LW	%r2, 3(%r1)
	ADD	%r29, %r2, %r5
	LW	%r2, 0(%r29)
	SW	%r1, 23(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29420
	J	BEQ_cont.29421
BEQ_else.29420:
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30)
	SW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	p_energy.2777
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 21(%r30)
	LW	%r3, 24(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 4(%r30)
	SW	%r1, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	veccpy.2691
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 23(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 21(%r30)
	LW	%r3, 25(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 26(%r30)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 21(%r30)
	LW	%r2, 27(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 2(%r30)
	LW	%r4, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29421:
	LW	%r1, 21(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29422
	LW	%r2, 23(%r30)
	SW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 28(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29423
	LW	%r1, 23(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 28(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29424
	J	BEQ_cont.29425
BEQ_else.29424:
	LW	%r1, 23(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29425:
	LW	%r1, 28(%r30)
	ADDI	%r2, %r1, 1
	LW	%r1, 23(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29423:
	JR	%r31
BEQ_else.29422:
	JR	%r31
BEQ_else.29419:
	JR	%r31
BEQ_else.29418:
	JR	%r31
BEQ_else.29417:
	LW	%r1, 16(%r30)
	LW	%r1, 3(%r1)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29430
	J	BEQ_cont.29431
BEQ_else.29430:
	LW	%r1, 19(%r30)
	LW	%r2, 20(%r30)
	LW	%r3, 17(%r30)
	LW	%r4, 18(%r30)
	LW	%r26, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29431:
	LW	%r1, 21(%r30)
	ADDI	%r6, %r1, 1
	LW	%r1, 19(%r30)
	LW	%r2, 13(%r30)
	LW	%r3, 20(%r30)
	LW	%r4, 17(%r30)
	LW	%r5, 18(%r30)
	LW	%r26, 14(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29408:
	JR	%r31
BEQ_else.29407:
	JR	%r31
BEQ_else.29377:
	JR	%r31
BEQ_else.29376:
	JR	%r31
set_arr_x.6362.7830:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29436
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29437
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	J	set_arr_x.6362.7830
BEQ_else.29437:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.29436:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
calc_floor.6367.7835:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29438
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29439
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.29440
BEQ_else.29439:
	SUB.s	%f2, %f1, %f2
BEQ_cont.29440:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29441
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29442
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29443
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.29444
BEQ_else.29443:
	SUB.s	%f2, %f1, %f2
BEQ_cont.29444:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29445
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367.7835
BEQ_else.29445:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367.7835
BEQ_else.29442:
	JR	%r31
BEQ_else.29441:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29446
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29447
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.29448
BEQ_else.29447:
	SUB.s	%f2, %f1, %f2
BEQ_cont.29448:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29449
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367.7835
BEQ_else.29449:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367.7835
BEQ_else.29446:
	JR	%r31
BEQ_else.29438:
	JR	%r31
write_rgb_element.3064:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29450
	LA	%r29, l.20801
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29452
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29453
BEQ_else.29452:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r3, 1(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29454
	SWC1	%f1, 0(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362.7830
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29455
BEQ_else.29454:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r1, %r0, 0
BEQ_cont.29455:
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29456
	ADDI	%r2, %r1, 1
	LW	%r4, 1(%r30)
	ADD	%r29, %r4, %r2
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	LW	%r3, 0(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29458
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.29459
BEQ_else.29458:
	SUB.s	%f2, %f1, %f2
BEQ_cont.29459:
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29460
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 1
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6367.7835
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29461
BEQ_else.29460:
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6367.7835
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29461:
	J	BEQ_cont.29457
BEQ_else.29456:
	ADDI	%r1, %r0, 0
BEQ_cont.29457:
BEQ_cont.29453:
	J	BEQ_cont.29451
BEQ_else.29450:
	LA	%r29, l.20790
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29462
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29463
BEQ_else.29462:
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r3, 1(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29464
	SWC1	%f1, 0(%r2)
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362.7830
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29465
BEQ_else.29464:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r1, %r0, 0
BEQ_cont.29465:
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29466
	ADDI	%r2, %r1, 1
	LW	%r4, 1(%r30)
	ADD	%r29, %r4, %r2
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	LW	%r3, 0(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f2, 0(%r29)
	LA	%r29, l.20768
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.29468
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.29469
BEQ_else.29468:
	SUB.s	%f2, %f1, %f2
BEQ_cont.29469:
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29470
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 1
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6367.7835
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29471
BEQ_else.29470:
	ADD	%r29, %r4, %r1
	SWC1	%f1, 0(%r29)
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6367.7835
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29471:
	J	BEQ_cont.29467
BEQ_else.29466:
	ADDI	%r1, %r0, 0
BEQ_cont.29467:
	SUB	%r29, %r0, %r1
	ADDI	%r1, %r29, 0
BEQ_cont.29463:
BEQ_cont.29451:
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29472
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29474
	J	BEQ_cont.29475
BEQ_else.29474:
	ADDI	%r1, %r0, 0
BEQ_cont.29475:
	J	BEQ_cont.29473
BEQ_else.29472:
	ADDI	%r1, %r0, 255
BEQ_cont.29473:
	J	min_caml_print_int
pretrace_diffuse_rays.3068:
	LW	%r3, 8(%r26)
	LW	%r4, 7(%r26)
	LW	%r5, 6(%r26)
	LW	%r6, 5(%r26)
	LW	%r7, 4(%r26)
	LW	%r8, 3(%r26)
	LW	%r9, 2(%r26)
	LW	%r10, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.29476
	LW	%r11, 2(%r1)
	ADD	%r29, %r11, %r2
	LW	%r11, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r11, %r27
	BNE	%r27, %r0, BEQ_else.29477
	LW	%r11, 3(%r1)
	ADD	%r29, %r11, %r2
	LW	%r11, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r8, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r7, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r9, 6(%r30)
	SW	%r10, 7(%r30)
	SW	%r2, 8(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r11, %r27, BEQ_else.29478
	J	BEQ_cont.29479
BEQ_else.29478:
	LW	%r11, 6(%r1)
	LW	%r11, 0(%r11)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r10)
	SWC1	%f1, 1(%r10)
	SWC1	%f1, 2(%r10)
	LW	%r12, 7(%r1)
	LW	%r13, 1(%r1)
	ADD	%r29, %r9, %r11
	LW	%r11, 0(%r29)
	ADD	%r29, %r12, %r2
	LW	%r12, 0(%r29)
	ADD	%r29, %r13, %r2
	LW	%r13, 0(%r29)
	SW	%r1, 9(%r30)
	SW	%r13, 10(%r30)
	SW	%r12, 11(%r30)
	SW	%r11, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r13, 0
	ADDI	%r26, %r6, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 12(%r30)
	LW	%r2, 11(%r30)
	LW	%r3, 10(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30)
	LW	%r2, 5(%r1)
	LW	%r3, 8(%r30)
	ADD	%r29, %r2, %r3
	LW	%r2, 0(%r29)
	LW	%r4, 7(%r30)
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r2)
BEQ_cont.29479:
	LW	%r2, 8(%r30)
	ADDI	%r2, %r2, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.29480
	LW	%r3, 2(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29481
	LW	%r3, 3(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r2, 13(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29482
	J	BEQ_cont.29483
BEQ_else.29482:
	LW	%r3, 6(%r1)
	LW	%r3, 0(%r3)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LW	%r4, 7(%r30)
	SWC1	%f1, 0(%r4)
	SWC1	%f1, 1(%r4)
	SWC1	%f1, 2(%r4)
	LW	%r5, 7(%r1)
	LW	%r6, 1(%r1)
	LW	%r7, 6(%r30)
	ADD	%r29, %r7, %r3
	LW	%r3, 0(%r29)
	ADD	%r29, %r5, %r2
	LW	%r5, 0(%r29)
	ADD	%r29, %r6, %r2
	LW	%r6, 0(%r29)
	LW	%r7, 5(%r30)
	SW	%r1, 9(%r30)
	SW	%r5, 14(%r30)
	SW	%r3, 15(%r30)
	SW	%r6, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r7, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	veccpy.2691
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r2, %r1, -1
	LW	%r1, 16(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 15(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	d_vec.2788
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	veciprod.2702
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fisneg.2603
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29485
	LW	%r1, 15(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 18(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29486
BEQ_else.29485:
	LW	%r1, 15(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 18(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29486:
	ADDI	%r4, %r0, 116
	LW	%r1, 15(%r30)
	LW	%r2, 14(%r30)
	LW	%r3, 16(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30)
	LW	%r2, 5(%r1)
	LW	%r3, 13(%r30)
	ADD	%r29, %r2, %r3
	LW	%r2, 0(%r29)
	LW	%r4, 7(%r30)
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r2)
BEQ_cont.29483:
	LW	%r2, 13(%r30)
	ADDI	%r2, %r2, 1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29481:
	JR	%r31
BEQ_else.29480:
	JR	%r31
BEQ_else.29477:
	JR	%r31
BEQ_else.29476:
	JR	%r31
calc_sqrt.6353.11991.14279:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29491
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.11991.14279
BEQ_else.29491:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.14384:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29492
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29493
	J	calc_sqrt.6353.14384
BEQ_else.29493:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.29492:
	ADD.s	%f1, %f2, %f0
	JR	%r31
pretrace_pixels.3071:
	LW	%r4, 16(%r26)
	LW	%r5, 15(%r26)
	LW	%r6, 14(%r26)
	LW	%r7, 13(%r26)
	LW	%r8, 12(%r26)
	LW	%r9, 11(%r26)
	LW	%r10, 10(%r26)
	LW	%r11, 9(%r26)
	LW	%r12, 8(%r26)
	LW	%r13, 7(%r26)
	LW	%r14, 6(%r26)
	LW	%r15, 5(%r26)
	LW	%r16, 4(%r26)
	LW	%r17, 3(%r26)
	LW	%r18, 2(%r26)
	LW	%r19, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29494
	LWC1	%f4, 0(%r11)
	LW	%r20, 0(%r17)
	SUB	%r20, %r2, %r20
	SW	%r26, 0(%r30)
	SW	%r17, 1(%r30)
	SW	%r11, 2(%r30)
	SW	%r14, 3(%r30)
	SW	%r16, 4(%r30)
	SW	%r6, 5(%r30)
	SW	%r9, 6(%r30)
	SW	%r15, 7(%r30)
	SW	%r7, 8(%r30)
	SW	%r18, 9(%r30)
	SW	%r19, 10(%r30)
	SW	%r3, 11(%r30)
	SW	%r5, 12(%r30)
	SW	%r2, 13(%r30)
	SW	%r1, 14(%r30)
	SW	%r8, 15(%r30)
	SW	%r4, 16(%r30)
	SW	%r12, 17(%r30)
	SWC1	%f3, 18(%r30)
	SWC1	%f2, 20(%r30)
	SW	%r13, 22(%r30)
	SWC1	%f1, 24(%r30)
	SW	%r10, 26(%r30)
	SWC1	%f4, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r20, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 26(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 24(%r30)
	ADD.s	%f2, %f2, %f3
	LW	%r2, 22(%r30)
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f4, 20(%r30)
	ADD.s	%f2, %f2, %f4
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 18(%r30)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r2)
	LWC1	%f1, 0(%r2)
	MUL.s	%f1, %f1, %f1
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f5, %f5
	ADD.s	%f1, %f1, %f5
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f5, %f5
	ADD.s	%f1, %f1, %f5
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.29497
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.29499
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f5, %f1, %f5
	DIV.s	%f6, %f1, %f5
	ADD.s	%f6, %f5, %f6
	LA	%r29, l.20771
	LWC1	%f7, 0(%r29)
	DIV.s	%f6, %f6, %f7
	C.eq.s	%r27, %f6, %f5
	BNE	%r27, %r0, BEQ_else.29501
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f6, %f0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	calc_sqrt.6353.14384
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29502
BEQ_else.29501:
	ADD.s	%f1, %f5, %f0
BEQ_cont.29502:
	J	BEQ_cont.29500
BEQ_else.29499:
BEQ_cont.29500:
	J	BEQ_cont.29498
BEQ_else.29497:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29498:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29503
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29504
BEQ_else.29503:
	ADDI	%r1, %r0, 1
BEQ_cont.29504:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29505
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.29506
BEQ_else.29505:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.29506:
	LW	%r2, 22(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r2)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LW	%r1, 17(%r30)
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	LW	%r3, 16(%r30)
	LWC1	%f1, 0(%r3)
	LW	%r4, 15(%r30)
	SWC1	%f1, 0(%r4)
	LWC1	%f1, 1(%r3)
	SWC1	%f1, 1(%r4)
	LWC1	%f1, 2(%r3)
	SWC1	%f1, 2(%r4)
	ADDI	%r5, %r0, 0
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LW	%r6, 13(%r30)
	LW	%r7, 14(%r30)
	ADD	%r29, %r7, %r6
	LW	%r8, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LW	%r26, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r8, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	LW	%r2, 14(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	LW	%r4, 17(%r30)
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 6(%r3)
	LW	%r5, 11(%r30)
	SW	%r5, 0(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r6, 2(%r3)
	LW	%r6, 0(%r6)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r6, %r27
	BNE	%r27, %r0, BEQ_else.29507
	LW	%r6, 3(%r3)
	LW	%r6, 0(%r6)
	SW	%r3, 30(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r6, %r27, BEQ_else.29509
	J	BEQ_cont.29510
BEQ_else.29509:
	LW	%r6, 6(%r3)
	LW	%r6, 0(%r6)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LW	%r7, 10(%r30)
	SWC1	%f1, 0(%r7)
	SWC1	%f1, 1(%r7)
	SWC1	%f1, 2(%r7)
	LW	%r8, 7(%r3)
	LW	%r9, 1(%r3)
	LW	%r10, 9(%r30)
	ADD	%r29, %r10, %r6
	LW	%r6, 0(%r29)
	LW	%r8, 0(%r8)
	LW	%r9, 0(%r9)
	LW	%r10, 8(%r30)
	SW	%r8, 31(%r30)
	SW	%r6, 32(%r30)
	SW	%r9, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r9, 0
	ADDI	%r1, %r10, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	veccpy.2691
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r2, %r1, -1
	LW	%r1, 33(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 32(%r30)
	LW	%r2, 118(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	d_vec.2788
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 31(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	veciprod.2702
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	fisneg.2603
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29511
	LW	%r1, 32(%r30)
	LW	%r2, 118(%r1)
	LA	%r29, l.22131
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 34(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29512
BEQ_else.29511:
	LW	%r1, 32(%r30)
	LW	%r2, 119(%r1)
	LA	%r29, l.22097
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 34(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29512:
	ADDI	%r4, %r0, 116
	LW	%r1, 32(%r30)
	LW	%r2, 31(%r30)
	LW	%r3, 33(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 30(%r30)
	LW	%r2, 5(%r1)
	LW	%r2, 0(%r2)
	LW	%r3, 10(%r30)
	LWC1	%f1, 0(%r3)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r3)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r3)
	SWC1	%f1, 2(%r2)
BEQ_cont.29510:
	ADDI	%r2, %r0, 1
	LW	%r1, 30(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29508
BEQ_else.29507:
BEQ_cont.29508:
	LW	%r1, 13(%r30)
	ADDI	%r1, %r1, -1
	LW	%r2, 11(%r30)
	ADDI	%r2, %r2, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29513
	ADDI	%r2, %r2, -5
	J	BEQ_cont.29514
BEQ_else.29513:
BEQ_cont.29514:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29515
	LW	%r3, 2(%r30)
	LWC1	%f1, 0(%r3)
	LW	%r3, 1(%r30)
	LW	%r3, 0(%r3)
	SUB	%r3, %r1, %r3
	SW	%r2, 36(%r30)
	SW	%r1, 37(%r30)
	SWC1	%f1, 38(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 38(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 26(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 24(%r30)
	ADD.s	%f2, %f2, %f3
	LW	%r2, 22(%r30)
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f4, 20(%r30)
	ADD.s	%f2, %f2, %f4
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 18(%r30)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r2)
	LWC1	%f1, 0(%r2)
	MUL.s	%f1, %f1, %f1
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f5, %f5
	ADD.s	%f1, %f1, %f5
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f5, %f5
	ADD.s	%f1, %f1, %f5
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.29516
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.29518
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f5, %f1, %f5
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	calc_sqrt.6353.11991.14279
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29519
BEQ_else.29518:
BEQ_cont.29519:
	J	BEQ_cont.29517
BEQ_else.29516:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29517:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29520
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29521
BEQ_else.29520:
	ADDI	%r1, %r0, 1
BEQ_cont.29521:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29522
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.29523
BEQ_else.29522:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.29523:
	LW	%r2, 22(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r2)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LW	%r1, 17(%r30)
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	LW	%r3, 16(%r30)
	LWC1	%f1, 0(%r3)
	LW	%r4, 15(%r30)
	SWC1	%f1, 0(%r4)
	LWC1	%f1, 1(%r3)
	SWC1	%f1, 1(%r4)
	LWC1	%f1, 2(%r3)
	SWC1	%f1, 2(%r4)
	ADDI	%r3, %r0, 0
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LW	%r4, 37(%r30)
	LW	%r5, 14(%r30)
	ADD	%r29, %r5, %r4
	LW	%r6, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LW	%r26, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r6, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 37(%r30)
	LW	%r2, 14(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	LW	%r4, 17(%r30)
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 6(%r3)
	LW	%r4, 36(%r30)
	SW	%r4, 0(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 37(%r30)
	ADDI	%r2, %r1, -1
	LW	%r1, 36(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29524
	ADDI	%r3, %r1, -5
	J	BEQ_cont.29525
BEQ_else.29524:
	ADDI	%r3, %r1, 0
BEQ_cont.29525:
	LWC1	%f1, 24(%r30)
	LWC1	%f2, 20(%r30)
	LWC1	%f3, 18(%r30)
	LW	%r1, 14(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29515:
	JR	%r31
BEQ_else.29494:
	JR	%r31
calc_sqrt.6353.11991.14187:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29528
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.11991.14187
BEQ_else.29528:
	ADD.s	%f1, %f2, %f0
	JR	%r31
pretrace_line.3078:
	LW	%r4, 13(%r26)
	LW	%r5, 12(%r26)
	LW	%r6, 11(%r26)
	LW	%r7, 10(%r26)
	LW	%r8, 9(%r26)
	LW	%r9, 8(%r26)
	LW	%r10, 7(%r26)
	LW	%r11, 6(%r26)
	LW	%r12, 5(%r26)
	LW	%r13, 4(%r26)
	LW	%r14, 3(%r26)
	LW	%r15, 2(%r26)
	LW	%r16, 1(%r26)
	LWC1	%f1, 0(%r10)
	LW	%r17, 1(%r16)
	SUB	%r2, %r2, %r17
	SW	%r13, 0(%r30)
	SW	%r14, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r1, 4(%r30)
	SW	%r6, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r11, 7(%r30)
	SW	%r12, 8(%r30)
	SW	%r9, 9(%r30)
	SW	%r16, 10(%r30)
	SW	%r10, 11(%r30)
	SW	%r15, 12(%r30)
	SW	%r7, 13(%r30)
	SW	%r8, 14(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 14(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LW	%r2, 13(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f1, %f3
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f1, %f1, %f4
	LWC1	%f4, 2(%r2)
	ADD.s	%f1, %f1, %f4
	LW	%r1, 12(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29530
	LW	%r2, 11(%r30)
	LWC1	%f4, 0(%r2)
	LW	%r2, 10(%r30)
	LW	%r2, 0(%r2)
	SUB	%r2, %r1, %r2
	SW	%r1, 18(%r30)
	SWC1	%f1, 20(%r30)
	SWC1	%f3, 22(%r30)
	SWC1	%f2, 24(%r30)
	SWC1	%f4, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 26(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 9(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 24(%r30)
	ADD.s	%f2, %f2, %f3
	LW	%r2, 8(%r30)
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f4, 22(%r30)
	ADD.s	%f2, %f2, %f4
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 20(%r30)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r2)
	LWC1	%f1, 0(%r2)
	MUL.s	%f1, %f1, %f1
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f5, %f5
	ADD.s	%f1, %f1, %f5
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f5, %f5
	ADD.s	%f1, %f1, %f5
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.le.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.29532
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f1, %f5
	BNE	%r27, %r0, BEQ_else.29534
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f5, %f1, %f5
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	calc_sqrt.6353.11991.14187
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29535
BEQ_else.29534:
BEQ_cont.29535:
	J	BEQ_cont.29533
BEQ_else.29532:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29533:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29536
	ADDI	%r1, %r0, 0
	J	BEQ_cont.29537
BEQ_else.29536:
	ADDI	%r1, %r0, 1
BEQ_cont.29537:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29538
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.29539
BEQ_else.29538:
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
BEQ_cont.29539:
	LW	%r2, 8(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r2)
	MUL.s	%f2, %f2, %f1
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r2)
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 2(%r2)
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LW	%r1, 7(%r30)
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	LW	%r3, 6(%r30)
	LWC1	%f1, 0(%r3)
	LW	%r4, 5(%r30)
	SWC1	%f1, 0(%r4)
	LWC1	%f1, 1(%r3)
	SWC1	%f1, 1(%r4)
	LWC1	%f1, 2(%r3)
	SWC1	%f1, 2(%r4)
	ADDI	%r3, %r0, 0
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LW	%r4, 18(%r30)
	LW	%r5, 4(%r30)
	ADD	%r29, %r5, %r4
	LW	%r6, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r6, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 18(%r30)
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	LW	%r4, 7(%r30)
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 6(%r3)
	LW	%r4, 2(%r30)
	SW	%r4, 0(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 18(%r30)
	ADDI	%r2, %r1, -1
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29540
	ADDI	%r3, %r1, -5
	J	BEQ_cont.29541
BEQ_else.29540:
	ADDI	%r3, %r1, 0
BEQ_cont.29541:
	LWC1	%f1, 24(%r30)
	LWC1	%f2, 22(%r30)
	LWC1	%f3, 20(%r30)
	LW	%r1, 4(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29530:
	JR	%r31
scan_pixel.3082:
	LW	%r6, 10(%r26)
	LW	%r7, 9(%r26)
	LW	%r8, 8(%r26)
	LW	%r9, 7(%r26)
	LW	%r10, 6(%r26)
	LW	%r11, 5(%r26)
	LW	%r12, 4(%r26)
	LW	%r13, 3(%r26)
	LW	%r14, 2(%r26)
	LW	%r15, 1(%r26)
	LW	%r16, 0(%r11)
	SLT	%r27, %r1, %r16
	BNE	%r27, %r0, BEQ_else.29543
	JR	%r31
BEQ_else.29543:
	ADD	%r29, %r4, %r1
	LW	%r16, 0(%r29)
	LW	%r16, 0(%r16)
	LWC1	%f1, 0(%r16)
	SWC1	%f1, 0(%r9)
	LWC1	%f1, 1(%r16)
	SWC1	%f1, 1(%r9)
	LWC1	%f1, 2(%r16)
	SWC1	%f1, 2(%r9)
	LW	%r16, 1(%r11)
	ADDI	%r17, %r2, 1
	SLT	%r27, %r17, %r16
	BNE	%r27, %r0, BEQ_else.29545
	ADDI	%r16, %r0, 0
	J	BEQ_cont.29546
BEQ_else.29545:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.29547
	ADDI	%r16, %r0, 0
	J	BEQ_cont.29548
BEQ_else.29547:
	LW	%r16, 0(%r11)
	ADDI	%r17, %r1, 1
	SLT	%r27, %r17, %r16
	BNE	%r27, %r0, BEQ_else.29549
	ADDI	%r16, %r0, 0
	J	BEQ_cont.29550
BEQ_else.29549:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29551
	ADDI	%r16, %r0, 0
	J	BEQ_cont.29552
BEQ_else.29551:
	ADDI	%r16, %r0, 1
BEQ_cont.29552:
BEQ_cont.29550:
BEQ_cont.29548:
BEQ_cont.29546:
	SW	%r26, 0(%r30)
	SW	%r10, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r3, 3(%r30)
	SW	%r7, 4(%r30)
	SW	%r12, 5(%r30)
	SW	%r15, 6(%r30)
	SW	%r8, 7(%r30)
	SW	%r13, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r4, 10(%r30)
	SW	%r11, 11(%r30)
	SW	%r1, 12(%r30)
	SW	%r6, 13(%r30)
	SW	%r9, 14(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r16, %r27, BEQ_else.29553
	ADD	%r29, %r4, %r1
	LW	%r14, 0(%r29)
	ADDI	%r16, %r0, 0
	LW	%r17, 2(%r14)
	LW	%r17, 0(%r17)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r17, %r27
	BNE	%r27, %r0, BEQ_else.29555
	LW	%r17, 3(%r14)
	LW	%r17, 0(%r17)
	SW	%r14, 15(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r17, %r27, BEQ_else.29557
	J	BEQ_cont.29558
BEQ_else.29557:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r16, 0
	ADDI	%r1, %r14, 0
	ADDI	%r26, %r15, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29558:
	LW	%r1, 15(%r30)
	LW	%r2, 2(%r1)
	LW	%r2, 1(%r2)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29559
	LW	%r2, 3(%r1)
	LW	%r2, 1(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29561
	J	BEQ_cont.29562
BEQ_else.29561:
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 15(%r30)
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 15(%r30)
	SW	%r1, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 15(%r30)
	SW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	p_energy.2777
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 16(%r30)
	LW	%r2, 1(%r2)
	LW	%r3, 8(%r30)
	SW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	veccpy.2691
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 17(%r30)
	LW	%r2, 1(%r2)
	LW	%r3, 18(%r30)
	LW	%r3, 1(%r3)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 19(%r30)
	LW	%r2, 1(%r1)
	LW	%r1, 14(%r30)
	LW	%r3, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29562:
	ADDI	%r1, %r0, 2
	LW	%r2, 15(%r30)
	SW	%r1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r1)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29563
	LW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29565
	J	BEQ_cont.29566
BEQ_else.29565:
	LW	%r1, 15(%r30)
	LW	%r2, 20(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29566:
	ADDI	%r2, %r0, 3
	LW	%r1, 15(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29564
BEQ_else.29563:
BEQ_cont.29564:
	J	BEQ_cont.29560
BEQ_else.29559:
BEQ_cont.29560:
	J	BEQ_cont.29556
BEQ_else.29555:
BEQ_cont.29556:
	J	BEQ_cont.29554
BEQ_else.29553:
	ADDI	%r16, %r0, 0
	ADD	%r29, %r4, %r1
	LW	%r17, 0(%r29)
	LW	%r18, 2(%r17)
	LW	%r18, 0(%r18)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r18, %r27
	BNE	%r27, %r0, BEQ_else.29567
	ADD	%r29, %r4, %r1
	LW	%r18, 0(%r29)
	SW	%r16, 21(%r30)
	SW	%r14, 22(%r30)
	SW	%r17, 23(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r18, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r1)
	LW	%r2, 12(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r1)
	LW	%r2, 24(%r30)
	BNE	%r1, %r2, BEQ_else.29569
	LW	%r1, 12(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r1
	LW	%r4, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r1)
	LW	%r2, 24(%r30)
	BNE	%r1, %r2, BEQ_else.29571
	LW	%r1, 12(%r30)
	ADDI	%r3, %r1, -1
	LW	%r4, 10(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r1)
	LW	%r2, 24(%r30)
	BNE	%r1, %r2, BEQ_else.29573
	LW	%r1, 12(%r30)
	ADDI	%r3, %r1, 1
	LW	%r4, 10(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r1)
	LW	%r2, 24(%r30)
	BNE	%r1, %r2, BEQ_else.29575
	ADDI	%r1, %r0, 1
	J	BEQ_cont.29576
BEQ_else.29575:
	ADDI	%r1, %r0, 0
BEQ_cont.29576:
	J	BEQ_cont.29574
BEQ_else.29573:
	ADDI	%r1, %r0, 0
BEQ_cont.29574:
	J	BEQ_cont.29572
BEQ_else.29571:
	ADDI	%r1, %r0, 0
BEQ_cont.29572:
	J	BEQ_cont.29570
BEQ_else.29569:
	ADDI	%r1, %r0, 0
BEQ_cont.29570:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29577
	LW	%r1, 12(%r30)
	LW	%r2, 10(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 2(%r3)
	LW	%r4, 0(%r4)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.29579
	LW	%r4, 3(%r3)
	LW	%r4, 0(%r4)
	SW	%r3, 25(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.29581
	J	BEQ_cont.29582
BEQ_else.29581:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 25(%r30)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 25(%r30)
	SW	%r1, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 25(%r30)
	SW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	p_energy.2777
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 26(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 8(%r30)
	SW	%r1, 29(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	veccpy.2691
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 27(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 28(%r30)
	LW	%r3, 0(%r3)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 29(%r30)
	LW	%r2, 0(%r1)
	LW	%r1, 14(%r30)
	LW	%r3, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29582:
	ADDI	%r1, %r0, 1
	LW	%r2, 25(%r30)
	SW	%r1, 30(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r1)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29583
	LW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29585
	J	BEQ_cont.29586
BEQ_else.29585:
	LW	%r1, 25(%r30)
	LW	%r2, 30(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29586:
	ADDI	%r2, %r0, 2
	LW	%r1, 25(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29584
BEQ_else.29583:
BEQ_cont.29584:
	J	BEQ_cont.29580
BEQ_else.29579:
BEQ_cont.29580:
	J	BEQ_cont.29578
BEQ_else.29577:
	LW	%r1, 23(%r30)
	LW	%r1, 3(%r1)
	LW	%r1, 0(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29587
	J	BEQ_cont.29588
BEQ_else.29587:
	LW	%r1, 12(%r30)
	LW	%r2, 3(%r30)
	LW	%r3, 10(%r30)
	LW	%r4, 2(%r30)
	LW	%r5, 21(%r30)
	LW	%r26, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29588:
	ADDI	%r6, %r0, 1
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	LW	%r3, 3(%r30)
	LW	%r4, 10(%r30)
	LW	%r5, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29578:
	J	BEQ_cont.29568
BEQ_else.29567:
BEQ_cont.29568:
BEQ_cont.29554:
	LW	%r1, 14(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r26, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LWC1	%f1, 1(%r1)
	LW	%r26, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LWC1	%f1, 2(%r1)
	LW	%r26, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 11(%r30)
	LW	%r3, 0(%r2)
	SLT	%r27, %r1, %r3
	BNE	%r27, %r0, BEQ_else.29589
	JR	%r31
BEQ_else.29589:
	LW	%r4, 10(%r30)
	ADD	%r29, %r4, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	LWC1	%f1, 0(%r3)
	LW	%r5, 14(%r30)
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r3)
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r3)
	SWC1	%f1, 2(%r5)
	LW	%r3, 1(%r2)
	LW	%r6, 9(%r30)
	ADDI	%r7, %r6, 1
	SLT	%r27, %r7, %r3
	BNE	%r27, %r0, BEQ_else.29591
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29592
BEQ_else.29591:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.29593
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29594
BEQ_else.29593:
	LW	%r2, 0(%r2)
	ADDI	%r3, %r1, 1
	SLT	%r27, %r3, %r2
	BNE	%r27, %r0, BEQ_else.29595
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29596
BEQ_else.29595:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29597
	ADDI	%r2, %r0, 0
	J	BEQ_cont.29598
BEQ_else.29597:
	ADDI	%r2, %r0, 1
BEQ_cont.29598:
BEQ_cont.29596:
BEQ_cont.29594:
BEQ_cont.29592:
	SW	%r1, 31(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.29599
	ADD	%r29, %r4, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 2(%r2)
	LW	%r3, 0(%r3)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29601
	LW	%r3, 3(%r2)
	LW	%r3, 0(%r3)
	SW	%r2, 32(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29603
	J	BEQ_cont.29604
BEQ_else.29603:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 33(%r30)
	ADDI	%r30, %r30, 34
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30)
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30)
	SW	%r1, 34(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 35(%r30)
	ADDI	%r30, %r30, 36
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 36
	SUB	%r30, %r30, %r29
	LW	%r29, 35(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30)
	SW	%r1, 35(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	p_energy.2777
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 33(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 8(%r30)
	SW	%r1, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	veccpy.2691
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 34(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 35(%r30)
	LW	%r3, 0(%r3)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 36(%r30)
	LW	%r2, 0(%r1)
	LW	%r1, 14(%r30)
	LW	%r3, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29604:
	ADDI	%r1, %r0, 1
	LW	%r2, 32(%r30)
	SW	%r1, 37(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r1)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29605
	LW	%r1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29607
	J	BEQ_cont.29608
BEQ_else.29607:
	LW	%r1, 32(%r30)
	LW	%r2, 37(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29608:
	ADDI	%r2, %r0, 2
	LW	%r1, 32(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29606
BEQ_else.29605:
BEQ_cont.29606:
	J	BEQ_cont.29602
BEQ_else.29601:
BEQ_cont.29602:
	J	BEQ_cont.29600
BEQ_else.29599:
	ADDI	%r2, %r0, 0
	LW	%r3, 3(%r30)
	LW	%r7, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r5, %r7, 0
	ADDI	%r25, %r6, 0
	ADDI	%r6, %r2, 0
	ADDI	%r2, %r25, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29600:
	LW	%r1, 14(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29609
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29611
	J	BEQ_cont.29612
BEQ_else.29611:
	ADDI	%r1, %r0, 0
BEQ_cont.29612:
	J	BEQ_cont.29610
BEQ_else.29609:
	ADDI	%r1, %r0, 255
BEQ_cont.29610:
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LWC1	%f1, 1(%r1)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29613
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29615
	J	BEQ_cont.29616
BEQ_else.29615:
	ADDI	%r1, %r0, 0
BEQ_cont.29616:
	J	BEQ_cont.29614
BEQ_else.29613:
	ADDI	%r1, %r0, 255
BEQ_cont.29614:
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LWC1	%f1, 2(%r1)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29617
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29619
	J	BEQ_cont.29620
BEQ_else.29619:
	ADDI	%r1, %r0, 0
BEQ_cont.29620:
	J	BEQ_cont.29618
BEQ_else.29617:
	ADDI	%r1, %r0, 255
BEQ_cont.29618:
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 31(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30)
	LW	%r3, 3(%r30)
	LW	%r4, 10(%r30)
	LW	%r5, 2(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
scan_line.3088:
	LW	%r6, 15(%r26)
	LW	%r7, 14(%r26)
	LW	%r8, 13(%r26)
	LW	%r9, 12(%r26)
	LW	%r10, 11(%r26)
	LW	%r11, 10(%r26)
	LW	%r12, 9(%r26)
	LW	%r13, 8(%r26)
	LW	%r14, 7(%r26)
	LW	%r15, 6(%r26)
	LW	%r16, 5(%r26)
	LW	%r17, 4(%r26)
	LW	%r18, 3(%r26)
	LW	%r19, 2(%r26)
	LW	%r20, 1(%r26)
	LW	%r21, 1(%r16)
	SLT	%r27, %r1, %r21
	BNE	%r27, %r0, BEQ_else.29621
	JR	%r31
BEQ_else.29621:
	LW	%r21, 1(%r16)
	ADDI	%r21, %r21, -1
	SW	%r26, 0(%r30)
	SW	%r14, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r10, 3(%r30)
	SW	%r15, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r2, 6(%r30)
	SW	%r6, 7(%r30)
	SW	%r18, 8(%r30)
	SW	%r20, 9(%r30)
	SW	%r7, 10(%r30)
	SW	%r19, 11(%r30)
	SW	%r1, 12(%r30)
	SW	%r12, 13(%r30)
	SW	%r3, 14(%r30)
	SW	%r16, 15(%r30)
	SLT	%r27, %r1, %r21
	BNE	%r27, %r0, BEQ_else.29623
	J	BEQ_cont.29624
BEQ_else.29623:
	ADDI	%r21, %r1, 1
	LWC1	%f1, 0(%r11)
	LW	%r11, 1(%r17)
	SUB	%r11, %r21, %r11
	SW	%r13, 16(%r30)
	SW	%r8, 17(%r30)
	SW	%r9, 18(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r11, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 18(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LW	%r2, 17(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f1, %f3
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f1, %f1, %f4
	LWC1	%f4, 2(%r2)
	ADD.s	%f1, %f1, %f4
	LW	%r1, 15(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r2, %r2, -1
	LW	%r3, 5(%r30)
	LW	%r4, 2(%r30)
	LW	%r26, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r4, 0
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f31, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29624:
	ADDI	%r1, %r0, 0
	LW	%r2, 15(%r30)
	LW	%r3, 0(%r2)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r3
	BNE	%r27, %r0, BEQ_else.29626
	J	BEQ_cont.29627
BEQ_else.29626:
	LW	%r4, 14(%r30)
	LW	%r3, 0(%r4)
	LW	%r3, 0(%r3)
	LWC1	%f1, 0(%r3)
	LW	%r5, 13(%r30)
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r3)
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r3)
	SWC1	%f1, 2(%r5)
	LW	%r3, 1(%r2)
	LW	%r6, 12(%r30)
	ADDI	%r7, %r6, 1
	SLT	%r27, %r7, %r3
	BNE	%r27, %r0, BEQ_else.29628
	ADDI	%r3, %r0, 0
	J	BEQ_cont.29629
BEQ_else.29628:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.29630
	ADDI	%r3, %r0, 0
	J	BEQ_cont.29631
BEQ_else.29630:
	LW	%r3, 0(%r2)
	ADDI	%r27, %r0, 1
	SLT	%r27, %r27, %r3
	BNE	%r27, %r0, BEQ_else.29632
	ADDI	%r3, %r0, 0
	J	BEQ_cont.29633
BEQ_else.29632:
	ADDI	%r3, %r0, 0
BEQ_cont.29633:
BEQ_cont.29631:
BEQ_cont.29629:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29634
	LW	%r1, 0(%r4)
	LW	%r3, 2(%r1)
	LW	%r3, 0(%r3)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29636
	LW	%r3, 3(%r1)
	LW	%r3, 0(%r3)
	SW	%r1, 22(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.29638
	J	BEQ_cont.29639
BEQ_else.29638:
	ADDI	%r29, %r31, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 22(%r30)
	SW	%r1, 23(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 22(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 22(%r30)
	SW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	p_energy.2777
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 11(%r30)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	veccpy.2691
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 24(%r30)
	LW	%r2, 0(%r2)
	LW	%r3, 25(%r30)
	LW	%r3, 0(%r3)
	LW	%r26, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 26(%r30)
	LW	%r2, 0(%r1)
	LW	%r1, 13(%r30)
	LW	%r3, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29639:
	ADDI	%r1, %r0, 1
	LW	%r2, 22(%r30)
	SW	%r1, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r1)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29640
	LW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.29642
	J	BEQ_cont.29643
BEQ_else.29642:
	LW	%r1, 22(%r30)
	LW	%r2, 27(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29643:
	ADDI	%r2, %r0, 2
	LW	%r1, 22(%r30)
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29641
BEQ_else.29640:
BEQ_cont.29641:
	J	BEQ_cont.29637
BEQ_else.29636:
BEQ_cont.29637:
	J	BEQ_cont.29635
BEQ_else.29634:
	ADDI	%r3, %r0, 0
	LW	%r7, 6(%r30)
	LW	%r8, 5(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r5, %r8, 0
	ADDI	%r2, %r6, 0
	ADDI	%r6, %r3, 0
	ADDI	%r3, %r7, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29635:
	LW	%r1, 13(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29644
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29646
	J	BEQ_cont.29647
BEQ_else.29646:
	ADDI	%r1, %r0, 0
BEQ_cont.29647:
	J	BEQ_cont.29645
BEQ_else.29644:
	ADDI	%r1, %r0, 255
BEQ_cont.29645:
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	LWC1	%f1, 1(%r1)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29648
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29650
	J	BEQ_cont.29651
BEQ_else.29650:
	ADDI	%r1, %r0, 0
BEQ_cont.29651:
	J	BEQ_cont.29649
BEQ_else.29648:
	ADDI	%r1, %r0, 255
BEQ_cont.29649:
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	LWC1	%f1, 2(%r1)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.29652
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29654
	J	BEQ_cont.29655
BEQ_else.29654:
	ADDI	%r1, %r0, 0
BEQ_cont.29655:
	J	BEQ_cont.29653
BEQ_else.29652:
	ADDI	%r1, %r0, 255
BEQ_cont.29653:
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 1
	LW	%r2, 12(%r30)
	LW	%r3, 6(%r30)
	LW	%r4, 14(%r30)
	LW	%r5, 5(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29627:
	LW	%r1, 12(%r30)
	ADDI	%r2, %r1, 1
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, 2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29656
	ADDI	%r3, %r1, -5
	J	BEQ_cont.29657
BEQ_else.29656:
	ADDI	%r3, %r1, 0
BEQ_cont.29657:
	LW	%r1, 15(%r30)
	LW	%r4, 1(%r1)
	SLT	%r27, %r2, %r4
	BNE	%r27, %r0, BEQ_else.29658
	JR	%r31
BEQ_else.29658:
	LW	%r1, 1(%r1)
	ADDI	%r1, %r1, -1
	SW	%r3, 28(%r30)
	SW	%r2, 29(%r30)
	SLT	%r27, %r2, %r1
	BNE	%r27, %r0, BEQ_else.29660
	J	BEQ_cont.29661
BEQ_else.29660:
	ADDI	%r1, %r2, 1
	LW	%r4, 6(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29661:
	ADDI	%r1, %r0, 0
	LW	%r2, 29(%r30)
	LW	%r3, 14(%r30)
	LW	%r4, 5(%r30)
	LW	%r5, 6(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 29(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 28(%r30)
	ADDI	%r2, %r2, 2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29662
	ADDI	%r5, %r2, -5
	J	BEQ_cont.29663
BEQ_else.29662:
	ADDI	%r5, %r2, 0
BEQ_cont.29663:
	LW	%r2, 5(%r30)
	LW	%r3, 6(%r30)
	LW	%r4, 14(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
create_float5x3array.3094:
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r2, 0
	JR	%r31
create_pixel.3096:
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r0, 5
	ADDI	%r3, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r0, 1
	ADDI	%r3, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r2, 7(%r1)
	LW	%r2, 6(%r30)
	SW	%r2, 6(%r1)
	LW	%r2, 5(%r30)
	SW	%r2, 5(%r1)
	LW	%r2, 4(%r30)
	SW	%r2, 4(%r1)
	LW	%r2, 3(%r30)
	SW	%r2, 3(%r1)
	LW	%r2, 2(%r30)
	SW	%r2, 2(%r1)
	LW	%r2, 1(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 0(%r30)
	SW	%r2, 0(%r1)
	JR	%r31
init_line_elements.3098:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29664
	ADDI	%r3, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r0, 5
	ADDI	%r3, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r0, 1
	ADDI	%r3, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30)
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30)
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30)
	SW	%r1, 4(%r2)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r2, 7(%r1)
	LW	%r2, 8(%r30)
	SW	%r2, 6(%r1)
	LW	%r2, 7(%r30)
	SW	%r2, 5(%r1)
	LW	%r2, 6(%r30)
	SW	%r2, 4(%r1)
	LW	%r2, 5(%r30)
	SW	%r2, 3(%r1)
	LW	%r2, 4(%r30)
	SW	%r2, 2(%r1)
	LW	%r2, 3(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 2(%r30)
	SW	%r2, 0(%r1)
	LW	%r2, 0(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29665
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29666
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r1, 7(%r2)
	LW	%r1, 18(%r30)
	SW	%r1, 6(%r2)
	LW	%r1, 17(%r30)
	SW	%r1, 5(%r2)
	LW	%r1, 16(%r30)
	SW	%r1, 4(%r2)
	LW	%r1, 15(%r30)
	SW	%r1, 3(%r2)
	LW	%r1, 14(%r30)
	SW	%r1, 2(%r2)
	LW	%r1, 13(%r30)
	SW	%r1, 1(%r2)
	LW	%r1, 12(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 11(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29667
	SW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 19(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r1, %r3, 0
	J	init_line_elements.3098
BEQ_else.29667:
	ADDI	%r1, %r3, 0
	JR	%r31
BEQ_else.29666:
	ADDI	%r1, %r3, 0
	JR	%r31
BEQ_else.29665:
	ADDI	%r1, %r3, 0
	JR	%r31
BEQ_else.29664:
	JR	%r31
calc_sqrt.6353.7246.13329:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29668
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.7246.13329
BEQ_else.29668:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7246.13351:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29669
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.7246.13351
BEQ_else.29669:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.13404:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29670
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29671
	J	calc_sqrt.6353.13404
BEQ_else.29671:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.29670:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.13430:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29672
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29673
	J	calc_sqrt.6353.13430
BEQ_else.29673:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.29672:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.13456:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29674
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29675
	J	calc_sqrt.6353.13456
BEQ_else.29675:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.29674:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7233:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29676
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29677
	J	calc_sqrt.6353.7233
BEQ_else.29677:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.29676:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_dirvec.3108:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29678
	MUL.s	%f3, %f1, %f1
	MUL.s	%f4, %f2, %f2
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r4, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	C.le.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.29680
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.29682
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.29684
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	calc_sqrt.6353.7233
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29685
BEQ_else.29684:
	ADD.s	%f1, %f4, %f0
BEQ_cont.29685:
	J	BEQ_cont.29683
BEQ_else.29682:
	ADD.s	%f1, %f3, %f0
BEQ_cont.29683:
	J	BEQ_cont.29681
BEQ_else.29680:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29681:
	LWC1	%f2, 6(%r30)
	DIV.s	%f2, %f2, %f1
	LWC1	%f3, 4(%r30)
	DIV.s	%f3, %f3, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	DIV.s	%f1, %f4, %f1
	LW	%r1, 1(%r30)
	LW	%r2, 2(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 0(%r30)
	ADD	%r29, %r1, %r2
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SWC1	%f2, 0(%r3)
	SWC1	%f3, 1(%r3)
	SWC1	%f1, 2(%r3)
	ADDI	%r3, %r2, 40
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f3
	SWC1	%f2, 0(%r3)
	SWC1	%f1, 1(%r3)
	SWC1	%f4, 2(%r3)
	ADDI	%r3, %r2, 80
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f2
	SUB.s	%f5, %f0, %f3
	SWC1	%f1, 0(%r3)
	SWC1	%f4, 1(%r3)
	SWC1	%f5, 2(%r3)
	ADDI	%r3, %r2, 1
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f2
	SUB.s	%f5, %f0, %f3
	SUB.s	%f6, %f0, %f1
	SWC1	%f4, 0(%r3)
	SWC1	%f5, 1(%r3)
	SWC1	%f6, 2(%r3)
	ADDI	%r3, %r2, 41
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f2
	SUB.s	%f5, %f0, %f1
	SWC1	%f4, 0(%r3)
	SWC1	%f5, 1(%r3)
	SWC1	%f3, 2(%r3)
	ADDI	%r2, %r2, 81
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r1, 0(%r1)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 0(%r1)
	SWC1	%f2, 1(%r1)
	SWC1	%f3, 2(%r1)
	JR	%r31
BEQ_else.29678:
	MUL.s	%f1, %f2, %f2
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	SW	%r26, 8(%r30)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r4, 2(%r30)
	SWC1	%f4, 10(%r30)
	SW	%r1, 12(%r30)
	SWC1	%f3, 14(%r30)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29689
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29691
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f5, %f1, %f2
	ADD.s	%f5, %f2, %f5
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f2
	BNE	%r27, %r0, BEQ_else.29693
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	calc_sqrt.6353.13456
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29694
BEQ_else.29693:
	ADD.s	%f1, %f2, %f0
BEQ_cont.29694:
	J	BEQ_cont.29692
BEQ_else.29691:
BEQ_cont.29692:
	J	BEQ_cont.29690
BEQ_else.29689:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29690:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	atan.2634
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 18(%r30)
	C.le.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.29695
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29696
BEQ_else.29695:
	SUB.s	%f3, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.29696:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 18(%r30)
	SWC1	%f1, 20(%r30)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29697
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29698
BEQ_else.29697:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29698:
	LWC1	%f2, 20(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 16(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 12(%r30)
	ADDI	%r1, %r1, 1
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.22037
	LWC1	%f3, 0(%r29)
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 22(%r30)
	SW	%r1, 24(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29699
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29701
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.29703
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	calc_sqrt.6353.13430
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29704
BEQ_else.29703:
	ADD.s	%f1, %f3, %f0
BEQ_cont.29704:
	J	BEQ_cont.29702
BEQ_else.29701:
	ADD.s	%f1, %f2, %f0
BEQ_cont.29702:
	J	BEQ_cont.29700
BEQ_else.29699:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29700:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	atan.2634
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 28(%r30)
	C.le.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.29706
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29707
BEQ_else.29706:
	SUB.s	%f3, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.29707:
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 28(%r30)
	SWC1	%f1, 30(%r30)
	C.le.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29708
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29709
BEQ_else.29708:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29709:
	LWC1	%f2, 30(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 24(%r30)
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29710
	LWC1	%f2, 22(%r30)
	MUL.s	%f3, %f2, %f2
	MUL.s	%f4, %f1, %f1
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	SWC1	%f1, 32(%r30)
	C.le.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.29711
	LA	%r29, l.20767
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.29713
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.20771
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.29715
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	calc_sqrt.6353.13404
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29716
BEQ_else.29715:
	ADD.s	%f1, %f4, %f0
BEQ_cont.29716:
	J	BEQ_cont.29714
BEQ_else.29713:
	ADD.s	%f1, %f3, %f0
BEQ_cont.29714:
	J	BEQ_cont.29712
BEQ_else.29711:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29712:
	LWC1	%f2, 22(%r30)
	DIV.s	%f2, %f2, %f1
	LWC1	%f3, 32(%r30)
	DIV.s	%f3, %f3, %f1
	LA	%r29, l.20768
	LWC1	%f4, 0(%r29)
	DIV.s	%f1, %f4, %f1
	LW	%r1, 1(%r30)
	LW	%r2, 2(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 0(%r30)
	ADD	%r29, %r1, %r2
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SWC1	%f2, 0(%r3)
	SWC1	%f3, 1(%r3)
	SWC1	%f1, 2(%r3)
	ADDI	%r3, %r2, 40
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f3
	SWC1	%f2, 0(%r3)
	SWC1	%f1, 1(%r3)
	SWC1	%f4, 2(%r3)
	ADDI	%r3, %r2, 80
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f2
	SUB.s	%f5, %f0, %f3
	SWC1	%f1, 0(%r3)
	SWC1	%f4, 1(%r3)
	SWC1	%f5, 2(%r3)
	ADDI	%r3, %r2, 1
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f2
	SUB.s	%f5, %f0, %f3
	SUB.s	%f6, %f0, %f1
	SWC1	%f4, 0(%r3)
	SWC1	%f5, 1(%r3)
	SWC1	%f6, 2(%r3)
	ADDI	%r3, %r2, 41
	ADD	%r29, %r1, %r3
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	SUB.s	%f4, %f0, %f2
	SUB.s	%f5, %f0, %f1
	SWC1	%f4, 0(%r3)
	SWC1	%f5, 1(%r3)
	SWC1	%f3, 2(%r3)
	ADDI	%r2, %r2, 81
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r1, 0(%r1)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 0(%r1)
	SWC1	%f2, 1(%r1)
	SWC1	%f3, 2(%r1)
	JR	%r31
BEQ_else.29710:
	MUL.s	%f1, %f1, %f1
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29718
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29720
	LA	%r29, l.20771
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	calc_sqrt.6353.7246.13351
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29721
BEQ_else.29720:
BEQ_cont.29721:
	J	BEQ_cont.29719
BEQ_else.29718:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29719:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	atan.2634
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 36(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	sin.2632
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 36(%r30)
	SWC1	%f1, 38(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	cos.2630
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 38(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 24(%r30)
	ADDI	%r1, %r1, 1
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.22037
	LWC1	%f3, 0(%r29)
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 40(%r30)
	SW	%r1, 42(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29722
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29724
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 43(%r30)
	ADDI	%r30, %r30, 44
	JAL	calc_sqrt.6353.7246.13329
	ADDI	%r29, %r0, 44
	SUB	%r30, %r30, %r29
	LW	%r29, 43(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29725
BEQ_else.29724:
	ADD.s	%f1, %f2, %f0
BEQ_cont.29725:
	J	BEQ_cont.29723
BEQ_else.29722:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29723:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	atan.2634
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	sin.2632
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 46(%r30)
	SWC1	%f1, 48(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	cos.2630
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 48(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 44(%r30)
	MUL.s	%f2, %f1, %f2
	LWC1	%f1, 40(%r30)
	LWC1	%f3, 14(%r30)
	LWC1	%f4, 10(%r30)
	LW	%r1, 42(%r30)
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 8(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
calc_sqrt.6353.7246.13307:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29727
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.7246.13307
BEQ_else.29727:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7246.13263:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29728
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.7246.13263
BEQ_else.29728:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7246.13241:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29729
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.7246.13241
BEQ_else.29729:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7246.13285:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.29730
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353.7246.13285
BEQ_else.29730:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_dirvecs.3116:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29731
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r4, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22869
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	LA	%r29, l.21806
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	calc_sqrt.6353.7246.13307
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	atan.2634
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	sin.2632
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	cos.2630
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 1
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.22037
	LWC1	%f3, 0(%r29)
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 16(%r30)
	SW	%r1, 18(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29733
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29735
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	calc_sqrt.6353.7246.13285
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29736
BEQ_else.29735:
	ADD.s	%f1, %f2, %f0
BEQ_cont.29736:
	J	BEQ_cont.29734
BEQ_else.29733:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29734:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	atan.2634
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	sin.2632
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 22(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	cos.2630
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 20(%r30)
	MUL.s	%f2, %f1, %f2
	LWC1	%f1, 16(%r30)
	LWC1	%f3, 8(%r30)
	LWC1	%f4, 6(%r30)
	LW	%r1, 18(%r30)
	LW	%r2, 3(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r1, 2(%r30)
	ADDI	%r2, %r1, 2
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	LA	%r29, l.21806
	LWC1	%f3, 0(%r29)
	SW	%r2, 26(%r30)
	SWC1	%f1, 28(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	calc_sqrt.6353.7246.13263
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	atan.2634
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	sin.2632
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	SWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	cos.2630
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 30(%r30)
	MUL.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 1
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.22037
	LWC1	%f3, 0(%r29)
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 36(%r30)
	SW	%r1, 38(%r30)
	C.le.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29739
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.29741
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	JAL	calc_sqrt.6353.7246.13241
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29742
BEQ_else.29741:
	ADD.s	%f1, %f2, %f0
BEQ_cont.29742:
	J	BEQ_cont.29740
BEQ_else.29739:
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
BEQ_cont.29740:
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	atan.2634
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	sin.2632
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 42(%r30)
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	cos.2630
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 44(%r30)
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 40(%r30)
	MUL.s	%f2, %f1, %f2
	LWC1	%f1, 36(%r30)
	LWC1	%f3, 28(%r30)
	LWC1	%f4, 6(%r30)
	LW	%r1, 38(%r30)
	LW	%r2, 3(%r30)
	LW	%r3, 26(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, -1
	LW	%r2, 3(%r30)
	ADDI	%r2, %r2, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29744
	ADDI	%r2, %r2, -5
	J	BEQ_cont.29745
BEQ_else.29744:
BEQ_cont.29745:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29746
	SW	%r1, 46(%r30)
	SW	%r2, 47(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22869
	LWC1	%f2, 0(%r29)
	SUB.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f4, 6(%r30)
	LW	%r2, 47(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	ADD.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LW	%r2, 2(%r30)
	ADDI	%r3, %r2, 2
	LWC1	%f4, 6(%r30)
	LW	%r4, 47(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 46(%r30)
	ADDI	%r1, %r1, -1
	LW	%r2, 47(%r30)
	ADDI	%r2, %r2, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29747
	ADDI	%r2, %r2, -5
	J	BEQ_cont.29748
BEQ_else.29747:
BEQ_cont.29748:
	LWC1	%f1, 6(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29746:
	JR	%r31
BEQ_else.29731:
	JR	%r31
calc_dirvec_rows.3121:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29751
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r3, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r5, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22869
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 4
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22869
	LWC1	%f2, 0(%r29)
	SUB.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LWC1	%f4, 8(%r30)
	LW	%r2, 4(%r30)
	LW	%r3, 3(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22037
	LWC1	%f2, 0(%r29)
	ADD.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	LA	%r29, l.20767
	LWC1	%f2, 0(%r29)
	LW	%r2, 3(%r30)
	ADDI	%r3, %r2, 2
	LWC1	%f4, 8(%r30)
	LW	%r4, 4(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r2, 4(%r30)
	ADDI	%r3, %r2, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29753
	ADDI	%r3, %r3, -5
	J	BEQ_cont.29754
BEQ_else.29753:
BEQ_cont.29754:
	LWC1	%f1, 8(%r30)
	LW	%r4, 3(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, -1
	LW	%r2, 4(%r30)
	ADDI	%r2, %r2, 2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29755
	ADDI	%r2, %r2, -5
	J	BEQ_cont.29756
BEQ_else.29755:
BEQ_cont.29756:
	LW	%r3, 3(%r30)
	ADDI	%r3, %r3, 4
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29757
	SW	%r1, 10(%r30)
	SW	%r3, 11(%r30)
	SW	%r2, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22869
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 4
	LW	%r2, 12(%r30)
	LW	%r3, 11(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, -1
	LW	%r2, 12(%r30)
	ADDI	%r2, %r2, 2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29758
	ADDI	%r2, %r2, -5
	J	BEQ_cont.29759
BEQ_else.29758:
BEQ_cont.29759:
	LW	%r3, 11(%r30)
	ADDI	%r3, %r3, 4
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29757:
	JR	%r31
BEQ_else.29751:
	JR	%r31
create_dirvec.3125:
	LW	%r1, 1(%r26)
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	LW	%r1, 0(%r1)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 1(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	JR	%r31
create_dirvec_elements.3127:
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29762
	ADDI	%r5, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r2, 2(%r30)
	SW	%r1, 3(%r30)
	SW	%r3, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 5(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 2(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29763
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 7(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 6(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29764
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r1, 0(%r1)
	SW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 9(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 8(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29765
	LW	%r26, 1(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	LW	%r26, 0(%r30)
	ADDI	%r1, %r3, 0
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29765:
	JR	%r31
BEQ_else.29764:
	JR	%r31
BEQ_else.29763:
	JR	%r31
BEQ_else.29762:
	JR	%r31
create_dirvecs.3130:
	LW	%r2, 4(%r26)
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29770
	ADDI	%r6, %r0, 120
	ADDI	%r7, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r1, 3(%r30)
	SW	%r3, 4(%r30)
	SW	%r6, 5(%r30)
	SW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 7(%r30)
	SW	%r1, 0(%r2)
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	ADDI	%r4, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 9(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 8(%r30)
	SW	%r1, 118(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 10(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 8(%r30)
	SW	%r1, 117(%r2)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	SW	%r1, 116(%r2)
	ADDI	%r1, %r0, 115
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29771
	ADDI	%r2, %r0, 120
	ADDI	%r3, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 11(%r30)
	SW	%r2, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 13(%r30)
	SW	%r1, 0(%r2)
	LW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 11(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	ADDI	%r4, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 15(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 15(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 14(%r30)
	SW	%r1, 118(%r2)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 14(%r30)
	SW	%r1, 117(%r2)
	ADDI	%r1, %r0, 116
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29772
	ADDI	%r2, %r0, 120
	ADDI	%r3, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 16(%r30)
	SW	%r2, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r1, 0(%r1)
	SW	%r2, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 18(%r30)
	SW	%r1, 0(%r2)
	LW	%r1, 17(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 16(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	LW	%r26, 2(%r30)
	SW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 19(%r30)
	SW	%r1, 118(%r2)
	ADDI	%r1, %r0, 117
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29773
	ADDI	%r2, %r0, 120
	LW	%r26, 2(%r30)
	SW	%r1, 20(%r30)
	SW	%r2, 21(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 21(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	ADDI	%r3, %r0, 118
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	ADDI	%r1, %r1, -1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29773:
	JR	%r31
BEQ_else.29772:
	JR	%r31
BEQ_else.29771:
	JR	%r31
BEQ_else.29770:
	JR	%r31
init_dirvec_constants.3132:
	LW	%r3, 4(%r26)
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29778
	ADD	%r29, %r1, %r2
	LW	%r7, 0(%r29)
	LW	%r8, 0(%r5)
	ADDI	%r8, %r8, -1
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r6, 2(%r30)
	SW	%r4, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r8, 0
	ADDI	%r1, %r7, 0
	ADDI	%r26, %r6, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29779
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 4(%r30)
	LW	%r5, 0(%r4)
	ADDI	%r5, %r5, -1
	SW	%r1, 7(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r5, %r27
	BNE	%r27, %r0, BEQ_else.29780
	LW	%r6, 3(%r30)
	ADD	%r29, %r6, %r5
	LW	%r6, 0(%r29)
	SW	%r5, 8(%r30)
	SW	%r6, 9(%r30)
	SW	%r3, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	d_const.2790
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	d_vec.2788
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30)
	SW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	o_form.2729
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.29782
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.29783
BEQ_else.29782:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.29784
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.29785
BEQ_else.29784:
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.29785:
BEQ_cont.29783:
	ADDI	%r2, %r2, -1
	LW	%r1, 10(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29781
BEQ_else.29780:
BEQ_cont.29781:
	LW	%r1, 7(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29786
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 4(%r30)
	LW	%r4, 0(%r4)
	ADDI	%r4, %r4, -1
	LW	%r26, 2(%r30)
	SW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29787
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r26, 1(%r30)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	ADDI	%r2, %r1, -1
	LW	%r1, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29787:
	JR	%r31
BEQ_else.29786:
	JR	%r31
BEQ_else.29779:
	JR	%r31
BEQ_else.29778:
	JR	%r31
init_vecset_constants.3135:
	LW	%r2, 6(%r26)
	LW	%r3, 5(%r26)
	LW	%r4, 4(%r26)
	LW	%r5, 3(%r26)
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29792
	ADD	%r29, %r7, %r1
	LW	%r8, 0(%r29)
	LW	%r9, 119(%r8)
	LW	%r10, 0(%r4)
	ADDI	%r10, %r10, -1
	SW	%r26, 0(%r30)
	SW	%r7, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r6, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r5, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r8, 7(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r10, %r27
	BNE	%r27, %r0, BEQ_else.29793
	ADD	%r29, %r3, %r10
	LW	%r3, 0(%r29)
	SW	%r10, 8(%r30)
	SW	%r3, 9(%r30)
	SW	%r9, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r9, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	d_const.2790
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 10(%r30)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	d_vec.2788
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30)
	SW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	o_form.2729
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.29795
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.29796
BEQ_else.29795:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.29797
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.29798
BEQ_else.29797:
	LW	%r1, 12(%r30)
	LW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LW	%r3, 11(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.29798:
BEQ_cont.29796:
	ADDI	%r2, %r2, -1
	LW	%r1, 10(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29794
BEQ_else.29793:
BEQ_cont.29794:
	LW	%r1, 7(%r30)
	LW	%r2, 118(%r1)
	LW	%r3, 6(%r30)
	LW	%r4, 0(%r3)
	ADDI	%r4, %r4, -1
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	LW	%r2, 117(%r1)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 116
	LW	%r1, 7(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29799
	LW	%r2, 1(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 119(%r3)
	LW	%r5, 6(%r30)
	LW	%r5, 0(%r5)
	ADDI	%r5, %r5, -1
	LW	%r26, 5(%r30)
	SW	%r1, 13(%r30)
	SW	%r3, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LW	%r2, 118(%r1)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 117
	LW	%r1, 14(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29800
	LW	%r2, 1(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 119(%r3)
	LW	%r26, 4(%r30)
	SW	%r1, 15(%r30)
	SW	%r3, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 118
	LW	%r1, 16(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 15(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29801
	LW	%r2, 1(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 119
	LW	%r26, 3(%r30)
	SW	%r1, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 17(%r30)
	ADDI	%r1, %r1, -1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.29801:
	JR	%r31
BEQ_else.29800:
	JR	%r31
BEQ_else.29799:
	JR	%r31
BEQ_else.29792:
	JR	%r31
setup_reflections.3152:
	LW	%r2, 6(%r26)
	LW	%r3, 5(%r26)
	LW	%r4, 4(%r26)
	LW	%r5, 3(%r26)
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.29806
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	LW	%r8, 2(%r3)
	ADDI	%r27, %r0, 2
	BNE	%r8, %r27, BEQ_else.29807
	LW	%r8, 7(%r3)
	LWC1	%f1, 0(%r8)
	LA	%r29, l.20768
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.29808
	ADDI	%r8, %r0, 0
	J	BEQ_cont.29809
BEQ_else.29808:
	ADDI	%r8, %r0, 1
BEQ_cont.29809:
	ADDI	%r27, %r0, 0
	BNE	%r8, %r27, BEQ_else.29810
	JR	%r31
BEQ_else.29810:
	LW	%r8, 1(%r3)
	ADDI	%r27, %r0, 1
	BNE	%r8, %r27, BEQ_else.29812
	SLL	%r1, %r1, 2
	LW	%r8, 0(%r4)
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LW	%r3, 7(%r3)
	LWC1	%f2, 0(%r3)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 0(%r6)
	SUB.s	%f2, %f0, %f2
	LWC1	%f3, 1(%r6)
	SUB.s	%f3, %f0, %f3
	LWC1	%f4, 2(%r6)
	SUB.s	%f4, %f0, %f4
	ADDI	%r3, %r1, 1
	LWC1	%f5, 0(%r6)
	ADDI	%r9, %r0, 3
	LA	%r29, l.20767
	LWC1	%f6, 0(%r29)
	SW	%r4, 0(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r6, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r8, 6(%r30)
	SW	%r2, 7(%r30)
	SW	%r3, 8(%r30)
	SWC1	%f1, 10(%r30)
	SW	%r7, 12(%r30)
	SWC1	%f4, 14(%r30)
	SWC1	%f3, 16(%r30)
	SWC1	%f5, 18(%r30)
	SW	%r5, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r9, 0
	ADD.s	%f1, %f6, %f0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 21(%r30)
	SW	%r1, 0(%r2)
	LWC1	%f1, 18(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f2, 14(%r30)
	SWC1	%f2, 2(%r1)
	LW	%r1, 20(%r30)
	LW	%r3, 0(%r1)
	ADDI	%r3, %r3, -1
	LW	%r26, 12(%r30)
	SW	%r2, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 10(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 22(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 8(%r30)
	SW	%r2, 0(%r1)
	LW	%r2, 6(%r30)
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r4, 5(%r30)
	ADDI	%r5, %r4, 2
	LW	%r6, 4(%r30)
	LWC1	%f2, 1(%r6)
	ADDI	%r7, %r0, 3
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r1, 23(%r30)
	SW	%r5, 24(%r30)
	SWC1	%f2, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 28(%r30)
	SW	%r1, 0(%r2)
	LWC1	%f1, 2(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f2, 26(%r30)
	SWC1	%f2, 1(%r1)
	LWC1	%f2, 14(%r30)
	SWC1	%f2, 2(%r1)
	LW	%r1, 20(%r30)
	LW	%r3, 0(%r1)
	ADDI	%r3, %r3, -1
	LW	%r26, 12(%r30)
	SW	%r2, 29(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 10(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 29(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 24(%r30)
	SW	%r2, 0(%r1)
	LW	%r2, 23(%r30)
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 6(%r30)
	ADDI	%r2, %r1, 2
	LW	%r4, 5(%r30)
	ADDI	%r4, %r4, 3
	LW	%r5, 4(%r30)
	LWC1	%f2, 2(%r5)
	ADDI	%r5, %r0, 3
	LA	%r29, l.20767
	LWC1	%f3, 0(%r29)
	SW	%r2, 30(%r30)
	SW	%r4, 31(%r30)
	SWC1	%f2, 32(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 34(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 35(%r30)
	ADDI	%r30, %r30, 36
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 36
	SUB	%r30, %r30, %r29
	LW	%r29, 35(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 34(%r30)
	SW	%r1, 0(%r2)
	LWC1	%f1, 2(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 32(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r1, 20(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LW	%r26, 12(%r30)
	SW	%r2, 35(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 10(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 35(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 31(%r30)
	SW	%r2, 0(%r1)
	LW	%r2, 30(%r30)
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 6(%r30)
	ADDI	%r1, %r1, 3
	LW	%r2, 0(%r30)
	SW	%r1, 0(%r2)
	JR	%r31
BEQ_else.29812:
	ADDI	%r27, %r0, 2
	BNE	%r8, %r27, BEQ_else.29818
	SLL	%r1, %r1, 2
	ADDI	%r1, %r1, 1
	LW	%r8, 0(%r4)
	LA	%r29, l.20768
	LWC1	%f1, 0(%r29)
	LW	%r9, 7(%r3)
	LWC1	%f2, 0(%r9)
	SUB.s	%f1, %f1, %f2
	LW	%r9, 4(%r3)
	LWC1	%f2, 0(%r6)
	LWC1	%f3, 0(%r9)
	MUL.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r6)
	LWC1	%f4, 1(%r9)
	MUL.s	%f3, %f3, %f4
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r6)
	LWC1	%f4, 2(%r9)
	MUL.s	%f3, %f3, %f4
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.20771
	LWC1	%f3, 0(%r29)
	LW	%r9, 4(%r3)
	LWC1	%f4, 0(%r9)
	MUL.s	%f3, %f3, %f4
	MUL.s	%f3, %f3, %f2
	LWC1	%f4, 0(%r6)
	SUB.s	%f3, %f3, %f4
	LA	%r29, l.20771
	LWC1	%f4, 0(%r29)
	LW	%r9, 4(%r3)
	LWC1	%f5, 1(%r9)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f4, %f4, %f2
	LWC1	%f5, 1(%r6)
	SUB.s	%f4, %f4, %f5
	LA	%r29, l.20771
	LWC1	%f5, 0(%r29)
	LW	%r3, 4(%r3)
	LWC1	%f6, 2(%r3)
	MUL.s	%f5, %f5, %f6
	MUL.s	%f2, %f5, %f2
	LWC1	%f5, 2(%r6)
	SUB.s	%f2, %f2, %f5
	ADDI	%r3, %r0, 3
	LA	%r29, l.20767
	LWC1	%f5, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r8, 36(%r30)
	SW	%r2, 7(%r30)
	SW	%r1, 37(%r30)
	SWC1	%f1, 38(%r30)
	SW	%r7, 12(%r30)
	SWC1	%f2, 40(%r30)
	SWC1	%f4, 42(%r30)
	SWC1	%f3, 44(%r30)
	SW	%r5, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30)
	LW	%r3, 0(%r1)
	SW	%r2, 46(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 47(%r30)
	ADDI	%r30, %r30, 48
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 48
	SUB	%r30, %r30, %r29
	LW	%r29, 47(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 46(%r30)
	SW	%r1, 0(%r2)
	LWC1	%f1, 44(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 42(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 40(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r1, 20(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LW	%r26, 12(%r30)
	SW	%r2, 47(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 38(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 47(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 37(%r30)
	SW	%r2, 0(%r1)
	LW	%r2, 36(%r30)
	LW	%r3, 7(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r2, 0(%r30)
	SW	%r1, 0(%r2)
	JR	%r31
BEQ_else.29818:
	JR	%r31
BEQ_else.29807:
	JR	%r31
BEQ_else.29806:
	JR	%r31
_min_caml_start: # main entry point
	SUB	%r0, %r0, %r0
	ADDI	%r28, %r0, 8192
   # main program start
	ADDI	%r1, %r0, 32
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 32
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r3, int_of_float.2622
	SW	%r3, 0(%r2)
	LW	%r3, 0(%r30)
	SW	%r3, 2(%r2)
	SW	%r1, 1(%r2)
	ADDI	%r4, %r0, 1
	ADDI	%r5, %r0, 0
	SW	%r2, 1(%r30)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 60
	ADDI	%r3, %r0, 0
	ADDI	%r4, %r0, 0
	ADDI	%r5, %r0, 0
	ADDI	%r6, %r0, 0
	ADDI	%r7, %r0, 0
	ADDI	%r8, %r28, 0
	ADDI	%r28, %r28, 11
	SW	%r1, 10(%r8)
	SW	%r1, 9(%r8)
	SW	%r1, 8(%r8)
	SW	%r1, 7(%r8)
	SW	%r7, 6(%r8)
	SW	%r1, 5(%r8)
	SW	%r1, 4(%r8)
	SW	%r6, 3(%r8)
	SW	%r5, 2(%r8)
	SW	%r4, 1(%r8)
	SW	%r3, 0(%r8)
	ADDI	%r1, %r8, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.21790
	LWC1	%f1, 0(%r29)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 50
	ADDI	%r3, %r0, 1
	ADDI	%r4, %r0, -1
	SW	%r1, 8(%r30)
	SW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 1
	LW	%r4, 0(%r1)
	SW	%r1, 10(%r30)
	SW	%r2, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.21812
	LWC1	%f1, 0(%r29)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 2
	ADDI	%r3, %r0, 0
	SW	%r1, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 2
	ADDI	%r3, %r0, 0
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 23(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 27(%r30)
	ADDI	%r30, %r30, 28
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 29(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 30(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	SW	%r2, 31(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r3)
	LW	%r1, 31(%r30)
	SW	%r1, 0(%r3)
	ADDI	%r1, %r3, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 32(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 33(%r30)
	ADDI	%r30, %r30, 34
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 60
	LW	%r3, 33(%r30)
	SW	%r1, 34(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 35(%r30)
	ADDI	%r30, %r30, 36
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 36
	SUB	%r30, %r30, %r29
	LW	%r29, 35(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r3, 34(%r30)
	SW	%r3, 0(%r2)
	ADDI	%r4, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 35(%r30)
	SW	%r2, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	SW	%r2, 37(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 37(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r0, 180
	ADDI	%r3, %r0, 0
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	ADDI	%r4, %r28, 0
	ADDI	%r28, %r28, 3
	SWC1	%f1, 2(%r4)
	SW	%r1, 1(%r4)
	SW	%r3, 0(%r4)
	ADDI	%r1, %r4, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 38(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r3, read_screen_settings.2800
	SW	%r3, 0(%r2)
	LW	%r3, 6(%r30)
	SW	%r3, 5(%r2)
	LW	%r4, 29(%r30)
	SW	%r4, 4(%r2)
	LW	%r5, 28(%r30)
	SW	%r5, 3(%r2)
	LW	%r6, 27(%r30)
	SW	%r6, 2(%r2)
	LW	%r7, 5(%r30)
	SW	%r7, 1(%r2)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r8, read_nth_object.2807
	SW	%r8, 0(%r7)
	LW	%r8, 4(%r30)
	SW	%r8, 1(%r7)
	ADDI	%r9, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r10, read_object.2809
	SW	%r10, 0(%r9)
	SW	%r7, 2(%r9)
	LW	%r7, 3(%r30)
	SW	%r7, 1(%r9)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r11, read_and_network.2817
	SW	%r11, 0(%r10)
	LW	%r11, 10(%r30)
	SW	%r11, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r13, solver_rect.2830
	SW	%r13, 0(%r12)
	LW	%r13, 13(%r30)
	SW	%r13, 1(%r12)
	ADDI	%r14, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r15, solver_second.2855
	SW	%r15, 0(%r14)
	SW	%r13, 1(%r14)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r16, solver.2861
	SW	%r16, 0(%r15)
	SW	%r13, 2(%r15)
	SW	%r8, 1(%r15)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, solver_rect_fast.2865
	SW	%r17, 0(%r16)
	SW	%r13, 1(%r16)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r18, solver_second_fast.2878
	SW	%r18, 0(%r17)
	SW	%r13, 1(%r17)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r19, solver_fast.2884
	SW	%r19, 0(%r18)
	SW	%r16, 3(%r18)
	SW	%r13, 2(%r18)
	SW	%r8, 1(%r18)
	ADDI	%r19, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r20, solver_second_fast2.2895
	SW	%r20, 0(%r19)
	SW	%r13, 1(%r19)
	ADDI	%r20, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r21, solver_fast2.2902
	SW	%r21, 0(%r20)
	SW	%r16, 3(%r20)
	SW	%r13, 2(%r20)
	SW	%r8, 1(%r20)
	ADDI	%r21, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r22, iter_setup_dirvec_constants.2914
	SW	%r22, 0(%r21)
	SW	%r8, 1(%r21)
	ADDI	%r22, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r23, setup_dirvec_constants.2917
	SW	%r23, 0(%r22)
	SW	%r8, 3(%r22)
	SW	%r7, 2(%r22)
	SW	%r21, 1(%r22)
	ADDI	%r23, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r24, setup_startp_constants.2919
	SW	%r24, 0(%r23)
	SW	%r8, 1(%r23)
	ADDI	%r24, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r25, setup_startp.2922
	SW	%r25, 0(%r24)
	LW	%r25, 26(%r30)
	SW	%r25, 4(%r24)
	SW	%r23, 3(%r24)
	SW	%r8, 2(%r24)
	SW	%r7, 1(%r24)
	ADDI	%r26, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r10, 39(%r30)
	LA	%r10, check_all_inside.2944
	SW	%r10, 0(%r26)
	SW	%r8, 1(%r26)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 12
	SW	%r9, 40(%r30)
	LA	%r9, shadow_check_and_group.2950
	SW	%r9, 0(%r10)
	LW	%r9, 34(%r30)
	SW	%r9, 11(%r10)
	SW	%r17, 10(%r10)
	SW	%r16, 9(%r10)
	SW	%r18, 8(%r10)
	SW	%r13, 7(%r10)
	SW	%r8, 6(%r10)
	SW	%r2, 41(%r30)
	LW	%r2, 36(%r30)
	SW	%r2, 5(%r10)
	SW	%r21, 42(%r30)
	LW	%r21, 7(%r30)
	SW	%r21, 4(%r10)
	SW	%r22, 43(%r30)
	LW	%r22, 16(%r30)
	SW	%r22, 3(%r10)
	LW	%r5, 35(%r30)
	SW	%r5, 2(%r10)
	SW	%r26, 1(%r10)
	ADDI	%r4, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r6, shadow_check_one_or_group.2953
	SW	%r6, 0(%r4)
	SW	%r18, 9(%r4)
	SW	%r13, 8(%r4)
	SW	%r10, 7(%r4)
	SW	%r8, 6(%r4)
	SW	%r2, 5(%r4)
	SW	%r21, 4(%r4)
	SW	%r22, 3(%r4)
	SW	%r26, 2(%r4)
	SW	%r11, 1(%r4)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 13
	LA	%r3, shadow_check_one_or_matrix.2956
	SW	%r3, 0(%r6)
	SW	%r9, 12(%r6)
	SW	%r17, 11(%r6)
	SW	%r16, 10(%r6)
	SW	%r18, 9(%r6)
	SW	%r13, 8(%r6)
	SW	%r4, 7(%r6)
	SW	%r10, 6(%r6)
	SW	%r8, 5(%r6)
	SW	%r2, 4(%r6)
	SW	%r22, 3(%r6)
	SW	%r5, 2(%r6)
	SW	%r11, 1(%r6)
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 11
	LA	%r5, solve_each_element.2959
	SW	%r5, 0(%r3)
	LW	%r5, 15(%r30)
	SW	%r5, 10(%r3)
	LW	%r10, 25(%r30)
	SW	%r10, 9(%r3)
	SW	%r14, 8(%r3)
	SW	%r12, 7(%r3)
	SW	%r13, 6(%r3)
	SW	%r8, 5(%r3)
	LW	%r17, 14(%r30)
	SW	%r17, 4(%r3)
	SW	%r22, 3(%r3)
	LW	%r9, 17(%r30)
	SW	%r9, 2(%r3)
	SW	%r26, 1(%r3)
	SW	%r24, 44(%r30)
	ADDI	%r24, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r21, solve_one_or_network.2963
	SW	%r21, 0(%r24)
	SW	%r3, 2(%r24)
	SW	%r11, 1(%r24)
	ADDI	%r21, %r28, 0
	ADDI	%r28, %r28, 11
	LA	%r7, trace_or_matrix.2967
	SW	%r7, 0(%r21)
	SW	%r5, 10(%r21)
	SW	%r10, 9(%r21)
	SW	%r14, 8(%r21)
	SW	%r12, 7(%r21)
	SW	%r13, 6(%r21)
	SW	%r15, 5(%r21)
	SW	%r24, 4(%r21)
	SW	%r3, 3(%r21)
	SW	%r8, 2(%r21)
	SW	%r11, 1(%r21)
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 11
	LA	%r7, solve_each_element_fast.2973
	SW	%r7, 0(%r3)
	SW	%r5, 10(%r3)
	SW	%r25, 9(%r3)
	SW	%r19, 8(%r3)
	SW	%r16, 7(%r3)
	SW	%r13, 6(%r3)
	SW	%r8, 5(%r3)
	SW	%r17, 4(%r3)
	SW	%r22, 3(%r3)
	SW	%r9, 2(%r3)
	SW	%r26, 1(%r3)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r12, solve_one_or_network_fast.2977
	SW	%r12, 0(%r7)
	SW	%r3, 2(%r7)
	SW	%r11, 1(%r7)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r14, trace_or_matrix_fast.2981
	SW	%r14, 0(%r12)
	SW	%r5, 9(%r12)
	SW	%r19, 8(%r12)
	SW	%r16, 7(%r12)
	SW	%r20, 6(%r12)
	SW	%r13, 5(%r12)
	SW	%r7, 4(%r12)
	SW	%r3, 3(%r12)
	SW	%r8, 2(%r12)
	SW	%r11, 1(%r12)
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r14, get_nvector_second.2991
	SW	%r14, 0(%r3)
	LW	%r14, 18(%r30)
	SW	%r14, 2(%r3)
	SW	%r22, 1(%r3)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, utexture.2996
	SW	%r16, 0(%r15)
	LW	%r16, 19(%r30)
	SW	%r16, 1(%r15)
	ADDI	%r19, %r28, 0
	ADDI	%r28, %r28, 18
	LA	%r24, trace_reflections.3003
	SW	%r24, 0(%r19)
	SW	%r12, 17(%r19)
	SW	%r5, 16(%r19)
	SW	%r16, 15(%r19)
	SW	%r20, 14(%r19)
	SW	%r18, 13(%r19)
	SW	%r13, 12(%r19)
	SW	%r7, 11(%r19)
	SW	%r6, 10(%r19)
	SW	%r4, 9(%r19)
	LW	%r24, 21(%r30)
	SW	%r24, 8(%r19)
	LW	%r26, 38(%r30)
	SW	%r26, 7(%r19)
	LW	%r11, 12(%r30)
	SW	%r11, 6(%r19)
	SW	%r14, 5(%r19)
	SW	%r2, 4(%r19)
	SW	%r17, 3(%r19)
	SW	%r22, 2(%r19)
	SW	%r9, 1(%r19)
	SW	%r3, 45(%r30)
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 30
	LA	%r9, trace_ray.3008
	SW	%r9, 0(%r3)
	SW	%r15, 29(%r3)
	SW	%r19, 28(%r3)
	SW	%r12, 27(%r3)
	SW	%r21, 26(%r3)
	SW	%r5, 25(%r3)
	SW	%r16, 24(%r3)
	SW	%r25, 23(%r3)
	SW	%r10, 22(%r3)
	SW	%r20, 21(%r3)
	SW	%r18, 20(%r3)
	SW	%r13, 19(%r3)
	SW	%r7, 18(%r3)
	SW	%r6, 17(%r3)
	SW	%r4, 16(%r3)
	SW	%r23, 15(%r3)
	SW	%r24, 14(%r3)
	SW	%r26, 13(%r3)
	SW	%r11, 12(%r3)
	SW	%r8, 11(%r3)
	SW	%r14, 10(%r3)
	SW	%r1, 9(%r3)
	LW	%r9, 3(%r30)
	SW	%r9, 8(%r3)
	SW	%r2, 7(%r3)
	LW	%r19, 7(%r30)
	SW	%r19, 6(%r3)
	SW	%r17, 5(%r3)
	SW	%r22, 4(%r3)
	LW	%r21, 17(%r30)
	SW	%r21, 3(%r3)
	SW	%r1, 46(%r30)
	LW	%r1, 45(%r30)
	SW	%r1, 2(%r3)
	LW	%r26, 8(%r30)
	SW	%r26, 1(%r3)
	ADDI	%r26, %r28, 0
	ADDI	%r28, %r28, 19
	LA	%r10, trace_diffuse_ray.3014
	SW	%r10, 0(%r26)
	SW	%r15, 18(%r26)
	SW	%r12, 17(%r26)
	SW	%r5, 16(%r26)
	SW	%r16, 15(%r26)
	SW	%r18, 14(%r26)
	SW	%r13, 13(%r26)
	SW	%r6, 12(%r26)
	SW	%r4, 11(%r26)
	SW	%r11, 10(%r26)
	SW	%r8, 9(%r26)
	SW	%r14, 8(%r26)
	SW	%r2, 7(%r26)
	SW	%r19, 6(%r26)
	SW	%r17, 5(%r26)
	SW	%r22, 4(%r26)
	SW	%r21, 3(%r26)
	SW	%r1, 2(%r26)
	LW	%r4, 20(%r30)
	SW	%r4, 1(%r26)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 19
	LA	%r18, iter_trace_diffuse_rays.3017
	SW	%r18, 0(%r10)
	SW	%r15, 18(%r10)
	SW	%r12, 17(%r10)
	SW	%r26, 16(%r10)
	SW	%r5, 15(%r10)
	SW	%r16, 14(%r10)
	SW	%r20, 13(%r10)
	SW	%r13, 12(%r10)
	SW	%r7, 11(%r10)
	SW	%r6, 10(%r10)
	SW	%r11, 9(%r10)
	SW	%r8, 8(%r10)
	SW	%r14, 7(%r10)
	SW	%r19, 6(%r10)
	SW	%r17, 5(%r10)
	SW	%r22, 4(%r10)
	SW	%r21, 3(%r10)
	SW	%r1, 2(%r10)
	SW	%r4, 1(%r10)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r5, trace_diffuse_ray_80percent.3026
	SW	%r5, 0(%r1)
	LW	%r5, 44(%r30)
	SW	%r5, 3(%r1)
	SW	%r10, 2(%r1)
	LW	%r6, 32(%r30)
	SW	%r6, 1(%r1)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 9
	LA	%r12, calc_diffuse_using_1point.3030
	SW	%r12, 0(%r7)
	SW	%r26, 8(%r7)
	SW	%r25, 7(%r7)
	SW	%r23, 6(%r7)
	SW	%r24, 5(%r7)
	SW	%r9, 4(%r7)
	SW	%r10, 3(%r7)
	SW	%r6, 2(%r7)
	SW	%r4, 1(%r7)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r13, calc_diffuse_using_5points.3033
	SW	%r13, 0(%r12)
	SW	%r24, 2(%r12)
	SW	%r4, 1(%r12)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 8
	LA	%r14, do_without_neighbors.3039
	SW	%r14, 0(%r13)
	SW	%r1, 7(%r13)
	SW	%r5, 6(%r13)
	SW	%r24, 5(%r13)
	SW	%r10, 4(%r13)
	SW	%r6, 3(%r13)
	SW	%r4, 2(%r13)
	SW	%r7, 1(%r13)
	ADDI	%r14, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r15, try_exploit_neighbors.3055
	SW	%r15, 0(%r14)
	SW	%r1, 6(%r14)
	SW	%r24, 5(%r14)
	SW	%r13, 4(%r14)
	SW	%r4, 3(%r14)
	SW	%r12, 2(%r14)
	SW	%r7, 1(%r14)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r16, write_rgb_element.3064
	SW	%r16, 0(%r15)
	LW	%r16, 0(%r30)
	SW	%r16, 2(%r15)
	LW	%r16, 2(%r30)
	SW	%r16, 1(%r15)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 9
	LA	%r17, pretrace_diffuse_rays.3068
	SW	%r17, 0(%r16)
	SW	%r26, 8(%r16)
	SW	%r25, 7(%r16)
	SW	%r23, 6(%r16)
	SW	%r5, 5(%r16)
	SW	%r9, 4(%r16)
	SW	%r10, 3(%r16)
	SW	%r6, 2(%r16)
	SW	%r4, 1(%r16)
	ADDI	%r5, %r28, 0
	ADDI	%r28, %r28, 17
	LA	%r17, pretrace_pixels.3071
	SW	%r17, 0(%r5)
	LW	%r17, 6(%r30)
	SW	%r17, 16(%r5)
	SW	%r3, 15(%r5)
	SW	%r26, 14(%r5)
	SW	%r25, 13(%r5)
	LW	%r18, 25(%r30)
	SW	%r18, 12(%r5)
	SW	%r23, 11(%r5)
	LW	%r20, 27(%r30)
	SW	%r20, 10(%r5)
	LW	%r21, 24(%r30)
	SW	%r21, 9(%r5)
	SW	%r24, 8(%r5)
	LW	%r22, 30(%r30)
	SW	%r22, 7(%r5)
	SW	%r16, 6(%r5)
	SW	%r9, 5(%r5)
	SW	%r10, 4(%r5)
	LW	%r10, 23(%r30)
	SW	%r10, 3(%r5)
	SW	%r6, 2(%r5)
	SW	%r4, 1(%r5)
	ADDI	%r23, %r28, 0
	ADDI	%r28, %r28, 14
	LA	%r25, pretrace_line.3078
	SW	%r25, 0(%r23)
	SW	%r17, 13(%r23)
	SW	%r3, 12(%r23)
	SW	%r18, 11(%r23)
	LW	%r3, 29(%r30)
	SW	%r3, 10(%r23)
	LW	%r17, 28(%r30)
	SW	%r17, 9(%r23)
	SW	%r20, 8(%r23)
	SW	%r21, 7(%r23)
	SW	%r24, 6(%r23)
	SW	%r22, 5(%r23)
	SW	%r5, 4(%r23)
	SW	%r16, 3(%r23)
	LW	%r16, 22(%r30)
	SW	%r16, 2(%r23)
	SW	%r10, 1(%r23)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 11
	LA	%r20, scan_pixel.3082
	SW	%r20, 0(%r18)
	SW	%r15, 10(%r18)
	SW	%r14, 9(%r18)
	SW	%r1, 8(%r18)
	SW	%r24, 7(%r18)
	LW	%r15, 1(%r30)
	SW	%r15, 6(%r18)
	SW	%r16, 5(%r18)
	SW	%r13, 4(%r18)
	SW	%r4, 3(%r18)
	SW	%r12, 2(%r18)
	SW	%r7, 1(%r18)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 16
	LA	%r20, scan_line.3088
	SW	%r20, 0(%r12)
	SW	%r14, 15(%r12)
	SW	%r1, 14(%r12)
	SW	%r3, 13(%r12)
	SW	%r17, 12(%r12)
	SW	%r18, 11(%r12)
	SW	%r21, 10(%r12)
	SW	%r24, 9(%r12)
	SW	%r5, 8(%r12)
	SW	%r23, 7(%r12)
	SW	%r15, 6(%r12)
	SW	%r16, 5(%r12)
	SW	%r10, 4(%r12)
	SW	%r13, 3(%r12)
	SW	%r4, 2(%r12)
	SW	%r7, 1(%r12)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r3, calc_dirvec.3108
	SW	%r3, 0(%r1)
	SW	%r6, 1(%r1)
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r4, calc_dirvecs.3116
	SW	%r4, 0(%r3)
	SW	%r1, 1(%r3)
	ADDI	%r4, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r5, calc_dirvec_rows.3121
	SW	%r5, 0(%r4)
	SW	%r3, 2(%r4)
	SW	%r1, 1(%r4)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r5, create_dirvec.3125
	SW	%r5, 0(%r1)
	SW	%r9, 1(%r1)
	ADDI	%r5, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r7, create_dirvec_elements.3127
	SW	%r7, 0(%r5)
	SW	%r9, 2(%r5)
	SW	%r1, 1(%r5)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r13, create_dirvecs.3130
	SW	%r13, 0(%r7)
	SW	%r9, 4(%r7)
	SW	%r6, 3(%r7)
	SW	%r5, 2(%r7)
	SW	%r1, 1(%r7)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r14, init_dirvec_constants.3132
	SW	%r14, 0(%r13)
	LW	%r14, 43(%r30)
	SW	%r14, 4(%r13)
	SW	%r8, 3(%r13)
	SW	%r9, 2(%r13)
	LW	%r15, 42(%r30)
	SW	%r15, 1(%r13)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r18, init_vecset_constants.3135
	SW	%r18, 0(%r17)
	SW	%r14, 6(%r17)
	SW	%r8, 5(%r17)
	SW	%r9, 4(%r17)
	SW	%r15, 3(%r17)
	SW	%r13, 2(%r17)
	SW	%r6, 1(%r17)
	ADDI	%r14, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r18, setup_reflections.3152
	SW	%r18, 0(%r14)
	LW	%r18, 38(%r30)
	SW	%r18, 6(%r14)
	SW	%r8, 5(%r14)
	LW	%r18, 46(%r30)
	SW	%r18, 4(%r14)
	SW	%r9, 3(%r14)
	SW	%r19, 2(%r14)
	SW	%r15, 1(%r14)
	ADDI	%r18, %r0, 128
	ADDI	%r20, %r0, 128
	SW	%r18, 0(%r16)
	SW	%r20, 1(%r16)
	SRA	%r22, %r18, 1
	SW	%r22, 0(%r10)
	SRA	%r20, %r20, 1
	SW	%r20, 1(%r10)
	LA	%r29, l.23064
	LWC1	%f1, 0(%r29)
	SW	%r12, 47(%r30)
	SW	%r23, 48(%r30)
	SW	%r14, 49(%r30)
	SW	%r17, 50(%r30)
	SW	%r13, 51(%r30)
	SW	%r4, 52(%r30)
	SW	%r3, 53(%r30)
	SW	%r7, 54(%r30)
	SW	%r5, 55(%r30)
	SW	%r1, 56(%r30)
	SWC1	%f1, 58(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r18, 0
	SW	%r29, 60(%r30)
	ADDI	%r30, %r30, 61
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 61
	SUB	%r30, %r30, %r29
	LW	%r29, 60(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 58(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r1, 24(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r1, 22(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r3, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r2, 60(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 61(%r30)
	ADDI	%r30, %r30, 62
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 62
	SUB	%r30, %r30, %r29
	LW	%r29, 61(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 61(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 62(%r30)
	ADDI	%r30, %r30, 63
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 63
	SUB	%r30, %r30, %r29
	LW	%r29, 62(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 62(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 63(%r30)
	ADDI	%r30, %r30, 64
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 64
	SUB	%r30, %r30, %r29
	LW	%r29, 63(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 63(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 64(%r30)
	ADDI	%r30, %r30, 65
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 65
	SUB	%r30, %r30, %r29
	LW	%r29, 64(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 64(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 65(%r30)
	ADDI	%r30, %r30, 66
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 66
	SUB	%r30, %r30, %r29
	LW	%r29, 65(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 65(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 66(%r30)
	ADDI	%r30, %r30, 67
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 67
	SUB	%r30, %r30, %r29
	LW	%r29, 66(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 66(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 67(%r30)
	ADDI	%r30, %r30, 68
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 68
	SUB	%r30, %r30, %r29
	LW	%r29, 67(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 67(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 68(%r30)
	ADDI	%r30, %r30, 69
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 69
	SUB	%r30, %r30, %r29
	LW	%r29, 68(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r1, 7(%r2)
	LW	%r1, 67(%r30)
	SW	%r1, 6(%r2)
	LW	%r1, 66(%r30)
	SW	%r1, 5(%r2)
	LW	%r1, 65(%r30)
	SW	%r1, 4(%r2)
	LW	%r1, 64(%r30)
	SW	%r1, 3(%r2)
	LW	%r1, 63(%r30)
	SW	%r1, 2(%r2)
	LW	%r1, 62(%r30)
	SW	%r1, 1(%r2)
	LW	%r1, 61(%r30)
	SW	%r1, 0(%r2)
	LW	%r1, 60(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 68(%r30)
	ADDI	%r30, %r30, 69
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 69
	SUB	%r30, %r30, %r29
	LW	%r29, 68(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 22(%r30)
	LW	%r3, 0(%r2)
	ADDI	%r3, %r3, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29824
	SW	%r3, 68(%r30)
	SW	%r1, 69(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 70(%r30)
	ADDI	%r30, %r30, 71
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 71
	SUB	%r30, %r30, %r29
	LW	%r29, 70(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 68(%r30)
	LW	%r3, 69(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 70(%r30)
	ADDI	%r30, %r30, 71
	JAL	init_line_elements.3098
	ADDI	%r29, %r0, 71
	SUB	%r30, %r30, %r29
	LW	%r29, 70(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29825
BEQ_else.29824:
BEQ_cont.29825:
	LW	%r2, 22(%r30)
	LW	%r3, 0(%r2)
	ADDI	%r4, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 70(%r30)
	SW	%r3, 71(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 72(%r30)
	ADDI	%r30, %r30, 73
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 73
	SUB	%r30, %r30, %r29
	LW	%r29, 72(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 72(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 73(%r30)
	ADDI	%r30, %r30, 74
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 74
	SUB	%r30, %r30, %r29
	LW	%r29, 73(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 73(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 74(%r30)
	ADDI	%r30, %r30, 75
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 75
	SUB	%r30, %r30, %r29
	LW	%r29, 74(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 74(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 75(%r30)
	ADDI	%r30, %r30, 76
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 76
	SUB	%r30, %r30, %r29
	LW	%r29, 75(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 75(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 76(%r30)
	ADDI	%r30, %r30, 77
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 77
	SUB	%r30, %r30, %r29
	LW	%r29, 76(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 76(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 77(%r30)
	ADDI	%r30, %r30, 78
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 78
	SUB	%r30, %r30, %r29
	LW	%r29, 77(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 77(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 78(%r30)
	ADDI	%r30, %r30, 79
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 79
	SUB	%r30, %r30, %r29
	LW	%r29, 78(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 78(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 79(%r30)
	ADDI	%r30, %r30, 80
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 80
	SUB	%r30, %r30, %r29
	LW	%r29, 79(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r1, 7(%r2)
	LW	%r1, 78(%r30)
	SW	%r1, 6(%r2)
	LW	%r1, 77(%r30)
	SW	%r1, 5(%r2)
	LW	%r1, 76(%r30)
	SW	%r1, 4(%r2)
	LW	%r1, 75(%r30)
	SW	%r1, 3(%r2)
	LW	%r1, 74(%r30)
	SW	%r1, 2(%r2)
	LW	%r1, 73(%r30)
	SW	%r1, 1(%r2)
	LW	%r1, 72(%r30)
	SW	%r1, 0(%r2)
	LW	%r1, 71(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 79(%r30)
	ADDI	%r30, %r30, 80
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 80
	SUB	%r30, %r30, %r29
	LW	%r29, 79(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 22(%r30)
	LW	%r3, 0(%r2)
	ADDI	%r3, %r3, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29826
	SW	%r3, 79(%r30)
	SW	%r1, 80(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 81(%r30)
	ADDI	%r30, %r30, 82
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 82
	SUB	%r30, %r30, %r29
	LW	%r29, 81(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 79(%r30)
	LW	%r3, 80(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 81(%r30)
	ADDI	%r30, %r30, 82
	JAL	init_line_elements.3098
	ADDI	%r29, %r0, 82
	SUB	%r30, %r30, %r29
	LW	%r29, 81(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29827
BEQ_else.29826:
BEQ_cont.29827:
	LW	%r2, 22(%r30)
	LW	%r3, 0(%r2)
	ADDI	%r4, %r0, 3
	LA	%r29, l.20767
	LWC1	%f1, 0(%r29)
	SW	%r1, 81(%r30)
	SW	%r3, 82(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 83(%r30)
	ADDI	%r30, %r30, 84
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 84
	SUB	%r30, %r30, %r29
	LW	%r29, 83(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 83(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 84(%r30)
	ADDI	%r30, %r30, 85
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 85
	SUB	%r30, %r30, %r29
	LW	%r29, 84(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 84(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 85(%r30)
	ADDI	%r30, %r30, 86
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 86
	SUB	%r30, %r30, %r29
	LW	%r29, 85(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 85(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 86(%r30)
	ADDI	%r30, %r30, 87
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 87
	SUB	%r30, %r30, %r29
	LW	%r29, 86(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 86(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 87(%r30)
	ADDI	%r30, %r30, 88
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 88
	SUB	%r30, %r30, %r29
	LW	%r29, 87(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 87(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 88(%r30)
	ADDI	%r30, %r30, 89
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 89
	SUB	%r30, %r30, %r29
	LW	%r29, 88(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 88(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 89(%r30)
	ADDI	%r30, %r30, 90
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 90
	SUB	%r30, %r30, %r29
	LW	%r29, 89(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 89(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 90(%r30)
	ADDI	%r30, %r30, 91
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 91
	SUB	%r30, %r30, %r29
	LW	%r29, 90(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r1, 7(%r2)
	LW	%r1, 89(%r30)
	SW	%r1, 6(%r2)
	LW	%r1, 88(%r30)
	SW	%r1, 5(%r2)
	LW	%r1, 87(%r30)
	SW	%r1, 4(%r2)
	LW	%r1, 86(%r30)
	SW	%r1, 3(%r2)
	LW	%r1, 85(%r30)
	SW	%r1, 2(%r2)
	LW	%r1, 84(%r30)
	SW	%r1, 1(%r2)
	LW	%r1, 83(%r30)
	SW	%r1, 0(%r2)
	LW	%r1, 82(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 90(%r30)
	ADDI	%r30, %r30, 91
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 91
	SUB	%r30, %r30, %r29
	LW	%r29, 90(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 22(%r30)
	LW	%r3, 0(%r2)
	ADDI	%r3, %r3, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.29828
	SW	%r3, 90(%r30)
	SW	%r1, 91(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 92(%r30)
	ADDI	%r30, %r30, 93
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 93
	SUB	%r30, %r30, %r29
	LW	%r29, 92(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 90(%r30)
	LW	%r3, 91(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 92(%r30)
	ADDI	%r30, %r30, 93
	JAL	init_line_elements.3098
	ADDI	%r29, %r0, 93
	SUB	%r30, %r30, %r29
	LW	%r29, 92(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29829
BEQ_else.29828:
BEQ_cont.29829:
	LW	%r26, 41(%r30)
	SW	%r1, 92(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 93(%r30)
	ADDI	%r30, %r30, 94
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 94
	SUB	%r30, %r30, %r29
	LW	%r29, 93(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 93(%r30)
	ADDI	%r30, %r30, 94
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 94
	SUB	%r30, %r30, %r29
	LW	%r29, 93(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 93(%r30)
	ADDI	%r30, %r30, 94
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 94
	SUB	%r30, %r30, %r29
	LW	%r29, 93(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 93(%r30)
	ADDI	%r30, %r30, 94
	JAL	rad.2798
	ADDI	%r29, %r0, 94
	SUB	%r30, %r30, %r29
	LW	%r29, 93(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 94(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 96(%r30)
	ADDI	%r30, %r30, 97
	JAL	sin.2632
	ADDI	%r29, %r0, 97
	SUB	%r30, %r30, %r29
	LW	%r29, 96(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 96(%r30)
	ADDI	%r30, %r30, 97
	JAL	fneg.2605
	ADDI	%r29, %r0, 97
	SUB	%r30, %r30, %r29
	LW	%r29, 96(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 96(%r30)
	ADDI	%r30, %r30, 97
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 97
	SUB	%r30, %r30, %r29
	LW	%r29, 96(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 96(%r30)
	ADDI	%r30, %r30, 97
	JAL	rad.2798
	ADDI	%r29, %r0, 97
	SUB	%r30, %r30, %r29
	LW	%r29, 96(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 94(%r30)
	SWC1	%f1, 96(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 98(%r30)
	ADDI	%r30, %r30, 99
	JAL	cos.2630
	ADDI	%r29, %r0, 99
	SUB	%r30, %r30, %r29
	LW	%r29, 98(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 96(%r30)
	SWC1	%f1, 98(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	JAL	sin.2632
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 98(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 7(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 96(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	JAL	cos.2630
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 98(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 7(%r30)
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 0
	LW	%r26, 40(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.29831
	J	BEQ_cont.29832
BEQ_else.29831:
	LW	%r2, 10(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r0, 1
	LW	%r26, 39(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.29832:
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.29833
	ADDI	%r1, %r0, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 100(%r30)
	ADDI	%r30, %r30, 101
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 101
	SUB	%r30, %r30, %r29
	LW	%r29, 100(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29834
BEQ_else.29833:
	ADDI	%r1, %r0, 1
	SW	%r2, 100(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	read_or_network.2815
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 100(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.29834:
	LW	%r2, 12(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r0, 80
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 51
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 22(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 22(%r30)
	LW	%r1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 255
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 101(%r30)
	ADDI	%r30, %r30, 102
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 102
	SUB	%r30, %r30, %r29
	LW	%r29, 101(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 120
	LW	%r26, 56(%r30)
	SW	%r1, 101(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 102(%r30)
	ADDI	%r30, %r30, 103
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 103
	SUB	%r30, %r30, %r29
	LW	%r29, 102(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 101(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 102(%r30)
	ADDI	%r30, %r30, 103
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 103
	SUB	%r30, %r30, %r29
	LW	%r29, 102(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30)
	SW	%r1, 4(%r2)
	LW	%r1, 4(%r2)
	ADDI	%r3, %r0, 118
	LW	%r26, 55(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 102(%r30)
	ADDI	%r30, %r30, 103
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 103
	SUB	%r30, %r30, %r29
	LW	%r29, 102(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r26, 54(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 102(%r30)
	ADDI	%r30, %r30, 103
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 103
	SUB	%r30, %r30, %r29
	LW	%r29, 102(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 9
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r0, 0
	SW	%r3, 102(%r30)
	SW	%r2, 103(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 104(%r30)
	ADDI	%r30, %r30, 105
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 105
	SUB	%r30, %r30, %r29
	LW	%r29, 104(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.22868
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.22869
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 4
	LW	%r2, 103(%r30)
	LW	%r3, 102(%r30)
	LW	%r26, 53(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 104(%r30)
	ADDI	%r30, %r30, 105
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 105
	SUB	%r30, %r30, %r29
	LW	%r29, 104(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 8
	ADDI	%r2, %r0, 2
	LW	%r3, 103(%r30)
	SW	%r1, 104(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 105(%r30)
	ADDI	%r30, %r30, 106
	JAL	add_mod5.2678
	ADDI	%r29, %r0, 106
	SUB	%r30, %r30, %r29
	LW	%r29, 105(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r3, %r0, 4
	LW	%r1, 104(%r30)
	LW	%r26, 52(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 105(%r30)
	ADDI	%r30, %r30, 106
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 106
	SUB	%r30, %r30, %r29
	LW	%r29, 105(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 32(%r30)
	LW	%r1, 4(%r1)
	ADDI	%r2, %r0, 119
	LW	%r26, 51(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 105(%r30)
	ADDI	%r30, %r30, 106
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 106
	SUB	%r30, %r30, %r29
	LW	%r29, 105(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 3
	LW	%r26, 50(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 105(%r30)
	ADDI	%r30, %r30, 106
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 106
	SUB	%r30, %r30, %r29
	LW	%r29, 105(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 34(%r30)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 2(%r2)
	LW	%r1, 3(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r2, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.29835
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 36(%r30)
	SW	%r2, 105(%r30)
	SW	%r3, 106(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 107(%r30)
	ADDI	%r30, %r30, 108
	JAL	d_const.2790
	ADDI	%r29, %r0, 108
	SUB	%r30, %r30, %r29
	LW	%r29, 107(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 36(%r30)
	SW	%r1, 107(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 108(%r30)
	ADDI	%r30, %r30, 109
	JAL	d_vec.2788
	ADDI	%r29, %r0, 109
	SUB	%r30, %r30, %r29
	LW	%r29, 108(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 106(%r30)
	SW	%r1, 108(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	JAL	o_form.2729
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.29837
	LW	%r1, 108(%r30)
	LW	%r2, 106(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 105(%r30)
	LW	%r3, 107(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.29838
BEQ_else.29837:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.29839
	LW	%r1, 108(%r30)
	LW	%r2, 106(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 105(%r30)
	LW	%r3, 107(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.29840
BEQ_else.29839:
	LW	%r1, 108(%r30)
	LW	%r2, 106(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 105(%r30)
	LW	%r3, 107(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.29840:
BEQ_cont.29838:
	ADDI	%r2, %r2, -1
	LW	%r1, 36(%r30)
	LW	%r26, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.29836
BEQ_else.29835:
BEQ_cont.29836:
	LW	%r1, 3(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LW	%r26, 49(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r0, 0
	LW	%r1, 81(%r30)
	LW	%r26, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	ADDI	%r5, %r0, 2
	LW	%r2, 70(%r30)
	LW	%r3, 81(%r30)
	LW	%r4, 92(%r30)
	LW	%r26, 47(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 109(%r30)
	ADDI	%r30, %r30, 110
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 110
	SUB	%r30, %r30, %r29
	LW	%r29, 109(%r30)
	ADDI	%r31, %r29, 0
#halt   # main program end
j _MAIN_PROGRAM_END

_MAIN_PROGRAM_END:	
_print_char_flush:	
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,1(%r2)
	addi	%r5,%r0,4
_print_char_flush_loop_e:		#4バイトに足りない分の空白を詰める(今回はそれで一応問題ない
	sll	%r3,%r3,8
	ori	%r3,%r3,0x20
	addi	%r4,%r4,1
	bne	%r4,%r5,_print_char_flush_loop_e
_print_char_flush_do:
	out	%r3
	sw	%r0,0(%r2)
	sw	%r0,1(%r2)
	halt
