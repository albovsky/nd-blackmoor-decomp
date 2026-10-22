# FUN_004bf8a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf8a7
# extent:       0x004bf8a7-0x004bf8c2 (27 code bytes)
# span:         0x004bf8a7-0x004bf8c2 (code 27, tables 0, padding 0)
# sha256:       a71e3f3d3547b58a2b49ba9021541bf47ac0392a83cbc1a7ce968d1f0ea8d45a
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf8a7_lifted
# naming:       native port src/original_methods_fl39d.c:m4bf8a7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bf773, FUN_004bf63b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4bf8a7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004bf63b, .text + (0x004bf63b - 0x401000)
.set FUN_004bf773, .text + (0x004bf773 - 0x401000)

.org 0x004bf8a7 - 0x401000
.globl FUN_004bf8a7
FUN_004bf8a7:
    # block 0x004bf8a7: entry, 11 instruction(s), calls FUN_004bf773, FUN_004bf63b, ends with ret
    push ebp                                     # 004bf8a7
    {load} mov ebp, esp                          # 004bf8a8
    push ecx                                     # 004bf8aa
    mov dword ptr [ebp - local_4], ecx           # 004bf8ab
    mov ecx, dword ptr [ebp - local_4]           # 004bf8ae
    call FUN_004bf773                            # 004bf8b1
    mov ecx, dword ptr [ebp - local_4]           # 004bf8b6
    call FUN_004bf63b                            # 004bf8b9
    {load} mov esp, ebp                          # 004bf8be
    pop ebp                                      # 004bf8c0
    ret                                          # 004bf8c1

