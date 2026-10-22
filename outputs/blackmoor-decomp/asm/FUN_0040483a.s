# FUN_0040483a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040483a
# extent:       0x0040483a-0x00404862 (40 code bytes)
# span:         0x0040483a-0x00404862 (code 40, tables 0, padding 0)
# sha256:       d6002bf6158270912fa44c66ea420b9b65ed534ed1e78092a6b5819986a29cd9
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40483a_lifted
# naming:       native port src/original_methods_fl40.c:m40483a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 12/12 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40483a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x0040483a - 0x401000
.globl FUN_0040483a
FUN_0040483a:
    # block 0x0040483a: entry, 12 instruction(s), calls FUN_004033db, ends with ret
    push ebp                                     # 0040483a
    {load} mov ebp, esp                          # 0040483b
    push ecx                                     # 0040483d
    mov dword ptr [ebp - local_4], ecx           # 0040483e
    mov eax, dword ptr [0x5c3a63]                # 00404841
    imul eax, eax, 0x106                         # 00404846
    mov dword ptr [eax + 0x5e569a], 0x1          # 0040484c
    mov ecx, dword ptr [ebp - local_4]           # 00404856
    call FUN_004033db                            # 00404859
    {load} mov esp, ebp                          # 0040485e
    pop ebp                                      # 00404860
    ret                                          # 00404861

