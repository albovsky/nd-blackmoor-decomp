# FUN_004473a9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004473a9
# extent:       0x004473a9-0x004473be (21 code bytes)
# span:         0x004473a9-0x004473be (code 21, tables 0, padding 0)
# sha256:       6538b99e98624c3656a55548f59ae5d77e7a20de0886945c7065af44a12602b8
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         effect_reset_stage
# naming:       native port src/action_family_28.c:effect_reset_stage (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Extracted from action_family28_step phase 0 here: stores 0 in the stage word (+0x2d). A-28 dispatcher and binding oracles compare the world, 0 mismatches; test seeds 123 and expects 0.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2d
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_28.c:effect_reset_stage (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2d, 0x2d  # offset +0x2d

# --- external targets -----------------------------------------------

.org 0x004473a9 - 0x401000
.globl FUN_004473a9
FUN_004473a9:
    # block 0x004473a9: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004473a9
    {load} mov ebp, esp                          # 004473aa
    push ecx                                     # 004473ac
    mov dword ptr [ebp - local_4], ecx           # 004473ad
    mov eax, dword ptr [ebp - local_4]           # 004473b0
    mov dword ptr [eax + field_2d], 0x0          # 004473b3
    {load} mov esp, ebp                          # 004473ba
    pop ebp                                      # 004473bc
    ret                                          # 004473bd

