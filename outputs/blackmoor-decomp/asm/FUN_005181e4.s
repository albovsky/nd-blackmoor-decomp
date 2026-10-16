# FUN_005181e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005181e4
# extent:       0x005181e4-0x00518218 (52 code bytes)
# span:         0x005181e4-0x00518218 (code 52, tables 0, padding 0)
# sha256:       92ccc8d82048a5fe7c8a4206ec7436a198c85c572fff0f17d69064f508ebe83a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xa48)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005181e4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518039
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518218
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518039, .text + (0x00518039 - 0x401000)

.org 0x005181e4 - 0x401000
.globl FUN_005181e4
FUN_005181e4:
    # block 0x005181e4: entry, 4 instruction(s), ends with je to 0x005181fb (forward)
    push eax                                     # 005181e4
    fnstsw ax                                    # 005181e5
    and eax, 0x3800                              # 005181e7
    je.d8 L_005181fb                             # 005181ec
    # block 0x005181ee: entered by fall-through of je at 0x005181ec, 4 instruction(s), calls FUN_00518039, ends with ret 0x4
    fild word ptr [esp + stk_8]                  # 005181ee
    call FUN_00518039                            # 005181f2
    pop eax                                      # 005181f7
    ret 0x4                                      # 005181f8
L_005181fb:
    # block 0x005181fb: entered by je at 0x005181ec, 10 instruction(s), calls FUN_00518039, ends with ret 0x4
    fxch st(1)                                   # 005181fb
    sub esp, 0xc                                 # 005181fd
    fstp tbyte ptr [esp]                         # 00518200
    fild word ptr [esp + stk_14]                 # 00518203
    call FUN_00518039                            # 00518207
    fld tbyte ptr [esp]                          # 0051820c
    fxch st(1)                                   # 0051820f
    add esp, 0xc                                 # 00518211
    pop eax                                      # 00518214
    ret 0x4                                      # 00518215

