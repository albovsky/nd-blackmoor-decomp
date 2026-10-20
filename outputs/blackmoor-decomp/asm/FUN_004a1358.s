# FUN_004a1358
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1358
# extent:       0x004a1358-0x004a140b (179 code bytes)
# span:         0x004a1358-0x004a140b (code 179, tables 0, padding 0)
# sha256:       24b9e518051fe00383b507919eaafed02342ea82197613ca3e4413bda934df54
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_level_builder_cell_stack_push
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a1358.c.txt, not original source) refers to the data labelled s_CRayCastLevelBuilder__PushCellSt_0055020c
# name-note:    CRayCastLevelBuilder cell stack push: errors out when the stack index is negative, otherwise stores the pair and decrements the index.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_df0; [edx + n] field_dec, field_df0
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 50 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_dec, 0xdec  # offset +0xdec
.equ field_df0, 0xdf0  # offset +0xdf0

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004a1358 - 0x401000
.globl FUN_004a1358
FUN_004a1358:
    # block 0x004a1358: entry, 7 instruction(s), ends with jge to 0x004a13bf (forward)
    push ebp                                     # 004a1358
    {load} mov ebp, esp                          # 004a1359
    push ecx                                     # 004a135b
    mov dword ptr [ebp - local_4], ecx           # 004a135c
    mov eax, dword ptr [ebp - local_4]           # 004a135f
    cmp dword ptr [eax + field_df0], 0x0         # 004a1362
    jge.d8 L_004a13bf                            # 004a1369
    # block 0x004a136b: entered by fall-through of jge at 0x004a1369, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x004a13b5 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004a136b
    push ecx                                     # 004a136e
    mov edx, dword ptr [ebp + arg_8]             # 004a136f
    push edx                                     # 004a1372
    mov eax, dword ptr [ebp - local_4]           # 004a1373
    mov ecx, dword ptr [eax + field_df0]         # 004a1376
    push ecx                                     # 004a137c
    push 0x55020c                                # 004a137d
    push 0x63888b                                # 004a1382
    call FUN_0050ca3e                            # 004a1387
    add esp, 0x14                                # 004a138c
    push 0x0                                     # 004a138f
    push 0x0                                     # 004a1391
    push 0x63888b                                # 004a1393
    call FUN_0052139c                            # 004a1398
    movsx edx, word ptr [0x63a4cd]               # 004a139d
    test edx, edx                                # 004a13a4
    je.d8 L_004a13b5                             # 004a13a6
    # block 0x004a13a8: entered by fall-through of je at 0x004a13a6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004a13b5
    push 0x63888b                                # 004a13a8
    call FUN_0044a2b7                            # 004a13ad
    add esp, 0x4                                 # 004a13b2
L_004a13b5:
    # block 0x004a13b5: entered by je at 0x004a13a6, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x004a13bf
    mov ecx, 0x5cf659                            # 004a13b5
    call FUN_004c97b4                            # 004a13ba
L_004a13bf:
    # block 0x004a13bf: entered by jge at 0x004a1369, 20 instruction(s), ends with ret 0x8
    mov eax, dword ptr [ebp - local_4]           # 004a13bf
    mov ecx, dword ptr [eax + field_df0]         # 004a13c2
    mov edx, dword ptr [ebp - local_4]           # 004a13c8
    mov eax, dword ptr [edx + field_dec]         # 004a13cb
    mov edx, dword ptr [ebp + arg_8]             # 004a13d1
    mov dword ptr [eax + 8*ecx], edx             # 004a13d4
    mov eax, dword ptr [ebp - local_4]           # 004a13d7
    mov ecx, dword ptr [eax + field_df0]         # 004a13da
    mov edx, dword ptr [ebp - local_4]           # 004a13e0
    mov eax, dword ptr [edx + field_dec]         # 004a13e3
    mov edx, dword ptr [ebp + arg_c]             # 004a13e9
    mov dword ptr [eax + 8*ecx + field_4], edx   # 004a13ec
    mov eax, dword ptr [ebp - local_4]           # 004a13f0
    mov ecx, dword ptr [eax + field_df0]         # 004a13f3
    sub ecx, 0x1                                 # 004a13f9
    mov edx, dword ptr [ebp - local_4]           # 004a13fc
    mov dword ptr [edx + field_df0], ecx         # 004a13ff
    {load} mov esp, ebp                          # 004a1405
    pop ebp                                      # 004a1407
    ret 0x8                                      # 004a1408

