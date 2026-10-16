# FUN_0051814c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051814c
# extent:       0x0051814c-0x00518198 (76 code bytes)
# span:         0x0051814c-0x00518198 (code 76, tables 0, padding 0)
# sha256:       879c0cc020aee4343f06b64e4155b7120bb160a0cff189654484e5e092a8252d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x9b0)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051814c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518039
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518198
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518039, .text + (0x00518039 - 0x401000)

.org 0x0051814c - 0x401000
.globl FUN_0051814c
FUN_0051814c:
    # block 0x0051814c: entry, 5 instruction(s), ends with je to 0x00518190 (forward)
    push eax                                     # 0051814c
    mov eax, dword ptr [esp + stk_8]             # 0051814d
    and eax, 0x7f800000                          # 00518151
    cmp eax, 0x7f800000                          # 00518156
    je.d8 L_00518190                             # 0051815b
    # block 0x0051815d: entered by fall-through of je at 0x0051815b, 3 instruction(s), ends with je to 0x00518173 (forward)
    fnstsw ax                                    # 0051815d
    and eax, 0x3800                              # 0051815f
    je.d8 L_00518173                             # 00518164
    # block 0x00518166: entered by fall-through of je at 0x00518164, 4 instruction(s), calls FUN_00518039, ends with ret 0x4
    fld dword ptr [esp + stk_8]                  # 00518166
    call FUN_00518039                            # 0051816a
    pop eax                                      # 0051816f
    ret 0x4                                      # 00518170
L_00518173:
    # block 0x00518173: entered by je at 0x00518164, 10 instruction(s), calls FUN_00518039, ends with ret 0x4
    fxch st(1)                                   # 00518173
    sub esp, 0xc                                 # 00518175
    fstp tbyte ptr [esp]                         # 00518178
    fld dword ptr [esp + stk_14]                 # 0051817b
    call FUN_00518039                            # 0051817f
    fld tbyte ptr [esp]                          # 00518184
    fxch st(1)                                   # 00518187
    add esp, 0xc                                 # 00518189
    pop eax                                      # 0051818c
    ret 0x4                                      # 0051818d
L_00518190:
    # block 0x00518190: entered by je at 0x0051815b, 3 instruction(s), ends with ret 0x4
    fdivr dword ptr [esp + stk_8]                # 00518190
    pop eax                                      # 00518194
    ret 0x4                                      # 00518195

