# FUN_004b80d9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b80d9
# extent:       0x004b80d9-0x004b8193 (186 code bytes)
# span:         0x004b80d9-0x004b8193 (code 186, tables 0, padding 0)
# sha256:       c480a70041b320c029a76a66588a06d7f20195c47fe4c3d5cfe8089d44385b7b
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_typing_quiz_f5_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f5_runtime.h:21 says "0x4b80d9 loader (0x4109ce): copies the 1390-byte typed body into a fresh row allocation"; src/scene_resource.c:128 says "0x4b80d9 copies 1,390 bytes (A-F5.1)"
# name-note:    Loader that copies the 1390-byte typed body of the 0xf5 Typing Quiz Puzzle into a fresh row allocation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
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

.org 0x004b80d9 - 0x401000
.globl FUN_004b80d9
FUN_004b80d9:
    # block 0x004b80d9: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004b8140 (forward)
    push ebp                                     # 004b80d9
    {load} mov ebp, esp                          # 004b80da
    sub esp, 0x8                                 # 004b80dc
    push esi                                     # 004b80df
    push edi                                     # 004b80e0
    mov dword ptr [ebp - local_8], ecx           # 004b80e1
    push 0x56e                                   # 004b80e4
    call FUN_0051dc43                            # 004b80e9
    add esp, 0x4                                 # 004b80ee
    mov dword ptr [ebp - local_4], eax           # 004b80f1
    mov eax, dword ptr [ebp + arg_8]             # 004b80f4
    mov ecx, dword ptr [ebp - local_4]           # 004b80f7
    mov dword ptr [eax], ecx                     # 004b80fa
    cmp dword ptr [ebp - local_4], 0x0           # 004b80fc
    jne.d8 L_004b8140                            # 004b8100
    # block 0x004b8102: entered by fall-through of jne at 0x004b8100, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004b8140
    movsx edx, word ptr [0x5c39e3]               # 004b8102
    push edx                                     # 004b8109
    mov eax, dword ptr [0x5bb57b]                # 004b810a
    push eax                                     # 004b810f
    push 0x551d34                                # 004b8110
    push 0x63888b                                # 004b8115
    call FUN_0050ca3e                            # 004b811a
    add esp, 0x10                                # 004b811f
    push 0x63888b                                # 004b8122
    push 0x551d60                                # 004b8127
    mov ecx, 0x583979                            # 004b812c
    call FUN_0042639d                            # 004b8131
    mov ecx, 0x5cf659                            # 004b8136
    call FUN_004c97b4                            # 004b813b
L_004b8140:
    # block 0x004b8140: entered by jne at 0x004b8100, 20 instruction(s), ends with je to 0x004b818b (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004b8140
    mov esi, dword ptr [ecx]                     # 004b8143
    mov edx, dword ptr [ebp + arg_8]             # 004b8145
    mov edi, dword ptr [edx]                     # 004b8148
    mov ecx, 0x15b                               # 004b814a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b814f
    movsw word ptr es:[edi], word ptr [esi]      # 004b8151
    mov eax, dword ptr [ebp + arg_10]            # 004b8153
    mov ecx, dword ptr [eax]                     # 004b8156
    add ecx, 0x56e                               # 004b8158
    mov edx, dword ptr [ebp + arg_10]            # 004b815e
    mov dword ptr [edx], ecx                     # 004b8161
    mov eax, dword ptr [ebp + arg_c]             # 004b8163
    mov ecx, dword ptr [eax]                     # 004b8166
    add ecx, 0x56e                               # 004b8168
    mov edx, dword ptr [ebp + arg_c]             # 004b816e
    mov dword ptr [edx], ecx                     # 004b8171
    movsx eax, word ptr [0x63a4cd]               # 004b8173
    test eax, eax                                # 004b817a
    je.d8 L_004b818b                             # 004b817c
    # block 0x004b817e: entered by fall-through of je at 0x004b817c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004b818b
    push 0x551d7c                                # 004b817e
    call FUN_0044a2b7                            # 004b8183
    add esp, 0x4                                 # 004b8188
L_004b818b:
    # block 0x004b818b: entered by je at 0x004b817c, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004b818b
    pop esi                                      # 004b818c
    {load} mov esp, ebp                          # 004b818d
    pop ebp                                      # 004b818f
    ret 0xc                                      # 004b8190

