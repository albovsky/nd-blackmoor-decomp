# FUN_00468f9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468f9f
# extent:       0x00468f9f-0x00469057 (184 code bytes)
# span:         0x00468f9f-0x00469057 (code 184, tables 0, padding 0)
# sha256:       e0781341d83631bfac212cc53258dcfcdc550f48bca2e1af398ba5ffefdcb575
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_equalizer_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/468f9f.c.txt, not original source) refers to the data labelled s_Loaded_AT_SOUND_EQUALIZER_PUZZLE_0054b9bc, s_for_SCENE__d__pData_for_ACTION_R_0054b974
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_SOUND_EQUALIZER_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00468f9f - 0x401000
.globl FUN_00468f9f
FUN_00468f9f:
    # block 0x00468f9f: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00469006 (forward)
    push ebp                                     # 00468f9f
    {load} mov ebp, esp                          # 00468fa0
    sub esp, 0x8                                 # 00468fa2
    push esi                                     # 00468fa5
    push edi                                     # 00468fa6
    mov dword ptr [ebp - local_8], ecx           # 00468fa7
    push 0x5d8                                   # 00468faa
    call FUN_0051dc43                            # 00468faf
    add esp, 0x4                                 # 00468fb4
    mov dword ptr [ebp - local_4], eax           # 00468fb7
    mov eax, dword ptr [ebp + arg_8]             # 00468fba
    mov ecx, dword ptr [ebp - local_4]           # 00468fbd
    mov dword ptr [eax], ecx                     # 00468fc0
    cmp dword ptr [ebp - local_4], 0x0           # 00468fc2
    jne.d8 L_00469006                            # 00468fc6
    # block 0x00468fc8: entered by fall-through of jne at 0x00468fc6, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00469006
    movsx edx, word ptr [0x5c39e3]               # 00468fc8
    push edx                                     # 00468fcf
    mov eax, dword ptr [0x5bb57b]                # 00468fd0
    push eax                                     # 00468fd5
    push 0x54b974                                # 00468fd6
    push 0x63888b                                # 00468fdb
    call FUN_0050ca3e                            # 00468fe0
    add esp, 0x10                                # 00468fe5
    push 0x63888b                                # 00468fe8
    push 0x54b9a0                                # 00468fed
    mov ecx, 0x583979                            # 00468ff2
    call FUN_0042639d                            # 00468ff7
    mov ecx, 0x5cf659                            # 00468ffc
    call FUN_004c97b4                            # 00469001
L_00469006:
    # block 0x00469006: entered by jne at 0x00468fc6, 19 instruction(s), ends with je to 0x0046904f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00469006
    mov esi, dword ptr [ecx]                     # 00469009
    mov edx, dword ptr [ebp + arg_8]             # 0046900b
    mov edi, dword ptr [edx]                     # 0046900e
    mov ecx, 0x176                               # 00469010
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00469015
    mov eax, dword ptr [ebp + arg_10]            # 00469017
    mov ecx, dword ptr [eax]                     # 0046901a
    add ecx, 0x5d8                               # 0046901c
    mov edx, dword ptr [ebp + arg_10]            # 00469022
    mov dword ptr [edx], ecx                     # 00469025
    mov eax, dword ptr [ebp + arg_c]             # 00469027
    mov ecx, dword ptr [eax]                     # 0046902a
    add ecx, 0x5d8                               # 0046902c
    mov edx, dword ptr [ebp + arg_c]             # 00469032
    mov dword ptr [edx], ecx                     # 00469035
    movsx eax, word ptr [0x63a4cd]               # 00469037
    test eax, eax                                # 0046903e
    je.d8 L_0046904f                             # 00469040
    # block 0x00469042: entered by fall-through of je at 0x00469040, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0046904f
    push 0x54b9bc                                # 00469042
    call FUN_0044a2b7                            # 00469047
    add esp, 0x4                                 # 0046904c
L_0046904f:
    # block 0x0046904f: entered by je at 0x00469040, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0046904f
    pop esi                                      # 00469050
    {load} mov esp, ebp                          # 00469051
    pop ebp                                      # 00469053
    ret 0xc                                      # 00469054

