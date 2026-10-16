# FUN_00518198
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518198
# extent:       0x00518198-0x005181e4 (76 code bytes)
# span:         0x00518198-0x005181e4 (code 76, tables 0, padding 0)
# sha256:       572bfcde4606bf491b0245447818fe1c74f397e9ebb78aaf26568fb023fe26ca
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x9fc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518198
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c, stk_14
# callees:      calls FUN_00518039
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005181e4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518039, .text + (0x00518039 - 0x401000)

.org 0x00518198 - 0x401000
.globl FUN_00518198
FUN_00518198:
    # block 0x00518198: entry, 5 instruction(s), ends with je to 0x005181dc (forward)
    push eax                                     # 00518198
    mov eax, dword ptr [esp + stk_c]             # 00518199
    and eax, 0x7ff00000                          # 0051819d
    cmp eax, 0x7ff00000                          # 005181a2
    je.d8 L_005181dc                             # 005181a7
    # block 0x005181a9: entered by fall-through of je at 0x005181a7, 3 instruction(s), ends with je to 0x005181bf (forward)
    fnstsw ax                                    # 005181a9
    and eax, 0x3800                              # 005181ab
    je.d8 L_005181bf                             # 005181b0
    # block 0x005181b2: entered by fall-through of je at 0x005181b0, 4 instruction(s), calls FUN_00518039, ends with ret 0x8
    fld qword ptr [esp + stk_8]                  # 005181b2
    call FUN_00518039                            # 005181b6
    pop eax                                      # 005181bb
    ret 0x8                                      # 005181bc
L_005181bf:
    # block 0x005181bf: entered by je at 0x005181b0, 10 instruction(s), calls FUN_00518039, ends with ret 0x8
    fxch st(1)                                   # 005181bf
    sub esp, 0xc                                 # 005181c1
    fstp tbyte ptr [esp]                         # 005181c4
    fld qword ptr [esp + stk_14]                 # 005181c7
    call FUN_00518039                            # 005181cb
    fld tbyte ptr [esp]                          # 005181d0
    fxch st(1)                                   # 005181d3
    add esp, 0xc                                 # 005181d5
    pop eax                                      # 005181d8
    ret 0x8                                      # 005181d9
L_005181dc:
    # block 0x005181dc: entered by je at 0x005181a7, 3 instruction(s), ends with ret 0x8
    fdivr qword ptr [esp + stk_8]                # 005181dc
    pop eax                                      # 005181e0
    ret 0x8                                      # 005181e1

