# FUN_00422970
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00422970
# extent:       0x00422970-0x004229b5 (69 code bytes)
# span:         0x00422970-0x004229b5 (code 69, tables 0, padding 0)
# sha256:       75d3362ef8d75eab01e531fcaff9a4c833d880487c621aed8a9bed70c5e4635a
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cel_set_target
# naming:       native port src/action_family_3f_runtime.c:cel_set_target (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Extracted from cel_advance and phase1 (no behaviour change): target = frame, final_seen = 1 once last <= target. RT-25 oracle (878 scenarios, 0 mismatches) compares both; unused stack arg dropped.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_782; [ecx + n] field_69c, field_784; [edx + n] field_6a4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_set_target (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_69c, 0x69c  # offset +0x69c
.equ field_6a4, 0x6a4  # offset +0x6a4
.equ field_782, 0x782  # offset +0x782
.equ field_784, 0x784  # offset +0x784

# --- external targets -----------------------------------------------

.org 0x00422970 - 0x401000
.globl FUN_00422970
FUN_00422970:
    # block 0x00422970: entry, 14 instruction(s), ends with jl to 0x004229af (forward)
    push ebp                                     # 00422970
    {load} mov ebp, esp                          # 00422971
    push ecx                                     # 00422973
    mov dword ptr [ebp - local_4], ecx           # 00422974
    mov eax, dword ptr [ebp - local_4]           # 00422977
    mov ecx, dword ptr [ebp - local_4]           # 0042297a
    mov dx, word ptr [ecx + field_69c]           # 0042297d
    mov word ptr [eax + field_782], dx           # 00422984
    mov eax, dword ptr [ebp - local_4]           # 0042298b
    movsx ecx, word ptr [eax + field_782]        # 0042298e
    mov edx, dword ptr [ebp - local_4]           # 00422995
    movsx eax, word ptr [edx + field_6a4]        # 00422998
    {load} cmp ecx, eax                          # 0042299f
    jl.d8 L_004229af                             # 004229a1
    # block 0x004229a3: entered by fall-through of jl at 0x004229a1, 2 instruction(s), falls into the block at 0x004229af
    mov ecx, dword ptr [ebp - local_4]           # 004229a3
    mov word ptr [ecx + field_784], 0x1          # 004229a6
L_004229af:
    # block 0x004229af: entered by jl at 0x004229a1, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004229af
    pop ebp                                      # 004229b1
    ret 0x4                                      # 004229b2

