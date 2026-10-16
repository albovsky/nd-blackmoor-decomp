# FUN_005025c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005025c0
# extent:       0x005025c0-0x00502626 (102 code bytes)
# span:         0x005025c0-0x00502630 (code 102, tables 0, padding 10)
# sha256:       4f8bf4530bad523228c4bec91acb152a379ca521e01b42d2eb35329af4d53381
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005025c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1; [edi + n] field_4; [esp + n] stk_14
# callees:      calls FUN_0050f440, FUN_0050e19e, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050f440, .text + (0x0050f440 - 0x401000)

.org 0x005025c0 - 0x401000
.globl FUN_005025c0
FUN_005025c0:
    # block 0x005025c0: entry, 15 instruction(s), calls FUN_0050f440, FUN_0050e19e, FUN_0050ce04, falls into the block at 0x005025ed
    push ebx                                     # 005025c0
    push ebp                                     # 005025c1
    push esi                                     # 005025c2
    push edi                                     # 005025c3
    mov edi, dword ptr [esp + stk_14]            # 005025c4
    fild dword ptr [edi + field_4]               # 005025c8
    fild dword ptr [edi]                         # 005025cb
    fdivr dword ptr [0x52cbf4]                   # 005025cd
    call FUN_0050f440                            # 005025d3
    sub esp, 0x8                                 # 005025d8
    fstp qword ptr [esp]                         # 005025db
    call FUN_0050e19e                            # 005025de
    add esp, 0x8                                 # 005025e3
    call FUN_0050ce04                            # 005025e6
    mov ebx, dword ptr [edi]                     # 005025eb
L_005025ed:
    # block 0x005025ed: entered by jmp at 0x0050261c; jmp at 0x0050261f, 4 instruction(s), ends with jle to 0x0050260c (forward)
    mov ecx, 0x1                                 # 005025ed
    test ebx, ebx                                # 005025f2
    {load} mov edx, ecx                          # 005025f4
    jle.d8 L_0050260c                            # 005025f6
    # block 0x005025f8: entered by fall-through of jle at 0x005025f6, 2 instruction(s), falls into the block at 0x005025fd
    lea edi, [eax + field_1]                     # 005025f8
    {load} mov esi, ebx                          # 005025fb
L_005025fd:
    # block 0x005025fd: entered by jne at 0x00502606, 5 instruction(s), ends with jne to 0x005025fd (backward)
    {load} mov ebp, edi                          # 005025fd
    imul ecx, eax                                # 005025ff
    imul edx, ebp                                # 00502602
    dec esi                                      # 00502605
    jne.d8 L_005025fd                            # 00502606
    # block 0x00502608: entered by fall-through of jne at 0x00502606, 1 instruction(s), falls into the block at 0x0050260c
    mov edi, dword ptr [esp + stk_14]            # 00502608
L_0050260c:
    # block 0x0050260c: entered by jle at 0x005025f6, 3 instruction(s), ends with jg to 0x0050261b (forward)
    mov esi, dword ptr [edi + field_4]           # 0050260c
    {load} cmp ecx, esi                          # 0050260f
    jg.d8 L_0050261b                             # 00502611
    # block 0x00502613: entered by fall-through of jg at 0x00502611, 2 instruction(s), ends with jg to 0x00502621 (forward)
    {load} cmp edx, esi                          # 00502613
    jg.d8 L_00502621                             # 00502615
    # block 0x00502617: entered by fall-through of jg at 0x00502615, 2 instruction(s), ends with jle to 0x0050261e (forward)
    {load} cmp ecx, esi                          # 00502617
    jle.d8 L_0050261e                            # 00502619
L_0050261b:
    # block 0x0050261b: entered by jg at 0x00502611; fall-through of jle at 0x00502619, 2 instruction(s), ends with backward jump to 0x005025ed
    dec eax                                      # 0050261b
    jmp.d8 L_005025ed                            # 0050261c
L_0050261e:
    # block 0x0050261e: entered by jle at 0x00502619, 2 instruction(s), ends with backward jump to 0x005025ed
    inc eax                                      # 0050261e
    jmp.d8 L_005025ed                            # 0050261f
L_00502621:
    # block 0x00502621: entered by jg at 0x00502615, 5 instruction(s), ends with ret
    pop edi                                      # 00502621
    pop esi                                      # 00502622
    pop ebp                                      # 00502623
    pop ebx                                      # 00502624
    ret                                          # 00502625

# --- data items (not part of the function) -------------------------
.org 0x00502626 - 0x401000
PAD_00502626:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

