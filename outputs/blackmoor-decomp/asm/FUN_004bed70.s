# FUN_004bed70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bed70
# extent:       0x004bed70-0x004bed99 (41 code bytes)
# span:         0x004bed70-0x004bed99 (code 41, tables 0, padding 0)
# sha256:       612d37ef016846dec1e61e83ab5b71f6c5afb4af81c940dbddf0a3651b455b00
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bed70_lifted
# naming:       native port src/original_methods_fl39d.c:m4bed70_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_4
# callees:      calls FUN_004bedb5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4bed70_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_004bedb5, .text + (0x004bedb5 - 0x401000)

.org 0x004bed70 - 0x401000
.globl FUN_004bed70
FUN_004bed70:
    # block 0x004bed70: entry, 14 instruction(s), calls FUN_004bedb5, ends with ret
    push ebp                                     # 004bed70
    {load} mov ebp, esp                          # 004bed71
    push ecx                                     # 004bed73
    mov dword ptr [ebp - local_4], ecx           # 004bed74
    mov eax, dword ptr [ebp - local_4]           # 004bed77
    mov dword ptr [eax], 0x52e210                # 004bed7a
    mov ecx, dword ptr [ebp - local_4]           # 004bed80
    mov dword ptr [ecx + field_4], 0xffffffff    # 004bed83
    mov ecx, dword ptr [ebp - local_4]           # 004bed8a
    call FUN_004bedb5                            # 004bed8d
    mov eax, dword ptr [ebp - local_4]           # 004bed92
    {load} mov esp, ebp                          # 004bed95
    pop ebp                                      # 004bed97
    ret                                          # 004bed98

