# FUN_004d5834
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5834
# extent:       0x004d5834-0x004d5880 (76 code bytes)
# span:         0x004d5834-0x004d5880 (code 76, tables 0, padding 0)
# sha256:       0ea0706fd6d6ad590c8a06f4569fd803362ea5ccca374ef8b64a8780d069e30e
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d5834_lifted
# naming:       native port src/original_methods_fl39d.c:m4d5834_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (16 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d5834_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x004d5834 - 0x401000
.globl FUN_004d5834
FUN_004d5834:
    # block 0x004d5834: entry, 9 instruction(s), ends with jl to 0x004d5871 (forward)
    push ebp                                     # 004d5834
    {load} mov ebp, esp                          # 004d5835
    push ecx                                     # 004d5837
    mov dword ptr [ebp - local_4], ecx           # 004d5838
    mov eax, dword ptr [ebp + arg_8]             # 004d583b
    mov ecx, dword ptr [ebp + arg_c]             # 004d583e
    mov edx, dword ptr [eax + field_8]           # 004d5841
    cmp edx, dword ptr [ecx]                     # 004d5844
    jl.d8 L_004d5871                             # 004d5846
    # block 0x004d5848: entered by fall-through of jl at 0x004d5846, 5 instruction(s), ends with jg to 0x004d5871 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5848
    mov ecx, dword ptr [ebp + arg_c]             # 004d584b
    mov edx, dword ptr [eax]                     # 004d584e
    cmp edx, dword ptr [ecx + field_8]           # 004d5850
    jg.d8 L_004d5871                             # 004d5853
    # block 0x004d5855: entered by fall-through of jg at 0x004d5853, 5 instruction(s), ends with jl to 0x004d5871 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5855
    mov ecx, dword ptr [ebp + arg_c]             # 004d5858
    mov edx, dword ptr [eax + field_c]           # 004d585b
    cmp edx, dword ptr [ecx + field_4]           # 004d585e
    jl.d8 L_004d5871                             # 004d5861
    # block 0x004d5863: entered by fall-through of jl at 0x004d5861, 5 instruction(s), ends with jle to 0x004d5878 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d5863
    mov ecx, dword ptr [ebp + arg_c]             # 004d5866
    mov edx, dword ptr [eax + field_4]           # 004d5869
    cmp edx, dword ptr [ecx + field_c]           # 004d586c
    jle.d8 L_004d5878                            # 004d586f
L_004d5871:
    # block 0x004d5871: entered by jl at 0x004d5846; jg at 0x004d5853; jl at 0x004d5861; fall-through of jle at 0x004d586f, 2 instruction(s), ends with forward jump to 0x004d587a
    mov eax, 0x1                                 # 004d5871
    jmp.d8 L_004d587a                            # 004d5876
L_004d5878:
    # block 0x004d5878: entered by jle at 0x004d586f, 1 instruction(s), falls into the block at 0x004d587a
    {load} xor eax, eax                          # 004d5878
L_004d587a:
    # block 0x004d587a: entered by jmp at 0x004d5876, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004d587a
    pop ebp                                      # 004d587c
    ret 0x8                                      # 004d587d

