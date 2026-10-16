# FUN_005180e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005180e4
# extent:       0x005180e4-0x00518118 (52 code bytes)
# span:         0x005180e4-0x00518118 (code 52, tables 0, padding 0)
# sha256:       a600f5751d9394d97048771ce6b4d5d9f861b66bb857d7c11ff14a2fec97d69a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x948)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005180e4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518026
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518118
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518026, .text + (0x00518026 - 0x401000)

.org 0x005180e4 - 0x401000
.globl FUN_005180e4
FUN_005180e4:
    # block 0x005180e4: entry, 4 instruction(s), ends with je to 0x005180fb (forward)
    push eax                                     # 005180e4
    fnstsw ax                                    # 005180e5
    and eax, 0x3800                              # 005180e7
    je.d8 L_005180fb                             # 005180ec
    # block 0x005180ee: entered by fall-through of je at 0x005180ec, 4 instruction(s), calls FUN_00518026, ends with ret 0x4
    fild word ptr [esp + stk_8]                  # 005180ee
    call FUN_00518026                            # 005180f2
    pop eax                                      # 005180f7
    ret 0x4                                      # 005180f8
L_005180fb:
    # block 0x005180fb: entered by je at 0x005180ec, 10 instruction(s), calls FUN_00518026, ends with ret 0x4
    fxch st(1)                                   # 005180fb
    sub esp, 0xc                                 # 005180fd
    fstp tbyte ptr [esp]                         # 00518100
    fild word ptr [esp + stk_14]                 # 00518103
    call FUN_00518026                            # 00518107
    fld tbyte ptr [esp]                          # 0051810c
    fxch st(1)                                   # 0051810f
    add esp, 0xc                                 # 00518111
    pop eax                                      # 00518114
    ret 0x4                                      # 00518115

