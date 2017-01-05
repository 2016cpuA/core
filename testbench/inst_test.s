addi %r1,%r0,0x4000
sll %r2,%r1,16
sw %r2,0(%r0)
lwc1 %f1,0(%r0)
add.s %f2,%f1,%f1
sub.s %f3,%f2,%f1
mul.s %f4,%f2,%f2
div.s %f5,%f4,%f2
c.eq.s %r3,%f1,%f1
c.lt.s %r4,%f4,%f2
c.le.s %r5,%f2,%f2
halt 
