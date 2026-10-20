# FUN_0047314b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047314b
# extent:       0x0047314b-0x00473206 (187 code bytes)
# span:         0x0047314b-0x00473206 (code 187, tables 0, padding 0)
# sha256:       c5552e4c32c2babb005dad6474ad3ba51856c8ef1d2a3c8957ea940ebf12479e
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_magnetmaze_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/47314b.c.txt, not original source) refers to the data labelled s_Loaded_AT_MAGNETMAZE_PUZZLE_acti_0054c5e8, s___for_SCENE__d__pData_for_ACTION_0054c59e
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_MAGNETMAZE_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
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

.org 0x0047314b - 0x401000
.globl FUN_0047314b
FUN_0047314b:
    # block 0x0047314b: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004731b2 (forward)
    push ebp                                     # 0047314b
    {load} mov ebp, esp                          # 0047314c
    sub esp, 0x8                                 # 0047314e
    push esi                                     # 00473151
    push edi                                     # 00473152
    mov dword ptr [ebp - local_8], ecx           # 00473153
    push 0x4ff                                   # 00473156
    call FUN_0051dc43                            # 0047315b
    add esp, 0x4                                 # 00473160
    mov dword ptr [ebp - local_4], eax           # 00473163
    mov eax, dword ptr [ebp + arg_8]             # 00473166
    mov ecx, dword ptr [ebp - local_4]           # 00473169
    mov dword ptr [eax], ecx                     # 0047316c
    cmp dword ptr [ebp - local_4], 0x0           # 0047316e
    jne.d8 L_004731b2                            # 00473172
    # block 0x00473174: entered by fall-through of jne at 0x00473172, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004731b2
    movsx edx, word ptr [0x5c39e3]               # 00473174
    push edx                                     # 0047317b
    mov eax, dword ptr [0x5bb57b]                # 0047317c
    push eax                                     # 00473181
    push 0x54c5a0                                # 00473182
    push 0x63888b                                # 00473187
    call FUN_0050ca3e                            # 0047318c
    add esp, 0x10                                # 00473191
    push 0x63888b                                # 00473194
    push 0x54c5cc                                # 00473199
    mov ecx, 0x583979                            # 0047319e
    call FUN_0042639d                            # 004731a3
    mov ecx, 0x5cf659                            # 004731a8
    call FUN_004c97b4                            # 004731ad
L_004731b2:
    # block 0x004731b2: entered by jne at 0x00473172, 21 instruction(s), ends with je to 0x004731fe (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004731b2
    mov esi, dword ptr [ecx]                     # 004731b5
    mov edx, dword ptr [ebp + arg_8]             # 004731b7
    mov edi, dword ptr [edx]                     # 004731ba
    mov ecx, 0x13f                               # 004731bc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004731c1
    movsw word ptr es:[edi], word ptr [esi]      # 004731c3
    movsb byte ptr es:[edi], byte ptr [esi]      # 004731c5
    mov eax, dword ptr [ebp + arg_10]            # 004731c6
    mov ecx, dword ptr [eax]                     # 004731c9
    add ecx, 0x4ff                               # 004731cb
    mov edx, dword ptr [ebp + arg_10]            # 004731d1
    mov dword ptr [edx], ecx                     # 004731d4
    mov eax, dword ptr [ebp + arg_c]             # 004731d6
    mov ecx, dword ptr [eax]                     # 004731d9
    add ecx, 0x4ff                               # 004731db
    mov edx, dword ptr [ebp + arg_c]             # 004731e1
    mov dword ptr [edx], ecx                     # 004731e4
    movsx eax, word ptr [0x63a4cd]               # 004731e6
    test eax, eax                                # 004731ed
    je.d8 L_004731fe                             # 004731ef
    # block 0x004731f1: entered by fall-through of je at 0x004731ef, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004731fe
    push 0x54c5e8                                # 004731f1
    call FUN_0044a2b7                            # 004731f6
    add esp, 0x4                                 # 004731fb
L_004731fe:
    # block 0x004731fe: entered by je at 0x004731ef, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004731fe
    pop esi                                      # 004731ff
    {load} mov esp, ebp                          # 00473200
    pop ebp                                      # 00473202
    ret 0xc                                      # 00473203

