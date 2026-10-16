# FUN_0051e91e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e91e
# extent:       0x0051e91e-0x0051e95c (62 code bytes)
# span:         0x0051e91e-0x0051e95c (code 62, tables 0, padding 0)
# sha256:       140d202e73ec034f69ace404e68a69fbd26118e44444436fa599a3ccd1735372
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e91e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_18, stk_2c
# callees:      calls FUN_0051e627, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18
.equ stk_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e627, .text + (0x0051e627 - 0x401000)

.org 0x0051e91e - 0x401000
.globl FUN_0051e91e
FUN_0051e91e:
    # block 0x0051e91e: entry, 9 instruction(s), ends with je to 0x0051e956 (forward)
    push ebx                                     # 0051e91e
    mov ebx, dword ptr [esp + stk_10]            # 0051e91f
    push esi                                     # 0051e923
    push edi                                     # 0051e924
    mov edi, dword ptr [esp + stk_10]            # 0051e925
    {load} mov esi, ecx                          # 0051e929
    lea eax, [edi + ebx]                         # 0051e92b
    test eax, eax                                # 0051e92e
    je.d8 L_0051e956                             # 0051e930
    # block 0x0051e932: entered by fall-through of je at 0x0051e930, 13 instruction(s), calls FUN_0051e627, FUN_0050fa90, falls into the block at 0x0051e956
    push eax                                     # 0051e932
    call FUN_0051e627                            # 0051e933
    push edi                                     # 0051e938
    push dword ptr [esp + stk_18]                # 0051e939
    push dword ptr [esi]                         # 0051e93d
    call FUN_0050fa90                            # 0051e93f
    mov eax, dword ptr [esi]                     # 0051e944
    push ebx                                     # 0051e946
    push dword ptr [esp + stk_2c]                # 0051e947
    {load} add eax, edi                          # 0051e94b
    push eax                                     # 0051e94d
    call FUN_0050fa90                            # 0051e94e
    add esp, 0x18                                # 0051e953
L_0051e956:
    # block 0x0051e956: entered by je at 0x0051e930, 4 instruction(s), ends with ret 0x10
    pop edi                                      # 0051e956
    pop esi                                      # 0051e957
    pop ebx                                      # 0051e958
    ret 0x10                                     # 0051e959

