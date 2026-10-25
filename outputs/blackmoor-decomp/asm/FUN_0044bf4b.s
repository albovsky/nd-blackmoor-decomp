# FUN_0044bf4b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044bf4b
# extent:       0x0044bf4b-0x0044bf8b (64 code bytes)
# span:         0x0044bf4b-0x0044bf8b (code 64, tables 0, padding 0)
# sha256:       5e6d96c946131c73fe040d4dbc95ce9f9577c4795d7f4bc64800a144b05007bf
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44bf4b_lifted
# naming:       native port src/original_methods_fl40.c:m44bf4b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 23/23 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [ecx + n] field_4
# callees:      calls FUN_0044bed5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44bf4b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044bed5, .text + (0x0044bed5 - 0x401000)

.org 0x0044bf4b - 0x401000
.globl FUN_0044bf4b
FUN_0044bf4b:
    # block 0x0044bf4b: entry, 23 instruction(s), calls FUN_0044bed5, ends with ret 0x4
    push ebp                                     # 0044bf4b
    {load} mov ebp, esp                          # 0044bf4c
    sub esp, 0x8                                 # 0044bf4e
    mov dword ptr [ebp - local_8], ecx           # 0044bf51
    mov eax, dword ptr [ebp + arg_8]             # 0044bf54
    push eax                                     # 0044bf57
    mov ecx, dword ptr [ebp - local_8]           # 0044bf58
    call FUN_0044bed5                            # 0044bf5b
    fdivr dword ptr [0x52cbf4]                   # 0044bf60
    fstp dword ptr [ebp - local_4]               # 0044bf66
    mov ecx, dword ptr [ebp + arg_8]             # 0044bf69
    fld dword ptr [ebp - local_4]                # 0044bf6c
    fmul dword ptr [ecx]                         # 0044bf6f
    mov edx, dword ptr [ebp + arg_8]             # 0044bf71
    fstp dword ptr [edx]                         # 0044bf74
    mov eax, dword ptr [ebp + arg_8]             # 0044bf76
    fld dword ptr [ebp - local_4]                # 0044bf79
    fmul dword ptr [eax + field_4]               # 0044bf7c
    mov ecx, dword ptr [ebp + arg_8]             # 0044bf7f
    fstp dword ptr [ecx + field_4]               # 0044bf82
    {load} mov esp, ebp                          # 0044bf85
    pop ebp                                      # 0044bf87
    ret 0x4                                      # 0044bf88

