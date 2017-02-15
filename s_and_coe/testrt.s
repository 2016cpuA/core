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
l.7048:	 # 128.000000
	.word	1124073472
l.7015:	 # 0.900000
	.word	1063675494
l.7014:	 # 0.200000
	.word	1045220557
l.6920:	 # 150.000000
	.word	1125515264
l.6918:	 # -150.000000
	.word	-1021968384
l.6902:	 # 0.100000
	.word	1036831949
l.6899:	 # -2.000000
	.word	-1073741824
l.6897:	 # 0.003906
	.word	998244352
l.6875:	 # 20.000000
	.word	1101004800
l.6874:	 # 0.050000
	.word	1028443341
l.6870:	 # 0.250000
	.word	1048576000
l.6866:	 # 10.000000
	.word	1092616192
l.6862:	 # 0.300000
	.word	1050253722
l.6861:	 # 255.000000
	.word	1132396544
l.6860:	 # 0.150000
	.word	1041865114
l.6858:	 # 3.141593
	.word	1078530011
l.6857:	 # 30.000000
	.word	1106247680
l.6856:	 # 15.000000
	.word	1097859072
l.6855:	 # 0.000100
	.word	953267991
l.6812:	 # 100000000.000000
	.word	1287568416
l.6808:	 # 1000000000.000000
	.word	1315859240
l.6788:	 # -0.100000
	.word	-1110651699
l.6775:	 # 0.010000
	.word	1008981770
l.6774:	 # -0.200000
	.word	-1102263091
l.6550:	 # -200.000000
	.word	-1018691584
l.6548:	 # 200.000000
	.word	1128792064
l.6544:	 # 0.017453
	.word	1016003125
l.6461:	 # -1.000000
	.word	-1082130432
l.6460:	 # 1.570796
	.word	1070141403
l.6459:	 # 0.000000
	.word	786163455
l.6458:	 # 4.000000
	.word	1082130432
l.6457:	 # 3.000000
	.word	1077936128
l.6456:	 # 2147483648.000000
	.word	1325400064
l.6455:	 # -2147483648.000000
	.word	-822083584
l.6448:	 # 16777216.000000
	.word	1266679808
l.6447:	 # -16777216.000000
	.word	-880803840
l.6446:	 # 2.000000
	.word	1073741824
l.6445:	 # 1.000000
	.word	1065353216
l.6444:	 # 0.500000
	.word	1056964608
l.6443:	 # 0.000000
	.word	0
	.text
	.globl  _min_caml_start
fiszero.2599:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9146
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9146:
	ADDI	%r1, %r0, 1
	JR	%r31
fispos.2601:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9147
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9147:
	ADDI	%r1, %r0, 1
	JR	%r31
fisneg.2603:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9148
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9148:
	ADDI	%r1, %r0, 1
	JR	%r31
fneg.2605:
	SUB.s	%f1, %f0, %f1
	JR	%r31
fless.2607:
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9149
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9149:
	ADDI	%r1, %r0, 1
	JR	%r31
fhalf.2610:
	LA	%r29, l.6444
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	JR	%r31
fsqr.2612:
	MUL.s	%f1, %f1, %f1
	JR	%r31
abs_float.2614:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9150
	JR	%r31
BEQ_else.9150:
	SUB.s	%f1, %f0, %f1
	JR	%r31
fabs.2616:
	J	abs_float.2614
calc_floor.6420:
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9151
	LA	%r29, l.6446
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6420
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30)
	C.le.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.9152
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.9153
BEQ_else.9152:
	SUB.s	%f3, %f1, %f3
BEQ_cont.9153:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.9154
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.9154:
	JR	%r31
BEQ_else.9151:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	JR	%r31
floor.2618:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9155
	LA	%r29, l.6448
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9156
	JR	%r31
BEQ_else.9156:
	J	calc_floor.6420
BEQ_else.9155:
	LA	%r29, l.6447
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9157
	JR	%r31
BEQ_else.9157:
	SUB.s	%f2, %f0, %f1
	SWC1	%f1, 0(%r30)
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	C.eq.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9158
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	JR	%r31
BEQ_else.9158:
	LWC1	%f1, 0(%r30)
	JR	%r31
set_arr_x.6362:
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9159
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.6446
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	J	set_arr_x.6362
BEQ_else.9159:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
calc_floor.6367:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9160
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9161
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.9162
BEQ_else.9161:
	SUB.s	%f2, %f1, %f2
BEQ_cont.9162:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.9163
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.9163:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.9160:
	JR	%r31
int_of_float.2622:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9164
	LA	%r29, l.6456
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9165
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9165:
	ADDI	%r1, %r0, 0
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	LW	%r3, 1(%r30)
	LW	%r4, 0(%r30)
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	J	calc_floor.6367
BEQ_else.9164:
	LA	%r29, l.6455
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9166
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9166:
	SUB.s	%f1, %f0, %f1
	ADDI	%r1, %r0, 0
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	LW	%r3, 1(%r30)
	LW	%r4, 0(%r30)
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
	SUB	%r29, %r0, %r1
	ADDI	%r1, %r29, 0
	JR	%r31
calc_sqrt.6353:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.6446
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.9167
	ADD.s	%f2, %f3, %f0
	J	calc_sqrt.6353
BEQ_else.9167:
	ADD.s	%f1, %f2, %f0
	JR	%r31
sqrt.2624:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9168
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9169
	LA	%r29, l.6446
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	J	calc_sqrt.6353
BEQ_else.9169:
	JR	%r31
BEQ_else.9168:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	JR	%r31
calc_cos.6332:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9170
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.9170:
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
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f31, %f2, %f0
	ADD.s	%f2, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_cos.6332
mycos_step1.2626:
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9172
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	ADDI	%r1, %r0, 16
	J	calc_cos.6332
BEQ_else.9172:
	LA	%r29, l.6446
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6446
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	JR	%r31
calc_sin.6307:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9173
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.9173:
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
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30)
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30)
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -2
	ADD.s	%f1, %f3, %f0
	J	calc_sin.6307
mysin_step1.2628:
	LA	%r29, l.6444
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9175
	ADDI	%r1, %r0, 17
	ADD.s	%f2, %f1, %f0
	J	calc_sin.6307
BEQ_else.9175:
	LA	%r29, l.6457
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6457
	LWC1	%f2, 0(%r29)
	LA	%r29, l.6458
	LWC1	%f3, 0(%r29)
	MUL.s	%f3, %f3, %f1
	MUL.s	%f3, %f3, %f1
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
	JR	%r31
cos.2630:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9176
	J	mycos_step1.2626
BEQ_else.9176:
	SUB.s	%f1, %f0, %f1
	J	mycos_step1.2626
sin.2632:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9177
	J	mysin_step1.2628
BEQ_else.9177:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
	JR	%r31
ev_error.6243:
	LA	%r29, l.6459
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.9178
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
	LA	%r29, l.6445
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30)
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 2(%r30)
	ADD.s	%f2, %f4, %f2
	LW	%r1, 0(%r30)
	J	ev_error.6243
BEQ_else.9178:
	JR	%r31
calc_atan.6249:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9180
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.9180:
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
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, -1
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f31, %f0
	J	calc_atan.6249
atan.2634:
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.9182
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9183
BEQ_else.9182:
	ADDI	%r1, %r0, 1
BEQ_cont.9183:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9184
	J	BEQ_cont.9185
BEQ_else.9184:
	SUB.s	%f1, %f0, %f1
BEQ_cont.9185:
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	C.le.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.9186
	ADDI	%r2, %r0, 0
	J	BEQ_cont.9187
BEQ_else.9186:
	ADDI	%r2, %r0, 1
BEQ_cont.9187:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.9188
	J	BEQ_cont.9189
BEQ_else.9188:
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
BEQ_cont.9189:
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	ADD.s	%f3, %f3, %f2
	DIV.s	%f3, %f2, %f3
	LA	%r29, l.6445
	LWC1	%f4, 0(%r29)
	ADD.s	%f2, %f4, %f2
	DIV.s	%f1, %f1, %f2
	ADDI	%r3, %r0, 1
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	SW	%r1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	ev_error.6243
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.9191
	LWC1	%f1, 4(%r30)
	LWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f3, %f1, %f0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	calc_atan.6249
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9192
BEQ_else.9191:
	LA	%r29, l.6460
	LWC1	%f1, 0(%r29)
	LWC1	%f3, 4(%r30)
	LWC1	%f2, 2(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	calc_atan.6249
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f1, %f2, %f1
BEQ_cont.9192:
	LW	%r1, 0(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9194
	JR	%r31
BEQ_else.9194:
	SUB.s	%f1, %f0, %f1
	JR	%r31
xor.2670:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9195
	ADDI	%r1, %r2, 0
	JR	%r31
BEQ_else.9195:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.9196
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9196:
	ADDI	%r1, %r0, 0
	JR	%r31
sgn.2673:
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	fiszero.2599
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9197
	LWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	fispos.2601
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9198
	LA	%r29, l.6461
	LWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.9198:
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.9197:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	JR	%r31
fneg_cond.2675:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9199
	J	fneg.2605
BEQ_else.9199:
	JR	%r31
add_mod5.2678:
	ADD	%r1, %r1, %r2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9200
	ADDI	%r1, %r1, -5
	JR	%r31
BEQ_else.9200:
	JR	%r31
vecset.2681:
	SWC1	%f1, 0(%r1)
	SWC1	%f2, 1(%r1)
	SWC1	%f3, 2(%r1)
	JR	%r31
vecfill.2686:
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	JR	%r31
vecbzero.2689:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	J	vecfill.2686
veccpy.2691:
	LWC1	%f1, 0(%r2)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r2)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r2)
	SWC1	%f1, 2(%r1)
	JR	%r31
