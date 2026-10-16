# FUN_00464076
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464076
# extent:       0x00464076-0x004640c9 (83 code bytes)
# span:         0x00464076-0x004640c9 (code 83, tables 0, padding 0)
# sha256:       dd6666b6681c6f12b0eb970f148de271019f860978cacff5865fcd4cc78c5e3b
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00464076
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_20; [edx + n] field_1c, field_20
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0046402e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0046402e, .text + (0x0046402e - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00464076 - 0x401000
.globl FUN_00464076
FUN_00464076:
    # block 0x00464076: entry, 7 instruction(s), ends with je to 0x004640a1 (forward)
    push ebp                                     # 00464076
    {load} mov ebp, esp                          # 00464077
    push ecx                                     # 00464079
    mov dword ptr [ebp - local_4], ecx           # 0046407a
    mov eax, dword ptr [ebp - local_4]           # 0046407d
    cmp dword ptr [eax + field_20], 0x0          # 00464080
    je.d8 L_004640a1                             # 00464084
    # block 0x00464086: entered by fall-through of je at 0x00464084, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004640a1
    mov ecx, dword ptr [ebp - local_4]           # 00464086
    add ecx, 0x20                                # 00464089
    push ecx                                     # 0046408c
    mov ecx, 0x5cf659                            # 0046408d
    call FUN_004c2dfb                            # 00464092
    mov edx, dword ptr [ebp - local_4]           # 00464097
    mov dword ptr [edx + field_20], 0x0          # 0046409a
L_004640a1:
    # block 0x004640a1: entered by je at 0x00464084, 4 instruction(s), ends with je to 0x004640bd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004640a1
    movsx ecx, word ptr [eax + field_1c]         # 004640a4
    cmp ecx, -0x1                                # 004640a8
    je.d8 L_004640bd                             # 004640ab
    # block 0x004640ad: entered by fall-through of je at 0x004640ab, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004640bd
    mov edx, dword ptr [ebp - local_4]           # 004640ad
    mov ax, word ptr [edx + field_1c]            # 004640b0
    push eax                                     # 004640b4
    call FUN_004d3992                            # 004640b5
    add esp, 0x4                                 # 004640ba
L_004640bd:
    # block 0x004640bd: entered by je at 0x004640ab, 5 instruction(s), calls FUN_0046402e, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004640bd
    call FUN_0046402e                            # 004640c0
    {load} mov esp, ebp                          # 004640c5
    pop ebp                                      # 004640c7
    ret                                          # 004640c8

