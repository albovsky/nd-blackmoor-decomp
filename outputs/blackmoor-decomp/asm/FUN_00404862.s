# FUN_00404862
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404862
# extent:       0x00404862-0x0040488a (40 code bytes)
# span:         0x00404862-0x0040488a (code 40, tables 0, padding 0)
# sha256:       ecb8f339d38610482e8a5ac0862720fd707ac72a4ec754a2554f68d107694788
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404862_lifted
# naming:       native port src/original_methods_fl40.c:m404862_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 2 seeds; oracle 12/12 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m404862_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x00404862 - 0x401000
.globl FUN_00404862
FUN_00404862:
    # block 0x00404862: entry, 12 instruction(s), calls FUN_004033db, ends with ret
    push ebp                                     # 00404862
    {load} mov ebp, esp                          # 00404863
    push ecx                                     # 00404865
    mov dword ptr [ebp - local_4], ecx           # 00404866
    mov eax, dword ptr [0x5c3a63]                # 00404869
    imul eax, eax, 0x106                         # 0040486e
    mov dword ptr [eax + 0x5e569a], 0x2          # 00404874
    mov ecx, dword ptr [ebp - local_4]           # 0040487e
    call FUN_004033db                            # 00404881
    {load} mov esp, ebp                          # 00404886
    pop ebp                                      # 00404888
    ret                                          # 00404889

