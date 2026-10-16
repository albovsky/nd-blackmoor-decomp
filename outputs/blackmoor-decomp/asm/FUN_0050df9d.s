# FUN_0050df9d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050df9d
# extent:       0x0050df9d-0x0050e03a (157 code bytes)
# span:         0x0050df9d-0x0050e040 (code 157, tables 0, padding 6)
# sha256:       ff4a32a89ab8ad13be2eb7cce78d554d69e40e372f3d28c121f9638db4d706a4
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050df9d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c
# callees:      calls FUN_00513c35, tail jump FUN_00513ccb, FUN_00513c4c, FUN_00513bd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00513bd7, .text + (0x00513bd7 - 0x401000)
.set FUN_00513c35, .text + (0x00513c35 - 0x401000)
.set FUN_00513c4c, .text + (0x00513c4c - 0x401000)
.set FUN_00513cbe, .text + (0x00513cbe - 0x401000)
.set FUN_00513ccb, .text + (0x00513ccb - 0x401000)

.org 0x0050df9d - 0x401000
.globl FUN_0050df9d
FUN_0050df9d:
    # block 0x0050df9d: entry, 5 instruction(s), ends with je to 0x0050dff9 (forward)
    push edx                                     # 0050df9d
    wait                                         # 0050df9e
    fnstcw word ptr [esp]                        # 0050df9f
    mov eax, dword ptr [esp + stk_c]             # 0050dfa2
    je.d8 L_0050dff9                             # 0050dfa6
    # block 0x0050dfa8: entered by fall-through of je at 0x0050dfa6, 2 instruction(s), ends with je to 0x0050dfb5 (forward)
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 0050dfa8
    je.d8 L_0050dfb5                             # 0050dfae
    # block 0x0050dfb0: entered by fall-through of je at 0x0050dfae, 1 instruction(s), calls FUN_00513c35, falls into the block at 0x0050dfb5
    call FUN_00513c35                            # 0050dfb0
L_0050dfb5:
    # block 0x0050dfb5: entered by je at 0x0050dfae, 2 instruction(s), ends with jne to 0x0050dfdb (forward)
    test eax, 0x80000000                         # 0050dfb5
    jne.d8 L_0050dfdb                            # 0050dfba
    # block 0x0050dfbc: entered by fall-through of jne at 0x0050dfba, 1 instruction(s), falls into the block at 0x0050dfbe
    fsqrt                                        # 0050dfbc
L_0050dfbe:
    # block 0x0050dfbe: entered by jmp at 0x0050dff0; je at 0x0050e00c, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050dfbe
    jne.d32 FUN_00513cbe                         # 0050dfc5
    # block 0x0050dfcb: entered by fall-through of jne at 0x0050dfc5, 3 instruction(s), ends with forward jump to 0x00513ccb
    mov edx, 0x5                                 # 0050dfcb
    lea ecx, [0x567e40]                          # 0050dfd0
    jmp.d32 FUN_00513ccb                         # 0050dfd6
L_0050dfdb:
    # block 0x0050dfdb: entered by jne at 0x0050dfba, 2 instruction(s), ends with jne to 0x0050e00e (forward)
    test eax, 0x7ff00000                         # 0050dfdb
    jne.d8 L_0050e00e                            # 0050dfe0
    # block 0x0050dfe2: entered by fall-through of jne at 0x0050dfe0, 2 instruction(s), ends with jne to 0x0050e00e (forward)
    test eax, 0xfffff                            # 0050dfe2
    jne.d8 L_0050e00e                            # 0050dfe7
    # block 0x0050dfe9: entered by fall-through of jne at 0x0050dfe7, 2 instruction(s), ends with jne to 0x0050e00e (forward)
    cmp dword ptr [esp + stk_8], 0x0             # 0050dfe9
    jne.d8 L_0050e00e                            # 0050dfee
    # block 0x0050dff0: entered by fall-through of jne at 0x0050dfee, 1 instruction(s), ends with backward jump to 0x0050dfbe
    jmp.d8 L_0050dfbe                            # 0050dff0
L_0050dff2:
    # block 0x0050dff2: entered by jne at 0x0050dffe; jne at 0x0050e005, 2 instruction(s), calls FUN_00513c4c, ends with forward jump to 0x0050e01b
    call FUN_00513c4c                            # 0050dff2
    jmp.d8 L_0050e01b                            # 0050dff7
L_0050dff9:
    # block 0x0050dff9: entered by je at 0x0050dfa6, 2 instruction(s), ends with jne to 0x0050dff2 (backward)
    test eax, 0xfffff                            # 0050dff9
    jne.d8 L_0050dff2                            # 0050dffe
    # block 0x0050e000: entered by fall-through of jne at 0x0050dffe, 2 instruction(s), ends with jne to 0x0050dff2 (backward)
    cmp dword ptr [esp + stk_8], 0x0             # 0050e000
    jne.d8 L_0050dff2                            # 0050e005
    # block 0x0050e007: entered by fall-through of jne at 0x0050e005, 2 instruction(s), ends with je to 0x0050dfbe (backward)
    and eax, 0x80000000                          # 0050e007
    je.d8 L_0050dfbe                             # 0050e00c
L_0050e00e:
    # block 0x0050e00e: entered by jne at 0x0050dfe0; jne at 0x0050dfe7; jne at 0x0050dfee; fall-through of je at 0x0050e00c, 3 instruction(s), falls into the block at 0x0050e01b
    fstp st(0)                                   # 0050e00e
    fld tbyte ptr [0x568910]                     # 0050e010
    mov eax, 0x1                                 # 0050e016
L_0050e01b:
    # block 0x0050e01b: entered by jmp at 0x0050dff7, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e01b
    jne.d32 FUN_00513cbe                         # 0050e022
    # block 0x0050e028: entered by fall-through of jne at 0x0050e022, 5 instruction(s), calls FUN_00513bd7, ends with ret
    mov edx, 0x5                                 # 0050e028
    lea ecx, [0x567e40]                          # 0050e02d
    call FUN_00513bd7                            # 0050e033
    pop edx                                      # 0050e038
    ret                                          # 0050e039

# --- data items (not part of the function) -------------------------
.org 0x0050e03a - 0x401000
PAD_0050e03a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

