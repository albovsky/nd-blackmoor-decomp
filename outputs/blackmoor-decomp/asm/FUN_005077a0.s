# FUN_005077a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005077a0
# extent:       0x005077a0-0x0050788b (235 code bytes)
# span:         0x005077a0-0x00507890 (code 235, tables 0, padding 5)
# sha256:       b8a72c77bd0a9ee385d88e79c4a4a57f4cf41a5c6765de4a7d7e5db388d49f05
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00507720 (+0x80)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005077a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_8, field_c, field_10, field_14; [esp + n] stk_10, stk_14, stk_18
# callees:      calls FUN_0050bc80, FUN_0050a440, FUN_00507890
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 102 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00507890, .text + (0x00507890 - 0x401000)
.set FUN_0050a440, .text + (0x0050a440 - 0x401000)
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)

.org 0x005077a0 - 0x401000
.globl FUN_005077a0
FUN_005077a0:
    # block 0x005077a0: entry, 41 instruction(s), calls FUN_0050bc80, ends with jle to 0x00507867 (forward)
    push ecx                                     # 005077a0
    push ebx                                     # 005077a1
    push ebp                                     # 005077a2
    push esi                                     # 005077a3
    mov esi, dword ptr [esp + stk_18]            # 005077a4
    push edi                                     # 005077a8
    mov edi, dword ptr [esp + stk_18]            # 005077a9
    push 0x18                                    # 005077ad
    {load} xor ebx, ebx                          # 005077af
    mov eax, dword ptr [edi]                     # 005077b1
    mov dword ptr [esp + stk_14], ebx            # 005077b3
    push eax                                     # 005077b7
    push esi                                     # 005077b8
    call FUN_0050bc80                            # 005077b9
    mov ecx, dword ptr [edi + field_4]           # 005077be
    push 0x18                                    # 005077c1
    push ecx                                     # 005077c3
    push esi                                     # 005077c4
    call FUN_0050bc80                            # 005077c5
    mov edx, dword ptr [edi + field_8]           # 005077ca
    push 0x18                                    # 005077cd
    dec edx                                      # 005077cf
    push edx                                     # 005077d0
    push esi                                     # 005077d1
    call FUN_0050bc80                            # 005077d2
    mov eax, dword ptr [edi + field_c]           # 005077d7
    push 0x6                                     # 005077da
    dec eax                                      # 005077dc
    push eax                                     # 005077dd
    push esi                                     # 005077de
    call FUN_0050bc80                            # 005077df
    mov ecx, dword ptr [edi + field_10]          # 005077e4
    push 0x8                                     # 005077e7
    push ecx                                     # 005077e9
    push esi                                     # 005077ea
    call FUN_0050bc80                            # 005077eb
    mov eax, dword ptr [edi + field_c]           # 005077f0
    add esp, 0x3c                                # 005077f3
    {load} xor ebp, ebp                          # 005077f6
    test eax, eax                                # 005077f8
    jle.d8 L_00507867                            # 005077fa
    # block 0x005077fc: entered by fall-through of jle at 0x005077fa, 1 instruction(s), falls into the block at 0x005077ff
    lea ebx, [edi + field_14]                    # 005077fc
L_005077ff:
    # block 0x005077ff: entered by jl at 0x00507863, 6 instruction(s), calls FUN_0050a440, ends with jle to 0x00507837 (forward)
    mov edx, dword ptr [ebx]                     # 005077ff
    push edx                                     # 00507801
    call FUN_0050a440                            # 00507802
    add esp, 0x4                                 # 00507807
    cmp eax, 0x3                                 # 0050780a
    jle.d8 L_00507837                            # 0050780d
    # block 0x0050780f: entered by fall-through of jle at 0x0050780d, 17 instruction(s), calls FUN_0050bc80, ends with forward jump to 0x00507845
    mov eax, dword ptr [ebx]                     # 0050780f
    push 0x3                                     # 00507811
    push eax                                     # 00507813
    push esi                                     # 00507814
    call FUN_0050bc80                            # 00507815
    push 0x1                                     # 0050781a
    push 0x1                                     # 0050781c
    push esi                                     # 0050781e
    call FUN_0050bc80                            # 0050781f
    mov ecx, dword ptr [ebx]                     # 00507824
    push 0x5                                     # 00507826
    sar ecx, 0x3                                 # 00507828
    push ecx                                     # 0050782b
    push esi                                     # 0050782c
    call FUN_0050bc80                            # 0050782d
    add esp, 0x24                                # 00507832
    jmp.d8 L_00507845                            # 00507835
L_00507837:
    # block 0x00507837: entered by jle at 0x0050780d, 6 instruction(s), calls FUN_0050bc80, falls into the block at 0x00507845
    mov edx, dword ptr [ebx]                     # 00507837
    push 0x4                                     # 00507839
    push edx                                     # 0050783b
    push esi                                     # 0050783c
    call FUN_0050bc80                            # 0050783d
    add esp, 0xc                                 # 00507842
L_00507845:
    # block 0x00507845: entered by jmp at 0x00507835, 12 instruction(s), calls FUN_00507890, ends with jl to 0x005077ff (backward)
    mov eax, dword ptr [ebx]                     # 00507845
    push eax                                     # 00507847
    call FUN_00507890                            # 00507848
    mov ecx, dword ptr [esp + stk_14]            # 0050784d
    add esp, 0x4                                 # 00507851
    {load} add ecx, eax                          # 00507854
    mov eax, dword ptr [edi + field_c]           # 00507856
    inc ebp                                      # 00507859
    add ebx, 0x4                                 # 0050785a
    {load} cmp ebp, eax                          # 0050785d
    mov dword ptr [esp + stk_10], ecx            # 0050785f
    jl.d8 L_005077ff                             # 00507863
    # block 0x00507865: entered by fall-through of jl at 0x00507863, 1 instruction(s), falls into the block at 0x00507867
    {load} mov ebx, ecx                          # 00507865
L_00507867:
    # block 0x00507867: entered by jle at 0x005077fa, 2 instruction(s), ends with jle to 0x00507885 (forward)
    test ebx, ebx                                # 00507867
    jle.d8 L_00507885                            # 00507869
    # block 0x0050786b: entered by fall-through of jle at 0x00507869, 1 instruction(s), falls into the block at 0x00507871
    add edi, 0x114                               # 0050786b
L_00507871:
    # block 0x00507871: entered by jne at 0x00507883, 9 instruction(s), calls FUN_0050bc80, ends with jne to 0x00507871 (backward)
    mov ecx, dword ptr [edi]                     # 00507871
    push 0x8                                     # 00507873
    push ecx                                     # 00507875
    push esi                                     # 00507876
    call FUN_0050bc80                            # 00507877
    add esp, 0xc                                 # 0050787c
    add edi, 0x4                                 # 0050787f
    dec ebx                                      # 00507882
    jne.d8 L_00507871                            # 00507883
L_00507885:
    # block 0x00507885: entered by jle at 0x00507869; fall-through of jne at 0x00507883, 6 instruction(s), ends with ret
    pop edi                                      # 00507885
    pop esi                                      # 00507886
    pop ebp                                      # 00507887
    pop ebx                                      # 00507888
    pop ecx                                      # 00507889
    ret                                          # 0050788a

# --- data items (not part of the function) -------------------------
.org 0x0050788b - 0x401000
PAD_0050788b:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

