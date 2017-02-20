addi %r1,%r0,0x4040
sll %r1,%r1,16
sw %r1,0(%r0)
lwc1 %f1,0(%r0)
add.s %f2,%f1,%f1 #3+3=6
sub.s %f3,%f2,%f1 #6-3=3
mul.s %f4,%f2,%f2 #6*6=36
div.s %f5,%f4,%f2 #36/6=6
c.eq.s %r6,%f1,%f3
c.lt.s %r7,%f1,%f2
c.lt.s %r7,%f2,%f1
swc1 %f1,1(%r0)
lwc1 %f8,1(%r0)
halt
