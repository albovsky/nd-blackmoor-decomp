# FUN_0051847c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051847c
# extent:       0x0051847c-0x0051852e (178 code bytes)
# span:         0x0051847c-0x0051852e (code 178, tables 0, padding 0)
# sha256:       fedd95152abf8b5e56a1967529793e107cd7396b17deabfe500d017d6c052a28
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xce0)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051847c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_6, stk_c, stk_18, stk_20, stk_24, stk_28
# callees:      calls FUN_00518276
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 54 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051852e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_6, 0x6  # offset +0x6
.equ stk_c, 0xc  # offset +0xc
.equ stk_18, 0x18  # offset +0x18
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00518276, .text + (0x00518276 - 0x401000)

.org 0x0051847c - 0x401000
.globl FUN_0051847c
FUN_0051847c:
    # block 0x0051847c: entry, 8 instruction(s), ends with je to 0x0051849e (forward)
    push edx                                     # 0051847c
    sub esp, 0x30                                # 0051847d
    fstp tbyte ptr [esp + stk_18]                # 00518480
    fstp tbyte ptr [esp]                         # 00518484
    {load} xor edx, edx                          # 00518487
    mov eax, dword ptr [esp + stk_6]             # 00518489
    test eax, 0x7fff0000                         # 0051848d
    je.d8 L_0051849e                             # 00518492
    # block 0x00518494: entered by fall-through of je at 0x00518492, 4 instruction(s), calls FUN_00518276, ends with ret
    call FUN_00518276                            # 00518494
    add esp, 0x30                                # 00518499
    pop edx                                      # 0051849c
    ret                                          # 0051849d
L_0051849e:
    # block 0x0051849e: entered by je at 0x00518492, 5 instruction(s), ends with je to 0x00518527 (forward)
    fld tbyte ptr [esp]                          # 0051849e
    fld tbyte ptr [esp + stk_18]                 # 005184a1
    mov eax, dword ptr [esp]                     # 005184a5
    or eax, dword ptr [esp + stk_4]              # 005184a8
    je.d8 L_00518527                             # 005184ac
    # block 0x005184ae: entered by fall-through of je at 0x005184ac, 14 instruction(s), ends with ja to 0x005184f9 (forward)
    fxch st(1)                                   # 005184ae
    fstp tbyte ptr [esp + stk_c]                 # 005184b0
    fld tbyte ptr [esp]                          # 005184b4
    fxch st(1)                                   # 005184b7
    or edx, 0x2                                  # 005184b9
    fnstcw word ptr [esp + stk_24]               # 005184bc
    mov eax, dword ptr [esp + stk_24]            # 005184c0
    or eax, 0x33f                                # 005184c4
    mov dword ptr [esp + stk_28], eax            # 005184c9
    fldcw word ptr [esp + stk_28]                # 005184cd
    mov eax, dword ptr [esp + stk_20]            # 005184d1
    and eax, 0x7fff                              # 005184d5
    cmp eax, 0x7fbe                              # 005184da
    ja.d8 L_005184f9                             # 005184df
    # block 0x005184e1: entered by fall-through of ja at 0x005184df, 6 instruction(s), ends with forward jump to 0x00518519
    or edx, 0x1                                  # 005184e1
    fmul qword ptr [0x568d04]                    # 005184e4
    fstp tbyte ptr [esp + stk_18]                # 005184ea
    fmul qword ptr [0x568d04]                    # 005184ee
    fstp tbyte ptr [esp]                         # 005184f4
    jmp.d8 L_00518519                            # 005184f7
L_005184f9:
    # block 0x005184f9: entered by ja at 0x005184df, 8 instruction(s), falls into the block at 0x00518519
    fnstcw word ptr [esp + stk_24]               # 005184f9
    mov eax, dword ptr [esp + stk_24]            # 005184fd
    or eax, 0x300                                # 00518501
    mov dword ptr [esp + stk_28], eax            # 00518506
    fldcw word ptr [esp + stk_28]                # 0051850a
    fstp st(0)                                   # 0051850e
    fmul qword ptr [0x568d04]                    # 00518510
    fstp tbyte ptr [esp]                         # 00518516
L_00518519:
    # block 0x00518519: entered by jmp at 0x005184f7, 5 instruction(s), calls FUN_00518276, ends with ret
    fldcw word ptr [esp + stk_24]                # 00518519
    call FUN_00518276                            # 0051851d
    add esp, 0x30                                # 00518522
    pop edx                                      # 00518525
    ret                                          # 00518526
L_00518527:
    # block 0x00518527: entered by je at 0x005184ac, 4 instruction(s), ends with ret
    fprem                                        # 00518527
    add esp, 0x30                                # 00518529
    pop edx                                      # 0051852c
    ret                                          # 0051852d

