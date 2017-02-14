	.data
l.11507:	 # 128.000000
	.word	1124073472
l.11367:	 # 0.900000
	.word	1063675494
l.11366:	 # 0.200000
	.word	1045220557
l.11185:	 # 150.000000
	.word	1125515264
l.11183:	 # -150.000000
	.word	-1021968384
l.11162:	 # 0.100000
	.word	1036831949
l.11151:	 # -2.000000
	.word	-1073741824
l.11137:	 # 0.003906
	.word	998244352
l.11101:	 # 100000000.000000
	.word	1287568416
l.11097:	 # 1000000000.000000
	.word	1315859240
l.11086:	 # 20.000000
	.word	1101004800
l.11085:	 # 0.050000
	.word	1028443341
l.11080:	 # 0.250000
	.word	1048576000
l.11076:	 # 10.000000
	.word	1092616192
l.11070:	 # 0.300000
	.word	1050253722
l.11069:	 # 255.000000
	.word	1132396544
l.11068:	 # 0.150000
	.word	1041865114
l.11064:	 # 3.141593
	.word	1078530011
l.11063:	 # 30.000000
	.word	1106247680
l.11062:	 # 15.000000
	.word	1097859072
l.11061:	 # 0.000100
	.word	953267991
l.10951:	 # -0.100000
	.word	-1110651699
l.10934:	 # 0.010000
	.word	1008981770
l.10933:	 # -0.200000
	.word	-1102263091
l.10625:	 # -200.000000
	.word	-1018691584
l.10623:	 # 200.000000
	.word	1128792064
l.10622:	 # 0.017453
	.word	1016003125
l.10573:	 # 1.570796
	.word	1070141403
l.10572:	 # 0.000000
	.word	786163455
l.10571:	 # 4.000000
	.word	1082130432
l.10570:	 # 3.000000
	.word	1077936128
l.10569:	 # 0.500000
	.word	1056964608
l.10568:	 # -1.000000
	.word	-1082130432
l.10565:	 # 2147483648.000000
	.word	1325400064
l.10562:	 # -2147483648.000000
	.word	-822083584
l.10553:	 # 16777216.000000
	.word	1266679808
l.10552:	 # -16777216.000000
	.word	-880803840
l.10551:	 # 2.000000
	.word	1073741824
l.10550:	 # 0.000000
	.word	0
l.10549:	 # 1.000000
	.word	1065353216
	.text
	.globl  _min_caml_start
calc_floor.6420:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13549
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13550
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	SWC1	%f2, 2(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30) # restore2
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13552
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.13553
BEQ_else.13552:
	SUB.s	%f3, %f1, %f3
BEQ_cont.13553:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13554
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.13555
BEQ_else.13554:
BEQ_cont.13555:
	J	BEQ_cont.13551
BEQ_else.13550:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13551:
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30) # restore2
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13556
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.13557
BEQ_else.13556:
	SUB.s	%f3, %f1, %f3
BEQ_cont.13557:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13558
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.13558:
	JR	%r31
BEQ_else.13549:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	JR	%r31
floor.2618:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13559
	LA	%r29, l.10553
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13560
	JR	%r31
BEQ_else.13560:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13561
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	SWC1	%f1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	calc_floor.6420
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 0(%r30) # restore2
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13562
	SUB.s	%f3, %f3, %f1
	J	BEQ_cont.13563
BEQ_else.13562:
	SUB.s	%f3, %f1, %f3
BEQ_cont.13563:
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13564
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	JR	%r31
BEQ_else.13564:
	JR	%r31
BEQ_else.13561:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.13559:
	LA	%r29, l.10552
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13565
	JR	%r31
BEQ_else.13565:
	SUB.s	%f2, %f0, %f1
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 0(%r30)
	SWC1	%f2, 2(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13566
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	calc_floor.6420
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADD.s	%f1, %f1, %f1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30) # restore2
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13568
	SUB.s	%f4, %f3, %f1
	J	BEQ_cont.13569
BEQ_else.13568:
	SUB.s	%f4, %f1, %f3
BEQ_cont.13569:
	C.lt.s	%r27, %f4, %f2
	BNE	%r27, %r0, BEQ_else.13570
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	J	BEQ_cont.13571
BEQ_else.13570:
BEQ_cont.13571:
	J	BEQ_cont.13567
BEQ_else.13566:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13567:
	LWC1	%f2, 2(%r30) # restore2
	C.eq.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13572
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SUB.s	%f1, %f0, %f1
	JR	%r31
BEQ_else.13572:
	LWC1	%f1, 0(%r30) # restore2
	JR	%r31
set_arr_x.6362:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13573
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13574
	ADD	%r29, %r2, %r1
	SWC1	%f1, 0(%r29)
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r1, 1
	J	set_arr_x.6362
BEQ_else.13574:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
BEQ_else.13573:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADD	%r29, %r3, %r1
	SWC1	%f1, 0(%r29)
	JR	%r31
calc_floor.6367:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.13575
	ADDI	%r5, %r2, 1
	ADD	%r29, %r4, %r5
	LWC1	%f1, 0(%r29)
	ADD.s	%f1, %f1, %f1
	ADD	%r29, %r3, %r2
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13576
	SUB.s	%f2, %f2, %f1
	J	BEQ_cont.13577
BEQ_else.13576:
	SUB.s	%f2, %f1, %f2
BEQ_cont.13577:
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13578
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.13578:
	ADD	%r29, %r4, %r2
	SWC1	%f1, 0(%r29)
	ADD	%r1, %r1, %r1
	ADDI	%r2, %r2, -1
	J	calc_floor.6367
BEQ_else.13575:
	JR	%r31
int_of_float.2622:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13579
	LA	%r29, l.10565
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13580
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13580:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13581
	SWC1	%f1, 0(%r2)
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13582
BEQ_else.13581:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r1, %r0, 0
BEQ_cont.13582:
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	LW	%r3, 1(%r30) # restore1
	LW	%r4, 0(%r30) # restore1
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	J	calc_floor.6367
BEQ_else.13579:
	LA	%r29, l.10562
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13583
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13583:
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13584
	SWC1	%f1, 0(%r2)
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	set_arr_x.6362
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13585
BEQ_else.13584:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r3)
	ADDI	%r1, %r0, 0
BEQ_cont.13585:
	ADDI	%r2, %r0, 0
	ADDI	%r1, %r1, -1
	LW	%r3, 1(%r30) # restore1
	LW	%r4, 0(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 2(%r30) # save link register
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
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13586
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13587
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13588
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13589
	J	calc_sqrt.6353
BEQ_else.13589:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13588:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13587:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13586:
	ADD.s	%f1, %f2, %f0
	JR	%r31
sqrt.2624:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13590
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13591
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13592
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13593
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13594
	ADD.s	%f2, %f3, %f0 # args
	J	calc_sqrt.6353
BEQ_else.13594:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13593:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13592:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13591:
	JR	%r31
BEQ_else.13590:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	JR	%r31
calc_cos.6332:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13595
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13595:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30) # restore2
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30) # restore1
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13597
	JR	%r31
BEQ_else.13597:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 8(%r30) # restore2
	SUB.s	%f2, %f0, %f2
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, -2
	ADD.s	%f31, %f2, %f0 # args
	ADD.s	%f2, %f1, %f0 # args
	ADD.s	%f1, %f31, %f0 # args
	J	calc_cos.6332
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
BEQ_else.13599:
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	JR	%r31
calc_sin.6307:
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.13600
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13600:
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 4(%r30) # restore2
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f1, %f1, %f3
	LW	%r1, 0(%r30) # restore1
	ADDI	%r1, %r1, -2
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.13602
	JR	%r31
BEQ_else.13602:
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f3, %f1, %f3
	MUL.s	%f1, %f1, %f3
	LWC1	%f3, 8(%r30) # restore2
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	SUB.s	%f1, %f2, %f1
	MUL.s	%f2, %f1, %f3
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, -2
	ADD.s	%f1, %f3, %f0 # args
	J	calc_sin.6307
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
BEQ_else.13604:
	LA	%r29, l.10570
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10570
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10571
	LWC1	%f3, 0(%r29)
	MUL.s	%f3, %f3, %f1
	MUL.s	%f3, %f3, %f1
	SUB.s	%f2, %f2, %f3
	MUL.s	%f1, %f1, %f2
	JR	%r31
