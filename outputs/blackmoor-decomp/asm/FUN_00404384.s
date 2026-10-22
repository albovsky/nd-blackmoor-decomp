# FUN_00404384
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404384
# extent:       0x00404384-0x004043b6 (50 code bytes)
# span:         0x00404384-0x004043b6 (code 50, tables 0, padding 0)
# sha256:       60d7f73b4d819cf898b0e0fa488933e0636a0594543c990b5ce61d6faa4d1b9d
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404384_lifted
# naming:       native port src/original_methods_fl40.c:m404384_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 14/14 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m404384_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x00404384 - 0x401000
.globl FUN_00404384
FUN_00404384:
    # block 0x00404384: entry, 6 instruction(s), ends with je to 0x004043a0 (forward)
    push ebp                                     # 00404384
    {load} mov ebp, esp                          # 00404385
    push ecx                                     # 00404387
    mov dword ptr [ebp - local_4], ecx           # 00404388
    cmp dword ptr [0x5ec342], 0x0                # 0040438b
    je.d8 L_004043a0                             # 00404392
    # block 0x00404394: entered by fall-through of je at 0x00404392, 2 instruction(s), ends with forward jump to 0x004043aa
    mov dword ptr [0x5ec342], 0x0                # 00404394
    jmp.d8 L_004043aa                            # 0040439e
L_004043a0:
    # block 0x004043a0: entered by je at 0x00404392, 1 instruction(s), falls into the block at 0x004043aa
    mov dword ptr [0x5ec342], 0x1                # 004043a0
L_004043aa:
    # block 0x004043aa: entered by jmp at 0x0040439e, 5 instruction(s), calls FUN_004033db, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004043aa
    call FUN_004033db                            # 004043ad
    {load} mov esp, ebp                          # 004043b2
    pop ebp                                      # 004043b4
    ret                                          # 004043b5

