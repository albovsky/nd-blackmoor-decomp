# FUN_00505020
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00505020
# extent:       0x00505020-0x005051ab (395 code bytes)
# span:         0x00505020-0x005051b0 (code 395, tables 0, padding 5)
# sha256:       47b65a3e9321f94579bbc840a33f77198d4f8d47272a64dcdf96d581baa022c5
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00505020
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_minus_1; [ebx + n] field_4; [ecx + n] field_4, field_minus_4, field_minus_8; [edi + n] field_minus_1; [edx + n] field_8; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_28, stk_2c, stk_30
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 137 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x00505020 - 0x401000
.globl FUN_00505020
FUN_00505020:
    # block 0x00505020: entry, 10 instruction(s), falls into the block at 0x00505037
    sub esp, 0x14                                # 00505020
    mov ecx, dword ptr [esp + stk_18]            # 00505023
    push ebx                                     # 00505027
    push ebp                                     # 00505028
    push esi                                     # 00505029
    push edi                                     # 0050502a
    mov ebx, 0x5669f8                            # 0050502b
    {load} xor esi, esi                          # 00505030
    {load} xor edi, edi                          # 00505032
    sub ebx, 0x4                                 # 00505034
L_00505037:
    # block 0x00505037: entered by jne at 0x0050505b; jmp at 0x005050b3, 4 instruction(s), ends with jge to 0x0050504a (forward)
    add ebx, 0x4                                 # 00505037
    cmp ebx, 0x566a08                            # 0050503a
    mov dword ptr [esp + stk_14], ebx            # 00505040
    jge.d8 L_0050504a                            # 00505044
    # block 0x00505046: entered by fall-through of jge at 0x00505044, 2 instruction(s), ends with forward jump to 0x0050504d
    mov esi, dword ptr [ebx]                     # 00505046
    jmp.d8 L_0050504d                            # 00505048
L_0050504a:
    # block 0x0050504a: entered by jge at 0x00505044, 1 instruction(s), falls into the block at 0x0050504d
    add esi, 0x2                                 # 0050504a
L_0050504d:
    # block 0x0050504d: entered by jmp at 0x00505048, 8 instruction(s), ends with jne to 0x00505037 (backward)
    {load} mov eax, ecx                          # 0050504d
    {load} mov ebp, ecx                          # 0050504f
    cdq                                          # 00505051
    idiv esi                                     # 00505052
    {load} mov edx, eax                          # 00505054
    imul edx, esi                                # 00505056
    {load} sub ebp, edx                          # 00505059
    jne.d8 L_00505037                            # 0050505b
    # block 0x0050505d: entered by fall-through of jne at 0x0050505b, 2 instruction(s), falls into the block at 0x00505064
    mov ecx, dword ptr [esp + stk_30]            # 0050505d
    lea ebx, [ecx + 4*edi]                       # 00505061
L_00505064:
    # block 0x00505064: entered by je at 0x005050ad, 7 instruction(s), ends with jne to 0x0050509c (forward)
    add ebx, 0x4                                 # 00505064
    inc edi                                      # 00505067
    {load} mov ecx, eax                          # 00505068
    cmp esi, 0x2                                 # 0050506a
    mov dword ptr [ebx + field_4], esi           # 0050506d
    mov dword ptr [esp + stk_18], ecx            # 00505070
    jne.d8 L_0050509c                            # 00505074
    # block 0x00505076: entered by fall-through of jne at 0x00505074, 2 instruction(s), ends with je to 0x0050509c (forward)
    cmp edi, 0x1                                 # 00505076
    je.d8 L_0050509c                             # 00505079
    # block 0x0050507b: entered by fall-through of je at 0x00505079, 1 instruction(s), ends with jle to 0x00505091 (forward)
    jle.d8 L_00505091                            # 0050507b
    # block 0x0050507d: entered by fall-through of jle at 0x0050507b, 2 instruction(s), falls into the block at 0x00505082
    {load} mov ecx, ebx                          # 0050507d
    lea edx, [edi - field_minus_1]               # 0050507f
