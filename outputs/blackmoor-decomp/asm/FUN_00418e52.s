# FUN_00418e52
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00418e52
# extent:       0x00418e52-0x00419955 (2819 code bytes)
# span:         0x00418e52-0x00419955 (code 2819, tables 0, padding 0)
# sha256:       b16715370f3691ea9a1526361da9f30d45c845cd1818a967f7c4941ee828e922
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_resource_payload_reader
# naming:       INFERRED (lower confidence, not verified): the repository text archive-recovery.md:15 says "`0x418e52` | Uppercases a query, resolves a resource and reads its payload"
# name-note:    Uppercases a query, resolves a resource and reads its payload (CIFTREE file image).
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       32 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_118, local_11c, local_120, local_128, local_152, local_154, local_16c and 20 more
# fields:       [eax + n] field_1, field_51, field_59, field_5d, field_571, field_573, field_577, field_57f, field_5c0; [ecx + n] field_27, field_51, field_59, field_571, field_577, field_57b, field_5c4; [edx + n] field_1, field_23, field_51, field_59, field_5d, field_571, field_577, field_57b, field_845
# callees:      calls FUN_0050d0bc, FUN_0050cd72, FUN_0041a102, FUN_0050d0a9, FUN_0050cf61, FUN_0050ca3e, FUN_0052139c, FUN_0051dc43, FUN_0041b6e2, FUN_0050cee4, FUN_004c7314, FUN_0041a216, FUN_0041a19c, FUN_0050ce2b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 716 instruction(s), 34 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_128, 0x128  # offset -0x128
.equ local_152, 0x152  # offset -0x152
.equ local_154, 0x154  # offset -0x154
.equ local_16c, 0x16c  # offset -0x16c
.equ local_170, 0x170  # offset -0x170
.equ local_174, 0x174  # offset -0x174
.equ local_178, 0x178  # offset -0x178
.equ local_17c, 0x17c  # offset -0x17c
.equ local_180, 0x180  # offset -0x180
.equ local_184, 0x184  # offset -0x184
.equ local_188, 0x188  # offset -0x188
.equ local_18c, 0x18c  # offset -0x18c
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1a9, 0x1a9  # offset -0x1a9
.equ local_1aa, 0x1aa  # offset -0x1aa
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ local_1b4, 0x1b4  # offset -0x1b4
.equ local_1b8, 0x1b8  # offset -0x1b8
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_51, 0x51  # offset +0x51
.equ field_59, 0x59  # offset +0x59
.equ field_5d, 0x5d  # offset +0x5d
.equ field_571, 0x571  # offset +0x571
.equ field_573, 0x573  # offset +0x573
.equ field_577, 0x577  # offset +0x577
.equ field_57b, 0x57b  # offset +0x57b
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5c0, 0x5c0  # offset +0x5c0
.equ field_5c4, 0x5c4  # offset +0x5c4
.equ field_845, 0x845  # offset +0x845

