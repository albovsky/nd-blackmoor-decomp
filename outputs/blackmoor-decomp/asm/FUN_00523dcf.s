# FUN_00523dcf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523dcf
# extent:       0x00523dcf-0x00523e94 (197 code bytes)
# span:         0x00523dcf-0x00523e94 (code 197, tables 0, padding 0)
# sha256:       7987a3427be7533d77f6e87aa914e46c0247f5b1f9bc48a8b8f285c28785a503
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523dcf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_90, field_94, field_c4, field_d4; [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10, field_minus_14; [esi + n] field_24, field_90, field_94, field_9c
# callees:      calls FUN_0050f978, FUN_0051d58b, FUN_0051c0c9, FUN_0051e7ba; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00523e94
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_24, 0x24  # offset +0x24
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_9c, 0x9c  # offset +0x9c
.equ field_c4, 0xc4  # offset +0xc4
.equ field_d4, 0xd4  # offset +0xd4

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051c0c9, .text + (0x0051c0c9 - 0x401000)
.set FUN_0051d58b, .text + (0x0051d58b - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00523dcf - 0x401000
.globl FUN_00523dcf
FUN_00523dcf:
    # block 0x00523dcf: entry, 17 instruction(s), calls FUN_0050f978, indirect dword ptr [eax + 0xd4], ends with je to 0x00523e71 (forward)
    mov eax, 0x528f6c                            # 00523dcf
    call FUN_0050f978                            # 00523dd4
    push ecx                                     # 00523dd9
    push ecx                                     # 00523dda
    push ebx                                     # 00523ddb
    push esi                                     # 00523ddc
    {load} mov esi, ecx                          # 00523ddd
    push edi                                     # 00523ddf
    mov eax, dword ptr [esi + field_94]          # 00523de0
    and dword ptr [esi + field_24], -0x41        # 00523de6
    mov dword ptr [ebp - field_minus_14], eax    # 00523dea
    mov eax, dword ptr [esi]                     # 00523ded
    call dword ptr [eax + field_d4]              # 00523def
    {load} mov ebx, eax                          # 00523df5
    {load} xor eax, eax                          # 00523df7
    {load} cmp ebx, eax                          # 00523df9
    je.d8 L_00523e71                             # 00523dfb
    # block 0x00523dfd: entered by fall-through of je at 0x00523dfb, 5 instruction(s), ends with je to 0x00523e16 (forward)
    mov ecx, dword ptr [0x5679b0]                # 00523dfd
    mov dword ptr [ebp - field_minus_10], ecx    # 00523e03
    cmp dword ptr [ebp + field_c], eax           # 00523e06
    mov dword ptr [ebp - field_minus_4], eax     # 00523e09
    je.d8 L_00523e16                             # 00523e0c
    # block 0x00523e0e: entered by fall-through of je at 0x00523e0c, 3 instruction(s), ends with forward jump to 0x00523e44
    mov eax, dword ptr [ebp + field_c]           # 00523e0e
    mov edi, dword ptr [ebp + field_8]           # 00523e11
    jmp.d8 L_00523e44                            # 00523e14
L_00523e16:
    # block 0x00523e16: entered by je at 0x00523e0c, 3 instruction(s), ends with je to 0x00523e44 (forward)
    mov edi, dword ptr [ebp + field_8]           # 00523e16
    {load} cmp edi, eax                          # 00523e19
    je.d8 L_00523e44                             # 00523e1b
    # block 0x00523e1d: entered by fall-through of je at 0x00523e1b, 2 instruction(s), ends with jne to 0x00523e32 (forward)
    cmp edi, 0xef06                              # 00523e1d
    jne.d8 L_00523e32                            # 00523e23
    # block 0x00523e25: entered by fall-through of jne at 0x00523e23, 2 instruction(s), ends with je to 0x00523e32 (forward)
    cmp dword ptr [esi + field_9c], eax          # 00523e25
    je.d8 L_00523e32                             # 00523e2b
    # block 0x00523e2d: entered by fall-through of je at 0x00523e2b, 1 instruction(s), falls into the block at 0x00523e32
    mov edi, 0xf005                              # 00523e2d
L_00523e32:
    # block 0x00523e32: entered by jne at 0x00523e23; je at 0x00523e2b, 7 instruction(s), calls indirect dword ptr [eax + 0xc4], falls into the block at 0x00523e44
    mov eax, dword ptr [esi]                     # 00523e32
    lea ecx, [ebp - field_minus_10]              # 00523e34
    push ecx                                     # 00523e37
    push edi                                     # 00523e38
    {load} mov ecx, esi                          # 00523e39
    call dword ptr [eax + field_c4]              # 00523e3b
    mov eax, dword ptr [ebp - field_minus_10]    # 00523e41
L_00523e44:
    # block 0x00523e44: entered by jmp at 0x00523e14; je at 0x00523e1b, 7 instruction(s), calls FUN_0051d58b, FUN_0051c0c9, ends with je to 0x00523e63 (forward)
    push eax                                     # 00523e44
    {load} mov ecx, ebx                          # 00523e45
    call FUN_0051d58b                            # 00523e47
    {load} mov ecx, ebx                          # 00523e4c
    call FUN_0051c0c9                            # 00523e4e
    test eax, eax                                # 00523e53
    je.d8 L_00523e63                             # 00523e55
    # block 0x00523e57: entered by fall-through of je at 0x00523e55, 2 instruction(s), falls into the block at 0x00523e63
    mov dword ptr [eax + field_94], edi          # 00523e57
    mov dword ptr [eax + field_90], edi          # 00523e5d
L_00523e63:
    # block 0x00523e63: entered by je at 0x00523e55, 4 instruction(s), calls FUN_0051e7ba, ends with forward jump to 0x00523e74
    or dword ptr [ebp - field_minus_4], -0x1     # 00523e63
    lea ecx, [ebp - field_minus_10]              # 00523e67
    call FUN_0051e7ba                            # 00523e6a
    jmp.d8 L_00523e74                            # 00523e6f
L_00523e71:
    # block 0x00523e71: entered by je at 0x00523dfb, 1 instruction(s), falls into the block at 0x00523e74
    mov edi, dword ptr [ebp + field_8]           # 00523e71
L_00523e74:
    # block 0x00523e74: entered by jmp at 0x00523e6f, 10 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - field_minus_c]     # 00523e74
    mov eax, dword ptr [ebp - field_minus_14]    # 00523e77
    mov dword ptr [esi + field_94], edi          # 00523e7a
    mov dword ptr [esi + field_90], edi          # 00523e80
    pop edi                                      # 00523e86
    pop esi                                      # 00523e87
    pop ebx                                      # 00523e88
    mov dword ptr fs:[0x0], ecx                  # 00523e89
    leave                                        # 00523e90
    ret 0x8                                      # 00523e91

