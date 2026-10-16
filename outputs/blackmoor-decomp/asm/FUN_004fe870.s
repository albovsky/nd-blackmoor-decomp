# FUN_004fe870
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe870
# extent:       0x004fe870-0x004fe970 (256 code bytes)
# span:         0x004fe870-0x004fe970 (code 256, tables 0, padding 0)
# sha256:       3c07ddcafd83794026ef9bebb84b68f75d445e0979790686057a4f46bc2be523
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe870
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [ebx + n] field_4, field_8; [ecx + n] field_c; [esp + n] stk_10, stk_1c, stk_24, stk_28, stk_2c, stk_30, stk_34
# callees:      calls FUN_0050bc50, FUN_0050be60, FUN_004fe970, FUN_004feb60, FUN_004fea80, FUN_004fe9a0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 102 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_004fe970, .text + (0x004fe970 - 0x401000)
.set FUN_004fe9a0, .text + (0x004fe9a0 - 0x401000)
.set FUN_004fea80, .text + (0x004fea80 - 0x401000)
.set FUN_004feb60, .text + (0x004feb60 - 0x401000)
.set FUN_0050bc50, .text + (0x0050bc50 - 0x401000)
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x004fe870 - 0x401000
.globl FUN_004fe870
FUN_004fe870:
    # block 0x004fe870: entry, 6 instruction(s), ends with je to 0x004fe965 (forward)
    sub esp, 0x1c                                # 004fe870
    push ebx                                     # 004fe873
    mov ebx, dword ptr [esp + stk_2c]            # 004fe874
    test ebx, ebx                                # 004fe878
    push ebp                                     # 004fe87a
    je.d32 L_004fe965                            # 004fe87b
    # block 0x004fe881: entered by fall-through of je at 0x004fe87b, 32 instruction(s), calls FUN_0050bc50, FUN_0050be60, FUN_004fe970, ends with je to 0x004fe8e3 (forward)
    mov eax, dword ptr [ebx + field_4]           # 004fe881
    mov ecx, dword ptr [ebx]                     # 004fe884
    push esi                                     # 004fe886
    push edi                                     # 004fe887
    push eax                                     # 004fe888
    lea edx, [esp + stk_1c]                      # 004fe889
    push ecx                                     # 004fe88d
    push edx                                     # 004fe88e
    call FUN_0050bc50                            # 004fe88f
    lea eax, [esp + stk_24]                      # 004fe894
    push 0x8                                     # 004fe898
    push eax                                     # 004fe89a
    call FUN_0050be60                            # 004fe89b
    {load} mov ebp, eax                          # 004fe8a0
    {load} xor ecx, ecx                          # 004fe8a2
    lea edx, [esp + stk_24]                      # 004fe8a4
    push 0x6                                     # 004fe8a8
    lea eax, [esp + stk_30]                      # 004fe8aa
    mov dword ptr [esp + stk_28], ecx            # 004fe8ae
    push edx                                     # 004fe8b2
    push eax                                     # 004fe8b3
    mov word ptr [esp + stk_34], cx              # 004fe8b4
    call FUN_004fe970                            # 004fe8b9
    add esp, 0x20                                # 004fe8be
    mov ecx, 0x3                                 # 004fe8c1
    mov edi, 0x560a6c                            # 004fe8c6
    lea esi, [esp + stk_10]                      # 004fe8cb
    {load} xor edx, edx                          # 004fe8cf
    rep cmpsw word ptr [esi], word ptr es:[edi]  # 004fe8d1
    pop edi                                      # 004fe8d4
    pop esi                                      # 004fe8d5
    je.d8 L_004fe8e3                             # 004fe8d6
    # block 0x004fe8d8: entered by fall-through of je at 0x004fe8d6, 5 instruction(s), ends with ret
    pop ebp                                      # 004fe8d8
    mov eax, 0xffffff7c                          # 004fe8d9
    pop ebx                                      # 004fe8de
    add esp, 0x1c                                # 004fe8df
    ret                                          # 004fe8e2
