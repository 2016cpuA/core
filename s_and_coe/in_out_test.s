	IN %r4
	OUT %r4
	ADDI %r1,%r0,$1000
	ADDI %r2,%r0,$100
loop:
	ADDI %r1,%r1,$-1
	BEQ %r1,%r0,next
	J loop
next:	
	IN %r3
	OUT %r3
	ADDI %r2,%r2,$-1
	BEQ %r2,%r0,end
	J next
end:
	HALT
