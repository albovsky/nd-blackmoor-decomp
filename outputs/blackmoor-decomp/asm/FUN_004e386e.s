# FUN_004e386e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e386e
# extent:       0x004e386e-0x004e3a64 (502 code bytes)
# span:         0x004e386e-0x004e3a64 (code 502, tables 0, padding 0)
# sha256:       463c4e19beca6dcc0f581edee45c07e92a3307bc0fc914324900668ac7580c98
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_scene_change_80_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_80_runtime.h:20 says "0x4e386e w = signed body word. w != 9999 (0x270f)"
# name-note:    Handler of raw 0x80: sets scene-change cells from a signed body word (9999 meaning none).
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_6b2, field_6b4, field_6ba, field_6bc, field_6c6, field_4530; [ecx + n] field_6b2, field_6b4, field_6ba, field_6c2, field_4528; [edi + n] field_minus_1; [edx + n] field_6ba, field_6be, field_6ca, field_4528, field_65d2
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_00427a40
# track-n:      outputs/blackmoor-decomp/src/action_family_80_runtime.h:action_family_80_runtime_visit (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 107 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_6b2, 0x6b2  # offset +0x6b2
.equ field_6b4, 0x6b4  # offset +0x6b4
.equ field_6ba, 0x6ba  # offset +0x6ba
.equ field_6bc, 0x6bc  # offset +0x6bc
.equ field_6be, 0x6be  # offset +0x6be
.equ field_6c2, 0x6c2  # offset +0x6c2
.equ field_6c6, 0x6c6  # offset +0x6c6
.equ field_6ca, 0x6ca  # offset +0x6ca
.equ field_4528, 0x4528  # offset +0x4528
.equ field_4530, 0x4530  # offset +0x4530
.equ field_65d2, 0x65d2  # offset +0x65d2

