# FUN_00523ef2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523ef2
# extent:       0x00523ef2-0x00523f7d (139 code bytes)
# span:         0x00523ef2-0x00523f7d (code 139, tables 0, padding 0)
# sha256:       d9eae004a472f1f5cc06f10de94a287767643e3356330003e5a6a67b4632c1e4
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523ef2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_58, field_d0; [ebp + n] field_minus_4, field_minus_c, field_minus_24, field_minus_28; [ecx + n] field_78; [edx + n] field_58; [esi + n] field_70
# callees:      calls FUN_0050f978, FUN_0051a28e, FUN_0051a387, FUN_0051c0c9, FUN_0051a2ed; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00523f7d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_24, 0x24  # offset -0x24
.equ field_minus_28, 0x28  # offset -0x28
.equ field_8, 0x8  # offset +0x8
.equ field_58, 0x58  # offset +0x58
.equ field_70, 0x70  # offset +0x70
.equ field_78, 0x78  # offset +0x78
.equ field_d0, 0xd0  # offset +0xd0

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a28e, .text + (0x0051a28e - 0x401000)
.set FUN_0051a2ed, .text + (0x0051a2ed - 0x401000)
.set FUN_0051a387, .text + (0x0051a387 - 0x401000)
.set FUN_0051c0c9, .text + (0x0051c0c9 - 0x401000)

.org 0x00523ef2 - 0x401000
.globl FUN_00523ef2
FUN_00523ef2:
    # block 0x00523ef2: entry, 12 instruction(s), calls FUN_0050f978, FUN_0051a28e, ends with je to 0x00523f3b (forward)
    mov eax, 0x528f80                            # 00523ef2
    call FUN_0050f978                            # 00523ef7
    sub esp, 0x1c                                # 00523efc
    push esi                                     # 00523eff
    {load} mov esi, ecx                          # 00523f00
    push 0xa                                     # 00523f02
    lea ecx, [ebp - field_minus_28]              # 00523f04
    call FUN_0051a28e                            # 00523f07
    mov esi, dword ptr [esi + field_70]          # 00523f0c
    and dword ptr [ebp - field_minus_4], 0x0     # 00523f0f
    test esi, esi                                # 00523f13
    je.d8 L_00523f3b                             # 00523f15
    # block 0x00523f17: entered by fall-through of je at 0x00523f15, 1 instruction(s), falls into the block at 0x00523f18
    push edi                                     # 00523f17
L_00523f18:
    # block 0x00523f18: entered by jne at 0x00523f38, 8 instruction(s), calls indirect dword ptr [eax + 0xd0], ends with je to 0x00523f36 (forward)
    {load} mov eax, esi                          # 00523f18
    mov esi, dword ptr [esi]                     # 00523f1a
    mov edi, dword ptr [eax + field_8]           # 00523f1c
    {load} mov ecx, edi                          # 00523f1f
    mov eax, dword ptr [edi]                     # 00523f21
    call dword ptr [eax + field_d0]              # 00523f23
    test eax, eax                                # 00523f29
    je.d8 L_00523f36                             # 00523f2b
    # block 0x00523f2d: entered by fall-through of je at 0x00523f2b, 3 instruction(s), calls FUN_0051a387, falls into the block at 0x00523f36
    push edi                                     # 00523f2d
    lea ecx, [ebp - field_minus_28]              # 00523f2e
    call FUN_0051a387                            # 00523f31
L_00523f36:
    # block 0x00523f36: entered by je at 0x00523f2b, 2 instruction(s), ends with jne to 0x00523f18 (backward)
    test esi, esi                                # 00523f36
    jne.d8 L_00523f18                            # 00523f38
    # block 0x00523f3a: entered by fall-through of jne at 0x00523f38, 1 instruction(s), falls into the block at 0x00523f3b
    pop edi                                      # 00523f3a
L_00523f3b:
    # block 0x00523f3b: entered by je at 0x00523f15, 1 instruction(s), falls into the block at 0x00523f3e
    mov esi, dword ptr [ebp - field_minus_24]    # 00523f3b
L_00523f3e:
    # block 0x00523f3e: entered by jmp at 0x00523f5b; jmp at 0x00523f62, 2 instruction(s), ends with je to 0x00523f64 (forward)
    test esi, esi                                # 00523f3e
    je.d8 L_00523f64                             # 00523f40
    # block 0x00523f42: entered by fall-through of je at 0x00523f40, 5 instruction(s), ends with je to 0x00523f5d (forward)
    {load} mov eax, esi                          # 00523f42
    mov esi, dword ptr [esi]                     # 00523f44
    mov ecx, dword ptr [eax + field_8]           # 00523f46
    cmp dword ptr [ecx + field_78], 0x0          # 00523f49
    je.d8 L_00523f5d                             # 00523f4d
    # block 0x00523f4f: entered by fall-through of je at 0x00523f4d, 5 instruction(s), calls FUN_0051c0c9, indirect dword ptr [edx + 0x58], ends with backward jump to 0x00523f3e
    call FUN_0051c0c9                            # 00523f4f
    mov edx, dword ptr [eax]                     # 00523f54
    {load} mov ecx, eax                          # 00523f56
    call dword ptr [edx + field_58]              # 00523f58
    jmp.d8 L_00523f3e                            # 00523f5b
L_00523f5d:
    # block 0x00523f5d: entered by je at 0x00523f4d, 3 instruction(s), calls indirect dword ptr [eax + 0x58], ends with backward jump to 0x00523f3e
    mov eax, dword ptr [ecx]                     # 00523f5d
    call dword ptr [eax + field_58]              # 00523f5f
    jmp.d8 L_00523f3e                            # 00523f62
L_00523f64:
    # block 0x00523f64: entered by je at 0x00523f40, 8 instruction(s), calls FUN_0051a2ed, ends with ret
    or dword ptr [ebp - field_minus_4], -0x1     # 00523f64
    lea ecx, [ebp - field_minus_28]              # 00523f68
    call FUN_0051a2ed                            # 00523f6b
    mov ecx, dword ptr [ebp - field_minus_c]     # 00523f70
    pop esi                                      # 00523f73
    mov dword ptr fs:[0x0], ecx                  # 00523f74
    leave                                        # 00523f7b
    ret                                          # 00523f7c

