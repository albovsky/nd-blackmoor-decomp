# FUN_0044e8a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e8a2
# extent:       0x0044e8a2-0x0044e95b (185 code bytes)
# span:         0x0044e8a2-0x0044e95b (code 185, tables 0, padding 0)
# sha256:       197ddf269d6057f61da1ce599c50540c1dcbd1399331b07bc4ecae2ac67b2342
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_angletoss_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/44e8a2.c.txt, not original source) refers to the data labelled s_Loaded_AT_ANGLETOSS_PUZZLE_actio_005497f0, s_for_SCENE__d__pData_for_ACTION_R_005497a8
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_ANGLETOSS_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x0044e8a2 - 0x401000
.globl FUN_0044e8a2
FUN_0044e8a2:
    # block 0x0044e8a2: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044e909 (forward)
    push ebp                                     # 0044e8a2
    {load} mov ebp, esp                          # 0044e8a3
    sub esp, 0x8                                 # 0044e8a5
    push esi                                     # 0044e8a8
    push edi                                     # 0044e8a9
    mov dword ptr [ebp - local_8], ecx           # 0044e8aa
    push 0x269                                   # 0044e8ad
    call FUN_0051dc43                            # 0044e8b2
    add esp, 0x4                                 # 0044e8b7
    mov dword ptr [ebp - local_4], eax           # 0044e8ba
    mov eax, dword ptr [ebp + arg_8]             # 0044e8bd
    mov ecx, dword ptr [ebp - local_4]           # 0044e8c0
    mov dword ptr [eax], ecx                     # 0044e8c3
    cmp dword ptr [ebp - local_4], 0x0           # 0044e8c5
    jne.d8 L_0044e909                            # 0044e8c9
    # block 0x0044e8cb: entered by fall-through of jne at 0x0044e8c9, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044e909
    movsx edx, word ptr [0x5c39e3]               # 0044e8cb
    push edx                                     # 0044e8d2
    mov eax, dword ptr [0x5bb57b]                # 0044e8d3
    push eax                                     # 0044e8d8
    push 0x5497a8                                # 0044e8d9
    push 0x63888b                                # 0044e8de
    call FUN_0050ca3e                            # 0044e8e3
    add esp, 0x10                                # 0044e8e8
    push 0x63888b                                # 0044e8eb
    push 0x5497d4                                # 0044e8f0
    mov ecx, 0x583979                            # 0044e8f5
    call FUN_0042639d                            # 0044e8fa
    mov ecx, 0x5cf659                            # 0044e8ff
    call FUN_004c97b4                            # 0044e904
L_0044e909:
    # block 0x0044e909: entered by jne at 0x0044e8c9, 20 instruction(s), ends with je to 0x0044e953 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044e909
    mov esi, dword ptr [ecx]                     # 0044e90c
    mov edx, dword ptr [ebp + arg_8]             # 0044e90e
    mov edi, dword ptr [edx]                     # 0044e911
    mov ecx, 0x9a                                # 0044e913
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044e918
    movsb byte ptr es:[edi], byte ptr [esi]      # 0044e91a
    mov eax, dword ptr [ebp + arg_10]            # 0044e91b
    mov ecx, dword ptr [eax]                     # 0044e91e
    add ecx, 0x269                               # 0044e920
    mov edx, dword ptr [ebp + arg_10]            # 0044e926
    mov dword ptr [edx], ecx                     # 0044e929
    mov eax, dword ptr [ebp + arg_c]             # 0044e92b
    mov ecx, dword ptr [eax]                     # 0044e92e
    add ecx, 0x269                               # 0044e930
    mov edx, dword ptr [ebp + arg_c]             # 0044e936
    mov dword ptr [edx], ecx                     # 0044e939
    movsx eax, word ptr [0x63a4cd]               # 0044e93b
    test eax, eax                                # 0044e942
    je.d8 L_0044e953                             # 0044e944
    # block 0x0044e946: entered by fall-through of je at 0x0044e944, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044e953
    push 0x5497f0                                # 0044e946
    call FUN_0044a2b7                            # 0044e94b
    add esp, 0x4                                 # 0044e950
L_0044e953:
    # block 0x0044e953: entered by je at 0x0044e944, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044e953
    pop esi                                      # 0044e954
    {load} mov esp, ebp                          # 0044e955
    pop ebp                                      # 0044e957
    ret 0xc                                      # 0044e958

