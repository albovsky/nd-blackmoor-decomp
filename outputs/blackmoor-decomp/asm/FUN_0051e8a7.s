# FUN_0051e8a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e8a7
# extent:       0x0051e8a7-0x0051e8f7 (80 code bytes)
# span:         0x0051e8a7-0x0051e8f7 (code 80, tables 0, padding 0)
# sha256:       2af3cf8263e13191f59b35bebe82d87346989936f893f490afa9959a5e97b32f
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e8a7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8, field_minus_c; [ecx + n] field_minus_c; [esp + n] stk_c
# callees:      calls FUN_0051e87a, FUN_0051e6f1, KERNEL32.dll!InterlockedIncrement
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e6f1, .text + (0x0051e6f1 - 0x401000)
.set FUN_0051e87a, .text + (0x0051e87a - 0x401000)

.org 0x0051e8a7 - 0x401000
.globl FUN_0051e8a7
FUN_0051e8a7:
    # block 0x0051e8a7: entry, 8 instruction(s), ends with je to 0x0051e8f0 (forward)
    push esi                                     # 0051e8a7
    push edi                                     # 0051e8a8
    mov edi, dword ptr [esp + stk_c]             # 0051e8a9
    {load} mov esi, ecx                          # 0051e8ad
    mov ecx, dword ptr [esi]                     # 0051e8af
    mov eax, dword ptr [edi]                     # 0051e8b1
    {load} cmp ecx, eax                          # 0051e8b3
    je.d8 L_0051e8f0                             # 0051e8b5
    # block 0x0051e8b7: entered by fall-through of je at 0x0051e8b5, 2 instruction(s), ends with jge to 0x0051e8c8 (forward)
    cmp dword ptr [ecx - field_minus_c], 0x0     # 0051e8b7
    jge.d8 L_0051e8c8                            # 0051e8bb
    # block 0x0051e8bd: entered by fall-through of jge at 0x0051e8bb, 3 instruction(s), ends with jne to 0x0051e8ce (forward)
    add ecx, -0xc                                # 0051e8bd
    cmp ecx, dword ptr [0x5679b4]                # 0051e8c0
    jne.d8 L_0051e8ce                            # 0051e8c6
L_0051e8c8:
    # block 0x0051e8c8: entered by jge at 0x0051e8bb; fall-through of jne at 0x0051e8c6, 2 instruction(s), ends with jge to 0x0051e8db (forward)
    cmp dword ptr [eax - field_minus_c], 0x0     # 0051e8c8
    jge.d8 L_0051e8db                            # 0051e8cc
L_0051e8ce:
    # block 0x0051e8ce: entered by jne at 0x0051e8c6; fall-through of jge at 0x0051e8cc, 5 instruction(s), calls FUN_0051e87a, ends with forward jump to 0x0051e8f0
    push eax                                     # 0051e8ce
    {load} mov ecx, esi                          # 0051e8cf
    push dword ptr [eax - field_minus_8]         # 0051e8d1
    call FUN_0051e87a                            # 0051e8d4
    jmp.d8 L_0051e8f0                            # 0051e8d9
L_0051e8db:
    # block 0x0051e8db: entered by jge at 0x0051e8cc, 7 instruction(s), calls FUN_0051e6f1, KERNEL32.dll!InterlockedIncrement, falls into the block at 0x0051e8f0
    {load} mov ecx, esi                          # 0051e8db
    call FUN_0051e6f1                            # 0051e8dd
    mov eax, dword ptr [edi]                     # 0051e8e2
    mov dword ptr [esi], eax                     # 0051e8e4
    add eax, -0xc                                # 0051e8e6
    push eax                                     # 0051e8e9
    call dword ptr [0x52a200]                    # 0051e8ea
L_0051e8f0:
    # block 0x0051e8f0: entered by je at 0x0051e8b5; jmp at 0x0051e8d9, 4 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051e8f0
    pop edi                                      # 0051e8f2
    pop esi                                      # 0051e8f3
    ret 0x4                                      # 0051e8f4

