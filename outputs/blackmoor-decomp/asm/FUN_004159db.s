# FUN_004159db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004159db
# extent:       0x004159db-0x00415a61 (134 code bytes)
# span:         0x004159db-0x00415a61 (code 134, tables 0, padding 0)
# sha256:       22d4d494ed470c374fc42a2afa715951fc23e6df411033abb7c136ccf3c302f5
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4159db_dispatch_piece
# naming:       native port src/original_methods_fl27a.c:m4159db_dispatch_piece (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4159db_dispatch_piece: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_20
# callees:      calls FUN_00415db9, FUN_00415011, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4159db_dispatch_piece (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00415011, .text + (0x00415011 - 0x401000)
.set FUN_00415db9, .text + (0x00415db9 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004159db - 0x401000
.globl FUN_004159db
FUN_004159db:
    # block 0x004159db: entry, 9 instruction(s), ends with je to 0x004159f5 (forward)
    push ebp                                     # 004159db
    {load} mov ebp, esp                          # 004159dc
    sub esp, 0x8                                 # 004159de
    mov dword ptr [ebp - local_4], ecx           # 004159e1
    mov eax, dword ptr [ebp + arg_8]             # 004159e4
    mov cl, byte ptr [eax + field_20]            # 004159e7
    mov byte ptr [ebp - local_8], cl             # 004159ea
    cmp byte ptr [ebp - local_8], 0x2            # 004159ed
    je.d8 L_004159f5                             # 004159f1
    # block 0x004159f3: entered by fall-through of je at 0x004159f1, 1 instruction(s), ends with forward jump to 0x00415a08
    jmp.d8 L_00415a08                            # 004159f3
L_004159f5:
    # block 0x004159f5: entered by je at 0x004159f1, 7 instruction(s), calls FUN_00415db9, ends with forward jump to 0x00415a5b
    mov dx, word ptr [ebp + arg_c]               # 004159f5
    push edx                                     # 004159f9
    mov eax, dword ptr [ebp + arg_8]             # 004159fa
    push eax                                     # 004159fd
    mov ecx, dword ptr [ebp - local_4]           # 004159fe
    call FUN_00415db9                            # 00415a01
    jmp.d8 L_00415a5b                            # 00415a06
L_00415a08:
    # block 0x00415a08: entered by jmp at 0x004159f3, 22 instruction(s), calls FUN_00415011, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00415a5b
    mov ecx, dword ptr [ebp + arg_8]             # 00415a08
    push ecx                                     # 00415a0b
    mov ecx, dword ptr [ebp - local_4]           # 00415a0c
    call FUN_00415011                            # 00415a0f
    mov edx, dword ptr [ebp + arg_8]             # 00415a14
    add edx, 0x151                               # 00415a17
    push edx                                     # 00415a1d
    mov eax, dword ptr [ebp + arg_8]             # 00415a1e
    {load} xor ecx, ecx                          # 00415a21
    mov cl, byte ptr [eax + field_20]            # 00415a23
    push ecx                                     # 00415a26
    push 0x541dd8                                # 00415a27
    push 0x63888b                                # 00415a2c
    call FUN_0050ca3e                            # 00415a31
    add esp, 0x10                                # 00415a36
    push 0x0                                     # 00415a39
    push 0x0                                     # 00415a3b
    push 0x63888b                                # 00415a3d
    call FUN_0052139c                            # 00415a42
    mov dword ptr [0x63a58a], 0x4                # 00415a47
    mov ecx, 0x5cf659                            # 00415a51
    call FUN_004c97b4                            # 00415a56
L_00415a5b:
    # block 0x00415a5b: entered by jmp at 0x00415a06, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00415a5b
    pop ebp                                      # 00415a5d
    ret 0x8                                      # 00415a5e

