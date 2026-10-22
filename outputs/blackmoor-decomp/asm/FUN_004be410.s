# FUN_004be410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be410
# extent:       0x004be410-0x004be44d (61 code bytes)
# span:         0x004be410-0x004be44d (code 61, tables 0, padding 0)
# sha256:       563157044b23efbc58517f9bafdb808f5c72fb020a47e0ba819d32bf386ffbd7
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4be410_check_bytes
# naming:       native port src/original_methods_fl39c.c:m4be410_check_bytes (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Compares the nine bytes at [self+0x34d] with the nine at 0x552158 (repe cmpsb, stops at the first difference); when they differ calls 0x4fb2e3(word [self+0x36e]) on 0x5c3a67. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_36e
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4be410_check_bytes (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_36e, 0x36e  # offset +0x36e

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004be410 - 0x401000
.globl FUN_004be410
FUN_004be410:
    # block 0x004be410: entry, 13 instruction(s), ends with je to 0x004be447 (forward)
    push ebp                                     # 004be410
    {load} mov ebp, esp                          # 004be411
    push ecx                                     # 004be413
    push esi                                     # 004be414
    push edi                                     # 004be415
    mov dword ptr [ebp - local_4], ecx           # 004be416
    mov edi, 0x552158                            # 004be419
    mov esi, dword ptr [ebp - local_4]           # 004be41e
    add esi, 0x34d                               # 004be421
    mov ecx, 0x9                                 # 004be427
    {load} xor eax, eax                          # 004be42c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004be42e
    je.d8 L_004be447                             # 004be430
    # block 0x004be432: entered by fall-through of je at 0x004be430, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004be447
    mov ecx, dword ptr [ebp - local_4]           # 004be432
    mov dx, word ptr [ecx + field_36e]           # 004be435
    push edx                                     # 004be43c
    mov ecx, 0x5c3a67                            # 004be43d
    call FUN_004fb2e3                            # 004be442
L_004be447:
    # block 0x004be447: entered by je at 0x004be430, 5 instruction(s), ends with ret
    pop edi                                      # 004be447
    pop esi                                      # 004be448
    {load} mov esp, ebp                          # 004be449
    pop ebp                                      # 004be44b
    ret                                          # 004be44c