ev_error.6243:
	LA	%r29, l.10572
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.13605
	ADDI	%r2, %r1, 1
	ADD	%r1, %r1, %r1
	SW	%r2, 0(%r30)
	SWC1	%f2, 2(%r30)
	SWC1	%f3, 4(%r30)
	SWC1	%f1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30) # restore2
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 2(%r30) # restore2
	ADD.s	%f2, %f4, %f2
	LA	%r29, l.10572
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f4, %f2
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.13607
	LW	%r1, 0(%r30) # restore1
	ADDI	%r2, %r1, 1
	ADD	%r1, %r1, %r1
	SW	%r2, 8(%r30)
	SWC1	%f2, 10(%r30)
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 12(%r30) # restore2
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 4(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 10(%r30) # restore2
	ADD.s	%f2, %f4, %f2
	LW	%r1, 8(%r30) # restore1
	J	ev_error.6243
BEQ_else.13607:
	LW	%r1, 0(%r30) # restore1
	JR	%r31
BEQ_else.13605:
	JR	%r31
calc_atan.6249:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13609
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13609:
	ADD	%r2, %r1, %r1
	SW	%r1, 0(%r30)
	SWC1	%f1, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f3, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30) # restore2
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30) # restore2
	ADD.s	%f1, %f1, %f3
	LW	%r1, 0(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13611
	JR	%r31
BEQ_else.13611:
	ADD	%r2, %r1, %r1
	SW	%r1, 8(%r30)
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30) # restore2
	MUL.s	%f2, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	ADD.s	%f1, %f1, %f3
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 4(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 2(%r30) # restore2
	ADD.s	%f1, %f1, %f3
	LW	%r1, 8(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADD.s	%f31, %f3, %f0 # args
	ADD.s	%f3, %f1, %f0 # args
	ADD.s	%f1, %f31, %f0 # args
	J	calc_atan.6249
atan.2634:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13613
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13614
BEQ_else.13613:
	ADDI	%r1, %r0, 1
BEQ_cont.13614:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13615
	J	BEQ_cont.13616
BEQ_else.13615:
	SUB.s	%f1, %f0, %f1
BEQ_cont.13616:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13617
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13618
BEQ_else.13617:
	ADDI	%r2, %r0, 1
BEQ_cont.13618:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13619
	J	BEQ_cont.13620
BEQ_else.13619:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
BEQ_cont.13620:
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	ADD.s	%f3, %f3, %f2
	DIV.s	%f3, %f2, %f3
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f2, %f4, %f2
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	SW	%r1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r2, 6(%r30)
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.13622
	ADDI	%r3, %r0, 2
	ADDI	%r4, %r0, 2
	SW	%r3, 7(%r30)
	SWC1	%f2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30) # restore2
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	LWC1	%f4, 8(%r30) # restore2
	ADD.s	%f4, %f4, %f2
	LW	%r1, 7(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f4, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	ev_error.6243
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13623
BEQ_else.13622:
	ADDI	%r1, %r0, 1
BEQ_cont.13623:
	LW	%r2, 6(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13624
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13626
	LWC1	%f1, 4(%r30) # restore2
	J	BEQ_cont.13627
BEQ_else.13626:
	ADD	%r2, %r1, %r1
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30) # restore2
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 10(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f3, %f0 # args
	ADD.s	%f3, %f1, %f0 # args
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f31, %f0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	calc_atan.6249
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13627:
	J	BEQ_cont.13625
BEQ_else.13624:
	LA	%r29, l.10573
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 12(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13629
	LWC1	%f2, 4(%r30) # restore2
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.13630
BEQ_else.13629:
	ADD	%r2, %r1, %r1
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 4(%r30) # restore2
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f1, %f1, %f4
	DIV.s	%f1, %f3, %f1
	LWC1	%f3, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f3
	ADD.s	%f1, %f1, %f2
	LW	%r1, 10(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f3, %f0 # args
	ADD.s	%f3, %f1, %f0 # args
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f31, %f0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	calc_atan.6249
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13630:
	LWC1	%f2, 12(%r30) # restore2
	SUB.s	%f1, %f2, %f1
BEQ_cont.13625:
	LW	%r1, 0(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13631
	JR	%r31
BEQ_else.13631:
	SUB.s	%f1, %f0, %f1
	JR	%r31
calc_sqrt.6353.9323:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13632
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13633
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13634
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13635
	J	calc_sqrt.6353.9323
BEQ_else.13635:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13634:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13633:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13632:
	ADD.s	%f1, %f2, %f0
	JR	%r31
vecunit_sgn.2699:
	LWC1	%f1, 0(%r1)
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 2(%r1)
	MUL.s	%f2, %f2, %f2
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13636
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13638
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13640
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13642
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13644
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	calc_sqrt.6353.9323
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13645
BEQ_else.13644:
	ADD.s	%f1, %f2, %f0
BEQ_cont.13645:
	J	BEQ_cont.13643
BEQ_else.13642:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13643:
	J	BEQ_cont.13641
BEQ_else.13640:
	ADD.s	%f1, %f2, %f0
BEQ_cont.13641:
	J	BEQ_cont.13639
BEQ_else.13638:
BEQ_cont.13639:
	J	BEQ_cont.13637
BEQ_else.13636:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13637:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13646
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13647
BEQ_else.13646:
	ADDI	%r1, %r0, 1
BEQ_cont.13647:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13648
	LW	%r1, 1(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13650
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.13651
BEQ_else.13650:
	LA	%r29, l.10568
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
BEQ_cont.13651:
	J	BEQ_cont.13649
BEQ_else.13648:
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
BEQ_cont.13649:
	LW	%r1, 0(%r30) # restore1
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
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30) # restore1
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 6(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13657
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13658
BEQ_else.13657:
	SUB.s	%f2, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13658:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 6(%r30) # restore2
	SWC1	%f1, 8(%r30)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13659
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13660
BEQ_else.13659:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13660:
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 12(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13661
	ADDI	%r29, %r31, 0
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13662
BEQ_else.13661:
	SUB.s	%f2, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13662:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 12(%r30) # restore2
	SWC1	%f1, 14(%r30)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13663
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 16(%r30) # save link register
	ADDI	%r30, %r30, 17
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13664
BEQ_else.13663:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 16(%r30) # save link register
	ADDI	%r30, %r30, 17
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13664:
	LWC1	%f2, 8(%r30) # restore2
	MUL.s	%f3, %f2, %f1
	LA	%r29, l.10623
	LWC1	%f4, 0(%r29)
	MUL.s	%f3, %f3, %f4
	LW	%r1, 3(%r30) # restore1
	SWC1	%f3, 0(%r1)
	LA	%r29, l.10625
	LWC1	%f3, 0(%r29)
	LWC1	%f4, 10(%r30) # restore2
	MUL.s	%f3, %f4, %f3
	SWC1	%f3, 1(%r1)
	LWC1	%f3, 14(%r30) # restore2
	MUL.s	%f5, %f2, %f3
	LA	%r29, l.10623
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	SWC1	%f5, 2(%r1)
	LW	%r2, 2(%r30) # restore1
	SWC1	%f3, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f5, 0(%r29)
	SWC1	%f5, 1(%r2)
	SUB.s	%f5, %f0, %f1
	SWC1	%f5, 2(%r2)
	SUB.s	%f5, %f0, %f4
	MUL.s	%f1, %f5, %f1
	LW	%r2, 1(%r30) # restore1
	SWC1	%f1, 0(%r2)
	SUB.s	%f1, %f0, %f2
	SWC1	%f1, 1(%r2)
	SUB.s	%f1, %f0, %f4
	MUL.s	%f1, %f1, %f3
	SWC1	%f1, 2(%r2)
	LW	%r2, 4(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 0(%r1)
	SUB.s	%f1, %f1, %f2
	LW	%r3, 0(%r30) # restore1
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
read_light.2802:
	LW	%r1, 2(%r26)
	LW	%r2, 1(%r26)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SWC1	%f1, 2(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13666
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13667
BEQ_else.13666:
	SUB.s	%f2, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13667:
	SUB.s	%f1, %f0, %f1
	LW	%r1, 1(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 2(%r30) # restore2
	SWC1	%f1, 4(%r30)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13668
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13669
BEQ_else.13668:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13669:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 4(%r30) # restore2
	SWC1	%f1, 6(%r30)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13670
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13671
BEQ_else.13670:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13671:
	LWC1	%f2, 6(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30) # restore1
	SWC1	%f1, 0(%r1)
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	LWC1	%f3, 4(%r30) # restore2
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13672
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13673
BEQ_else.13672:
	SUB.s	%f1, %f0, %f3
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13673:
	LWC1	%f2, 6(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 1(%r30) # restore1
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
	JR	%r31
rotate_quadratic_matrix.2804:
	LWC1	%f1, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13675
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13676
BEQ_else.13675:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13676:
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 0(%r1)
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 2(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13677
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13678
BEQ_else.13677:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13678:
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 1(%r1)
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 4(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13679
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13680
BEQ_else.13679:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13680:
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 1(%r1)
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 6(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13681
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13682
BEQ_else.13681:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13682:
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 2(%r1)
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 8(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13683
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13684
BEQ_else.13683:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13684:
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 2(%r1)
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 10(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13685
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13686
BEQ_else.13685:
	SUB.s	%f2, %f0, %f2
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.13686:
	LWC1	%f2, 10(%r30) # restore2
	LWC1	%f3, 6(%r30) # restore2
	MUL.s	%f4, %f3, %f2
	LWC1	%f5, 8(%r30) # restore2
	LWC1	%f6, 4(%r30) # restore2
	MUL.s	%f7, %f6, %f5
	MUL.s	%f7, %f7, %f2
	LWC1	%f8, 2(%r30) # restore2
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
	LW	%r1, 0(%r30) # restore1
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
	LA	%r29, l.10551
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
	LW	%r1, 1(%r30) # restore1
	SWC1	%f13, 0(%r1)
	LA	%r29, l.10551
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
	LA	%r29, l.10551
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
read_nth_object.2807:
	LW	%r2, 1(%r26)
	SW	%r1, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13688
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13688:
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	SWC1	%f1, 2(%r1)
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30) # restore1
	SWC1	%f1, 2(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13689
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13690
BEQ_else.13689:
	ADDI	%r1, %r0, 1
BEQ_cont.13690:
	ADDI	%r2, %r0, 2
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30) # restore1
	SWC1	%f1, 2(%r1)
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13691
	J	BEQ_cont.13692
BEQ_else.13691:
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 11(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 11(%r30) # restore1
	SWC1	%f1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_read_float
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10622
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 11(%r30) # restore1
	SWC1	%f1, 2(%r1)
BEQ_cont.13692:
	LW	%r2, 3(%r30) # restore1
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.13693
	ADDI	%r3, %r0, 1
	J	BEQ_cont.13694
BEQ_else.13693:
	LW	%r3, 8(%r30) # restore1
BEQ_cont.13694:
	ADDI	%r4, %r0, 4
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r3, 12(%r30)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 11
	SW	%r1, 10(%r2)
	LW	%r1, 11(%r30) # restore1
	SW	%r1, 9(%r2)
	LW	%r3, 10(%r30) # restore1
	SW	%r3, 8(%r2)
	LW	%r3, 9(%r30) # restore1
	SW	%r3, 7(%r2)
	LW	%r3, 12(%r30) # restore1
	SW	%r3, 6(%r2)
	LW	%r3, 7(%r30) # restore1
	SW	%r3, 5(%r2)
	LW	%r3, 6(%r30) # restore1
	SW	%r3, 4(%r2)
	LW	%r4, 5(%r30) # restore1
	SW	%r4, 3(%r2)
	LW	%r5, 4(%r30) # restore1
	SW	%r5, 2(%r2)
	LW	%r5, 3(%r30) # restore1
	SW	%r5, 1(%r2)
	LW	%r6, 2(%r30) # restore1
	SW	%r6, 0(%r2)
	LW	%r6, 0(%r30) # restore1
	LW	%r7, 1(%r30) # restore1
	ADD	%r29, %r7, %r6
	SW	%r2, 0(%r29)
	ADDI	%r27, %r0, 3
	BNE	%r5, %r27, BEQ_else.13695
	LWC1	%f1, 0(%r3)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13697
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13698
BEQ_else.13697:
	ADDI	%r2, %r0, 1
BEQ_cont.13698:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13699
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13701
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13702
BEQ_else.13701:
	ADDI	%r2, %r0, 1
BEQ_cont.13702:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13703
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13705
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13706
BEQ_else.13705:
	ADDI	%r2, %r0, 1
BEQ_cont.13706:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13707
	LA	%r29, l.10568
	LWC1	%f2, 0(%r29)
	J	BEQ_cont.13708
BEQ_else.13707:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
BEQ_cont.13708:
	J	BEQ_cont.13704
BEQ_else.13703:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
BEQ_cont.13704:
	MUL.s	%f1, %f1, %f1
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.13700
BEQ_else.13699:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13700:
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r3)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13709
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13710
BEQ_else.13709:
	ADDI	%r2, %r0, 1
BEQ_cont.13710:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13711
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13713
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13714
BEQ_else.13713:
	ADDI	%r2, %r0, 1
BEQ_cont.13714:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13715
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13717
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13718
BEQ_else.13717:
	ADDI	%r2, %r0, 1
BEQ_cont.13718:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13719
	LA	%r29, l.10568
	LWC1	%f2, 0(%r29)
	J	BEQ_cont.13720
BEQ_else.13719:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
BEQ_cont.13720:
	J	BEQ_cont.13716
BEQ_else.13715:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
BEQ_cont.13716:
	MUL.s	%f1, %f1, %f1
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.13712
BEQ_else.13711:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13712:
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r3)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13721
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13722
BEQ_else.13721:
	ADDI	%r2, %r0, 1
BEQ_cont.13722:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13723
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13725
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13726
BEQ_else.13725:
	ADDI	%r2, %r0, 1
BEQ_cont.13726:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13727
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13729
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13730
BEQ_else.13729:
	ADDI	%r2, %r0, 1
BEQ_cont.13730:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13731
	LA	%r29, l.10568
	LWC1	%f2, 0(%r29)
	J	BEQ_cont.13732
BEQ_else.13731:
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
BEQ_cont.13732:
	J	BEQ_cont.13728
BEQ_else.13727:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
BEQ_cont.13728:
	MUL.s	%f1, %f1, %f1
	DIV.s	%f1, %f2, %f1
	J	BEQ_cont.13724
BEQ_else.13723:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13724:
	SWC1	%f1, 2(%r3)
	J	BEQ_cont.13696
BEQ_else.13695:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.13733
	LW	%r2, 8(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13735
	ADDI	%r2, %r0, 1
	J	BEQ_cont.13736
BEQ_else.13735:
	ADDI	%r2, %r0, 0
BEQ_cont.13736:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	vecunit_sgn.2699
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13734
BEQ_else.13733:
BEQ_cont.13734:
BEQ_cont.13696:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13737
	J	BEQ_cont.13738
BEQ_else.13737:
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 11(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	rotate_quadratic_matrix.2804
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.13738:
	ADDI	%r1, %r0, 1
	JR	%r31
read_object.2809:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.13739
	JR	%r31
BEQ_else.13739:
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r2, 0 # args
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13741
	LW	%r1, 2(%r30) # restore1
	LW	%r2, 3(%r30) # restore1
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.13741:
	LW	%r1, 3(%r30) # restore1
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 60
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.13743
	JR	%r31
BEQ_else.13743:
	LW	%r26, 1(%r30) # restore1
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
	BNE	%r1, %r27, BEQ_else.13745
	LW	%r1, 2(%r30) # restore1
	LW	%r2, 4(%r30) # restore1
	SW	%r2, 0(%r1)
	JR	%r31
BEQ_else.13745:
	LW	%r1, 4(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
read_net_item.2813:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13747
	LW	%r1, 0(%r30) # restore1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	J	min_caml_create_array
BEQ_else.13747:
	LW	%r2, 0(%r30) # restore1
	ADDI	%r3, %r2, 1
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13748
	LW	%r1, 2(%r30) # restore1
	ADDI	%r1, %r1, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13749
BEQ_else.13748:
	LW	%r2, 2(%r30) # restore1
	ADDI	%r3, %r2, 1
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30) # restore1
	LW	%r3, 3(%r30) # restore1
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.13749:
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
	JR	%r31
read_or_network.2815:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13750
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13751
BEQ_else.13750:
	ADDI	%r2, %r0, 1
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30) # restore1
	SW	%r2, 0(%r1)
	ADDI	%r2, %r1, 0
BEQ_cont.13751:
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13752
	LW	%r1, 0(%r30) # restore1
	ADDI	%r1, %r1, 1
	J	min_caml_create_array
BEQ_else.13752:
	LW	%r1, 0(%r30) # restore1
	ADDI	%r3, %r1, 1
	ADDI	%r4, %r0, 0
	SW	%r2, 2(%r30)
	SW	%r3, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13753
	LW	%r1, 3(%r30) # restore1
	ADDI	%r1, %r1, 1
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13754
BEQ_else.13753:
	LW	%r1, 3(%r30) # restore1
	ADDI	%r3, %r1, 1
	SW	%r2, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	read_or_network.2815
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
BEQ_cont.13754:
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r1, %r2
	SW	%r3, 0(%r29)
	JR	%r31
read_and_network.2817:
	LW	%r2, 1(%r26)
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_read_int
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.13755
	ADDI	%r1, %r0, 1
	ADDI	%r2, %r0, -1
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13756
BEQ_else.13755:
	ADDI	%r2, %r0, 1
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30) # restore1
	SW	%r2, 0(%r1)
BEQ_cont.13756:
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.13757
	JR	%r31
BEQ_else.13757:
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	ADDI	%r2, %r0, 0
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	read_net_item.2813
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.13759
	JR	%r31
BEQ_else.13759:
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
solver_rect_surface.2821:
	LW	%r6, 1(%r26)
	ADD	%r29, %r2, %r3
	LWC1	%f4, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.13761
	ADDI	%r7, %r0, 0
	J	BEQ_cont.13762
BEQ_else.13761:
	ADDI	%r7, %r0, 1
BEQ_cont.13762:
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.13763
	LW	%r7, 4(%r1)
	LW	%r1, 6(%r1)
	ADD	%r29, %r2, %r3
	LWC1	%f4, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f5, 0(%r29)
	C.lt.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.13764
	ADDI	%r8, %r0, 0
	J	BEQ_cont.13765
BEQ_else.13764:
	ADDI	%r8, %r0, 1
BEQ_cont.13765:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13766
	ADDI	%r1, %r8, 0
	J	BEQ_cont.13767
BEQ_else.13766:
	ADDI	%r27, %r0, 0
	BNE	%r8, %r27, BEQ_else.13768
	ADDI	%r1, %r0, 1
	J	BEQ_cont.13769
BEQ_else.13768:
	ADDI	%r1, %r0, 0
BEQ_cont.13769:
BEQ_cont.13767:
	ADD	%r29, %r7, %r3
	LWC1	%f4, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13770
	SUB.s	%f4, %f0, %f4
	J	BEQ_cont.13771
BEQ_else.13770:
BEQ_cont.13771:
	SUB.s	%f1, %f4, %f1
	ADD	%r29, %r2, %r3
	LWC1	%f4, 0(%r29)
	DIV.s	%f1, %f1, %f4
	ADD	%r29, %r2, %r4
	LWC1	%f4, 0(%r29)
	MUL.s	%f4, %f1, %f4
	ADD.s	%f2, %f4, %f2
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f2, %f4
	BNE	%r27, %r0, BEQ_else.13772
	J	BEQ_cont.13773
BEQ_else.13772:
	SUB.s	%f2, %f0, %f2
BEQ_cont.13773:
	ADD	%r29, %r7, %r4
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f2, %f4
	BNE	%r27, %r0, BEQ_else.13774
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13775
BEQ_else.13774:
	ADDI	%r1, %r0, 1
BEQ_cont.13775:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13776
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13776:
	ADD	%r29, %r2, %r5
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13777
	J	BEQ_cont.13778
BEQ_else.13777:
	SUB.s	%f2, %f0, %f2
BEQ_cont.13778:
	ADD	%r29, %r7, %r5
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13779
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13780
BEQ_else.13779:
	ADDI	%r1, %r0, 1
BEQ_cont.13780:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13781
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13781:
	SWC1	%f1, 0(%r6)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.13763:
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
	BNE	%r1, %r27, BEQ_else.13782
	ADDI	%r3, %r0, 1
	ADDI	%r4, %r0, 2
	ADDI	%r5, %r0, 0
	LWC1	%f1, 4(%r30) # restore2
	LWC1	%f2, 2(%r30) # restore2
	LWC1	%f3, 0(%r30) # restore2
	LW	%r1, 7(%r30) # restore1
	LW	%r2, 6(%r30) # restore1
	LW	%r26, 8(%r30) # restore1
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
	BNE	%r1, %r27, BEQ_else.13783
	ADDI	%r3, %r0, 2
	ADDI	%r4, %r0, 0
	ADDI	%r5, %r0, 1
	LWC1	%f1, 2(%r30) # restore2
	LWC1	%f2, 0(%r30) # restore2
	LWC1	%f3, 4(%r30) # restore2
	LW	%r1, 7(%r30) # restore1
	LW	%r2, 6(%r30) # restore1
	LW	%r26, 8(%r30) # restore1
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
	BNE	%r1, %r27, BEQ_else.13784
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13784:
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.13783:
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.13782:
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
	BNE	%r2, %r27, BEQ_else.13785
	ADD.s	%f1, %f4, %f0
	JR	%r31
BEQ_else.13785:
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
bilinear.2847:
	MUL.s	%f7, %f1, %f4
	LW	%r2, 4(%r1)
	LWC1	%f8, 0(%r2)
	MUL.s	%f7, %f7, %f8
	MUL.s	%f8, %f2, %f5
	LW	%r2, 4(%r1)
	LWC1	%f9, 1(%r2)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	MUL.s	%f8, %f3, %f6
	LW	%r2, 4(%r1)
	LWC1	%f9, 2(%r2)
	MUL.s	%f8, %f8, %f9
	ADD.s	%f7, %f7, %f8
	LW	%r2, 3(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13786
	ADD.s	%f1, %f7, %f0
	JR	%r31
BEQ_else.13786:
	MUL.s	%f8, %f3, %f5
	MUL.s	%f9, %f2, %f6
	ADD.s	%f8, %f8, %f9
	LW	%r2, 9(%r1)
	LWC1	%f9, 0(%r2)
	MUL.s	%f8, %f8, %f9
	MUL.s	%f6, %f1, %f6
	MUL.s	%f3, %f3, %f4
	ADD.s	%f3, %f6, %f3
	LW	%r2, 9(%r1)
	LWC1	%f6, 1(%r2)
	MUL.s	%f3, %f3, %f6
	ADD.s	%f3, %f8, %f3
	MUL.s	%f1, %f1, %f5
	MUL.s	%f2, %f2, %f4
	ADD.s	%f1, %f1, %f2
	LW	%r1, 9(%r1)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f3, %f1
	LA	%r29, l.10569
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f7, %f1
	JR	%r31
calc_sqrt.6353.8933:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13787
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13788
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13789
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13790
	J	calc_sqrt.6353.8933
BEQ_else.13790:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13789:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13788:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13787:
	ADD.s	%f1, %f2, %f0
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
	ADD.s	%f3, %f6, %f0 # args
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f4, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	quadratic.2842
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13792
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13793
BEQ_else.13792:
	ADDI	%r1, %r0, 1
BEQ_cont.13793:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13794
	LW	%r1, 9(%r30) # restore1
	LWC1	%f2, 0(%r1)
	LWC1	%f3, 1(%r1)
	LWC1	%f4, 2(%r1)
	LWC1	%f5, 6(%r30) # restore2
	LWC1	%f6, 4(%r30) # restore2
	LWC1	%f7, 2(%r30) # restore2
	LW	%r1, 8(%r30) # restore1
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f3, %f0 # args
	ADD.s	%f3, %f4, %f0 # args
	ADD.s	%f4, %f5, %f0 # args
	ADD.s	%f5, %f6, %f0 # args
	ADD.s	%f6, %f7, %f0 # args
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	bilinear.2847
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30) # restore2
	LWC1	%f3, 4(%r30) # restore2
	LWC1	%f4, 2(%r30) # restore2
	LW	%r1, 8(%r30) # restore1
	SWC1	%f1, 12(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f3, %f0 # args
	ADD.s	%f3, %f4, %f0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	quadratic.2842
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.13795
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.13796
BEQ_else.13795:
BEQ_cont.13796:
	LWC1	%f2, 12(%r30) # restore2
	MUL.s	%f3, %f2, %f2
	LWC1	%f4, 10(%r30) # restore2
	MUL.s	%f1, %f4, %f1
	SUB.s	%f1, %f3, %f1
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13797
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13798
BEQ_else.13797:
	ADDI	%r2, %r0, 1
BEQ_cont.13798:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13799
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13799:
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.13800
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.13802
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f1, %f3
	DIV.s	%f5, %f1, %f3
	ADD.s	%f5, %f3, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f3
	BNE	%r27, %r0, BEQ_else.13804
	DIV.s	%f3, %f1, %f5
	ADD.s	%f3, %f5, %f3
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f3, %f3, %f6
	C.eq.s	%r27, %f3, %f5
	BNE	%r27, %r0, BEQ_else.13806
	DIV.s	%f5, %f1, %f3
	ADD.s	%f5, %f3, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f3
	BNE	%r27, %r0, BEQ_else.13808
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	calc_sqrt.6353.8933
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13809
BEQ_else.13808:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13809:
	J	BEQ_cont.13807
BEQ_else.13806:
	ADD.s	%f1, %f5, %f0
BEQ_cont.13807:
	J	BEQ_cont.13805
BEQ_else.13804:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13805:
	J	BEQ_cont.13803
BEQ_else.13802:
BEQ_cont.13803:
	J	BEQ_cont.13801
BEQ_else.13800:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13801:
	LW	%r1, 8(%r30) # restore1
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13810
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.13811
BEQ_else.13810:
BEQ_cont.13811:
	LWC1	%f2, 12(%r30) # restore2
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 10(%r30) # restore2
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.13794:
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
	LW	%r7, 5(%r1)
	LWC1	%f2, 0(%r7)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LW	%r7, 5(%r1)
	LWC1	%f3, 1(%r7)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r3)
	LW	%r3, 5(%r1)
	LWC1	%f4, 2(%r3)
	SUB.s	%f3, %f3, %f4
	LW	%r3, 1(%r1)
	ADDI	%r27, %r0, 1
	BNE	%r3, %r27, BEQ_else.13812
	ADDI	%r26, %r5, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.13812:
	ADDI	%r27, %r0, 2
	BNE	%r3, %r27, BEQ_else.13813
	LW	%r1, 4(%r1)
	SW	%r6, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	veciprod.2702
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13815
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13816
BEQ_else.13815:
	ADDI	%r1, %r0, 1
BEQ_cont.13816:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13817
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13817:
	LW	%r1, 8(%r30) # restore1
	LWC1	%f2, 0(%r1)
	LWC1	%f3, 6(%r30) # restore2
	MUL.s	%f2, %f2, %f3
	LWC1	%f3, 1(%r1)
	LWC1	%f4, 4(%r30) # restore2
	MUL.s	%f3, %f3, %f4
	ADD.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r1)
	LWC1	%f4, 2(%r30) # restore2
	MUL.s	%f3, %f3, %f4
	ADD.s	%f2, %f2, %f3
	SUB.s	%f2, %f0, %f2
	DIV.s	%f1, %f2, %f1
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.13813:
	ADDI	%r26, %r4, 0 # args
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
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13818
	J	BEQ_cont.13819
BEQ_else.13818:
	SUB.s	%f5, %f0, %f5
BEQ_cont.13819:
	LW	%r5, 4(%r1)
	LWC1	%f6, 1(%r5)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13820
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13821
BEQ_else.13820:
	ADDI	%r5, %r0, 1
BEQ_cont.13821:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13822
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13823
BEQ_else.13822:
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f3
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13824
	J	BEQ_cont.13825
BEQ_else.13824:
	SUB.s	%f5, %f0, %f5
BEQ_cont.13825:
	LW	%r5, 4(%r1)
	LWC1	%f6, 2(%r5)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13826
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13827
BEQ_else.13826:
	ADDI	%r5, %r0, 1
BEQ_cont.13827:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13828
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13829
BEQ_else.13828:
	LWC1	%f5, 1(%r3)
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	C.eq.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13830
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13831
BEQ_else.13830:
	ADDI	%r5, %r0, 1
BEQ_cont.13831:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13832
	ADDI	%r5, %r0, 1
	J	BEQ_cont.13833
BEQ_else.13832:
	ADDI	%r5, %r0, 0
BEQ_cont.13833:
BEQ_cont.13829:
BEQ_cont.13823:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13834
	LWC1	%f4, 2(%r3)
	SUB.s	%f4, %f4, %f2
	LWC1	%f5, 3(%r3)
	MUL.s	%f4, %f4, %f5
	LWC1	%f5, 0(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f1
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13835
	J	BEQ_cont.13836
BEQ_else.13835:
	SUB.s	%f5, %f0, %f5
BEQ_cont.13836:
	LW	%r5, 4(%r1)
	LWC1	%f6, 0(%r5)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13837
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13838
BEQ_else.13837:
	ADDI	%r5, %r0, 1
BEQ_cont.13838:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13839
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13840
BEQ_else.13839:
	LWC1	%f5, 2(%r2)
	MUL.s	%f5, %f4, %f5
	ADD.s	%f5, %f5, %f3
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13841
	J	BEQ_cont.13842
BEQ_else.13841:
	SUB.s	%f5, %f0, %f5
BEQ_cont.13842:
	LW	%r5, 4(%r1)
	LWC1	%f6, 2(%r5)
	C.lt.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13843
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13844
BEQ_else.13843:
	ADDI	%r5, %r0, 1
BEQ_cont.13844:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13845
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13846
BEQ_else.13845:
	LWC1	%f5, 3(%r3)
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	C.eq.s	%r27, %f5, %f6
	BNE	%r27, %r0, BEQ_else.13847
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13848
BEQ_else.13847:
	ADDI	%r5, %r0, 1
BEQ_cont.13848:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13849
	ADDI	%r5, %r0, 1
	J	BEQ_cont.13850
BEQ_else.13849:
	ADDI	%r5, %r0, 0
BEQ_cont.13850:
BEQ_cont.13846:
BEQ_cont.13840:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13851
	LWC1	%f4, 4(%r3)
	SUB.s	%f3, %f4, %f3
	LWC1	%f4, 5(%r3)
	MUL.s	%f3, %f3, %f4
	LWC1	%f4, 0(%r2)
	MUL.s	%f4, %f3, %f4
	ADD.s	%f1, %f4, %f1
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.13852
	J	BEQ_cont.13853
BEQ_else.13852:
	SUB.s	%f1, %f0, %f1
BEQ_cont.13853:
	LW	%r5, 4(%r1)
	LWC1	%f4, 0(%r5)
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.13854
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13855
BEQ_else.13854:
	ADDI	%r5, %r0, 1
BEQ_cont.13855:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13856
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13857
BEQ_else.13856:
	LWC1	%f1, 1(%r2)
	MUL.s	%f1, %f3, %f1
	ADD.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13858
	J	BEQ_cont.13859
BEQ_else.13858:
	SUB.s	%f1, %f0, %f1
BEQ_cont.13859:
	LW	%r1, 4(%r1)
	LWC1	%f2, 1(%r1)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13860
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13861
BEQ_else.13860:
	ADDI	%r1, %r0, 1
BEQ_cont.13861:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13862
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13863
BEQ_else.13862:
	LWC1	%f1, 5(%r3)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13864
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13865
BEQ_else.13864:
	ADDI	%r1, %r0, 1
BEQ_cont.13865:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13866
	ADDI	%r1, %r0, 1
	J	BEQ_cont.13867
BEQ_else.13866:
	ADDI	%r1, %r0, 0
BEQ_cont.13867:
BEQ_cont.13863:
BEQ_cont.13857:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13868
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13868:
	SWC1	%f3, 0(%r4)
	ADDI	%r1, %r0, 3
	JR	%r31
BEQ_else.13851:
	SWC1	%f4, 0(%r4)
	ADDI	%r1, %r0, 2
	JR	%r31
BEQ_else.13834:
	SWC1	%f4, 0(%r4)
	ADDI	%r1, %r0, 1
	JR	%r31
solver_surface_fast.2872:
	LW	%r1, 1(%r26)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f5, 0(%r29)
	C.lt.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.13869
	ADDI	%r3, %r0, 0
	J	BEQ_cont.13870
BEQ_else.13869:
	ADDI	%r3, %r0, 1
BEQ_cont.13870:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.13871
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13871:
	LWC1	%f4, 1(%r2)
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r2)
	MUL.s	%f2, %f4, %f2
	ADD.s	%f1, %f1, %f2
	LWC1	%f2, 3(%r2)
	MUL.s	%f2, %f2, %f3
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r1)
	ADDI	%r1, %r0, 1
	JR	%r31
calc_sqrt.6353.8744:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13872
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13873
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13874
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13875
	J	calc_sqrt.6353.8744
BEQ_else.13875:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13874:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13873:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13872:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.8755:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13876
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13877
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13878
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13879
	J	calc_sqrt.6353.8755
BEQ_else.13879:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13878:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13877:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13876:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_second_fast.2878:
	LW	%r3, 1(%r26)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.13880
	ADDI	%r4, %r0, 0
	J	BEQ_cont.13881
BEQ_else.13880:
	ADDI	%r4, %r0, 1
BEQ_cont.13881:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13882
	LWC1	%f5, 1(%r2)
	MUL.s	%f5, %f5, %f1
	LWC1	%f6, 2(%r2)
	MUL.s	%f6, %f6, %f2
	ADD.s	%f5, %f5, %f6
	LWC1	%f6, 3(%r2)
	MUL.s	%f6, %f6, %f3
	ADD.s	%f5, %f5, %f6
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f4, 2(%r30)
	SWC1	%f5, 4(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	quadratic.2842
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.13883
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.13884
BEQ_else.13883:
BEQ_cont.13884:
	LWC1	%f2, 4(%r30) # restore2
	MUL.s	%f3, %f2, %f2
	LWC1	%f4, 2(%r30) # restore2
	MUL.s	%f1, %f4, %f1
	SUB.s	%f1, %f3, %f1
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.13885
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13886
BEQ_else.13885:
	ADDI	%r2, %r0, 1
BEQ_cont.13886:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13887
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13887:
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13888
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.13890
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.13892
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f1, %f3
	DIV.s	%f4, %f1, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13894
	DIV.s	%f3, %f1, %f4
	ADD.s	%f3, %f4, %f3
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f3, %f3, %f5
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.13896
	DIV.s	%f4, %f1, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13898
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f4, %f0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	calc_sqrt.6353.8755
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13899
BEQ_else.13898:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13899:
	J	BEQ_cont.13897
BEQ_else.13896:
	ADD.s	%f1, %f4, %f0
BEQ_cont.13897:
	J	BEQ_cont.13895
BEQ_else.13894:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13895:
	J	BEQ_cont.13893
BEQ_else.13892:
BEQ_cont.13893:
	J	BEQ_cont.13891
BEQ_else.13890:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13891:
	LWC1	%f2, 4(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.13889
BEQ_else.13888:
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.13900
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.13902
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f1, %f3
	DIV.s	%f4, %f1, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13904
	DIV.s	%f3, %f1, %f4
	ADD.s	%f3, %f4, %f3
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f3, %f3, %f5
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.13906
	DIV.s	%f4, %f1, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13908
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f4, %f0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	calc_sqrt.6353.8744
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13909
BEQ_else.13908:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13909:
	J	BEQ_cont.13907
BEQ_else.13906:
	ADD.s	%f1, %f4, %f0
BEQ_cont.13907:
	J	BEQ_cont.13905
BEQ_else.13904:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13905:
	J	BEQ_cont.13903
BEQ_else.13902:
BEQ_cont.13903:
	J	BEQ_cont.13901
BEQ_else.13900:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13901:
	LWC1	%f2, 4(%r30) # restore2
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
BEQ_cont.13889:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.13882:
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
	LW	%r8, 5(%r7)
	LWC1	%f2, 0(%r8)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 1(%r3)
	LW	%r8, 5(%r7)
	LWC1	%f3, 1(%r8)
	SUB.s	%f2, %f2, %f3
	LWC1	%f3, 2(%r3)
	LW	%r3, 5(%r7)
	LWC1	%f4, 2(%r3)
	SUB.s	%f3, %f3, %f4
	LW	%r3, 1(%r2)
	ADD	%r29, %r3, %r1
	LW	%r3, 0(%r29)
	LW	%r1, 1(%r7)
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.13910
	LW	%r2, 0(%r2)
	ADDI	%r1, %r7, 0 # args
	ADDI	%r26, %r6, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.13910:
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.13911
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r7, 0 # args
	ADDI	%r26, %r4, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.13911:
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r7, 0 # args
	ADDI	%r26, %r5, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
calc_sqrt.6353.8657:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13912
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13913
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13914
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13915
	J	calc_sqrt.6353.8657
BEQ_else.13915:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13914:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13913:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13912:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.8668:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13916
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13917
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13918
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13919
	J	calc_sqrt.6353.8668
BEQ_else.13919:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13918:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.13917:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.13916:
	ADD.s	%f1, %f2, %f0
	JR	%r31
solver_second_fast2.2895:
	LW	%r4, 1(%r26)
	LWC1	%f4, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f5, 0(%r29)
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.13920
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13921
BEQ_else.13920:
	ADDI	%r5, %r0, 1
BEQ_cont.13921:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13922
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
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.13923
	ADDI	%r3, %r0, 0
	J	BEQ_cont.13924
BEQ_else.13923:
	ADDI	%r3, %r0, 1
BEQ_cont.13924:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.13925
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13925:
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13926
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f1, 2(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13928
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13930
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13932
	DIV.s	%f3, %f2, %f4
	ADD.s	%f3, %f4, %f3
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f3, %f3, %f5
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.13934
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13936
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f4, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.8668
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13937
BEQ_else.13936:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13937:
	J	BEQ_cont.13935
BEQ_else.13934:
	ADD.s	%f1, %f4, %f0
BEQ_cont.13935:
	J	BEQ_cont.13933
BEQ_else.13932:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13933:
	J	BEQ_cont.13931
BEQ_else.13930:
	ADD.s	%f1, %f2, %f0
BEQ_cont.13931:
	J	BEQ_cont.13929
BEQ_else.13928:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13929:
	LWC1	%f2, 2(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.13927
BEQ_else.13926:
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SW	%r4, 0(%r30)
	SW	%r2, 1(%r30)
	SWC1	%f1, 2(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13938
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.13940
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13942
	DIV.s	%f3, %f2, %f4
	ADD.s	%f3, %f4, %f3
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f3, %f3, %f5
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.13944
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.13946
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f4, %f0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	calc_sqrt.6353.8657
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.13947
BEQ_else.13946:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13947:
	J	BEQ_cont.13945
BEQ_else.13944:
	ADD.s	%f1, %f4, %f0
BEQ_cont.13945:
	J	BEQ_cont.13943
BEQ_else.13942:
	ADD.s	%f1, %f3, %f0
BEQ_cont.13943:
	J	BEQ_cont.13941
BEQ_else.13940:
	ADD.s	%f1, %f2, %f0
BEQ_cont.13941:
	J	BEQ_cont.13939
BEQ_else.13938:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.13939:
	LWC1	%f2, 2(%r30) # restore2
	ADD.s	%f1, %f2, %f1
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 4(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 0(%r1)
BEQ_cont.13927:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.13922:
	ADDI	%r1, %r0, 0
	JR	%r31
solver_fast2.2902:
	LW	%r3, 4(%r26)
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADD	%r29, %r6, %r1
	LW	%r6, 0(%r29)
	LW	%r7, 10(%r6)
	LWC1	%f1, 0(%r7)
	LWC1	%f2, 1(%r7)
	LWC1	%f3, 2(%r7)
	LW	%r8, 1(%r2)
	ADD	%r29, %r8, %r1
	LW	%r1, 0(%r29)
	LW	%r8, 1(%r6)
	ADDI	%r27, %r0, 1
	BNE	%r8, %r27, BEQ_else.13948
	LW	%r2, 0(%r2)
	ADDI	%r3, %r1, 0 # args
	ADDI	%r26, %r4, 0 # args
	ADDI	%r1, %r6, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.13948:
	ADDI	%r27, %r0, 2
	BNE	%r8, %r27, BEQ_else.13949
	LWC1	%f1, 0(%r1)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13950
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13951
BEQ_else.13950:
	ADDI	%r2, %r0, 1
BEQ_cont.13951:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13952
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.13952:
	LWC1	%f1, 0(%r1)
	LWC1	%f2, 3(%r7)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 0(%r5)
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.13949:
	ADDI	%r2, %r1, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r7, 0 # args
	ADDI	%r1, %r6, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
setup_rect_table.2905:
	ADDI	%r3, %r0, 6
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13953
	ADDI	%r3, %r0, 0
	J	BEQ_cont.13954
BEQ_else.13953:
	ADDI	%r3, %r0, 1
BEQ_cont.13954:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.13955
	LW	%r3, 0(%r30) # restore1
	LW	%r4, 6(%r3)
	LWC1	%f1, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13957
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13958
BEQ_else.13957:
	ADDI	%r5, %r0, 1
BEQ_cont.13958:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13959
	ADDI	%r4, %r5, 0
	J	BEQ_cont.13960
BEQ_else.13959:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13961
	ADDI	%r4, %r0, 1
	J	BEQ_cont.13962
BEQ_else.13961:
	ADDI	%r4, %r0, 0
BEQ_cont.13962:
BEQ_cont.13960:
	LW	%r5, 4(%r3)
	LWC1	%f1, 0(%r5)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13963
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.13964
BEQ_else.13963:
BEQ_cont.13964:
	SWC1	%f1, 0(%r1)
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 0(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 1(%r1)
	J	BEQ_cont.13956
BEQ_else.13955:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 1(%r1)
BEQ_cont.13956:
	LWC1	%f1, 1(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13965
	ADDI	%r3, %r0, 0
	J	BEQ_cont.13966
BEQ_else.13965:
	ADDI	%r3, %r0, 1
BEQ_cont.13966:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.13967
	LW	%r3, 0(%r30) # restore1
	LW	%r4, 6(%r3)
	LWC1	%f1, 1(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13969
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13970
BEQ_else.13969:
	ADDI	%r5, %r0, 1
BEQ_cont.13970:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13971
	ADDI	%r4, %r5, 0
	J	BEQ_cont.13972
BEQ_else.13971:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13973
	ADDI	%r4, %r0, 1
	J	BEQ_cont.13974
BEQ_else.13973:
	ADDI	%r4, %r0, 0
BEQ_cont.13974:
BEQ_cont.13972:
	LW	%r5, 4(%r3)
	LWC1	%f1, 1(%r5)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13975
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.13976
BEQ_else.13975:
BEQ_cont.13976:
	SWC1	%f1, 2(%r1)
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 1(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 3(%r1)
	J	BEQ_cont.13968
BEQ_else.13967:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 3(%r1)
BEQ_cont.13968:
	LWC1	%f1, 2(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13977
	ADDI	%r3, %r0, 0
	J	BEQ_cont.13978
BEQ_else.13977:
	ADDI	%r3, %r0, 1
BEQ_cont.13978:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.13979
	LW	%r3, 0(%r30) # restore1
	LW	%r4, 6(%r3)
	LWC1	%f1, 2(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13981
	ADDI	%r5, %r0, 0
	J	BEQ_cont.13982
BEQ_else.13981:
	ADDI	%r5, %r0, 1
BEQ_cont.13982:
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13983
	ADDI	%r4, %r5, 0
	J	BEQ_cont.13984
BEQ_else.13983:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.13985
	ADDI	%r4, %r0, 1
	J	BEQ_cont.13986
BEQ_else.13985:
	ADDI	%r4, %r0, 0
BEQ_cont.13986:
BEQ_cont.13984:
	LW	%r3, 4(%r3)
	LWC1	%f1, 2(%r3)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13987
	SUB.s	%f1, %f0, %f1
	J	BEQ_cont.13988
BEQ_else.13987:
BEQ_cont.13988:
	SWC1	%f1, 4(%r1)
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 2(%r2)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 5(%r1)
	J	BEQ_cont.13980
BEQ_else.13979:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 5(%r1)
BEQ_cont.13980:
	JR	%r31
setup_surface_table.2908:
	ADDI	%r3, %r0, 4
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LW	%r3, 0(%r30) # restore1
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
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.13989
	ADDI	%r2, %r0, 0
	J	BEQ_cont.13990
BEQ_else.13989:
	ADDI	%r2, %r0, 1
BEQ_cont.13990:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.13991
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r1)
	J	BEQ_cont.13992
BEQ_else.13991:
	LA	%r29, l.10568
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
BEQ_cont.13992:
	JR	%r31
setup_second_table.2911:
	ADDI	%r3, %r0, 5
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 1(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LWC1	%f2, 1(%r2)
	LWC1	%f3, 2(%r2)
	LW	%r3, 0(%r30) # restore1
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	quadratic.2842
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30) # restore1
	LWC1	%f2, 0(%r1)
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 4(%r2)
	LWC1	%f3, 0(%r3)
	MUL.s	%f2, %f2, %f3
	SUB.s	%f2, %f0, %f2
	LWC1	%f3, 1(%r1)
	LW	%r3, 4(%r2)
	LWC1	%f4, 1(%r3)
	MUL.s	%f3, %f3, %f4
	SUB.s	%f3, %f0, %f3
	LWC1	%f4, 2(%r1)
	LW	%r3, 4(%r2)
	LWC1	%f5, 2(%r3)
	MUL.s	%f4, %f4, %f5
	SUB.s	%f4, %f0, %f4
	LW	%r3, 2(%r30) # restore1
	SWC1	%f1, 0(%r3)
	LW	%r4, 3(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r4, %r27, BEQ_else.13993
	SWC1	%f2, 1(%r3)
	SWC1	%f3, 2(%r3)
	SWC1	%f4, 3(%r3)
	J	BEQ_cont.13994
BEQ_else.13993:
	LWC1	%f5, 2(%r1)
	LW	%r4, 9(%r2)
	LWC1	%f6, 1(%r4)
	MUL.s	%f5, %f5, %f6
	LWC1	%f6, 1(%r1)
	LW	%r4, 9(%r2)
	LWC1	%f7, 2(%r4)
	MUL.s	%f6, %f6, %f7
	ADD.s	%f5, %f5, %f6
	LA	%r29, l.10569
	LWC1	%f6, 0(%r29)
	MUL.s	%f5, %f5, %f6
	SUB.s	%f2, %f2, %f5
	SWC1	%f2, 1(%r3)
	LWC1	%f2, 2(%r1)
	LW	%r4, 9(%r2)
	LWC1	%f5, 0(%r4)
	MUL.s	%f2, %f2, %f5
	LWC1	%f5, 0(%r1)
	LW	%r4, 9(%r2)
	LWC1	%f6, 2(%r4)
	MUL.s	%f5, %f5, %f6
	ADD.s	%f2, %f2, %f5
	LA	%r29, l.10569
	LWC1	%f5, 0(%r29)
	MUL.s	%f2, %f2, %f5
	SUB.s	%f2, %f3, %f2
	SWC1	%f2, 2(%r3)
	LWC1	%f2, 1(%r1)
	LW	%r4, 9(%r2)
	LWC1	%f3, 0(%r4)
	MUL.s	%f2, %f2, %f3
	LWC1	%f3, 0(%r1)
	LW	%r1, 9(%r2)
	LWC1	%f5, 1(%r1)
	MUL.s	%f3, %f3, %f5
	ADD.s	%f2, %f2, %f3
	LA	%r29, l.10569
	LWC1	%f3, 0(%r29)
	MUL.s	%f2, %f2, %f3
	SUB.s	%f2, %f4, %f2
	SWC1	%f2, 3(%r3)
BEQ_cont.13994:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.13995
	ADDI	%r1, %r0, 0
	J	BEQ_cont.13996
BEQ_else.13995:
	ADDI	%r1, %r0, 1
BEQ_cont.13996:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.13997
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f2, %f1
	SWC1	%f1, 4(%r3)
	J	BEQ_cont.13998
BEQ_else.13997:
BEQ_cont.13998:
	ADDI	%r1, %r3, 0
	JR	%r31
iter_setup_dirvec_constants.2914:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.13999
	ADD	%r29, %r3, %r2
	LW	%r4, 0(%r29)
	LW	%r5, 1(%r1)
	LW	%r6, 0(%r1)
	LW	%r7, 1(%r4)
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r7, %r27, BEQ_else.14000
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r6, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14001
BEQ_else.14000:
	ADDI	%r27, %r0, 2
	BNE	%r7, %r27, BEQ_else.14002
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r6, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14003
BEQ_else.14002:
	SW	%r2, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r6, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14003:
BEQ_cont.14001:
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14004
	LW	%r2, 2(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 1(%r30) # restore1
	LW	%r4, 1(%r3)
	LW	%r5, 0(%r3)
	LW	%r6, 1(%r2)
	ADDI	%r27, %r0, 1
	BNE	%r6, %r27, BEQ_else.14005
	SW	%r1, 5(%r30)
	SW	%r4, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 6(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14006
BEQ_else.14005:
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.14007
	SW	%r1, 5(%r30)
	SW	%r4, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 6(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14008
BEQ_else.14007:
	SW	%r1, 5(%r30)
	SW	%r4, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 6(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14008:
BEQ_cont.14006:
	ADDI	%r2, %r2, -1
	LW	%r1, 1(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14004:
	JR	%r31
BEQ_else.13999:
	JR	%r31
setup_startp_constants.2919:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14011
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
	SW	%r1, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r2, 2(%r30)
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.14012
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
	J	BEQ_cont.14013
BEQ_else.14012:
	ADDI	%r27, %r0, 2
	SLT	%r27, %r27, %r5
	BNE	%r27, %r0, BEQ_else.14014
	J	BEQ_cont.14015
BEQ_else.14014:
	LWC1	%f1, 0(%r4)
	LWC1	%f2, 1(%r4)
	LWC1	%f3, 2(%r4)
	SW	%r4, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	quadratic.2842
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30) # restore1
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.14016
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.14017
BEQ_else.14016:
BEQ_cont.14017:
	LW	%r1, 3(%r30) # restore1
	SWC1	%f1, 3(%r1)
BEQ_cont.14015:
BEQ_cont.14013:
	LW	%r1, 2(%r30) # restore1
	ADDI	%r2, %r1, -1
	LW	%r1, 0(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14011:
	JR	%r31
setup_startp.2922:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	LWC1	%f1, 0(%r1)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 2(%r2)
	LW	%r2, 0(%r4)
	ADDI	%r2, %r2, -1
	ADDI	%r26, %r3, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
is_rect_outside.2924:
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.14019
	J	BEQ_cont.14020
BEQ_else.14019:
	SUB.s	%f1, %f0, %f1
BEQ_cont.14020:
	LW	%r2, 4(%r1)
	LWC1	%f4, 0(%r2)
	C.lt.s	%r27, %f1, %f4
	BNE	%r27, %r0, BEQ_else.14021
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14022
BEQ_else.14021:
	ADDI	%r2, %r0, 1
BEQ_cont.14022:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14023
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14024
BEQ_else.14023:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14025
	ADD.s	%f1, %f2, %f0
	J	BEQ_cont.14026
BEQ_else.14025:
	SUB.s	%f1, %f0, %f2
BEQ_cont.14026:
	LW	%r2, 4(%r1)
	LWC1	%f2, 1(%r2)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14027
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14028
BEQ_else.14027:
	ADDI	%r2, %r0, 1
BEQ_cont.14028:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14029
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14030
BEQ_else.14029:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	C.lt.s	%r27, %f3, %f1
	BNE	%r27, %r0, BEQ_else.14031
	ADD.s	%f1, %f3, %f0
	J	BEQ_cont.14032
BEQ_else.14031:
	SUB.s	%f1, %f0, %f3
BEQ_cont.14032:
	LW	%r2, 4(%r1)
	LWC1	%f2, 2(%r2)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14033
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14034
BEQ_else.14033:
	ADDI	%r2, %r0, 1
BEQ_cont.14034:
BEQ_cont.14030:
BEQ_cont.14024:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14035
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14036
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14036:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14035:
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
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14037
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14038
BEQ_else.14037:
	ADDI	%r2, %r0, 1
BEQ_cont.14038:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14039
	ADDI	%r1, %r2, 0
	J	BEQ_cont.14040
BEQ_else.14039:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14041
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14042
BEQ_else.14041:
	ADDI	%r1, %r0, 0
BEQ_cont.14042:
BEQ_cont.14040:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14043
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14043:
	ADDI	%r1, %r0, 0
	JR	%r31
is_second_outside.2934:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	quadratic.2842
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.14044
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.14045
BEQ_else.14044:
BEQ_cont.14045:
	LW	%r1, 6(%r1)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14046
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14047
BEQ_else.14046:
	ADDI	%r2, %r0, 1
BEQ_cont.14047:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14048
	ADDI	%r1, %r2, 0
	J	BEQ_cont.14049
BEQ_else.14048:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14050
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14051
BEQ_else.14050:
	ADDI	%r1, %r0, 0
BEQ_cont.14051:
BEQ_cont.14049:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14052
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14052:
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
	BNE	%r2, %r27, BEQ_else.14053
	J	is_rect_outside.2924
BEQ_else.14053:
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.14054
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
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14055
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14056
BEQ_else.14055:
	ADDI	%r2, %r0, 1
BEQ_cont.14056:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14057
	ADDI	%r1, %r2, 0
	J	BEQ_cont.14058
BEQ_else.14057:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14059
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14060
BEQ_else.14059:
	ADDI	%r1, %r0, 0
BEQ_cont.14060:
BEQ_cont.14058:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14061
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14061:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14054:
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	quadratic.2842
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, 3
	BNE	%r2, %r27, BEQ_else.14062
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	J	BEQ_cont.14063
BEQ_else.14062:
BEQ_cont.14063:
	LW	%r1, 6(%r1)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14064
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14065
BEQ_else.14064:
	ADDI	%r2, %r0, 1
BEQ_cont.14065:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14066
	ADDI	%r1, %r2, 0
	J	BEQ_cont.14067
BEQ_else.14066:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14068
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14069
BEQ_else.14068:
	ADDI	%r1, %r0, 0
BEQ_cont.14069:
BEQ_cont.14067:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14070
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14070:
	ADDI	%r1, %r0, 0
	JR	%r31
check_all_inside.2944:
	LW	%r3, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r4, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.14071
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14071:
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
	BNE	%r5, %r27, BEQ_else.14073
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	ADD.s	%f3, %f6, %f0 # args
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f4, %f0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	is_rect_outside.2924
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14074
BEQ_else.14073:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.14075
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	ADD.s	%f3, %f6, %f0 # args
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f4, %f0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	is_plane_outside.2929
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14076
BEQ_else.14075:
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	ADD.s	%f3, %f6, %f0 # args
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f4, %f0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	is_second_outside.2934
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14076:
BEQ_cont.14074:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14077
	LW	%r1, 10(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.14078
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14078:
	LW	%r4, 8(%r30) # restore1
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	LWC1	%f1, 6(%r30) # restore2
	LWC1	%f2, 4(%r30) # restore2
	LWC1	%f3, 2(%r30) # restore2
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	is_outside.2939
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14079
	LW	%r1, 11(%r30) # restore1
	ADDI	%r1, %r1, 1
	LWC1	%f1, 6(%r30) # restore2
	LWC1	%f2, 4(%r30) # restore2
	LWC1	%f3, 2(%r30) # restore2
	LW	%r2, 9(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14079:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14077:
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
	BNE	%r10, %r27, BEQ_else.14080
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14080:
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
	ADDI	%r2, %r6, 0 # args
	ADDI	%r1, %r10, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r8, 0 # args
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 8(%r30) # restore1
	LWC1	%f1, 0(%r2)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14081
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14082
BEQ_else.14081:
	LA	%r29, l.10933
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14083
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14084
BEQ_else.14083:
	ADDI	%r1, %r0, 1
BEQ_cont.14084:
BEQ_cont.14082:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14085
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 7(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14086
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14086:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14085:
	LA	%r29, l.10934
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r1, 2(%r30) # restore1
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f2, %f1
	LW	%r2, 1(%r30) # restore1
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
	LW	%r2, 3(%r30) # restore1
	LW	%r1, 0(%r2)
	ADDI	%r27, %r0, -1
	BNE	%r1, %r27, BEQ_else.14087
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14088
BEQ_else.14087:
	LW	%r3, 7(%r30) # restore1
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	SWC1	%f1, 10(%r30)
	SWC1	%f3, 12(%r30)
	SWC1	%f2, 14(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f31, %f3, %f0 # args
	ADD.s	%f3, %f1, %f0 # args
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f31, %f0 # args
	SW	%r29, 16(%r30) # save link register
	ADDI	%r30, %r30, 17
	JAL	is_outside.2939
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14090
	ADDI	%r1, %r0, 1
	LWC1	%f1, 14(%r30) # restore2
	LWC1	%f2, 12(%r30) # restore2
	LWC1	%f3, 10(%r30) # restore2
	LW	%r2, 3(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14091
BEQ_else.14090:
	ADDI	%r1, %r0, 0
BEQ_cont.14091:
BEQ_cont.14088:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14092
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14092:
	ADDI	%r1, %r0, 1
	JR	%r31
shadow_check_one_or_group.2953:
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r5, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.14093
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14093:
	ADD	%r29, %r4, %r5
	LW	%r5, 0(%r29)
	ADDI	%r6, %r0, 0
	SW	%r26, 0(%r30)
	SW	%r3, 1(%r30)
	SW	%r4, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r6, 0 # args
	ADDI	%r26, %r3, 0 # args
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14094
	LW	%r1, 4(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.14095
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14095:
	LW	%r4, 2(%r30) # restore1
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r26, 1(%r30) # restore1
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14096
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14096:
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14094:
	ADDI	%r1, %r0, 1
	JR	%r31
shadow_check_one_or_matrix.2956:
	LW	%r3, 7(%r26)
	LW	%r4, 6(%r26)
	LW	%r5, 5(%r26)
	LW	%r6, 4(%r26)
	LW	%r7, 3(%r26)
	LW	%r8, 2(%r26)
	LW	%r9, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r10, 0(%r29)
	LW	%r11, 0(%r10)
	ADDI	%r27, %r0, -1
	BNE	%r11, %r27, BEQ_else.14097
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14097:
	SW	%r5, 0(%r30)
	SW	%r6, 1(%r30)
	SW	%r9, 2(%r30)
	SW	%r10, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r26, 5(%r30)
	SW	%r1, 6(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r11, %r27, BEQ_else.14098
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14099
BEQ_else.14098:
	SW	%r4, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r11, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r8, 0 # args
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14100
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14101
BEQ_else.14100:
	LW	%r1, 7(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LA	%r29, l.10951
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14102
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14103
BEQ_else.14102:
	ADDI	%r1, %r0, 1
BEQ_cont.14103:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14104
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14105
BEQ_else.14104:
	LW	%r1, 3(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.14106
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14107
BEQ_else.14106:
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14108
	ADDI	%r1, %r0, 2
	LW	%r2, 3(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14109
BEQ_else.14108:
	ADDI	%r1, %r0, 1
BEQ_cont.14109:
BEQ_cont.14107:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14110
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14111
BEQ_else.14110:
	ADDI	%r1, %r0, 1
BEQ_cont.14111:
BEQ_cont.14105:
BEQ_cont.14101:
BEQ_cont.14099:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14112
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30) # restore1
	LW	%r26, 5(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14112:
	LW	%r1, 3(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.14113
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14114
BEQ_else.14113:
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14115
	ADDI	%r1, %r0, 2
	LW	%r2, 3(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14116
BEQ_else.14115:
	ADDI	%r1, %r0, 1
BEQ_cont.14116:
BEQ_cont.14114:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14117
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30) # restore1
	LW	%r26, 5(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14117:
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
	BNE	%r13, %r27, BEQ_else.14118
	JR	%r31
BEQ_else.14118:
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
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r13, 0 # args
	ADDI	%r26, %r7, 0 # args
	ADDI	%r3, %r5, 0 # args
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14120
	LW	%r1, 11(%r30) # restore1
	LW	%r2, 12(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14121
	JR	%r31
BEQ_else.14121:
	LW	%r1, 10(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30) # restore1
	LW	%r3, 7(%r30) # restore1
	LW	%r26, 9(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14120:
	LW	%r2, 6(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14123
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14124
BEQ_else.14123:
	ADDI	%r2, %r0, 1
BEQ_cont.14124:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14125
	J	BEQ_cont.14126
BEQ_else.14125:
	LW	%r2, 5(%r30) # restore1
	LWC1	%f2, 0(%r2)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14127
	ADDI	%r3, %r0, 0
	J	BEQ_cont.14128
BEQ_else.14127:
	ADDI	%r3, %r0, 1
BEQ_cont.14128:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.14129
	J	BEQ_cont.14130
BEQ_else.14129:
	LA	%r29, l.10934
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r3, 7(%r30) # restore1
	LWC1	%f2, 0(%r3)
	MUL.s	%f2, %f2, %f1
	LW	%r4, 4(%r30) # restore1
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
	LW	%r4, 8(%r30) # restore1
	LW	%r5, 0(%r4)
	SW	%r1, 13(%r30)
	SWC1	%f4, 14(%r30)
	SWC1	%f3, 16(%r30)
	SWC1	%f2, 18(%r30)
	SWC1	%f1, 20(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r5, %r27, BEQ_else.14131
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14132
BEQ_else.14131:
	LW	%r6, 12(%r30) # restore1
	ADD	%r29, %r6, %r5
	LW	%r5, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0 # args
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f3, %f0 # args
	ADD.s	%f3, %f4, %f0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	is_outside.2939
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14133
	ADDI	%r1, %r0, 1
	LWC1	%f1, 18(%r30) # restore2
	LWC1	%f2, 16(%r30) # restore2
	LWC1	%f3, 14(%r30) # restore2
	LW	%r2, 8(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14134
BEQ_else.14133:
	ADDI	%r1, %r0, 0
BEQ_cont.14134:
BEQ_cont.14132:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14135
	J	BEQ_cont.14136
BEQ_else.14135:
	LW	%r1, 5(%r30) # restore1
	LWC1	%f1, 20(%r30) # restore2
	SWC1	%f1, 0(%r1)
	LW	%r1, 2(%r30) # restore1
	LWC1	%f1, 18(%r30) # restore2
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 16(%r30) # restore2
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 14(%r30) # restore2
	SWC1	%f1, 2(%r1)
	LW	%r1, 1(%r30) # restore1
	LW	%r2, 11(%r30) # restore1
	SW	%r2, 0(%r1)
	LW	%r1, 0(%r30) # restore1
	LW	%r2, 13(%r30) # restore1
	SW	%r2, 0(%r1)
BEQ_cont.14136:
BEQ_cont.14130:
BEQ_cont.14126:
	LW	%r1, 10(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 8(%r30) # restore1
	LW	%r3, 7(%r30) # restore1
	LW	%r26, 9(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
solve_one_or_network.2963:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r6, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r6, %r27, BEQ_else.14137
	JR	%r31
BEQ_else.14137:
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
	ADDI	%r2, %r6, 0 # args
	ADDI	%r1, %r7, 0 # args
	ADDI	%r26, %r4, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.14139
	JR	%r31
BEQ_else.14139:
	LW	%r4, 3(%r30) # restore1
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 1(%r30) # restore1
	LW	%r26, 2(%r30) # restore1
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r4, 0 # args
	ADDI	%r3, %r5, 0 # args
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
trace_or_matrix.2967:
	LW	%r4, 7(%r26)
	LW	%r5, 6(%r26)
	LW	%r6, 5(%r26)
	LW	%r7, 4(%r26)
	LW	%r8, 3(%r26)
	LW	%r9, 2(%r26)
	LW	%r10, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r11, 0(%r29)
	LW	%r12, 0(%r11)
	ADDI	%r27, %r0, -1
	BNE	%r12, %r27, BEQ_else.14141
	JR	%r31
BEQ_else.14141:
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r12, %r27, BEQ_else.14143
	LW	%r4, 1(%r11)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.14145
	J	BEQ_cont.14146
BEQ_else.14145:
	ADD	%r29, %r10, %r4
	LW	%r4, 0(%r29)
	ADDI	%r5, %r0, 0
	SW	%r11, 4(%r30)
	SW	%r8, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r5, 0 # args
	ADDI	%r26, %r9, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 2
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14146:
	J	BEQ_cont.14144
BEQ_else.14143:
	SW	%r8, 5(%r30)
	SW	%r9, 6(%r30)
	SW	%r10, 7(%r30)
	SW	%r11, 4(%r30)
	SW	%r4, 8(%r30)
	SW	%r6, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r12, 0 # args
	ADDI	%r26, %r7, 0 # args
	ADDI	%r3, %r5, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14147
	J	BEQ_cont.14148
BEQ_else.14147:
	LW	%r1, 9(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LW	%r1, 8(%r30) # restore1
	LWC1	%f2, 0(%r1)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14149
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14150
BEQ_else.14149:
	ADDI	%r1, %r0, 1
BEQ_cont.14150:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14151
	J	BEQ_cont.14152
BEQ_else.14151:
	LW	%r1, 4(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.14153
	J	BEQ_cont.14154
BEQ_else.14153:
	LW	%r3, 7(%r30) # restore1
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r4, 0(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	ADDI	%r3, %r4, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 2
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14154:
BEQ_cont.14152:
BEQ_cont.14148:
BEQ_cont.14144:
	LW	%r1, 3(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 2(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
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
	LW	%r13, 0(%r3)
	ADD	%r29, %r2, %r1
	LW	%r14, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r14, %r27, BEQ_else.14155
	JR	%r31
BEQ_else.14155:
	SW	%r9, 0(%r30)
	SW	%r11, 1(%r30)
	SW	%r10, 2(%r30)
	SW	%r12, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r13, 5(%r30)
	SW	%r4, 6(%r30)
	SW	%r7, 7(%r30)
	SW	%r3, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r26, 10(%r30)
	SW	%r1, 11(%r30)
	SW	%r14, 12(%r30)
	SW	%r8, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r14, 0 # args
	ADDI	%r26, %r6, 0 # args
	SW	%r29, 14(%r30)
	ADDI	%r30, %r30, 15
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14157
	LW	%r1, 12(%r30) # restore1
	LW	%r2, 13(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 6(%r1)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14158
	JR	%r31
BEQ_else.14158:
	LW	%r1, 11(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	LW	%r26, 10(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14157:
	LW	%r2, 7(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14160
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14161
BEQ_else.14160:
	ADDI	%r2, %r0, 1
BEQ_cont.14161:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14162
	J	BEQ_cont.14163
BEQ_else.14162:
	LW	%r2, 6(%r30) # restore1
	LWC1	%f2, 0(%r2)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14164
	ADDI	%r3, %r0, 0
	J	BEQ_cont.14165
BEQ_else.14164:
	ADDI	%r3, %r0, 1
BEQ_cont.14165:
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.14166
	J	BEQ_cont.14167
BEQ_else.14166:
	LA	%r29, l.10934
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	LW	%r3, 5(%r30) # restore1
	LWC1	%f2, 0(%r3)
	MUL.s	%f2, %f2, %f1
	LW	%r4, 4(%r30) # restore1
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
	LW	%r3, 9(%r30) # restore1
	LW	%r4, 0(%r3)
	SW	%r1, 14(%r30)
	SWC1	%f4, 16(%r30)
	SWC1	%f3, 18(%r30)
	SWC1	%f2, 20(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.14169
	ADDI	%r1, %r0, 1
	J	BEQ_cont.14170
BEQ_else.14169:
	LW	%r5, 13(%r30) # restore1
	ADD	%r29, %r5, %r4
	LW	%r4, 0(%r29)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f3, %f0 # args
	ADD.s	%f3, %f4, %f0 # args
	SW	%r29, 24(%r30) # save link register
	ADDI	%r30, %r30, 25
	JAL	is_outside.2939
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14171
	ADDI	%r1, %r0, 1
	LWC1	%f1, 20(%r30) # restore2
	LWC1	%f2, 18(%r30) # restore2
	LWC1	%f3, 16(%r30) # restore2
	LW	%r2, 9(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30)
	ADDI	%r30, %r30, 25
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14172
BEQ_else.14171:
	ADDI	%r1, %r0, 0
BEQ_cont.14172:
BEQ_cont.14170:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14173
	J	BEQ_cont.14174
BEQ_else.14173:
	LW	%r1, 6(%r30) # restore1
	LWC1	%f1, 22(%r30) # restore2
	SWC1	%f1, 0(%r1)
	LW	%r1, 2(%r30) # restore1
	LWC1	%f1, 20(%r30) # restore2
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 18(%r30) # restore2
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 16(%r30) # restore2
	SWC1	%f1, 2(%r1)
	LW	%r1, 1(%r30) # restore1
	LW	%r2, 12(%r30) # restore1
	SW	%r2, 0(%r1)
	LW	%r1, 0(%r30) # restore1
	LW	%r2, 14(%r30) # restore1
	SW	%r2, 0(%r1)
BEQ_cont.14174:
BEQ_cont.14167:
BEQ_cont.14163:
	LW	%r1, 11(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 9(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	LW	%r26, 10(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
solve_one_or_network_fast.2977:
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r6, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r6, %r27, BEQ_else.14175
	JR	%r31
BEQ_else.14175:
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
	ADDI	%r2, %r6, 0 # args
	ADDI	%r1, %r7, 0 # args
	ADDI	%r26, %r4, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, -1
	BNE	%r3, %r27, BEQ_else.14177
	JR	%r31
BEQ_else.14177:
	LW	%r4, 3(%r30) # restore1
	ADD	%r29, %r4, %r3
	LW	%r3, 0(%r29)
	ADDI	%r4, %r0, 0
	LW	%r5, 1(%r30) # restore1
	LW	%r26, 2(%r30) # restore1
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r4, 0 # args
	ADDI	%r3, %r5, 0 # args
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
trace_or_matrix_fast.2981:
	LW	%r4, 6(%r26)
	LW	%r5, 5(%r26)
	LW	%r6, 4(%r26)
	LW	%r7, 3(%r26)
	LW	%r8, 2(%r26)
	LW	%r9, 1(%r26)
	ADD	%r29, %r2, %r1
	LW	%r10, 0(%r29)
	LW	%r11, 0(%r10)
	ADDI	%r27, %r0, -1
	BNE	%r11, %r27, BEQ_else.14179
	JR	%r31
BEQ_else.14179:
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r1, 3(%r30)
	ADDI	%r27, %r0, 99
	BNE	%r11, %r27, BEQ_else.14181
	LW	%r4, 1(%r10)
	ADDI	%r27, %r0, -1
	BNE	%r4, %r27, BEQ_else.14183
	J	BEQ_cont.14184
BEQ_else.14183:
	ADD	%r29, %r9, %r4
	LW	%r4, 0(%r29)
	ADDI	%r5, %r0, 0
	SW	%r10, 4(%r30)
	SW	%r7, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r5, 0 # args
	ADDI	%r26, %r8, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 2
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14184:
	J	BEQ_cont.14182
BEQ_else.14181:
	SW	%r7, 5(%r30)
	SW	%r8, 6(%r30)
	SW	%r9, 7(%r30)
	SW	%r10, 4(%r30)
	SW	%r4, 8(%r30)
	SW	%r6, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r1, %r11, 0 # args
	ADDI	%r26, %r5, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14185
	J	BEQ_cont.14186
BEQ_else.14185:
	LW	%r1, 9(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LW	%r1, 8(%r30) # restore1
	LWC1	%f2, 0(%r1)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14187
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14188
BEQ_else.14187:
	ADDI	%r1, %r0, 1
BEQ_cont.14188:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14189
	J	BEQ_cont.14190
BEQ_else.14189:
	LW	%r1, 4(%r30) # restore1
	LW	%r2, 1(%r1)
	ADDI	%r27, %r0, -1
	BNE	%r2, %r27, BEQ_else.14191
	J	BEQ_cont.14192
BEQ_else.14191:
	LW	%r3, 7(%r30) # restore1
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 0
	LW	%r4, 0(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	ADDI	%r3, %r4, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 2
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14192:
BEQ_cont.14190:
BEQ_cont.14186:
BEQ_cont.14182:
	LW	%r1, 3(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 2(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
get_nvector_rect.2987:
	LW	%r2, 2(%r26)
	LW	%r3, 1(%r26)
	LW	%r3, 0(%r3)
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r2)
	SWC1	%f1, 1(%r2)
	SWC1	%f1, 2(%r2)
	ADDI	%r4, %r3, -1
	ADDI	%r3, %r3, -1
	ADD	%r29, %r1, %r3
	LWC1	%f1, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14193
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14194
BEQ_else.14193:
	ADDI	%r1, %r0, 1
BEQ_cont.14194:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14195
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14197
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14198
BEQ_else.14197:
	ADDI	%r1, %r0, 1
BEQ_cont.14198:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14199
	LA	%r29, l.10568
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.14200
BEQ_else.14199:
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
BEQ_cont.14200:
	J	BEQ_cont.14196
BEQ_else.14195:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14196:
	SUB.s	%f1, %f0, %f1
	ADD	%r29, %r2, %r4
	SWC1	%f1, 0(%r29)
	JR	%r31
get_nvector_plane.2989:
	LW	%r2, 1(%r26)
	LW	%r3, 4(%r1)
	LWC1	%f1, 0(%r3)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 0(%r2)
	LW	%r3, 4(%r1)
	LWC1	%f1, 1(%r3)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 1(%r2)
	LW	%r1, 4(%r1)
	LWC1	%f1, 2(%r1)
	SUB.s	%f1, %f0, %f1
	SWC1	%f1, 2(%r2)
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
	BNE	%r3, %r27, BEQ_else.14203
	SWC1	%f4, 0(%r2)
	SWC1	%f5, 1(%r2)
	SWC1	%f6, 2(%r2)
	J	BEQ_cont.14204
BEQ_else.14203:
	LW	%r3, 9(%r1)
	LWC1	%f7, 2(%r3)
	MUL.s	%f7, %f2, %f7
	LW	%r3, 9(%r1)
	LWC1	%f8, 1(%r3)
	MUL.s	%f8, %f3, %f8
	ADD.s	%f7, %f7, %f8
	LA	%r29, l.10569
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
	LA	%r29, l.10569
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
	LA	%r29, l.10569
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	ADD.s	%f1, %f6, %f1
	SWC1	%f1, 2(%r2)
BEQ_cont.14204:
	LW	%r1, 6(%r1)
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	J	vecunit_sgn.2699
calc_sqrt.6353.7436:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14205
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14206
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14207
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14208
	J	calc_sqrt.6353.7436
BEQ_else.14208:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14207:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.14206:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14205:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7471:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14209
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14210
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14211
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14212
	J	calc_sqrt.6353.7471
BEQ_else.14212:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14211:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.14210:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14209:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7506:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14213
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14214
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14215
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14216
	J	calc_sqrt.6353.7506
BEQ_else.14216:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14215:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.14214:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14213:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_sqrt.6353.7543:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14217
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14218
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14219
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14220
	J	calc_sqrt.6353.7543
BEQ_else.14220:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14219:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.14218:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14217:
	ADD.s	%f1, %f2, %f0
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
	BNE	%r4, %r27, BEQ_else.14221
	LWC1	%f1, 0(%r2)
	LW	%r4, 5(%r1)
	LWC1	%f2, 0(%r4)
	SUB.s	%f1, %f1, %f2
	LA	%r29, l.11085
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	SWC1	%f1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	floor.2618
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11086
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 4(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.11076
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14223
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14224
BEQ_else.14223:
	ADDI	%r1, %r0, 1
BEQ_cont.14224:
	LW	%r2, 2(%r30) # restore1
	LWC1	%f1, 2(%r2)
	LW	%r2, 1(%r30) # restore1
	LW	%r2, 5(%r2)
	LWC1	%f2, 2(%r2)
	SUB.s	%f1, %f1, %f2
	LA	%r29, l.11085
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	SW	%r1, 6(%r30)
	SWC1	%f1, 8(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	floor.2618
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11086
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 8(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.11076
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14226
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14227
BEQ_else.14226:
	ADDI	%r1, %r0, 1
BEQ_cont.14227:
	LW	%r2, 6(%r30) # restore1
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14228
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14230
	LA	%r29, l.11069
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.14231
BEQ_else.14230:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14231:
	J	BEQ_cont.14229
BEQ_else.14228:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14232
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.14233
BEQ_else.14232:
	LA	%r29, l.11069
	LWC1	%f1, 0(%r29)
BEQ_cont.14233:
BEQ_cont.14229:
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 1(%r1)
	JR	%r31
BEQ_else.14221:
	ADDI	%r27, %r0, 2
	BNE	%r4, %r27, BEQ_else.14235
	LWC1	%f1, 1(%r2)
	LA	%r29, l.11080
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14236
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14237
BEQ_else.14236:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.14237:
	MUL.s	%f1, %f1, %f1
	LA	%r29, l.11069
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f2, %f1
	LW	%r1, 0(%r30) # restore1
	SWC1	%f2, 0(%r1)
	LA	%r29, l.11069
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10549
	LWC1	%f3, 0(%r29)
	SUB.s	%f1, %f3, %f1
	MUL.s	%f1, %f2, %f1
	SWC1	%f1, 1(%r1)
	JR	%r31
BEQ_else.14235:
	ADDI	%r27, %r0, 3
	BNE	%r4, %r27, BEQ_else.14239
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
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	SW	%r3, 0(%r30)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14240
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.eq.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14242
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f1, %f2
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14244
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14246
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14248
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f3, %f0 # args
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	calc_sqrt.6353.7543
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14249
BEQ_else.14248:
	ADD.s	%f1, %f2, %f0
BEQ_cont.14249:
	J	BEQ_cont.14247
BEQ_else.14246:
	ADD.s	%f1, %f3, %f0
BEQ_cont.14247:
	J	BEQ_cont.14245
BEQ_else.14244:
	ADD.s	%f1, %f2, %f0
BEQ_cont.14245:
	J	BEQ_cont.14243
BEQ_else.14242:
BEQ_cont.14243:
	J	BEQ_cont.14241
BEQ_else.14240:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14241:
	LA	%r29, l.11076
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	SWC1	%f1, 10(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	floor.2618
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.11064
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14250
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14251
BEQ_else.14250:
	SUB.s	%f1, %f0, %f1
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14251:
	MUL.s	%f1, %f1, %f1
	LA	%r29, l.11069
	LWC1	%f2, 0(%r29)
	MUL.s	%f2, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f2, 1(%r1)
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.11069
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.14239:
	ADDI	%r27, %r0, 4
	BNE	%r4, %r27, BEQ_else.14253
	LWC1	%f1, 0(%r2)
	LW	%r4, 5(%r1)
	LWC1	%f2, 0(%r4)
	SUB.s	%f1, %f1, %f2
	LW	%r4, 4(%r1)
	LWC1	%f2, 0(%r4)
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r2, 2(%r30)
	SWC1	%f1, 12(%r30)
	C.lt.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14254
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14256
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	DIV.s	%f3, %f2, %f3
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.14258
	DIV.s	%f3, %f2, %f4
	ADD.s	%f3, %f4, %f3
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f3, %f3, %f5
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14260
	DIV.s	%f4, %f2, %f3
	ADD.s	%f4, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f5, 0(%r29)
	DIV.s	%f4, %f4, %f5
	C.eq.s	%r27, %f4, %f3
	BNE	%r27, %r0, BEQ_else.14262
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f4, %f0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	calc_sqrt.6353.7506
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14263
BEQ_else.14262:
	ADD.s	%f1, %f3, %f0
BEQ_cont.14263:
	J	BEQ_cont.14261
BEQ_else.14260:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14261:
	J	BEQ_cont.14259
BEQ_else.14258:
	ADD.s	%f1, %f3, %f0
BEQ_cont.14259:
	J	BEQ_cont.14257
BEQ_else.14256:
	ADD.s	%f1, %f2, %f0
BEQ_cont.14257:
	J	BEQ_cont.14255
BEQ_else.14254:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14255:
	LWC1	%f2, 12(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 2(%r30) # restore1
	LWC1	%f2, 2(%r1)
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 5(%r2)
	LWC1	%f3, 2(%r3)
	SUB.s	%f2, %f2, %f3
	LW	%r3, 4(%r2)
	LWC1	%f3, 2(%r3)
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	SWC1	%f1, 14(%r30)
	SWC1	%f2, 16(%r30)
	C.lt.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14264
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14266
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.14268
	DIV.s	%f4, %f3, %f5
	ADD.s	%f4, %f5, %f4
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f4, %f4, %f6
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.14270
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.14272
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 18(%r30) # save link register
	ADDI	%r30, %r30, 19
	JAL	calc_sqrt.6353.7471
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14273
BEQ_else.14272:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14273:
	J	BEQ_cont.14271
BEQ_else.14270:
	ADD.s	%f1, %f5, %f0
BEQ_cont.14271:
	J	BEQ_cont.14269
BEQ_else.14268:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14269:
	J	BEQ_cont.14267
BEQ_else.14266:
	ADD.s	%f1, %f3, %f0
BEQ_cont.14267:
	J	BEQ_cont.14265
BEQ_else.14264:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14265:
	LWC1	%f2, 16(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 14(%r30) # restore2
	MUL.s	%f3, %f2, %f2
	MUL.s	%f4, %f1, %f1
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f2, %f4
	BNE	%r27, %r0, BEQ_else.14274
	ADD.s	%f4, %f2, %f0
	J	BEQ_cont.14275
BEQ_else.14274:
	SUB.s	%f4, %f0, %f2
BEQ_cont.14275:
	LA	%r29, l.11061
	LWC1	%f5, 0(%r29)
	C.lt.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.14276
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14277
BEQ_else.14276:
	ADDI	%r1, %r0, 1
BEQ_cont.14277:
	SWC1	%f3, 18(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14278
	DIV.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14280
	J	BEQ_cont.14281
BEQ_else.14280:
	SUB.s	%f1, %f0, %f1
BEQ_cont.14281:
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30) # save link register
	ADDI	%r30, %r30, 21
	JAL	atan.2634
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11063
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.11064
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.14279
BEQ_else.14278:
	LA	%r29, l.11062
	LWC1	%f1, 0(%r29)
BEQ_cont.14279:
	SWC1	%f1, 20(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	floor.2618
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LW	%r1, 2(%r30) # restore1
	LWC1	%f2, 1(%r1)
	LW	%r1, 1(%r30) # restore1
	LW	%r2, 5(%r1)
	LWC1	%f3, 1(%r2)
	SUB.s	%f2, %f2, %f3
	LW	%r1, 4(%r1)
	LWC1	%f3, 1(%r1)
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	SWC1	%f1, 22(%r30)
	SWC1	%f2, 24(%r30)
	C.lt.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14282
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14284
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.14286
	DIV.s	%f4, %f3, %f5
	ADD.s	%f4, %f5, %f4
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f4, %f4, %f6
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.14288
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.14290
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 26(%r30) # save link register
	ADDI	%r30, %r30, 27
	JAL	calc_sqrt.6353.7436
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14291
BEQ_else.14290:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14291:
	J	BEQ_cont.14289
BEQ_else.14288:
	ADD.s	%f1, %f5, %f0
BEQ_cont.14289:
	J	BEQ_cont.14287
BEQ_else.14286:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14287:
	J	BEQ_cont.14285
BEQ_else.14284:
	ADD.s	%f1, %f3, %f0
BEQ_cont.14285:
	J	BEQ_cont.14283
BEQ_else.14282:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14283:
	LWC1	%f2, 24(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 18(%r30) # restore2
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14292
	ADD.s	%f2, %f3, %f0
	J	BEQ_cont.14293
BEQ_else.14292:
	SUB.s	%f2, %f0, %f3
BEQ_cont.14293:
	LA	%r29, l.11061
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f2, %f4
	BNE	%r27, %r0, BEQ_else.14294
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14295
BEQ_else.14294:
	ADDI	%r1, %r0, 1
BEQ_cont.14295:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14296
	DIV.s	%f1, %f1, %f3
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14298
	J	BEQ_cont.14299
BEQ_else.14298:
	SUB.s	%f1, %f0, %f1
BEQ_cont.14299:
	ADDI	%r29, %r31, 0
	SW	%r29, 26(%r30) # save link register
	ADDI	%r30, %r30, 27
	JAL	atan.2634
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11063
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.11064
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	J	BEQ_cont.14297
BEQ_else.14296:
	LA	%r29, l.11062
	LWC1	%f1, 0(%r29)
BEQ_cont.14297:
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30) # save link register
	ADDI	%r30, %r30, 29
	JAL	floor.2618
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 26(%r30) # restore2
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.11068
	LWC1	%f2, 0(%r29)
	LA	%r29, l.10569
	LWC1	%f3, 0(%r29)
	LWC1	%f4, 22(%r30) # restore2
	SUB.s	%f3, %f3, %f4
	MUL.s	%f3, %f3, %f3
	SUB.s	%f2, %f2, %f3
	LA	%r29, l.10569
	LWC1	%f3, 0(%r29)
	SUB.s	%f1, %f3, %f1
	MUL.s	%f1, %f1, %f1
	SUB.s	%f1, %f2, %f1
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14300
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14301
BEQ_else.14300:
	ADDI	%r1, %r0, 1
BEQ_cont.14301:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14302
	J	BEQ_cont.14303
BEQ_else.14302:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14303:
	LA	%r29, l.11069
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f2, %f1
	LA	%r29, l.11070
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
	SWC1	%f1, 2(%r1)
	JR	%r31
BEQ_else.14253:
	JR	%r31
add_light.2999:
	LW	%r2, 2(%r26)
	LW	%r1, 1(%r26)
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.lt.s	%r27, %f4, %f1
	BNE	%r27, %r0, BEQ_else.14306
	ADDI	%r3, %r0, 0
	J	BEQ_cont.14307
BEQ_else.14306:
	ADDI	%r3, %r0, 1
BEQ_cont.14307:
	SW	%r1, 0(%r30)
	SWC1	%f3, 2(%r30)
	SWC1	%f2, 4(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.14309
	J	BEQ_cont.14310
BEQ_else.14309:
	ADDI	%r29, %r31, 0
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	vecaccum.2710
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14310:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 4(%r30) # restore2
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14311
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14312
BEQ_else.14311:
	ADDI	%r1, %r0, 1
BEQ_cont.14312:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14313
	JR	%r31
BEQ_else.14313:
	MUL.s	%f1, %f2, %f2
	MUL.s	%f1, %f1, %f1
	LWC1	%f2, 2(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LW	%r1, 0(%r30) # restore1
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
	LW	%r3, 9(%r26)
	LW	%r4, 8(%r26)
	LW	%r5, 7(%r26)
	LW	%r6, 6(%r26)
	LW	%r7, 5(%r26)
	LW	%r8, 4(%r26)
	LW	%r9, 3(%r26)
	LW	%r10, 2(%r26)
	LW	%r11, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14316
	ADD	%r29, %r6, %r1
	LW	%r6, 0(%r29)
	LW	%r12, 1(%r6)
	LA	%r29, l.11097
	LWC1	%f3, 0(%r29)
	SWC1	%f3, 0(%r4)
	ADDI	%r13, %r0, 0
	LW	%r14, 0(%r7)
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r11, 4(%r30)
	SW	%r2, 5(%r30)
	SWC1	%f1, 6(%r30)
	SW	%r8, 8(%r30)
	SW	%r12, 9(%r30)
	SW	%r5, 10(%r30)
	SW	%r7, 11(%r30)
	SW	%r6, 12(%r30)
	SW	%r9, 13(%r30)
	SW	%r10, 14(%r30)
	SW	%r4, 15(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r14, 0 # args
	ADDI	%r1, %r13, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r12, 0 # args
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 15(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LA	%r29, l.10951
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14317
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14318
BEQ_else.14317:
	ADDI	%r1, %r0, 1
BEQ_cont.14318:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14319
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14320
BEQ_else.14319:
	LA	%r29, l.11101
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14321
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14322
BEQ_else.14321:
	ADDI	%r1, %r0, 1
BEQ_cont.14322:
BEQ_cont.14320:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14323
	J	BEQ_cont.14324
BEQ_else.14323:
	LW	%r1, 14(%r30) # restore1
	LW	%r1, 0(%r1)
	SLL	%r1, %r1, 2
	LW	%r2, 13(%r30) # restore1
	LW	%r2, 0(%r2)
	ADD	%r1, %r1, %r2
	LW	%r2, 12(%r30) # restore1
	LW	%r3, 0(%r2)
	BNE	%r1, %r3, BEQ_else.14325
	ADDI	%r1, %r0, 0
	LW	%r3, 11(%r30) # restore1
	LW	%r3, 0(%r3)
	LW	%r26, 10(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 16(%r30)
	ADDI	%r30, %r30, 17
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14327
	LW	%r1, 9(%r30) # restore1
	LW	%r2, 0(%r1)
	LW	%r3, 8(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 16(%r30) # save link register
	ADDI	%r30, %r30, 17
	JAL	veciprod.2702
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 12(%r30) # restore1
	LWC1	%f2, 2(%r1)
	LWC1	%f3, 6(%r30) # restore2
	MUL.s	%f4, %f2, %f3
	MUL.s	%f1, %f4, %f1
	LW	%r1, 9(%r30) # restore1
	LW	%r2, 0(%r1)
	LW	%r1, 5(%r30) # restore1
	SWC1	%f1, 16(%r30)
	SWC1	%f2, 18(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30) # save link register
	ADDI	%r30, %r30, 21
	JAL	veciprod.2702
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 18(%r30) # restore2
	MUL.s	%f2, %f2, %f1
	LWC1	%f1, 16(%r30) # restore2
	LWC1	%f3, 2(%r30) # restore2
	LW	%r26, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30)
	ADDI	%r30, %r30, 21
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14328
BEQ_else.14327:
BEQ_cont.14328:
	J	BEQ_cont.14326
BEQ_else.14325:
BEQ_cont.14326:
BEQ_cont.14324:
	LW	%r1, 1(%r30) # restore1
	ADDI	%r1, %r1, -1
	LWC1	%f1, 6(%r30) # restore2
	LWC1	%f2, 2(%r30) # restore2
	LW	%r2, 5(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14316:
	JR	%r31
trace_ray.3008:
	LW	%r4, 24(%r26)
	LW	%r5, 23(%r26)
	LW	%r6, 22(%r26)
	LW	%r7, 21(%r26)
	LW	%r8, 20(%r26)
	LW	%r9, 19(%r26)
	LW	%r10, 18(%r26)
	LW	%r11, 17(%r26)
	LW	%r12, 16(%r26)
	LW	%r13, 15(%r26)
	LW	%r14, 14(%r26)
	LW	%r15, 13(%r26)
	LW	%r16, 12(%r26)
	LW	%r17, 11(%r26)
	LW	%r18, 10(%r26)
	LW	%r19, 9(%r26)
	LW	%r20, 8(%r26)
	LW	%r21, 7(%r26)
	LW	%r22, 6(%r26)
	LW	%r23, 5(%r26)
	LW	%r24, 4(%r26)
	LW	%r25, 3(%r26)
	SW	%r5, 0(%r30)
	LW	%r5, 2(%r26)
	SW	%r26, 1(%r30)
	LW	%r26, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.14330
	SW	%r17, 2(%r30)
	LW	%r17, 2(%r3)
	LA	%r29, l.11097
	LWC1	%f3, 0(%r29)
	SWC1	%f3, 0(%r7)
	SW	%r12, 3(%r30)
	ADDI	%r12, %r0, 0
	SW	%r18, 4(%r30)
	LW	%r18, 0(%r14)
	SWC1	%f2, 6(%r30)
	SW	%r9, 8(%r30)
	SW	%r26, 9(%r30)
	SW	%r11, 10(%r30)
	SW	%r14, 11(%r30)
	SW	%r16, 12(%r30)
	SW	%r8, 13(%r30)
	SW	%r3, 14(%r30)
	SW	%r20, 15(%r30)
	SW	%r4, 16(%r30)
	SW	%r10, 17(%r30)
	SW	%r21, 18(%r30)
	SW	%r23, 19(%r30)
	SW	%r25, 20(%r30)
	SW	%r24, 21(%r30)
	SW	%r15, 22(%r30)
	SW	%r22, 23(%r30)
	SW	%r13, 24(%r30)
	SW	%r5, 25(%r30)
	SWC1	%f1, 26(%r30)
	SW	%r19, 28(%r30)
	SW	%r2, 29(%r30)
	SW	%r1, 30(%r30)
	SW	%r17, 31(%r30)
	SW	%r7, 32(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r2, 0 # args
	ADDI	%r1, %r12, 0 # args
	ADDI	%r26, %r6, 0 # args
	ADDI	%r2, %r18, 0 # args
	SW	%r29, 33(%r30)
	ADDI	%r30, %r30, 34
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 32(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LA	%r29, l.10951
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14332
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14333
BEQ_else.14332:
	ADDI	%r2, %r0, 1
BEQ_cont.14333:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14334
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14335
BEQ_else.14334:
	LA	%r29, l.11101
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14336
	ADDI	%r2, %r0, 0
	J	BEQ_cont.14337
BEQ_else.14336:
	ADDI	%r2, %r0, 1
BEQ_cont.14337:
BEQ_cont.14335:
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14338
	ADDI	%r1, %r0, -1
	LW	%r2, 30(%r30) # restore1
	LW	%r3, 31(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r2, %r27, BEQ_else.14339
	JR	%r31
BEQ_else.14339:
	LW	%r1, 29(%r30) # restore1
	LW	%r2, 28(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 33(%r30) # save link register
	ADDI	%r30, %r30, 34
	JAL	veciprod.2702
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14341
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14342
BEQ_else.14341:
	ADDI	%r1, %r0, 1
BEQ_cont.14342:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14343
	JR	%r31
BEQ_else.14343:
	MUL.s	%f2, %f1, %f1
	MUL.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LW	%r1, 25(%r30) # restore1
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 24(%r30) # restore1
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
BEQ_else.14338:
	LW	%r2, 23(%r30) # restore1
	LW	%r2, 0(%r2)
	LW	%r3, 22(%r30) # restore1
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	LW	%r4, 2(%r3)
	LW	%r5, 7(%r3)
	LWC1	%f1, 0(%r5)
	LWC1	%f2, 26(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LW	%r5, 1(%r3)
	SW	%r4, 33(%r30)
	SWC1	%f1, 34(%r30)
	SW	%r2, 36(%r30)
	SW	%r3, 37(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r5, %r27, BEQ_else.14346
	LW	%r5, 29(%r30) # restore1
	LW	%r26, 21(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0 # args
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14347
BEQ_else.14346:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.14348
	LW	%r26, 20(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14349
BEQ_else.14348:
	LW	%r26, 19(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14349:
BEQ_cont.14347:
	LW	%r2, 18(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LW	%r1, 17(%r30) # restore1
	SWC1	%f1, 0(%r1)
	LWC1	%f1, 1(%r2)
	SWC1	%f1, 1(%r1)
	LWC1	%f1, 2(%r2)
	SWC1	%f1, 2(%r1)
	LW	%r1, 37(%r30) # restore1
	LW	%r26, 16(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30)
	ADDI	%r30, %r30, 39
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 36(%r30) # restore1
	SLL	%r1, %r1, 2
	LW	%r2, 15(%r30) # restore1
	LW	%r2, 0(%r2)
	ADD	%r1, %r1, %r2
	LW	%r2, 30(%r30) # restore1
	LW	%r3, 31(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 14(%r30) # restore1
	LW	%r4, 1(%r1)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r5, 18(%r30) # restore1
	LWC1	%f1, 0(%r5)
	SWC1	%f1, 0(%r4)
	LWC1	%f1, 1(%r5)
	SWC1	%f1, 1(%r4)
	LWC1	%f1, 2(%r5)
	SWC1	%f1, 2(%r4)
	LW	%r4, 3(%r1)
	LW	%r6, 37(%r30) # restore1
	LW	%r7, 7(%r6)
	LWC1	%f1, 0(%r7)
	LA	%r29, l.10569
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14350
	ADDI	%r7, %r0, 0
	J	BEQ_cont.14351
BEQ_else.14350:
	ADDI	%r7, %r0, 1
BEQ_cont.14351:
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.14352
	ADDI	%r7, %r0, 1
	ADD	%r29, %r4, %r2
	SW	%r7, 0(%r29)
	LW	%r4, 4(%r1)
	ADD	%r29, %r4, %r2
	LW	%r7, 0(%r29)
	LW	%r8, 13(%r30) # restore1
	LWC1	%f1, 0(%r8)
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r8)
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r8)
	SWC1	%f1, 2(%r7)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LA	%r29, l.11137
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 34(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LWC1	%f3, 0(%r4)
	MUL.s	%f3, %f3, %f1
	SWC1	%f3, 0(%r4)
	LWC1	%f3, 1(%r4)
	MUL.s	%f3, %f3, %f1
	SWC1	%f3, 1(%r4)
	LWC1	%f3, 2(%r4)
	MUL.s	%f1, %f3, %f1
	SWC1	%f1, 2(%r4)
	LW	%r4, 7(%r1)
	ADD	%r29, %r4, %r2
	LW	%r4, 0(%r29)
	LW	%r7, 12(%r30) # restore1
	LWC1	%f1, 0(%r7)
	SWC1	%f1, 0(%r4)
	LWC1	%f1, 1(%r7)
	SWC1	%f1, 1(%r4)
	LWC1	%f1, 2(%r7)
	SWC1	%f1, 2(%r4)
	J	BEQ_cont.14353
BEQ_else.14352:
	ADDI	%r7, %r0, 0
	ADD	%r29, %r4, %r2
	SW	%r7, 0(%r29)
BEQ_cont.14353:
	LA	%r29, l.11151
	LWC1	%f1, 0(%r29)
	LW	%r4, 29(%r30) # restore1
	LW	%r7, 12(%r30) # restore1
	SWC1	%f1, 38(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 40(%r30) # save link register
	ADDI	%r30, %r30, 41
	JAL	veciprod.2702
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 38(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 29(%r30) # restore1
	LW	%r2, 12(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30) # save link register
	ADDI	%r30, %r30, 41
	JAL	vecaccum.2710
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 37(%r30) # restore1
	LW	%r2, 7(%r1)
	LWC1	%f1, 1(%r2)
	LWC1	%f2, 26(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	ADDI	%r2, %r0, 0
	LW	%r3, 11(%r30) # restore1
	LW	%r3, 0(%r3)
	LW	%r26, 10(%r30) # restore1
	SWC1	%f1, 40(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14354
	LW	%r1, 12(%r30) # restore1
	LW	%r2, 28(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30) # save link register
	ADDI	%r30, %r30, 43
	JAL	veciprod.2702
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
	LWC1	%f2, 34(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LW	%r1, 29(%r30) # restore1
	LW	%r2, 28(%r30) # restore1
	SWC1	%f1, 42(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30) # save link register
	ADDI	%r30, %r30, 45
	JAL	veciprod.2702
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f2, %f0, %f1
	LWC1	%f1, 42(%r30) # restore2
	LWC1	%f3, 40(%r30) # restore2
	LW	%r26, 9(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14355
BEQ_else.14354:
BEQ_cont.14355:
	LW	%r1, 18(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LW	%r2, 8(%r30) # restore1
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 2(%r2)
	LW	%r2, 4(%r30) # restore1
	LW	%r2, 0(%r2)
	ADDI	%r2, %r2, -1
	LW	%r26, 3(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30) # restore1
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LWC1	%f1, 34(%r30) # restore2
	LWC1	%f2, 40(%r30) # restore2
	LW	%r2, 29(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 44(%r30)
	ADDI	%r30, %r30, 45
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 45
	SUB	%r30, %r30, %r29
	LW	%r29, 44(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11162
	LWC1	%f1, 0(%r29)
	LWC1	%f2, 26(%r30) # restore2
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14356
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14357
BEQ_else.14356:
	ADDI	%r1, %r0, 1
BEQ_cont.14357:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14358
	JR	%r31
BEQ_else.14358:
	LW	%r1, 30(%r30) # restore1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14360
	J	BEQ_cont.14361
BEQ_else.14360:
	ADDI	%r2, %r1, 1
	ADDI	%r3, %r0, -1
	LW	%r4, 31(%r30) # restore1
	ADD	%r29, %r4, %r2
	SW	%r3, 0(%r29)
BEQ_cont.14361:
	LW	%r2, 33(%r30) # restore1
	ADDI	%r27, %r0, 2
	BNE	%r2, %r27, BEQ_else.14362
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LW	%r2, 37(%r30) # restore1
	LW	%r2, 7(%r2)
	LWC1	%f3, 0(%r2)
	SUB.s	%f1, %f1, %f3
	MUL.s	%f1, %f2, %f1
	ADDI	%r1, %r1, 1
	LW	%r2, 32(%r30) # restore1
	LWC1	%f2, 0(%r2)
	LWC1	%f3, 6(%r30) # restore2
	ADD.s	%f2, %f3, %f2
	LW	%r2, 29(%r30) # restore1
	LW	%r3, 14(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14362:
	JR	%r31
BEQ_else.14330:
	JR	%r31
trace_diffuse_ray.3014:
	LW	%r2, 15(%r26)
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
	LA	%r29, l.11097
	LWC1	%f2, 0(%r29)
	SWC1	%f2, 0(%r4)
	ADDI	%r17, %r0, 0
	LW	%r18, 0(%r7)
	SW	%r5, 0(%r30)
	SW	%r16, 1(%r30)
	SWC1	%f1, 2(%r30)
	SW	%r10, 4(%r30)
	SW	%r9, 5(%r30)
	SW	%r6, 6(%r30)
	SW	%r7, 7(%r30)
	SW	%r11, 8(%r30)
	SW	%r2, 9(%r30)
	SW	%r13, 10(%r30)
	SW	%r15, 11(%r30)
	SW	%r14, 12(%r30)
	SW	%r1, 13(%r30)
	SW	%r8, 14(%r30)
	SW	%r12, 15(%r30)
	SW	%r4, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r18, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r1, 0 # args
	ADDI	%r1, %r17, 0 # args
	SW	%r29, 17(%r30)
	ADDI	%r30, %r30, 18
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 16(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LA	%r29, l.10951
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14365
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14366
BEQ_else.14365:
	ADDI	%r1, %r0, 1
BEQ_cont.14366:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14367
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14368
BEQ_else.14367:
	LA	%r29, l.11101
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14369
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14370
BEQ_else.14369:
	ADDI	%r1, %r0, 1
BEQ_cont.14370:
BEQ_cont.14368:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14371
	JR	%r31
BEQ_else.14371:
	LW	%r1, 15(%r30) # restore1
	LW	%r1, 0(%r1)
	LW	%r2, 14(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 13(%r30) # restore1
	LW	%r2, 0(%r2)
	LW	%r3, 1(%r1)
	SW	%r1, 17(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r3, %r27, BEQ_else.14373
	LW	%r26, 12(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14374
BEQ_else.14373:
	ADDI	%r27, %r0, 2
	BNE	%r3, %r27, BEQ_else.14375
	LW	%r26, 11(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14376
BEQ_else.14375:
	LW	%r26, 10(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14376:
BEQ_cont.14374:
	LW	%r1, 17(%r30) # restore1
	LW	%r2, 8(%r30) # restore1
	LW	%r26, 9(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r2, 0(%r2)
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30)
	ADDI	%r30, %r30, 19
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14377
	LW	%r1, 5(%r30) # restore1
	LW	%r2, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 18(%r30) # save link register
	ADDI	%r30, %r30, 19
	JAL	veciprod.2702
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f2, %f1
	BNE	%r27, %r0, BEQ_else.14378
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14379
BEQ_else.14378:
	ADDI	%r1, %r0, 1
BEQ_cont.14379:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14380
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	J	BEQ_cont.14381
BEQ_else.14380:
BEQ_cont.14381:
	LWC1	%f2, 2(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 17(%r30) # restore1
	LW	%r1, 7(%r1)
	LWC1	%f2, 0(%r1)
	MUL.s	%f1, %f1, %f2
	LW	%r1, 1(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	J	vecaccum.2710
BEQ_else.14377:
	JR	%r31
iter_trace_diffuse_rays.3017:
	LW	%r5, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.14383
	ADD	%r29, %r1, %r4
	LW	%r6, 0(%r29)
	LW	%r6, 0(%r6)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r4, 4(%r30)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	veciprod.2702
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14384
	ADDI	%r1, %r0, 0
	J	BEQ_cont.14385
BEQ_else.14384:
	ADDI	%r1, %r0, 1
BEQ_cont.14385:
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14386
	LW	%r1, 4(%r30) # restore1
	LW	%r2, 5(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LA	%r29, l.11185
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r26, 3(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14387
BEQ_else.14386:
	LW	%r1, 4(%r30) # restore1
	ADDI	%r2, %r1, 1
	LW	%r3, 5(%r30) # restore1
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	LA	%r29, l.11183
	LWC1	%f2, 0(%r29)
	DIV.s	%f1, %f1, %f2
	LW	%r26, 3(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 6(%r30)
	ADDI	%r30, %r30, 7
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14387:
	LW	%r1, 4(%r30) # restore1
	ADDI	%r4, %r1, -2
	LW	%r1, 5(%r30) # restore1
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 2(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14383:
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
	BNE	%r1, %r27, BEQ_else.14389
	J	BEQ_cont.14390
BEQ_else.14389:
	LW	%r7, 0(%r6)
	SW	%r7, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	ADDI	%r26, %r4, 0 # args
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14390:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r27, %r0, 1
	BNE	%r1, %r27, BEQ_else.14391
	J	BEQ_cont.14392
BEQ_else.14391:
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 1(%r2)
	LW	%r4, 2(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	SW	%r3, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 7(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14392:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r27, %r0, 2
	BNE	%r1, %r27, BEQ_else.14393
	J	BEQ_cont.14394
BEQ_else.14393:
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 2(%r2)
	LW	%r4, 2(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	SW	%r3, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 8(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14394:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r27, %r0, 3
	BNE	%r1, %r27, BEQ_else.14395
	J	BEQ_cont.14396
BEQ_else.14395:
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 3(%r2)
	LW	%r4, 2(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	SW	%r3, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 9(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14396:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r27, %r0, 4
	BNE	%r1, %r27, BEQ_else.14397
	JR	%r31
BEQ_else.14397:
	LW	%r1, 4(%r30) # restore1
	LW	%r1, 4(%r1)
	LW	%r2, 2(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	SW	%r1, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 11(%r30)
	ADDI	%r30, %r30, 12
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 10(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
calc_diffuse_using_1point.3030:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	LW	%r6, 5(%r1)
	LW	%r7, 7(%r1)
	LW	%r8, 1(%r1)
	LW	%r9, 4(%r1)
	ADD	%r29, %r6, %r2
	LW	%r6, 0(%r29)
	LWC1	%f1, 0(%r6)
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r6)
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r6)
	SWC1	%f1, 2(%r5)
	LW	%r1, 6(%r1)
	LW	%r1, 0(%r1)
	ADD	%r29, %r7, %r2
	LW	%r6, 0(%r29)
	ADD	%r29, %r8, %r2
	LW	%r7, 0(%r29)
	SW	%r5, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r2, 2(%r30)
	SW	%r9, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r6, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r7, 0 # args
	SW	%r29, 4(%r30)
	ADDI	%r30, %r30, 5
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30) # restore1
	LW	%r2, 3(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r1, 1(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	J	vecaccumv.2723
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
	SW	%r6, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r4, 3(%r30)
	SW	%r10, 4(%r30)
	SW	%r7, 5(%r30)
	SW	%r5, 6(%r30)
	SW	%r9, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	vecadd.2714
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 7(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	vecadd.2714
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 4(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	vecadd.2714
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 3(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 5(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	vecadd.2714
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30) # restore1
	LW	%r2, 2(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 4(%r1)
	LW	%r2, 6(%r30) # restore1
	ADD	%r29, %r1, %r2
	LW	%r2, 0(%r29)
	LW	%r1, 0(%r30) # restore1
	LW	%r3, 5(%r30) # restore1
	J	vecaccumv.2723
do_without_neighbors.3039:
	LW	%r3, 4(%r26)
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.14399
	LW	%r7, 2(%r1)
	ADD	%r29, %r7, %r2
	LW	%r7, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r7, %r27
	BNE	%r27, %r0, BEQ_else.14400
	LW	%r7, 3(%r1)
	ADD	%r29, %r7, %r2
	LW	%r7, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r6, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r2, 3(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.14401
	J	BEQ_cont.14402
BEQ_else.14401:
	LW	%r7, 5(%r1)
	LW	%r8, 7(%r1)
	LW	%r9, 1(%r1)
	LW	%r10, 4(%r1)
	ADD	%r29, %r7, %r2
	LW	%r7, 0(%r29)
	LWC1	%f1, 0(%r7)
	SWC1	%f1, 0(%r5)
	LWC1	%f1, 1(%r7)
	SWC1	%f1, 1(%r5)
	LWC1	%f1, 2(%r7)
	SWC1	%f1, 2(%r5)
	LW	%r7, 6(%r1)
	LW	%r7, 0(%r7)
	ADD	%r29, %r8, %r2
	LW	%r8, 0(%r29)
	ADD	%r29, %r9, %r2
	LW	%r9, 0(%r29)
	SW	%r5, 4(%r30)
	SW	%r4, 5(%r30)
	SW	%r10, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r8, 0 # args
	ADDI	%r1, %r7, 0 # args
	ADDI	%r26, %r3, 0 # args
	ADDI	%r3, %r9, 0 # args
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30) # restore1
	LW	%r2, 6(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r3, 5(%r30) # restore1
	LW	%r4, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	ADDI	%r3, %r4, 0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	vecaccumv.2723
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14402:
	LW	%r1, 3(%r30) # restore1
	ADDI	%r2, %r1, 1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.14403
	LW	%r1, 2(%r30) # restore1
	LW	%r3, 2(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.14404
	LW	%r3, 3(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r2, 7(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.14405
	J	BEQ_cont.14406
BEQ_else.14405:
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14406:
	LW	%r1, 7(%r30) # restore1
	ADDI	%r2, %r1, 1
	LW	%r1, 2(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14404:
	JR	%r31
BEQ_else.14403:
	JR	%r31
BEQ_else.14400:
	JR	%r31
BEQ_else.14399:
	JR	%r31
neighbors_are_available.3049:
	ADD	%r29, %r3, %r1
	LW	%r6, 0(%r29)
	LW	%r6, 2(%r6)
	ADD	%r29, %r6, %r5
	LW	%r6, 0(%r29)
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	LW	%r2, 2(%r2)
	ADD	%r29, %r2, %r5
	LW	%r2, 0(%r29)
	BNE	%r2, %r6, BEQ_else.14411
	ADD	%r29, %r4, %r1
	LW	%r2, 0(%r29)
	LW	%r2, 2(%r2)
	ADD	%r29, %r2, %r5
	LW	%r2, 0(%r29)
	BNE	%r2, %r6, BEQ_else.14412
	ADDI	%r2, %r1, -1
	ADD	%r29, %r3, %r2
	LW	%r2, 0(%r29)
	LW	%r2, 2(%r2)
	ADD	%r29, %r2, %r5
	LW	%r2, 0(%r29)
	BNE	%r2, %r6, BEQ_else.14413
	ADDI	%r1, %r1, 1
	ADD	%r29, %r3, %r1
	LW	%r1, 0(%r29)
	LW	%r1, 2(%r1)
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	BNE	%r1, %r6, BEQ_else.14414
	ADDI	%r1, %r0, 1
	JR	%r31
BEQ_else.14414:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14413:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14412:
	ADDI	%r1, %r0, 0
	JR	%r31
BEQ_else.14411:
	ADDI	%r1, %r0, 0
	JR	%r31
try_exploit_neighbors.3055:
	LW	%r7, 3(%r26)
	LW	%r8, 2(%r26)
	LW	%r9, 1(%r26)
	ADD	%r29, %r4, %r1
	LW	%r10, 0(%r29)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r6
	BNE	%r27, %r0, BEQ_else.14415
	LW	%r11, 2(%r10)
	ADD	%r29, %r11, %r6
	LW	%r11, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r11, %r27
	BNE	%r27, %r0, BEQ_else.14416
	SW	%r2, 0(%r30)
	SW	%r26, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r3, 3(%r30)
	SW	%r8, 4(%r30)
	SW	%r10, 5(%r30)
	SW	%r7, 6(%r30)
	SW	%r9, 7(%r30)
	SW	%r6, 8(%r30)
	SW	%r1, 9(%r30)
	SW	%r4, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	ADDI	%r3, %r4, 0 # args
	ADDI	%r4, %r5, 0 # args
	ADDI	%r5, %r6, 0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	neighbors_are_available.3049
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14417
	LW	%r1, 9(%r30) # restore1
	LW	%r2, 10(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 8(%r30) # restore1
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.14418
	LW	%r3, 2(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.14419
	LW	%r3, 3(%r1)
	ADD	%r29, %r3, %r2
	LW	%r3, 0(%r29)
	SW	%r1, 11(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r3, %r27, BEQ_else.14420
	J	BEQ_cont.14421
BEQ_else.14420:
	LW	%r26, 7(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14421:
	LW	%r1, 8(%r30) # restore1
	ADDI	%r2, %r1, 1
	LW	%r1, 11(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14419:
	JR	%r31
BEQ_else.14418:
	JR	%r31
BEQ_else.14417:
	LW	%r1, 5(%r30) # restore1
	LW	%r1, 3(%r1)
	LW	%r5, 8(%r30) # restore1
	ADD	%r29, %r1, %r5
	LW	%r1, 0(%r29)
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14424
	J	BEQ_cont.14425
BEQ_else.14424:
	LW	%r1, 9(%r30) # restore1
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 10(%r30) # restore1
	LW	%r4, 2(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14425:
	LW	%r1, 8(%r30) # restore1
	ADDI	%r6, %r1, 1
	LW	%r1, 9(%r30) # restore1
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 3(%r30) # restore1
	LW	%r4, 10(%r30) # restore1
	LW	%r5, 2(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14416:
	JR	%r31
BEQ_else.14415:
	JR	%r31
write_ppm_header.3062:
	LW	%r1, 1(%r26)
	ADDI	%r2, %r0, 80
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 51
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30) # restore1
	LW	%r2, 0(%r1)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 0(%r30) # restore1
	LW	%r1, 1(%r1)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 255
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	J	min_caml_print_char
pretrace_diffuse_rays.3068:
	LW	%r3, 4(%r26)
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADDI	%r27, %r0, 4
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.14428
	LW	%r7, 2(%r1)
	ADD	%r29, %r7, %r2
	LW	%r7, 0(%r29)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r7, %r27
	BNE	%r27, %r0, BEQ_else.14429
	LW	%r7, 3(%r1)
	ADD	%r29, %r7, %r2
	LW	%r7, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r7, %r27, BEQ_else.14430
	J	BEQ_cont.14431
BEQ_else.14430:
	LW	%r7, 6(%r1)
	LW	%r7, 0(%r7)
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SWC1	%f1, 0(%r6)
	SWC1	%f1, 1(%r6)
	SWC1	%f1, 2(%r6)
	LW	%r8, 7(%r1)
	LW	%r9, 1(%r1)
	ADD	%r29, %r5, %r7
	LW	%r5, 0(%r29)
	ADD	%r29, %r8, %r2
	LW	%r7, 0(%r29)
	ADD	%r29, %r9, %r2
	LW	%r8, 0(%r29)
	SW	%r6, 2(%r30)
	SW	%r1, 3(%r30)
	SW	%r8, 4(%r30)
	SW	%r7, 5(%r30)
	SW	%r5, 6(%r30)
	SW	%r4, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r8, 0 # args
	ADDI	%r26, %r3, 0 # args
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r4, %r0, 118
	LW	%r1, 6(%r30) # restore1
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	LW	%r26, 7(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 8(%r30)
	ADDI	%r30, %r30, 9
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30) # restore1
	LW	%r2, 5(%r1)
	LW	%r3, 1(%r30) # restore1
	ADD	%r29, %r2, %r3
	LW	%r2, 0(%r29)
	LW	%r4, 2(%r30) # restore1
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r2)
BEQ_cont.14431:
	LW	%r2, 1(%r30) # restore1
	ADDI	%r2, %r2, 1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14429:
	JR	%r31
BEQ_else.14428:
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
	BNE	%r27, %r0, BEQ_else.14434
	LWC1	%f4, 0(%r8)
	LW	%r8, 0(%r12)
	SUB	%r8, %r2, %r8
	SW	%r26, 0(%r30)
	SW	%r11, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r5, 3(%r30)
	SW	%r2, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r6, 6(%r30)
	SW	%r4, 7(%r30)
	SW	%r9, 8(%r30)
	SWC1	%f3, 10(%r30)
	SWC1	%f2, 12(%r30)
	SW	%r10, 14(%r30)
	SWC1	%f1, 16(%r30)
	SW	%r7, 18(%r30)
	SWC1	%f4, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r8, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 20(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 18(%r30) # restore1
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f3, 16(%r30) # restore2
	ADD.s	%f2, %f2, %f3
	LW	%r2, 14(%r30) # restore1
	SWC1	%f2, 0(%r2)
	LWC1	%f2, 1(%r1)
	MUL.s	%f2, %f1, %f2
	LWC1	%f4, 12(%r30) # restore2
	ADD.s	%f2, %f2, %f4
	SWC1	%f2, 1(%r2)
	LWC1	%f2, 2(%r1)
	MUL.s	%f1, %f1, %f2
	LWC1	%f2, 10(%r30) # restore2
	ADD.s	%f1, %f1, %f2
	SWC1	%f1, 2(%r2)
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	vecunit_sgn.2699
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	LW	%r1, 8(%r30) # restore1
	SWC1	%f1, 0(%r1)
	SWC1	%f1, 1(%r1)
	SWC1	%f1, 2(%r1)
	LW	%r2, 7(%r30) # restore1
	LWC1	%f1, 0(%r2)
	LW	%r3, 6(%r30) # restore1
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r2)
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r2)
	SWC1	%f1, 2(%r3)
	ADDI	%r2, %r0, 0
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LW	%r3, 4(%r30) # restore1
	LW	%r4, 5(%r30) # restore1
	ADD	%r29, %r4, %r3
	LW	%r5, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LW	%r6, 14(%r30) # restore1
	LW	%r26, 3(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0 # args
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r6, 0 # args
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30) # restore1
	LW	%r2, 5(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 0(%r3)
	LW	%r4, 8(%r30) # restore1
	LWC1	%f1, 0(%r4)
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 1(%r4)
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 2(%r4)
	SWC1	%f1, 2(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r3, 6(%r3)
	LW	%r4, 2(%r30) # restore1
	SW	%r4, 0(%r3)
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	ADDI	%r5, %r0, 0
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 4(%r30) # restore1
	ADDI	%r2, %r1, -1
	LW	%r1, 2(%r30) # restore1
	ADDI	%r1, %r1, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14438
	ADDI	%r3, %r1, -5
	J	BEQ_cont.14439
BEQ_else.14438:
	ADDI	%r3, %r1, 0
BEQ_cont.14439:
	LWC1	%f1, 16(%r30) # restore2
	LWC1	%f2, 12(%r30) # restore2
	LWC1	%f3, 10(%r30) # restore2
	LW	%r1, 5(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14434:
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
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 6(%r30) # restore2
	MUL.s	%f1, %f2, %f1
	LW	%r1, 5(%r30) # restore1
	LWC1	%f2, 0(%r1)
	MUL.s	%f2, %f1, %f2
	LW	%r2, 4(%r30) # restore1
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
	LW	%r1, 3(%r30) # restore1
	LW	%r1, 0(%r1)
	ADDI	%r2, %r1, -1
	LW	%r1, 1(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 2(%r30) # restore1
	ADD.s	%f31, %f3, %f0 # args
	ADD.s	%f3, %f1, %f0 # args
	ADD.s	%f1, %f2, %f0 # args
	ADD.s	%f2, %f31, %f0 # args
	LW	%r25, 0(%r26)
	JR	%r25
scan_pixel.3082:
	LW	%r6, 6(%r26)
	LW	%r7, 5(%r26)
	LW	%r8, 4(%r26)
	LW	%r9, 3(%r26)
	LW	%r10, 2(%r26)
	LW	%r11, 1(%r26)
	LW	%r12, 0(%r9)
	SLT	%r27, %r1, %r12
	BNE	%r27, %r0, BEQ_else.14441
	JR	%r31
BEQ_else.14441:
	ADD	%r29, %r4, %r1
	LW	%r12, 0(%r29)
	LW	%r12, 0(%r12)
	LWC1	%f1, 0(%r12)
	SWC1	%f1, 0(%r7)
	LWC1	%f1, 1(%r12)
	SWC1	%f1, 1(%r7)
	LWC1	%f1, 2(%r12)
	SWC1	%f1, 2(%r7)
	LW	%r12, 1(%r9)
	ADDI	%r13, %r2, 1
	SLT	%r27, %r13, %r12
	BNE	%r27, %r0, BEQ_else.14443
	ADDI	%r9, %r0, 0
	J	BEQ_cont.14444
BEQ_else.14443:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r2
	BNE	%r27, %r0, BEQ_else.14445
	ADDI	%r9, %r0, 0
	J	BEQ_cont.14446
BEQ_else.14445:
	LW	%r9, 0(%r9)
	ADDI	%r12, %r1, 1
	SLT	%r27, %r12, %r9
	BNE	%r27, %r0, BEQ_else.14447
	ADDI	%r9, %r0, 0
	J	BEQ_cont.14448
BEQ_else.14447:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.14449
	ADDI	%r9, %r0, 0
	J	BEQ_cont.14450
BEQ_else.14449:
	ADDI	%r9, %r0, 1
BEQ_cont.14450:
BEQ_cont.14448:
BEQ_cont.14446:
BEQ_cont.14444:
	SW	%r5, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r26, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r8, 6(%r30)
	SW	%r7, 7(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r9, %r27, BEQ_else.14451
	ADD	%r29, %r4, %r1
	LW	%r6, 0(%r29)
	ADDI	%r9, %r0, 0
	LW	%r12, 2(%r6)
	LW	%r12, 0(%r12)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r12, %r27
	BNE	%r27, %r0, BEQ_else.14453
	LW	%r12, 3(%r6)
	LW	%r12, 0(%r12)
	SW	%r6, 8(%r30)
	SW	%r10, 9(%r30)
	ADDI	%r27, %r0, 0
	BNE	%r12, %r27, BEQ_else.14455
	J	BEQ_cont.14456
BEQ_else.14455:
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r9, 0 # args
	ADDI	%r1, %r6, 0 # args
	ADDI	%r26, %r11, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14456:
	ADDI	%r2, %r0, 1
	LW	%r1, 8(%r30) # restore1
	LW	%r26, 9(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14454
BEQ_else.14453:
BEQ_cont.14454:
	J	BEQ_cont.14452
BEQ_else.14451:
	ADDI	%r9, %r0, 0
	ADDI	%r29, %r31, 0
	ADDI	%r26, %r6, 0 # args
	ADDI	%r6, %r9, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14452:
	LW	%r1, 7(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.14457
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14459
	J	BEQ_cont.14460
BEQ_else.14459:
	ADDI	%r1, %r0, 0
BEQ_cont.14460:
	J	BEQ_cont.14458
BEQ_else.14457:
	ADDI	%r1, %r0, 255
BEQ_cont.14458:
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30) # restore1
	LWC1	%f1, 1(%r1)
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.14461
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14463
	J	BEQ_cont.14464
BEQ_else.14463:
	ADDI	%r1, %r0, 0
BEQ_cont.14464:
	J	BEQ_cont.14462
BEQ_else.14461:
	ADDI	%r1, %r0, 255
BEQ_cont.14462:
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 32
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 7(%r30) # restore1
	LWC1	%f1, 2(%r1)
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 255
	SLT	%r27, %r27, %r1
	BNE	%r27, %r0, BEQ_else.14465
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14467
	J	BEQ_cont.14468
BEQ_else.14467:
	ADDI	%r1, %r0, 0
BEQ_cont.14468:
	J	BEQ_cont.14466
BEQ_else.14465:
	ADDI	%r1, %r0, 255
BEQ_cont.14466:
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_print_int
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 10
	ADDI	%r29, %r31, 0
	SW	%r29, 10(%r30) # save link register
	ADDI	%r30, %r30, 11
	JAL	min_caml_print_char
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r4, 1(%r30) # restore1
	LW	%r5, 0(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
scan_line.3088:
	LW	%r6, 3(%r26)
	LW	%r7, 2(%r26)
	LW	%r8, 1(%r26)
	LW	%r9, 1(%r8)
	SLT	%r27, %r1, %r9
	BNE	%r27, %r0, BEQ_else.14469
	JR	%r31
BEQ_else.14469:
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
	BNE	%r27, %r0, BEQ_else.14471
	J	BEQ_cont.14472
BEQ_else.14471:
	ADDI	%r8, %r1, 1
	ADDI	%r29, %r31, 0
	ADDI	%r3, %r5, 0 # args
	ADDI	%r2, %r8, 0 # args
	ADDI	%r1, %r4, 0 # args
	ADDI	%r26, %r7, 0 # args
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14472:
	ADDI	%r1, %r0, 0
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	LW	%r4, 3(%r30) # restore1
	LW	%r5, 2(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, 1
	LW	%r2, 1(%r30) # restore1
	ADDI	%r2, %r2, 2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14473
	ADDI	%r5, %r2, -5
	J	BEQ_cont.14474
BEQ_else.14473:
	ADDI	%r5, %r2, 0
BEQ_cont.14474:
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r4, 4(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
create_float5x3array.3094:
	ADDI	%r1, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30) # save link register
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30) # save link register
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30) # restore1
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30) # restore1
	SW	%r1, 2(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30) # restore1
	SW	%r1, 3(%r2)
	ADDI	%r1, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
	ADDI	%r30, %r30, 2
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 2
	SUB	%r30, %r30, %r29
	LW	%r29, 1(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30) # restore1
	SW	%r1, 4(%r2)
	ADDI	%r1, %r2, 0
	JR	%r31
create_pixel.3096:
	ADDI	%r1, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30) # save link register
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 1(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 2(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	create_float5x3array.3094
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r1, 7(%r2)
	LW	%r1, 6(%r30) # restore1
	SW	%r1, 6(%r2)
	LW	%r1, 5(%r30) # restore1
	SW	%r1, 5(%r2)
	LW	%r1, 4(%r30) # restore1
	SW	%r1, 4(%r2)
	LW	%r1, 3(%r30) # restore1
	SW	%r1, 3(%r2)
	LW	%r1, 2(%r30) # restore1
	SW	%r1, 2(%r2)
	LW	%r1, 1(%r30) # restore1
	SW	%r1, 1(%r2)
	LW	%r1, 0(%r30) # restore1
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	JR	%r31
init_line_elements.3098:
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14475
	SW	%r2, 0(%r30)
	SW	%r1, 1(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 0(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14476
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14477
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14478
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 4(%r30) # restore1
	LW	%r3, 1(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r1, %r3, 0 # args
	J	init_line_elements.3098
BEQ_else.14478:
	ADDI	%r1, %r3, 0
	JR	%r31
BEQ_else.14477:
	ADDI	%r1, %r3, 0
	JR	%r31
BEQ_else.14476:
	ADDI	%r1, %r3, 0
	JR	%r31
BEQ_else.14475:
	JR	%r31
calc_sqrt.6353.6791:
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14479
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14480
	DIV.s	%f3, %f1, %f2
	ADD.s	%f3, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f3, %f3, %f4
	C.eq.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14481
	DIV.s	%f2, %f1, %f3
	ADD.s	%f2, %f3, %f2
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f2, %f2, %f4
	C.eq.s	%r27, %f2, %f3
	BNE	%r27, %r0, BEQ_else.14482
	J	calc_sqrt.6353.6791
BEQ_else.14482:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14481:
	ADD.s	%f1, %f2, %f0
	JR	%r31
BEQ_else.14480:
	ADD.s	%f1, %f3, %f0
	JR	%r31
BEQ_else.14479:
	ADD.s	%f1, %f2, %f0
	JR	%r31
calc_dirvec.3108:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 5
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14483
	MUL.s	%f3, %f1, %f1
	MUL.s	%f4, %f2, %f2
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	ADD.s	%f3, %f3, %f4
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r4, 2(%r30)
	SWC1	%f2, 4(%r30)
	SWC1	%f1, 6(%r30)
	C.lt.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14485
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	C.eq.s	%r27, %f3, %f4
	BNE	%r27, %r0, BEQ_else.14487
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	DIV.s	%f4, %f3, %f4
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.14489
	DIV.s	%f4, %f3, %f5
	ADD.s	%f4, %f5, %f4
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f4, %f4, %f6
	C.eq.s	%r27, %f4, %f5
	BNE	%r27, %r0, BEQ_else.14491
	DIV.s	%f5, %f3, %f4
	ADD.s	%f5, %f4, %f5
	LA	%r29, l.10551
	LWC1	%f6, 0(%r29)
	DIV.s	%f5, %f5, %f6
	C.eq.s	%r27, %f5, %f4
	BNE	%r27, %r0, BEQ_else.14493
	ADDI	%r29, %r31, 0
	ADD.s	%f2, %f5, %f0 # args
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	calc_sqrt.6353.6791
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14494
BEQ_else.14493:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14494:
	J	BEQ_cont.14492
BEQ_else.14491:
	ADD.s	%f1, %f5, %f0
BEQ_cont.14492:
	J	BEQ_cont.14490
BEQ_else.14489:
	ADD.s	%f1, %f4, %f0
BEQ_cont.14490:
	J	BEQ_cont.14488
BEQ_else.14487:
	ADD.s	%f1, %f3, %f0
BEQ_cont.14488:
	J	BEQ_cont.14486
BEQ_else.14485:
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
BEQ_cont.14486:
	LWC1	%f2, 6(%r30) # restore2
	DIV.s	%f2, %f2, %f1
	LWC1	%f3, 4(%r30) # restore2
	DIV.s	%f3, %f3, %f1
	LA	%r29, l.10549
	LWC1	%f4, 0(%r29)
	DIV.s	%f1, %f4, %f1
	LW	%r1, 1(%r30) # restore1
	LW	%r2, 2(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r1, 0(%r29)
	LW	%r2, 0(%r30) # restore1
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
BEQ_else.14483:
	MUL.s	%f1, %f2, %f2
	LA	%r29, l.11162
	LWC1	%f2, 0(%r29)
	ADD.s	%f1, %f1, %f2
	SW	%r3, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r26, 8(%r30)
	SWC1	%f4, 10(%r30)
	SW	%r1, 12(%r30)
	SWC1	%f3, 14(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 16(%r30) # save link register
	ADDI	%r30, %r30, 17
	JAL	sqrt.2624
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 18(%r30) # save link register
	ADDI	%r30, %r30, 19
	JAL	atan.2634
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 14(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 18(%r30)
	C.lt.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.14498
	ADDI	%r29, %r31, 0
	SW	%r29, 20(%r30) # save link register
	ADDI	%r30, %r30, 21
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14499
BEQ_else.14498:
	SUB.s	%f3, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 20(%r30) # save link register
	ADDI	%r30, %r30, 21
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 21
	SUB	%r30, %r30, %r29
	LW	%r29, 20(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.14499:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 18(%r30) # restore2
	SWC1	%f1, 20(%r30)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14500
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14501
BEQ_else.14500:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14501:
	LWC1	%f2, 20(%r30) # restore2
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 16(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LW	%r1, 12(%r30) # restore1
	ADDI	%r1, %r1, 1
	MUL.s	%f2, %f1, %f1
	LA	%r29, l.11162
	LWC1	%f3, 0(%r29)
	ADD.s	%f2, %f2, %f3
	SWC1	%f1, 22(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	sqrt.2624
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	DIV.s	%f2, %f2, %f1
	SWC1	%f1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 28(%r30) # save link register
	ADDI	%r30, %r30, 29
	JAL	atan.2634
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 10(%r30) # restore2
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SWC1	%f1, 28(%r30)
	C.lt.s	%r27, %f1, %f3
	BNE	%r27, %r0, BEQ_else.14503
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30) # save link register
	ADDI	%r30, %r30, 31
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14504
BEQ_else.14503:
	SUB.s	%f3, %f0, %f1
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 30(%r30) # save link register
	ADDI	%r30, %r30, 31
	JAL	mysin_step1.2628
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	SUB.s	%f1, %f0, %f1
BEQ_cont.14504:
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f3, 28(%r30) # restore2
	SWC1	%f1, 30(%r30)
	C.lt.s	%r27, %f3, %f2
	BNE	%r27, %r0, BEQ_else.14505
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 32(%r30) # save link register
	ADDI	%r30, %r30, 33
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14506
BEQ_else.14505:
	SUB.s	%f2, %f0, %f3
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f2, %f0 # args
	SW	%r29, 32(%r30) # save link register
	ADDI	%r30, %r30, 33
	JAL	mycos_step1.2626
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14506:
	LWC1	%f2, 30(%r30) # restore2
	DIV.s	%f1, %f2, %f1
	LWC1	%f2, 26(%r30) # restore2
	MUL.s	%f2, %f1, %f2
	LWC1	%f1, 22(%r30) # restore2
	LWC1	%f3, 14(%r30) # restore2
	LWC1	%f4, 10(%r30) # restore2
	LW	%r1, 24(%r30) # restore1
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 0(%r30) # restore1
	LW	%r26, 8(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
calc_dirvecs.3116:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14507
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SWC1	%f1, 2(%r30)
	SW	%r3, 4(%r30)
	SW	%r2, 5(%r30)
	SW	%r4, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11366
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.11367
	LWC1	%f2, 0(%r29)
	SUB.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LWC1	%f4, 2(%r30) # restore2
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 4(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11366
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.11162
	LWC1	%f2, 0(%r29)
	ADD.s	%f3, %f1, %f2
	ADDI	%r1, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	LA	%r29, l.10550
	LWC1	%f2, 0(%r29)
	LW	%r2, 4(%r30) # restore1
	ADDI	%r3, %r2, 2
	LWC1	%f4, 2(%r30) # restore2
	LW	%r4, 5(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r4, 0 # args
	SW	%r29, 7(%r30)
	ADDI	%r30, %r30, 8
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30) # restore1
	ADDI	%r1, %r1, -1
	LW	%r2, 5(%r30) # restore1
	ADDI	%r2, %r2, 1
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14508
	ADDI	%r2, %r2, -5
	J	BEQ_cont.14509
BEQ_else.14508:
BEQ_cont.14509:
	LWC1	%f1, 2(%r30) # restore2
	LW	%r3, 4(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14507:
	JR	%r31
calc_dirvec_rows.3121:
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14511
	SW	%r26, 0(%r30)
	SW	%r1, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r2, 3(%r30)
	SW	%r4, 4(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.11366
	LWC1	%f2, 0(%r29)
	MUL.s	%f1, %f1, %f2
	LA	%r29, l.11367
	LWC1	%f2, 0(%r29)
	SUB.s	%f1, %f1, %f2
	ADDI	%r1, %r0, 4
	LW	%r2, 3(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 5(%r30)
	ADDI	%r30, %r30, 6
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 1(%r30) # restore1
	ADDI	%r1, %r1, -1
	LW	%r2, 3(%r30) # restore1
	ADDI	%r2, %r2, 2
	ADDI	%r27, %r0, 5
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14512
	ADDI	%r2, %r2, -5
	J	BEQ_cont.14513
BEQ_else.14512:
BEQ_cont.14513:
	LW	%r3, 2(%r30) # restore1
	ADDI	%r3, %r3, 4
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14511:
	JR	%r31
create_dirvec_elements.3127:
	LW	%r3, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14515
	ADDI	%r4, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r2, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r3, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 4(%r30) # restore1
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14516
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 3(%r30) # restore1
	LW	%r1, 0(%r1)
	SW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 6(%r30) # restore1
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 5(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	LW	%r26, 0(%r30) # restore1
	ADDI	%r1, %r3, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14516:
	JR	%r31
BEQ_else.14515:
	JR	%r31
create_dirvecs.3130:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14519
	ADDI	%r5, %r0, 120
	ADDI	%r6, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r26, 0(%r30)
	SW	%r4, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r3, 3(%r30)
	SW	%r5, 4(%r30)
	SW	%r2, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r6, 0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 6(%r30) # restore1
	SW	%r1, 0(%r2)
	LW	%r1, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 7(%r30) # save link register
	ADDI	%r30, %r30, 8
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 8
	SUB	%r30, %r30, %r29
	LW	%r29, 7(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 2(%r30) # restore1
	LW	%r3, 3(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	ADDI	%r4, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 7(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 8(%r30) # save link register
	ADDI	%r30, %r30, 9
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 9
	SUB	%r30, %r30, %r29
	LW	%r29, 8(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 8(%r30) # restore1
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	LW	%r2, 7(%r30) # restore1
	SW	%r1, 118(%r2)
	ADDI	%r1, %r0, 117
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14520
	ADDI	%r2, %r0, 120
	ADDI	%r3, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 9(%r30)
	SW	%r2, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 5(%r30) # restore1
	LW	%r1, 0(%r1)
	SW	%r2, 11(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 11(%r30) # restore1
	SW	%r1, 0(%r2)
	LW	%r1, 10(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 12(%r30) # save link register
	ADDI	%r30, %r30, 13
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 9(%r30) # restore1
	LW	%r3, 3(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADD	%r29, %r3, %r2
	LW	%r1, 0(%r29)
	ADDI	%r3, %r0, 118
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 12(%r30)
	ADDI	%r30, %r30, 13
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 13
	SUB	%r30, %r30, %r29
	LW	%r29, 12(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30) # restore1
	ADDI	%r1, %r1, -1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14520:
	JR	%r31
BEQ_else.14519:
	JR	%r31
init_dirvec_constants.3132:
	LW	%r3, 3(%r26)
	LW	%r4, 2(%r26)
	LW	%r5, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14523
	ADD	%r29, %r1, %r2
	LW	%r6, 0(%r29)
	LW	%r7, 0(%r4)
	ADDI	%r7, %r7, -1
	SW	%r26, 0(%r30)
	SW	%r5, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r4, 3(%r30)
	SW	%r1, 4(%r30)
	SW	%r2, 5(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r7, %r27
	BNE	%r27, %r0, BEQ_else.14524
	ADD	%r29, %r3, %r7
	LW	%r8, 0(%r29)
	LW	%r9, 1(%r6)
	LW	%r10, 0(%r6)
	LW	%r11, 1(%r8)
	SW	%r6, 6(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r11, %r27, BEQ_else.14526
	SW	%r7, 7(%r30)
	SW	%r9, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r8, 0 # args
	ADDI	%r1, %r10, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14527
BEQ_else.14526:
	ADDI	%r27, %r0, 2
	BNE	%r11, %r27, BEQ_else.14528
	SW	%r7, 7(%r30)
	SW	%r9, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r8, 0 # args
	ADDI	%r1, %r10, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14529
BEQ_else.14528:
	SW	%r7, 7(%r30)
	SW	%r9, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r8, 0 # args
	ADDI	%r1, %r10, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14529:
BEQ_cont.14527:
	ADDI	%r2, %r2, -1
	LW	%r1, 6(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14525
BEQ_else.14524:
BEQ_cont.14525:
	LW	%r1, 5(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14530
	LW	%r2, 4(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r3, 0(%r29)
	LW	%r4, 3(%r30) # restore1
	LW	%r4, 0(%r4)
	ADDI	%r4, %r4, -1
	SW	%r1, 9(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.14531
	LW	%r5, 2(%r30) # restore1
	ADD	%r29, %r5, %r4
	LW	%r5, 0(%r29)
	LW	%r6, 1(%r3)
	LW	%r7, 0(%r3)
	LW	%r8, 1(%r5)
	SW	%r3, 10(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r8, %r27, BEQ_else.14533
	SW	%r4, 11(%r30)
	SW	%r6, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r7, 0 # args
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 11(%r30) # restore1
	LW	%r3, 12(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14534
BEQ_else.14533:
	ADDI	%r27, %r0, 2
	BNE	%r8, %r27, BEQ_else.14535
	SW	%r4, 11(%r30)
	SW	%r6, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r7, 0 # args
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 11(%r30) # restore1
	LW	%r3, 12(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14536
BEQ_else.14535:
	SW	%r4, 11(%r30)
	SW	%r6, 12(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r7, 0 # args
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 11(%r30) # restore1
	LW	%r3, 12(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14536:
BEQ_cont.14534:
	ADDI	%r2, %r2, -1
	LW	%r1, 10(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 13(%r30)
	ADDI	%r30, %r30, 14
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14532
BEQ_else.14531:
BEQ_cont.14532:
	LW	%r1, 9(%r30) # restore1
	ADDI	%r2, %r1, -1
	LW	%r1, 4(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14530:
	JR	%r31
BEQ_else.14523:
	JR	%r31
init_vecset_constants.3135:
	LW	%r2, 5(%r26)
	LW	%r3, 4(%r26)
	LW	%r4, 3(%r26)
	LW	%r5, 2(%r26)
	LW	%r6, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14539
	ADD	%r29, %r6, %r1
	LW	%r7, 0(%r29)
	LW	%r8, 119(%r7)
	LW	%r3, 0(%r3)
	ADDI	%r3, %r3, -1
	SW	%r26, 0(%r30)
	SW	%r6, 1(%r30)
	SW	%r1, 2(%r30)
	SW	%r7, 3(%r30)
	SW	%r5, 4(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.14540
	ADD	%r29, %r2, %r3
	LW	%r2, 0(%r29)
	LW	%r9, 1(%r8)
	LW	%r10, 0(%r8)
	LW	%r11, 1(%r2)
	SW	%r8, 5(%r30)
	SW	%r4, 6(%r30)
	ADDI	%r27, %r0, 1
	BNE	%r11, %r27, BEQ_else.14542
	SW	%r3, 7(%r30)
	SW	%r9, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r10, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14543
BEQ_else.14542:
	ADDI	%r27, %r0, 2
	BNE	%r11, %r27, BEQ_else.14544
	SW	%r3, 7(%r30)
	SW	%r9, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r10, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14545
BEQ_else.14544:
	SW	%r3, 7(%r30)
	SW	%r9, 8(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r10, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 7(%r30) # restore1
	LW	%r3, 8(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14545:
BEQ_cont.14543:
	ADDI	%r2, %r2, -1
	LW	%r1, 5(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14541
BEQ_else.14540:
BEQ_cont.14541:
	ADDI	%r2, %r0, 118
	LW	%r1, 3(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30)
	ADDI	%r30, %r30, 10
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 2(%r30) # restore1
	ADDI	%r1, %r1, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14546
	LW	%r2, 1(%r30) # restore1
	ADD	%r29, %r2, %r1
	LW	%r2, 0(%r29)
	ADDI	%r3, %r0, 119
	LW	%r26, 4(%r30) # restore1
	SW	%r1, 9(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 10(%r30)
	ADDI	%r30, %r30, 11
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 11
	SUB	%r30, %r30, %r29
	LW	%r29, 10(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 9(%r30) # restore1
	ADDI	%r1, %r1, -1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14546:
	JR	%r31
BEQ_else.14539:
	JR	%r31
setup_rect_reflection.3146:
	LW	%r3, 6(%r26)
	LW	%r4, 5(%r26)
	LW	%r5, 4(%r26)
	LW	%r6, 3(%r26)
	LW	%r7, 2(%r26)
	LW	%r8, 1(%r26)
	SLL	%r1, %r1, 2
	LW	%r9, 0(%r5)
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LW	%r2, 7(%r2)
	LWC1	%f2, 0(%r2)
	SUB.s	%f1, %f1, %f2
	LWC1	%f2, 0(%r7)
	SUB.s	%f2, %f0, %f2
	LWC1	%f3, 1(%r7)
	SUB.s	%f3, %f0, %f3
	LWC1	%f4, 2(%r7)
	SUB.s	%f4, %f0, %f4
	ADDI	%r2, %r1, 1
	LWC1	%f5, 0(%r7)
	ADDI	%r10, %r0, 3
	LA	%r29, l.10550
	LWC1	%f6, 0(%r29)
	SW	%r5, 0(%r30)
	SWC1	%f2, 2(%r30)
	SW	%r7, 4(%r30)
	SW	%r1, 5(%r30)
	SW	%r9, 6(%r30)
	SW	%r3, 7(%r30)
	SW	%r2, 8(%r30)
	SWC1	%f1, 10(%r30)
	SW	%r8, 12(%r30)
	SW	%r4, 13(%r30)
	SWC1	%f4, 14(%r30)
	SWC1	%f3, 16(%r30)
	SWC1	%f5, 18(%r30)
	SW	%r6, 20(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r10, 0 # args
	ADD.s	%f1, %f6, %f0 # args
	SW	%r29, 21(%r30) # save link register
	ADDI	%r30, %r30, 22
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 22
	SUB	%r30, %r30, %r29
	LW	%r29, 21(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r3, 21(%r30) # restore1
	SW	%r3, 0(%r2)
	LWC1	%f1, 18(%r30) # restore2
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 16(%r30) # restore2
	SWC1	%f1, 1(%r3)
	LWC1	%f2, 14(%r30) # restore2
	SWC1	%f2, 2(%r3)
	LW	%r4, 20(%r30) # restore1
	LW	%r5, 0(%r4)
	ADDI	%r5, %r5, -1
	SW	%r2, 22(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r5, %r27
	BNE	%r27, %r0, BEQ_else.14551
	LW	%r6, 13(%r30) # restore1
	ADD	%r29, %r6, %r5
	LW	%r7, 0(%r29)
	LW	%r8, 1(%r7)
	ADDI	%r27, %r0, 1
	BNE	%r8, %r27, BEQ_else.14553
	SW	%r5, 23(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30) # restore1
	LW	%r3, 24(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14554
BEQ_else.14553:
	ADDI	%r27, %r0, 2
	BNE	%r8, %r27, BEQ_else.14555
	SW	%r5, 23(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30) # restore1
	LW	%r3, 24(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14556
BEQ_else.14555:
	SW	%r5, 23(%r30)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 23(%r30) # restore1
	LW	%r3, 24(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14556:
BEQ_cont.14554:
	ADDI	%r2, %r2, -1
	LW	%r1, 22(%r30) # restore1
	LW	%r26, 12(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 25(%r30)
	ADDI	%r30, %r30, 26
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14552
BEQ_else.14551:
BEQ_cont.14552:
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 10(%r30) # restore2
	SWC1	%f1, 2(%r1)
	LW	%r2, 22(%r30) # restore1
	SW	%r2, 1(%r1)
	LW	%r2, 8(%r30) # restore1
	SW	%r2, 0(%r1)
	LW	%r2, 6(%r30) # restore1
	LW	%r3, 7(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r4, 5(%r30) # restore1
	ADDI	%r5, %r4, 2
	LW	%r6, 4(%r30) # restore1
	LWC1	%f2, 1(%r6)
	ADDI	%r7, %r0, 3
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SW	%r1, 25(%r30)
	SW	%r5, 26(%r30)
	SWC1	%f2, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r7, 0 # args
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 30(%r30) # save link register
	ADDI	%r30, %r30, 31
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 30(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 31(%r30) # save link register
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r3, 30(%r30) # restore1
	SW	%r3, 0(%r2)
	LWC1	%f1, 2(%r30) # restore2
	SWC1	%f1, 0(%r3)
	LWC1	%f2, 28(%r30) # restore2
	SWC1	%f2, 1(%r3)
	LWC1	%f2, 14(%r30) # restore2
	SWC1	%f2, 2(%r3)
	LW	%r4, 20(%r30) # restore1
	LW	%r5, 0(%r4)
	ADDI	%r5, %r5, -1
	SW	%r2, 31(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r5, %r27
	BNE	%r27, %r0, BEQ_else.14558
	LW	%r6, 13(%r30) # restore1
	ADD	%r29, %r6, %r5
	LW	%r7, 0(%r29)
	LW	%r8, 1(%r7)
	ADDI	%r27, %r0, 1
	BNE	%r8, %r27, BEQ_else.14560
	SW	%r5, 32(%r30)
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 34(%r30) # save link register
	ADDI	%r30, %r30, 35
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30) # restore1
	LW	%r3, 33(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14561
BEQ_else.14560:
	ADDI	%r27, %r0, 2
	BNE	%r8, %r27, BEQ_else.14562
	SW	%r5, 32(%r30)
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 34(%r30) # save link register
	ADDI	%r30, %r30, 35
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30) # restore1
	LW	%r3, 33(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14563
BEQ_else.14562:
	SW	%r5, 32(%r30)
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r7, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 34(%r30) # save link register
	ADDI	%r30, %r30, 35
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30) # restore1
	LW	%r3, 33(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14563:
BEQ_cont.14561:
	ADDI	%r2, %r2, -1
	LW	%r1, 31(%r30) # restore1
	LW	%r26, 12(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 34(%r30)
	ADDI	%r30, %r30, 35
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14559
BEQ_else.14558:
BEQ_cont.14559:
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 10(%r30) # restore2
	SWC1	%f1, 2(%r1)
	LW	%r2, 31(%r30) # restore1
	SW	%r2, 1(%r1)
	LW	%r2, 26(%r30) # restore1
	SW	%r2, 0(%r1)
	LW	%r2, 25(%r30) # restore1
	LW	%r3, 7(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 6(%r30) # restore1
	ADDI	%r2, %r1, 2
	LW	%r4, 5(%r30) # restore1
	ADDI	%r4, %r4, 3
	LW	%r5, 4(%r30) # restore1
	LWC1	%f2, 2(%r5)
	ADDI	%r5, %r0, 3
	LA	%r29, l.10550
	LWC1	%f3, 0(%r29)
	SW	%r2, 34(%r30)
	SW	%r4, 35(%r30)
	SWC1	%f2, 36(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r5, 0 # args
	ADD.s	%f1, %f3, %f0 # args
	SW	%r29, 38(%r30) # save link register
	ADDI	%r30, %r30, 39
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 20(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 38(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 39(%r30) # save link register
	ADDI	%r30, %r30, 40
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r3, 38(%r30) # restore1
	SW	%r3, 0(%r2)
	LWC1	%f1, 2(%r30) # restore2
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 16(%r30) # restore2
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 36(%r30) # restore2
	SWC1	%f1, 2(%r3)
	LW	%r4, 20(%r30) # restore1
	LW	%r4, 0(%r4)
	ADDI	%r4, %r4, -1
	SW	%r2, 39(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.14564
	LW	%r5, 13(%r30) # restore1
	ADD	%r29, %r5, %r4
	LW	%r5, 0(%r29)
	LW	%r6, 1(%r5)
	ADDI	%r27, %r0, 1
	BNE	%r6, %r27, BEQ_else.14566
	SW	%r4, 40(%r30)
	SW	%r1, 41(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 42(%r30) # save link register
	ADDI	%r30, %r30, 43
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 40(%r30) # restore1
	LW	%r3, 41(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14567
BEQ_else.14566:
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.14568
	SW	%r4, 40(%r30)
	SW	%r1, 41(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 42(%r30) # save link register
	ADDI	%r30, %r30, 43
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 40(%r30) # restore1
	LW	%r3, 41(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14569
BEQ_else.14568:
	SW	%r4, 40(%r30)
	SW	%r1, 41(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 42(%r30) # save link register
	ADDI	%r30, %r30, 43
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 40(%r30) # restore1
	LW	%r3, 41(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14569:
BEQ_cont.14567:
	ADDI	%r2, %r2, -1
	LW	%r1, 39(%r30) # restore1
	LW	%r26, 12(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 42(%r30)
	ADDI	%r30, %r30, 43
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 43
	SUB	%r30, %r30, %r29
	LW	%r29, 42(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14565
BEQ_else.14564:
BEQ_cont.14565:
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 10(%r30) # restore2
	SWC1	%f1, 2(%r1)
	LW	%r2, 39(%r30) # restore1
	SW	%r2, 1(%r1)
	LW	%r2, 35(%r30) # restore1
	SW	%r2, 0(%r1)
	LW	%r2, 34(%r30) # restore1
	LW	%r3, 7(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	LW	%r1, 6(%r30) # restore1
	ADDI	%r1, %r1, 3
	LW	%r2, 0(%r30) # restore1
	SW	%r1, 0(%r2)
	JR	%r31
setup_surface_reflection.3149:
	LW	%r3, 6(%r26)
	LW	%r4, 5(%r26)
	LW	%r5, 4(%r26)
	LW	%r6, 3(%r26)
	LW	%r7, 2(%r26)
	LW	%r8, 1(%r26)
	SLL	%r1, %r1, 2
	ADDI	%r1, %r1, 1
	LW	%r9, 0(%r5)
	LA	%r29, l.10549
	LWC1	%f1, 0(%r29)
	LW	%r10, 7(%r2)
	LWC1	%f2, 0(%r10)
	SUB.s	%f1, %f1, %f2
	LW	%r10, 4(%r2)
	SW	%r5, 0(%r30)
	SW	%r9, 1(%r30)
	SW	%r3, 2(%r30)
	SW	%r1, 3(%r30)
	SWC1	%f1, 4(%r30)
	SW	%r8, 6(%r30)
	SW	%r4, 7(%r30)
	SW	%r6, 8(%r30)
	SW	%r7, 9(%r30)
	SW	%r2, 10(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r10, 0 # args
	ADDI	%r1, %r7, 0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	veciprod.2702
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	LA	%r29, l.10551
	LWC1	%f2, 0(%r29)
	LW	%r1, 10(%r30) # restore1
	LW	%r2, 4(%r1)
	LWC1	%f3, 0(%r2)
	MUL.s	%f2, %f2, %f3
	MUL.s	%f2, %f2, %f1
	LW	%r2, 9(%r30) # restore1
	LWC1	%f3, 0(%r2)
	SUB.s	%f2, %f2, %f3
	LA	%r29, l.10551
	LWC1	%f3, 0(%r29)
	LW	%r3, 4(%r1)
	LWC1	%f4, 1(%r3)
	MUL.s	%f3, %f3, %f4
	MUL.s	%f3, %f3, %f1
	LWC1	%f4, 1(%r2)
	SUB.s	%f3, %f3, %f4
	LA	%r29, l.10551
	LWC1	%f4, 0(%r29)
	LW	%r1, 4(%r1)
	LWC1	%f5, 2(%r1)
	MUL.s	%f4, %f4, %f5
	MUL.s	%f1, %f4, %f1
	LWC1	%f4, 2(%r2)
	SUB.s	%f1, %f1, %f4
	ADDI	%r1, %r0, 3
	LA	%r29, l.10550
	LWC1	%f4, 0(%r29)
	SWC1	%f1, 12(%r30)
	SWC1	%f3, 14(%r30)
	SWC1	%f2, 16(%r30)
	ADDI	%r29, %r31, 0
	ADD.s	%f1, %f4, %f0 # args
	SW	%r29, 18(%r30) # save link register
	ADDI	%r30, %r30, 19
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30) # restore1
	LW	%r3, 0(%r1)
	SW	%r2, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 19(%r30) # save link register
	ADDI	%r30, %r30, 20
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r3, 18(%r30) # restore1
	SW	%r3, 0(%r2)
	LWC1	%f1, 16(%r30) # restore2
	SWC1	%f1, 0(%r3)
	LWC1	%f1, 14(%r30) # restore2
	SWC1	%f1, 1(%r3)
	LWC1	%f1, 12(%r30) # restore2
	SWC1	%f1, 2(%r3)
	LW	%r4, 8(%r30) # restore1
	LW	%r4, 0(%r4)
	ADDI	%r4, %r4, -1
	SW	%r2, 19(%r30)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r4, %r27
	BNE	%r27, %r0, BEQ_else.14572
	LW	%r5, 7(%r30) # restore1
	ADD	%r29, %r5, %r4
	LW	%r5, 0(%r29)
	LW	%r6, 1(%r5)
	ADDI	%r27, %r0, 1
	BNE	%r6, %r27, BEQ_else.14574
	SW	%r4, 20(%r30)
	SW	%r1, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 21(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14575
BEQ_else.14574:
	ADDI	%r27, %r0, 2
	BNE	%r6, %r27, BEQ_else.14576
	SW	%r4, 20(%r30)
	SW	%r1, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 21(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14577
BEQ_else.14576:
	SW	%r4, 20(%r30)
	SW	%r1, 21(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r5, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 21(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14577:
BEQ_cont.14575:
	ADDI	%r2, %r2, -1
	LW	%r1, 19(%r30) # restore1
	LW	%r26, 6(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 22(%r30)
	ADDI	%r30, %r30, 23
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14573
BEQ_else.14572:
BEQ_cont.14573:
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 3
	LWC1	%f1, 4(%r30) # restore2
	SWC1	%f1, 2(%r1)
	LW	%r2, 19(%r30) # restore1
	SW	%r2, 1(%r1)
	LW	%r2, 3(%r30) # restore1
	SW	%r2, 0(%r1)
	LW	%r2, 1(%r30) # restore1
	LW	%r3, 2(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, 1
	LW	%r2, 0(%r30) # restore1
	SW	%r1, 0(%r2)
	JR	%r31
setup_reflections.3152:
	LW	%r2, 3(%r26)
	LW	%r3, 2(%r26)
	LW	%r4, 1(%r26)
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14579
	ADD	%r29, %r4, %r1
	LW	%r4, 0(%r29)
	LW	%r5, 2(%r4)
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.14580
	LW	%r5, 7(%r4)
	LWC1	%f1, 0(%r5)
	LA	%r29, l.10549
	LWC1	%f2, 0(%r29)
	C.lt.s	%r27, %f1, %f2
	BNE	%r27, %r0, BEQ_else.14581
	ADDI	%r5, %r0, 0
	J	BEQ_cont.14582
BEQ_else.14581:
	ADDI	%r5, %r0, 1
BEQ_cont.14582:
	ADDI	%r27, %r0, 0
	BNE	%r5, %r27, BEQ_else.14583
	JR	%r31
BEQ_else.14583:
	LW	%r5, 1(%r4)
	ADDI	%r27, %r0, 1
	BNE	%r5, %r27, BEQ_else.14585
	ADDI	%r2, %r4, 0 # args
	ADDI	%r26, %r3, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14585:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.14586
	ADDI	%r26, %r2, 0 # args
	ADDI	%r2, %r4, 0 # args
	LW	%r25, 0(%r26)
	JR	%r25
BEQ_else.14586:
	JR	%r31
BEQ_else.14580:
	JR	%r31
BEQ_else.14579:
	JR	%r31
rt.3154:
	LW	%r3, 23(%r26)
	LW	%r4, 22(%r26)
	LW	%r5, 21(%r26)
	LW	%r6, 20(%r26)
	LW	%r7, 19(%r26)
	LW	%r8, 18(%r26)
	LW	%r9, 17(%r26)
	LW	%r10, 16(%r26)
	LW	%r11, 15(%r26)
	LW	%r12, 14(%r26)
	LW	%r13, 13(%r26)
	LW	%r14, 12(%r26)
	LW	%r15, 11(%r26)
	LW	%r16, 10(%r26)
	LW	%r17, 9(%r26)
	LW	%r18, 8(%r26)
	LW	%r19, 7(%r26)
	LW	%r20, 6(%r26)
	LW	%r21, 5(%r26)
	LW	%r22, 4(%r26)
	LW	%r23, 3(%r26)
	LW	%r24, 2(%r26)
	LW	%r25, 1(%r26)
	SW	%r1, 0(%r21)
	SW	%r2, 1(%r21)
	SRA	%r26, %r1, 1
	SW	%r26, 0(%r22)
	SRA	%r2, %r2, 1
	SW	%r2, 1(%r22)
	LA	%r29, l.11507
	LWC1	%f1, 0(%r29)
	SW	%r7, 0(%r30)
	SW	%r13, 1(%r30)
	SW	%r5, 2(%r30)
	SW	%r17, 3(%r30)
	SW	%r19, 4(%r30)
	SW	%r24, 5(%r30)
	SW	%r15, 6(%r30)
	SW	%r4, 7(%r30)
	SW	%r18, 8(%r30)
	SW	%r20, 9(%r30)
	SW	%r25, 10(%r30)
	SW	%r23, 11(%r30)
	SW	%r3, 12(%r30)
	SW	%r14, 13(%r30)
	SW	%r12, 14(%r30)
	SW	%r9, 15(%r30)
	SW	%r16, 16(%r30)
	SW	%r10, 17(%r30)
	SW	%r11, 18(%r30)
	SW	%r8, 19(%r30)
	SW	%r21, 20(%r30)
	SW	%r6, 21(%r30)
	SWC1	%f1, 22(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 24(%r30) # save link register
	ADDI	%r30, %r30, 25
	JAL	min_caml_float_of_int
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	LWC1	%f2, 22(%r30) # restore2
	DIV.s	%f1, %f2, %f1
	LW	%r1, 21(%r30) # restore1
	SWC1	%f1, 0(%r1)
	LW	%r1, 20(%r30) # restore1
	LW	%r2, 0(%r1)
	SW	%r2, 24(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 24(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 0(%r2)
	ADDI	%r3, %r3, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.14590
	SW	%r3, 25(%r30)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 27(%r30) # save link register
	ADDI	%r30, %r30, 28
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 25(%r30) # restore1
	LW	%r3, 26(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14592
	SW	%r1, 27(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 28(%r30) # save link register
	ADDI	%r30, %r30, 29
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 27(%r30) # restore1
	LW	%r3, 26(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 28(%r30) # save link register
	ADDI	%r30, %r30, 29
	JAL	init_line_elements.3098
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14593
BEQ_else.14592:
	ADDI	%r1, %r3, 0
BEQ_cont.14593:
	J	BEQ_cont.14591
BEQ_else.14590:
BEQ_cont.14591:
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 0(%r2)
	SW	%r1, 28(%r30)
	SW	%r3, 29(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30) # save link register
	ADDI	%r30, %r30, 31
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 29(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 30(%r30) # save link register
	ADDI	%r30, %r30, 31
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 31
	SUB	%r30, %r30, %r29
	LW	%r29, 30(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 0(%r2)
	ADDI	%r3, %r3, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.14594
	SW	%r3, 30(%r30)
	SW	%r1, 31(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 32(%r30) # save link register
	ADDI	%r30, %r30, 33
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 30(%r30) # restore1
	LW	%r3, 31(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14596
	SW	%r1, 32(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 33(%r30) # save link register
	ADDI	%r30, %r30, 34
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 32(%r30) # restore1
	LW	%r3, 31(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 33(%r30) # save link register
	ADDI	%r30, %r30, 34
	JAL	init_line_elements.3098
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14597
BEQ_else.14596:
	ADDI	%r1, %r3, 0
BEQ_cont.14597:
	J	BEQ_cont.14595
BEQ_else.14594:
BEQ_cont.14595:
	LW	%r2, 20(%r30) # restore1
	LW	%r3, 0(%r2)
	SW	%r1, 33(%r30)
	SW	%r3, 34(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 35(%r30) # save link register
	ADDI	%r30, %r30, 36
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 36
	SUB	%r30, %r30, %r29
	LW	%r29, 35(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 34(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 35(%r30) # save link register
	ADDI	%r30, %r30, 36
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 36
	SUB	%r30, %r30, %r29
	LW	%r29, 35(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 20(%r30) # restore1
	LW	%r2, 0(%r2)
	ADDI	%r2, %r2, -2
	ADDI	%r27, %r0, 0
	SLT	%r27, %r2, %r27
	BNE	%r27, %r0, BEQ_else.14598
	SW	%r2, 35(%r30)
	SW	%r1, 36(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30) # save link register
	ADDI	%r30, %r30, 38
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 35(%r30) # restore1
	LW	%r3, 36(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r1, %r2, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r1, %r27
	BNE	%r27, %r0, BEQ_else.14600
	SW	%r1, 37(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 38(%r30) # save link register
	ADDI	%r30, %r30, 39
	JAL	create_pixel.3096
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 37(%r30) # restore1
	LW	%r3, 36(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	ADDI	%r2, %r2, -1
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 38(%r30) # save link register
	ADDI	%r30, %r30, 39
	JAL	init_line_elements.3098
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14601
BEQ_else.14600:
	ADDI	%r1, %r3, 0
BEQ_cont.14601:
	J	BEQ_cont.14599
BEQ_else.14598:
BEQ_cont.14599:
	LW	%r26, 19(%r30) # restore1
	SW	%r1, 38(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	LW	%r26, 18(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 39(%r30)
	ADDI	%r30, %r30, 40
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 40
	SUB	%r30, %r30, %r29
	LW	%r29, 39(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	LW	%r26, 17(%r30) # restore1
	SW	%r1, 39(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r27, %r0, 0
	BNE	%r1, %r27, BEQ_else.14602
	LW	%r1, 16(%r30) # restore1
	LW	%r2, 39(%r30) # restore1
	SW	%r2, 0(%r1)
	J	BEQ_cont.14603
BEQ_else.14602:
	ADDI	%r1, %r0, 1
	LW	%r26, 15(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
BEQ_cont.14603:
	ADDI	%r1, %r0, 0
	LW	%r26, 14(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30) # save link register
	ADDI	%r30, %r30, 41
	JAL	read_or_network.2815
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 13(%r30) # restore1
	SW	%r1, 0(%r2)
	LW	%r26, 12(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r26, 11(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 9
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r0, 0
	LW	%r26, 10(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 4
	LW	%r26, 9(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 40(%r30)
	ADDI	%r30, %r30, 41
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 41
	SUB	%r30, %r30, %r29
	LW	%r29, 40(%r30)
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30) # restore1
	LWC1	%f1, 0(%r1)
	LW	%r2, 7(%r30) # restore1
	SWC1	%f1, 0(%r2)
	LWC1	%f1, 1(%r1)
	SWC1	%f1, 1(%r2)
	LWC1	%f1, 2(%r1)
	SWC1	%f1, 2(%r2)
	LW	%r1, 16(%r30) # restore1
	LW	%r3, 0(%r1)
	ADDI	%r3, %r3, -1
	ADDI	%r27, %r0, 0
	SLT	%r27, %r3, %r27
	BNE	%r27, %r0, BEQ_else.14604
	LW	%r4, 6(%r30) # restore1
	ADD	%r29, %r4, %r3
	LW	%r4, 0(%r29)
	LW	%r5, 1(%r4)
	ADDI	%r27, %r0, 1
	BNE	%r5, %r27, BEQ_else.14606
	SW	%r3, 40(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r4, 0 # args
	SW	%r29, 41(%r30) # save link register
	ADDI	%r30, %r30, 42
	JAL	setup_rect_table.2905
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 40(%r30) # restore1
	LW	%r3, 5(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14607
BEQ_else.14606:
	ADDI	%r27, %r0, 2
	BNE	%r5, %r27, BEQ_else.14608
	SW	%r3, 40(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r4, 0 # args
	SW	%r29, 41(%r30) # save link register
	ADDI	%r30, %r30, 42
	JAL	setup_surface_table.2908
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 40(%r30) # restore1
	LW	%r3, 5(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
	J	BEQ_cont.14609
BEQ_else.14608:
	SW	%r3, 40(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r4, 0 # args
	SW	%r29, 41(%r30) # save link register
	ADDI	%r30, %r30, 42
	JAL	setup_second_table.2911
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	LW	%r2, 40(%r30) # restore1
	LW	%r3, 5(%r30) # restore1
	ADD	%r29, %r3, %r2
	SW	%r1, 0(%r29)
BEQ_cont.14609:
BEQ_cont.14607:
	ADDI	%r2, %r2, -1
	LW	%r1, 3(%r30) # restore1
	LW	%r26, 4(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	J	BEQ_cont.14605
BEQ_else.14604:
BEQ_cont.14605:
	LW	%r1, 16(%r30) # restore1
	LW	%r1, 0(%r1)
	ADDI	%r1, %r1, -1
	LW	%r26, 2(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 41(%r30)
	ADDI	%r30, %r30, 42
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 42
	SUB	%r30, %r30, %r29
	LW	%r29, 41(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	ADDI	%r3, %r0, 0
	LW	%r1, 33(%r30) # restore1
	LW	%r26, 1(%r30) # restore1
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
	ADDI	%r5, %r0, 2
	LW	%r2, 28(%r30) # restore1
	LW	%r3, 33(%r30) # restore1
	LW	%r4, 38(%r30) # restore1
	LW	%r26, 0(%r30) # restore1
	LW	%r25, 0(%r26)
	JR	%r25
_min_caml_start: # main entry point
	SUB	%r0, %r0, %r0
	ADDI	%r28, %r0, 8192
   # main program start
	ADDI	%r1, %r0, 32
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r29, %r31, 0
	SW	%r29, 0(%r30) # save link register
	ADDI	%r30, %r30, 1
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 1
	SUB	%r30, %r30, %r29
	LW	%r29, 0(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 32
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 0(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 1(%r30) # save link register
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
	LW	%r3, 0(%r30) # restore1
	SW	%r3, 2(%r2)
	SW	%r1, 1(%r2)
	ADDI	%r1, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r2, 1(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 2(%r30) # save link register
	ADDI	%r30, %r30, 3
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 3
	SUB	%r30, %r30, %r29
	LW	%r29, 2(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 2(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 3(%r30) # save link register
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
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 3(%r30) # save link register
	ADDI	%r30, %r30, 4
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 4
	SUB	%r30, %r30, %r29
	LW	%r29, 3(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 3(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 4(%r30) # save link register
	ADDI	%r30, %r30, 5
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 5
	SUB	%r30, %r30, %r29
	LW	%r29, 4(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 4(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 5(%r30) # save link register
	ADDI	%r30, %r30, 6
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 6
	SUB	%r30, %r30, %r29
	LW	%r29, 5(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 5(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 6(%r30) # save link register
	ADDI	%r30, %r30, 7
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 7
	SUB	%r30, %r30, %r29
	LW	%r29, 6(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.11069
	LWC1	%f1, 0(%r29)
	SW	%r1, 6(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 7(%r30) # save link register
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
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 9(%r30) # save link register
	ADDI	%r30, %r30, 10
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 10
	SUB	%r30, %r30, %r29
	LW	%r29, 9(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 8(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 9(%r30) # save link register
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
	ADDI	%r2, %r4, 0 # args
	ADDI	%r1, %r3, 0 # args
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	LW	%r1, 10(%r30) # restore1
	ADDI	%r29, %r31, 0
	SW	%r29, 11(%r30) # save link register
	ADDI	%r30, %r30, 12
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 12
	SUB	%r30, %r30, %r29
	LW	%r29, 11(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 11(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 12(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 13(%r30) # save link register
	ADDI	%r30, %r30, 14
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 14
	SUB	%r30, %r30, %r29
	LW	%r29, 13(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.11097
	LWC1	%f1, 0(%r29)
	SW	%r1, 13(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 14(%r30) # save link register
	ADDI	%r30, %r30, 15
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 15
	SUB	%r30, %r30, %r29
	LW	%r29, 14(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 14(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 15(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 16(%r30) # save link register
	ADDI	%r30, %r30, 17
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 17
	SUB	%r30, %r30, %r29
	LW	%r29, 16(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 16(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 17(%r30) # save link register
	ADDI	%r30, %r30, 18
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 18
	SUB	%r30, %r30, %r29
	LW	%r29, 17(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 17(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 18(%r30) # save link register
	ADDI	%r30, %r30, 19
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 19
	SUB	%r30, %r30, %r29
	LW	%r29, 18(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 18(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 19(%r30) # save link register
	ADDI	%r30, %r30, 20
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 20
	SUB	%r30, %r30, %r29
	LW	%r29, 19(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 19(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 20(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 21(%r30) # save link register
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
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 22(%r30) # save link register
	ADDI	%r30, %r30, 23
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 23
	SUB	%r30, %r30, %r29
	LW	%r29, 22(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 22(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 23(%r30) # save link register
	ADDI	%r30, %r30, 24
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 24
	SUB	%r30, %r30, %r29
	LW	%r29, 23(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 23(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 24(%r30) # save link register
	ADDI	%r30, %r30, 25
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 25
	SUB	%r30, %r30, %r29
	LW	%r29, 24(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 24(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 25(%r30) # save link register
	ADDI	%r30, %r30, 26
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 26
	SUB	%r30, %r30, %r29
	LW	%r29, 25(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 25(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 26(%r30) # save link register
	ADDI	%r30, %r30, 27
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 27
	SUB	%r30, %r30, %r29
	LW	%r29, 26(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 26(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 27(%r30) # save link register
	ADDI	%r30, %r30, 28
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 28
	SUB	%r30, %r30, %r29
	LW	%r29, 27(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 27(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 28(%r30) # save link register
	ADDI	%r30, %r30, 29
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 29
	SUB	%r30, %r30, %r29
	LW	%r29, 28(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 28(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 29(%r30) # save link register
	ADDI	%r30, %r30, 30
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 30
	SUB	%r30, %r30, %r29
	LW	%r29, 29(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 29(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 30(%r30) # save link register
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
	SW	%r29, 31(%r30) # save link register
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
	LW	%r1, 30(%r30) # restore1
	SW	%r1, 0(%r3)
	ADDI	%r1, %r3, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 31(%r30) # save link register
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 5
	ADDI	%r29, %r31, 0
	SW	%r29, 31(%r30) # save link register
	ADDI	%r30, %r30, 32
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 32
	SUB	%r30, %r30, %r29
	LW	%r29, 31(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 31(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 32(%r30) # save link register
	ADDI	%r30, %r30, 33
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 33
	SUB	%r30, %r30, %r29
	LW	%r29, 32(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 3
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 32(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	SW	%r29, 33(%r30) # save link register
	ADDI	%r30, %r30, 34
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 34
	SUB	%r30, %r30, %r29
	LW	%r29, 33(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 60
	LW	%r3, 32(%r30) # restore1
	SW	%r1, 33(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 34(%r30) # save link register
	ADDI	%r30, %r30, 35
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 35
	SUB	%r30, %r30, %r29
	LW	%r29, 34(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r3, 33(%r30) # restore1
	SW	%r3, 0(%r2)
	ADDI	%r4, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	SW	%r1, 34(%r30)
	SW	%r2, 35(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r4, 0 # args
	SW	%r29, 36(%r30) # save link register
	ADDI	%r30, %r30, 37
	JAL	min_caml_create_float_array
	ADDI	%r29, %r0, 37
	SUB	%r30, %r30, %r29
	LW	%r29, 36(%r30)
	ADDI	%r2, %r1, 0
	ADDI	%r31, %r29, 0
	ADDI	%r1, %r0, 0
	SW	%r2, 36(%r30)
	ADDI	%r29, %r31, 0
	SW	%r29, 37(%r30) # save link register
	ADDI	%r30, %r30, 38
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	SW	%r1, 1(%r2)
	LW	%r1, 36(%r30) # restore1
	SW	%r1, 0(%r2)
	ADDI	%r1, %r2, 0
	ADDI	%r2, %r0, 180
	ADDI	%r3, %r0, 0
	LA	%r29, l.10550
	LWC1	%f1, 0(%r29)
	ADDI	%r4, %r28, 0
	ADDI	%r28, %r28, 3
	SWC1	%f1, 2(%r4)
	SW	%r1, 1(%r4)
	SW	%r3, 0(%r4)
	ADDI	%r1, %r4, 0
	ADDI	%r29, %r31, 0
	ADDI	%r25, %r2, 0 # args
	ADDI	%r2, %r1, 0 # args
	ADDI	%r1, %r25, 0 # args
	SW	%r29, 37(%r30) # save link register
	ADDI	%r30, %r30, 38
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 38
	SUB	%r30, %r30, %r29
	LW	%r29, 37(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r0, 1
	ADDI	%r3, %r0, 0
	SW	%r1, 37(%r30)
	ADDI	%r29, %r31, 0
	ADDI	%r1, %r2, 0 # args
	ADDI	%r2, %r3, 0 # args
	SW	%r29, 38(%r30) # save link register
	ADDI	%r30, %r30, 39
	JAL	min_caml_create_array
	ADDI	%r29, %r0, 39
	SUB	%r30, %r30, %r29
	LW	%r29, 38(%r30)
	ADDI	%r31, %r29, 0
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r3, read_screen_settings.2800
	SW	%r3, 0(%r2)
	LW	%r3, 5(%r30) # restore1
	SW	%r3, 5(%r2)
	LW	%r4, 28(%r30) # restore1
	SW	%r4, 4(%r2)
	LW	%r5, 27(%r30) # restore1
	SW	%r5, 3(%r2)
	LW	%r6, 26(%r30) # restore1
	SW	%r6, 2(%r2)
	LW	%r7, 4(%r30) # restore1
	SW	%r7, 1(%r2)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r8, read_light.2802
	SW	%r8, 0(%r7)
	LW	%r8, 6(%r30) # restore1
	SW	%r8, 2(%r7)
	LW	%r9, 7(%r30) # restore1
	SW	%r9, 1(%r7)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r11, read_nth_object.2807
	SW	%r11, 0(%r10)
	LW	%r11, 3(%r30) # restore1
	SW	%r11, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r13, read_object.2809
	SW	%r13, 0(%r12)
	SW	%r10, 2(%r12)
	LW	%r13, 2(%r30) # restore1
	SW	%r13, 1(%r12)
	ADDI	%r14, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r15, read_and_network.2817
	SW	%r15, 0(%r14)
	LW	%r15, 9(%r30) # restore1
	SW	%r15, 1(%r14)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, solver_rect_surface.2821
	SW	%r17, 0(%r16)
	LW	%r17, 12(%r30) # restore1
	SW	%r17, 1(%r16)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r19, solver_rect.2830
	SW	%r19, 0(%r18)
	SW	%r16, 1(%r18)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r19, solver_second.2855
	SW	%r19, 0(%r16)
	SW	%r17, 1(%r16)
	ADDI	%r19, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r20, solver.2861
	SW	%r20, 0(%r19)
	SW	%r16, 4(%r19)
	SW	%r18, 3(%r19)
	SW	%r17, 2(%r19)
	SW	%r11, 1(%r19)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r18, solver_rect_fast.2865
	SW	%r18, 0(%r16)
	SW	%r17, 1(%r16)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r20, solver_surface_fast.2872
	SW	%r20, 0(%r18)
	SW	%r17, 1(%r18)
	ADDI	%r20, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r21, solver_second_fast.2878
	SW	%r21, 0(%r20)
	SW	%r17, 1(%r20)
	ADDI	%r21, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r22, solver_fast.2884
	SW	%r22, 0(%r21)
	SW	%r18, 4(%r21)
	SW	%r20, 3(%r21)
	SW	%r16, 2(%r21)
	SW	%r11, 1(%r21)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r20, solver_second_fast2.2895
	SW	%r20, 0(%r18)
	SW	%r17, 1(%r18)
	ADDI	%r20, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r22, solver_fast2.2902
	SW	%r22, 0(%r20)
	SW	%r18, 4(%r20)
	SW	%r16, 3(%r20)
	SW	%r17, 2(%r20)
	SW	%r11, 1(%r20)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r18, iter_setup_dirvec_constants.2914
	SW	%r18, 0(%r16)
	SW	%r11, 1(%r16)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r22, setup_startp_constants.2919
	SW	%r22, 0(%r18)
	SW	%r11, 1(%r18)
	ADDI	%r22, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r23, setup_startp.2922
	SW	%r23, 0(%r22)
	LW	%r23, 25(%r30) # restore1
	SW	%r23, 3(%r22)
	SW	%r18, 2(%r22)
	SW	%r13, 1(%r22)
	ADDI	%r24, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r25, check_all_inside.2944
	SW	%r25, 0(%r24)
	SW	%r11, 1(%r24)
	ADDI	%r25, %r28, 0
	ADDI	%r28, %r28, 8
	LA	%r26, shadow_check_and_group.2950
	SW	%r26, 0(%r25)
	SW	%r21, 7(%r25)
	SW	%r17, 6(%r25)
	SW	%r11, 5(%r25)
	LW	%r26, 35(%r30) # restore1
	SW	%r26, 4(%r25)
	SW	%r8, 3(%r25)
	SW	%r14, 38(%r30)
	LW	%r14, 15(%r30) # restore1
	SW	%r14, 2(%r25)
	SW	%r24, 1(%r25)
	SW	%r7, 39(%r30)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 3
	SW	%r10, 40(%r30)
	LA	%r10, shadow_check_one_or_group.2953
	SW	%r10, 0(%r7)
	SW	%r25, 2(%r7)
	SW	%r15, 1(%r7)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 8
	SW	%r12, 41(%r30)
	LA	%r12, shadow_check_one_or_matrix.2956
	SW	%r12, 0(%r10)
	SW	%r21, 7(%r10)
	SW	%r17, 6(%r10)
	SW	%r7, 5(%r10)
	SW	%r25, 4(%r10)
	SW	%r26, 3(%r10)
	SW	%r14, 2(%r10)
	SW	%r15, 1(%r10)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r12, solve_each_element.2959
	SW	%r12, 0(%r7)
	LW	%r12, 14(%r30) # restore1
	SW	%r12, 9(%r7)
	LW	%r21, 24(%r30) # restore1
	SW	%r21, 8(%r7)
	SW	%r17, 7(%r7)
	SW	%r19, 6(%r7)
	SW	%r11, 5(%r7)
	LW	%r25, 13(%r30) # restore1
	SW	%r25, 4(%r7)
	SW	%r14, 3(%r7)
	LW	%r26, 16(%r30) # restore1
	SW	%r26, 2(%r7)
	SW	%r24, 1(%r7)
	SW	%r2, 42(%r30)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 3
	SW	%r16, 43(%r30)
	LA	%r16, solve_one_or_network.2963
	SW	%r16, 0(%r2)
	SW	%r7, 2(%r2)
	SW	%r15, 1(%r2)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 8
	LA	%r5, trace_or_matrix.2967
	SW	%r5, 0(%r16)
	SW	%r12, 7(%r16)
	SW	%r21, 6(%r16)
	SW	%r17, 5(%r16)
	SW	%r19, 4(%r16)
	SW	%r2, 3(%r16)
	SW	%r7, 2(%r16)
	SW	%r15, 1(%r16)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r5, solve_each_element_fast.2973
	SW	%r5, 0(%r2)
	SW	%r12, 9(%r2)
	SW	%r23, 8(%r2)
	SW	%r20, 7(%r2)
	SW	%r17, 6(%r2)
	SW	%r11, 5(%r2)
	SW	%r25, 4(%r2)
	SW	%r14, 3(%r2)
	SW	%r26, 2(%r2)
	SW	%r24, 1(%r2)
	ADDI	%r5, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r7, solve_one_or_network_fast.2977
	SW	%r7, 0(%r5)
	SW	%r2, 2(%r5)
	SW	%r15, 1(%r5)
	ADDI	%r7, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r19, trace_or_matrix_fast.2981
	SW	%r19, 0(%r7)
	SW	%r12, 6(%r7)
	SW	%r20, 5(%r7)
	SW	%r17, 4(%r7)
	SW	%r5, 3(%r7)
	SW	%r2, 2(%r7)
	SW	%r15, 1(%r7)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r5, get_nvector_rect.2987
	SW	%r5, 0(%r2)
	LW	%r5, 17(%r30) # restore1
	SW	%r5, 2(%r2)
	SW	%r25, 1(%r2)
	ADDI	%r15, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r17, get_nvector_plane.2989
	SW	%r17, 0(%r15)
	SW	%r5, 1(%r15)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r19, get_nvector_second.2991
	SW	%r19, 0(%r17)
	SW	%r5, 2(%r17)
	SW	%r14, 1(%r17)
	ADDI	%r19, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r20, utexture.2996
	SW	%r20, 0(%r19)
	LW	%r20, 18(%r30) # restore1
	SW	%r20, 1(%r19)
	ADDI	%r24, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r4, add_light.2999
	SW	%r4, 0(%r24)
	SW	%r20, 2(%r24)
	LW	%r4, 20(%r30) # restore1
	SW	%r4, 1(%r24)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r3, trace_reflections.3003
	SW	%r3, 0(%r6)
	SW	%r7, 9(%r6)
	SW	%r12, 8(%r6)
	SW	%r10, 7(%r6)
	LW	%r3, 37(%r30) # restore1
	SW	%r3, 6(%r6)
	LW	%r3, 11(%r30) # restore1
	SW	%r3, 5(%r6)
	SW	%r5, 4(%r6)
	SW	%r25, 3(%r6)
	SW	%r26, 2(%r6)
	SW	%r24, 1(%r6)
	SW	%r22, 44(%r30)
	ADDI	%r22, %r28, 0
	ADDI	%r28, %r28, 25
	SW	%r7, 45(%r30)
	LA	%r7, trace_ray.3008
	SW	%r7, 0(%r22)
	SW	%r19, 24(%r22)
	SW	%r6, 23(%r22)
	SW	%r16, 22(%r22)
	SW	%r12, 21(%r22)
	SW	%r20, 20(%r22)
	SW	%r23, 19(%r22)
	SW	%r21, 18(%r22)
	SW	%r10, 17(%r22)
	SW	%r18, 16(%r22)
	SW	%r4, 15(%r22)
	SW	%r3, 14(%r22)
	SW	%r11, 13(%r22)
	SW	%r5, 12(%r22)
	SW	%r1, 11(%r22)
	SW	%r13, 10(%r22)
	SW	%r8, 9(%r22)
	SW	%r25, 8(%r22)
	SW	%r14, 7(%r22)
	SW	%r26, 6(%r22)
	SW	%r17, 5(%r22)
	SW	%r2, 4(%r22)
	SW	%r15, 3(%r22)
	SW	%r9, 2(%r22)
	SW	%r24, 1(%r22)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 16
	LA	%r7, trace_diffuse_ray.3014
	SW	%r7, 0(%r6)
	SW	%r19, 15(%r6)
	LW	%r7, 45(%r30) # restore1
	SW	%r7, 14(%r6)
	SW	%r12, 13(%r6)
	SW	%r20, 12(%r6)
	SW	%r10, 11(%r6)
	SW	%r3, 10(%r6)
	SW	%r11, 9(%r6)
	SW	%r5, 8(%r6)
	SW	%r8, 7(%r6)
	SW	%r14, 6(%r6)
	SW	%r26, 5(%r6)
	SW	%r17, 4(%r6)
	SW	%r2, 3(%r6)
	SW	%r15, 2(%r6)
	LW	%r2, 19(%r30) # restore1
	SW	%r2, 1(%r6)
	ADDI	%r5, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r7, iter_trace_diffuse_rays.3017
	SW	%r7, 0(%r5)
	SW	%r6, 1(%r5)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r7, trace_diffuse_ray_80percent.3026
	SW	%r7, 0(%r6)
	LW	%r7, 44(%r30) # restore1
	SW	%r7, 3(%r6)
	SW	%r5, 2(%r6)
	LW	%r9, 31(%r30) # restore1
	SW	%r9, 1(%r6)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r12, calc_diffuse_using_1point.3030
	SW	%r12, 0(%r10)
	SW	%r6, 3(%r10)
	SW	%r4, 2(%r10)
	SW	%r2, 1(%r10)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 3
	LA	%r14, calc_diffuse_using_5points.3033
	SW	%r14, 0(%r12)
	SW	%r4, 2(%r12)
	SW	%r2, 1(%r12)
	ADDI	%r14, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r15, do_without_neighbors.3039
	SW	%r15, 0(%r14)
	SW	%r6, 4(%r14)
	SW	%r4, 3(%r14)
	SW	%r2, 2(%r14)
	SW	%r10, 1(%r14)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r15, try_exploit_neighbors.3055
	SW	%r15, 0(%r6)
	SW	%r14, 3(%r6)
	SW	%r12, 2(%r6)
	SW	%r10, 1(%r6)
	ADDI	%r12, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r15, write_ppm_header.3062
	SW	%r15, 0(%r12)
	LW	%r15, 21(%r30) # restore1
	SW	%r15, 1(%r12)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 5
	LA	%r17, pretrace_diffuse_rays.3068
	SW	%r17, 0(%r16)
	SW	%r7, 4(%r16)
	SW	%r5, 3(%r16)
	SW	%r9, 2(%r16)
	SW	%r2, 1(%r16)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 10
	LA	%r5, pretrace_pixels.3071
	SW	%r5, 0(%r2)
	LW	%r5, 5(%r30) # restore1
	SW	%r5, 9(%r2)
	SW	%r22, 8(%r2)
	SW	%r21, 7(%r2)
	LW	%r5, 26(%r30) # restore1
	SW	%r5, 6(%r2)
	LW	%r5, 23(%r30) # restore1
	SW	%r5, 5(%r2)
	SW	%r4, 4(%r2)
	LW	%r7, 29(%r30) # restore1
	SW	%r7, 3(%r2)
	SW	%r16, 2(%r2)
	LW	%r7, 22(%r30) # restore1
	SW	%r7, 1(%r2)
	ADDI	%r16, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r17, pretrace_line.3078
	SW	%r17, 0(%r16)
	LW	%r17, 28(%r30) # restore1
	SW	%r17, 6(%r16)
	LW	%r17, 27(%r30) # restore1
	SW	%r17, 5(%r16)
	SW	%r5, 4(%r16)
	SW	%r2, 3(%r16)
	SW	%r15, 2(%r16)
	SW	%r7, 1(%r16)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r17, scan_pixel.3082
	SW	%r17, 0(%r2)
	SW	%r6, 6(%r2)
	SW	%r4, 5(%r2)
	LW	%r4, 1(%r30) # restore1
	SW	%r4, 4(%r2)
	SW	%r15, 3(%r2)
	SW	%r14, 2(%r2)
	SW	%r10, 1(%r2)
	ADDI	%r4, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r6, scan_line.3088
	SW	%r6, 0(%r4)
	SW	%r2, 3(%r4)
	SW	%r16, 2(%r4)
	SW	%r15, 1(%r4)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r6, calc_dirvec.3108
	SW	%r6, 0(%r2)
	SW	%r9, 1(%r2)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r10, calc_dirvecs.3116
	SW	%r10, 0(%r6)
	SW	%r2, 1(%r6)
	ADDI	%r2, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r10, calc_dirvec_rows.3121
	SW	%r10, 0(%r2)
	SW	%r6, 1(%r2)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 2
	LA	%r10, create_dirvec_elements.3127
	SW	%r10, 0(%r6)
	SW	%r13, 1(%r6)
	ADDI	%r10, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r14, create_dirvecs.3130
	SW	%r14, 0(%r10)
	SW	%r13, 3(%r10)
	SW	%r9, 2(%r10)
	SW	%r6, 1(%r10)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r14, init_dirvec_constants.3132
	SW	%r14, 0(%r6)
	SW	%r11, 3(%r6)
	SW	%r13, 2(%r6)
	LW	%r14, 43(%r30) # restore1
	SW	%r14, 1(%r6)
	ADDI	%r17, %r28, 0
	ADDI	%r28, %r28, 6
	LA	%r18, init_vecset_constants.3135
	SW	%r18, 0(%r17)
	SW	%r11, 5(%r17)
	SW	%r13, 4(%r17)
	SW	%r14, 3(%r17)
	SW	%r6, 2(%r17)
	SW	%r9, 1(%r17)
	ADDI	%r6, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r9, setup_rect_reflection.3146
	SW	%r9, 0(%r6)
	LW	%r9, 37(%r30) # restore1
	SW	%r9, 6(%r6)
	SW	%r11, 5(%r6)
	SW	%r1, 4(%r6)
	SW	%r13, 3(%r6)
	SW	%r8, 2(%r6)
	SW	%r14, 1(%r6)
	ADDI	%r18, %r28, 0
	ADDI	%r28, %r28, 7
	LA	%r19, setup_surface_reflection.3149
	SW	%r19, 0(%r18)
	SW	%r9, 6(%r18)
	SW	%r11, 5(%r18)
	SW	%r1, 4(%r18)
	SW	%r13, 3(%r18)
	SW	%r8, 2(%r18)
	SW	%r14, 1(%r18)
	ADDI	%r1, %r28, 0
	ADDI	%r28, %r28, 4
	LA	%r9, setup_reflections.3152
	SW	%r9, 0(%r1)
	SW	%r18, 3(%r1)
	SW	%r6, 2(%r1)
	SW	%r11, 1(%r1)
	ADDI	%r26, %r28, 0
	ADDI	%r28, %r28, 24
	LA	%r6, rt.3154
	SW	%r6, 0(%r26)
	SW	%r12, 23(%r26)
	LW	%r6, 33(%r30) # restore1
	SW	%r6, 22(%r26)
	SW	%r1, 21(%r26)
	SW	%r5, 20(%r26)
	SW	%r4, 19(%r26)
	LW	%r1, 42(%r30) # restore1
	SW	%r1, 18(%r26)
	LW	%r1, 41(%r30) # restore1
	SW	%r1, 17(%r26)
	LW	%r1, 40(%r30) # restore1
	SW	%r1, 16(%r26)
	LW	%r1, 39(%r30) # restore1
	SW	%r1, 15(%r26)
	LW	%r1, 38(%r30) # restore1
	SW	%r1, 14(%r26)
	SW	%r16, 13(%r26)
	SW	%r3, 12(%r26)
	SW	%r11, 11(%r26)
	SW	%r13, 10(%r26)
	LW	%r1, 35(%r30) # restore1
	SW	%r1, 9(%r26)
	SW	%r8, 8(%r26)
	SW	%r14, 7(%r26)
	SW	%r17, 6(%r26)
	SW	%r15, 5(%r26)
	SW	%r7, 4(%r26)
	SW	%r10, 3(%r26)
	LW	%r1, 34(%r30) # restore1
	SW	%r1, 2(%r26)
	SW	%r2, 1(%r26)
	ADDI	%r1, %r0, 128
	ADDI	%r2, %r0, 128
	ADDI	%r29, %r31, 0
	SW	%r29, 46(%r30)
	ADDI	%r30, %r30, 47
	LW	%r29, 0(%r26)
	JALR	%r29
	ADDI	%r29, %r0, 47
	SUB	%r30, %r30, %r29
	LW	%r29, 46(%r30)
	ADDI	%r31, %r29, 0
halt   # main program end
