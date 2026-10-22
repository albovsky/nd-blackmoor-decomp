# FUN_00404186
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404186
# extent:       0x00404186-0x004041a3 (29 code bytes)
# span:         0x00404186-0x004041a3 (code 29, tables 0, padding 0)
# sha256:       410ae617477bf987d5a7d8057fb05122bda5f02437e0c269f9eddca59dcb6a52
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404186_lifted
# naming:       native port src/original_methods_fl40.c:m404186_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 11/11 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d9302, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m404186_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_004d9302, .text + (0x004d9302 - 0x401000)

.org 0x00404186 - 0x401000
.globl FUN_00404186
FUN_00404186:
    # block 0x00404186: entry, 11 instruction(s), calls FUN_004d9302, FUN_004033db, ends with ret
    push ebp                                     # 00404186
    {load} mov ebp, esp                          # 00404187
    push ecx                                     # 00404189
    mov dword ptr [ebp - local_4], ecx           # 0040418a
    mov ecx, 0x5e2e70                            # 0040418d
    call FUN_004d9302                            # 00404192
    mov ecx, dword ptr [ebp - local_4]           # 00404197
    call FUN_004033db                            # 0040419a
    {load} mov esp, ebp                          # 0040419f
    pop ebp                                      # 004041a1
    ret                                          # 004041a2

