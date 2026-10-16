# FUN_00511f30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511f30
# extent:       0x00511f30-0x00511fab (123 code bytes)
# span:         0x00511f30-0x00511fab (code 123, tables 0, padding 0)
# sha256:       ee3a394138000e43710e1f46da55d9eed3240ac7510488da765689c5aea446c7
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511f30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_minus_1, field_minus_2, field_minus_3, field_minus_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_2, 0x2  # offset -0x2
.equ field_minus_3, 0x3  # offset -0x3
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00511f30 - 0x401000
.globl FUN_00511f30
FUN_00511f30:
    # block 0x00511f30: entry, 3 instruction(s), ends with je to 0x00511f50 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 00511f30
    test ecx, 0x3                                # 00511f34
    je.d8 L_00511f50                             # 00511f3a
L_00511f3c:
    # block 0x00511f3c: entered by jne at 0x00511f49; fall-through of je at 0x00511f3a, 4 instruction(s), ends with je to 0x00511f83 (forward)
    mov al, byte ptr [ecx]                       # 00511f3c
    inc ecx                                      # 00511f3e
    test al, al                                  # 00511f3f
    je.d8 L_00511f83                             # 00511f41
    # block 0x00511f43: entered by fall-through of je at 0x00511f41, 2 instruction(s), ends with jne to 0x00511f3c (backward)
    test ecx, 0x3                                # 00511f43
    jne.d8 L_00511f3c                            # 00511f49
    # block 0x00511f4b: entered by fall-through of jne at 0x00511f49, 1 instruction(s), falls into the block at 0x00511f50
    .insn 0x05, 0x00000000{:u32}                 # 00511f4b
L_00511f50:
    # block 0x00511f50: entered by je at 0x00511f3a; je at 0x00511f66; jmp at 0x00511f81, 8 instruction(s), ends with je to 0x00511f50 (backward)
    mov eax, dword ptr [ecx]                     # 00511f50
    mov edx, 0x7efefeff                          # 00511f52
    {load} add edx, eax                          # 00511f57
    xor eax, -0x1                                # 00511f59
    {load} xor eax, edx                          # 00511f5c
    add ecx, 0x4                                 # 00511f5e
    test eax, 0x81010100                         # 00511f61
    je.d8 L_00511f50                             # 00511f66
    # block 0x00511f68: entered by fall-through of je at 0x00511f66, 3 instruction(s), ends with je to 0x00511fa1 (forward)
    mov eax, dword ptr [ecx - field_minus_4]     # 00511f68
    test al, al                                  # 00511f6b
    je.d8 L_00511fa1                             # 00511f6d
    # block 0x00511f6f: entered by fall-through of je at 0x00511f6d, 2 instruction(s), ends with je to 0x00511f97 (forward)
    test ah, ah                                  # 00511f6f
    je.d8 L_00511f97                             # 00511f71
    # block 0x00511f73: entered by fall-through of je at 0x00511f71, 2 instruction(s), ends with je to 0x00511f8d (forward)
    test eax, 0xff0000                           # 00511f73
    je.d8 L_00511f8d                             # 00511f78
    # block 0x00511f7a: entered by fall-through of je at 0x00511f78, 2 instruction(s), ends with je to 0x00511f83 (forward)
    test eax, 0xff000000                         # 00511f7a
    je.d8 L_00511f83                             # 00511f7f
    # block 0x00511f81: entered by fall-through of je at 0x00511f7f, 1 instruction(s), ends with backward jump to 0x00511f50
    jmp.d8 L_00511f50                            # 00511f81
L_00511f83:
    # block 0x00511f83: entered by je at 0x00511f41; je at 0x00511f7f, 4 instruction(s), ends with ret
    lea eax, [ecx - field_minus_1]               # 00511f83
    mov ecx, dword ptr [esp + stk_4]             # 00511f86
    {load} sub eax, ecx                          # 00511f8a
    ret                                          # 00511f8c
L_00511f8d:
    # block 0x00511f8d: entered by je at 0x00511f78, 4 instruction(s), ends with ret
    lea eax, [ecx - field_minus_2]               # 00511f8d
    mov ecx, dword ptr [esp + stk_4]             # 00511f90
    {load} sub eax, ecx                          # 00511f94
    ret                                          # 00511f96
L_00511f97:
    # block 0x00511f97: entered by je at 0x00511f71, 4 instruction(s), ends with ret
    lea eax, [ecx - field_minus_3]               # 00511f97
    mov ecx, dword ptr [esp + stk_4]             # 00511f9a
    {load} sub eax, ecx                          # 00511f9e
    ret                                          # 00511fa0
L_00511fa1:
    # block 0x00511fa1: entered by je at 0x00511f6d, 4 instruction(s), ends with ret
    lea eax, [ecx - field_minus_4]               # 00511fa1
    mov ecx, dword ptr [esp + stk_4]             # 00511fa4
    {load} sub eax, ecx                          # 00511fa8
    ret                                          # 00511faa

