# FUN_00524fe7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524fe7
# extent:       0x00524fe7-0x0052505e (119 code bytes)
# span:         0x00524fe7-0x0052505e (code 119, tables 0, padding 0)
# sha256:       069e349488ed28d5d579df858de306a7e4d4f4e53ad7324f491f1361e63d7168
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524fe7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14; [esi + n] field_4, field_8, field_2c; [esp + n] stk_c, stk_10
# callees:      calls FUN_00525371, FUN_0052513f, KERNEL32.dll!GetCurrentThreadId, USER32.dll!SetWindowsHookExA, FUN_00519cc0, FUN_00525bd1, FUN_0052116f, GDI32.dll!CreateSolidBrush, FUN_00521014
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)
.set FUN_00521014, .text + (0x00521014 - 0x401000)
.set FUN_0052116f, .text + (0x0052116f - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x00524fe7 - 0x401000
.globl FUN_00524fe7
FUN_00524fe7:
    # block 0x00524fe7: entry, 5 instruction(s), calls FUN_00525371, ends with jne to 0x00525023 (forward)
    push esi                                     # 00524fe7
    push edi                                     # 00524fe8
    call FUN_00525371                            # 00524fe9
    cmp byte ptr [eax + field_14], 0x0           # 00524fee
    jne.d8 L_00525023                            # 00524ff2
    # block 0x00524ff4: entered by fall-through of jne at 0x00524ff2, 4 instruction(s), calls FUN_0052513f, ends with jne to 0x00525023 (forward)
    call FUN_0052513f                            # 00524ff4
    {load} mov esi, eax                          # 00524ff9
    cmp dword ptr [esi + field_2c], 0x0          # 00524ffb
    jne.d8 L_00525023                            # 00524fff
    # block 0x00525001: entered by fall-through of jne at 0x00524fff, 9 instruction(s), calls KERNEL32.dll!GetCurrentThreadId, USER32.dll!SetWindowsHookExA, ends with jne to 0x00525023 (forward)
    call dword ptr [0x52a2a0]                    # 00525001
    push eax                                     # 00525007
    push 0x0                                     # 00525008
    push 0x51aea1                                # 0052500a
    push 0x5                                     # 0052500f
    call dword ptr [0x52a41c]                    # 00525011
    test eax, eax                                # 00525017
    mov dword ptr [esi + field_2c], eax          # 00525019
    jne.d8 L_00525023                            # 0052501c
    # block 0x0052501e: entered by fall-through of jne at 0x0052501c, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x00525023
    call FUN_00519cc0                            # 0052501e
L_00525023:
    # block 0x00525023: entered by jne at 0x00524ff2; jne at 0x00524fff; jne at 0x0052501c, 16 instruction(s), calls FUN_00525bd1, FUN_0052116f, GDI32.dll!CreateSolidBrush, ends with jne to 0x0052505b (forward)
    push 0x5249a0                                # 00525023
    mov ecx, 0x63c41c                            # 00525028
    call FUN_00525bd1                            # 0052502d
    {load} mov esi, eax                          # 00525032
    lea edi, [esi + field_4]                     # 00525034
    push edi                                     # 00525037
    call FUN_0052116f                            # 00525038
    push dword ptr [esp + stk_c]                 # 0052503d
    call dword ptr [0x52a060]                    # 00525041
    mov ecx, dword ptr [esp + stk_10]            # 00525047
    mov dword ptr [edi], eax                     # 0052504b
    mov dword ptr [esi + field_8], ecx           # 0052504d
    pop edi                                      # 00525050
    test eax, eax                                # 00525051
    pop esi                                      # 00525053
    jne.d8 L_0052505b                            # 00525054
    # block 0x00525056: entered by fall-through of jne at 0x00525054, 1 instruction(s), calls FUN_00521014, falls into the block at 0x0052505b
    call FUN_00521014                            # 00525056
L_0052505b:
    # block 0x0052505b: entered by jne at 0x00525054, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 0052505b

