addi %r1,%r0,$0x3f80
sll %r1,%r1,$16
addi %r2,%r0,$0x4000
sll %r2,%r2,$16
sw %r1,0(%r0)
sw %r2,1(%r0)
lwc1 %f1,0(%r0)
lwc1 %f2,0(%r0)
lwc1 %f3,1(%r0)
c.eq.s %r3,%f1,%f2
c.eq.s %r4,%f1,%f3
add.s %f4,%f1,%f2
c.eq.s %r5,%f1,%f4
c.eq.s %r6,%f3,%f4
halt