L_004fe8e3:
    # block 0x004fe8e3: entered by je at 0x004fe8d6, 3 instruction(s), ends with je to 0x004fe93f (forward)
    {load} mov eax, ebp                          # 004fe8e3
    dec eax                                      # 004fe8e5
    je.d8 L_004fe93f                             # 004fe8e6
    # block 0x004fe8e8: entered by fall-through of je at 0x004fe8e6, 2 instruction(s), ends with je to 0x004fe91c (forward)
    sub eax, 0x2                                 # 004fe8e8
    je.d8 L_004fe91c                             # 004fe8eb
    # block 0x004fe8ed: entered by fall-through of je at 0x004fe8eb, 2 instruction(s), ends with jne to 0x004fe965 (forward)
    sub eax, 0x2                                 # 004fe8ed
    jne.d8 L_004fe965                            # 004fe8f0
    # block 0x004fe8f2: entered by fall-through of jne at 0x004fe8f0, 4 instruction(s), ends with je to 0x004fe965 (forward)
    mov eax, dword ptr [esp + stk_28]            # 004fe8f2
    mov ecx, dword ptr [eax + field_8]           # 004fe8f6
    test ecx, ecx                                # 004fe8f9
    je.d8 L_004fe965                             # 004fe8fb
    # block 0x004fe8fd: entered by fall-through of je at 0x004fe8fb, 4 instruction(s), ends with je to 0x004fe965 (forward)
    mov ecx, dword ptr [esp + stk_2c]            # 004fe8fd
    mov edx, dword ptr [ecx + field_c]           # 004fe901
    test edx, edx                                # 004fe904
    je.d8 L_004fe965                             # 004fe906
    # block 0x004fe908: entered by fall-through of je at 0x004fe906, 9 instruction(s), calls FUN_004feb60, ends with ret
    lea edx, [esp + stk_10]                      # 004fe908
    push edx                                     # 004fe90c
    push eax                                     # 004fe90d
    call FUN_004feb60                            # 004fe90e
    add esp, 0x8                                 # 004fe913
    pop ebp                                      # 004fe916
    pop ebx                                      # 004fe917
    add esp, 0x1c                                # 004fe918
    ret                                          # 004fe91b
L_004fe91c:
    # block 0x004fe91c: entered by je at 0x004fe8eb, 4 instruction(s), ends with je to 0x004fe965 (forward)
    mov eax, dword ptr [esp + stk_28]            # 004fe91c
    mov ecx, dword ptr [eax + field_8]           # 004fe920
    test ecx, ecx                                # 004fe923
    je.d8 L_004fe965                             # 004fe925
    # block 0x004fe927: entered by fall-through of je at 0x004fe925, 10 instruction(s), calls FUN_004fea80, ends with ret
    mov edx, dword ptr [esp + stk_2c]            # 004fe927
    lea ecx, [esp + stk_10]                      # 004fe92b
    push ecx                                     # 004fe92f
    push edx                                     # 004fe930
    call FUN_004fea80                            # 004fe931
    add esp, 0x8                                 # 004fe936
    pop ebp                                      # 004fe939
    pop ebx                                      # 004fe93a
    add esp, 0x1c                                # 004fe93b
    ret                                          # 004fe93e
L_004fe93f:
    # block 0x004fe93f: entered by je at 0x004fe8e6, 3 instruction(s), ends with je to 0x004fe965 (forward)
    mov eax, dword ptr [ebx + field_8]           # 004fe93f
    test eax, eax                                # 004fe942
    je.d8 L_004fe965                             # 004fe944
    # block 0x004fe946: entered by fall-through of je at 0x004fe944, 4 instruction(s), ends with jne to 0x004fe965 (forward)
    mov eax, dword ptr [esp + stk_28]            # 004fe946
    mov ecx, dword ptr [eax + field_8]           # 004fe94a
    test ecx, ecx                                # 004fe94d
    jne.d8 L_004fe965                            # 004fe94f
    # block 0x004fe951: entered by fall-through of jne at 0x004fe94f, 9 instruction(s), calls FUN_004fe9a0, ends with ret
    lea ecx, [esp + stk_10]                      # 004fe951
    push ecx                                     # 004fe955
    push eax                                     # 004fe956
    call FUN_004fe9a0                            # 004fe957
    add esp, 0x8                                 # 004fe95c
    pop ebp                                      # 004fe95f
    pop ebx                                      # 004fe960
    add esp, 0x1c                                # 004fe961
    ret                                          # 004fe964
L_004fe965:
    # block 0x004fe965: entered by je at 0x004fe87b; jne at 0x004fe8f0; je at 0x004fe8fb; je at 0x004fe906; more, 5 instruction(s), ends with ret
    pop ebp                                      # 004fe965
    mov eax, 0xffffff7b                          # 004fe966
    pop ebx                                      # 004fe96b
    add esp, 0x1c                                # 004fe96c
    ret                                          # 004fe96f

