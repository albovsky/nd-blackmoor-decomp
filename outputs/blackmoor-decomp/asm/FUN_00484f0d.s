# FUN_00484f0d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484f0d
# extent:       0x00484f0d-0x00484f42 (53 code bytes)
# span:         0x00484f0d-0x00484f42 (code 53, tables 0, padding 0)
# sha256:       c79a9aef8da7071bd7a7489b72ab12802f5aecc36e3c8e8a2e2ccca68cd760ea
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         rect_valid
# naming:       native port src/action_family_ea_runtime.c:rect_valid (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with rect_valid (nonzero when both edge pairs differ). Native takes the body and a rectangle offset where the original takes a pointer.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_c; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:rect_valid (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00484f0d - 0x401000
.globl FUN_00484f0d
FUN_00484f0d:
    # block 0x00484f0d: entry, 10 instruction(s), ends with je to 0x00484f33 (forward)
    push ebp                                     # 00484f0d
    {load} mov ebp, esp                          # 00484f0e
    push ecx                                     # 00484f10
    mov dword ptr [ebp - local_4], ecx           # 00484f11
    mov eax, dword ptr [ebp + arg_8]             # 00484f14
    mov ecx, dword ptr [ebp + arg_8]             # 00484f17
    mov edx, dword ptr [eax + field_c]           # 00484f1a
    sub edx, dword ptr [ecx + field_4]           # 00484f1d
    test edx, edx                                # 00484f20
    je.d8 L_00484f33                             # 00484f22
    # block 0x00484f24: entered by fall-through of je at 0x00484f22, 6 instruction(s), ends with jne to 0x00484f37 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00484f24
    mov ecx, dword ptr [ebp + arg_8]             # 00484f27
    mov edx, dword ptr [eax + field_8]           # 00484f2a
    sub edx, dword ptr [ecx]                     # 00484f2d
    test edx, edx                                # 00484f2f
    jne.d8 L_00484f37                            # 00484f31
L_00484f33:
    # block 0x00484f33: entered by je at 0x00484f22; fall-through of jne at 0x00484f31, 2 instruction(s), ends with forward jump to 0x00484f3c
    {load} xor eax, eax                          # 00484f33
    jmp.d8 L_00484f3c                            # 00484f35
L_00484f37:
    # block 0x00484f37: entered by jne at 0x00484f31, 1 instruction(s), falls into the block at 0x00484f3c
    mov eax, 0x1                                 # 00484f37
L_00484f3c:
    # block 0x00484f3c: entered by jmp at 0x00484f35, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00484f3c
    pop ebp                                      # 00484f3e
    ret 0x4                                      # 00484f3f

