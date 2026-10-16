# FUN_00517a70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00517a70
# extent:       0x00517a70-0x00517b87 (279 code bytes)
# span:         0x00517a70-0x00517b87 (code 279, tables 0, padding 0)
# sha256:       7ea7f014db95f49de1726a2a00132c76354d0638afa44bc9a30b71bc8afc97e5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0x2d4)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00517a70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c, stk_10, stk_14, stk_18, stk_1c, stk_20
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 83 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00517b87
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x00517a70 - 0x401000
.globl FUN_00517a70
FUN_00517a70:
    # block 0x00517a70: entry, 2 instruction(s), falls into the block at 0x00517a78
    fld tbyte ptr [esp + stk_10]                 # 00517a70
    fld tbyte ptr [esp + stk_4]                  # 00517a74
L_00517a78:
    # block 0x00517a78: entered by jmp at 0x00517b7b, 3 instruction(s), ends with jae to 0x00517b0a (forward)
    mov eax, dword ptr [esp + stk_8]             # 00517a78
    {load} add eax, eax                          # 00517a7c
    jae.d32 L_00517b0a                           # 00517a7e
    # block 0x00517a84: entered by fall-through of jae at 0x00517a7e, 3 instruction(s), ends with je to 0x00517a93 (forward)
    xor eax, 0xe000000                           # 00517a84
    test eax, 0xe000000                          # 00517a89
    je.d8 L_00517a93                             # 00517a8e
    # block 0x00517a90: entered by fall-through of je at 0x00517a8e, 2 instruction(s), ends with ret
    fdivp st(1), st                              # 00517a90
    ret                                          # 00517a92
L_00517a93:
    # block 0x00517a93: entered by je at 0x00517a8e, 3 instruction(s), ends with jne to 0x00517aa2 (forward)
    shr eax, 0x1c                                # 00517a93
    cmp byte ptr [eax + 0x568cd0], 0x0           # 00517a96
    jne.d8 L_00517aa2                            # 00517a9d
    # block 0x00517a9f: entered by fall-through of jne at 0x00517a9d, 2 instruction(s), ends with ret
    fdivp st(1), st                              # 00517a9f
    ret                                          # 00517aa1
L_00517aa2:
    # block 0x00517aa2: entered by jne at 0x00517a9d, 3 instruction(s), ends with je to 0x00517b14 (forward)
    mov eax, dword ptr [esp + stk_c]             # 00517aa2
    and eax, 0x7fff                              # 00517aa6
    je.d8 L_00517b14                             # 00517aab
    # block 0x00517aad: entered by fall-through of je at 0x00517aab, 2 instruction(s), ends with je to 0x00517b14 (forward)
    cmp eax, 0x7fff                              # 00517aad
    je.d8 L_00517b14                             # 00517ab2
    # block 0x00517ab4: entered by fall-through of je at 0x00517ab2, 10 instruction(s), ends with je to 0x00517af3 (forward)
    fnstcw word ptr [esp + stk_1c]               # 00517ab4
    mov eax, dword ptr [esp + stk_1c]            # 00517ab8
    or eax, 0x33f                                # 00517abc
    and eax, 0xf3ff                              # 00517ac1
    mov dword ptr [esp + stk_20], eax            # 00517ac6
    fldcw word ptr [esp + stk_20]                # 00517aca
    mov eax, dword ptr [esp + stk_18]            # 00517ace
    and eax, 0x7fff                              # 00517ad2
    cmp eax, 0x1                                 # 00517ad7
    je.d8 L_00517af3                             # 00517ada
    # block 0x00517adc: entered by fall-through of je at 0x00517ada, 7 instruction(s), ends with ret
    fmul dword ptr [0x568ce0]                    # 00517adc
    fxch st(1)                                   # 00517ae2
    fmul dword ptr [0x568ce0]                    # 00517ae4
    fxch st(1)                                   # 00517aea
    fldcw word ptr [esp + stk_1c]                # 00517aec
    fdivp st(1), st                              # 00517af0
    ret                                          # 00517af2
