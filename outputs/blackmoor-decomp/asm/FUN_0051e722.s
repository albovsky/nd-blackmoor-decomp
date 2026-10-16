# FUN_0051e722
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e722
# extent:       0x0051e722-0x0051e745 (35 code bytes)
# span:         0x0051e722-0x0051e745 (code 35, tables 0, padding 0)
# sha256:       1010d98be19a991870b554cdf0ea0380a4ea251c7b3342f53058d48514d2a9ff
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e722
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls KERNEL32.dll!InterlockedDecrement, FUN_0051e6a9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e6a9, .text + (0x0051e6a9 - 0x401000)

.org 0x0051e722 - 0x401000
.globl FUN_0051e722
FUN_0051e722:
    # block 0x0051e722: entry, 4 instruction(s), ends with je to 0x0051e741 (forward)
    push esi                                     # 0051e722
    mov esi, dword ptr [esp + stk_8]             # 0051e723
    cmp esi, dword ptr [0x5679b4]                # 0051e727
    je.d8 L_0051e741                             # 0051e72d
    # block 0x0051e72f: entered by fall-through of je at 0x0051e72d, 4 instruction(s), calls KERNEL32.dll!InterlockedDecrement, ends with jg to 0x0051e741 (forward)
    push esi                                     # 0051e72f
    call dword ptr [0x52a1fc]                    # 0051e730
    test eax, eax                                # 0051e736
    jg.d8 L_0051e741                             # 0051e738
    # block 0x0051e73a: entered by fall-through of jg at 0x0051e738, 2 instruction(s), calls FUN_0051e6a9, falls into the block at 0x0051e741
    {load} mov ecx, esi                          # 0051e73a
    call FUN_0051e6a9                            # 0051e73c
L_0051e741:
    # block 0x0051e741: entered by je at 0x0051e72d; jg at 0x0051e738, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051e741
    ret 0x4                                      # 0051e742

