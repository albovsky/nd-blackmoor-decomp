# FUN_00426346
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426346
# extent:       0x00426346-0x00426367 (33 code bytes)
# span:         0x00426346-0x00426367 (code 33, tables 0, padding 0)
# sha256:       00299b72f7016b8b5193177bcecd0a68cf52669cdd416e7643b3a05dda63e6a3
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m426346_lifted
# naming:       native port src/original_methods_fl40.c:m426346_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 14/14 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426346_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00426346 - 0x401000
.globl FUN_00426346
FUN_00426346:
    # block 0x00426346: entry, 14 instruction(s), calls FUN_0051dc6c, ends with ret
    push ebp                                     # 00426346
    {load} mov ebp, esp                          # 00426347
    sub esp, 0x8                                 # 00426349
    mov dword ptr [ebp - local_8], ecx           # 0042634c
    mov eax, dword ptr [ebp - local_8]           # 0042634f
    mov ecx, dword ptr [eax]                     # 00426352
    mov dword ptr [ebp - local_4], ecx           # 00426354
    mov edx, dword ptr [ebp - local_4]           # 00426357
    push edx                                     # 0042635a
    call FUN_0051dc6c                            # 0042635b
    add esp, 0x4                                 # 00426360
    {load} mov esp, ebp                          # 00426363
    pop ebp                                      # 00426365
    ret                                          # 00426366

