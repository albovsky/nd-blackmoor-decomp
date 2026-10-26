# FUN_004d57e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d57e8
# extent:       0x004d57e8-0x004d5834 (76 code bytes)
# span:         0x004d57e8-0x004d5834 (code 76, tables 0, padding 0)
# sha256:       e19dfa0996a8c563f3ba17ab721d418e540ec7f7378bb66c327033b75cd27a70
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d57e8_lifted
# naming:       native port src/original_methods_fl41.c:m4d57e8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 15 seeds; oracle: 30/30 instructions, 8/8 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d57e8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004d57e8 - 0x401000
.globl FUN_004d57e8
FUN_004d57e8:
    # block 0x004d57e8: entry, 9 instruction(s), ends with jl to 0x004d582c (forward)
    push ebp                                     # 004d57e8
    {load} mov ebp, esp                          # 004d57e9
    push ecx                                     # 004d57eb
    mov dword ptr [ebp - local_4], ecx           # 004d57ec
    mov eax, dword ptr [ebp + arg_8]             # 004d57ef
    mov ecx, dword ptr [ebp + arg_c]             # 004d57f2
    mov edx, dword ptr [eax]                     # 004d57f5
    cmp edx, dword ptr [ecx]                     # 004d57f7
    jl.d8 L_004d582c                             # 004d57f9
    # block 0x004d57fb: entered by fall-through of jl at 0x004d57f9, 5 instruction(s), ends with jg to 0x004d582c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d57fb
    mov ecx, dword ptr [ebp + arg_c]             # 004d57fe
    mov edx, dword ptr [eax + field_8]           # 004d5801
    cmp edx, dword ptr [ecx + field_8]           # 004d5804
    jg.d8 L_004d582c                             # 004d5807
    # block 0x004d5809: entered by fall-through of jg at 0x004d5807, 5 instruction(s), ends with jl to 0x004d582c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5809
    mov ecx, dword ptr [ebp + arg_c]             # 004d580c
    mov edx, dword ptr [eax + field_4]           # 004d580f
    cmp edx, dword ptr [ecx + field_4]           # 004d5812
    jl.d8 L_004d582c                             # 004d5815
    # block 0x004d5817: entered by fall-through of jl at 0x004d5815, 5 instruction(s), ends with jg to 0x004d582c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5817
    mov ecx, dword ptr [ebp + arg_c]             # 004d581a
    mov edx, dword ptr [eax + field_c]           # 004d581d
    cmp edx, dword ptr [ecx + field_c]           # 004d5820
    jg.d8 L_004d582c                             # 004d5823
    # block 0x004d5825: entered by fall-through of jg at 0x004d5823, 2 instruction(s), ends with forward jump to 0x004d582e
    mov eax, 0x1                                 # 004d5825
    jmp.d8 L_004d582e                            # 004d582a
L_004d582c:
    # block 0x004d582c: entered by jl at 0x004d57f9; jg at 0x004d5807; jl at 0x004d5815; jg at 0x004d5823, 1 instruction(s), falls into the block at 0x004d582e
    {load} xor eax, eax                          # 004d582c
L_004d582e:
    # block 0x004d582e: entered by jmp at 0x004d582a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004d582e
    pop ebp                                      # 004d5830
    ret 0x8                                      # 004d5831

