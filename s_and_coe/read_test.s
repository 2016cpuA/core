jal min_caml_read_int
jal min_caml_read_float
j 0
min_caml_read_int:
	in	%r1
	jr	%r31
	.globl	min_caml_read_float
min_caml_read_float:
	in	%r29	
	sw	%r29,0(%r30)
	lwc1	%f1,0(%r30)
	jr	%r31
