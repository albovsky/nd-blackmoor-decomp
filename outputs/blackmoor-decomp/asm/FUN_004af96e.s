# FUN_004af96e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004af96e
# extent:       0x004af96e-0x004afa0e (160 code bytes)
# span:         0x004af96e-0x004afa0e (code 160, tables 0, padding 0)
# sha256:       90550c11c873ab893af206efc64ac8b6f50414de9326d267ae08c18dadc19892
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4af96e_lifted
# naming:       native port src/original_methods_fl41.c:m4af96e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 44/44 instructions, 6/6 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_e57; [ecx + n] field_6e; [edx + n] field_e39, field_e57
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4af96e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_6e, 0x6e  # offset +0x6e
.equ field_e39, 0xe39  # offset +0xe39
.equ field_e57, 0xe57  # offset +0xe57

# --- external targets -----------------------------------------------

.org 0x004af96e - 0x401000
.globl FUN_004af96e
FUN_004af96e:
    # block 0x004af96e: entry, 9 instruction(s), ends with jne to 0x004af991 (forward)
    push ebp                                     # 004af96e
    {load} mov ebp, esp                          # 004af96f
    sub esp, 0xc                                 # 004af971
    mov dword ptr [ebp - local_c], ecx           # 004af974
    mov word ptr [ebp - local_8], 0xffff         # 004af977
    mov eax, dword ptr [ebp - local_c]           # 004af97d
    movsx ecx, word ptr [eax + field_e57]        # 004af980
    test ecx, ecx                                # 004af987
    jne.d8 L_004af991                            # 004af989
    # block 0x004af98b: entered by fall-through of jne at 0x004af989, 2 instruction(s), ends with forward jump to 0x004afa0a
    mov ax, word ptr [ebp - local_8]             # 004af98b
    jmp.d8 L_004afa0a                            # 004af98f
L_004af991:
    # block 0x004af991: entered by jne at 0x004af989, 5 instruction(s), ends with forward jump to 0x004af9b1
    mov edx, dword ptr [ebp - local_c]           # 004af991
    mov ax, word ptr [edx + field_e39]           # 004af994
    mov word ptr [ebp - local_8], ax             # 004af99b
    mov dword ptr [ebp - local_4], 0x1           # 004af99f
    jmp.d8 L_004af9b1                            # 004af9a6
L_004af9a8:
    # block 0x004af9a8: entered by jmp at 0x004afa04, 3 instruction(s), falls into the block at 0x004af9b1
    mov ecx, dword ptr [ebp - local_4]           # 004af9a8
    add ecx, 0x1                                 # 004af9ab
    mov dword ptr [ebp - local_4], ecx           # 004af9ae
L_004af9b1:
    # block 0x004af9b1: entered by jmp at 0x004af9a6, 4 instruction(s), ends with jge to 0x004afa06 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004af9b1
    movsx eax, word ptr [edx + field_e57]        # 004af9b4
    cmp dword ptr [ebp - local_4], eax           # 004af9bb
    jge.d8 L_004afa06                            # 004af9be
    # block 0x004af9c0: entered by fall-through of jge at 0x004af9be, 12 instruction(s), ends with jle to 0x004afa04 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004af9c0
    mov edx, dword ptr [ebp - local_c]           # 004af9c3
    movsx eax, word ptr [edx + 2*ecx + field_e39] # 004af9c6
    imul eax, eax, 0xc7                          # 004af9ce
    mov ecx, dword ptr [ebp - local_c]           # 004af9d4
    movsx edx, word ptr [ecx + eax + field_6e]   # 004af9d7
    movsx eax, word ptr [ebp - local_8]          # 004af9dc
    imul eax, eax, 0xc7                          # 004af9e0
    mov ecx, dword ptr [ebp - local_c]           # 004af9e6
    movsx eax, word ptr [ecx + eax + field_6e]   # 004af9e9
    {load} cmp edx, eax                          # 004af9ee
    jle.d8 L_004afa04                            # 004af9f0
    # block 0x004af9f2: entered by fall-through of jle at 0x004af9f0, 4 instruction(s), falls into the block at 0x004afa04
    mov ecx, dword ptr [ebp - local_4]           # 004af9f2
    mov edx, dword ptr [ebp - local_c]           # 004af9f5
    mov ax, word ptr [edx + 2*ecx + field_e39]   # 004af9f8
    mov word ptr [ebp - local_8], ax             # 004afa00
L_004afa04:
    # block 0x004afa04: entered by jle at 0x004af9f0, 1 instruction(s), ends with backward jump to 0x004af9a8
    jmp.d8 L_004af9a8                            # 004afa04
L_004afa06:
    # block 0x004afa06: entered by jge at 0x004af9be, 1 instruction(s), falls into the block at 0x004afa0a
    mov ax, word ptr [ebp - local_8]             # 004afa06
L_004afa0a:
    # block 0x004afa0a: entered by jmp at 0x004af98f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004afa0a
    pop ebp                                      # 004afa0c
    ret                                          # 004afa0d

