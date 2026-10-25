# FUN_0044bf14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bf14
# extent:       0x0044bf14-0x0044bf4b (55 code bytes)
# span:         0x0044bf14-0x0044bf4b (code 55, tables 0, padding 0)
# sha256:       5d5787f993cde9b790b660d3d3cdc08b4e0ffe1a4e51126338681b2c9789f1d6
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44bf14_lifted
# naming:       native port src/original_methods_fl40.c:m44bf14_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 5 seeds; oracle 21/21 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_8, local_c, local_10
# fields:       [eax + n] field_4; [edx + n] field_4
# callees:      calls FUN_0044bed5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44bf14_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0044bed5, .text + (0x0044bed5 - 0x401000)

.org 0x0044bf14 - 0x401000
.globl FUN_0044bf14
FUN_0044bf14:
    # block 0x0044bf14: entry, 21 instruction(s), calls FUN_0044bed5, ends with ret 0x8
    push ebp                                     # 0044bf14
    {load} mov ebp, esp                          # 0044bf15
    sub esp, 0x10                                # 0044bf17
    mov dword ptr [ebp - local_10], ecx          # 0044bf1a
    mov eax, dword ptr [ebp + arg_c]             # 0044bf1d
    mov ecx, dword ptr [ebp + arg_8]             # 0044bf20
    fld dword ptr [eax]                          # 0044bf23
    fsub dword ptr [ecx]                         # 0044bf25
    fstp dword ptr [ebp - local_c]               # 0044bf27
    mov edx, dword ptr [ebp + arg_c]             # 0044bf2a
    mov eax, dword ptr [ebp + arg_8]             # 0044bf2d
    fld dword ptr [edx + field_4]                # 0044bf30
    fsub dword ptr [eax + field_4]               # 0044bf33
    fstp dword ptr [ebp - local_8]               # 0044bf36
    lea ecx, [ebp - local_c]                     # 0044bf39
    push ecx                                     # 0044bf3c
    mov ecx, dword ptr [ebp - local_10]          # 0044bf3d
    call FUN_0044bed5                            # 0044bf40
    {load} mov esp, ebp                          # 0044bf45
    pop ebp                                      # 0044bf47
    ret 0x8                                      # 0044bf48

