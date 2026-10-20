# FUN_004bf8c2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf8c2
# extent:       0x004bf8c2-0x004bf9bb (249 code bytes)
# span:         0x004bf8c2-0x004bf9bb (code 249, tables 0, padding 0)
# sha256:       7d158bdf34fe0129dfc3c0d488dfe5d325275ad225a14ee8167f62242083b27a
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_action_35_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_35.c:1 says "Behavioral reconstruction from original x86 loader 0x4bf8c2."; src/action_family_35.h:85 says "Models 0x4bf8c2's complete variable allocation"
# name-note:    Original x86 loader of action family 0x35, copying its typed body into a fresh allocation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_2; [edx + n] field_3b
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/action_family_35.h:action_family_35_construct (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 82 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_3b, 0x3b  # offset +0x3b

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004bf8c2 - 0x401000
.globl FUN_004bf8c2
FUN_004bf8c2:
    # block 0x004bf8c2: entry, 36 instruction(s), calls FUN_0051dc43, ends with jne to 0x004bf966 (forward)
    push ebp                                     # 004bf8c2
    {load} mov ebp, esp                          # 004bf8c3
    sub esp, 0x18                                # 004bf8c5
    push esi                                     # 004bf8c8
    push edi                                     # 004bf8c9
    mov dword ptr [ebp - local_18], ecx          # 004bf8ca
    mov eax, dword ptr [ebp + arg_c]             # 004bf8cd
    mov ecx, dword ptr [eax]                     # 004bf8d0
    mov dword ptr [ebp - local_c], ecx           # 004bf8d2
    mov edx, dword ptr [ebp - local_c]           # 004bf8d5
    movsx eax, word ptr [edx + field_3b]         # 004bf8d8
    imul eax, eax, 0x6                           # 004bf8dc
    add eax, 0x3d                                # 004bf8df
    mov dword ptr [ebp - local_10], eax          # 004bf8e2
    mov ecx, dword ptr [ebp + arg_c]             # 004bf8e5
    mov edx, dword ptr [ecx]                     # 004bf8e8
    add edx, dword ptr [ebp - local_10]          # 004bf8ea
    mov dword ptr [ebp - local_8], edx           # 004bf8ed
    mov eax, dword ptr [ebp - local_8]           # 004bf8f0
    mov cx, word ptr [eax]                       # 004bf8f3
    mov word ptr [ebp - local_4], cx             # 004bf8f6
    movsx edx, word ptr [ebp - local_4]          # 004bf8fa
    imul edx, edx, 0x22                          # 004bf8fe
    mov eax, dword ptr [ebp - local_10]          # 004bf901
    lea ecx, [eax + edx + field_2]               # 004bf904
    mov dword ptr [ebp - local_10], ecx          # 004bf908
    mov edx, dword ptr [ebp - local_10]          # 004bf90b
    push edx                                     # 004bf90e
    call FUN_0051dc43                            # 004bf90f
    add esp, 0x4                                 # 004bf914
    mov dword ptr [ebp - local_14], eax          # 004bf917
    mov eax, dword ptr [ebp + arg_8]             # 004bf91a
    mov ecx, dword ptr [ebp - local_14]          # 004bf91d
    mov dword ptr [eax], ecx                     # 004bf920
    cmp dword ptr [ebp - local_14], 0x0          # 004bf922
    jne.d8 L_004bf966                            # 004bf926
    # block 0x004bf928: entered by fall-through of jne at 0x004bf926, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004bf966
    movsx edx, word ptr [0x5c39e3]               # 004bf928
    push edx                                     # 004bf92f
    mov eax, dword ptr [0x5bb57b]                # 004bf930
    push eax                                     # 004bf935
    push 0x5526a4                                # 004bf936
    push 0x63888b                                # 004bf93b
    call FUN_0050ca3e                            # 004bf940
    add esp, 0x10                                # 004bf945
    push 0x63888b                                # 004bf948
    push 0x5526d0                                # 004bf94d
    mov ecx, 0x583979                            # 004bf952
    call FUN_0042639d                            # 004bf957
    mov ecx, 0x5cf659                            # 004bf95c
    call FUN_004c97b4                            # 004bf961
L_004bf966:
    # block 0x004bf966: entered by jne at 0x004bf926, 24 instruction(s), ends with je to 0x004bf9b3 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004bf966
    mov edx, dword ptr [ebp + arg_c]             # 004bf969
    mov esi, dword ptr [edx]                     # 004bf96c
    mov eax, dword ptr [ebp + arg_8]             # 004bf96e
    mov edi, dword ptr [eax]                     # 004bf971
    {load} mov edx, ecx                          # 004bf973
    shr ecx, 0x2                                 # 004bf975
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004bf978
    {load} mov ecx, edx                          # 004bf97a
    and ecx, 0x3                                 # 004bf97c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004bf97f
    mov eax, dword ptr [ebp + arg_10]            # 004bf981
    mov ecx, dword ptr [eax]                     # 004bf984
    add ecx, dword ptr [ebp - local_10]          # 004bf986
    mov edx, dword ptr [ebp + arg_10]            # 004bf989
    mov dword ptr [edx], ecx                     # 004bf98c
    mov eax, dword ptr [ebp + arg_c]             # 004bf98e
    mov ecx, dword ptr [eax]                     # 004bf991
    add ecx, dword ptr [ebp - local_10]          # 004bf993
    mov edx, dword ptr [ebp + arg_c]             # 004bf996
    mov dword ptr [edx], ecx                     # 004bf999
    movsx eax, word ptr [0x63a4cd]               # 004bf99b
    test eax, eax                                # 004bf9a2
    je.d8 L_004bf9b3                             # 004bf9a4
    # block 0x004bf9a6: entered by fall-through of je at 0x004bf9a4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004bf9b3
    push 0x5526ec                                # 004bf9a6
    call FUN_0044a2b7                            # 004bf9ab
    add esp, 0x4                                 # 004bf9b0
L_004bf9b3:
    # block 0x004bf9b3: entered by je at 0x004bf9a4, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004bf9b3
    pop esi                                      # 004bf9b4
    {load} mov esp, ebp                          # 004bf9b5
    pop ebp                                      # 004bf9b7
    ret 0xc                                      # 004bf9b8

