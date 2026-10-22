# FUN_004d794d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d794d
# extent:       0x004d794d-0x004d79c7 (122 code bytes)
# span:         0x004d794d-0x004d79c7 (code 122, tables 0, padding 0)
# sha256:       c0c7479d0a14c1f5a40daa30834d0dcbe9ac2f900eee1b238ad30b6b47a5471e
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d794d_lifted
# naming:       native port src/original_methods_fl39d.c:m4d794d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (250 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_955e
# callees:      calls FUN_004d79c7, FUN_004db870
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d794d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_955e, 0x955e  # offset +0x955e

# --- external targets -----------------------------------------------
.set FUN_004d79c7, .text + (0x004d79c7 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)

.org 0x004d794d - 0x401000
.globl FUN_004d794d
FUN_004d794d:
    # block 0x004d794d: entry, 11 instruction(s), calls FUN_004d79c7, ends with jne to 0x004d7991 (forward)
    push ebp                                     # 004d794d
    {load} mov ebp, esp                          # 004d794e
    push ecx                                     # 004d7950
    mov dword ptr [ebp - local_4], ecx           # 004d7951
    mov ecx, dword ptr [ebp - local_4]           # 004d7954
    call FUN_004d79c7                            # 004d7957
    mov eax, dword ptr [0x583985]                # 004d795c
    mov dword ptr [0x583981], eax                # 004d7961
    mov ecx, dword ptr [ebp - local_4]           # 004d7966
    cmp dword ptr [ecx + field_955e], 0x0        # 004d7969
    jne.d8 L_004d7991                            # 004d7970
    # block 0x004d7972: entered by fall-through of jne at 0x004d7970, 2 instruction(s), ends with je to 0x004d7991 (forward)
    cmp dword ptr [0x5bb1e2], 0x0                # 004d7972
    je.d8 L_004d7991                             # 004d7979
    # block 0x004d797b: entered by fall-through of je at 0x004d7979, 4 instruction(s), calls FUN_004db870, ends with forward jump to 0x004d79b9
    mov dword ptr [0x583981], 0xe                # 004d797b
    mov ecx, 0x5830ce                            # 004d7985
    call FUN_004db870                            # 004d798a
    jmp.d8 L_004d79b9                            # 004d798f
L_004d7991:
    # block 0x004d7991: entered by jne at 0x004d7970; je at 0x004d7979, 2 instruction(s), ends with jne to 0x004d79a6 (forward)
    cmp dword ptr [0x583985], 0x6                # 004d7991
    jne.d8 L_004d79a6                            # 004d7998
    # block 0x004d799a: entered by fall-through of jne at 0x004d7998, 2 instruction(s), ends with forward jump to 0x004d79b9
    mov dword ptr [0x5839a1], 0x0                # 004d799a
    jmp.d8 L_004d79b9                            # 004d79a4
L_004d79a6:
    # block 0x004d79a6: entered by jne at 0x004d7998, 2 instruction(s), ends with jne to 0x004d79b9 (forward)
    cmp dword ptr [0x583985], 0xe                # 004d79a6
    jne.d8 L_004d79b9                            # 004d79ad
    # block 0x004d79af: entered by fall-through of jne at 0x004d79ad, 2 instruction(s), calls FUN_004db870, falls into the block at 0x004d79b9
    mov ecx, 0x5830ce                            # 004d79af
    call FUN_004db870                            # 004d79b4
L_004d79b9:
    # block 0x004d79b9: entered by jmp at 0x004d798f; jmp at 0x004d79a4; jne at 0x004d79ad, 4 instruction(s), ends with ret
    mov dword ptr [0x583985], 0x7                # 004d79b9
    {load} mov esp, ebp                          # 004d79c3
    pop ebp                                      # 004d79c5
    ret                                          # 004d79c6

