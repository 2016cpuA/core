	.data
l.552:	 # 0.000000
	.word	0
l.551:	 # 1.000000
	.word	1065353216
l.550:	 # 1.500000
	.word	1069547520
l.549:	 # 400.000000
	.word	1137180672
l.548:	 # 4.000000
	.word	1082130432
	.text
	.globl  _min_caml_start
dbl.247:
	ADD.s	%f1, %f1, %f1
	JR	%r31
iloop.263:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.567
	ADDI	%r1, %r0, 1
	J	min_caml_print_int
BEQ_else.567:
	SUB.s	%f3, %f3, %f4
	ADD.s	%f3, %f3, %f5
	SWC1	%f5, 0(%r30)
	SW	%r1, 2(%r30)
	SWC1	%f3, 4(%r30)
	SWC1	%f6, 6(%r30)
	SWC1	%f2, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	JAL	dbl.247
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30)
	MUL.s	%f1, %f1, %f2
	LWC1	%f6, 6(%r30)
	ADD.s	%f2, %f1, %f6
	LWC1	%f1, 4(%r30)
	MUL.s	%f3, %f1, %f1
	MUL.s	%f4, %f2, %f2
	ADD.s	%f5, %f3, %f4
	LA	%r29, l.548
	LWC1	%f7, 0(%r29)
	C.lt.s	%r27, %f7, %f5
	BNE	%r27, %r0, BEQ_else.569
	LW	%r1, 2(%r30)
	ADDI	%r1, %r1, -1
	LWC1	%f5, 0(%r30)
	J	iloop.263
BEQ_else.569:
	ADDI	%r1, %r0, 0
	J	min_caml_print_int
xloop.253:
	ADDI	%r27, %r0, 400
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.570
	JR	%r31
BEQ_else.570:
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30)
	ADDI	%r30, %r30, 3
	JAL	dbl.247
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.549
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.550
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	LW	%r1, 1(%r30)
	SWC1	%f1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	dbl.247
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.549
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.551
	LWC1	%f2, 0(%r29)
	SUB.s	%f6, %f1, %f2
	ADDI	%r1, %r0, 1000
	LA	%r29, l.552
	LWC1	%f1, 0(%r29)
	LA	%r29, l.552
	LWC1	%f2, 0(%r29)
	LA	%r29, l.552
	LWC1	%f3, 0(%r29)
	LA	%r29, l.552
	LWC1	%f4, 0(%r29)
	LWC1	%f5, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	JAL	iloop.263
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30)
	J	xloop.253
yloop.249:
	ADDI	%r27, %r0, 400
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.572
	JR	%r31
BEQ_else.572:
	ADDI	%r2, %r0, 0
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0
	ADDI	%r2, %r1, 0
	ADDI	%r1, %r25, 0
	SW	%r29, 1(%r30)
	ADDI	%r30, %r30, 2
	JAL	xloop.253
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30)
	ADDI	%r1, %r1, 1
	J	yloop.249
_min_caml_start: # main entry point
	SUB	%r0, %r0, %r0
	ADDI	%r28, %r0, 8192
   # main program start
	ADDI	%r1, %r0, 32
	LA	%r29, l.552
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	LA	%r29, l.552
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30)
	ADDI	%r30, %r30, 1
	JAL	yloop.249
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
halt   # main program end