L_00517af3:
    # block 0x00517af3: entered by je at 0x00517ada, 7 instruction(s), ends with ret
    fmul dword ptr [0x568ce4]                    # 00517af3
    fxch st(1)                                   # 00517af9
    fmul dword ptr [0x568ce4]                    # 00517afb
    fxch st(1)                                   # 00517b01
    fldcw word ptr [esp + stk_1c]                # 00517b03
    fdivp st(1), st                              # 00517b07
    ret                                          # 00517b09
L_00517b0a:
    # block 0x00517b0a: entered by jae at 0x00517a7e, 3 instruction(s), ends with jne to 0x00517b17 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00517b0a
    or eax, dword ptr [esp + stk_8]              # 00517b0e
    jne.d8 L_00517b17                            # 00517b12
L_00517b14:
    # block 0x00517b14: entered by je at 0x00517aab; je at 0x00517ab2; jne at 0x00517b20; fall-through of jne at 0x00517b12, 2 instruction(s), ends with ret
    fdivp st(1), st                              # 00517b14
    ret                                          # 00517b16
L_00517b17:
    # block 0x00517b17: entered by jne at 0x00517b12, 3 instruction(s), ends with jne to 0x00517b14 (backward)
    mov eax, dword ptr [esp + stk_c]             # 00517b17
    and eax, 0x7fff                              # 00517b1b
    jne.d8 L_00517b14                            # 00517b20
    # block 0x00517b22: entered by fall-through of jne at 0x00517b20, 9 instruction(s), ends with je to 0x00517b58 (forward)
    fnstcw word ptr [esp + stk_1c]               # 00517b22
    mov eax, dword ptr [esp + stk_1c]            # 00517b26
    or eax, 0x33f                                # 00517b2a
    and eax, 0xf3ff                              # 00517b2f
    mov dword ptr [esp + stk_20], eax            # 00517b34
    fldcw word ptr [esp + stk_20]                # 00517b38
    mov eax, dword ptr [esp + stk_18]            # 00517b3c
    and eax, 0x7fff                              # 00517b40
    je.d8 L_00517b58                             # 00517b45
    # block 0x00517b47: entered by fall-through of je at 0x00517b45, 2 instruction(s), ends with je to 0x00517b80 (forward)
    cmp eax, 0x7fff                              # 00517b47
    je.d8 L_00517b80                             # 00517b4c
    # block 0x00517b4e: entered by fall-through of je at 0x00517b4c, 3 instruction(s), ends with jae to 0x00517b80 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00517b4e
    {load} add eax, eax                          # 00517b52
    jae.d8 L_00517b80                            # 00517b54
    # block 0x00517b56: entered by fall-through of jae at 0x00517b54, 1 instruction(s), ends with forward jump to 0x00517b60
    jmp.d8 L_00517b60                            # 00517b56
L_00517b58:
    # block 0x00517b58: entered by je at 0x00517b45, 3 instruction(s), ends with jb to 0x00517b80 (forward)
    mov eax, dword ptr [esp + stk_14]            # 00517b58
    {load} add eax, eax                          # 00517b5c
    jb.d8 L_00517b80                             # 00517b5e
L_00517b60:
    # block 0x00517b60: entered by jmp at 0x00517b56; fall-through of jb at 0x00517b5e, 10 instruction(s), ends with backward jump to 0x00517a78
    fxch st(1)                                   # 00517b60
    fstp st(0)                                   # 00517b62
    fld st(0)                                    # 00517b64
    fmul dword ptr [0x568ce8]                    # 00517b66
    fstp tbyte ptr [esp + stk_4]                 # 00517b6c
    fld tbyte ptr [esp + stk_10]                 # 00517b70
    fxch st(1)                                   # 00517b74
    wait                                         # 00517b76
    fldcw word ptr [esp + stk_1c]                # 00517b77
    jmp.d32 L_00517a78                           # 00517b7b
L_00517b80:
    # block 0x00517b80: entered by je at 0x00517b4c; jae at 0x00517b54; jb at 0x00517b5e, 3 instruction(s), ends with ret
    fldcw word ptr [esp + stk_1c]                # 00517b80
    fdivp st(1), st                              # 00517b84
    ret                                          # 00517b86

