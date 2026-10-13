/*
 * Human-reconstructed x86 for the original input move/down/up methods.
 * These three complete ranges are reconstructed assembly, not a claim about
 * the compiler or source-language spelling used to produce GAME.EXE.
 */
.text

.globl _FUN_004daf9f
_FUN_004daf9f:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl 0x0c(%ebp), %ecx
    movl (%ecx), %edx
    movl %edx, 0x18(%eax)
    movl -4(%ebp), %eax
    movl 0x0c(%ebp), %ecx
    movl 0x04(%ecx), %edx
    movl %edx, 0x1c(%eax)
    {load} movl %ebp, %esp
    popl %ebp
    ret $8

.globl _FUN_004dafc3
_FUN_004dafc3:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    movl $0, (%eax)
    movl -4(%ebp), %ecx
    movl $0, 0x08(%ecx)
    movl -4(%ebp), %edx
    cmpl $0, 0x0c(%edx)
    jne .Ldown_skip_latch
    movl -4(%ebp), %eax
    movl $1, 0x0c(%eax)
.Ldown_skip_latch:
    movl -4(%ebp), %ecx
    movl $0, 0x10(%ecx)
    {load} movl %ebp, %esp
    popl %ebp
    ret $8

.globl _FUN_004db000
_FUN_004db000:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    cmpl $0, 0x08(%eax)
    je .Lup_unblocked
    jmp .Lup_return
.Lup_unblocked:
    cmpl $-1, 0x005c39e5
    je .Lup_skip_primary
    movl -4(%ebp), %ecx
    cmpl $0, (%ecx)
    jne .Lup_skip_primary
    movl -4(%ebp), %edx
    movl $1, (%edx)
.Lup_skip_primary:
    movl -4(%ebp), %eax
    cmpl $1, 0x0c(%eax)
    jne .Lup_skip_secondary
    movl -4(%ebp), %ecx
    movl $2, 0x0c(%ecx)
.Lup_skip_secondary:
    movl -4(%ebp), %edx
    movl $0, 0x10(%edx)
.Lup_return:
    {load} movl %ebp, %esp
    popl %ebp
    ret $8
