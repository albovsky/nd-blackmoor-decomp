# FUN_0040488a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040488a
# extent:       0x0040488a-0x004048b2 (40 code bytes)
# span:         0x0040488a-0x004048b2 (code 40, tables 0, padding 0)
# sha256:       417f33eaadb5ad1e45523d3743c16606affc7eee444e5856ca61b78eb068f781
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40488a_lifted
# naming:       native port src/original_methods_fl40.c:m40488a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 12/12 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40488a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x0040488a - 0x401000
.globl FUN_0040488a
FUN_0040488a:
    # block 0x0040488a: entry, 12 instruction(s), calls FUN_004033db, ends with ret
    push ebp                                     # 0040488a
    {load} mov ebp, esp                          # 0040488b
    push ecx                                     # 0040488d
    mov dword ptr [ebp - local_4], ecx           # 0040488e
    mov eax, dword ptr [0x5c3a63]                # 00404891
    imul eax, eax, 0x106                         # 00404896
    mov dword ptr [eax + 0x5e569a], 0x5          # 0040489c
    mov ecx, dword ptr [ebp - local_4]           # 004048a6
    call FUN_004033db                            # 004048a9
    {load} mov esp, ebp                          # 004048ae
    pop ebp                                      # 004048b0
    ret                                          # 004048b1