L_00505082:
    # block 0x00505082: entered by jne at 0x0050508b, 5 instruction(s), ends with jne to 0x00505082 (backward)
    mov ebp, dword ptr [ecx]                     # 00505082
    mov dword ptr [ecx + field_4], ebp           # 00505084
    sub ecx, 0x4                                 # 00505087
    dec edx                                      # 0050508a
    jne.d8 L_00505082                            # 0050508b
    # block 0x0050508d: entered by fall-through of jne at 0x0050508b, 1 instruction(s), falls into the block at 0x00505091
    mov ecx, dword ptr [esp + stk_18]            # 0050508d
L_00505091:
    # block 0x00505091: entered by jle at 0x0050507b, 2 instruction(s), falls into the block at 0x0050509c
    mov edx, dword ptr [esp + stk_30]            # 00505091
    mov dword ptr [edx + field_8], 0x2           # 00505095
L_0050509c:
    # block 0x0050509c: entered by jne at 0x00505074; je at 0x00505079, 2 instruction(s), ends with je to 0x005050b5 (forward)
    cmp eax, 0x1                                 # 0050509c
    je.d8 L_005050b5                             # 0050509f
    # block 0x005050a1: entered by fall-through of je at 0x0050509f, 7 instruction(s), ends with je to 0x00505064 (backward)
    cdq                                          # 005050a1
    idiv esi                                     # 005050a2
    {load} mov ebp, ecx                          # 005050a4
    {load} mov edx, eax                          # 005050a6
    imul edx, esi                                # 005050a8
    {load} sub ebp, edx                          # 005050ab
    je.d8 L_00505064                             # 005050ad
    # block 0x005050af: entered by fall-through of je at 0x005050ad, 2 instruction(s), ends with backward jump to 0x00505037
    mov ebx, dword ptr [esp + stk_14]            # 005050af
    jmp.d8 L_00505037                            # 005050b3
L_005050b5:
    # block 0x005050b5: entered by je at 0x0050509f, 12 instruction(s), ends with je to 0x005051a3 (forward)
    mov eax, dword ptr [esp + stk_30]            # 005050b5
    mov ecx, dword ptr [esp + stk_28]            # 005050b9
    fild dword ptr [esp + stk_28]                # 005050bd
    mov dword ptr [eax], ecx                     # 005050c1
    mov dword ptr [eax + field_4], edi           # 005050c3
    dec edi                                      # 005050c6
    mov dword ptr [esp + stk_30], 0x0            # 005050c7
    fdivr dword ptr [0x566a08]                   # 005050cf
    test edi, edi                                # 005050d5
    mov ebx, 0x1                                 # 005050d7
    fstp dword ptr [esp + stk_20]                # 005050dc
    je.d32 L_005051a3                            # 005050e0
    # block 0x005050e6: entered by fall-through of je at 0x005050e0, 1 instruction(s), ends with jle to 0x005051a3 (forward)
    jle.d32 L_005051a3                           # 005050e6
    # block 0x005050ec: entered by fall-through of jle at 0x005050e6, 3 instruction(s), falls into the block at 0x005050f7
    add eax, 0x8                                 # 005050ec
    mov dword ptr [esp + stk_18], edi            # 005050ef
    mov dword ptr [esp + stk_10], eax            # 005050f3
L_005050f7:
    # block 0x005050f7: entered by jne at 0x0050519d, 11 instruction(s), ends with jle to 0x00505187 (forward)
    mov edx, dword ptr [esp + stk_10]            # 005050f7
    mov eax, dword ptr [esp + stk_28]            # 005050fb
    {load} xor ebp, ebp                          # 005050ff
    mov ecx, dword ptr [edx]                     # 00505101
    {load} mov esi, ecx                          # 00505103
    imul esi, ebx                                # 00505105
    cdq                                          # 00505108
    idiv esi                                     # 00505109
    dec ecx                                      # 0050510b
    test ecx, ecx                                # 0050510c
    jle.d8 L_00505187                            # 0050510e
    # block 0x00505110: entered by fall-through of jle at 0x0050510e, 8 instruction(s), falls into the block at 0x0050512c
    mov edx, dword ptr [esp + stk_2c]            # 00505110
    mov edi, dword ptr [esp + stk_30]            # 00505114
    mov dword ptr [esp + stk_14], ecx            # 00505118
    imul ecx, eax                                # 0050511c
    lea edi, [edx + 4*edi]                       # 0050511f
    mov edx, dword ptr [esp + stk_30]            # 00505122
    {load} add edx, ecx                          # 00505126
    mov dword ptr [esp + stk_30], edx            # 00505128
