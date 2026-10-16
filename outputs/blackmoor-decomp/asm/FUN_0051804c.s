# FUN_0051804c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051804c
# extent:       0x0051804c-0x00518098 (76 code bytes)
# span:         0x0051804c-0x00518098 (code 76, tables 0, padding 0)
# sha256:       8e34c41b0f603824ba18c284cf6416e7d6902eb04fd6f62f071f452912eec5a0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x8b0)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051804c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518026
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518098
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518026, .text + (0x00518026 - 0x401000)

.org 0x0051804c - 0x401000
.globl FUN_0051804c
FUN_0051804c:
    # block 0x0051804c: entry, 5 instruction(s), ends with je to 0x00518090 (forward)
    push eax                                     # 0051804c
    mov eax, dword ptr [esp + stk_8]             # 0051804d
    and eax, 0x7f800000                          # 00518051
    cmp eax, 0x7f800000                          # 00518056
    je.d8 L_00518090                             # 0051805b
    # block 0x0051805d: entered by fall-through of je at 0x0051805b, 3 instruction(s), ends with je to 0x00518073 (forward)
    fnstsw ax                                    # 0051805d
    and eax, 0x3800                              # 0051805f
    je.d8 L_00518073                             # 00518064
    # block 0x00518066: entered by fall-through of je at 0x00518064, 4 instruction(s), calls FUN_00518026, ends with ret 0x4
    fld dword ptr [esp + stk_8]                  # 00518066
    call FUN_00518026                            # 0051806a
    pop eax                                      # 0051806f
    ret 0x4                                      # 00518070
L_00518073:
    # block 0x00518073: entered by je at 0x00518064, 10 instruction(s), calls FUN_00518026, ends with ret 0x4
    fxch st(1)                                   # 00518073
    sub esp, 0xc                                 # 00518075
    fstp tbyte ptr [esp]                         # 00518078
    fld dword ptr [esp + stk_14]                 # 0051807b
    call FUN_00518026                            # 0051807f
    fld tbyte ptr [esp]                          # 00518084
    fxch st(1)                                   # 00518087
    add esp, 0xc                                 # 00518089
    pop eax                                      # 0051808c
    ret 0x4                                      # 0051808d
L_00518090:
    # block 0x00518090: entered by je at 0x0051805b, 3 instruction(s), ends with ret 0x4
    fdiv dword ptr [esp + stk_8]                 # 00518090
    pop eax                                      # 00518094
    ret 0x4                                      # 00518095

