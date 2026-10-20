# FUN_004809a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004809a7
# extent:       0x004809a7-0x00480a1d (118 code bytes)
# span:         0x004809a7-0x00480a1d (code 118, tables 0, padding 0)
# sha256:       45a848e9ec74f52695b3249b8455d0d851933f49f091d3d7c80d00895119a20c
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         sound_pick_4809a7
# naming:       native port src/action_family_eb_runtime.c:sound_pick_4809a7 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with sound_pick_4809a7 (record +0x746, channel +0x767, deadline tick+300, state 1). Body is a parameter; sound_play/tick are host callbacks; oracle aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e; [ecx + n] field_767, field_13e7; [edx + n] field_13ca
# callees:      calls FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:sound_pick_4809a7 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_767, 0x767  # offset +0x767
.equ field_13ca, 0x13ca  # offset +0x13ca
.equ field_13e7, 0x13e7  # offset +0x13e7

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004809a7 - 0x401000
.globl FUN_004809a7
FUN_004809a7:
    # block 0x004809a7: entry, 18 instruction(s), ends with je to 0x00480a17 (forward)
    push ebp                                     # 004809a7
    {load} mov ebp, esp                          # 004809a8
    sub esp, 0x8                                 # 004809aa
    push esi                                     # 004809ad
    push edi                                     # 004809ae
    mov dword ptr [ebp - local_8], ecx           # 004809af
    mov eax, dword ptr [ebp - local_8]           # 004809b2
    movsx ecx, word ptr [eax + field_1e]         # 004809b5
    imul ecx, ecx, 0x8d                          # 004809b9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004809bf
    mov dword ptr [ebp - local_4], edx           # 004809c5
    mov edi, 0x54d5b8                            # 004809c8
    mov esi, dword ptr [ebp - local_4]           # 004809cd
    add esi, 0x746                               # 004809d0
    mov ecx, 0x9                                 # 004809d6
    {load} xor eax, eax                          # 004809db
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004809dd
    je.d8 L_00480a17                             # 004809df
    # block 0x004809e1: entered by fall-through of je at 0x004809df, 11 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00480a17
    mov ecx, dword ptr [ebp - local_4]           # 004809e1
    mov dx, word ptr [ecx + field_767]           # 004809e4
    push edx                                     # 004809eb
    mov ecx, 0x5c3a67                            # 004809ec
    call FUN_004fb2e3                            # 004809f1
    call dword ptr [0x52a23c]                    # 004809f6
    add eax, 0x12c                               # 004809fc
    mov ecx, dword ptr [ebp - local_8]           # 00480a01
    mov dword ptr [ecx + field_13e7], eax        # 00480a04
    mov edx, dword ptr [ebp - local_8]           # 00480a0a
    mov dword ptr [edx + field_13ca], 0x1        # 00480a0d
L_00480a17:
    # block 0x00480a17: entered by je at 0x004809df, 5 instruction(s), ends with ret
    pop edi                                      # 00480a17
    pop esi                                      # 00480a18
    {load} mov esp, ebp                          # 00480a19
    pop ebp                                      # 00480a1b
    ret                                          # 00480a1c

