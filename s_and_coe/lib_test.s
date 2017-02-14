calc_cos.6332:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13595
	ADD.s	%f1, %f2, %f0
	JR	%r31

mycos_step1.2626:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13599
	ADDI	%r1, %r0, 16
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10568
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 0(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	ADDI	%r1, %r0, 14
	ADD.s	%f31, %f2, %f0 # args
	ADD.s	%f2, %f1, %f0 # args
	ADD.s	%f1, %f31, %f0 # args
	J	calc_cos.6332

calc_sin.6307:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.13600
	ADD.s	%f1, %f2, %f0
	JR	%r31

mysin_step1.2628:
	LA	%r29, l.10569
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13604
	ADDI	%r1, %r0, 17
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 0(%r30) # restore2
	DIV.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	ADDI	%r1, %r0, 15
	ADD.s	%f1, %f3, %f0 # args
	J	calc_sin.6307

