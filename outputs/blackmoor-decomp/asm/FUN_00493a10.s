# FUN_00493a10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493a10
# extent:       0x00493a10-0x00493a47 (55 code bytes)
# span:         0x00493a10-0x00493a47 (code 55, tables 0, padding 0)
# sha256:       ac1bcd8e4d0a3a22eba4be5f3bc91a6de5343e9b015ad78d9727337e19ec201e
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00493a10
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_1f77; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1f77, 0x1f77  # offset +0x1f77

# --- external targets -----------------------------------------------

.org 0x00493a10 - 0x401000
.globl FUN_00493a10
FUN_00493a10:
    # block 0x00493a10: entry, 7 instruction(s), ends with je to 0x00493a43 (forward)
    push ebp                                     # 00493a10
    {load} mov ebp, esp                          # 00493a11
    push ecx                                     # 00493a13
    mov dword ptr [ebp - local_4], ecx           # 00493a14
    mov eax, dword ptr [ebp - local_4]           # 00493a17
    cmp dword ptr [eax + field_1f77], 0x0        # 00493a1a
    je.d8 L_00493a43                             # 00493a21
    # block 0x00493a23: entered by fall-through of je at 0x00493a21, 4 instruction(s), ends with je to 0x00493a43 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00493a23
    movsx edx, word ptr [ecx + field_1c]         # 00493a26
    cmp edx, -0x1                                # 00493a2a
    je.d8 L_00493a43                             # 00493a2d
    # block 0x00493a2f: entered by fall-through of je at 0x00493a2d, 4 instruction(s), falls into the block at 0x00493a43
    mov eax, dword ptr [ebp - local_4]           # 00493a2f
    movsx ecx, word ptr [eax + field_1c]         # 00493a32
    imul ecx, ecx, 0x4a                          # 00493a36
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00493a39
L_00493a43:
    # block 0x00493a43: entered by je at 0x00493a21; je at 0x00493a2d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00493a43
    pop ebp                                      # 00493a45
    ret                                          # 00493a46

