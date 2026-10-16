# FUN_00520ae3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520ae3
# extent:       0x00520ae3-0x00520b14 (49 code bytes)
# span:         0x00520ae3-0x00520b14 (code 49, tables 0, padding 0)
# sha256:       6a9ebe25531fb855ba618a95b6696a0852fbc8f0deae8cc3cf91d0d046b3886e
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520ae3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_14; [esi + n] field_4
# callees:      calls FUN_00520a5c, FUN_0051a601; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051a601, .text + (0x0051a601 - 0x401000)
.set FUN_00520a5c, .text + (0x00520a5c - 0x401000)

.org 0x00520ae3 - 0x401000
.globl FUN_00520ae3
FUN_00520ae3:
    # block 0x00520ae3: entry, 6 instruction(s), ends with je to 0x00520b04 (forward)
    push esi                                     # 00520ae3
    {load} mov esi, ecx                          # 00520ae4
    push edi                                     # 00520ae6
    mov edi, dword ptr [esi + field_4]           # 00520ae7
    test edi, edi                                # 00520aea
    je.d8 L_00520b04                             # 00520aec
    # block 0x00520aee: entered by fall-through of je at 0x00520aec, 4 instruction(s), calls FUN_00520a5c, ends with je to 0x00520b04 (forward)
    push 0x0                                     # 00520aee
    call FUN_00520a5c                            # 00520af0
    test eax, eax                                # 00520af5
    je.d8 L_00520b04                             # 00520af7
    # block 0x00520af9: entered by fall-through of je at 0x00520af7, 3 instruction(s), calls FUN_0051a601, falls into the block at 0x00520b04
    push dword ptr [esi + field_4]               # 00520af9
    lea ecx, [eax + field_4]                     # 00520afc
    call FUN_0051a601                            # 00520aff
L_00520b04:
    # block 0x00520b04: entered by je at 0x00520aec; je at 0x00520af7, 8 instruction(s), calls indirect dword ptr [eax + 0x14], ends with ret
    mov eax, dword ptr [esi]                     # 00520b04
    {load} mov ecx, esi                          # 00520b06
    call dword ptr [eax + field_14]              # 00520b08
    and dword ptr [esi + field_4], 0x0           # 00520b0b
    {load} mov eax, edi                          # 00520b0f
    pop edi                                      # 00520b11
    pop esi                                      # 00520b12
    ret                                          # 00520b13

