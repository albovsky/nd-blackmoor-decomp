# FUN_0050f72d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f72d
# extent:       0x0050f72d-0x0050f7db (174 code bytes)
# span:         0x0050f72d-0x0050f7e0 (code 174, tables 0, padding 5)
# sha256:       77970ef64ad461a1e2ab5740d780589cebda74fbe5984cfcbe1f97f13c944f1b
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f72d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c
# callees:      calls FUN_00513c35, tail jump FUN_00513ccb, FUN_00513c4c, FUN_00513bd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0050f72d - 0x401000
.globl FUN_0050f72d
FUN_0050f72d:
    # block 0x0050f72d: entry, 4 instruction(s), ends with je to 0x0050f7a1 (forward)
    push edx                                     # 0050f72d
    wait                                         # 0050f72e
    fnstcw word ptr [esp]                        # 0050f72f
    je.d8 L_0050f7a1                             # 0050f732
    # block 0x0050f734: entered by fall-through of je at 0x0050f732, 2 instruction(s), ends with je to 0x0050f741 (forward)
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 0050f734
    je.d8 L_0050f741                             # 0050f73a
    # block 0x0050f73c: entered by fall-through of je at 0x0050f73a, 1 instruction(s), calls FUN_00513c35, falls into the block at 0x0050f741
    call FUN_00513c35                            # 0050f73c
L_0050f741:
    # block 0x0050f741: entered by je at 0x0050f73a, 2 instruction(s), ends with jae to 0x0050f775 (forward)
    cmp eax, 0x3ff00000                          # 0050f741
    jae.d8 L_0050f775                            # 0050f746
    # block 0x0050f748: entered by fall-through of jae at 0x0050f746, 8 instruction(s), falls into the block at 0x0050f758
    fld1                                         # 0050f748
    fadd st, st(1)                               # 0050f74a
    fld1                                         # 0050f74c
    fsub st, st(2)                               # 0050f74e
    fmulp st(1), st                              # 0050f750
    fsqrt                                        # 0050f752
    fxch st(1)                                   # 0050f754
    fpatan                                       # 0050f756
L_0050f758:
    # block 0x0050f758: entered by jmp at 0x0050f794; jmp at 0x0050f798, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050f758
    jne.d32 FUN_00513cbe                         # 0050f75f
    # block 0x0050f765: entered by fall-through of jne at 0x0050f75f, 3 instruction(s), ends with forward jump to 0x00513ccb
    mov edx, 0xd                                 # 0050f765
    lea ecx, [0x568000]                          # 0050f76a
    jmp.d32 FUN_00513ccb                         # 0050f770
L_0050f775:
    # block 0x0050f775: entered by jae at 0x0050f746, 1 instruction(s), ends with ja to 0x0050f7af (forward)
    ja.d8 L_0050f7af                             # 0050f775
    # block 0x0050f777: entered by fall-through of ja at 0x0050f775, 5 instruction(s), ends with jne to 0x0050f7af (forward)
    mov eax, dword ptr [esp + stk_c]             # 0050f777
    {load} mov ecx, eax                          # 0050f77b
    and eax, 0xfffff                             # 0050f77d
    or eax, dword ptr [esp + stk_8]              # 0050f782
    jne.d8 L_0050f7af                            # 0050f786
    # block 0x0050f788: entered by fall-through of jne at 0x0050f786, 3 instruction(s), ends with je to 0x0050f796 (forward)
    and ecx, 0x80000000                          # 0050f788
    fstp st(0)                                   # 0050f78e
    je.d8 L_0050f796                             # 0050f790
    # block 0x0050f792: entered by fall-through of je at 0x0050f790, 2 instruction(s), ends with backward jump to 0x0050f758
    fldpi                                        # 0050f792
    jmp.d8 L_0050f758                            # 0050f794
L_0050f796:
    # block 0x0050f796: entered by je at 0x0050f790, 2 instruction(s), ends with backward jump to 0x0050f758
    fldz                                         # 0050f796
    jmp.d8 L_0050f758                            # 0050f798
L_0050f79a:
    # block 0x0050f79a: entered by jne at 0x0050f7a6; jne at 0x0050f7ad, 2 instruction(s), calls FUN_00513c4c, ends with forward jump to 0x0050f7bc
    call FUN_00513c4c                            # 0050f79a
    jmp.d8 L_0050f7bc                            # 0050f79f
L_0050f7a1:
    # block 0x0050f7a1: entered by je at 0x0050f732, 2 instruction(s), ends with jne to 0x0050f79a (backward)
    test eax, 0xfffff                            # 0050f7a1
    jne.d8 L_0050f79a                            # 0050f7a6
    # block 0x0050f7a8: entered by fall-through of jne at 0x0050f7a6, 2 instruction(s), ends with jne to 0x0050f79a (backward)
    cmp dword ptr [esp + stk_8], 0x0             # 0050f7a8
    jne.d8 L_0050f79a                            # 0050f7ad
L_0050f7af:
    # block 0x0050f7af: entered by ja at 0x0050f775; jne at 0x0050f786; fall-through of jne at 0x0050f7ad, 3 instruction(s), falls into the block at 0x0050f7bc
    fstp st(0)                                   # 0050f7af
    fld tbyte ptr [0x568910]                     # 0050f7b1
    mov eax, 0x1                                 # 0050f7b7
L_0050f7bc:
    # block 0x0050f7bc: entered by jmp at 0x0050f79f, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050f7bc
    jne.d32 FUN_00513cbe                         # 0050f7c3
    # block 0x0050f7c9: entered by fall-through of jne at 0x0050f7c3, 5 instruction(s), calls FUN_00513bd7, ends with ret
    mov edx, 0xd                                 # 0050f7c9
    lea ecx, [0x568000]                          # 0050f7ce
    call FUN_00513bd7                            # 0050f7d4
    pop edx                                      # 0050f7d9
    ret                                          # 0050f7da

# --- data items (not part of the function) -------------------------
.org 0x0050f7db - 0x401000
PAD_0050f7db:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

