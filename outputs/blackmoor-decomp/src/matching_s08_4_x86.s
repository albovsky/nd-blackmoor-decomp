/*
 * Human-reconstructed x86 for the two original input-consumption methods.
 * These are complete mnemonic assembly extents, not original compiler/source
 * provenance and not a whole-executable rebuild.
 */
.text

.globl _FUN_004daf3f
_FUN_004daf3f:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    cmpl $0, (%eax)
    je .Lfield0_empty
    movl -4(%ebp), %ecx
    movl $0, (%ecx)
    movl -4(%ebp), %edx
    movl $0, 0x0c(%edx)
    movl $1, %eax
    jmp .Lfield0_return
.Lfield0_empty:
    {load} xorl %eax, %eax
.Lfield0_return:
    {load} movl %ebp, %esp
    popl %ebp
    ret

.globl _FUN_004daf6e
_FUN_004daf6e:
    pushl %ebp
    {load} movl %esp, %ebp
    pushl %ecx
    movl %ecx, -4(%ebp)
    movl -4(%ebp), %eax
    cmpl $0, 0x04(%eax)
    je .Lfield4_empty
    movl -4(%ebp), %ecx
    movl $0, 0x04(%ecx)
    movl -4(%ebp), %edx
    movl $0, 0x10(%edx)
    movl $1, %eax
    jmp .Lfield4_return
.Lfield4_empty:
    {load} xorl %eax, %eax
.Lfield4_return:
    {load} movl %ebp, %esp
    popl %ebp
    ret
