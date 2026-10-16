# FUN_0051181f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051181f
# extent:       0x0051181f-0x00511850 (49 code bytes)
# span:         0x0051181f-0x00511850 (code 49, tables 0, padding 0)
# sha256:       d5748a1236092028ae8b199bac0bb65729e23f668a9cebb0ddbc9575a160e454
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051181f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10, stk_14, stk_18
# callees:      calls FUN_005117ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_005117ea, .text + (0x005117ea - 0x401000)

.org 0x0051181f - 0x401000
.globl FUN_0051181f
FUN_0051181f:
    # block 0x0051181f: entry, 7 instruction(s), ends with jle to 0x0051184d (forward)
    push esi                                     # 0051181f
    push edi                                     # 00511820
    mov edi, dword ptr [esp + stk_10]            # 00511821
    {load} mov eax, edi                          # 00511825
    dec edi                                      # 00511827
    test eax, eax                                # 00511828
    jle.d8 L_0051184d                            # 0051182a
    # block 0x0051182c: entered by fall-through of jle at 0x0051182a, 1 instruction(s), falls into the block at 0x00511830
    mov esi, dword ptr [esp + stk_18]            # 0051182c
L_00511830:
    # block 0x00511830: entered by jg at 0x0051184b, 7 instruction(s), calls FUN_005117ea, ends with je to 0x0051184d (forward)
    push esi                                     # 00511830
    push dword ptr [esp + stk_18]                # 00511831
    push dword ptr [esp + stk_14]                # 00511835
    call FUN_005117ea                            # 00511839
    add esp, 0xc                                 # 0051183e
    cmp dword ptr [esi], -0x1                    # 00511841
    je.d8 L_0051184d                             # 00511844
    # block 0x00511846: entered by fall-through of je at 0x00511844, 4 instruction(s), ends with jg to 0x00511830 (backward)
    {load} mov eax, edi                          # 00511846
    dec edi                                      # 00511848
    test eax, eax                                # 00511849
    jg.d8 L_00511830                             # 0051184b
L_0051184d:
    # block 0x0051184d: entered by jle at 0x0051182a; je at 0x00511844; fall-through of jg at 0x0051184b, 3 instruction(s), ends with ret
    pop edi                                      # 0051184d
    pop esi                                      # 0051184e
    ret                                          # 0051184f

