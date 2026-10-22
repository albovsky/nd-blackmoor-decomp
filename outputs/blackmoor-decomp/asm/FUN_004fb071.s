# FUN_004fb071
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb071
# extent:       0x004fb071-0x004fb086 (21 code bytes)
# span:         0x004fb071-0x004fb086 (code 21, tables 0, padding 0)
# sha256:       54c16bbab2ab5989494f2374b1998e66df8cbaf0e63088aa817929d37078ead9
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fb071_lifted
# naming:       native port src/original_methods_fl39d.c:m4fb071_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fc808
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4fb071_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)

.org 0x004fb071 - 0x401000
.globl FUN_004fb071
FUN_004fb071:
    # block 0x004fb071: entry, 10 instruction(s), calls FUN_004fc808, ends with ret
    push ebp                                     # 004fb071
    {load} mov ebp, esp                          # 004fb072
    push ecx                                     # 004fb074
    mov dword ptr [ebp - local_4], ecx           # 004fb075
    push 0x0                                     # 004fb078
    mov ecx, dword ptr [ebp - local_4]           # 004fb07a
    call FUN_004fc808                            # 004fb07d
    {load} mov esp, ebp                          # 004fb082
    pop ebp                                      # 004fb084
    ret                                          # 004fb085