# --- external targets -----------------------------------------------
.set FUN_00427a40, .text + (0x00427a40 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e386e - 0x401000
.globl FUN_004e386e
FUN_004e386e:
    # block 0x004e386e: entry, 12 instruction(s), ends with je to 0x004e38ff (forward)
    push ebp                                     # 004e386e
    {load} mov ebp, esp                          # 004e386f
    sub esp, 0xc                                 # 004e3871
    push edi                                     # 004e3874
    mov dword ptr [ebp - local_8], ecx           # 004e3875
    movsx eax, word ptr [ebp + arg_8]            # 004e3878
    imul eax, eax, 0x8d                          # 004e387c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004e3882
    mov dword ptr [ebp - local_4], ecx           # 004e3888
    movsx edx, word ptr [0x63a4cd]               # 004e388b
    test edx, edx                                # 004e3892
    je.d8 L_004e38ff                             # 004e3894
    # block 0x004e3896: entered by fall-through of je at 0x004e3894, 21 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, ends with je to 0x004e38ef (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e3896
    movsx ecx, word ptr [eax + field_6ba]        # 004e3899
    push ecx                                     # 004e38a0
    mov edx, dword ptr [0x5bb57b]                # 004e38a1
    push edx                                     # 004e38a7
    push 0x55c06c                                # 004e38a8
    push 0x63888b                                # 004e38ad
    call FUN_0050ca3e                            # 004e38b2
    add esp, 0x10                                # 004e38b7
    push 0x63888b                                # 004e38ba
    call FUN_0044a2b7                            # 004e38bf
    add esp, 0x4                                 # 004e38c4
    mov edi, 0x63888b                            # 004e38c7
    or ecx, -0x1                                 # 004e38cc
    {load} xor eax, eax                          # 004e38cf
    repne scasb al, byte ptr es:[edi]            # 004e38d1
    mov ax, word ptr [0x55c0bc]                  # 004e38d3
    mov word ptr [edi - field_minus_1], ax       # 004e38d9
    mov ecx, 0x1                                 # 004e38dd
    test ecx, ecx                                # 004e38e2
    je.d8 L_004e38ef                             # 004e38e4
    # block 0x004e38e6: entered by fall-through of je at 0x004e38e4, 2 instruction(s), ends with forward jump to 0x004e38ff
    mov dword ptr [ebp - local_c], 0x0           # 004e38e6
    jmp.d8 L_004e38ff                            # 004e38ed
L_004e38ef:
    # block 0x004e38ef: entered by je at 0x004e38e4, 4 instruction(s), calls FUN_00427a40, falls into the block at 0x004e38ff
    push 0x63888b                                # 004e38ef
    call FUN_00427a40                            # 004e38f4
    add esp, 0x4                                 # 004e38f9
    mov dword ptr [ebp - local_c], eax           # 004e38fc
L_004e38ff:
    # block 0x004e38ff: entered by je at 0x004e3894; jmp at 0x004e38ed, 4 instruction(s), ends with je to 0x004e395f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e38ff
    movsx eax, word ptr [edx]                    # 004e3902
    cmp eax, 0x270f                              # 004e3905
    je.d8 L_004e395f                             # 004e390a
    # block 0x004e390c: entered by fall-through of je at 0x004e390a, 13 instruction(s), ends with forward jump to 0x004e397e
    mov ecx, dword ptr [ebp - local_4]           # 004e390c
    movsx edx, word ptr [ecx]                    # 004e390f
    mov dword ptr [0x5bb57b], edx                # 004e3912
    mov eax, dword ptr [ebp - local_4]           # 004e3918
    movsx ecx, word ptr [eax]                    # 004e391b
    mov dword ptr [0x5bb57f], ecx                # 004e391e
    mov word ptr [0x5bb599], 0x0                 # 004e3924
    mov word ptr [0x5bb595], 0x0                 # 004e392d
    mov dword ptr [0x5bb59b], 0x0                # 004e3936
    mov dword ptr [0x5bb59f], 0x0                # 004e3940
    mov dword ptr [0x5bb5a3], 0x1                # 004e394a
    mov word ptr [0x5c39ff], 0x1                 # 004e3954
    jmp.d8 L_004e397e                            # 004e395d
L_004e395f:
    # block 0x004e395f: entered by je at 0x004e390a, 6 instruction(s), falls into the block at 0x004e397e
    mov edx, dword ptr [ebp - local_8]           # 004e395f
    movsx eax, word ptr [edx + field_6ba]        # 004e3962
    mov dword ptr [0x5bb57b], eax                # 004e3969
    mov ecx, dword ptr [ebp - local_8]           # 004e396e
    movsx edx, word ptr [ecx + field_6ba]        # 004e3971
    mov dword ptr [0x5bb57f], edx                # 004e3978
L_004e397e:
    # block 0x004e397e: entered by jmp at 0x004e395d, 20 instruction(s), ends with je to 0x004e39f8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e397e
    mov cx, word ptr [eax + field_6bc]           # 004e3981
    mov word ptr [0x5bb599], cx                  # 004e3988
    mov edx, dword ptr [ebp - local_8]           # 004e398f
    mov ax, word ptr [edx + field_6be]           # 004e3992
    mov word ptr [0x5bb595], ax                  # 004e3999
    mov ecx, dword ptr [ebp - local_8]           # 004e399f
    mov edx, dword ptr [ecx + field_6c2]         # 004e39a2
    mov dword ptr [0x5bb59b], edx                # 004e39a8
    mov eax, dword ptr [ebp - local_8]           # 004e39ae
    mov ecx, dword ptr [eax + field_6c6]         # 004e39b1
    mov dword ptr [0x5bb59f], ecx                # 004e39b7
    mov edx, dword ptr [ebp - local_8]           # 004e39bd
    mov eax, dword ptr [edx + field_6ca]         # 004e39c0
    mov dword ptr [0x5bb5a3], eax                # 004e39c6
    mov word ptr [0x5c39ff], 0x1                 # 004e39cb
    mov dword ptr [0x583999], 0x4                # 004e39d4
    mov ecx, dword ptr [ebp - local_8]           # 004e39de
    cmp dword ptr [ecx + field_4528], 0x2        # 004e39e1
    je.d8 L_004e39f8                             # 004e39e8
    # block 0x004e39ea: entered by fall-through of je at 0x004e39e8, 3 instruction(s), ends with je to 0x004e39f8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004e39ea
    cmp dword ptr [edx + field_4528], 0x3        # 004e39ed
    je.d8 L_004e39f8                             # 004e39f4
    # block 0x004e39f6: entered by fall-through of je at 0x004e39f4, 1 instruction(s), ends with forward jump to 0x004e3a5d
    jmp.d8 L_004e3a5d                            # 004e39f6
L_004e39f8:
    # block 0x004e39f8: entered by je at 0x004e39e8; je at 0x004e39f4, 8 instruction(s), ends with je to 0x004e3a5d (forward)
    mov dword ptr [0x583204], 0x5                # 004e39f8
    mov dword ptr [0x5bb22a], 0x0                # 004e3a02
    mov eax, dword ptr [ebp - local_8]           # 004e3a0c
    mov dword ptr [eax + field_4530], 0x0        # 004e3a0f
    mov ecx, dword ptr [ebp - local_8]           # 004e3a19
    movsx edx, word ptr [ecx + field_6b2]        # 004e3a1c
    cmp edx, 0x270f                              # 004e3a23
    je.d8 L_004e3a5d                             # 004e3a29
    # block 0x004e3a2b: entered by fall-through of je at 0x004e3a29, 5 instruction(s), ends with je to 0x004e3a5d (forward)
    mov eax, dword ptr [ebp - local_8]           # 004e3a2b
    mov word ptr [eax + field_6b2], 0x270f       # 004e3a2e
    mov ecx, dword ptr [ebp - local_8]           # 004e3a37
    cmp dword ptr [ecx + field_6b4], 0x0         # 004e3a3a
    je.d8 L_004e3a5d                             # 004e3a41
    # block 0x004e3a43: entered by fall-through of je at 0x004e3a41, 4 instruction(s), falls into the block at 0x004e3a5d
    mov edx, dword ptr [ebp - local_8]           # 004e3a43
    mov dword ptr [edx + field_65d2], 0x1        # 004e3a46
    mov eax, dword ptr [ebp - local_8]           # 004e3a50
    mov dword ptr [eax + field_6b4], 0x0         # 004e3a53
L_004e3a5d:
    # block 0x004e3a5d: entered by jmp at 0x004e39f6; je at 0x004e3a29; je at 0x004e3a41, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004e3a5d
    {load} mov esp, ebp                          # 004e3a5e
    pop ebp                                      # 004e3a60
    ret 0x4                                      # 004e3a61

