# FUN_005247a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005247a7
# extent:       0x005247a7-0x005247f7 (80 code bytes)
# span:         0x005247a7-0x005247f7 (code 80, tables 0, padding 0)
# sha256:       a5bf2a2b0acaeaac5536267ff3a21cc70e257ea060926bb9dee792d6924ca1b7
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005247a7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_1c; [esp + n] stk_8
# callees:      calls USER32.dll!IsWindowVisible, USER32.dll!IsIconic, FUN_005247f7, FUN_0051d630
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)
.set FUN_005247f7, .text + (0x005247f7 - 0x401000)

.org 0x005247a7 - 0x401000
.globl FUN_005247a7
FUN_005247a7:
    # block 0x005247a7: entry, 6 instruction(s), ends with jne to 0x005247d5 (forward)
    push esi                                     # 005247a7
    mov esi, dword ptr [esp + stk_8]             # 005247a8
    push edi                                     # 005247ac
    cmp esi, -0x1                                # 005247ad
    {load} mov edi, ecx                          # 005247b0
    jne.d8 L_005247d5                            # 005247b2
    # block 0x005247b4: entered by fall-through of jne at 0x005247b2, 4 instruction(s), calls USER32.dll!IsWindowVisible, ends with jne to 0x005247c5 (forward)
    push dword ptr [edi + field_1c]              # 005247b4
    call dword ptr [0x52a2e8]                    # 005247b7
    test eax, eax                                # 005247bd
    jne.d8 L_005247c5                            # 005247bf
    # block 0x005247c1: entered by fall-through of jne at 0x005247bf, 2 instruction(s), ends with forward jump to 0x005247d4
    push 0x1                                     # 005247c1
    jmp.d8 L_005247d4                            # 005247c3
L_005247c5:
    # block 0x005247c5: entered by jne at 0x005247bf, 4 instruction(s), calls USER32.dll!IsIconic, ends with je to 0x005247d5 (forward)
    push dword ptr [edi + field_1c]              # 005247c5
    call dword ptr [0x52a464]                    # 005247c8
    test eax, eax                                # 005247ce
    je.d8 L_005247d5                             # 005247d0
    # block 0x005247d2: entered by fall-through of je at 0x005247d0, 1 instruction(s), falls into the block at 0x005247d4
    push 0x9                                     # 005247d2
L_005247d4:
    # block 0x005247d4: entered by jmp at 0x005247c3, 1 instruction(s), falls into the block at 0x005247d5
    pop esi                                      # 005247d4
L_005247d5:
    # block 0x005247d5: entered by jne at 0x005247b2; je at 0x005247d0, 5 instruction(s), calls FUN_005247f7, ends with je to 0x005247f2 (forward)
    push esi                                     # 005247d5
    {load} mov ecx, edi                          # 005247d6
    call FUN_005247f7                            # 005247d8
    cmp esi, -0x1                                # 005247dd
    je.d8 L_005247f2                             # 005247e0
    # block 0x005247e2: entered by fall-through of je at 0x005247e0, 6 instruction(s), calls FUN_0051d630, FUN_005247f7, falls into the block at 0x005247f2
    push esi                                     # 005247e2
    {load} mov ecx, edi                          # 005247e3
    call FUN_0051d630                            # 005247e5
    push esi                                     # 005247ea
    {load} mov ecx, edi                          # 005247eb
    call FUN_005247f7                            # 005247ed
L_005247f2:
    # block 0x005247f2: entered by je at 0x005247e0, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 005247f2
    pop esi                                      # 005247f3
    ret 0x4                                      # 005247f4

