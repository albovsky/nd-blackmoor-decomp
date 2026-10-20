# FUN_0042405a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042405a
# extent:       0x0042405a-0x0042406d (19 code bytes)
# span:         0x0042405a-0x0042406d (code 19, tables 0, padding 0)
# sha256:       51f1992473768cb6d2376d96f02e4cda78712549273f0f11d78eb513db92fcc6
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42405a_get_control
# naming:       native port src/original_methods_fl17.c:m42405a_get_control (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m42405a_get_control; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 19 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_30
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m42405a_get_control (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x0042405a - 0x401000
.globl FUN_0042405a
FUN_0042405a:
    # block 0x0042405a: entry, 9 instruction(s), ends with ret 0x4
    push ebp                                     # 0042405a
    {load} mov ebp, esp                          # 0042405b
    push ecx                                     # 0042405d
    mov dword ptr [ebp - local_4], ecx           # 0042405e
    mov eax, dword ptr [ebp + arg_8]             # 00424061
    mov eax, dword ptr [eax + field_30]          # 00424064
    {load} mov esp, ebp                          # 00424067
    pop ebp                                      # 00424069
    ret 0x4                                      # 0042406a

