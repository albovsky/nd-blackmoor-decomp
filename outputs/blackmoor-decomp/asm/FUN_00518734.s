# FUN_00518734
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518734
# extent:       0x00518734-0x005187e9 (181 code bytes)
# span:         0x00518734-0x005187e9 (code 181, tables 0, padding 0)
# sha256:       7071461eff1b70e01cbb1997c557ebdf63b0bebb0bb0951ceb7d3f7eb13c5419
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xf98)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518734
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_6, stk_c, stk_18, stk_20, stk_24, stk_28
# callees:      calls FUN_0051852e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 54 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005187e9
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
.set FUN_0051852e, .text + (0x0051852e - 0x401000)

.org 0x00518734 - 0x401000
.globl FUN_00518734
FUN_00518734:
    # block 0x00518734: entry, 8 instruction(s), ends with je to 0x00518759 (forward)
    push edx                                     # 00518734
    sub esp, 0x30                                # 00518735
    fstp tbyte ptr [esp + stk_18]                # 00518738
    fstp tbyte ptr [esp]                         # 0051873c
    mov edx, 0x0                                 # 0051873f
    mov eax, dword ptr [esp + stk_6]             # 00518744
    test eax, 0x7fff0000                         # 00518748
    je.d8 L_00518759                             # 0051874d
    # block 0x0051874f: entered by fall-through of je at 0x0051874d, 4 instruction(s), calls FUN_0051852e, ends with ret
    call FUN_0051852e                            # 0051874f
    add esp, 0x30                                # 00518754
    pop edx                                      # 00518757
    ret                                          # 00518758
L_00518759:
    # block 0x00518759: entered by je at 0x0051874d, 5 instruction(s), ends with je to 0x005187e2 (forward)
    fld tbyte ptr [esp]                          # 00518759
    fld tbyte ptr [esp + stk_18]                 # 0051875c
    mov eax, dword ptr [esp]                     # 00518760
    or eax, dword ptr [esp + stk_4]              # 00518763
    je.d8 L_005187e2                             # 00518767
    # block 0x00518769: entered by fall-through of je at 0x00518767, 14 instruction(s), ends with ja to 0x005187b4 (forward)
    fxch st(1)                                   # 00518769
    fstp tbyte ptr [esp + stk_c]                 # 0051876b
    fld tbyte ptr [esp]                          # 0051876f
    fxch st(1)                                   # 00518772
    or edx, 0x2                                  # 00518774
    fnstcw word ptr [esp + stk_24]               # 00518777
    mov eax, dword ptr [esp + stk_24]            # 0051877b
    or eax, 0x33f                                # 0051877f
    mov dword ptr [esp + stk_28], eax            # 00518784
    fldcw word ptr [esp + stk_28]                # 00518788
    mov eax, dword ptr [esp + stk_20]            # 0051878c
    and eax, 0x7fff                              # 00518790
    cmp eax, 0x7fbe                              # 00518795
    ja.d8 L_005187b4                             # 0051879a
    # block 0x0051879c: entered by fall-through of ja at 0x0051879a, 6 instruction(s), ends with forward jump to 0x005187d4
    or edx, 0x1                                  # 0051879c
    fmul qword ptr [0x568d04]                    # 0051879f
    fstp tbyte ptr [esp + stk_18]                # 005187a5
    fmul qword ptr [0x568d04]                    # 005187a9
    fstp tbyte ptr [esp]                         # 005187af
    jmp.d8 L_005187d4                            # 005187b2
L_005187b4:
    # block 0x005187b4: entered by ja at 0x0051879a, 8 instruction(s), falls into the block at 0x005187d4
    fnstcw word ptr [esp + stk_24]               # 005187b4
    mov eax, dword ptr [esp + stk_24]            # 005187b8
    or eax, 0x300                                # 005187bc
    mov dword ptr [esp + stk_28], eax            # 005187c1
    fldcw word ptr [esp + stk_28]                # 005187c5
    fstp st(0)                                   # 005187c9
    fmul qword ptr [0x568d04]                    # 005187cb
    fstp tbyte ptr [esp]                         # 005187d1
L_005187d4:
    # block 0x005187d4: entered by jmp at 0x005187b2, 5 instruction(s), calls FUN_0051852e, ends with ret
    fldcw word ptr [esp + stk_24]                # 005187d4
    call FUN_0051852e                            # 005187d8
    add esp, 0x30                                # 005187dd
    pop edx                                      # 005187e0
    ret                                          # 005187e1
L_005187e2:
    # block 0x005187e2: entered by je at 0x00518767, 4 instruction(s), ends with ret
    fprem                                        # 005187e2
    add esp, 0x30                                # 005187e4
    pop edx                                      # 005187e7
    ret                                          # 005187e8

