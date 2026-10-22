# FUN_004b3e99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3e99
# extent:       0x004b3e99-0x004b3f98 (255 code bytes)
# span:         0x004b3e99-0x004b3f98 (code 255, tables 0, padding 0)
# sha256:       f41f9f0d496a07f974aa634e5a4a226411f5648d7d1555206186e2fd3bb6c57e
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b3e99_clamp_rect
# naming:       native port src/original_methods_fl39c.c:m4b3e99_clamp_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Clamps the signed dwords [self+0x6e0]/[self+0x6e8] against the globals 0x58319a/0x5831a2 (word [self+0x722] keeps the width) and [self+0x6dc]/[self+0x6e4] against 0x583196/0x58319e. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6dc, field_6e0, field_6e4, field_6e8; [ecx + n] field_71e, field_722; [edx + n] field_6dc, field_6e0, field_6e4, field_6e8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4b3e99_clamp_rect (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6dc, 0x6dc  # offset +0x6dc
.equ field_6e0, 0x6e0  # offset +0x6e0
.equ field_6e4, 0x6e4  # offset +0x6e4
.equ field_6e8, 0x6e8  # offset +0x6e8
.equ field_71e, 0x71e  # offset +0x71e
.equ field_722, 0x722  # offset +0x722

# --- external targets -----------------------------------------------

.org 0x004b3e99 - 0x401000
.globl FUN_004b3e99
FUN_004b3e99:
    # block 0x004b3e99: entry, 8 instruction(s), ends with jge to 0x004b3edd (forward)
    push ebp                                     # 004b3e99
    {load} mov ebp, esp                          # 004b3e9a
    push ecx                                     # 004b3e9c
    mov dword ptr [ebp - local_4], ecx           # 004b3e9d
    mov eax, dword ptr [ebp - local_4]           # 004b3ea0
    mov ecx, dword ptr [eax + field_6e0]         # 004b3ea3
    cmp ecx, dword ptr [0x58319a]                # 004b3ea9
    jge.d8 L_004b3edd                            # 004b3eaf
    # block 0x004b3eb1: entered by fall-through of jge at 0x004b3eaf, 10 instruction(s), falls into the block at 0x004b3edd
    mov edx, dword ptr [ebp - local_4]           # 004b3eb1
    mov eax, dword ptr [0x58319a]                # 004b3eb4
    mov dword ptr [edx + field_6e0], eax         # 004b3eb9
    mov ecx, dword ptr [ebp - local_4]           # 004b3ebf
    movsx edx, word ptr [ecx + field_722]        # 004b3ec2
    mov eax, dword ptr [ebp - local_4]           # 004b3ec9
    mov ecx, dword ptr [eax + field_6e0]         # 004b3ecc
    {load} add ecx, edx                          # 004b3ed2
    mov edx, dword ptr [ebp - local_4]           # 004b3ed4
    mov dword ptr [edx + field_6e8], ecx         # 004b3ed7
L_004b3edd:
    # block 0x004b3edd: entered by jge at 0x004b3eaf, 4 instruction(s), ends with jle to 0x004b3f1a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b3edd
    mov ecx, dword ptr [eax + field_6e8]         # 004b3ee0
    cmp ecx, dword ptr [0x5831a2]                # 004b3ee6
    jle.d8 L_004b3f1a                            # 004b3eec
    # block 0x004b3eee: entered by fall-through of jle at 0x004b3eec, 10 instruction(s), falls into the block at 0x004b3f1a
    mov edx, dword ptr [ebp - local_4]           # 004b3eee
    mov eax, dword ptr [0x5831a2]                # 004b3ef1
    mov dword ptr [edx + field_6e8], eax         # 004b3ef6
    mov ecx, dword ptr [ebp - local_4]           # 004b3efc
    movsx edx, word ptr [ecx + field_722]        # 004b3eff
    mov eax, dword ptr [ebp - local_4]           # 004b3f06
    mov ecx, dword ptr [eax + field_6e8]         # 004b3f09
    {load} sub ecx, edx                          # 004b3f0f
    mov edx, dword ptr [ebp - local_4]           # 004b3f11
    mov dword ptr [edx + field_6e0], ecx         # 004b3f14
L_004b3f1a:
    # block 0x004b3f1a: entered by jle at 0x004b3eec, 4 instruction(s), ends with jge to 0x004b3f57 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b3f1a
    mov ecx, dword ptr [eax + field_6dc]         # 004b3f1d
    cmp ecx, dword ptr [0x583196]                # 004b3f23
    jge.d8 L_004b3f57                            # 004b3f29
    # block 0x004b3f2b: entered by fall-through of jge at 0x004b3f29, 10 instruction(s), falls into the block at 0x004b3f57
    mov edx, dword ptr [ebp - local_4]           # 004b3f2b
    mov eax, dword ptr [0x583196]                # 004b3f2e
    mov dword ptr [edx + field_6dc], eax         # 004b3f33
    mov ecx, dword ptr [ebp - local_4]           # 004b3f39
    movsx edx, word ptr [ecx + field_71e]        # 004b3f3c
    mov eax, dword ptr [ebp - local_4]           # 004b3f43
    mov ecx, dword ptr [eax + field_6dc]         # 004b3f46
    {load} add ecx, edx                          # 004b3f4c
    mov edx, dword ptr [ebp - local_4]           # 004b3f4e
    mov dword ptr [edx + field_6e4], ecx         # 004b3f51
L_004b3f57:
    # block 0x004b3f57: entered by jge at 0x004b3f29, 4 instruction(s), ends with jle to 0x004b3f94 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b3f57
    mov ecx, dword ptr [eax + field_6e4]         # 004b3f5a
    cmp ecx, dword ptr [0x58319e]                # 004b3f60
    jle.d8 L_004b3f94                            # 004b3f66
    # block 0x004b3f68: entered by fall-through of jle at 0x004b3f66, 10 instruction(s), falls into the block at 0x004b3f94
    mov edx, dword ptr [ebp - local_4]           # 004b3f68
    mov eax, dword ptr [0x58319e]                # 004b3f6b
    mov dword ptr [edx + field_6e4], eax         # 004b3f70
    mov ecx, dword ptr [ebp - local_4]           # 004b3f76
    movsx edx, word ptr [ecx + field_71e]        # 004b3f79
    mov eax, dword ptr [ebp - local_4]           # 004b3f80
    mov ecx, dword ptr [eax + field_6e4]         # 004b3f83
    {load} sub ecx, edx                          # 004b3f89
    mov edx, dword ptr [ebp - local_4]           # 004b3f8b
    mov dword ptr [edx + field_6dc], ecx         # 004b3f8e
L_004b3f94:
    # block 0x004b3f94: entered by jle at 0x004b3f66, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b3f94
    pop ebp                                      # 004b3f96
    ret                                          # 004b3f97

