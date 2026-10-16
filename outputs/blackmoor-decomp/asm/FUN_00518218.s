# FUN_00518218
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518218
# extent:       0x00518218-0x0051824c (52 code bytes)
# span:         0x00518218-0x0051824c (code 52, tables 0, padding 0)
# sha256:       33bda7724edc7da65a3f61391f09122614d3823482bba553069045a469ddab31
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xa7c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518218
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518039
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051824c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518039, .text + (0x00518039 - 0x401000)

.org 0x00518218 - 0x401000
.globl FUN_00518218
FUN_00518218:
    # block 0x00518218: entry, 4 instruction(s), ends with je to 0x0051822f (forward)
    push eax                                     # 00518218
    fnstsw ax                                    # 00518219
    and eax, 0x3800                              # 0051821b
    je.d8 L_0051822f                             # 00518220
    # block 0x00518222: entered by fall-through of je at 0x00518220, 4 instruction(s), calls FUN_00518039, ends with ret 0x4
    fild dword ptr [esp + stk_8]                 # 00518222
    call FUN_00518039                            # 00518226
    pop eax                                      # 0051822b
    ret 0x4                                      # 0051822c
L_0051822f:
    # block 0x0051822f: entered by je at 0x00518220, 10 instruction(s), calls FUN_00518039, ends with ret 0x4
    fxch st(1)                                   # 0051822f
    sub esp, 0xc                                 # 00518231
    fstp tbyte ptr [esp]                         # 00518234
    fild dword ptr [esp + stk_14]                # 00518237
    call FUN_00518039                            # 0051823b
    fld tbyte ptr [esp]                          # 00518240
    fxch st(1)                                   # 00518243
    add esp, 0xc                                 # 00518245
    pop eax                                      # 00518248
    ret 0x4                                      # 00518249

