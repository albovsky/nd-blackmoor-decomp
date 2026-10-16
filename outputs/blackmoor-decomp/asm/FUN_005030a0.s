# FUN_005030a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005030a0
# extent:       0x005030a0-0x005031c7 (295 code bytes)
# span:         0x005030a0-0x005031d0 (code 295, tables 0, padding 9)
# sha256:       c322d3cd908b9be9e2604280cfc501cc989b9dfde494267977ffdb2f2606ba14
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005030a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_minus_1; [ecx + n] field_14, field_minus_1; [edi + n] field_8, field_18, field_1c, field_20, field_24, field_28; [edx + n] field_1c, field_minus_1; [esp + n] stk_10, stk_18, stk_1c, stk_20
# callees:      calls FUN_0050bd80, FUN_0050be30, FUN_00502da0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 116 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00502da0, .text + (0x00502da0 - 0x401000)
.set FUN_0050bd80, .text + (0x0050bd80 - 0x401000)
.set FUN_0050be30, .text + (0x0050be30 - 0x401000)

.org 0x005030a0 - 0x401000
.globl FUN_005030a0
FUN_005030a0:
    # block 0x005030a0: entry, 16 instruction(s), calls FUN_0050bd80, ends with jl to 0x00503114 (forward)
    push ecx                                     # 005030a0
    push ebx                                     # 005030a1
    push ebp                                     # 005030a2
    push esi                                     # 005030a3
    mov esi, dword ptr [esp + stk_18]            # 005030a4
    push edi                                     # 005030a8
    mov edi, dword ptr [esp + stk_18]            # 005030a9
    mov eax, dword ptr [edi + field_24]          # 005030ad
    mov ebp, dword ptr [edi + field_28]          # 005030b0
    push eax                                     # 005030b3
    push esi                                     # 005030b4
    mov dword ptr [esp + stk_18], ebp            # 005030b5
    call FUN_0050bd80                            # 005030b9
    add esp, 0x8                                 # 005030be
    test eax, eax                                # 005030c1
    jl.d8 L_00503114                             # 005030c3
    # block 0x005030c5: entered by fall-through of jl at 0x005030c3, 4 instruction(s), ends with je to 0x005030eb (forward)
    mov ecx, dword ptr [edi + field_20]          # 005030c5
    mov ebx, dword ptr [ecx + 4*eax]             # 005030c8
    test ebx, 0x80000000                         # 005030cb
    je.d8 L_005030eb                             # 005030d1
    # block 0x005030d3: entered by fall-through of je at 0x005030d1, 7 instruction(s), ends with forward jump to 0x00503119
    mov edi, dword ptr [edi + field_8]           # 005030d3
    {load} mov esi, ebx                          # 005030d6
    sar esi, 0xf                                 # 005030d8
    and ebx, 0x7fff                              # 005030db
    and esi, 0x7fff                              # 005030e1
    {load} sub edi, ebx                          # 005030e7
    jmp.d8 L_00503119                            # 005030e9
L_005030eb:
    # block 0x005030eb: entered by je at 0x005030d1, 7 instruction(s), calls FUN_0050be30, falls into the block at 0x00503100
    mov edx, dword ptr [edi + field_1c]          # 005030eb
    movsx eax, byte ptr [edx + ebx - field_minus_1] # 005030ee
    push eax                                     # 005030f3
    push esi                                     # 005030f4
    call FUN_0050be30                            # 005030f5
    add esp, 0x8                                 # 005030fa
    lea esi, [ebx - field_minus_1]               # 005030fd
L_00503100:
    # block 0x00503100: entered by jmp at 0x005031ad, 2 instruction(s), ends with jl to 0x005031bf (forward)
    test esi, esi                                # 00503100
    jl.d32 L_005031bf                            # 00503102
    # block 0x00503108: entered by fall-through of jl at 0x00503102, 8 instruction(s), ends with ret
    mov ecx, dword ptr [edi + field_18]          # 00503108
    pop edi                                      # 0050310b
    mov eax, dword ptr [ecx + 4*esi]             # 0050310c
    pop esi                                      # 0050310f
    pop ebp                                      # 00503110
    pop ebx                                      # 00503111
    pop ecx                                      # 00503112
    ret                                          # 00503113
L_00503114:
    # block 0x00503114: entered by jl at 0x005030c3, 2 instruction(s), falls into the block at 0x00503119
    mov edi, dword ptr [edi + field_8]           # 00503114
    {load} xor esi, esi                          # 00503117
L_00503119:
    # block 0x00503119: entered by jmp at 0x005030e9, 7 instruction(s), calls FUN_0050bd80, ends with jge to 0x0050314d (forward)
    mov ebx, dword ptr [esp + stk_1c]            # 00503119
    push ebp                                     # 0050311d
    push ebx                                     # 0050311e
    call FUN_0050bd80                            # 0050311f
    add esp, 0x8                                 # 00503124
    test eax, eax                                # 00503127
    jge.d8 L_0050314d                            # 00503129
