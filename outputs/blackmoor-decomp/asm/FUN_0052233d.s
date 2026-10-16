# FUN_0052233d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052233d
# extent:       0x0052233d-0x005223ff (194 code bytes)
# span:         0x0052233d-0x005223ff (code 194, tables 0, padding 0)
# sha256:       2a6a2bae171b6a8a8b0223994d524d393709d2df3544acf7a91af3a7fcb674f3
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052233d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebx + n] field_5c; [edi + n] field_minus_28; [esi + n] field_1c, field_5c, field_64, field_6c; [esp + n] stk_8; [scaled index + n] field_minus_28
# callees:      calls FUN_0051a267, FUN_0051dc43, FUN_0050fa90, FUN_0051dc6c, FUN_00521de7, FUN_00521a86, COMCTL32.dll!CreatePropertySheetPageA, FUN_00519cc0, USER32.dll!SendMessageA, COMCTL32.dll!DestroyPropertySheetPage
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005223ff
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_28, 0x28  # offset -0x28
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_5c, 0x5c  # offset +0x5c
.equ field_64, 0x64  # offset +0x64
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)
.set FUN_0051a267, .text + (0x0051a267 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00521a86, .text + (0x00521a86 - 0x401000)
.set FUN_00521de7, .text + (0x00521de7 - 0x401000)

.org 0x0052233d - 0x401000
.globl FUN_0052233d
FUN_0052233d:
    # block 0x0052233d: entry, 11 instruction(s), calls FUN_0051a267, ends with je to 0x005223f9 (forward)
    push ebx                                     # 0052233d
    mov ebx, dword ptr [esp + stk_8]             # 0052233e
    push esi                                     # 00522342
    {load} mov esi, ecx                          # 00522343
    push edi                                     # 00522345
    push ebx                                     # 00522346
    push dword ptr [esi + field_6c]              # 00522347
    lea ecx, [esi + field_64]                    # 0052234a
    call FUN_0051a267                            # 0052234d
    cmp dword ptr [esi + field_1c], 0x0          # 00522352
    je.d32 L_005223f9                            # 00522356
    # block 0x0052235c: entered by fall-through of je at 0x00522356, 41 instruction(s), calls FUN_0051dc43, FUN_0050fa90, FUN_0051dc6c, FUN_00521de7, FUN_00521a86, COMCTL32.dll!CreateProperty..., ends with jne to 0x005223d8 (forward)
    mov eax, dword ptr [esi + field_6c]          # 0052235c
    lea eax, [eax + 4*eax]                       # 0052235f
    shl eax, 0x3                                 # 00522362
    push eax                                     # 00522365
    call FUN_0051dc43                            # 00522366
    {load} mov edi, eax                          # 0052236b
    mov eax, dword ptr [esi + field_6c]          # 0052236d
    lea eax, [eax + 4*eax]                       # 00522370
    lea eax, [8*eax - field_minus_28]            # 00522373
    push eax                                     # 0052237a
    push dword ptr [esi + field_5c]              # 0052237b
    push edi                                     # 0052237e
    call FUN_0050fa90                            # 0052237f
    push dword ptr [esi + field_5c]              # 00522384
    call FUN_0051dc6c                            # 00522387
    mov dword ptr [esi + field_5c], edi          # 0052238c
    mov eax, dword ptr [esi + field_6c]          # 0052238f
    push 0x28                                    # 00522392
    lea eax, [eax + 4*eax]                       # 00522394
    lea edi, [edi + 8*eax - field_minus_28]      # 00522397
    lea eax, [ebx + field_5c]                    # 0052239b
    push eax                                     # 0052239e
    push edi                                     # 0052239f
    call FUN_0050fa90                            # 005223a0
    add esp, 0x20                                # 005223a5
    {load} mov ecx, esi                          # 005223a8
    call FUN_00521de7                            # 005223aa
    mov eax, dword ptr [eax + field_4]           # 005223af
    {load} mov ecx, ebx                          # 005223b2
    and eax, 0x2020                              # 005223b4
    neg eax                                      # 005223b9
    {load} sbb eax, eax                          # 005223bb
    neg eax                                      # 005223bd
    push eax                                     # 005223bf
    push edi                                     # 005223c0
    call FUN_00521a86                            # 005223c1
    push edi                                     # 005223c6
    call dword ptr [0x52a024]                    # 005223c7
    {load} mov edi, eax                          # 005223cd
    test edi, edi                                # 005223cf
    jne.d8 L_005223d8                            # 005223d1
    # block 0x005223d3: entered by fall-through of jne at 0x005223d1, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x005223d8
    call FUN_00519cc0                            # 005223d3
L_005223d8:
    # block 0x005223d8: entered by jne at 0x005223d1, 7 instruction(s), calls USER32.dll!SendMessageA, ends with jne to 0x005223f9 (forward)
    push edi                                     # 005223d8
    push 0x0                                     # 005223d9
    push 0x467                                   # 005223db
    push dword ptr [esi + field_1c]              # 005223e0
    call dword ptr [0x52a4c8]                    # 005223e3
    test eax, eax                                # 005223e9
    jne.d8 L_005223f9                            # 005223eb
    # block 0x005223ed: entered by fall-through of jne at 0x005223eb, 3 instruction(s), calls COMCTL32.dll!DestroyPropertySheetPage, FUN_00519cc0, falls into the block at 0x005223f9
    push edi                                     # 005223ed
    call dword ptr [0x52a028]                    # 005223ee
    call FUN_00519cc0                            # 005223f4
L_005223f9:
    # block 0x005223f9: entered by je at 0x00522356; jne at 0x005223eb, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 005223f9
    pop esi                                      # 005223fa
    pop ebx                                      # 005223fb
    ret 0x4                                      # 005223fc

