addi	%r1,%r0,0x0001 	#reg[1] <= 1
addi	%r2,%r0,0x0002 	#ref[2] <= 2
addi	%r3,%r0,0x7fff 	#reg[3] <= 32767
addi	%r4,%r0,0xffff 	#reg[4] <= -1
andi	%r5,%r4,0xffff	#reg[5] <= -1
andi	%r6,%r4,0x7fff	#reg[6] <= 32767
ori		%r7,%r1,0x8000	#reg[7] <= -32767
ori		%r8,%r1,0xffff	#reg[8] <= -1
add		%r9,%r1,%r2		#reg[9] <= 1 + 2 = 3
add		%r10,%r3,%r4	#reg[10] <= 32767 + (-1) = 32766
add		%r11,%r6,%r7	#reg[11] <= 32767 + (-32767) = 0
sll		%r12,%r1,31		#reg[12] <= -2147483648
srl		%r13,%r1,1		#reg[13] <= 0
srl		%r14,%r4,31		#reg[14] <= 1
sra		%r15,%r1,1		#reg[15] <= 0
sra		%r16,%r4,31		#reg[16] <= -1
