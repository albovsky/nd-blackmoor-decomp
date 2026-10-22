# FUN_004041ec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004041ec
# extent:       0x004041ec-0x00404201 (21 code bytes)
# span:         0x004041ec-0x00404201 (code 21, tables 0, padding 0)
# sha256:       821e69d5931300865178ea1410a84cb35955cce731197605cac95d33fa56718d
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4041ec_lifted
# naming:       native port src/original_methods_fl40.c:m4041ec_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 9/9 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d940a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4041ec_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d940a, .text + (0x004d940a - 0x401000)

.org 0x004041ec - 0x401000
.globl FUN_004041ec
FUN_004041ec:
    # block 0x004041ec: entry, 9 instruction(s), calls FUN_004d940a, ends with ret
    push ebp                                     # 004041ec
    {load} mov ebp, esp                          # 004041ed
    push ecx                                     # 004041ef
    mov dword ptr [ebp - local_4], ecx           # 004041f0
    mov ecx, 0x5e2e70                            # 004041f3
    call FUN_004d940a                            # 004041f8
    {load} mov esp, ebp                          # 004041fd
    pop ebp                                      # 004041ff
    ret                                          # 00404200

