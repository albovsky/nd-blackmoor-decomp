# FUN_0051c47f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c47f
# extent:       0x0051c47f-0x0051c4aa (43 code bytes)
# span:         0x0051c47f-0x0051c4aa (code 43, tables 0, padding 0)
# sha256:       53dfe87ff3ede52203e00993af3a97cb505392c74bade62d770dcfcf62163dcf
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c47f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_14
# callees:      calls FUN_0051d540, FUN_0051d526, USER32.dll!AdjustWindowRectEx
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d540, .text + (0x0051d540 - 0x401000)

.org 0x0051c47f - 0x401000
.globl FUN_0051c47f
FUN_0051c47f:
    # block 0x0051c47f: entry, 5 instruction(s), calls FUN_0051d540, ends with jne to 0x0051c491 (forward)
    push esi                                     # 0051c47f
    {load} mov esi, ecx                          # 0051c480
    call FUN_0051d540                            # 0051c482
    cmp dword ptr [esp + stk_c], 0x0             # 0051c487
    jne.d8 L_0051c491                            # 0051c48c
    # block 0x0051c48e: entered by fall-through of jne at 0x0051c48c, 1 instruction(s), falls into the block at 0x0051c491
    and ah, -0x3                                 # 0051c48e
L_0051c491:
    # block 0x0051c491: entered by jne at 0x0051c48c, 9 instruction(s), calls FUN_0051d526, USER32.dll!AdjustWindowRectEx, ends with ret 0x8
    push eax                                     # 0051c491
    push 0x0                                     # 0051c492
    {load} mov ecx, esi                          # 0051c494
    call FUN_0051d526                            # 0051c496
    push eax                                     # 0051c49b
    push dword ptr [esp + stk_14]                # 0051c49c
    call dword ptr [0x52a2f8]                    # 0051c4a0
    pop esi                                      # 0051c4a6
    ret 0x8                                      # 0051c4a7

