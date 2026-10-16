# FUN_00516eaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516eaa
# extent:       0x00516eaa-0x00516f60 (182 code bytes)
# span:         0x00516eaa-0x00516f60 (code 182, tables 0, padding 0)
# sha256:       4032b729187a5ee2f32cc4785d18fdc9fafcf77e6af6ef954d977201f0743553
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516eaa
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8; [ecx + n] field_3c00, field_3c01; [edx + n] field_4, field_6
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 70 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_3c00, 0x3c00  # offset +0x3c00
.equ field_3c01, 0x3c01  # offset +0x3c01

# --- external targets -----------------------------------------------

.org 0x00516eaa - 0x401000
.globl FUN_00516eaa
FUN_00516eaa:
    # block 0x00516eaa: entry, 22 instruction(s), ends with je to 0x00516ef8 (forward)
    push ebp                                     # 00516eaa
    {load} mov ebp, esp                          # 00516eab
    push ecx                                     # 00516ead
    mov edx, dword ptr [ebp + arg_c]             # 00516eae
    push ebx                                     # 00516eb1
    push esi                                     # 00516eb2
    push edi                                     # 00516eb3
    mov ax, word ptr [edx + field_6]             # 00516eb4
    mov edi, 0x7ff                               # 00516eb8
    {load} mov ecx, eax                          # 00516ebd
    and eax, 0x8000                              # 00516ebf
    shr ecx, 0x4                                 # 00516ec4
    {load} and ecx, edi                          # 00516ec7
    mov dword ptr [ebp + arg_c], eax             # 00516ec9
    mov eax, dword ptr [edx + field_4]           # 00516ecc
    mov edx, dword ptr [edx]                     # 00516ecf
    movzx ebx, cx                                # 00516ed1
    mov esi, 0x80000000                          # 00516ed4
    and eax, 0xfffff                             # 00516ed9
    test ebx, ebx                                # 00516ede
    mov dword ptr [ebp - local_4], esi           # 00516ee0
    je.d8 L_00516ef8                             # 00516ee3
    # block 0x00516ee5: entered by fall-through of je at 0x00516ee3, 2 instruction(s), ends with je to 0x00516ef1 (forward)
    {load} cmp ebx, edi                          # 00516ee5
    je.d8 L_00516ef1                             # 00516ee7
    # block 0x00516ee9: entered by fall-through of je at 0x00516ee7, 2 instruction(s), ends with forward jump to 0x00516f19
    lea edi, [ecx + field_3c00]                  # 00516ee9
    jmp.d8 L_00516f19                            # 00516eef
L_00516ef1:
    # block 0x00516ef1: entered by je at 0x00516ee7, 2 instruction(s), ends with forward jump to 0x00516f19
    mov edi, 0x7fff                              # 00516ef1
    jmp.d8 L_00516f19                            # 00516ef6
L_00516ef8:
    # block 0x00516ef8: entered by je at 0x00516ee3, 3 instruction(s), ends with jne to 0x00516f10 (forward)
    {load} xor ebx, ebx                          # 00516ef8
    {load} cmp eax, ebx                          # 00516efa
    jne.d8 L_00516f10                            # 00516efc
    # block 0x00516efe: entered by fall-through of jne at 0x00516efc, 2 instruction(s), ends with jne to 0x00516f10 (forward)
    {load} cmp edx, ebx                          # 00516efe
    jne.d8 L_00516f10                            # 00516f00
    # block 0x00516f02: entered by fall-through of jne at 0x00516f00, 5 instruction(s), ends with forward jump to 0x00516f5b
    mov eax, dword ptr [ebp + arg_8]             # 00516f02
    mov dword ptr [eax + field_4], ebx           # 00516f05
    mov dword ptr [eax], ebx                     # 00516f08
    mov word ptr [eax + field_8], bx             # 00516f0a
    jmp.d8 L_00516f5b                            # 00516f0e
L_00516f10:
    # block 0x00516f10: entered by jne at 0x00516efc; jne at 0x00516f00, 2 instruction(s), falls into the block at 0x00516f19
    lea edi, [ecx + field_3c01]                  # 00516f10
    mov dword ptr [ebp - local_4], ebx           # 00516f16
L_00516f19:
    # block 0x00516f19: entered by jmp at 0x00516eef; jmp at 0x00516ef6, 9 instruction(s), falls into the block at 0x00516f31
    {load} mov ecx, edx                          # 00516f19
    shr ecx, 0x15                                # 00516f1b
    shl eax, 0xb                                 # 00516f1e
    {load} or ecx, eax                           # 00516f21
    mov eax, dword ptr [ebp + arg_8]             # 00516f23
    or ecx, dword ptr [ebp - local_4]            # 00516f26
    shl edx, 0xb                                 # 00516f29
    mov dword ptr [eax + field_4], ecx           # 00516f2c
    mov dword ptr [eax], edx                     # 00516f2f
L_00516f31:
    # block 0x00516f31: entered by jmp at 0x00516f50, 2 instruction(s), ends with jne to 0x00516f52 (forward)
    test esi, ecx                                # 00516f31
    jne.d8 L_00516f52                            # 00516f33
    # block 0x00516f35: entered by fall-through of jne at 0x00516f33, 11 instruction(s), ends with backward jump to 0x00516f31
    mov edx, dword ptr [eax]                     # 00516f35
    {load} add ecx, ecx                          # 00516f37
    {load} mov ebx, edx                          # 00516f39
    shr ebx, 0x1f                                # 00516f3b
    {load} or ebx, ecx                           # 00516f3e
    lea ecx, [edx + edx]                         # 00516f40
    mov dword ptr [eax], ecx                     # 00516f43
    mov dword ptr [eax + field_4], ebx           # 00516f45
    add edi, 0xffff                              # 00516f48
    {load} mov ecx, ebx                          # 00516f4e
    jmp.d8 L_00516f31                            # 00516f50
L_00516f52:
    # block 0x00516f52: entered by jne at 0x00516f33, 3 instruction(s), falls into the block at 0x00516f5b
    mov ecx, dword ptr [ebp + arg_c]             # 00516f52
    {load} or ecx, edi                           # 00516f55
    mov word ptr [eax + field_8], cx             # 00516f57
L_00516f5b:
    # block 0x00516f5b: entered by jmp at 0x00516f0e, 5 instruction(s), ends with ret
    pop edi                                      # 00516f5b
    pop esi                                      # 00516f5c
    pop ebx                                      # 00516f5d
    leave                                        # 00516f5e
    ret                                          # 00516f5f

