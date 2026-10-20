# FUN_0048a865
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a865
# extent:       0x0048a865-0x0048a920 (187 code bytes)
# span:         0x0048a865-0x0048a920 (code 187, tables 0, padding 0)
# sha256:       2fd3800c9784d8e082431e370b504cf8c6ef26b6b197390ae943524dd88336b7
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_override_lock_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/48a865.c.txt, not original source) refers to the data labelled s_Loaded_AT_OVERRIDE_LOCK_PUZZLE_a_0054e32c, s_for_SCENE__d__pData_for_ACTION_R_0054e2e4
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_OVERRIDE_LOCK_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x0048a865 - 0x401000
.globl FUN_0048a865
FUN_0048a865:
    # block 0x0048a865: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0048a8cc (forward)
    push ebp                                     # 0048a865
    {load} mov ebp, esp                          # 0048a866
    sub esp, 0x8                                 # 0048a868
    push esi                                     # 0048a86b
    push edi                                     # 0048a86c
    mov dword ptr [ebp - local_8], ecx           # 0048a86d
    push 0x41b                                   # 0048a870
    call FUN_0051dc43                            # 0048a875
    add esp, 0x4                                 # 0048a87a
    mov dword ptr [ebp - local_4], eax           # 0048a87d
    mov eax, dword ptr [ebp + arg_8]             # 0048a880
    mov ecx, dword ptr [ebp - local_4]           # 0048a883
    mov dword ptr [eax], ecx                     # 0048a886
    cmp dword ptr [ebp - local_4], 0x0           # 0048a888
    jne.d8 L_0048a8cc                            # 0048a88c
    # block 0x0048a88e: entered by fall-through of jne at 0x0048a88c, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0048a8cc
    movsx edx, word ptr [0x5c39e3]               # 0048a88e
    push edx                                     # 0048a895
    mov eax, dword ptr [0x5bb57b]                # 0048a896
    push eax                                     # 0048a89b
    push 0x54e2e4                                # 0048a89c
    push 0x63888b                                # 0048a8a1
    call FUN_0050ca3e                            # 0048a8a6
    add esp, 0x10                                # 0048a8ab
    push 0x63888b                                # 0048a8ae
    push 0x54e310                                # 0048a8b3
    mov ecx, 0x583979                            # 0048a8b8
    call FUN_0042639d                            # 0048a8bd
    mov ecx, 0x5cf659                            # 0048a8c2
    call FUN_004c97b4                            # 0048a8c7
L_0048a8cc:
    # block 0x0048a8cc: entered by jne at 0x0048a88c, 21 instruction(s), ends with je to 0x0048a918 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0048a8cc
    mov esi, dword ptr [ecx]                     # 0048a8cf
    mov edx, dword ptr [ebp + arg_8]             # 0048a8d1
    mov edi, dword ptr [edx]                     # 0048a8d4
    mov ecx, 0x106                               # 0048a8d6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048a8db
    movsw word ptr es:[edi], word ptr [esi]      # 0048a8dd
    movsb byte ptr es:[edi], byte ptr [esi]      # 0048a8df
    mov eax, dword ptr [ebp + arg_10]            # 0048a8e0
    mov ecx, dword ptr [eax]                     # 0048a8e3
    add ecx, 0x41b                               # 0048a8e5
    mov edx, dword ptr [ebp + arg_10]            # 0048a8eb
    mov dword ptr [edx], ecx                     # 0048a8ee
    mov eax, dword ptr [ebp + arg_c]             # 0048a8f0
    mov ecx, dword ptr [eax]                     # 0048a8f3
    add ecx, 0x41b                               # 0048a8f5
    mov edx, dword ptr [ebp + arg_c]             # 0048a8fb
    mov dword ptr [edx], ecx                     # 0048a8fe
    movsx eax, word ptr [0x63a4cd]               # 0048a900
    test eax, eax                                # 0048a907
    je.d8 L_0048a918                             # 0048a909
    # block 0x0048a90b: entered by fall-through of je at 0x0048a909, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0048a918
    push 0x54e32c                                # 0048a90b
    call FUN_0044a2b7                            # 0048a910
    add esp, 0x4                                 # 0048a915
L_0048a918:
    # block 0x0048a918: entered by je at 0x0048a909, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0048a918
    pop esi                                      # 0048a919
    {load} mov esp, ebp                          # 0048a91a
    pop ebp                                      # 0048a91c
    ret 0xc                                      # 0048a91d

