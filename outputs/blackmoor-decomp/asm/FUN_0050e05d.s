# FUN_0050e05d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e05d
# extent:       0x0050e05d-0x0050e0ee (145 code bytes)
# span:         0x0050e05d-0x0050e0f0 (code 145, tables 0, padding 2)
# sha256:       e9e813e0e280f71afbab3cdfbf10497925e8f10c7deee0db7eeb38e2d6db92ad
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e05d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls tail jump FUN_00513ccb, FUN_00513c4c, FUN_00513bd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00513bd7, .text + (0x00513bd7 - 0x401000)
.set FUN_00513c4c, .text + (0x00513c4c - 0x401000)
.set FUN_00513cbe, .text + (0x00513cbe - 0x401000)
.set FUN_00513ccb, .text + (0x00513ccb - 0x401000)

.org 0x0050e05d - 0x401000
.globl FUN_0050e05d
FUN_0050e05d:
    # block 0x0050e05d: entry, 4 instruction(s), ends with je to 0x0050e0b4 (forward)
    push edx                                     # 0050e05d
    wait                                         # 0050e05e
    fnstcw word ptr [esp]                        # 0050e05f
    je.d8 L_0050e0b4                             # 0050e062
    # block 0x0050e064: entered by fall-through of je at 0x0050e062, 2 instruction(s), ends with je to 0x0050e072 (forward)
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 0050e064
    je.d8 L_0050e072                             # 0050e06a
    # block 0x0050e06c: entered by fall-through of je at 0x0050e06a, 1 instruction(s), falls into the block at 0x0050e072
    fldcw word ptr [0x530548]                    # 0050e06c
L_0050e072:
    # block 0x0050e072: entered by je at 0x0050e06a, 5 instruction(s), ends with jp to 0x0050e097 (forward)
    fcos                                         # 0050e072
    wait                                         # 0050e074
    fnstsw ax                                    # 0050e075
    sahf                                         # 0050e077
    jp.d8 L_0050e097                             # 0050e078
L_0050e07a:
    # block 0x0050e07a: entered by jmp at 0x0050e0ab; fall-through of jp at 0x0050e078, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e07a
    jne.d32 FUN_00513cbe                         # 0050e081
    # block 0x0050e087: entered by fall-through of jne at 0x0050e081, 3 instruction(s), ends with forward jump to 0x00513ccb
    mov edx, 0x12                                # 0050e087
    lea ecx, [0x567e50]                          # 0050e08c
    jmp.d32 FUN_00513ccb                         # 0050e092
L_0050e097:
    # block 0x0050e097: entered by jp at 0x0050e078, 2 instruction(s), falls into the block at 0x0050e09f
    fld tbyte ptr [0x53054a]                     # 0050e097
    fxch st(1)                                   # 0050e09d
L_0050e09f:
    # block 0x0050e09f: entered by jp at 0x0050e0a5, 5 instruction(s), ends with jp to 0x0050e09f (backward)
    fprem1                                       # 0050e09f
    wait                                         # 0050e0a1
    fnstsw ax                                    # 0050e0a2
    sahf                                         # 0050e0a4
    jp.d8 L_0050e09f                             # 0050e0a5
    # block 0x0050e0a7: entered by fall-through of jp at 0x0050e0a5, 3 instruction(s), ends with backward jump to 0x0050e07a
    fstp st(1)                                   # 0050e0a7
    fcos                                         # 0050e0a9
    jmp.d8 L_0050e07a                            # 0050e0ab
L_0050e0ad:
    # block 0x0050e0ad: entered by jne at 0x0050e0b9; jne at 0x0050e0c0, 2 instruction(s), calls FUN_00513c4c, ends with forward jump to 0x0050e0cf
    call FUN_00513c4c                            # 0050e0ad
    jmp.d8 L_0050e0cf                            # 0050e0b2
L_0050e0b4:
    # block 0x0050e0b4: entered by je at 0x0050e062, 2 instruction(s), ends with jne to 0x0050e0ad (backward)
    test eax, 0xfffff                            # 0050e0b4
    jne.d8 L_0050e0ad                            # 0050e0b9
    # block 0x0050e0bb: entered by fall-through of jne at 0x0050e0b9, 2 instruction(s), ends with jne to 0x0050e0ad (backward)
    cmp dword ptr [esp + stk_8], 0x0             # 0050e0bb
    jne.d8 L_0050e0ad                            # 0050e0c0
    # block 0x0050e0c2: entered by fall-through of jne at 0x0050e0c0, 3 instruction(s), falls into the block at 0x0050e0cf
    fstp st(0)                                   # 0050e0c2
    fld tbyte ptr [0x568910]                     # 0050e0c4
    mov eax, 0x1                                 # 0050e0ca
L_0050e0cf:
    # block 0x0050e0cf: entered by jmp at 0x0050e0b2, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e0cf
    jne.d32 FUN_00513cbe                         # 0050e0d6
    # block 0x0050e0dc: entered by fall-through of jne at 0x0050e0d6, 5 instruction(s), calls FUN_00513bd7, ends with ret
    mov edx, 0x12                                # 0050e0dc
    lea ecx, [0x567e50]                          # 0050e0e1
    call FUN_00513bd7                            # 0050e0e7
    pop edx                                      # 0050e0ec
    ret                                          # 0050e0ed

# --- data items (not part of the function) -------------------------
.org 0x0050e0ee - 0x401000
PAD_0050e0ee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

