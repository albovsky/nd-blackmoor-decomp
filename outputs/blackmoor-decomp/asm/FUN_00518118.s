# FUN_00518118
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518118
# extent:       0x00518118-0x0051814c (52 code bytes)
# span:         0x00518118-0x0051814c (code 52, tables 0, padding 0)
# sha256:       754cead3ec2faa36d2bfb8cac08ddd03d65dcab678b78a5def2c60c61971e143
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x97c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518118
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518026
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051814c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518026, .text + (0x00518026 - 0x401000)

.org 0x00518118 - 0x401000
.globl FUN_00518118
FUN_00518118:
    # block 0x00518118: entry, 4 instruction(s), ends with je to 0x0051812f (forward)
    push eax                                     # 00518118
    fnstsw ax                                    # 00518119
    and eax, 0x3800                              # 0051811b
    je.d8 L_0051812f                             # 00518120
    # block 0x00518122: entered by fall-through of je at 0x00518120, 4 instruction(s), calls FUN_00518026, ends with ret 0x4
    fild dword ptr [esp + stk_8]                 # 00518122
    call FUN_00518026                            # 00518126
    pop eax                                      # 0051812b
    ret 0x4                                      # 0051812c
L_0051812f:
    # block 0x0051812f: entered by je at 0x00518120, 10 instruction(s), calls FUN_00518026, ends with ret 0x4
    fxch st(1)                                   # 0051812f
    sub esp, 0xc                                 # 00518131
    fstp tbyte ptr [esp]                         # 00518134
    fild dword ptr [esp + stk_14]                # 00518137
    call FUN_00518026                            # 0051813b
    fld tbyte ptr [esp]                          # 00518140
    fxch st(1)                                   # 00518143
    add esp, 0xc                                 # 00518145
    pop eax                                      # 00518148
    ret 0x4                                      # 00518149