# --- external targets -----------------------------------------------
.set FUN_0041a102, .text + (0x0041a102 - 0x401000)
.set FUN_0041a19c, .text + (0x0041a19c - 0x401000)
.set FUN_0041a216, .text + (0x0041a216 - 0x401000)
.set FUN_0041b6e2, .text + (0x0041b6e2 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00418e52 - 0x401000
.globl FUN_00418e52
FUN_00418e52:
    # block 0x00418e52: entry, 17 instruction(s), calls FUN_0050d0bc, ends with je to 0x004191e7 (forward)
    push ebp                                     # 00418e52
    {load} mov ebp, esp                          # 00418e53
    sub esp, 0x1b8                               # 00418e55
    push esi                                     # 00418e5b
    push edi                                     # 00418e5c
    mov dword ptr [ebp - local_19c], ecx         # 00418e5d
    mov eax, dword ptr [ebp + arg_10]            # 00418e63
    mov dword ptr [eax], 0x0                     # 00418e66
    mov dword ptr [ebp - local_14], 0x0          # 00418e6c
    mov dword ptr [ebp - local_4], 0x0           # 00418e73
    mov ecx, dword ptr [ebp + arg_c]             # 00418e7a
    push ecx                                     # 00418e7d
    call FUN_0050d0bc                            # 00418e7e
    add esp, 0x4                                 # 00418e83
    mov dword ptr [ebp + arg_c], eax             # 00418e86
    cmp dword ptr [0x5bb1fe], 0x0                # 00418e89
    je.d32 L_004191e7                            # 00418e90
    # block 0x00418e96: entered by fall-through of je at 0x00418e90, 20 instruction(s), calls FUN_0050cd72, FUN_0041a102, ends with je to 0x004191e7 (forward)
    push 0x542a84                                # 00418e96
    mov edx, dword ptr [ebp + arg_c]             # 00418e9b
    push edx                                     # 00418e9e
    mov eax, dword ptr [ebp - local_19c]         # 00418e9f
    add eax, 0x1f                                # 00418ea5
    push eax                                     # 00418ea8
    mov ecx, dword ptr [ebp - local_19c]         # 00418ea9
    add ecx, 0x1c                                # 00418eaf
    push ecx                                     # 00418eb2
    lea edx, [ebp - local_118]                   # 00418eb3
    push edx                                     # 00418eb9
    call FUN_0050cd72                            # 00418eba
    add esp, 0x14                                # 00418ebf
    lea eax, [ebp - local_118]                   # 00418ec2
    push eax                                     # 00418ec8
    mov ecx, dword ptr [ebp - local_19c]         # 00418ec9
    call FUN_0041a102                            # 00418ecf
    movsx ecx, ax                                # 00418ed4
    test ecx, ecx                                # 00418ed7
    je.d32 L_004191e7                            # 00418ed9
    # block 0x00418edf: entered by fall-through of je at 0x00418ed9, 16 instruction(s), calls FUN_0050d0a9, FUN_0050cf61, ends with je to 0x00418f4d (forward)
    push 0x542a8c                                # 00418edf
    lea edx, [ebp - local_118]                   # 00418ee4
    push edx                                     # 00418eea
    call FUN_0050d0a9                            # 00418eeb
    add esp, 0x8                                 # 00418ef0
    mov dword ptr [ebp - local_8], eax           # 00418ef3
    mov eax, dword ptr [ebp - local_8]           # 00418ef6
    push eax                                     # 00418ef9
    push 0x1                                     # 00418efa
    push 0x51                                    # 00418efc
    lea ecx, [ebp - local_16c]                   # 00418efe
    push ecx                                     # 00418f04
    call FUN_0050cf61                            # 00418f05
    add esp, 0x10                                # 00418f0a
    cmp eax, 0x1                                 # 00418f0d
    je.d8 L_00418f4d                             # 00418f10
    # block 0x00418f12: entered by fall-through of je at 0x00418f10, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419948
    lea edx, [ebp - local_118]                   # 00418f12
    push edx                                     # 00418f18
    push 0x542a90                                # 00418f19
    mov eax, dword ptr [ebp - local_19c]         # 00418f1e
    add eax, 0x31f                               # 00418f24
    push eax                                     # 00418f29
    call FUN_0050ca3e                            # 00418f2a
    add esp, 0xc                                 # 00418f2f
    push 0x0                                     # 00418f32
    push 0x0                                     # 00418f34
    mov ecx, dword ptr [ebp - local_19c]         # 00418f36
    add ecx, 0x31f                               # 00418f3c
    push ecx                                     # 00418f42
    call FUN_0052139c                            # 00418f43
    jmp.d32 L_00419948                           # 00418f48
L_00418f4d:
    # block 0x00418f4d: entered by je at 0x00418f10, 6 instruction(s), ends with jne to 0x00418f84 (forward)
    mov edi, 0x542abc                            # 00418f4d
    lea esi, [ebp - local_16c]                   # 00418f52
    mov ecx, 0x14                                # 00418f58
    {load} xor edx, edx                          # 00418f5d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00418f5f
    jne.d8 L_00418f84                            # 00418f61
    # block 0x00418f63: entered by fall-through of jne at 0x00418f61, 4 instruction(s), ends with jne to 0x00418f84 (forward)
    mov eax, dword ptr [ebp - local_154]         # 00418f63
    and eax, 0xffff                              # 00418f69
    cmp eax, 0x2                                 # 00418f6e
    jne.d8 L_00418f84                            # 00418f71
    # block 0x00418f73: entered by fall-through of jne at 0x00418f71, 4 instruction(s), ends with je to 0x00418f97 (forward)
    mov ecx, dword ptr [ebp - local_152]         # 00418f73
    and ecx, 0xffff                              # 00418f79
    cmp ecx, 0x1                                 # 00418f7f
    je.d8 L_00418f97                             # 00418f82
L_00418f84:
    # block 0x00418f84: entered by jne at 0x00418f61; jne at 0x00418f71; fall-through of je at 0x00418f82, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419943
    push 0x0                                     # 00418f84
    push 0x0                                     # 00418f86
    push 0x542ad0                                # 00418f88
    call FUN_0052139c                            # 00418f8d
    jmp.d32 L_00419943                           # 00418f92
L_00418f97:
    # block 0x00418f97: entered by je at 0x00418f82, 4 instruction(s), ends with je to 0x00418fbe (forward)
    mov dl, byte ptr [ebp - local_11c]           # 00418f97
    mov byte ptr [ebp - local_1a0], dl           # 00418f9d
    cmp byte ptr [ebp - local_1a0], 0x2          # 00418fa3
    je.d8 L_00418fbe                             # 00418faa
    # block 0x00418fac: entered by fall-through of je at 0x00418faa, 2 instruction(s), ends with je to 0x004190dd (forward)
    cmp byte ptr [ebp - local_1a0], 0x3          # 00418fac
    je.d32 L_004190dd                            # 00418fb3
    # block 0x00418fb9: entered by fall-through of je at 0x00418fb3, 1 instruction(s), ends with forward jump to 0x004191e7
    jmp.d32 L_004191e7                           # 00418fb9
L_00418fbe:
    # block 0x00418fbe: entered by je at 0x00418faa, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00418ff5 (forward)
    mov eax, dword ptr [ebp - local_120]         # 00418fbe
    push eax                                     # 00418fc4
    call FUN_0051dc43                            # 00418fc5
    add esp, 0x4                                 # 00418fca
    mov dword ptr [ebp - local_170], eax         # 00418fcd
    mov ecx, dword ptr [ebp - local_170]         # 00418fd3
    mov dword ptr [ebp - local_4], ecx           # 00418fd9
    cmp dword ptr [ebp - local_4], 0x0           # 00418fdc
    jne.d8 L_00418ff5                            # 00418fe0
    # block 0x00418fe2: entered by fall-through of jne at 0x00418fe0, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0041993e
    push 0x0                                     # 00418fe2
    push 0x0                                     # 00418fe4
    push 0x542b08                                # 00418fe6
    call FUN_0052139c                            # 00418feb
    jmp.d32 L_0041993e                           # 00418ff0
L_00418ff5:
    # block 0x00418ff5: entered by jne at 0x00418fe0, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041902c (forward)
    mov edx, dword ptr [ebp - local_128]         # 00418ff5
    push edx                                     # 00418ffb
    call FUN_0051dc43                            # 00418ffc
    add esp, 0x4                                 # 00419001
    mov dword ptr [ebp - local_174], eax         # 00419004
    mov eax, dword ptr [ebp - local_174]         # 0041900a
    mov dword ptr [ebp - local_14], eax          # 00419010
    cmp dword ptr [ebp - local_14], 0x0          # 00419013
    jne.d8 L_0041902c                            # 00419017
    # block 0x00419019: entered by fall-through of jne at 0x00419017, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419939
    push 0x0                                     # 00419019
    push 0x0                                     # 0041901b
    push 0x542b3c                                # 0041901d
    call FUN_0052139c                            # 00419022
    jmp.d32 L_00419939                           # 00419027
L_0041902c:
    # block 0x0041902c: entered by jne at 0x00419017, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x00419085 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0041902c
    push ecx                                     # 0041902f
    push 0x1                                     # 00419030
    mov edx, dword ptr [ebp - local_120]         # 00419032
    push edx                                     # 00419038
    mov eax, dword ptr [ebp - local_4]           # 00419039
    push eax                                     # 0041903c
    call FUN_0050cf61                            # 0041903d
    add esp, 0x10                                # 00419042
    cmp eax, 0x1                                 # 00419045
    je.d8 L_00419085                             # 00419048
    # block 0x0041904a: entered by fall-through of je at 0x00419048, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419934
    lea ecx, [ebp - local_118]                   # 0041904a
    push ecx                                     # 00419050
    push 0x542b6c                                # 00419051
    mov edx, dword ptr [ebp - local_19c]         # 00419056
    add edx, 0x31f                               # 0041905c
    push edx                                     # 00419062
    call FUN_0050ca3e                            # 00419063
    add esp, 0xc                                 # 00419068
    push 0x0                                     # 0041906b
    push 0x0                                     # 0041906d
    mov eax, dword ptr [ebp - local_19c]         # 0041906f
    add eax, 0x31f                               # 00419075
    push eax                                     # 0041907a
    call FUN_0052139c                            # 0041907b
    jmp.d32 L_00419934                           # 00419080
L_00419085:
    # block 0x00419085: entered by je at 0x00419048, 25 instruction(s), calls FUN_0041b6e2, FUN_0050cee4, FUN_004c7314, ends with forward jump to 0x0041992f
    mov ecx, dword ptr [ebp - local_128]         # 00419085
    push ecx                                     # 0041908b
    mov edx, dword ptr [ebp - local_120]         # 0041908c
    push edx                                     # 00419092
    mov eax, dword ptr [ebp - local_14]          # 00419093
    push eax                                     # 00419096
    mov ecx, dword ptr [ebp - local_4]           # 00419097
    push ecx                                     # 0041909a
    mov ecx, dword ptr [ebp - local_19c]         # 0041909b
    add ecx, 0x51f                               # 004190a1
    call FUN_0041b6e2                            # 004190a7
    mov edx, dword ptr [ebp - local_8]           # 004190ac
    push edx                                     # 004190af
    call FUN_0050cee4                            # 004190b0
    add esp, 0x4                                 # 004190b5
    mov eax, dword ptr [ebp - local_128]         # 004190b8
    push eax                                     # 004190be
    mov ecx, dword ptr [ebp - local_14]          # 004190bf
    push ecx                                     # 004190c2
    mov ecx, 0x5cf659                            # 004190c3
    call FUN_004c7314                            # 004190c8
    mov edx, dword ptr [ebp + arg_10]            # 004190cd
    mov eax, dword ptr [ebp - local_128]         # 004190d0
    mov dword ptr [edx], eax                     # 004190d6
    jmp.d32 L_0041992f                           # 004190d8
L_004190dd:
    # block 0x004190dd: entered by je at 0x00418fb3, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00419114 (forward)
    mov ecx, dword ptr [ebp - local_120]         # 004190dd
    push ecx                                     # 004190e3
    call FUN_0051dc43                            # 004190e4
    add esp, 0x4                                 # 004190e9
    mov dword ptr [ebp - local_178], eax         # 004190ec
    mov edx, dword ptr [ebp - local_178]         # 004190f2
    mov dword ptr [ebp - local_4], edx           # 004190f8
    cmp dword ptr [ebp - local_4], 0x0           # 004190fb
    jne.d8 L_00419114                            # 004190ff
    # block 0x00419101: entered by fall-through of jne at 0x004190ff, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0041992d
    push 0x0                                     # 00419101
    push 0x0                                     # 00419103
    push 0x542b8c                                # 00419105
    call FUN_0052139c                            # 0041910a
    jmp.d32 L_0041992d                           # 0041910f
L_00419114:
    # block 0x00419114: entered by jne at 0x004190ff, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041914b (forward)
    mov eax, dword ptr [ebp - local_128]         # 00419114
    push eax                                     # 0041911a
    call FUN_0051dc43                            # 0041911b
    add esp, 0x4                                 # 00419120
    mov dword ptr [ebp - local_17c], eax         # 00419123
    mov ecx, dword ptr [ebp - local_17c]         # 00419129
    mov dword ptr [ebp - local_14], ecx          # 0041912f
    cmp dword ptr [ebp - local_14], 0x0          # 00419132
    jne.d8 L_0041914b                            # 00419136
    # block 0x00419138: entered by fall-through of jne at 0x00419136, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0041992b
    push 0x0                                     # 00419138
    push 0x0                                     # 0041913a
    push 0x542bc0                                # 0041913c
    call FUN_0052139c                            # 00419141
    jmp.d32 L_0041992b                           # 00419146
L_0041914b:
    # block 0x0041914b: entered by jne at 0x00419136, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x004191a4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041914b
    push edx                                     # 0041914e
    push 0x1                                     # 0041914f
    mov eax, dword ptr [ebp - local_120]         # 00419151
    push eax                                     # 00419157
    mov ecx, dword ptr [ebp - local_4]           # 00419158
    push ecx                                     # 0041915b
    call FUN_0050cf61                            # 0041915c
    add esp, 0x10                                # 00419161
    cmp eax, 0x1                                 # 00419164
    je.d8 L_004191a4                             # 00419167
    # block 0x00419169: entered by fall-through of je at 0x00419167, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419929
    lea edx, [ebp - local_118]                   # 00419169
    push edx                                     # 0041916f
    push 0x542bf0                                # 00419170
    mov eax, dword ptr [ebp - local_19c]         # 00419175
    add eax, 0x31f                               # 0041917b
    push eax                                     # 00419180
    call FUN_0050ca3e                            # 00419181
    add esp, 0xc                                 # 00419186
    push 0x0                                     # 00419189
    push 0x0                                     # 0041918b
    mov ecx, dword ptr [ebp - local_19c]         # 0041918d
    add ecx, 0x31f                               # 00419193
    push ecx                                     # 00419199
    call FUN_0052139c                            # 0041919a
    jmp.d32 L_00419929                           # 0041919f
L_004191a4:
    # block 0x004191a4: entered by je at 0x00419167, 19 instruction(s), calls FUN_0041b6e2, FUN_0050cee4, ends with forward jump to 0x00419924
    mov edx, dword ptr [ebp - local_128]         # 004191a4
    push edx                                     # 004191aa
    mov eax, dword ptr [ebp - local_120]         # 004191ab
    push eax                                     # 004191b1
    mov ecx, dword ptr [ebp - local_14]          # 004191b2
    push ecx                                     # 004191b5
    mov edx, dword ptr [ebp - local_4]           # 004191b6
    push edx                                     # 004191b9
    mov ecx, dword ptr [ebp - local_19c]         # 004191ba
    add ecx, 0x51f                               # 004191c0
    call FUN_0041b6e2                            # 004191c6
    mov eax, dword ptr [ebp - local_8]           # 004191cb
    push eax                                     # 004191ce
    call FUN_0050cee4                            # 004191cf
    add esp, 0x4                                 # 004191d4
    mov ecx, dword ptr [ebp + arg_10]            # 004191d7
    mov edx, dword ptr [ebp - local_128]         # 004191da
    mov dword ptr [ecx], edx                     # 004191e0
    jmp.d32 L_00419924                           # 004191e2
L_004191e7:
    # block 0x004191e7: entered by je at 0x00418e90; je at 0x00418ed9; jmp at 0x00418fb9, 10 instruction(s), calls FUN_0041a216, ends with jne to 0x0041924d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004191e7
    push eax                                     # 004191ea
    mov ecx, dword ptr [ebp - local_19c]         # 004191eb
    call FUN_0041a216                            # 004191f1
    mov ecx, dword ptr [ebp - local_19c]         # 004191f6
    mov word ptr [ecx + field_571], ax           # 004191fc
    mov edx, dword ptr [ebp - local_19c]         # 00419203
    movsx eax, word ptr [edx + field_571]        # 00419209
    cmp eax, -0x1                                # 00419210
    jne.d8 L_0041924d                            # 00419213
    # block 0x00419215: entered by fall-through of jne at 0x00419213, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419922
    mov ecx, dword ptr [ebp + arg_8]             # 00419215
    push ecx                                     # 00419218
    push 0x542c10                                # 00419219
    mov edx, dword ptr [ebp - local_19c]         # 0041921e
    add edx, 0x31f                               # 00419224
    push edx                                     # 0041922a
    call FUN_0050ca3e                            # 0041922b
    add esp, 0xc                                 # 00419230
    push 0x0                                     # 00419233
    push 0x0                                     # 00419235
    mov eax, dword ptr [ebp - local_19c]         # 00419237
    add eax, 0x31f                               # 0041923d
    push eax                                     # 00419242
    call FUN_0052139c                            # 00419243
    jmp.d32 L_00419922                           # 00419248
L_0041924d:
    # block 0x0041924d: entered by jne at 0x00419213, 34 instruction(s), calls FUN_0041a19c, ends with jne to 0x0041933d (forward)
    mov ecx, dword ptr [ebp - local_19c]         # 0041924d
    movsx edx, word ptr [ecx + field_571]        # 00419253
    imul edx, edx, 0x84d                         # 0041925a
    mov eax, dword ptr [ebp - local_19c]         # 00419260
    lea ecx, [eax + edx + field_57f]             # 00419266
    mov edx, dword ptr [ebp - local_19c]         # 0041926d
    mov dword ptr [edx + field_57b], ecx         # 00419273
    mov eax, dword ptr [ebp - local_19c]         # 00419279
    movsx ecx, word ptr [eax + field_571]        # 0041927f
    imul ecx, ecx, 0x84d                         # 00419286
    mov edx, dword ptr [ebp - local_19c]         # 0041928c
    mov eax, dword ptr [ebp - local_19c]         # 00419292
    mov ecx, dword ptr [eax + ecx + field_5c0]   # 00419298
    mov dword ptr [edx + field_577], ecx         # 0041929f
    mov edx, dword ptr [ebp - local_19c]         # 004192a5
    movsx eax, word ptr [edx + field_571]        # 004192ab
    imul eax, eax, 0x84d                         # 004192b2
    mov ecx, dword ptr [ebp - local_19c]         # 004192b8
    lea edx, [ecx + eax + field_5c4]             # 004192be
    mov eax, dword ptr [ebp - local_19c]         # 004192c5
    mov dword ptr [eax + field_573], edx         # 004192cb
    mov ecx, dword ptr [ebp + arg_c]             # 004192d1
    push ecx                                     # 004192d4
    mov ecx, dword ptr [ebp - local_19c]         # 004192d5
    call FUN_0041a19c                            # 004192db
    mov word ptr [ebp - local_c], ax             # 004192e0
    movsx edx, word ptr [ebp - local_c]          # 004192e4
    mov eax, dword ptr [ebp - local_19c]         # 004192e8
    mov ecx, dword ptr [eax + field_573]         # 004192ee
    mov dx, word ptr [ecx + 2*edx]               # 004192f4
    mov word ptr [ebp - local_10], dx            # 004192f8
    movsx eax, word ptr [ebp - local_10]         # 004192fc
    cmp eax, -0x1                                # 00419300
    jne.d8 L_0041933d                            # 00419303
    # block 0x00419305: entered by fall-through of jne at 0x00419303, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419920
    mov ecx, dword ptr [ebp + arg_c]             # 00419305
    push ecx                                     # 00419308
    push 0x542c4c                                # 00419309
    mov edx, dword ptr [ebp - local_19c]         # 0041930e
    add edx, 0x31f                               # 00419314
    push edx                                     # 0041931a
    call FUN_0050ca3e                            # 0041931b
    add esp, 0xc                                 # 00419320
    push 0x0                                     # 00419323
    push 0x0                                     # 00419325
    mov eax, dword ptr [ebp - local_19c]         # 00419327
    add eax, 0x31f                               # 0041932d
    push eax                                     # 00419332
    call FUN_0052139c                            # 00419333
    jmp.d32 L_00419920                           # 00419338
L_0041933d:
    # block 0x0041933d: entered by jne at 0x00419303; jmp at 0x0041944d, 3 instruction(s), ends with je to 0x00419452 (forward)
    mov ecx, 0x1                                 # 0041933d
    test ecx, ecx                                # 00419342
    je.d32 L_00419452                            # 00419344
    # block 0x0041934a: entered by fall-through of je at 0x00419344, 8 instruction(s), falls into the block at 0x0041936e
    mov edx, dword ptr [ebp + arg_c]             # 0041934a
    mov dword ptr [ebp - local_1a4], edx         # 0041934d
    movsx eax, word ptr [ebp - local_10]         # 00419353
    imul eax, eax, 0x5e                          # 00419357
    mov ecx, dword ptr [ebp - local_19c]         # 0041935a
    mov edx, dword ptr [ecx + field_577]         # 00419360
    {load} add edx, eax                          # 00419366
    mov dword ptr [ebp - local_1a8], edx         # 00419368
L_0041936e:
    # block 0x0041936e: entered by jne at 0x004193be, 6 instruction(s), ends with jne to 0x004193cc (forward)
    mov eax, dword ptr [ebp - local_1a8]         # 0041936e
    mov cl, byte ptr [eax]                       # 00419374
    mov byte ptr [ebp - local_1a9], cl           # 00419376
    mov edx, dword ptr [ebp - local_1a4]         # 0041937c
    cmp cl, byte ptr [edx]                       # 00419382
    jne.d8 L_004193cc                            # 00419384
    # block 0x00419386: entered by fall-through of jne at 0x00419384, 2 instruction(s), ends with je to 0x004193c0 (forward)
    cmp byte ptr [ebp - local_1a9], 0x0          # 00419386
    je.d8 L_004193c0                             # 0041938d
    # block 0x0041938f: entered by fall-through of je at 0x0041938d, 6 instruction(s), ends with jne to 0x004193cc (forward)
    mov eax, dword ptr [ebp - local_1a8]         # 0041938f
    mov cl, byte ptr [eax + field_1]             # 00419395
    mov byte ptr [ebp - local_1aa], cl           # 00419398
    mov edx, dword ptr [ebp - local_1a4]         # 0041939e
    cmp cl, byte ptr [edx + field_1]             # 004193a4
    jne.d8 L_004193cc                            # 004193a7
    # block 0x004193a9: entered by fall-through of jne at 0x004193a7, 4 instruction(s), ends with jne to 0x0041936e (backward)
    add dword ptr [ebp - local_1a8], 0x2         # 004193a9
    add dword ptr [ebp - local_1a4], 0x2         # 004193b0
    cmp byte ptr [ebp - local_1aa], 0x0          # 004193b7
    jne.d8 L_0041936e                            # 004193be
L_004193c0:
    # block 0x004193c0: entered by je at 0x0041938d; fall-through of jne at 0x004193be, 2 instruction(s), ends with forward jump to 0x004193d7
    mov dword ptr [ebp - local_1b0], 0x0         # 004193c0
    jmp.d8 L_004193d7                            # 004193ca
L_004193cc:
    # block 0x004193cc: entered by jne at 0x00419384; jne at 0x004193a7, 3 instruction(s), falls into the block at 0x004193d7
    {load} sbb eax, eax                          # 004193cc
    sbb eax, -0x1                                # 004193ce
    mov dword ptr [ebp - local_1b0], eax         # 004193d1
L_004193d7:
    # block 0x004193d7: entered by jmp at 0x004193ca, 4 instruction(s), ends with je to 0x0041944b (forward)
    mov ecx, dword ptr [ebp - local_1b0]         # 004193d7
    mov dword ptr [ebp - local_1b4], ecx         # 004193dd
    cmp dword ptr [ebp - local_1b4], 0x0         # 004193e3
    je.d8 L_0041944b                             # 004193ea
    # block 0x004193ec: entered by fall-through of je at 0x004193ea, 9 instruction(s), ends with jne to 0x00419449 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004193ec
    imul edx, edx, 0x5e                          # 004193f0
    mov eax, dword ptr [ebp - local_19c]         # 004193f3
    mov ecx, dword ptr [eax + field_577]         # 004193f9
    mov dx, word ptr [ecx + edx + field_27]      # 004193ff
    mov word ptr [ebp - local_10], dx            # 00419404
    movsx eax, word ptr [ebp - local_10]         # 00419408
    cmp eax, -0x1                                # 0041940c
    jne.d8 L_00419449                            # 0041940f
    # block 0x00419411: entered by fall-through of jne at 0x0041940f, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x0041991e
    mov ecx, dword ptr [ebp + arg_c]             # 00419411
    push ecx                                     # 00419414
    push 0x542c7c                                # 00419415
    mov edx, dword ptr [ebp - local_19c]         # 0041941a
    add edx, 0x31f                               # 00419420
    push edx                                     # 00419426
    call FUN_0050ca3e                            # 00419427
    add esp, 0xc                                 # 0041942c
    push 0x0                                     # 0041942f
    push 0x0                                     # 00419431
    mov eax, dword ptr [ebp - local_19c]         # 00419433
    add eax, 0x31f                               # 00419439
    push eax                                     # 0041943e
    call FUN_0052139c                            # 0041943f
    jmp.d32 L_0041991e                           # 00419444
L_00419449:
    # block 0x00419449: entered by jne at 0x0041940f, 1 instruction(s), ends with forward jump to 0x0041944d
    jmp.d8 L_0041944d                            # 00419449
L_0041944b:
    # block 0x0041944b: entered by je at 0x004193ea, 1 instruction(s), ends with forward jump to 0x00419452
    jmp.d8 L_00419452                            # 0041944b
L_0041944d:
    # block 0x0041944d: entered by jmp at 0x00419449, 1 instruction(s), ends with backward jump to 0x0041933d
    jmp.d32 L_0041933d                           # 0041944d
L_00419452:
    # block 0x00419452: entered by je at 0x00419344; jmp at 0x0041944b, 8 instruction(s), ends with je to 0x0041948a (forward)
    movsx ecx, word ptr [ebp - local_10]         # 00419452
    imul ecx, ecx, 0x5e                          # 00419456
    mov edx, dword ptr [ebp - local_19c]         # 00419459
    mov eax, dword ptr [edx + field_577]         # 0041945f
    mov cl, byte ptr [eax + ecx + field_5d]      # 00419465
    mov byte ptr [ebp - local_1b8], cl           # 00419469
    cmp byte ptr [ebp - local_1b8], 0x2          # 0041946f
    je.d8 L_0041948a                             # 00419476
    # block 0x00419478: entered by fall-through of je at 0x00419476, 2 instruction(s), ends with je to 0x00419667 (forward)
    cmp byte ptr [ebp - local_1b8], 0x3          # 00419478
    je.d32 L_00419667                            # 0041947f
    # block 0x00419485: entered by fall-through of je at 0x0041947f, 1 instruction(s), ends with forward jump to 0x0041981e
    jmp.d32 L_0041981e                           # 00419485
L_0041948a:
    # block 0x0041948a: entered by je at 0x00419476, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004194d2 (forward)
    movsx edx, word ptr [ebp - local_10]         # 0041948a
    imul edx, edx, 0x5e                          # 0041948e
    mov eax, dword ptr [ebp - local_19c]         # 00419491
    mov ecx, dword ptr [eax + field_577]         # 00419497
    mov edx, dword ptr [ecx + edx + field_59]    # 0041949d
    push edx                                     # 004194a1
    call FUN_0051dc43                            # 004194a2
    add esp, 0x4                                 # 004194a7
    mov dword ptr [ebp - local_180], eax         # 004194aa
    mov eax, dword ptr [ebp - local_180]         # 004194b0
    mov dword ptr [ebp - local_4], eax           # 004194b6
    cmp dword ptr [ebp - local_4], 0x0           # 004194b9
    jne.d8 L_004194d2                            # 004194bd
    # block 0x004194bf: entered by fall-through of jne at 0x004194bd, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0041991c
    push 0x0                                     # 004194bf
    push 0x0                                     # 004194c1
    push 0x542cac                                # 004194c3
    call FUN_0052139c                            # 004194c8
    jmp.d32 L_0041991c                           # 004194cd
L_004194d2:
    # block 0x004194d2: entered by jne at 0x004194bd, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0041951a (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004194d2
    imul ecx, ecx, 0x5e                          # 004194d6
    mov edx, dword ptr [ebp - local_19c]         # 004194d9
    mov eax, dword ptr [edx + field_577]         # 004194df
    mov ecx, dword ptr [eax + ecx + field_51]    # 004194e5
    push ecx                                     # 004194e9
    call FUN_0051dc43                            # 004194ea
    add esp, 0x4                                 # 004194ef
    mov dword ptr [ebp - local_184], eax         # 004194f2
    mov edx, dword ptr [ebp - local_184]         # 004194f8
    mov dword ptr [ebp - local_14], edx          # 004194fe
    cmp dword ptr [ebp - local_14], 0x0          # 00419501
    jne.d8 L_0041951a                            # 00419505
    # block 0x00419507: entered by fall-through of jne at 0x00419505, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0041991a
    push 0x0                                     # 00419507
    push 0x0                                     # 00419509
    push 0x542ce0                                # 0041950b
    call FUN_0052139c                            # 00419510
    jmp.d32 L_0041991a                           # 00419515
L_0041951a:
    # block 0x0041951a: entered by jne at 0x00419505, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x004195d7 (forward)
    push 0x0                                     # 0041951a
    movsx eax, word ptr [ebp - local_10]         # 0041951c
    imul eax, eax, 0x5e                          # 00419520
    mov ecx, dword ptr [ebp - local_19c]         # 00419523
    mov edx, dword ptr [ecx + field_577]         # 00419529
    mov eax, dword ptr [edx + eax + field_23]    # 0041952f
    push eax                                     # 00419533
    mov ecx, dword ptr [ebp - local_19c]         # 00419534
    mov edx, dword ptr [ecx + field_57b]         # 0041953a
    mov eax, dword ptr [edx + field_845]         # 00419540
    push eax                                     # 00419546
    call FUN_0050ce2b                            # 00419547
    add esp, 0xc                                 # 0041954c
    mov ecx, dword ptr [ebp - local_19c]         # 0041954f
    mov edx, dword ptr [ecx + field_57b]         # 00419555
    mov eax, dword ptr [edx + field_845]         # 0041955b
    push eax                                     # 00419561
    push 0x1                                     # 00419562
    movsx ecx, word ptr [ebp - local_10]         # 00419564
    imul ecx, ecx, 0x5e                          # 00419568
    mov edx, dword ptr [ebp - local_19c]         # 0041956b
    mov eax, dword ptr [edx + field_577]         # 00419571
    mov ecx, dword ptr [eax + ecx + field_59]    # 00419577
    push ecx                                     # 0041957b
    mov edx, dword ptr [ebp - local_4]           # 0041957c
    push edx                                     # 0041957f
    call FUN_0050cf61                            # 00419580
    add esp, 0x10                                # 00419585
    cmp eax, 0x1                                 # 00419588
    je.d8 L_004195d7                             # 0041958b
    # block 0x0041958d: entered by fall-through of je at 0x0041958b, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419918
    movsx eax, word ptr [ebp - local_10]         # 0041958d
    imul eax, eax, 0x5e                          # 00419591
    mov ecx, dword ptr [ebp - local_19c]         # 00419594
    mov edx, dword ptr [ecx + field_577]         # 0041959a
    {load} add edx, eax                          # 004195a0
    push edx                                     # 004195a2
    push 0x542d10                                # 004195a3
    mov eax, dword ptr [ebp - local_19c]         # 004195a8
    add eax, 0x31f                               # 004195ae
    push eax                                     # 004195b3
    call FUN_0050ca3e                            # 004195b4
    add esp, 0xc                                 # 004195b9
    push 0x0                                     # 004195bc
    push 0x0                                     # 004195be
    mov ecx, dword ptr [ebp - local_19c]         # 004195c0
    add ecx, 0x31f                               # 004195c6
    push ecx                                     # 004195cc
    call FUN_0052139c                            # 004195cd
    jmp.d32 L_00419918                           # 004195d2
L_004195d7:
    # block 0x004195d7: entered by je at 0x0041958b, 37 instruction(s), calls FUN_0041b6e2, FUN_004c7314, ends with forward jump to 0x00419913
    movsx edx, word ptr [ebp - local_10]         # 004195d7
    imul edx, edx, 0x5e                          # 004195db
    mov eax, dword ptr [ebp - local_19c]         # 004195de
    mov ecx, dword ptr [eax + field_577]         # 004195e4
    mov edx, dword ptr [ecx + edx + field_51]    # 004195ea
    push edx                                     # 004195ee
    movsx eax, word ptr [ebp - local_10]         # 004195ef
    imul eax, eax, 0x5e                          # 004195f3
    mov ecx, dword ptr [ebp - local_19c]         # 004195f6
    mov edx, dword ptr [ecx + field_577]         # 004195fc
    mov eax, dword ptr [edx + eax + field_59]    # 00419602
    push eax                                     # 00419606
    mov ecx, dword ptr [ebp - local_14]          # 00419607
    push ecx                                     # 0041960a
    mov edx, dword ptr [ebp - local_4]           # 0041960b
    push edx                                     # 0041960e
    mov ecx, dword ptr [ebp - local_19c]         # 0041960f
    add ecx, 0x51f                               # 00419615
    call FUN_0041b6e2                            # 0041961b
    movsx eax, word ptr [ebp - local_10]         # 00419620
    imul eax, eax, 0x5e                          # 00419624
    mov ecx, dword ptr [ebp - local_19c]         # 00419627
    mov edx, dword ptr [ecx + field_577]         # 0041962d
    mov eax, dword ptr [edx + eax + field_51]    # 00419633
    push eax                                     # 00419637
    mov ecx, dword ptr [ebp - local_14]          # 00419638
    push ecx                                     # 0041963b
    mov ecx, 0x5cf659                            # 0041963c
    call FUN_004c7314                            # 00419641
    movsx edx, word ptr [ebp - local_10]         # 00419646
    imul edx, edx, 0x5e                          # 0041964a
    mov eax, dword ptr [ebp - local_19c]         # 0041964d
    mov ecx, dword ptr [eax + field_577]         # 00419653
    mov eax, dword ptr [ebp + arg_10]            # 00419659
    mov ecx, dword ptr [ecx + edx + field_51]    # 0041965c
    mov dword ptr [eax], ecx                     # 00419660
    jmp.d32 L_00419913                           # 00419662
L_00419667:
    # block 0x00419667: entered by je at 0x0041947f, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004196af (forward)
    movsx edx, word ptr [ebp - local_10]         # 00419667
    imul edx, edx, 0x5e                          # 0041966b
    mov eax, dword ptr [ebp - local_19c]         # 0041966e
    mov ecx, dword ptr [eax + field_577]         # 00419674
    mov edx, dword ptr [ecx + edx + field_59]    # 0041967a
    push edx                                     # 0041967e
    call FUN_0051dc43                            # 0041967f
    add esp, 0x4                                 # 00419684
    mov dword ptr [ebp - local_188], eax         # 00419687
    mov eax, dword ptr [ebp - local_188]         # 0041968d
    mov dword ptr [ebp - local_4], eax           # 00419693
    cmp dword ptr [ebp - local_4], 0x0           # 00419696
    jne.d8 L_004196af                            # 0041969a
    # block 0x0041969c: entered by fall-through of jne at 0x0041969a, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00419911
    push 0x0                                     # 0041969c
    push 0x0                                     # 0041969e
    push 0x542d34                                # 004196a0
    call FUN_0052139c                            # 004196a5
    jmp.d32 L_00419911                           # 004196aa
L_004196af:
    # block 0x004196af: entered by jne at 0x0041969a, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004196f7 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004196af
    imul ecx, ecx, 0x5e                          # 004196b3
    mov edx, dword ptr [ebp - local_19c]         # 004196b6
    mov eax, dword ptr [edx + field_577]         # 004196bc
    mov ecx, dword ptr [eax + ecx + field_51]    # 004196c2
    push ecx                                     # 004196c6
    call FUN_0051dc43                            # 004196c7
    add esp, 0x4                                 # 004196cc
    mov dword ptr [ebp - local_18c], eax         # 004196cf
    mov edx, dword ptr [ebp - local_18c]         # 004196d5
    mov dword ptr [ebp - local_14], edx          # 004196db
    cmp dword ptr [ebp - local_14], 0x0          # 004196de
    jne.d8 L_004196f7                            # 004196e2
    # block 0x004196e4: entered by fall-through of jne at 0x004196e2, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x0041990f
    push 0x0                                     # 004196e4
    push 0x0                                     # 004196e6
    push 0x542d68                                # 004196e8
    call FUN_0052139c                            # 004196ed
    jmp.d32 L_0041990f                           # 004196f2
L_004196f7:
    # block 0x004196f7: entered by jne at 0x004196e2, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x004197b4 (forward)
    push 0x0                                     # 004196f7
    movsx eax, word ptr [ebp - local_10]         # 004196f9
    imul eax, eax, 0x5e                          # 004196fd
    mov ecx, dword ptr [ebp - local_19c]         # 00419700
    mov edx, dword ptr [ecx + field_577]         # 00419706
    mov eax, dword ptr [edx + eax + field_23]    # 0041970c
    push eax                                     # 00419710
    mov ecx, dword ptr [ebp - local_19c]         # 00419711
    mov edx, dword ptr [ecx + field_57b]         # 00419717
    mov eax, dword ptr [edx + field_845]         # 0041971d
    push eax                                     # 00419723
    call FUN_0050ce2b                            # 00419724
    add esp, 0xc                                 # 00419729
    mov ecx, dword ptr [ebp - local_19c]         # 0041972c
    mov edx, dword ptr [ecx + field_57b]         # 00419732
    mov eax, dword ptr [edx + field_845]         # 00419738
    push eax                                     # 0041973e
    push 0x1                                     # 0041973f
    movsx ecx, word ptr [ebp - local_10]         # 00419741
    imul ecx, ecx, 0x5e                          # 00419745
    mov edx, dword ptr [ebp - local_19c]         # 00419748
    mov eax, dword ptr [edx + field_577]         # 0041974e
    mov ecx, dword ptr [eax + ecx + field_59]    # 00419754
    push ecx                                     # 00419758
    mov edx, dword ptr [ebp - local_4]           # 00419759
    push edx                                     # 0041975c
    call FUN_0050cf61                            # 0041975d
    add esp, 0x10                                # 00419762
    cmp eax, 0x1                                 # 00419765
    je.d8 L_004197b4                             # 00419768
    # block 0x0041976a: entered by fall-through of je at 0x00419768, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x0041990d
    movsx eax, word ptr [ebp - local_10]         # 0041976a
    imul eax, eax, 0x5e                          # 0041976e
    mov ecx, dword ptr [ebp - local_19c]         # 00419771
    mov edx, dword ptr [ecx + field_577]         # 00419777
    {load} add edx, eax                          # 0041977d
    push edx                                     # 0041977f
    push 0x542d98                                # 00419780
    mov eax, dword ptr [ebp - local_19c]         # 00419785
    add eax, 0x31f                               # 0041978b
    push eax                                     # 00419790
    call FUN_0050ca3e                            # 00419791
    add esp, 0xc                                 # 00419796
    push 0x0                                     # 00419799
    push 0x0                                     # 0041979b
    mov ecx, dword ptr [ebp - local_19c]         # 0041979d
    add ecx, 0x31f                               # 004197a3
    push ecx                                     # 004197a9
    call FUN_0052139c                            # 004197aa
    jmp.d32 L_0041990d                           # 004197af
L_004197b4:
    # block 0x004197b4: entered by je at 0x00419768, 27 instruction(s), calls FUN_0041b6e2, ends with forward jump to 0x00419908
    movsx edx, word ptr [ebp - local_10]         # 004197b4
    imul edx, edx, 0x5e                          # 004197b8
    mov eax, dword ptr [ebp - local_19c]         # 004197bb
    mov ecx, dword ptr [eax + field_577]         # 004197c1
    mov edx, dword ptr [ecx + edx + field_51]    # 004197c7
    push edx                                     # 004197cb
    movsx eax, word ptr [ebp - local_10]         # 004197cc
    imul eax, eax, 0x5e                          # 004197d0
    mov ecx, dword ptr [ebp - local_19c]         # 004197d3
    mov edx, dword ptr [ecx + field_577]         # 004197d9
    mov eax, dword ptr [edx + eax + field_59]    # 004197df
    push eax                                     # 004197e3
    mov ecx, dword ptr [ebp - local_14]          # 004197e4
    push ecx                                     # 004197e7
    mov edx, dword ptr [ebp - local_4]           # 004197e8
    push edx                                     # 004197eb
    mov ecx, dword ptr [ebp - local_19c]         # 004197ec
    add ecx, 0x51f                               # 004197f2
    call FUN_0041b6e2                            # 004197f8
    movsx eax, word ptr [ebp - local_10]         # 004197fd
    imul eax, eax, 0x5e                          # 00419801
    mov ecx, dword ptr [ebp - local_19c]         # 00419804
    mov edx, dword ptr [ecx + field_577]         # 0041980a
    mov ecx, dword ptr [ebp + arg_10]            # 00419810
    mov edx, dword ptr [edx + eax + field_51]    # 00419813
    mov dword ptr [ecx], edx                     # 00419817
    jmp.d32 L_00419908                           # 00419819
L_0041981e:
    # block 0x0041981e: entered by jmp at 0x00419485, 26 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00419906
    movsx eax, word ptr [ebp - local_10]         # 0041981e
    imul eax, eax, 0x5e                          # 00419822
    mov ecx, dword ptr [ebp - local_19c]         # 00419825
    mov edx, dword ptr [ecx + field_577]         # 0041982b
    {load} xor ecx, ecx                          # 00419831
    mov cl, byte ptr [edx + eax + field_5d]      # 00419833
    push ecx                                     # 00419837
    movsx edx, word ptr [ebp - local_10]         # 00419838
    imul edx, edx, 0x5e                          # 0041983c
    mov eax, dword ptr [ebp - local_19c]         # 0041983f
    mov ecx, dword ptr [eax + field_577]         # 00419845
    {load} add ecx, edx                          # 0041984b
    push ecx                                     # 0041984d
    push 0x542dbc                                # 0041984e
    mov edx, dword ptr [ebp - local_19c]         # 00419853
    add edx, 0x31f                               # 00419859
    push edx                                     # 0041985f
    call FUN_0050ca3e                            # 00419860
    add esp, 0x10                                # 00419865
    push 0x0                                     # 00419868
    push 0x0                                     # 0041986a
    mov eax, dword ptr [ebp - local_19c]         # 0041986c
    add eax, 0x31f                               # 00419872
    push eax                                     # 00419877
    call FUN_0052139c                            # 00419878
    jmp.d32 L_00419906                           # 0041987d
L_00419882:
    # block 0x00419882: entered by jmp at 0x00419908; jmp at 0x00419913; jmp at 0x00419924; jmp at 0x0041992f, 2 instruction(s), ends with je to 0x004198a7 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00419882
    je.d8 L_004198a7                             # 00419886
    # block 0x00419888: entered by fall-through of je at 0x00419886, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004198a7
    mov ecx, dword ptr [ebp - local_4]           # 00419888
    mov dword ptr [ebp - local_190], ecx         # 0041988b
    mov edx, dword ptr [ebp - local_190]         # 00419891
    push edx                                     # 00419897
    call FUN_0051dc6c                            # 00419898
    add esp, 0x4                                 # 0041989d
    mov dword ptr [ebp - local_4], 0x0           # 004198a0
L_004198a7:
    # block 0x004198a7: entered by je at 0x00419886, 2 instruction(s), ends with forward jump to 0x0041994d
    mov eax, dword ptr [ebp - local_14]          # 004198a7
    jmp.d32 L_0041994d                           # 004198aa
L_004198af:
    # block 0x004198af: entered by jmp at 0x00419906; jmp at 0x0041990d; jmp at 0x0041990f; jmp at 0x00419911; more, 2 instruction(s), ends with je to 0x004198d4 (forward)
    cmp dword ptr [ebp - local_14], 0x0          # 004198af
    je.d8 L_004198d4                             # 004198b3
    # block 0x004198b5: entered by fall-through of je at 0x004198b3, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004198d4
    mov eax, dword ptr [ebp - local_14]          # 004198b5
    mov dword ptr [ebp - local_194], eax         # 004198b8
    mov ecx, dword ptr [ebp - local_194]         # 004198be
    push ecx                                     # 004198c4
    call FUN_0051dc6c                            # 004198c5
    add esp, 0x4                                 # 004198ca
    mov dword ptr [ebp - local_14], 0x0          # 004198cd
L_004198d4:
    # block 0x004198d4: entered by je at 0x004198b3, 2 instruction(s), ends with je to 0x004198f9 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004198d4
    je.d8 L_004198f9                             # 004198d8
    # block 0x004198da: entered by fall-through of je at 0x004198d8, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004198f9
    mov edx, dword ptr [ebp - local_4]           # 004198da
    mov dword ptr [ebp - local_198], edx         # 004198dd
    mov eax, dword ptr [ebp - local_198]         # 004198e3
    push eax                                     # 004198e9
    call FUN_0051dc6c                            # 004198ea
    add esp, 0x4                                 # 004198ef
    mov dword ptr [ebp - local_4], 0x0           # 004198f2
L_004198f9:
    # block 0x004198f9: entered by je at 0x004198d8, 4 instruction(s), ends with forward jump to 0x0041994d
    mov ecx, dword ptr [ebp + arg_10]            # 004198f9
    mov dword ptr [ecx], 0x0                     # 004198fc
    {load} xor eax, eax                          # 00419902
    jmp.d8 L_0041994d                            # 00419904
L_00419906:
    # block 0x00419906: entered by jmp at 0x0041987d, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 00419906
L_00419908:
    # block 0x00419908: entered by jmp at 0x00419819, 1 instruction(s), ends with backward jump to 0x00419882
    jmp.d32 L_00419882                           # 00419908
L_0041990d:
    # block 0x0041990d: entered by jmp at 0x004197af, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041990d
L_0041990f:
    # block 0x0041990f: entered by jmp at 0x004196f2, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041990f
L_00419911:
    # block 0x00419911: entered by jmp at 0x004196aa, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 00419911
L_00419913:
    # block 0x00419913: entered by jmp at 0x00419662, 1 instruction(s), ends with backward jump to 0x00419882
    jmp.d32 L_00419882                           # 00419913
L_00419918:
    # block 0x00419918: entered by jmp at 0x004195d2, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 00419918
L_0041991a:
    # block 0x0041991a: entered by jmp at 0x00419515, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041991a
L_0041991c:
    # block 0x0041991c: entered by jmp at 0x004194cd, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041991c
L_0041991e:
    # block 0x0041991e: entered by jmp at 0x00419444, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041991e
L_00419920:
    # block 0x00419920: entered by jmp at 0x00419338, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 00419920
L_00419922:
    # block 0x00419922: entered by jmp at 0x00419248, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 00419922
L_00419924:
    # block 0x00419924: entered by jmp at 0x004191e2, 1 instruction(s), ends with backward jump to 0x00419882
    jmp.d32 L_00419882                           # 00419924
L_00419929:
    # block 0x00419929: entered by jmp at 0x0041919f, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 00419929
L_0041992b:
    # block 0x0041992b: entered by jmp at 0x00419146, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041992b
L_0041992d:
    # block 0x0041992d: entered by jmp at 0x0041910f, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d8 L_004198af                            # 0041992d
L_0041992f:
    # block 0x0041992f: entered by jmp at 0x004190d8, 1 instruction(s), ends with backward jump to 0x00419882
    jmp.d32 L_00419882                           # 0041992f
L_00419934:
    # block 0x00419934: entered by jmp at 0x00419080, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d32 L_004198af                           # 00419934
L_00419939:
    # block 0x00419939: entered by jmp at 0x00419027, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d32 L_004198af                           # 00419939
L_0041993e:
    # block 0x0041993e: entered by jmp at 0x00418ff0, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d32 L_004198af                           # 0041993e
L_00419943:
    # block 0x00419943: entered by jmp at 0x00418f92, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d32 L_004198af                           # 00419943
L_00419948:
    # block 0x00419948: entered by jmp at 0x00418f48, 1 instruction(s), ends with backward jump to 0x004198af
    jmp.d32 L_004198af                           # 00419948
L_0041994d:
    # block 0x0041994d: entered by jmp at 0x004198aa; jmp at 0x00419904, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0041994d
    pop esi                                      # 0041994e
    {load} mov esp, ebp                          # 0041994f
    pop ebp                                      # 00419951
    ret 0xc                                      # 00419952

