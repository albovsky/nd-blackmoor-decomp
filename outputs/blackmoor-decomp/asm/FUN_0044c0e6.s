# FUN_0044c0e6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c0e6
# extent:       0x0044c0e6-0x0044c114 (46 code bytes)
# span:         0x0044c0e6-0x0044c114 (code 46, tables 0, padding 0)
# sha256:       041cc06cce6815098fdc295786289c6e9fd1ddb1fa2101f177ced4826e52192c
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44c0e6_lifted
# naming:       native port src/original_methods_fl40.c:m44c0e6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 19/19 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_4; [edx + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44c0e6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0044c0e6 - 0x401000
.globl FUN_0044c0e6
FUN_0044c0e6:
    # block 0x0044c0e6: entry, 19 instruction(s), ends with ret 0xc
    push ebp                                     # 0044c0e6
    {load} mov ebp, esp                          # 0044c0e7
    push ecx                                     # 0044c0e9
    mov dword ptr [ebp - local_4], ecx           # 0044c0ea
    mov eax, dword ptr [ebp + arg_8]             # 0044c0ed
    mov ecx, dword ptr [ebp + arg_c]             # 0044c0f0
    fld dword ptr [eax]                          # 0044c0f3
    fsub dword ptr [ecx]                         # 0044c0f5
    mov edx, dword ptr [ebp + arg_10]            # 0044c0f7
    fstp dword ptr [edx]                         # 0044c0fa
    mov eax, dword ptr [ebp + arg_8]             # 0044c0fc
    mov ecx, dword ptr [ebp + arg_c]             # 0044c0ff
    fld dword ptr [eax + field_4]                # 0044c102
    fsub dword ptr [ecx + field_4]               # 0044c105
    mov edx, dword ptr [ebp + arg_10]            # 0044c108
    fstp dword ptr [edx + field_4]               # 0044c10b
    {load} mov esp, ebp                          # 0044c10e
    pop ebp                                      # 0044c110
    ret 0xc                                      # 0044c111