L_0050312b:
    # block 0x0050312b: entered by jl at 0x0050313d; fall-through of jge at 0x00503129, 2 instruction(s), ends with jle to 0x00503145 (forward)
    cmp ebp, 0x1                                 # 0050312b
    jle.d8 L_00503145                            # 0050312e
    # block 0x00503130: entered by fall-through of jle at 0x0050312e, 7 instruction(s), calls FUN_0050bd80, ends with jl to 0x0050312b (backward)
    dec ebp                                      # 00503130
    push ebp                                     # 00503131
    push ebx                                     # 00503132
    call FUN_0050bd80                            # 00503133
    add esp, 0x8                                 # 00503138
    test eax, eax                                # 0050313b
    jl.d8 L_0050312b                             # 0050313d
    # block 0x0050313f: entered by fall-through of jl at 0x0050313d, 2 instruction(s), ends with forward jump to 0x0050314d
    mov dword ptr [esp + stk_10], ebp            # 0050313f
    jmp.d8 L_0050314d                            # 00503143
L_00503145:
    # block 0x00503145: entered by jle at 0x0050312e, 3 instruction(s), ends with jl to 0x005031bc (forward)
    test eax, eax                                # 00503145
    mov dword ptr [esp + stk_10], ebp            # 00503147
    jl.d8 L_005031bc                             # 0050314b
L_0050314d:
    # block 0x0050314d: entered by jge at 0x00503129; jmp at 0x00503143; fall-through of jl at 0x0050314b, 7 instruction(s), calls FUN_00502da0, ends with jle to 0x00503190 (forward)
    push eax                                     # 0050314d
    call FUN_00502da0                            # 0050314e
    {load} mov edx, edi                          # 00503153
    add esp, 0x4                                 # 00503155
    {load} sub edx, esi                          # 00503158
    cmp edx, 0x1                                 # 0050315a
    jle.d8 L_00503190                            # 0050315d
    # block 0x0050315f: entered by fall-through of jle at 0x0050315d, 2 instruction(s), falls into the block at 0x00503166
    mov ecx, dword ptr [esp + stk_18]            # 0050315f
    mov ebx, dword ptr [ecx + field_14]          # 00503163
L_00503166:
    # block 0x00503166: entered by jg at 0x00503186, 15 instruction(s), ends with jg to 0x00503166 (backward)
    sar edx                                      # 00503166
    lea ecx, [edx + esi]                         # 00503168
    cmp eax, dword ptr [ebx + 4*ecx]             # 0050316b
    {load} sbb ecx, ecx                          # 0050316e
    neg ecx                                      # 00503170
    lea ebp, [ecx - field_minus_1]               # 00503172
    neg ecx                                      # 00503175
    {load} and ecx, edx                          # 00503177
    {load} and ebp, edx                          # 00503179
    {load} sub edi, ecx                          # 0050317b
    {load} add esi, ebp                          # 0050317d
    {load} mov edx, edi                          # 0050317f
    {load} sub edx, esi                          # 00503181
    cmp edx, 0x1                                 # 00503183
    jg.d8 L_00503166                             # 00503186
    # block 0x00503188: entered by fall-through of jg at 0x00503186, 2 instruction(s), falls into the block at 0x00503190
    mov ebp, dword ptr [esp + stk_10]            # 00503188
    mov ebx, dword ptr [esp + stk_1c]            # 0050318c
L_00503190:
    # block 0x00503190: entered by jle at 0x0050315d, 5 instruction(s), ends with jg to 0x005031b2 (forward)
    mov edx, dword ptr [esp + stk_18]            # 00503190
    mov eax, dword ptr [edx + field_1c]          # 00503194
    movsx eax, byte ptr [eax + esi]              # 00503197
    {load} cmp eax, ebp                          # 0050319b
    jg.d8 L_005031b2                             # 0050319d
    # block 0x0050319f: entered by fall-through of jg at 0x0050319d, 6 instruction(s), calls FUN_0050be30, ends with backward jump to 0x00503100
    push eax                                     # 0050319f
    push ebx                                     # 005031a0
    call FUN_0050be30                            # 005031a1
    mov edi, dword ptr [esp + stk_20]            # 005031a6
    add esp, 0x8                                 # 005031aa
    jmp.d32 L_00503100                           # 005031ad
L_005031b2:
    # block 0x005031b2: entered by jg at 0x0050319d, 4 instruction(s), calls FUN_0050be30, falls into the block at 0x005031bc
    push ebp                                     # 005031b2
    push ebx                                     # 005031b3
    call FUN_0050be30                            # 005031b4
    add esp, 0x8                                 # 005031b9
L_005031bc:
    # block 0x005031bc: entered by jl at 0x0050314b, 1 instruction(s), falls into the block at 0x005031bf
    or esi, -0x1                                 # 005031bc
L_005031bf:
    # block 0x005031bf: entered by jl at 0x00503102, 7 instruction(s), ends with ret
    {load} mov eax, esi                          # 005031bf
    pop edi                                      # 005031c1
    pop esi                                      # 005031c2
    pop ebp                                      # 005031c3
    pop ebx                                      # 005031c4
    pop ecx                                      # 005031c5
    ret                                          # 005031c6

# --- data items (not part of the function) -------------------------
.org 0x005031c7 - 0x401000
PAD_005031c7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

