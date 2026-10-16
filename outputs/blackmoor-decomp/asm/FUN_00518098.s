# FUN_00518098
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518098
# extent:       0x00518098-0x005180e4 (76 code bytes)
# span:         0x00518098-0x005180e4 (code 76, tables 0, padding 0)
# sha256:       4646412c7934f9f5124c5bdf33c4f276e4621917b2eb0983472f429d8f856a95
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x8fc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518098
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c, stk_14
# callees:      calls FUN_00518026
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005180e4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518026, .text + (0x00518026 - 0x401000)

.org 0x00518098 - 0x401000
.globl FUN_00518098
FUN_00518098:
    # block 0x00518098: entry, 5 instruction(s), ends with je to 0x005180dc (forward)
    push eax                                     # 00518098
    mov eax, dword ptr [esp + stk_c]             # 00518099
    and eax, 0x7ff00000                          # 0051809d
    cmp eax, 0x7ff00000                          # 005180a2
    je.d8 L_005180dc                             # 005180a7
    # block 0x005180a9: entered by fall-through of je at 0x005180a7, 3 instruction(s), ends with je to 0x005180bf (forward)
    fnstsw ax                                    # 005180a9
    and eax, 0x3800                              # 005180ab
    je.d8 L_005180bf                             # 005180b0
    # block 0x005180b2: entered by fall-through of je at 0x005180b0, 4 instruction(s), calls FUN_00518026, ends with ret 0x8
    fld qword ptr [esp + stk_8]                  # 005180b2
    call FUN_00518026                            # 005180b6
    pop eax                                      # 005180bb
    ret 0x8                                      # 005180bc
L_005180bf:
    # block 0x005180bf: entered by je at 0x005180b0, 10 instruction(s), calls FUN_00518026, ends with ret 0x8
    fxch st(1)                                   # 005180bf
    sub esp, 0xc                                 # 005180c1
    fstp tbyte ptr [esp]                         # 005180c4
    fld qword ptr [esp + stk_14]                 # 005180c7
    call FUN_00518026                            # 005180cb
    fld tbyte ptr [esp]                          # 005180d0
    fxch st(1)                                   # 005180d3
    add esp, 0xc                                 # 005180d5
    pop eax                                      # 005180d8
    ret 0x8                                      # 005180d9
L_005180dc:
    # block 0x005180dc: entered by je at 0x005180a7, 3 instruction(s), ends with ret 0x8
    fdiv qword ptr [esp + stk_8]                 # 005180dc
    pop eax                                      # 005180e0
    ret 0x8                                      # 005180e1

