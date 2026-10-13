/*
 * Human-reconstructed x86 lowering for six independently recovered accessors.
 * GNU as {load} prefixes select the alternate MOV register form used by the
 * original ranges. This is assembly source, not original C/compiler provenance.
 */
.text

.globl _FUN_004dae66
_FUN_004dae66:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 0x18(%eax), %eax
    {load} movl %ebp, %esp
    popl %ebp
    ret

.globl _FUN_004dae77
_FUN_004dae77:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 0x1c(%eax), %eax
    {load} movl %ebp, %esp
    popl %ebp
    ret

.globl _FUN_004daef1
_FUN_004daef1:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 0x0c(%eax), %eax
    {load} movl %ebp, %esp
    popl %ebp
    ret

.globl _FUN_004daf02
_FUN_004daf02:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 8(%ebp), %ecx
    movl %ecx, 0x0c(%eax)
    {load} movl %ebp, %esp
    popl %ebp
    ret $4

.globl _FUN_004daf18
_FUN_004daf18:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 0x10(%eax), %eax
    {load} movl %ebp, %esp
    popl %ebp
    ret

.globl _FUN_004daf29
_FUN_004daf29:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 8(%ebp), %ecx
    movl %ecx, 0x10(%eax)
    {load} movl %ebp, %esp
    popl %ebp
    ret $4