vecunit_sgn.2699:
	LWC1	%f1, 0(%r1)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	fsqr.2612
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fsqr.2612
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	fsqr.2612
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	sqrt.2624
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fiszero.2599
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9204
	LW	%r1, 0(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9206
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 6(%r30)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.9207
BEQ_else.9206:
	LA	%r29, l.6461
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 6(%r30)
	DIV.s	%f1, %f1, %f2
BEQ_cont.9207:
	J	BEQ_cont.9205
BEQ_else.9204:
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
BEQ_cont.9205:
	LW	%r1, 1(%r30)
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
vecaccum.2710:
	LWC1	%f2, 0(%r1)
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
vecadd.2714:
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 0(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 1(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r1)
	LWC1	%f2, 2(%r2)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
	JR	%r31
vecscale.2720:
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
o_texturetype.2727:
	LW	%r1, 0(%r1)
	JR	%r31
o_form.2729:
	LW	%r1, 1(%r1)
	JR	%r31
o_reflectiontype.2731:
	LW	%r1, 2(%r1)
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
o_diffuse.2751:
	LW	%r1, 7(%r1)
	LWC1	%f1, 0(%r1)
	JR	%r31
o_hilight.2753:
	LW	%r1, 7(%r1)
	LWC1	%f1, 1(%r1)
	JR	%r31
o_color_red.2755:
	LW	%r1, 8(%r1)
	LWC1	%f1, 0(%r1)
	JR	%r31
o_color_green.2757:
	LW	%r1, 8(%r1)
	LWC1	%f1, 1(%r1)
	JR	%r31
o_color_blue.2759:
	LW	%r1, 8(%r1)
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
o_param_ctbl.2767:
	LW	%r1, 10(%r1)
	JR	%r31
p_rgb.2769:
	LW	%r1, 0(%r1)
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
p_set_group_id.2783:
	LW	%r1, 6(%r1)
	SW	%r2, 0(%r1)
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
r_surface_id.2792:
	LW	%r1, 0(%r1)
	JR	%r31
r_dvec.2794:
	LW	%r1, 1(%r1)
	JR	%r31
r_bright.2796:
	LWC1	%f1, 2(%r1)
	JR	%r31
rad.2798:
	LA	%r29, l.6544
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
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	rad.2798
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	cos.2630
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	sin.2632
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	rad.2798
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	cos.2630
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
	JAL	sin.2632
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.6548
	LWC1	%f4, 0(%r29)
	MUL.s	%f3, %f3, %f4
	LW	%r1, 3(%r30)
	SWC1	%f3, 0(%r1)
	LA	%r29, l.6550
	LWC1	%f3, 0(%r29)
	LWC1	%f4, 10(%r30)
	MUL.s	%f3, %f4, %f3
	SWC1	%f3, 1(%r1)
	LWC1	%f3, 14(%r30)
	MUL.s	%f5, %f2, %f3
	LA	%r29, l.6548
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	SWC1	%f5, 2(%r1)
	LW	%r2, 2(%r30)
	SWC1	%f3, 0(%r2)
	LA	%r29, l.6443
	LWC1	%f5, 0(%r29)
	SWC1	%f5, 1(%r2)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fneg.2605
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 2(%r1)
	LWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fneg.2605
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fneg.2605
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fneg.2605
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r1, 4(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r2, 3(%r30)
	LWC1	%f2, 0(%r2)
	SUB.s	%f1, %f1, %f2
	LW	%r3, 0(%r30)
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 1(%r2)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r1)
	LWC1	%f2, 2(%r2)
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r3)
	JR	%r31
read_light.2802:
	LW	%r1, 2(%r26)
	LW	%r2, 1(%r26)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	rad.2798
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	sin.2632
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fneg.2605
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	rad.2798
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	cos.2630
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	sin.2632
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	cos.2630
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	JR	%r31
rotate_quadratic_matrix.2804:
	LWC1	%f1, 0(%r2)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	cos.2630
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	sin.2632
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	cos.2630
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	sin.2632
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	cos.2630
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	sin.2632
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
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
	SWC1	%f1, 12(%r30)
	SWC1	%f9, 14(%r30)
	SWC1	%f11, 16(%r30)
	SWC1	%f7, 18(%r30)
	SWC1	%f10, 20(%r30)
	SWC1	%f4, 22(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fneg.2605
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	LWC1	%f3, 4(%r30)
	MUL.s	%f3, %f3, %f2
	LWC1	%f4, 2(%r30)
	MUL.s	%f2, %f4, %f2
	LW	%r1, 0(%r30)
	LWC1	%f4, 0(%r1)
	LWC1	%f5, 1(%r1)
	LWC1	%f6, 2(%r1)
	LWC1	%f7, 22(%r30)
	SWC1	%f2, 24(%r30)
	SWC1	%f3, 26(%r30)
	SWC1	%f6, 28(%r30)
	SWC1	%f1, 30(%r30)
	SWC1	%f5, 32(%r30)
	SWC1	%f4, 34(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f7, %f0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	fsqr.2612
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 20(%r30)
	SWC1	%f1, 36(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	fsqr.2612
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 36(%r30)
	ADD.s	%f1, %f3, %f1
	LWC1	%f3, 30(%r30)
	SWC1	%f1, 38(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	fsqr.2612
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 38(%r30)
	ADD.s	%f1, %f3, %f1
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	fsqr.2612
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 16(%r30)
	SWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	fsqr.2612
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 40(%r30)
	ADD.s	%f1, %f3, %f1
	LWC1	%f3, 26(%r30)
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	fsqr.2612
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 42(%r30)
	ADD.s	%f1, %f3, %f1
	LW	%r1, 0(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	fsqr.2612
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 12(%r30)
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	fsqr.2612
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 44(%r30)
	ADD.s	%f1, %f3, %f1
	LWC1	%f3, 24(%r30)
	SWC1	%f1, 46(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	fsqr.2612
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 46(%r30)
	ADD.s	%f1, %f3, %f1
	LW	%r1, 0(%r30)
	SWC1	%f1, 2(%r1)
	LA	%r29, l.6446
	LWC1	%f1, 0(%r29)
	LWC1	%f3, 18(%r30)
	LWC1	%f4, 34(%r30)
	MUL.s	%f5, %f4, %f3
	LWC1	%f6, 14(%r30)
	MUL.s	%f5, %f5, %f6
	LWC1	%f7, 16(%r30)
	LWC1	%f8, 32(%r30)
	MUL.s	%f9, %f8, %f7
	LWC1	%f10, 12(%r30)
	MUL.s	%f9, %f9, %f10
	ADD.s	%f5, %f5, %f9
	LWC1	%f9, 26(%r30)
	MUL.s	%f11, %f2, %f9
	LWC1	%f12, 24(%r30)
	MUL.s	%f11, %f11, %f12
	ADD.s	%f5, %f5, %f11
	MUL.s	%f1, %f1, %f5
	LW	%r1, 1(%r30)
	SWC1	%f1, 0(%r1)
	LA	%r29, l.6446
	LWC1	%f1, 0(%r29)
	LWC1	%f5, 22(%r30)
	MUL.s	%f11, %f4, %f5
	MUL.s	%f6, %f11, %f6
	LWC1	%f11, 20(%r30)
	MUL.s	%f13, %f8, %f11
	MUL.s	%f10, %f13, %f10
	ADD.s	%f6, %f6, %f10
	LWC1	%f10, 30(%r30)
	MUL.s	%f13, %f2, %f10
	MUL.s	%f12, %f13, %f12
	ADD.s	%f6, %f6, %f12
	MUL.s	%f1, %f1, %f6
	SWC1	%f1, 1(%r1)
	LA	%r29, l.6446
	LWC1	%f1, 0(%r29)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f3, %f4, %f3
	MUL.s	%f4, %f8, %f11
	MUL.s	%f4, %f4, %f7
	ADD.s	%f3, %f3, %f4
	MUL.s	%f2, %f2, %f10
	MUL.s	%f2, %f2, %f9
	ADD.s	%f2, %f3, %f2
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
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
	BNE	%r1, %r27, BEQ_else.9218
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9218:
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fisneg.2603
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 2
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	BNE	%r2, %r27, BEQ_else.9219
	J	BEQ_cont.9220
BEQ_else.9219:
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	rad.2798
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
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
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	rad.2798
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
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
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	rad.2798
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	SWC1	%f1, 2(%r1)
BEQ_cont.9220:
	LW	%r2, 3(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.9221
	ADDI	%r3, %r0, 1
	J	BEQ_cont.9222
BEQ_else.9221:
	LW	%r3, 8(%r30)
BEQ_cont.9222:
	ADDI	%r4, %r0, 4
	LA	%r29, l.6443
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
	BNE	%r5, %r27, BEQ_else.9223
	LWC1	%f1, 0(%r3)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fiszero.2599
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9226
	LWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	sgn.2673
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fsqr.2612
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.9227
BEQ_else.9226:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
BEQ_cont.9227:
	LW	%r1, 6(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fiszero.2599
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9228
	LWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	sgn.2673
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fsqr.2612
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.9229
BEQ_else.9228:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
BEQ_cont.9229:
	LW	%r1, 6(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fiszero.2599
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9230
	LWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	sgn.2673
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
	JAL	fsqr.2612
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.9231
BEQ_else.9230:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
BEQ_cont.9231:
	LW	%r1, 6(%r30)
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.9224
BEQ_else.9223:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.9232
	LW	%r2, 8(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.9234
	ADDI	%r2, %r0, 1
	J	BEQ_cont.9235
BEQ_else.9234:
	ADDI	%r2, %r0, 0
BEQ_cont.9235:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	vecunit_sgn.2699
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9233
BEQ_else.9232:
BEQ_cont.9233:
BEQ_cont.9224:
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9236
	J	BEQ_cont.9237
BEQ_else.9236:
	LW	%r1, 6(%r30)
	LW	%r2, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	rotate_quadratic_matrix.2804
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9237:
	ADDI	%r1, %r0, 1
	JR	%r31
read_object.2809:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9238
	JR	%r31
BEQ_else.9238:
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r2, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9240
	LW	%r1, 1(%r30)
	LW	%r2, 2(%r30)
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.9240:
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, 1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
read_all_object.2811:
	LW	%r26, 1(%r26)
	ADDI	%r1, %r0, 0
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
	BNE	%r1, %r27, BEQ_else.9242
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	J	min_caml_create_array
BEQ_else.9242:
	LW	%r2, 0(%r30)
	ADDI	%r3, %r2, 1
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
	JR	%r31
read_or_network.2815:
	ADDI	%r2, %r0, 0
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.9243
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 1
	J	min_caml_create_array
BEQ_else.9243:
	LW	%r1, 0(%r30)
	ADDI	%r3, %r1, 1
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	read_or_network.2815
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
	JR	%r31
read_and_network.2817:
	LW	%r2, 1(%r26)
	ADDI	%r3, %r0, 0
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.9244
	JR	%r31
BEQ_else.9244:
	LW	%r2, 1(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
read_parameter.2819:
	LW	%r1, 5(%r26)
	LW	%r2, 4(%r26)
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SW	%r5, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r2, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r1, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	read_or_network.2815
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 0(%r2)
	JR	%r31
solver_rect_surface.2821:
	LW	%r6, 1(%r26)
	ADD	%r29, %r2, %r3
	LWC1	%f4, 0(%r29)
	SW	%r6, 0(%r30)
	SWC1	%f3, 2(%r30)
	SW	%r5, 4(%r30)
	SWC1	%f2, 6(%r30)
	SW	%r4, 8(%r30)
	SWC1	%f1, 10(%r30)
	SW	%r3, 12(%r30)
	SW	%r2, 13(%r30)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	fiszero.2599
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9250
	LW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 14(%r30)
	SW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 12(%r30)
	LW	%r3, 13(%r30)
	ADD	%r29, %r3, %r2
	LWC1	%f1, 0(%r29)
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	fisneg.2603
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	xor.2670
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 12(%r30)
	LW	%r3, 15(%r30)
	ADD	%r29, %r3, %r2
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	fneg_cond.2675
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	SUB.s	%f1, %f1, %f2
	LW	%r1, 12(%r30)
	LW	%r2, 13(%r30)
	ADD	%r29, %r2, %r1
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 8(%r30)
	ADD	%r29, %r2, %r1
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 6(%r30)
	ADD.s	%f2, %f2, %f3
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fabs.2616
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r2, 15(%r30)
	ADD	%r29, %r2, %r1
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fless.2607
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9252
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9252:
	LW	%r1, 4(%r30)
	LW	%r2, 13(%r30)
	ADD	%r29, %r2, %r1
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 18(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 2(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fabs.2616
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r2, 15(%r30)
	ADD	%r29, %r2, %r1
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fless.2607
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9253
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9253:
	LW	%r1, 0(%r30)
	LWC1	%f1, 18(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9250:
	ADDI	%r1, %r0, 0
	JR	%r31
solver_rect.2830:
	LW	%r26, 1(%r26)
	ADDI	%r3, %r0, 0
	ADDI	%r4, %r0, 1
	ADDI	%r5, %r0, 2
	SWC1	%f1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SW	%r2, 6(%r30)
	SW	%r1, 7(%r30)
	SW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9254
	ADDI	%r3, %r0, 1
	ADDI	%r4, %r0, 2
	ADDI	%r5, %r0, 0
	LWC1	%f1, 4(%r30)
	LWC1	%f2, 2(%r30)
	LWC1	%f3, 0(%r30)
	LW	%r1, 7(%r30)
	LW	%r2, 6(%r30)
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9255
	ADDI	%r3, %r0, 2
	ADDI	%r4, %r0, 0
	ADDI	%r5, %r0, 1
	LWC1	%f1, 2(%r30)
	LWC1	%f2, 0(%r30)
	LWC1	%f3, 4(%r30)
	LW	%r1, 7(%r30)
	LW	%r2, 6(%r30)
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9256
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9256:
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.9255:
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.9254:
	ADDI	%r1, %r0, 1
	JR	%r31
solver_surface.2836:
	LW	%r3, 1(%r26)
	SW	%r3, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r2, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	SW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	veciprod.2702
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fispos.2601
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9258
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9258:
	LWC1	%f1, 6(%r30)
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 2(%r30)
	LW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fneg.2605
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
quadratic.2842:
	SWC1	%f1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	fsqr.2612
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fsqr.2612
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fsqr.2612
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 14(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 6(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_isrot.2735
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9260
	LWC1	%f1, 18(%r30)
	JR	%r31
BEQ_else.9260:
	LWC1	%f1, 2(%r30)
	LWC1	%f2, 4(%r30)
	MUL.s	%f3, %f2, %f1
	LW	%r1, 6(%r30)
	SWC1	%f3, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 18(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 0(%r30)
	LWC1	%f3, 2(%r30)
	MUL.s	%f3, %f3, %f2
	LW	%r1, 6(%r30)
	SWC1	%f1, 22(%r30)
	SWC1	%f3, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 22(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 0(%r30)
	MUL.s	%f2, %f3, %f2
	LW	%r1, 6(%r30)
	SWC1	%f1, 26(%r30)
	SWC1	%f2, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30)
	ADD.s	%f1, %f2, %f1
	JR	%r31
bilinear.2847:
	MUL.s	%f7, %f1, %f4
	SWC1	%f4, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f6, 4(%r30)
	SWC1	%f3, 6(%r30)
	SW	%r1, 8(%r30)
	SWC1	%f5, 10(%r30)
	SWC1	%f2, 12(%r30)
	SWC1	%f7, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 12(%r30)
	MUL.s	%f4, %f3, %f2
	LW	%r1, 8(%r30)
	SWC1	%f1, 16(%r30)
	SWC1	%f4, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 16(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 6(%r30)
	MUL.s	%f4, %f3, %f2
	LW	%r1, 8(%r30)
	SWC1	%f1, 20(%r30)
	SWC1	%f4, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 22(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 20(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 8(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_isrot.2735
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9262
	LWC1	%f1, 24(%r30)
	JR	%r31
BEQ_else.9262:
	LWC1	%f1, 10(%r30)
	LWC1	%f2, 6(%r30)
	MUL.s	%f3, %f2, %f1
	LWC1	%f4, 4(%r30)
	LWC1	%f5, 12(%r30)
	MUL.s	%f6, %f5, %f4
	ADD.s	%f3, %f3, %f6
	LW	%r1, 8(%r30)
	SWC1	%f3, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 26(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 2(%r30)
	MUL.s	%f2, %f3, %f2
	LWC1	%f4, 0(%r30)
	LWC1	%f5, 6(%r30)
	MUL.s	%f5, %f5, %f4
	ADD.s	%f2, %f2, %f5
	LW	%r1, 8(%r30)
	SWC1	%f1, 28(%r30)
	SWC1	%f2, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 30(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 28(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 2(%r30)
	MUL.s	%f2, %f3, %f2
	LWC1	%f3, 0(%r30)
	LWC1	%f4, 12(%r30)
	MUL.s	%f3, %f4, %f3
	ADD.s	%f2, %f2, %f3
	LW	%r1, 8(%r30)
	SWC1	%f1, 32(%r30)
	SWC1	%f2, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 32(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	fhalf.2610
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	ADD.s	%f1, %f2, %f1
	JR	%r31
solver_second.2855:
	LW	%r3, 1(%r26)
	LWC1	%f4, 0(%r2)
	LWC1	%f5, 1(%r2)
	LWC1	%f6, 2(%r2)
	SW	%r3, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r1, 8(%r30)
	SW	%r2, 9(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f3, %f6, %f0
	ADD.s	%f2, %f5, %f0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	quadratic.2842
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fiszero.2599
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9264
	LW	%r1, 9(%r30)
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 2(%r1)
	LWC1	%f4, 6(%r30)
	LWC1	%f5, 4(%r30)
	LWC1	%f6, 2(%r30)
	LW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	bilinear.2847
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	LWC1	%f3, 4(%r30)
	LWC1	%f4, 2(%r30)
	LW	%r1, 8(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	ADD.s	%f3, %f4, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	quadratic.2842
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_form.2729
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.9265
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.9266
BEQ_else.9265:
	LWC1	%f1, 14(%r30)
BEQ_cont.9266:
	LWC1	%f2, 12(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fsqr.2612
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 10(%r30)
	MUL.s	%f2, %f3, %f2
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fispos.2601
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9267
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9267:
	LWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	sqrt.2624
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9268
	LWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fneg.2605
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9269
BEQ_else.9268:
	LWC1	%f1, 20(%r30)
BEQ_cont.9269:
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 10(%r30)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9264:
	ADDI	%r1, %r0, 0
	JR	%r31
solver.2861:
	LW	%r4, 4(%r26)
	LW	%r5, 3(%r26)
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADD	%r29, %r7, %r1
	LW	%r1, 0(%r29)
	LWC1	%f1, 0(%r3)
	SW	%r5, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r2, 2(%r30)
	SW	%r6, 3(%r30)
	SW	%r1, 4(%r30)
	SW	%r3, 5(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 5(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r2, 4(%r30)
	SWC1	%f1, 8(%r30)
	SWC1	%f2, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 5(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r1, 4(%r30)
	SWC1	%f1, 12(%r30)
	SWC1	%f2, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_form.2729
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9270
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 12(%r30)
	LWC1	%f3, 16(%r30)
	LW	%r1, 4(%r30)
	LW	%r2, 2(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9270:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9271
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 12(%r30)
	LWC1	%f3, 16(%r30)
	LW	%r1, 4(%r30)
	LW	%r2, 2(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9271:
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 12(%r30)
	LWC1	%f3, 16(%r30)
	LW	%r1, 4(%r30)
	LW	%r2, 2(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solver_rect_fast.2865:
	LW	%r4, 1(%r26)
	LWC1	%f4, 0(%r3)
	SUB.s	%f4, %f4, %f1
	LWC1	%f5, 1(%r3)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f2
	SW	%r4, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	SW	%r3, 6(%r30)
	SWC1	%f3, 8(%r30)
	SWC1	%f4, 10(%r30)
	SW	%r2, 12(%r30)
	SW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f5, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	fabs.2616
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fless.2607
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9274
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9275
BEQ_else.9274:
	LW	%r1, 12(%r30)
	LWC1	%f1, 2(%r1)
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 8(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fabs.2616
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fless.2607
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9276
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9277
BEQ_else.9276:
	LW	%r1, 6(%r30)
	LWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fiszero.2599
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9278
	ADDI	%r1, %r0, 1
	J	BEQ_cont.9279
BEQ_else.9278:
	ADDI	%r1, %r0, 0
BEQ_cont.9279:
BEQ_cont.9277:
BEQ_cont.9275:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9280
	LW	%r1, 6(%r30)
	LWC1	%f1, 2(%r1)
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f1, %f2
	LWC1	%f3, 3(%r1)
	MUL.s	%f1, %f1, %f3
	LW	%r2, 12(%r30)
	LWC1	%f3, 0(%r2)
	MUL.s	%f3, %f1, %f3
	LWC1	%f4, 2(%r30)
	ADD.s	%f3, %f3, %f4
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fabs.2616
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fless.2607
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9281
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9282
BEQ_else.9281:
	LW	%r1, 12(%r30)
	LWC1	%f1, 2(%r1)
	LWC1	%f2, 18(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 8(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fabs.2616
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fless.2607
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9283
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9284
BEQ_else.9283:
	LW	%r1, 6(%r30)
	LWC1	%f1, 3(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fiszero.2599
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9285
	ADDI	%r1, %r0, 1
	J	BEQ_cont.9286
BEQ_else.9285:
	ADDI	%r1, %r0, 0
BEQ_cont.9286:
BEQ_cont.9284:
BEQ_cont.9282:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9287
	LW	%r1, 6(%r30)
	LWC1	%f1, 4(%r1)
	LWC1	%f2, 8(%r30)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 5(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r2, 12(%r30)
	LWC1	%f2, 0(%r2)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 2(%r30)
	ADD.s	%f2, %f2, %f3
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	fabs.2616
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	fless.2607
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9288
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9289
BEQ_else.9288:
	LW	%r1, 12(%r30)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 4(%r30)
	ADD.s	%f1, %f1, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	fabs.2616
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	SWC1	%f1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	o_param_b.2739
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
	BNE	%r1, %r27, BEQ_else.9290
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9291
BEQ_else.9290:
	LW	%r1, 6(%r30)
	LWC1	%f1, 5(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	fiszero.2599
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9292
	ADDI	%r1, %r0, 1
	J	BEQ_cont.9293
BEQ_else.9292:
	ADDI	%r1, %r0, 0
BEQ_cont.9293:
BEQ_cont.9291:
BEQ_cont.9289:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9294
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9294:
	LW	%r1, 0(%r30)
	LWC1	%f1, 24(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.9287:
	LW	%r1, 0(%r30)
	LWC1	%f1, 18(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.9280:
	LW	%r1, 0(%r30)
	LWC1	%f1, 10(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
solver_surface_fast.2872:
	LW	%r1, 1(%r26)
	LWC1	%f4, 0(%r2)
	SW	%r1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	fisneg.2603
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9296
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9296:
	LW	%r1, 8(%r30)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 4(%r30)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r1)
	LWC1	%f3, 2(%r30)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
solver_second_fast.2878:
	LW	%r3, 1(%r26)
	LWC1	%f4, 0(%r2)
	SW	%r3, 0(%r30)
	SWC1	%f4, 2(%r30)
	SW	%r1, 4(%r30)
	SWC1	%f3, 6(%r30)
	SWC1	%f2, 8(%r30)
	SWC1	%f1, 10(%r30)
	SW	%r2, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	fiszero.2599
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9299
	LW	%r1, 12(%r30)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r1)
	LWC1	%f4, 8(%r30)
	MUL.s	%f3, %f3, %f4
	ADD.s	%f1, %f1, %f3
	LWC1	%f3, 3(%r1)
	LWC1	%f5, 6(%r30)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f1, %f1, %f3
	LW	%r2, 4(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADD.s	%f3, %f5, %f0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f4, %f0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	quadratic.2842
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_form.2729
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.9301
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 16(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.9302
BEQ_else.9301:
	LWC1	%f1, 16(%r30)
BEQ_cont.9302:
	LWC1	%f2, 14(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fsqr.2612
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	LWC1	%f3, 2(%r30)
	MUL.s	%f2, %f3, %f2
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fispos.2601
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9303
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9303:
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9304
	LWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	sqrt.2624
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 12(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.9305
BEQ_else.9304:
	LWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	sqrt.2624
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 12(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
BEQ_cont.9305:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9299:
	ADDI	%r1, %r0, 0
	JR	%r31
solver_fast.2884:
	LW	%r4, 4(%r26)
	LW	%r5, 3(%r26)
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADD	%r29, %r7, %r1
	LW	%r7, 0(%r29)
	LWC1	%f1, 0(%r3)
	SW	%r5, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r6, 2(%r30)
	SW	%r1, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r7, 5(%r30)
	SW	%r3, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 6(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r2, 5(%r30)
	SWC1	%f1, 10(%r30)
	SWC1	%f2, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 6(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r1, 5(%r30)
	SWC1	%f1, 14(%r30)
	SWC1	%f2, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	d_const.2790
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r2, 5(%r30)
	SW	%r1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	o_form.2729
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9307
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	d_vec.2788
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 10(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 18(%r30)
	LW	%r1, 5(%r30)
	LW	%r3, 20(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9307:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9308
	LWC1	%f1, 10(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 18(%r30)
	LW	%r1, 5(%r30)
	LW	%r2, 20(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9308:
	LWC1	%f1, 10(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 18(%r30)
	LW	%r1, 5(%r30)
	LW	%r2, 20(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solver_surface_fast2.2888:
	LW	%r1, 1(%r26)
	LWC1	%f1, 0(%r2)
	SW	%r1, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	fisneg.2603
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9309
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9309:
	LW	%r1, 2(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 1(%r30)
	LWC1	%f2, 3(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
solver_second_fast2.2895:
	LW	%r4, 1(%r26)
	LWC1	%f4, 0(%r2)
	SW	%r4, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f4, 2(%r30)
	SW	%r3, 4(%r30)
	SWC1	%f3, 6(%r30)
	SWC1	%f2, 8(%r30)
	SWC1	%f1, 10(%r30)
	SW	%r2, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	fiszero.2599
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9311
	LW	%r1, 12(%r30)
	LWC1	%f1, 1(%r1)
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 8(%r30)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r1)
	LWC1	%f3, 6(%r30)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r2, 4(%r30)
	LWC1	%f2, 3(%r2)
	SWC1	%f1, 14(%r30)
	SWC1	%f2, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fsqr.2612
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 2(%r30)
	MUL.s	%f2, %f3, %f2
	SUB.s	%f1, %f1, %f2
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fispos.2601
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9313
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9313:
	LW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9314
	LWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	sqrt.2624
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 12(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.9315
BEQ_else.9314:
	LWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	sqrt.2624
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 12(%r30)
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
BEQ_cont.9315:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9311:
	ADDI	%r1, %r0, 0
	JR	%r31
solver_fast2.2902:
	LW	%r3, 4(%r26)
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADD	%r29, %r6, %r1
	LW	%r6, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r6, 3(%r30)
	SW	%r1, 4(%r30)
	SW	%r2, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	o_param_ctbl.2767
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 2(%r1)
	LW	%r2, 5(%r30)
	SW	%r1, 6(%r30)
	SWC1	%f3, 8(%r30)
	SWC1	%f2, 10(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	d_const.2790
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r2, 3(%r30)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	o_form.2729
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9317
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	d_vec.2788
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 8(%r30)
	LW	%r1, 3(%r30)
	LW	%r3, 14(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9317:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9318
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 8(%r30)
	LW	%r1, 3(%r30)
	LW	%r2, 14(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9318:
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 8(%r30)
	LW	%r1, 3(%r30)
	LW	%r2, 14(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
setup_rect_table.2905:
	ADDI	%r3, %r0, 6
	LA	%r29, l.6443
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
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	fiszero.2599
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9319
	LW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LWC1	%f1, 0(%r2)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fisneg.2603
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	xor.2670
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	fneg_cond.2675
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 0(%r1)
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LW	%r2, 1(%r30)
	LWC1	%f2, 0(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r1)
	J	BEQ_cont.9320
BEQ_else.9319:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	LW	%r1, 2(%r30)
	SWC1	%f1, 1(%r1)
BEQ_cont.9320:
	LW	%r2, 1(%r30)
	LWC1	%f1, 1(%r2)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	fiszero.2599
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9321
	LW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LWC1	%f1, 1(%r2)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	fisneg.2603
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	xor.2670
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	fneg_cond.2675
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 2(%r1)
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LW	%r2, 1(%r30)
	LWC1	%f2, 1(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 3(%r1)
	J	BEQ_cont.9322
BEQ_else.9321:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	LW	%r1, 2(%r30)
	SWC1	%f1, 3(%r1)
BEQ_cont.9322:
	LW	%r2, 1(%r30)
	LWC1	%f1, 2(%r2)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	fiszero.2599
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9323
	LW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LWC1	%f1, 2(%r2)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fisneg.2603
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	xor.2670
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	fneg_cond.2675
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 4(%r1)
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LW	%r2, 1(%r30)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 5(%r1)
	J	BEQ_cont.9324
BEQ_else.9323:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	LW	%r1, 2(%r30)
	SWC1	%f1, 5(%r1)
BEQ_cont.9324:
	JR	%r31
setup_surface_table.2908:
	ADDI	%r3, %r0, 4
	LA	%r29, l.6443
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
	SW	%r1, 2(%r30)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 6(%r30)
	SWC1	%f2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 6(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r1, 0(%r30)
	SWC1	%f1, 10(%r30)
	SWC1	%f2, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	ADD.s	%f1, %f2, %f1
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fispos.2601
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9326
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	LW	%r1, 2(%r30)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.9327
BEQ_else.9326:
	LA	%r29, l.6461
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 2(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fneg.2605
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fneg.2605
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fneg.2605
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	SWC1	%f1, 3(%r1)
BEQ_cont.9327:
	JR	%r31
setup_second_table.2911:
	ADDI	%r3, %r0, 5
	LA	%r29, l.6443
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
	LW	%r3, 0(%r30)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	quadratic.2842
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 4(%r30)
	SWC1	%f2, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fneg.2605
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 8(%r30)
	SWC1	%f2, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fneg.2605
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 12(%r30)
	SWC1	%f2, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fneg.2605
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	LWC1	%f2, 4(%r30)
	SWC1	%f2, 0(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_isrot.2735
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9329
	LW	%r1, 2(%r30)
	LWC1	%f1, 8(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 12(%r30)
	SWC1	%f1, 2(%r1)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 3(%r1)
	J	BEQ_cont.9330
BEQ_else.9329:
	LW	%r1, 1(%r30)
	LWC1	%f1, 2(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 20(%r30)
	SWC1	%f2, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 22(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 20(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fhalf.2610
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 1(%r30)
	LWC1	%f1, 2(%r2)
	LW	%r3, 0(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	LW	%r2, 0(%r30)
	SWC1	%f1, 26(%r30)
	SWC1	%f2, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	fhalf.2610
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 1(%r30)
	LWC1	%f1, 1(%r2)
	LW	%r3, 0(%r30)
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 30(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LWC1	%f2, 0(%r1)
	LW	%r1, 0(%r30)
	SWC1	%f1, 32(%r30)
	SWC1	%f2, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 32(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	fhalf.2610
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	SWC1	%f1, 3(%r1)
BEQ_cont.9330:
	LWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	fiszero.2599
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9331
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 4(%r30)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 2(%r30)
	SWC1	%f1, 4(%r1)
	J	BEQ_cont.9332
BEQ_else.9331:
BEQ_cont.9332:
	LW	%r1, 2(%r30)
	JR	%r31
iter_setup_dirvec_constants.2914:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9333
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	d_const.2790
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	d_vec.2788
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	o_form.2729
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9334
	LW	%r1, 5(%r30)
	LW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.9335
BEQ_else.9334:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9336
	LW	%r1, 5(%r30)
	LW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.9337
BEQ_else.9336:
	LW	%r1, 5(%r30)
	LW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.9337:
BEQ_cont.9335:
	ADDI	%r2, %r2, -1
	LW	%r1, 3(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9333:
	JR	%r31
setup_dirvec_constants.2917:
	LW	%r2, 2(%r26)
	LW	%r26, 1(%r26)
	LW	%r2, 0(%r2)
	ADDI	%r2, %r2, -1
	LW	%r25, 0(%r26)
	JR	%r25
setup_startp_constants.2919:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9339
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r3, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_param_ctbl.2767
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	o_form.2729
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 3(%r30)
	SW	%r1, 5(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 2(%r30)
	LWC1	%f1, 1(%r2)
	LW	%r3, 3(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 2(%r30)
	LWC1	%f1, 2(%r2)
	LW	%r3, 3(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 5(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.9340
	LW	%r2, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 1(%r2)
	LWC1	%f3, 2(%r2)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 3(%r1)
	J	BEQ_cont.9341
BEQ_else.9340:
	ADDI	%r27, %r0, 2
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.9342
	J	BEQ_cont.9343
BEQ_else.9342:
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 1(%r1)
	LWC1	%f3, 2(%r1)
	LW	%r3, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	quadratic.2842
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.9344
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.9345
BEQ_else.9344:
BEQ_cont.9345:
	LW	%r1, 4(%r30)
	SWC1	%f1, 3(%r1)
BEQ_cont.9343:
BEQ_cont.9341:
	LW	%r1, 1(%r30)
	ADDI	%r2, %r1, -1
	LW	%r1, 2(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9339:
	JR	%r31
setup_startp.2922:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	SW	%r1, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	veccpy.2691
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r2, %r1, -1
	LW	%r1, 0(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
is_rect_outside.2924:
	SWC1	%f3, 0(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	fabs.2616
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fless.2607
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9348
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9349
BEQ_else.9348:
	LWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fabs.2616
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	fless.2607
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9350
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9351
BEQ_else.9350:
	LWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	fabs.2616
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fless.2607
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9351:
BEQ_cont.9349:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9352
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9353
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9353:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9352:
	LW	%r1, 4(%r30)
	J	o_isinvert.2733
is_plane_outside.2929:
	SW	%r1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 6(%r30)
	LWC1	%f2, 4(%r30)
	LWC1	%f3, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	veciprod2.2705
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 8(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	fisneg.2603
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	xor.2670
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9355
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9355:
	ADDI	%r1, %r0, 0
	JR	%r31
is_second_outside.2934:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	quadratic.2842
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_form.2729
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.9357
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	J	BEQ_cont.9358
BEQ_else.9357:
	LWC1	%f1, 2(%r30)
BEQ_cont.9358:
	LW	%r1, 0(%r30)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 4(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	fisneg.2603
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	xor.2670
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9359
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9359:
	ADDI	%r1, %r0, 0
	JR	%r31
is_outside.2939:
	SWC1	%f3, 0(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r1, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 0(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	o_form.2729
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9361
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 12(%r30)
	LW	%r1, 4(%r30)
	J	is_rect_outside.2924
BEQ_else.9361:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9362
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 12(%r30)
	LW	%r1, 4(%r30)
	J	is_plane_outside.2929
BEQ_else.9362:
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 12(%r30)
	LW	%r1, 4(%r30)
	J	is_second_outside.2934
check_all_inside.2944:
	LW	%r3, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r4, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.9363
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9363:
	ADD	%r29, %r3, %r4
	LW	%r3, 0(%r29)
	SWC1	%f3, 0(%r30)
	SWC1	%f2, 2(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r2, 6(%r30)
	SW	%r26, 7(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	is_outside.2939
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9364
	LW	%r1, 8(%r30)
	ADDI	%r1, %r1, 1
	LWC1	%f1, 4(%r30)
	LWC1	%f2, 2(%r30)
	LWC1	%f3, 0(%r30)
	LW	%r2, 6(%r30)
	LW	%r26, 7(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9364:
	ADDI	%r1, %r0, 0
	JR	%r31
shadow_check_and_group.2950:
	LW	%r3, 7(%r26)
	LW	%r4, 6(%r26)
	LW	%r5, 5(%r26)
	LW	%r6, 4(%r26)
	LW	%r7, 3(%r26)
	LW	%r8, 2(%r26)
	LW	%r9, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r10, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r10, %r27, BEQ_else.9365
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9365:
	ADD	%r29, %r2, %r1
	LW	%r10, 0(%r29)
	SW	%r9, 0(%r30)
	SW	%r8, 1(%r30)
	SW	%r7, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r26, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r10, 6(%r30)
	SW	%r5, 7(%r30)
	SW	%r4, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r10, 0
	ADDI	%r26, %r3, 0
	ADDI	%r3, %r8, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	LWC1	%f1, 0(%r2)
	SWC1	%f1, 10(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9367
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9368
BEQ_else.9367:
	LA	%r29, l.6774
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fless.2607
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9368:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9369
	LW	%r1, 6(%r30)
	LW	%r2, 7(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9370
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9370:
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30)
	LW	%r26, 4(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9369:
	LA	%r29, l.6775
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 10(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 1(%r30)
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
	ADDI	%r1, %r0, 0
	LW	%r2, 3(%r30)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f31, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9371
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30)
	LW	%r26, 4(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9371:
	ADDI	%r1, %r0, 1
	JR	%r31
shadow_check_one_or_group.2953:
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r5, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.9372
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9372:
	ADD	%r29, %r4, %r5
	LW	%r4, 0(%r29)
	ADDI	%r5, %r0, 0
	SW	%r2, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r5, 0
	ADDI	%r26, %r3, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9373
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 0(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9373:
	ADDI	%r1, %r0, 1
	JR	%r31
shadow_check_one_or_matrix.2956:
	LW	%r3, 5(%r26)
	LW	%r4, 4(%r26)
	LW	%r5, 3(%r26)
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r8, 0(%r29)
	LW	%r9, 0(%r8)
	ADDI	%r27, %r0, -1
	BNE	%r9, %r27, BEQ_else.9374
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9374:
	SW	%r8, 0(%r30)
	SW	%r5, 1(%r30)
	SW	%r2, 2(%r30)
	SW	%r26, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r9, %r27, BEQ_else.9375
	ADDI	%r1, %r0, 1
	J	BEQ_cont.9376
BEQ_else.9375:
	SW	%r4, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r9, 0
	ADDI	%r26, %r3, 0
	ADDI	%r3, %r7, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9377
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9378
BEQ_else.9377:
	LW	%r1, 5(%r30)
	LWC1	%f1, 0(%r1)
	LA	%r29, l.6788
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	fless.2607
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9379
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9380
BEQ_else.9379:
	ADDI	%r1, %r0, 1
	LW	%r2, 0(%r30)
	LW	%r26, 1(%r30)
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
	BNE	%r1, %r27, BEQ_else.9381
	ADDI	%r1, %r0, 0
	J	BEQ_cont.9382
BEQ_else.9381:
	ADDI	%r1, %r0, 1
BEQ_cont.9382:
BEQ_cont.9380:
BEQ_cont.9378:
BEQ_cont.9376:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9383
	LW	%r1, 4(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 2(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9383:
	ADDI	%r1, %r0, 1
	LW	%r2, 0(%r30)
	LW	%r26, 1(%r30)
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
	BNE	%r1, %r27, BEQ_else.9384
	LW	%r1, 4(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 2(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9384:
	ADDI	%r1, %r0, 1
	JR	%r31
solve_each_element.2959:
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
	ADDI	%r27, %r0, -1
	BNE	%r13, %r27, BEQ_else.9385
	JR	%r31
BEQ_else.9385:
	SW	%r9, 0(%r30)
	SW	%r11, 1(%r30)
	SW	%r10, 2(%r30)
	SW	%r12, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r6, 6(%r30)
	SW	%r3, 7(%r30)
	SW	%r2, 8(%r30)
	SW	%r26, 9(%r30)
	SW	%r1, 10(%r30)
	SW	%r13, 11(%r30)
	SW	%r8, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r13, 0
	ADDI	%r26, %r7, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9387
	LW	%r1, 11(%r30)
	LW	%r2, 12(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9388
	JR	%r31
BEQ_else.9388:
	LW	%r1, 10(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30)
	LW	%r3, 7(%r30)
	LW	%r26, 9(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9387:
	LW	%r2, 6(%r30)
	LWC1	%f2, 0(%r2)
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	SW	%r1, 13(%r30)
	SWC1	%f2, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fless.2607
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9390
	J	BEQ_cont.9391
BEQ_else.9390:
	LW	%r1, 5(%r30)
	LWC1	%f2, 0(%r1)
	LWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	fless.2607
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9392
	J	BEQ_cont.9393
BEQ_else.9392:
	LA	%r29, l.6775
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 14(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 7(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 4(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f4, %f4, %f1
	LWC1	%f5, 2(%r2)
	ADD.s	%f4, %f4, %f5
	ADDI	%r2, %r0, 0
	LW	%r3, 8(%r30)
	LW	%r26, 3(%r30)
	SWC1	%f4, 16(%r30)
	SWC1	%f3, 18(%r30)
	SWC1	%f2, 20(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	ADD.s	%f3, %f4, %f0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9394
	J	BEQ_cont.9395
BEQ_else.9394:
	LW	%r1, 5(%r30)
	LWC1	%f1, 22(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 20(%r30)
	LWC1	%f2, 18(%r30)
	LWC1	%f3, 16(%r30)
	LW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	vecset.2681
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LW	%r2, 11(%r30)
	SW	%r2, 0(%r1)
	LW	%r1, 0(%r30)
	LW	%r2, 13(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.9395:
BEQ_cont.9393:
BEQ_cont.9391:
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
	BNE	%r6, %r27, BEQ_else.9396
	JR	%r31
BEQ_else.9396:
	ADD	%r29, %r5, %r6
	LW	%r5, 0(%r29)
	ADDI	%r6, %r0, 0
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r6, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
trace_or_matrix.2967:
	LW	%r4, 5(%r26)
	LW	%r5, 4(%r26)
	LW	%r6, 3(%r26)
	LW	%r7, 2(%r26)
	LW	%r8, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r9, 0(%r29)
	LW	%r10, 0(%r9)
	ADDI	%r27, %r0, -1
	BNE	%r10, %r27, BEQ_else.9398
	JR	%r31
BEQ_else.9398:
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r10, %r27, BEQ_else.9400
	ADDI	%r4, %r0, 1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r9, 0
	ADDI	%r1, %r4, 0
	ADDI	%r26, %r8, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9401
BEQ_else.9400:
	SW	%r9, 4(%r30)
	SW	%r8, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r6, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r10, 0
	ADDI	%r26, %r7, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9402
	J	BEQ_cont.9403
BEQ_else.9402:
	LW	%r1, 7(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 6(%r30)
	LWC1	%f2, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fless.2607
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9404
	J	BEQ_cont.9405
BEQ_else.9404:
	ADDI	%r1, %r0, 1
	LW	%r2, 4(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9405:
BEQ_cont.9403:
BEQ_cont.9401:
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
judge_intersection.2971:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	LA	%r29, l.6808
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r5, %r0, 0
	LW	%r4, 0(%r4)
	SW	%r3, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r1, 0
	ADDI	%r26, %r2, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	LWC1	%f2, 0(%r1)
	LA	%r29, l.6788
	LWC1	%f1, 0(%r29)
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fless.2607
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9407
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9407:
	LA	%r29, l.6812
	LWC1	%f2, 0(%r29)
	LWC1	%f1, 2(%r30)
	J	fless.2607
solve_each_element_fast.2973:
	LW	%r4, 9(%r26)
	LW	%r5, 8(%r26)
	LW	%r6, 7(%r26)
	LW	%r7, 6(%r26)
	LW	%r8, 5(%r26)
	LW	%r9, 4(%r26)
	LW	%r10, 3(%r26)
	LW	%r11, 2(%r26)
	LW	%r12, 1(%r26)
	SW	%r9, 0(%r30)
	SW	%r11, 1(%r30)
	SW	%r10, 2(%r30)
	SW	%r12, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r7, 6(%r30)
	SW	%r26, 7(%r30)
	SW	%r8, 8(%r30)
	SW	%r3, 9(%r30)
	SW	%r6, 10(%r30)
	SW	%r1, 11(%r30)
	SW	%r2, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	d_vec.2788
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 11(%r30)
	LW	%r3, 12(%r30)
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.9408
	JR	%r31
BEQ_else.9408:
	LW	%r5, 9(%r30)
	LW	%r26, 10(%r30)
	SW	%r1, 13(%r30)
	SW	%r4, 14(%r30)
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
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9410
	LW	%r1, 14(%r30)
	LW	%r2, 8(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9411
	JR	%r31
BEQ_else.9411:
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 12(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 7(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9410:
	LW	%r2, 6(%r30)
	LWC1	%f2, 0(%r2)
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	SW	%r1, 15(%r30)
	SWC1	%f2, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fless.2607
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9413
	J	BEQ_cont.9414
BEQ_else.9413:
	LW	%r1, 5(%r30)
	LWC1	%f2, 0(%r1)
	LWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fless.2607
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9415
	J	BEQ_cont.9416
BEQ_else.9415:
	LA	%r29, l.6775
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 16(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 13(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 4(%r30)
	LWC1	%f3, 0(%r2)
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r2)
	ADD.s	%f3, %f3, %f4
	LWC1	%f4, 2(%r1)
	MUL.s	%f4, %f4, %f1
	LWC1	%f5, 2(%r2)
	ADD.s	%f4, %f4, %f5
	ADDI	%r1, %r0, 0
	LW	%r2, 12(%r30)
	LW	%r26, 3(%r30)
	SWC1	%f4, 18(%r30)
	SWC1	%f3, 20(%r30)
	SWC1	%f2, 22(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	ADD.s	%f3, %f4, %f0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9417
	J	BEQ_cont.9418
BEQ_else.9417:
	LW	%r1, 5(%r30)
	LWC1	%f1, 24(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 22(%r30)
	LWC1	%f2, 20(%r30)
	LWC1	%f3, 18(%r30)
	LW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	vecset.2681
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LW	%r2, 14(%r30)
	SW	%r2, 0(%r1)
	LW	%r1, 0(%r30)
	LW	%r2, 15(%r30)
	SW	%r2, 0(%r1)
BEQ_cont.9418:
BEQ_cont.9416:
BEQ_cont.9414:
	LW	%r1, 11(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 12(%r30)
	LW	%r3, 9(%r30)
	LW	%r26, 7(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
solve_one_or_network_fast.2977:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r6, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r6, %r27, BEQ_else.9419
	JR	%r31
BEQ_else.9419:
	ADD	%r29, %r5, %r6
	LW	%r5, 0(%r29)
	ADDI	%r6, %r0, 0
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r6, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
trace_or_matrix_fast.2981:
	LW	%r4, 4(%r26)
	LW	%r5, 3(%r26)
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r8, 0(%r29)
	LW	%r9, 0(%r8)
	ADDI	%r27, %r0, -1
	BNE	%r9, %r27, BEQ_else.9421
	JR	%r31
BEQ_else.9421:
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r9, %r27, BEQ_else.9423
	ADDI	%r4, %r0, 1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r8, 0
	ADDI	%r1, %r4, 0
	ADDI	%r26, %r7, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9424
BEQ_else.9423:
	SW	%r8, 4(%r30)
	SW	%r7, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r6, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r9, 0
	ADDI	%r26, %r5, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9425
	J	BEQ_cont.9426
BEQ_else.9425:
	LW	%r1, 7(%r30)
	LWC1	%f1, 0(%r1)
	LW	%r1, 6(%r30)
	LWC1	%f2, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fless.2607
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9427
	J	BEQ_cont.9428
BEQ_else.9427:
	ADDI	%r1, %r0, 1
	LW	%r2, 4(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9428:
BEQ_cont.9426:
BEQ_cont.9424:
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
judge_intersection_fast.2985:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	LA	%r29, l.6808
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r5, %r0, 0
	LW	%r4, 0(%r4)
	SW	%r3, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r1, 0
	ADDI	%r26, %r2, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r5, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	LWC1	%f2, 0(%r1)
	LA	%r29, l.6788
	LWC1	%f1, 0(%r29)
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fless.2607
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9430
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9430:
	LA	%r29, l.6812
	LWC1	%f2, 0(%r29)
	LWC1	%f1, 2(%r30)
	J	fless.2607
get_nvector_rect.2987:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LW	%r3, 0(%r3)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	vecbzero.2689
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	ADDI	%r2, %r1, -1
	ADDI	%r1, %r1, -1
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r1
	LWC1	%f1, 0(%r29)
	SW	%r2, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	sgn.2673
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fneg.2605
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	LW	%r2, 0(%r30)
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
get_nvector_plane.2989:
	LW	%r2, 1(%r26)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	fneg.2605
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	fneg.2605
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	fneg.2605
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 2(%r1)
	JR	%r31
get_nvector_second.2991:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LWC1	%f1, 0(%r3)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r2, 1(%r30)
	SWC1	%f1, 6(%r30)
	SWC1	%f2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r1, 1(%r30)
	SWC1	%f1, 10(%r30)
	SWC1	%f2, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_isrot.2735
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9434
	LW	%r1, 0(%r30)
	LWC1	%f1, 16(%r30)
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 18(%r30)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 20(%r30)
	SWC1	%f1, 2(%r1)
	J	BEQ_cont.9435
BEQ_else.9434:
	LW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f3, 22(%r30)
	ADD.s	%f1, %f3, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	fhalf.2610
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 0(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	o_param_r3.2765
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 24(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	fhalf.2610
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 0(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	o_param_r2.2763
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	o_param_r1.2761
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	fhalf.2610
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	ADD.s	%f1, %f2, %f1
	LW	%r1, 0(%r30)
	SWC1	%f1, 2(%r1)
BEQ_cont.9435:
	LW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	o_isinvert.2733
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	J	vecunit_sgn.2699
get_nvector.2993:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r4, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	o_form.2729
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9436
	LW	%r1, 3(%r30)
	LW	%r26, 4(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9436:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9437
	LW	%r1, 1(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9437:
	LW	%r1, 1(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
utexture.2996:
	LW	%r3, 1(%r26)
	SW	%r2, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	o_texturetype.2727
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_color_red.2755
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_color_green.2757
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 1(%r1)
	LW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_color_blue.2759
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 3(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r2, %r27, BEQ_else.9438
	LW	%r2, 0(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 2(%r30)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6874
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	floor.2618
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6875
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6866
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fless.2607
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	LWC1	%f1, 2(%r2)
	LW	%r2, 2(%r30)
	SW	%r1, 8(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6874
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	floor.2618
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6875
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 12(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6866
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	fless.2607
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.9440
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9442
	LA	%r29, l.6861
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.9443
BEQ_else.9442:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
BEQ_cont.9443:
	J	BEQ_cont.9441
BEQ_else.9440:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9444
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.9445
BEQ_else.9444:
	LA	%r29, l.6861
	LWC1	%f1, 0(%r29)
BEQ_cont.9445:
BEQ_cont.9441:
	LW	%r1, 1(%r30)
	SWC1	%f1, 1(%r1)
	JR	%r31
BEQ_else.9438:
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.9447
	LW	%r2, 0(%r30)
	LWC1	%f1, 1(%r2)
	LA	%r29, l.6870
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	sin.2632
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	fsqr.2612
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6861
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	LW	%r1, 1(%r30)
	SWC1	%f2, 0(%r1)
	LA	%r29, l.6861
	LWC1	%f2, 0(%r29)
	LA	%r29, l.6445
	LWC1	%f3, 0(%r29)
	SUB.s	%f1, %f3, %f1
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 1(%r1)
	JR	%r31
BEQ_else.9447:
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.9449
	LW	%r2, 0(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 2(%r30)
	SWC1	%f1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 0(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r1, 2(%r30)
	SWC1	%f1, 16(%r30)
	SWC1	%f2, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	SUB.s	%f1, %f2, %f1
	LWC1	%f2, 16(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fsqr.2612
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
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
	LWC1	%f2, 22(%r30)
	ADD.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	sqrt.2624
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6866
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	floor.2618
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6858
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	cos.2630
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	fsqr.2612
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6861
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	LW	%r1, 1(%r30)
	SWC1	%f2, 1(%r1)
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.9449:
	ADDI	%r27, %r0, 4
	BNE	%r2, %r27, BEQ_else.9451
	LW	%r2, 0(%r30)
	LWC1	%f1, 0(%r2)
	LW	%r3, 2(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	o_param_x.2745
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 26(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	SWC1	%f1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	sqrt.2624
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 28(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 0(%r30)
	LWC1	%f2, 2(%r1)
	LW	%r2, 2(%r30)
	SWC1	%f1, 30(%r30)
	SWC1	%f2, 32(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	o_param_z.2749
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	SWC1	%f1, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	sqrt.2624
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 34(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 30(%r30)
	SWC1	%f1, 36(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	JAL	fsqr.2612
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
	JAL	fsqr.2612
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 38(%r30)
	ADD.s	%f1, %f2, %f1
	LWC1	%f2, 30(%r30)
	SWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	fabs.2616
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6855
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	fless.2607
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9452
	LWC1	%f1, 30(%r30)
	LWC1	%f2, 36(%r30)
	DIV.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	fabs.2616
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	atan.2634
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6857
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.6858
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.9453
BEQ_else.9452:
	LA	%r29, l.6856
	LWC1	%f1, 0(%r29)
BEQ_cont.9453:
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	floor.2618
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 42(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 0(%r30)
	LWC1	%f2, 1(%r1)
	LW	%r1, 2(%r30)
	SWC1	%f1, 44(%r30)
	SWC1	%f2, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	o_param_y.2747
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 46(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30)
	SWC1	%f1, 48(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	sqrt.2624
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 48(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 40(%r30)
	SWC1	%f1, 50(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	fabs.2616
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6855
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	fless.2607
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9454
	LWC1	%f1, 40(%r30)
	LWC1	%f2, 50(%r30)
	DIV.s	%f1, %f2, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	fabs.2616
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 52(%r30)
	ADDI	%r30, %r30, 53
	JAL	atan.2634
	ADDI	%r29, %r0, 53
	SUB	%r30, %r30, %r29
	LW	%r29, 52(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6857
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.6858
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.9455
BEQ_else.9454:
	LA	%r29, l.6856
	LWC1	%f1, 0(%r29)
BEQ_cont.9455:
	SWC1	%f1, 52(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 54(%r30)
	ADDI	%r30, %r30, 55
	JAL	floor.2618
	ADDI	%r29, %r0, 55
	SUB	%r30, %r30, %r29
	LW	%r29, 54(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 52(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6860
	LWC1	%f2, 0(%r29)
	LA	%r29, l.6444
	LWC1	%f3, 0(%r29)
	LWC1	%f4, 44(%r30)
	SUB.s	%f3, %f3, %f4
	SWC1	%f1, 54(%r30)
	SWC1	%f2, 56(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0
	SW	%r29, 58(%r30)
	ADDI	%r30, %r30, 59
	JAL	fsqr.2612
	ADDI	%r29, %r0, 59
	SUB	%r30, %r30, %r29
	LW	%r29, 58(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 56(%r30)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.6444
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 54(%r30)
	SUB.s	%f2, %f2, %f3
	SWC1	%f1, 58(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 60(%r30)
	ADDI	%r30, %r30, 61
	JAL	fsqr.2612
	ADDI	%r29, %r0, 61
	SUB	%r30, %r30, %r29
	LW	%r29, 60(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 58(%r30)
	SUB.s	%f1, %f2, %f1
	SWC1	%f1, 60(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 62(%r30)
	ADDI	%r30, %r30, 63
	JAL	fisneg.2603
	ADDI	%r29, %r0, 63
	SUB	%r30, %r30, %r29
	LW	%r29, 62(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9456
	LWC1	%f1, 60(%r30)
	J	BEQ_cont.9457
BEQ_else.9456:
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
BEQ_cont.9457:
	LA	%r29, l.6861
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.6862
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.9451:
	JR	%r31
add_light.2999:
	LW	%r1, 2(%r26)
	LW	%r2, 1(%r26)
	SWC1	%f3, 0(%r30)
	SWC1	%f2, 2(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r1, 6(%r30)
	SW	%r2, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fispos.2601
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9460
	J	BEQ_cont.9461
BEQ_else.9460:
	LWC1	%f1, 4(%r30)
	LW	%r1, 7(%r30)
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	vecaccum.2710
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9461:
	LWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fispos.2601
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9462
	JR	%r31
BEQ_else.9462:
	LWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fsqr.2612
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fsqr.2612
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 0(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 7(%r30)
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
trace_reflections.3003:
	LW	%r3, 8(%r26)
	LW	%r4, 7(%r26)
	LW	%r5, 6(%r26)
	LW	%r6, 5(%r26)
	LW	%r7, 4(%r26)
	LW	%r8, 3(%r26)
	LW	%r9, 2(%r26)
	LW	%r10, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9465
	ADD	%r29, %r4, %r1
	LW	%r4, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r10, 4(%r30)
	SW	%r2, 5(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r6, 8(%r30)
	SW	%r3, 9(%r30)
	SW	%r5, 10(%r30)
	SW	%r4, 11(%r30)
	SW	%r8, 12(%r30)
	SW	%r9, 13(%r30)
	SW	%r7, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	r_dvec.2794
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 14(%r30)
	SW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9466
	J	BEQ_cont.9467
BEQ_else.9466:
	LW	%r1, 13(%r30)
	LW	%r1, 0(%r1)
	SLL	%r1, %r1, 2
	LW	%r2, 12(%r30)
	LW	%r2, 0(%r2)
	ADD	%r1, %r1, %r2
	LW	%r2, 11(%r30)
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	r_surface_id.2792
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 16(%r30)
	BNE	%r2, %r1, BEQ_else.9468
	ADDI	%r1, %r0, 0
	LW	%r2, 10(%r30)
	LW	%r2, 0(%r2)
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
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9470
	LW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	d_vec.2788
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	veciprod.2702
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 11(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	r_bright.2796
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	MUL.s	%f3, %f1, %f2
	LWC1	%f4, 18(%r30)
	MUL.s	%f3, %f3, %f4
	LW	%r1, 15(%r30)
	SWC1	%f3, 20(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	d_vec.2788
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	JAL	veciprod.2702
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 22(%r30)
	MUL.s	%f2, %f2, %f1
	LWC1	%f1, 20(%r30)
	LWC1	%f3, 2(%r30)
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
	J	BEQ_cont.9471
BEQ_else.9470:
BEQ_cont.9471:
	J	BEQ_cont.9469
BEQ_else.9468:
BEQ_cont.9469:
BEQ_cont.9467:
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, -1
	LWC1	%f1, 6(%r30)
	LWC1	%f2, 2(%r30)
	LW	%r2, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9465:
	JR	%r31
trace_ray.3008:
	LW	%r4, 20(%r26)
	LW	%r5, 19(%r26)
	LW	%r6, 18(%r26)
	LW	%r7, 17(%r26)
	LW	%r8, 16(%r26)
	LW	%r9, 15(%r26)
	LW	%r10, 14(%r26)
	LW	%r11, 13(%r26)
	LW	%r12, 12(%r26)
	LW	%r13, 11(%r26)
	LW	%r14, 10(%r26)
	LW	%r15, 9(%r26)
	LW	%r16, 8(%r26)
	LW	%r17, 7(%r26)
	LW	%r18, 6(%r26)
	LW	%r19, 5(%r26)
	LW	%r20, 4(%r26)
	LW	%r21, 3(%r26)
	LW	%r22, 2(%r26)
	LW	%r23, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.9474
	SW	%r26, 0(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r6, 4(%r30)
	SW	%r5, 5(%r30)
	SW	%r15, 6(%r30)
	SW	%r10, 7(%r30)
	SW	%r23, 8(%r30)
	SW	%r9, 9(%r30)
	SW	%r12, 10(%r30)
	SW	%r14, 11(%r30)
	SW	%r7, 12(%r30)
	SW	%r3, 13(%r30)
	SW	%r18, 14(%r30)
	SW	%r4, 15(%r30)
	SW	%r19, 16(%r30)
	SW	%r8, 17(%r30)
	SW	%r21, 18(%r30)
	SW	%r13, 19(%r30)
	SW	%r20, 20(%r30)
	SW	%r11, 21(%r30)
	SW	%r22, 22(%r30)
	SWC1	%f1, 24(%r30)
	SW	%r16, 26(%r30)
	SW	%r1, 27(%r30)
	SW	%r2, 28(%r30)
	SW	%r17, 29(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 30(%r30)
	ADDI	%r30, %r30, 31
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 28(%r30)
	LW	%r26, 29(%r30)
	SW	%r1, 30(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9477
	ADDI	%r1, %r0, -1
	LW	%r2, 27(%r30)
	LW	%r3, 30(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.9478
	JR	%r31
BEQ_else.9478:
	LW	%r1, 28(%r30)
	LW	%r2, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	veciprod.2702
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
	SWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	fispos.2601
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9481
	JR	%r31
BEQ_else.9481:
	LWC1	%f1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	fsqr.2612
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 32(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 22(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 21(%r30)
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
BEQ_else.9477:
	LW	%r1, 20(%r30)
	LW	%r1, 0(%r1)
	LW	%r2, 19(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	SW	%r1, 34(%r30)
	SW	%r2, 35(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	o_reflectiontype.2731
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 35(%r30)
	SW	%r1, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 35(%r30)
	LW	%r2, 28(%r30)
	LW	%r26, 18(%r30)
	SWC1	%f1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 17(%r30)
	LW	%r2, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	veccpy.2691
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 35(%r30)
	LW	%r2, 16(%r30)
	LW	%r26, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 34(%r30)
	SLL	%r1, %r1, 2
	LW	%r2, 14(%r30)
	LW	%r2, 0(%r2)
	ADD	%r1, %r1, %r2
	LW	%r2, 27(%r30)
	LW	%r3, 30(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 27(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r3, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	veccpy.2691
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 35(%r30)
	SW	%r1, 40(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6444
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	fless.2607
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9485
	ADDI	%r1, %r0, 1
	LW	%r2, 27(%r30)
	LW	%r3, 40(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	p_energy.2777
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 27(%r30)
	ADD	%r29, %r1, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 12(%r30)
	SW	%r1, 41(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	veccpy.2691
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 27(%r30)
	LW	%r2, 41(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LA	%r29, l.6897
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 38(%r30)
	MUL.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	vecscale.2720
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 27(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r3, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	JAL	veccpy.2691
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9486
BEQ_else.9485:
	ADDI	%r1, %r0, 0
	LW	%r2, 27(%r30)
	LW	%r3, 40(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.9486:
	LA	%r29, l.6899
	LWC1	%f1, 0(%r29)
	LW	%r1, 28(%r30)
	LW	%r2, 11(%r30)
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	veciprod.2702
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 42(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 28(%r30)
	LW	%r2, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	vecaccum.2710
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 35(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	JAL	o_hilight.2753
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f2, %f1
	ADDI	%r1, %r0, 0
	LW	%r2, 10(%r30)
	LW	%r2, 0(%r2)
	LW	%r26, 9(%r30)
	SWC1	%f1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9487
	LW	%r1, 11(%r30)
	LW	%r2, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	veciprod.2702
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	JAL	fneg.2605
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 38(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 28(%r30)
	LW	%r2, 26(%r30)
	SWC1	%f1, 46(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	veciprod.2702
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	fneg.2605
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 46(%r30)
	LWC1	%f3, 44(%r30)
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9488
BEQ_else.9487:
BEQ_cont.9488:
	LW	%r1, 16(%r30)
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LWC1	%f1, 38(%r30)
	LWC1	%f2, 44(%r30)
	LW	%r2, 28(%r30)
	LW	%r26, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6902
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 48(%r30)
	ADDI	%r30, %r30, 49
	JAL	fless.2607
	ADDI	%r29, %r0, 49
	SUB	%r30, %r30, %r29
	LW	%r29, 48(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9489
	JR	%r31
BEQ_else.9489:
	LW	%r1, 27(%r30)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9491
	J	BEQ_cont.9492
BEQ_else.9491:
	ADDI	%r2, %r1, 1
	ADDI	%r3, %r0, -1
	LW	%r4, 30(%r30)
	ADD	%r29, %r4, %r2
	SW	%r3, 0(%r29)
BEQ_cont.9492:
	LW	%r2, 36(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.9493
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LW	%r2, 35(%r30)
	SWC1	%f1, 48(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 50(%r30)
	ADDI	%r30, %r30, 51
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 51
	SUB	%r30, %r30, %r29
	LW	%r29, 50(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 48(%r30)
	SUB.s	%f1, %f2, %f1
	LWC1	%f2, 24(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 27(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30)
	LWC1	%f2, 0(%r2)
	LWC1	%f3, 2(%r30)
	ADD.s	%f2, %f3, %f2
	LW	%r2, 28(%r30)
	LW	%r3, 13(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9493:
	JR	%r31
BEQ_else.9474:
	JR	%r31
trace_diffuse_ray.3014:
	LW	%r2, 12(%r26)
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
	SW	%r3, 0(%r30)
	SW	%r13, 1(%r30)
	SWC1	%f1, 2(%r30)
	SW	%r8, 4(%r30)
	SW	%r7, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r5, 7(%r30)
	SW	%r10, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r12, 10(%r30)
	SW	%r1, 11(%r30)
	SW	%r6, 12(%r30)
	SW	%r11, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r9, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9496
	JR	%r31
BEQ_else.9496:
	LW	%r1, 13(%r30)
	LW	%r1, 0(%r1)
	LW	%r2, 12(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 11(%r30)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	d_vec.2788
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LW	%r26, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LW	%r2, 8(%r30)
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
	ADDI	%r1, %r0, 0
	LW	%r2, 7(%r30)
	LW	%r2, 0(%r2)
	LW	%r26, 6(%r30)
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
	BNE	%r1, %r27, BEQ_else.9498
	LW	%r1, 5(%r30)
	LW	%r2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	veciprod.2702
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	fneg.2605
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	fispos.2601
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9500
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.9501
BEQ_else.9500:
	LWC1	%f1, 16(%r30)
BEQ_cont.9501:
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 14(%r30)
	SWC1	%f1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30)
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30)
	LW	%r2, 0(%r30)
	J	vecaccum.2710
BEQ_else.9498:
	JR	%r31
iter_trace_diffuse_rays.3017:
	LW	%r5, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.9503
	ADD	%r29, %r1, %r4
	LW	%r6, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r4, 3(%r30)
	SW	%r1, 4(%r30)
	SW	%r2, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	d_vec.2788
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	veciprod.2702
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fisneg.2603
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9504
	LW	%r1, 3(%r30)
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LA	%r29, l.6920
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 6(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9505
BEQ_else.9504:
	LW	%r1, 3(%r30)
	ADDI	%r2, %r1, 1
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	LA	%r29, l.6918
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 6(%r30)
	DIV.s	%f1, %f2, %f1
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9505:
	LW	%r1, 3(%r30)
	ADDI	%r4, %r1, -2
	LW	%r1, 4(%r30)
	LW	%r2, 5(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9503:
	JR	%r31
trace_diffuse_rays.3022:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r5, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 2(%r30)
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 3(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
trace_diffuse_ray_80percent.3026:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9507
	J	BEQ_cont.9508
BEQ_else.9507:
	LW	%r6, 0(%r5)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9508:
	LW	%r1, 4(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9509
	J	BEQ_cont.9510
BEQ_else.9509:
	LW	%r2, 3(%r30)
	LW	%r3, 1(%r2)
	LW	%r4, 1(%r30)
	LW	%r5, 0(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9510:
	LW	%r1, 4(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9511
	J	BEQ_cont.9512
BEQ_else.9511:
	LW	%r2, 3(%r30)
	LW	%r3, 2(%r2)
	LW	%r4, 1(%r30)
	LW	%r5, 0(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9512:
	LW	%r1, 4(%r30)
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.9513
	J	BEQ_cont.9514
BEQ_else.9513:
	LW	%r2, 3(%r30)
	LW	%r3, 3(%r2)
	LW	%r4, 1(%r30)
	LW	%r5, 0(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	ADDI	%r3, %r5, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9514:
	LW	%r1, 4(%r30)
	ADDI	%r27, %r0, 4
	BNE	%r1, %r27, BEQ_else.9515
	JR	%r31
BEQ_else.9515:
	LW	%r1, 3(%r30)
	LW	%r1, 4(%r1)
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
calc_diffuse_using_1point.3030:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SW	%r4, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	p_energy.2777
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	LW	%r3, 5(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 2(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	veccpy.2691
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	LW	%r3, 6(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 7(%r30)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r3, %r4, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	LW	%r2, 8(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r1, 0(%r30)
	LW	%r3, 2(%r30)
	J	vecaccumv.2723
calc_diffuse_using_5points.3033:
	LW	%r6, 2(%r26)
	LW	%r7, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	SW	%r6, 0(%r30)
	SW	%r7, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r4, 3(%r30)
	SW	%r3, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	ADDI	%r3, %r2, -1
	LW	%r4, 4(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	ADDI	%r3, %r2, 1
	LW	%r4, 4(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	LW	%r3, 6(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 1(%r30)
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	veccpy.2691
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	LW	%r2, 7(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	vecadd.2714
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	LW	%r2, 8(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	vecadd.2714
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	LW	%r2, 9(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	vecadd.2714
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	LW	%r2, 10(%r30)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	vecadd.2714
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	LW	%r2, 4(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	p_energy.2777
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	ADD	%r29, %r1, %r2
	LW	%r2, 0(%r29)
	LW	%r1, 0(%r30)
	LW	%r3, 1(%r30)
	J	vecaccumv.2723
do_without_neighbors.3039:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.9517
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r2, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9518
	LW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9519
	J	BEQ_cont.9520
BEQ_else.9519:
	LW	%r1, 2(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9520:
	LW	%r1, 3(%r30)
	ADDI	%r2, %r1, 1
	LW	%r1, 2(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9518:
	JR	%r31
BEQ_else.9517:
	JR	%r31
neighbors_exist.3042:
	LW	%r3, 1(%r26)
	LW	%r4, 1(%r3)
	ADDI	%r5, %r2, 1
	SLT	%r27, %r5, %r4
	BNE	%r27, %r0, BEQ_else.9523
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9523:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.9524
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9524:
	LW	%r2, 0(%r3)
	ADDI	%r3, %r1, 1
	SLT	%r27, %r3, %r2
	BNE	%r27, %r0, BEQ_else.9525
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9525:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.9526
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9526:
	ADDI	%r1, %r0, 1
	JR	%r31
get_surface_id.3046:
	SW	%r2, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	p_surface_ids.2773
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	JR	%r31
neighbors_are_available.3049:
	ADD	%r29, %r3, %r1
	LW	%r6, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r1, 3(%r30)
	SW	%r2, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r6, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	LW	%r3, 4(%r30)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 2(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	BNE	%r1, %r2, BEQ_else.9527
	LW	%r1, 3(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	BNE	%r1, %r2, BEQ_else.9528
	LW	%r1, 3(%r30)
	ADDI	%r3, %r1, -1
	LW	%r4, 0(%r30)
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	LW	%r5, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	BNE	%r1, %r2, BEQ_else.9529
	LW	%r1, 3(%r30)
	ADDI	%r1, %r1, 1
	LW	%r3, 0(%r30)
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LW	%r3, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	BNE	%r1, %r2, BEQ_else.9530
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.9530:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9529:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9528:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.9527:
	ADDI	%r1, %r0, 0
	JR	%r31
try_exploit_neighbors.3055:
	LW	%r7, 2(%r26)
	LW	%r8, 1(%r26)
	ADD	%r29, %r4, %r1
	LW	%r9, 0(%r29)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.9531
	SW	%r2, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r8, 2(%r30)
	SW	%r9, 3(%r30)
	SW	%r7, 4(%r30)
	SW	%r6, 5(%r30)
	SW	%r5, 6(%r30)
	SW	%r4, 7(%r30)
	SW	%r3, 8(%r30)
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0
	ADDI	%r1, %r9, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9532
	LW	%r1, 9(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 7(%r30)
	LW	%r4, 6(%r30)
	LW	%r5, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	neighbors_are_available.3049
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9533
	LW	%r1, 9(%r30)
	LW	%r2, 7(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 5(%r30)
	LW	%r26, 4(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9533:
	LW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r5, 5(%r30)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9534
	J	BEQ_cont.9535
BEQ_else.9534:
	LW	%r1, 9(%r30)
	LW	%r2, 8(%r30)
	LW	%r3, 7(%r30)
	LW	%r4, 6(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9535:
	LW	%r1, 5(%r30)
	ADDI	%r6, %r1, 1
	LW	%r1, 9(%r30)
	LW	%r2, 0(%r30)
	LW	%r3, 8(%r30)
	LW	%r4, 7(%r30)
	LW	%r5, 6(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9532:
	JR	%r31
BEQ_else.9531:
	JR	%r31
write_ppm_header.3062:
	LW	%r1, 1(%r26)
	ADDI	%r2, %r0, 80
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 51
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	LW	%r2, 0(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	LW	%r1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 255
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	J	min_caml_print_char
write_rgb_element.3064:
	LW	%r26, 1(%r26)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.9538
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9540
	J	BEQ_cont.9541
BEQ_else.9540:
	ADDI	%r1, %r0, 0
BEQ_cont.9541:
	J	BEQ_cont.9539
BEQ_else.9538:
	ADDI	%r1, %r0, 255
BEQ_cont.9539:
	J	min_caml_print_int
write_rgb.3066:
	LW	%r1, 2(%r26)
	LW	%r2, 1(%r26)
	LWC1	%f1, 0(%r2)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r1, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f1, 1(%r1)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	LWC1	%f1, 2(%r1)
	LW	%r26, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	J	min_caml_print_char
pretrace_diffuse_rays.3068:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.9542
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	get_surface_id.3046
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9543
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	p_calc_diffuse.2775
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9544
	J	BEQ_cont.9545
BEQ_else.9544:
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	p_group_id.2781
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	vecbzero.2689
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	p_nvectors.2786
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	p_intersection_points.2771
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 6(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	LW	%r3, 4(%r30)
	LW	%r4, 7(%r30)
	ADD	%r29, %r4, %r3
	LW	%r4, 0(%r29)
	ADD	%r29, %r1, %r3
	LW	%r1, 0(%r29)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r1, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	p_received_ray_20percent.2779
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30)
	ADD	%r29, %r1, %r2
	LW	%r1, 0(%r29)
	LW	%r3, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	veccpy.2691
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9545:
	LW	%r1, 4(%r30)
	ADDI	%r2, %r1, 1
	LW	%r1, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9543:
	JR	%r31
BEQ_else.9542:
	JR	%r31
pretrace_pixels.3071:
	LW	%r4, 9(%r26)
	LW	%r5, 8(%r26)
	LW	%r6, 7(%r26)
	LW	%r7, 6(%r26)
	LW	%r8, 5(%r26)
	LW	%r9, 4(%r26)
	LW	%r10, 3(%r26)
	LW	%r11, 2(%r26)
	LW	%r12, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9548
	LWC1	%f4, 0(%r8)
	LW	%r8, 0(%r12)
	SUB	%r8, %r2, %r8
	SW	%r26, 0(%r30)
	SW	%r11, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r6, 7(%r30)
	SW	%r9, 8(%r30)
	SWC1	%f3, 10(%r30)
	SWC1	%f2, 12(%r30)
	SW	%r10, 14(%r30)
	SWC1	%f1, 16(%r30)
	SW	%r7, 18(%r30)
	SWC1	%f4, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r8, 0
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
	LWC1	%f3, 16(%r30)
	ADD.s	%f2, %f2, %f3
	LW	%r2, 14(%r30)
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f4, 12(%r30)
	ADD.s	%f2, %f2, %f4
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 10(%r30)
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r2)
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	vecunit_sgn.2699
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	vecbzero.2689
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	LW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	veccpy.2691
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	LW	%r2, 4(%r30)
	LW	%r3, 5(%r30)
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	LW	%r5, 14(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r4, 0
	ADDI	%r2, %r5, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	p_rgb.2769
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	veccpy.2691
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	p_set_group_id.2783
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r2, %r0, 1
	LW	%r3, 2(%r30)
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	add_mod5.2678
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r3, %r1, 0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	LWC1	%f2, 12(%r30)
	LWC1	%f3, 10(%r30)
	LW	%r1, 5(%r30)
	LW	%r2, 22(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9548:
	JR	%r31
pretrace_line.3078:
	LW	%r4, 6(%r26)
	LW	%r5, 5(%r26)
	LW	%r6, 4(%r26)
	LW	%r7, 3(%r26)
	LW	%r8, 2(%r26)
	LW	%r9, 1(%r26)
	LWC1	%f1, 0(%r6)
	LW	%r6, 1(%r9)
	SUB	%r2, %r2, %r6
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r7, 2(%r30)
	SW	%r8, 3(%r30)
	SW	%r4, 4(%r30)
	SW	%r5, 5(%r30)
	SWC1	%f1, 6(%r30)
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
	MUL.s	%f1, %f2, %f1
	LW	%r1, 5(%r30)
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LW	%r2, 4(%r30)
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
	LW	%r1, 3(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r2, %r1, -1
	LW	%r1, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 2(%r30)
	ADD.s	%f31, %f3, %f0
	ADD.s	%f3, %f1, %f0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f31, %f0
	LW	%r25, 0(%r26)
	JR	%r25
scan_pixel.3082:
	LW	%r6, 6(%r26)
	LW	%r7, 5(%r26)
	LW	%r8, 4(%r26)
	LW	%r9, 3(%r26)
	LW	%r10, 2(%r26)
	LW	%r11, 1(%r26)
	LW	%r10, 0(%r10)
	SLT	%r27, %r1, %r10
	BNE	%r27, %r0, BEQ_else.9553
	JR	%r31
BEQ_else.9553:
	ADD	%r29, %r4, %r1
	LW	%r10, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r6, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r7, 3(%r30)
	SW	%r11, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r5, 6(%r30)
	SW	%r2, 7(%r30)
	SW	%r1, 8(%r30)
	SW	%r9, 9(%r30)
	SW	%r8, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r10, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	p_rgb.2769
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	veccpy.2691
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	LW	%r2, 7(%r30)
	LW	%r3, 6(%r30)
	LW	%r26, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9555
	LW	%r1, 8(%r30)
	LW	%r2, 5(%r30)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.9556
BEQ_else.9555:
	ADDI	%r6, %r0, 0
	LW	%r1, 8(%r30)
	LW	%r2, 7(%r30)
	LW	%r3, 2(%r30)
	LW	%r4, 5(%r30)
	LW	%r5, 6(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9556:
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 7(%r30)
	LW	%r3, 2(%r30)
	LW	%r4, 5(%r30)
	LW	%r5, 6(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
scan_line.3088:
	LW	%r6, 3(%r26)
	LW	%r7, 2(%r26)
	LW	%r8, 1(%r26)
	LW	%r9, 1(%r8)
	SLT	%r27, %r1, %r9
	BNE	%r27, %r0, BEQ_else.9557
	JR	%r31
BEQ_else.9557:
	LW	%r8, 1(%r8)
	ADDI	%r8, %r8, -1
	SW	%r26, 0(%r30)
	SW	%r5, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r3, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r6, 6(%r30)
	SLT	%r27, %r1, %r8
	BNE	%r27, %r0, BEQ_else.9559
	J	BEQ_cont.9560
BEQ_else.9559:
	ADDI	%r8, %r1, 1
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0
	ADDI	%r2, %r8, 0
	ADDI	%r1, %r4, 0
	ADDI	%r26, %r7, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.9560:
	ADDI	%r1, %r0, 0
	LW	%r2, 5(%r30)
	LW	%r3, 4(%r30)
	LW	%r4, 3(%r30)
	LW	%r5, 2(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30)
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, 2
	LW	%r3, 1(%r30)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	add_mod5.2678
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r5, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30)
	LW	%r2, 3(%r30)
	LW	%r3, 2(%r30)
	LW	%r4, 4(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
create_float5x3array.3094:
	ADDI	%r1, %r0, 3
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 5
	ADDI	%r3, %r0, 0
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
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
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r1, 7(%r2)
	LW	%r1, 6(%r30)
	SW	%r1, 6(%r2)
	LW	%r1, 5(%r30)
	SW	%r1, 5(%r2)
	LW	%r1, 4(%r30)
	SW	%r1, 4(%r2)
	LW	%r1, 3(%r30)
	SW	%r1, 3(%r2)
	LW	%r1, 2(%r30)
	SW	%r1, 2(%r2)
	LW	%r1, 1(%r30)
	SW	%r1, 1(%r2)
	LW	%r1, 0(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	JR	%r31
init_line_elements.3098:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9561
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r1, %r3, 0
	J	init_line_elements.3098
BEQ_else.9561:
	JR	%r31
create_pixelline.3101:
	LW	%r1, 1(%r26)
	LW	%r2, 0(%r1)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30)
	LW	%r2, 0(%r2)
	ADDI	%r2, %r2, -2
	J	init_line_elements.3098
tan.3103:
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	sin.2632
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 0(%r30)
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	cos.2630
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	DIV.s	%f1, %f2, %f1
	JR	%r31
adjust_position.3105:
	MUL.s	%f1, %f1, %f1
	LA	%r29, l.6902
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	SWC1	%f2, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	sqrt.2624
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	atan.2634
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 0(%r30)
	MUL.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	tan.3103
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 2(%r30)
	MUL.s	%f1, %f1, %f2
	JR	%r31
calc_dirvec.3108:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9562
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r4, 2(%r30)
	SWC1	%f1, 4(%r30)
	SWC1	%f2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	fsqr.2612
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	fsqr.2612
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	ADD.s	%f1, %f2, %f1
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	sqrt.2624
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30)
	DIV.s	%f2, %f2, %f1
	LWC1	%f3, 6(%r30)
	DIV.s	%f3, %f3, %f1
	LA	%r29, l.6445
	LWC1	%f4, 0(%r29)
	DIV.s	%f1, %f4, %f1
	LW	%r1, 1(%r30)
	LW	%r2, 2(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 0(%r30)
	ADD	%r29, %r1, %r2
	LW	%r3, 0(%r29)
	SW	%r1, 10(%r30)
	SWC1	%f1, 12(%r30)
	SWC1	%f3, 14(%r30)
	SWC1	%f2, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	d_vec.2788
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	vecset.2681
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r2, %r1, 40
	LW	%r3, 10(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	d_vec.2788
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 14(%r30)
	SW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	fneg.2605
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADD.s	%f3, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	LWC1	%f2, 12(%r30)
	LW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	vecset.2681
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r2, %r1, 80
	LW	%r3, 10(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 19(%r30)
	ADDI	%r30, %r30, 20
	JAL	d_vec.2788
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	SW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	JAL	fneg.2605
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	fneg.2605
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADD.s	%f3, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 20(%r30)
	LW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	vecset.2681
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r2, %r1, 1
	LW	%r3, 10(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	d_vec.2788
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	fneg.2605
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30)
	SWC1	%f1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 26(%r30)
	ADDI	%r30, %r30, 27
	JAL	fneg.2605
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	fneg.2605
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADD.s	%f3, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 24(%r30)
	LWC1	%f2, 26(%r30)
	LW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	vecset.2681
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r2, %r1, 41
	LW	%r3, 10(%r30)
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 28(%r30)
	ADDI	%r30, %r30, 29
	JAL	d_vec.2788
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 16(%r30)
	SW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 29(%r30)
	ADDI	%r30, %r30, 30
	JAL	fneg.2605
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	SWC1	%f1, 30(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	fneg.2605
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 30(%r30)
	LWC1	%f3, 14(%r30)
	LW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	vecset.2681
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 81
	LW	%r2, 10(%r30)
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	d_vec.2788
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 12(%r30)
	SW	%r1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 33(%r30)
	ADDI	%r30, %r30, 34
	JAL	fneg.2605
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	LWC1	%f3, 14(%r30)
	LW	%r1, 32(%r30)
	J	vecset.2681
BEQ_else.9562:
	SWC1	%f3, 34(%r30)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 36(%r30)
	SWC1	%f4, 38(%r30)
	SW	%r1, 40(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	ADD.s	%f2, %f3, %f0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	JAL	adjust_position.3105
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 40(%r30)
	ADDI	%r1, %r1, 1
	LWC1	%f2, 38(%r30)
	SWC1	%f1, 42(%r30)
	SW	%r1, 44(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 45(%r30)
	ADDI	%r30, %r30, 46
	JAL	adjust_position.3105
	ADDI	%r29, %r0, 46
	SUB	%r30, %r30, %r29
	LW	%r29, 45(%r30)
	ADD.s	%f2, %f1, %f0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 42(%r30)
	LWC1	%f3, 34(%r30)
	LWC1	%f4, 38(%r30)
	LW	%r1, 44(%r30)
	LW	%r2, 1(%r30)
	LW	%r3, 0(%r30)
	LW	%r26, 36(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
calc_dirvecs.3116:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9570
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f1, 2(%r30)
	SW	%r3, 4(%r30)
	SW	%r2, 5(%r30)
	SW	%r4, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.7014
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.7015
	LWC1	%f2, 0(%r29)
	SUB.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	LWC1	%f4, 2(%r30)
	LW	%r2, 5(%r30)
	LW	%r3, 4(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.7014
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.6902
	LWC1	%f2, 0(%r29)
	ADD.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	LA	%r29, l.6443
	LWC1	%f2, 0(%r29)
	LW	%r2, 4(%r30)
	ADDI	%r3, %r2, 2
	LWC1	%f4, 2(%r30)
	LW	%r4, 5(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r2, %r0, 1
	LW	%r3, 5(%r30)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	add_mod5.2678
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LWC1	%f1, 2(%r30)
	LW	%r1, 7(%r30)
	LW	%r3, 4(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9570:
	JR	%r31
calc_dirvec_rows.3121:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9572
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r4, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.7014
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.7015
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 4
	LW	%r2, 3(%r30)
	LW	%r3, 2(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, -1
	ADDI	%r2, %r0, 2
	LW	%r3, 3(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	JAL	add_mod5.2678
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	ADDI	%r3, %r1, 4
	LW	%r1, 5(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9572:
	JR	%r31
create_dirvec.3125:
	LW	%r1, 1(%r26)
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9574
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r3, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30)
	LW	%r3, 2(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	LW	%r26, 0(%r30)
	ADDI	%r1, %r3, 0
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9574:
	JR	%r31
create_dirvecs.3130:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9576
	ADDI	%r5, %r0, 120
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r4, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30)
	LW	%r3, 3(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	ADDI	%r3, %r0, 118
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, -1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9576:
	JR	%r31
init_dirvec_constants.3132:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.9578
	ADD	%r29, %r1, %r2
	LW	%r4, 0(%r29)
	SW	%r1, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	ADDI	%r26, %r3, 0
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	ADDI	%r2, %r1, -1
	LW	%r1, 0(%r30)
	LW	%r26, 1(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9578:
	JR	%r31
init_vecset_constants.3135:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9580
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 119
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0
	ADDI	%r26, %r2, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, -1
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9580:
	JR	%r31
init_dirvecs.3137:
	LW	%r1, 3(%r26)
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	ADDI	%r4, %r0, 4
	SW	%r1, 0(%r30)
	SW	%r3, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	ADDI	%r26, %r2, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 9
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r0, 0
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
add_reflection.3139:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r26, 1(%r26)
	SW	%r1, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r2, 2(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r3, 6(%r30)
	SWC1	%f4, 8(%r30)
	SWC1	%f3, 10(%r30)
	SWC1	%f2, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	d_vec.2788
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f1, 12(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	JAL	vecset.2681
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 14(%r30)
	LW	%r26, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 4(%r30)
	SWC1	%f1, 2(%r1)
	LW	%r2, 14(%r30)
	SW	%r2, 1(%r1)
	LW	%r2, 2(%r30)
	SW	%r2, 0(%r1)
	LW	%r2, 0(%r30)
	LW	%r3, 1(%r30)
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	JR	%r31
setup_rect_reflection.3146:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SLL	%r1, %r1, 2
	LW	%r6, 0(%r3)
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r6, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r1, 3(%r30)
	SW	%r4, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 4(%r30)
	LWC1	%f2, 0(%r1)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	fneg.2605
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LWC1	%f2, 1(%r1)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	JAL	fneg.2605
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	LWC1	%f2, 2(%r1)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	fneg.2605
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADD.s	%f4, %f1, %f0
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	ADDI	%r2, %r1, 1
	LW	%r3, 4(%r30)
	LWC1	%f2, 0(%r3)
	LWC1	%f1, 8(%r30)
	LWC1	%f3, 12(%r30)
	LW	%r4, 1(%r30)
	LW	%r26, 2(%r30)
	SWC1	%f4, 14(%r30)
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
	LW	%r1, 1(%r30)
	ADDI	%r2, %r1, 1
	LW	%r3, 3(%r30)
	ADDI	%r4, %r3, 2
	LW	%r5, 4(%r30)
	LWC1	%f3, 1(%r5)
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f4, 14(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r4, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r2, %r1, 2
	LW	%r3, 3(%r30)
	ADDI	%r3, %r3, 3
	LW	%r4, 4(%r30)
	LWC1	%f4, 2(%r4)
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 10(%r30)
	LWC1	%f3, 12(%r30)
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30)
	ADDI	%r1, %r1, 3
	LW	%r2, 0(%r30)
	SW	%r1, 0(%r2)
	JR	%r31
setup_surface_reflection.3149:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	SLL	%r1, %r1, 2
	ADDI	%r1, %r1, 1
	LW	%r6, 0(%r3)
	LA	%r29, l.6445
	LWC1	%f1, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r6, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r4, 4(%r30)
	SW	%r2, 5(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30)
	SUB.s	%f1, %f2, %f1
	LW	%r1, 5(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	o_param_abc.2743
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	veciprod.2702
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6446
	LWC1	%f2, 0(%r29)
	LW	%r1, 5(%r30)
	SWC1	%f1, 10(%r30)
	SWC1	%f2, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	o_param_a.2737
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 4(%r30)
	LWC1	%f3, 0(%r1)
	SUB.s	%f1, %f1, %f3
	LA	%r29, l.6446
	LWC1	%f3, 0(%r29)
	LW	%r2, 5(%r30)
	SWC1	%f1, 14(%r30)
	SWC1	%f3, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	JAL	o_param_b.2739
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 16(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 4(%r30)
	LWC1	%f3, 1(%r1)
	SUB.s	%f1, %f1, %f3
	LA	%r29, l.6446
	LWC1	%f3, 0(%r29)
	LW	%r2, 5(%r30)
	SWC1	%f1, 18(%r30)
	SWC1	%f3, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	JAL	o_param_c.2741
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30)
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 10(%r30)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 4(%r30)
	LWC1	%f2, 2(%r1)
	SUB.s	%f4, %f1, %f2
	LWC1	%f1, 8(%r30)
	LWC1	%f2, 14(%r30)
	LWC1	%f3, 18(%r30)
	LW	%r1, 2(%r30)
	LW	%r2, 1(%r30)
	LW	%r26, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 0(%r30)
	SW	%r1, 0(%r2)
	JR	%r31
setup_reflections.3152:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.9588
	ADD	%r29, %r4, %r1
	LW	%r4, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r4, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_reflectiontype.2731
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9589
	LW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_diffuse.2751
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.6445
	LWC1	%f2, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	fless.2607
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.9590
	JR	%r31
BEQ_else.9590:
	LW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	o_form.2729
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.9592
	LW	%r1, 1(%r30)
	LW	%r2, 3(%r30)
	LW	%r26, 2(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9592:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.9593
	LW	%r1, 1(%r30)
	LW	%r2, 3(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.9593:
	JR	%r31
BEQ_else.9589:
	JR	%r31
BEQ_else.9588:
	JR	%r31
rt.3154:
	LW	%r3, 14(%r26)
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
	SW	%r1, 0(%r14)
	SW	%r2, 1(%r14)
	SRA	%r14, %r1, 1
	SW	%r14, 0(%r15)
	SRA	%r2, %r2, 1
	SW	%r2, 1(%r15)
	LA	%r29, l.7048
	LWC1	%f1, 0(%r29)
	SW	%r7, 0(%r30)
	SW	%r9, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r10, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r12, 5(%r30)
	SW	%r11, 6(%r30)
	SW	%r13, 7(%r30)
	SW	%r3, 8(%r30)
	SW	%r8, 9(%r30)
	SW	%r16, 10(%r30)
	SW	%r6, 11(%r30)
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
	DIV.s	%f1, %f2, %f1
	LW	%r1, 11(%r30)
	SWC1	%f1, 0(%r1)
	LW	%r26, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 10(%r30)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 15(%r30)
	ADDI	%r30, %r30, 16
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 16
	SUB	%r30, %r30, %r29
	LW	%r29, 15(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 10(%r30)
	SW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 9(%r30)
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	d_vec.2788
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	veccpy.2691
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30)
	LW	%r26, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30)
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LW	%r26, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r0, 0
	LW	%r1, 15(%r30)
	LW	%r26, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	ADDI	%r5, %r0, 2
	LW	%r2, 14(%r30)
	LW	%r3, 15(%r30)
	LW	%r4, 16(%r30)
	LW	%r26, 0(%r30)
	LW	%r25, 0(%r26)
	JR	%r25
_min_caml_start: # main entry point
	SUB	%r0, %r0, %r0
	ADDI	%r28, %r0, 8192
   # main program start
	ADDI	%r1, %r0, 32
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	ADDI	%r1, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.6443
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
	SW	%r29, 3(%r30)
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 1
	LA	%r29, l.6861
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
	ADDI	%r2, %r0, 50
	ADDI	%r3, %r0, 1
	ADDI	%r4, %r0, -1
	SW	%r1, 7(%r30)
	SW	%r2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 1
	LW	%r4, 0(%r1)
	SW	%r1, 9(%r30)
	SW	%r2, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0
	ADDI	%r1, %r3, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.6808
	LWC1	%f1, 0(%r29)
	SW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 15(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 2
	ADDI	%r3, %r0, 0
	SW	%r1, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 21(%r30)
	ADDI	%r30, %r30, 22
	JAL	min_caml_create_array
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
	ADDI	%r2, %r0, 1
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 23(%r30)
	ADDI	%r30, %r30, 24
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 0
	LA	%r29, l.6443
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
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	SW	%r2, 30(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r3)
	LW	%r1, 30(%r30)
	SW	%r1, 0(%r3)
	ADDI	%r1, %r3, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30)
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	SW	%r1, 31(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 32(%r30)
	ADDI	%r30, %r30, 33
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.6443
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
	ADDI	%r2, %r0, 60
	LW	%r3, 32(%r30)
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 33(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.6443
	LWC1	%f1, 0(%r29)
	SW	%r1, 34(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	SW	%r29, 35(%r30)
	ADDI	%r30, %r30, 36
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 36
	SUB	%r30, %r30, %r29
	LW	%r29, 35(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	SW	%r2, 35(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 35(%r30)
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r0, 180
	ADDI	%r3, %r0, 0
	LA	%r29, l.6443
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
	SW	%r29, 36(%r30)
	ADDI	%r30, %r30, 37
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r3, 0
	SW	%r29, 37(%r30)
	ADDI	%r30, %r30, 38
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r3, read_screen_settings.2800
	SW	%r3, 0(%r2)
	LW	%r3, 5(%r30)
	SW	%r3, 5(%r2)
	LW	%r4, 28(%r30)
	SW	%r4, 4(%r2)
	LW	%r5, 27(%r30)
	SW	%r5, 3(%r2)
	LW	%r6, 26(%r30)
	SW	%r6, 2(%r2)
	LW	%r7, 4(%r30)
	SW	%r7, 1(%r2)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r8, read_light.2802
	SW	%r8, 0(%r7)
	LW	%r8, 6(%r30)
	SW	%r8, 2(%r7)
	LW	%r9, 7(%r30)
	SW	%r9, 1(%r7)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r11, read_nth_object.2807
	SW	%r11, 0(%r10)
	LW	%r11, 3(%r30)
	SW	%r11, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r13, read_object.2809
	SW	%r13, 0(%r12)
	SW	%r10, 2(%r12)
	LW	%r10, 2(%r30)
	SW	%r10, 1(%r12)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r14, read_all_object.2811
	SW	%r14, 0(%r13)
	SW	%r12, 1(%r13)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r14, read_and_network.2817
	SW	%r14, 0(%r12)
	LW	%r14, 9(%r30)
	SW	%r14, 1(%r12)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r16, read_parameter.2819
	SW	%r16, 0(%r15)
	SW	%r2, 5(%r15)
	SW	%r7, 4(%r15)
	SW	%r12, 3(%r15)
	SW	%r13, 2(%r15)
	LW	%r2, 11(%r30)
	SW	%r2, 1(%r15)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r12, solver_rect_surface.2821
	SW	%r12, 0(%r7)
	LW	%r12, 12(%r30)
	SW	%r12, 1(%r7)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, solver_rect.2830
	SW	%r16, 0(%r13)
	SW	%r7, 1(%r13)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, solver_surface.2836
	SW	%r16, 0(%r7)
	SW	%r12, 1(%r7)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, solver_second.2855
	SW	%r17, 0(%r16)
	SW	%r12, 1(%r16)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r18, solver.2861
	SW	%r18, 0(%r17)
	SW	%r7, 4(%r17)
	SW	%r16, 3(%r17)
	SW	%r13, 2(%r17)
	SW	%r11, 1(%r17)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r13, solver_rect_fast.2865
	SW	%r13, 0(%r7)
	SW	%r12, 1(%r7)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, solver_surface_fast.2872
	SW	%r16, 0(%r13)
	SW	%r12, 1(%r13)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r18, solver_second_fast.2878
	SW	%r18, 0(%r16)
	SW	%r12, 1(%r16)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r19, solver_fast.2884
	SW	%r19, 0(%r18)
	SW	%r13, 4(%r18)
	SW	%r16, 3(%r18)
	SW	%r7, 2(%r18)
	SW	%r11, 1(%r18)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, solver_surface_fast2.2888
	SW	%r16, 0(%r13)
	SW	%r12, 1(%r13)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r19, solver_second_fast2.2895
	SW	%r19, 0(%r16)
	SW	%r12, 1(%r16)
	ADDI	%r19, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r20, solver_fast2.2902
	SW	%r20, 0(%r19)
	SW	%r13, 4(%r19)
	SW	%r16, 3(%r19)
	SW	%r7, 2(%r19)
	SW	%r11, 1(%r19)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r13, iter_setup_dirvec_constants.2914
	SW	%r13, 0(%r7)
	SW	%r11, 1(%r7)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r16, setup_dirvec_constants.2917
	SW	%r16, 0(%r13)
	SW	%r10, 2(%r13)
	SW	%r7, 1(%r13)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, setup_startp_constants.2919
	SW	%r16, 0(%r7)
	SW	%r11, 1(%r7)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r20, setup_startp.2922
	SW	%r20, 0(%r16)
	LW	%r20, 25(%r30)
	SW	%r20, 3(%r16)
	SW	%r7, 2(%r16)
	SW	%r10, 1(%r16)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r21, check_all_inside.2944
	SW	%r21, 0(%r7)
	SW	%r11, 1(%r7)
	ADDI	%r21, %r28, 0
	ADDI	%r28, %r28, 8
	LA	%r22, shadow_check_and_group.2950
	SW	%r22, 0(%r21)
	SW	%r18, 7(%r21)
	SW	%r12, 6(%r21)
	SW	%r11, 5(%r21)
	LW	%r22, 34(%r30)
	SW	%r22, 4(%r21)
	SW	%r8, 3(%r21)
	LW	%r23, 15(%r30)
	SW	%r23, 2(%r21)
	SW	%r7, 1(%r21)
	ADDI	%r24, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r25, shadow_check_one_or_group.2953
	SW	%r25, 0(%r24)
	SW	%r21, 2(%r24)
	SW	%r14, 1(%r24)
	ADDI	%r21, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r25, shadow_check_one_or_matrix.2956
	SW	%r25, 0(%r21)
	SW	%r18, 5(%r21)
	SW	%r12, 4(%r21)
	SW	%r24, 3(%r21)
	SW	%r22, 2(%r21)
	SW	%r23, 1(%r21)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r24, solve_each_element.2959
	SW	%r24, 0(%r18)
	LW	%r24, 14(%r30)
	SW	%r24, 9(%r18)
	LW	%r25, 24(%r30)
	SW	%r25, 8(%r18)
	SW	%r12, 7(%r18)
	SW	%r17, 6(%r18)
	SW	%r11, 5(%r18)
	LW	%r26, 13(%r30)
	SW	%r26, 4(%r18)
	SW	%r23, 3(%r18)
	LW	%r22, 16(%r30)
	SW	%r22, 2(%r18)
	SW	%r7, 1(%r18)
	SW	%r15, 37(%r30)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 3
	SW	%r13, 38(%r30)
	LA	%r13, solve_one_or_network.2963
	SW	%r13, 0(%r15)
	SW	%r18, 2(%r15)
	SW	%r14, 1(%r15)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r18, trace_or_matrix.2967
	SW	%r18, 0(%r13)
	SW	%r24, 5(%r13)
	SW	%r25, 4(%r13)
	SW	%r12, 3(%r13)
	SW	%r17, 2(%r13)
	SW	%r15, 1(%r13)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r17, judge_intersection.2971
	SW	%r17, 0(%r15)
	SW	%r13, 3(%r15)
	SW	%r24, 2(%r15)
	SW	%r2, 1(%r15)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r17, solve_each_element_fast.2973
	SW	%r17, 0(%r13)
	SW	%r24, 9(%r13)
	SW	%r20, 8(%r13)
	SW	%r19, 7(%r13)
	SW	%r12, 6(%r13)
	SW	%r11, 5(%r13)
	SW	%r26, 4(%r13)
	SW	%r23, 3(%r13)
	SW	%r22, 2(%r13)
	SW	%r7, 1(%r13)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r17, solve_one_or_network_fast.2977
	SW	%r17, 0(%r7)
	SW	%r13, 2(%r7)
	SW	%r14, 1(%r7)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r14, trace_or_matrix_fast.2981
	SW	%r14, 0(%r13)
	SW	%r24, 4(%r13)
	SW	%r19, 3(%r13)
	SW	%r12, 2(%r13)
	SW	%r7, 1(%r13)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r12, judge_intersection_fast.2985
	SW	%r12, 0(%r7)
	SW	%r13, 3(%r7)
	SW	%r24, 2(%r7)
	SW	%r2, 1(%r7)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r13, get_nvector_rect.2987
	SW	%r13, 0(%r12)
	LW	%r13, 17(%r30)
	SW	%r13, 2(%r12)
	SW	%r26, 1(%r12)
	ADDI	%r14, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, get_nvector_plane.2989
	SW	%r17, 0(%r14)
	SW	%r13, 1(%r14)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r18, get_nvector_second.2991
	SW	%r18, 0(%r17)
	SW	%r13, 2(%r17)
	SW	%r23, 1(%r17)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r19, get_nvector.2993
	SW	%r19, 0(%r18)
	SW	%r17, 3(%r18)
	SW	%r12, 2(%r18)
	SW	%r14, 1(%r18)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r14, utexture.2996
	SW	%r14, 0(%r12)
	LW	%r14, 18(%r30)
	SW	%r14, 1(%r12)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r19, add_light.2999
	SW	%r19, 0(%r17)
	SW	%r14, 2(%r17)
	LW	%r19, 20(%r30)
	SW	%r19, 1(%r17)
	ADDI	%r20, %r28, 0
	ADDI	%r28, %r28, 9
	LA	%r10, trace_reflections.3003
	SW	%r10, 0(%r20)
	SW	%r21, 8(%r20)
	LW	%r10, 36(%r30)
	SW	%r10, 7(%r20)
	SW	%r2, 6(%r20)
	SW	%r13, 5(%r20)
	SW	%r7, 4(%r20)
	SW	%r26, 3(%r20)
	SW	%r22, 2(%r20)
	SW	%r17, 1(%r20)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 21
	LA	%r5, trace_ray.3008
	SW	%r5, 0(%r10)
	SW	%r12, 20(%r10)
	SW	%r20, 19(%r10)
	SW	%r24, 18(%r10)
	SW	%r14, 17(%r10)
	SW	%r25, 16(%r10)
	SW	%r21, 15(%r10)
	SW	%r16, 14(%r10)
	SW	%r19, 13(%r10)
	SW	%r2, 12(%r10)
	SW	%r11, 11(%r10)
	SW	%r13, 10(%r10)
	SW	%r1, 9(%r10)
	SW	%r8, 8(%r10)
	SW	%r15, 7(%r10)
	SW	%r26, 6(%r10)
	SW	%r23, 5(%r10)
	SW	%r22, 4(%r10)
	SW	%r18, 3(%r10)
	SW	%r9, 2(%r10)
	SW	%r17, 1(%r10)
	ADDI	%r5, %r28, 0
	ADDI	%r28, %r28, 13
	LA	%r9, trace_diffuse_ray.3014
	SW	%r9, 0(%r5)
	SW	%r12, 12(%r5)
	SW	%r14, 11(%r5)
	SW	%r21, 10(%r5)
	SW	%r2, 9(%r5)
	SW	%r11, 8(%r5)
	SW	%r13, 7(%r5)
	SW	%r8, 6(%r5)
	SW	%r7, 5(%r5)
	SW	%r23, 4(%r5)
	SW	%r22, 3(%r5)
	SW	%r18, 2(%r5)
	LW	%r2, 19(%r30)
	SW	%r2, 1(%r5)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r9, iter_trace_diffuse_rays.3017
	SW	%r9, 0(%r7)
	SW	%r5, 1(%r7)
	ADDI	%r5, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r9, trace_diffuse_rays.3022
	SW	%r9, 0(%r5)
	SW	%r16, 2(%r5)
	SW	%r7, 1(%r5)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r9, trace_diffuse_ray_80percent.3026
	SW	%r9, 0(%r7)
	SW	%r5, 2(%r7)
	LW	%r9, 31(%r30)
	SW	%r9, 1(%r7)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r13, calc_diffuse_using_1point.3030
	SW	%r13, 0(%r12)
	SW	%r7, 3(%r12)
	SW	%r19, 2(%r12)
	SW	%r2, 1(%r12)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r13, calc_diffuse_using_5points.3033
	SW	%r13, 0(%r7)
	SW	%r19, 2(%r7)
	SW	%r2, 1(%r7)
	ADDI	%r13, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r14, do_without_neighbors.3039
	SW	%r14, 0(%r13)
	SW	%r12, 1(%r13)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r14, neighbors_exist.3042
	SW	%r14, 0(%r12)
	LW	%r14, 21(%r30)
	SW	%r14, 1(%r12)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r16, try_exploit_neighbors.3055
	SW	%r16, 0(%r15)
	SW	%r13, 2(%r15)
	SW	%r7, 1(%r15)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, write_ppm_header.3062
	SW	%r16, 0(%r7)
	SW	%r14, 1(%r7)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, write_rgb_element.3064
	SW	%r17, 0(%r16)
	LW	%r17, 1(%r30)
	SW	%r17, 1(%r16)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r18, write_rgb.3066
	SW	%r18, 0(%r17)
	SW	%r16, 2(%r17)
	SW	%r19, 1(%r17)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r18, pretrace_diffuse_rays.3068
	SW	%r18, 0(%r16)
	SW	%r5, 3(%r16)
	SW	%r9, 2(%r16)
	SW	%r2, 1(%r16)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r5, pretrace_pixels.3071
	SW	%r5, 0(%r2)
	SW	%r3, 9(%r2)
	SW	%r10, 8(%r2)
	SW	%r25, 7(%r2)
	SW	%r6, 6(%r2)
	LW	%r3, 23(%r30)
	SW	%r3, 5(%r2)
	SW	%r19, 4(%r2)
	LW	%r5, 29(%r30)
	SW	%r5, 3(%r2)
	SW	%r16, 2(%r2)
	LW	%r5, 22(%r30)
	SW	%r5, 1(%r2)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r10, pretrace_line.3078
	SW	%r10, 0(%r6)
	SW	%r4, 6(%r6)
	LW	%r4, 27(%r30)
	SW	%r4, 5(%r6)
	SW	%r3, 4(%r6)
	SW	%r2, 3(%r6)
	SW	%r14, 2(%r6)
	SW	%r5, 1(%r6)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r4, scan_pixel.3082
	SW	%r4, 0(%r2)
	SW	%r17, 6(%r2)
	SW	%r15, 5(%r2)
	SW	%r19, 4(%r2)
	SW	%r12, 3(%r2)
	SW	%r14, 2(%r2)
	SW	%r13, 1(%r2)
	ADDI	%r4, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r10, scan_line.3088
	SW	%r10, 0(%r4)
	SW	%r2, 3(%r4)
	SW	%r6, 2(%r4)
	SW	%r14, 1(%r4)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r10, create_pixelline.3101
	SW	%r10, 0(%r2)
	SW	%r14, 1(%r2)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r12, calc_dirvec.3108
	SW	%r12, 0(%r10)
	SW	%r9, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r13, calc_dirvecs.3116
	SW	%r13, 0(%r12)
	SW	%r10, 1(%r12)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r13, calc_dirvec_rows.3121
	SW	%r13, 0(%r10)
	SW	%r12, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r13, create_dirvec.3125
	SW	%r13, 0(%r12)
	LW	%r13, 2(%r30)
	SW	%r13, 1(%r12)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r16, create_dirvec_elements.3127
	SW	%r16, 0(%r15)
	SW	%r12, 1(%r15)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r17, create_dirvecs.3130
	SW	%r17, 0(%r16)
	SW	%r9, 3(%r16)
	SW	%r15, 2(%r16)
	SW	%r12, 1(%r16)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, init_dirvec_constants.3132
	SW	%r17, 0(%r15)
	LW	%r17, 38(%r30)
	SW	%r17, 1(%r15)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r19, init_vecset_constants.3135
	SW	%r19, 0(%r18)
	SW	%r15, 2(%r18)
	SW	%r9, 1(%r18)
	ADDI	%r9, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r15, init_dirvecs.3137
	SW	%r15, 0(%r9)
	SW	%r18, 3(%r9)
	SW	%r16, 2(%r9)
	SW	%r10, 1(%r9)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r15, add_reflection.3139
	SW	%r15, 0(%r10)
	SW	%r17, 3(%r10)
	LW	%r15, 36(%r30)
	SW	%r15, 2(%r10)
	SW	%r12, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r15, setup_rect_reflection.3146
	SW	%r15, 0(%r12)
	SW	%r1, 3(%r12)
	SW	%r8, 2(%r12)
	SW	%r10, 1(%r12)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r16, setup_surface_reflection.3149
	SW	%r16, 0(%r15)
	SW	%r1, 3(%r15)
	SW	%r8, 2(%r15)
	SW	%r10, 1(%r15)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r10, setup_reflections.3152
	SW	%r10, 0(%r1)
	SW	%r15, 3(%r1)
	SW	%r12, 2(%r1)
	SW	%r11, 1(%r1)
	ADDI	%r26, %r28, 0
	ADDI	%r28, %r28, 15
	LA	%r10, rt.3154
	SW	%r10, 0(%r26)
	SW	%r7, 14(%r26)
	SW	%r1, 13(%r26)
	SW	%r17, 12(%r26)
	SW	%r3, 11(%r26)
	SW	%r4, 10(%r26)
	LW	%r1, 37(%r30)
	SW	%r1, 9(%r26)
	SW	%r6, 8(%r26)
	SW	%r13, 7(%r26)
	LW	%r1, 34(%r30)
	SW	%r1, 6(%r26)
	SW	%r8, 5(%r26)
	SW	%r9, 4(%r26)
	SW	%r14, 3(%r26)
	SW	%r5, 2(%r26)
	SW	%r2, 1(%r26)
	ADDI	%r1, %r0, 128
	ADDI	%r2, %r0, 128
	ADDI	%r29, %r31, 0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
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
