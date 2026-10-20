# FUN_004faf98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004faf98
# extent:       0x004faf98-0x004fafc7 (47 code bytes)
# span:         0x004faf98-0x004fafc7 (code 47, tables 0, padding 0)
# sha256:       a97750f441e69af796c313f09e05e794286d0e2c3fc8cae8e53cc015c005aa4c
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4faf98_visit
# naming:       native port src/original_methods_fl16.c:m4faf98_visit (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4faf98_visit (0x4fadc4, then 0x4fb2e3 when it returns non-zero; both are Fl16Host callbacks, the word argument passed as 16 bits).
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fadc4, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4faf98_visit (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004fadc4, .text + (0x004fadc4 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004faf98 - 0x401000
.globl FUN_004faf98
FUN_004faf98:
    # block 0x004faf98: entry, 12 instruction(s), calls FUN_004fadc4, ends with je to 0x004fafc1 (forward)
    push ebp                                     # 004faf98
    {load} mov ebp, esp                          # 004faf99
    push ecx                                     # 004faf9b
    mov dword ptr [ebp - local_4], ecx           # 004faf9c
    mov ax, word ptr [ebp + arg_c]               # 004faf9f
    push eax                                     # 004fafa3
    mov ecx, dword ptr [ebp + arg_8]             # 004fafa4
    push ecx                                     # 004fafa7
    mov ecx, dword ptr [ebp - local_4]           # 004fafa8
    call FUN_004fadc4                            # 004fafab
    test eax, eax                                # 004fafb0
    je.d8 L_004fafc1                             # 004fafb2
    # block 0x004fafb4: entered by fall-through of je at 0x004fafb2, 4 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004fafc1
    mov dx, word ptr [ebp + arg_c]               # 004fafb4
    push edx                                     # 004fafb8
    mov ecx, dword ptr [ebp - local_4]           # 004fafb9
    call FUN_004fb2e3                            # 004fafbc
L_004fafc1:
    # block 0x004fafc1: entered by je at 0x004fafb2, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004fafc1
    pop ebp                                      # 004fafc3
    ret 0x8                                      # 004fafc4

