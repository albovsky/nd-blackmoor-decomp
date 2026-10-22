# FUN_004beeb3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004beeb3
# extent:       0x004beeb3-0x004bef11 (94 code bytes)
# span:         0x004beeb3-0x004bef11 (code 94, tables 0, padding 0)
# sha256:       6f4a4ca30ecdf79c1465c807fb7f3d9c3169bcc5d79f0477eb48da31b93b5390
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4beeb3_bind_buffer
# naming:       native port src/original_methods_fl39f.c:m4beeb3_bind_buffer (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4bf38c(this); a0 == 0 clears 0xe dwords at [this+0x84] and stores 0xfffffffd at [this+0x2c0] (result 0); All instructions run; both jump directions taken; returns a host pointer.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkGetRealtime@12
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4beeb3_bind_buffer (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004beeb3 - 0x401000
.globl FUN_004beeb3
FUN_004beeb3:
    # block 0x004beeb3: entry, 9 instruction(s), calls FUN_004bf38c, ends with jne to 0x004beeec (forward)
    push ebp                                     # 004beeb3
    {load} mov ebp, esp                          # 004beeb4
    push ecx                                     # 004beeb6
    push edi                                     # 004beeb7
    mov dword ptr [ebp - local_4], ecx           # 004beeb8
    mov ecx, dword ptr [ebp - local_4]           # 004beebb
    call FUN_004bf38c                            # 004beebe
    cmp dword ptr [ebp + arg_8], 0x0             # 004beec3
    jne.d8 L_004beeec                            # 004beec7
    # block 0x004beec9: entered by fall-through of jne at 0x004beec7, 9 instruction(s), ends with forward jump to 0x004bef0a
    mov ecx, 0xe                                 # 004beec9
    {load} xor eax, eax                          # 004beece
    mov edi, dword ptr [ebp - local_4]           # 004beed0
    add edi, 0x84                                # 004beed3
    rep stosd dword ptr es:[edi], eax            # 004beed9
    mov eax, dword ptr [ebp - local_4]           # 004beedb
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004beede
    {load} xor eax, eax                          # 004beee8
    jmp.d8 L_004bef0a                            # 004beeea
L_004beeec:
    # block 0x004beeec: entered by jne at 0x004beec7, 9 instruction(s), calls binkw32.dll!_BinkGetRealtime@12, falls into the block at 0x004bef0a
    push 0x0                                     # 004beeec
    mov ecx, dword ptr [ebp - local_4]           # 004beeee
    add ecx, 0x84                                # 004beef1
    push ecx                                     # 004beef7
    mov edx, dword ptr [ebp + arg_8]             # 004beef8
    push edx                                     # 004beefb
    call dword ptr [0x52a534]                    # 004beefc
    mov eax, dword ptr [ebp - local_4]           # 004bef02
    add eax, 0x84                                # 004bef05
L_004bef0a:
    # block 0x004bef0a: entered by jmp at 0x004beeea, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004bef0a
    {load} mov esp, ebp                          # 004bef0b
    pop ebp                                      # 004bef0d
    ret 0x4                                      # 004bef0e

