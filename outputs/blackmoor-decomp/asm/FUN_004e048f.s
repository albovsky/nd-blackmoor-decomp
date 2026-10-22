# FUN_004e048f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e048f
# extent:       0x004e048f-0x004e04f3 (100 code bytes)
# span:         0x004e048f-0x004e04f3 (code 100, tables 0, padding 0)
# sha256:       3f2de8ad9fdc67e19543038a0664a0eb921089a45d97920a481a339e2b87dcbe
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e048f_lifted
# naming:       native port src/original_methods_fl41.c:m4e048f_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 27/27 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e0619, FUN_0050cba8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4e048f_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e0619, .text + (0x004e0619 - 0x401000)
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x004e048f - 0x401000
.globl FUN_004e048f
FUN_004e048f:
    # block 0x004e048f: entry, 27 instruction(s), calls FUN_004e0619, FUN_0050cba8, ends with ret
    push ebp                                     # 004e048f
    {load} mov ebp, esp                          # 004e0490
    push -0x1                                    # 004e0492
    push 0x528990                                # 004e0494
    mov eax, dword ptr fs:[0x0]                  # 004e0499
    push eax                                     # 004e049f
    mov dword ptr fs:[0x0], esp                  # 004e04a0
    push ecx                                     # 004e04a7
    mov dword ptr [ebp - local_10], ecx          # 004e04a8
    mov eax, dword ptr [ebp - local_10]          # 004e04ab
    mov dword ptr [eax], 0x52e4e4                # 004e04ae
    mov dword ptr [ebp - local_4], 0x0           # 004e04b4
    mov ecx, dword ptr [ebp - local_10]          # 004e04bb
    call FUN_004e0619                            # 004e04be
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e04c3
    push 0x4e1c83                                # 004e04ca
    push 0x5                                     # 004e04cf
    push 0x18f                                   # 004e04d1
    mov ecx, dword ptr [ebp - local_10]          # 004e04d6
    add ecx, 0x757                               # 004e04d9
    push ecx                                     # 004e04df
    call FUN_0050cba8                            # 004e04e0
    mov ecx, dword ptr [ebp - local_c]           # 004e04e5
    mov dword ptr fs:[0x0], ecx                  # 004e04e8
    {load} mov esp, ebp                          # 004e04ef
    pop ebp                                      # 004e04f1
    ret                                          # 004e04f2

