# FUN_0044f650
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f650
# extent:       0x0044f650-0x0044f66f (31 code bytes)
# span:         0x0044f650-0x0044f66f (code 31, tables 0, padding 0)
# sha256:       a8e7055da85e8bd4d359d2303e82906e0cfff44272bf216a144d262e04d589d2
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44f650_init_vtable_call_ret_self
# naming:       native port src/original_methods_fl36c.c:m44f650_init_vtable_call_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cd10u at [this], calls 0x44f68b(this), returns this. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044f68b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m44f650_init_vtable_call_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044f68b, .text + (0x0044f68b - 0x401000)

.org 0x0044f650 - 0x401000
.globl FUN_0044f650
FUN_0044f650:
    # block 0x0044f650: entry, 12 instruction(s), calls FUN_0044f68b, ends with ret
    push ebp                                     # 0044f650
    {load} mov ebp, esp                          # 0044f651
    push ecx                                     # 0044f653
    mov dword ptr [ebp - local_4], ecx           # 0044f654
    mov eax, dword ptr [ebp - local_4]           # 0044f657
    mov dword ptr [eax], 0x52cd10                # 0044f65a
    mov ecx, dword ptr [ebp - local_4]           # 0044f660
    call FUN_0044f68b                            # 0044f663
    mov eax, dword ptr [ebp - local_4]           # 0044f668
    {load} mov esp, ebp                          # 0044f66b
    pop ebp                                      # 0044f66d
    ret                                          # 0044f66e

