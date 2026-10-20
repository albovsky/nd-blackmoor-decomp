# FUN_004eb96e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb96e
# extent:       0x004eb96e-0x004eb9c8 (90 code bytes)
# span:         0x004eb96e-0x004eb9c8 (code 90, tables 0, padding 0)
# sha256:       fe96ae0e13e254c9da42f2d1457d19a597235dc0651c012e7f33b17782da77cf
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4eb96e_close
# naming:       native port src/original_methods_fl17.c:m4eb96e_close (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4eb96e_close; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 90 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edb97, FUN_004eba54, FUN_004d36ed, FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4eb96e_close (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004eba54, .text + (0x004eba54 - 0x401000)
.set FUN_004edb97, .text + (0x004edb97 - 0x401000)

.org 0x004eb96e - 0x401000
.globl FUN_004eb96e
FUN_004eb96e:
    # block 0x004eb96e: entry, 12 instruction(s), calls FUN_004edb97, FUN_004eba54, FUN_004d36ed, ends with je to 0x004eb9ac (forward)
    push ebp                                     # 004eb96e
    {load} mov ebp, esp                          # 004eb96f
    push ecx                                     # 004eb971
    mov dword ptr [ebp - local_4], ecx           # 004eb972
    mov ecx, dword ptr [ebp - local_4]           # 004eb975
    call FUN_004edb97                            # 004eb978
    mov ecx, dword ptr [ebp - local_4]           # 004eb97d
    call FUN_004eba54                            # 004eb980
    mov dword ptr [0x583204], 0x0                # 004eb985
    call FUN_004d36ed                            # 004eb98f
    cmp dword ptr [0x5d03a3], 0x0                # 004eb994
    je.d8 L_004eb9ac                             # 004eb99b
    # block 0x004eb99d: entered by fall-through of je at 0x004eb99b, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004eb9ac
    push 0x5d03a3                                # 004eb99d
    mov ecx, 0x5cf659                            # 004eb9a2
    call FUN_004c2dfb                            # 004eb9a7
L_004eb9ac:
    # block 0x004eb9ac: entered by je at 0x004eb99b, 2 instruction(s), ends with je to 0x004eb9c4 (forward)
    cmp dword ptr [0x5d03a7], 0x0                # 004eb9ac
    je.d8 L_004eb9c4                             # 004eb9b3
    # block 0x004eb9b5: entered by fall-through of je at 0x004eb9b3, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004eb9c4
    push 0x5d03a7                                # 004eb9b5
    mov ecx, 0x5cf659                            # 004eb9ba
    call FUN_004c2dfb                            # 004eb9bf
L_004eb9c4:
    # block 0x004eb9c4: entered by je at 0x004eb9b3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004eb9c4
    pop ebp                                      # 004eb9c6
    ret                                          # 004eb9c7