L_0050512c:
    # block 0x0050512c: entered by jne at 0x00505185, 8 instruction(s), ends with jle to 0x00505171 (forward)
    {load} add ebp, ebx                          # 0050512c
    cmp eax, 0x2                                 # 0050512e
    mov dword ptr [esp + stk_1c], ebp            # 00505131
    fild dword ptr [esp + stk_1c]                # 00505135
    fmul dword ptr [esp + stk_20]                # 00505139
    fstp dword ptr [esp + stk_1c]                # 0050513d
    fld dword ptr [0x52db78]                     # 00505141
    jle.d8 L_00505171                            # 00505147
    # block 0x00505149: entered by fall-through of jle at 0x00505147, 3 instruction(s), falls into the block at 0x00505150
    lea edx, [eax - field_minus_1]               # 00505149
    {load} mov ecx, edi                          # 0050514c
    shr edx                                      # 0050514e
L_00505150:
    # block 0x00505150: entered by jne at 0x0050516f, 12 instruction(s), ends with jne to 0x00505150 (backward)
    fadd dword ptr [0x52cbf4]                    # 00505150
    add ecx, 0x4                                 # 00505156
    add ecx, 0x4                                 # 00505159
    dec edx                                      # 0050515c
    fld st(0)                                    # 0050515d
    fmul dword ptr [esp + stk_1c]                # 0050515f
    fld st(0)                                    # 00505163
    fcos                                         # 00505165
    fstp dword ptr [ecx - field_minus_8]         # 00505167
    fsin                                         # 0050516a
    fstp dword ptr [ecx - field_minus_4]         # 0050516c
    jne.d8 L_00505150                            # 0050516f
L_00505171:
    # block 0x00505171: entered by jle at 0x00505147; fall-through of jne at 0x0050516f, 7 instruction(s), ends with jne to 0x0050512c (backward)
    lea ecx, [4*eax]                             # 00505171
    {load} add edi, ecx                          # 00505178
    mov ecx, dword ptr [esp + stk_14]            # 0050517a
    dec ecx                                      # 0050517e
    fstp st(0)                                   # 0050517f
    mov dword ptr [esp + stk_14], ecx            # 00505181
    jne.d8 L_0050512c                            # 00505185
L_00505187:
    # block 0x00505187: entered by jle at 0x0050510e; fall-through of jne at 0x00505185, 8 instruction(s), ends with jne to 0x005050f7 (backward)
    mov ecx, dword ptr [esp + stk_10]            # 00505187
    mov eax, dword ptr [esp + stk_18]            # 0050518b
    add ecx, 0x4                                 # 0050518f
    dec eax                                      # 00505192
    {load} mov ebx, esi                          # 00505193
    mov dword ptr [esp + stk_10], ecx            # 00505195
    mov dword ptr [esp + stk_18], eax            # 00505199
    jne.d32 L_005050f7                           # 0050519d
L_005051a3:
    # block 0x005051a3: entered by je at 0x005050e0; jle at 0x005050e6; fall-through of jne at 0x0050519d, 6 instruction(s), ends with ret
    pop edi                                      # 005051a3
    pop esi                                      # 005051a4
    pop ebp                                      # 005051a5
    pop ebx                                      # 005051a6
    add esp, 0x14                                # 005051a7
    ret                                          # 005051aa

# --- data items (not part of the function) -------------------------
.org 0x005051ab - 0x401000
PAD_005051ab:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

