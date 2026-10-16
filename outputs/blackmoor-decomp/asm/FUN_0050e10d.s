# FUN_0050e10d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e10d
# extent:       0x0050e10d-0x0050e19e (145 code bytes)
# span:         0x0050e10d-0x0050e19e (code 145, tables 0, padding 0)
# sha256:       c75caa23be5fc5f7b670d5e78816274736ea8f22e0ce99c360db9c35aebee39b
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e10d
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

.org 0x0050e10d - 0x401000
.globl FUN_0050e10d
FUN_0050e10d:
    # block 0x0050e10d: entry, 4 instruction(s), ends with je to 0x0050e164 (forward)
    push edx                                     # 0050e10d
    wait                                         # 0050e10e
    fnstcw word ptr [esp]                        # 0050e10f
    je.d8 L_0050e164                             # 0050e112
    # block 0x0050e114: entered by fall-through of je at 0x0050e112, 2 instruction(s), ends with je to 0x0050e122 (forward)
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 0050e114
    je.d8 L_0050e122                             # 0050e11a
    # block 0x0050e11c: entered by fall-through of je at 0x0050e11a, 1 instruction(s), falls into the block at 0x0050e122
    fldcw word ptr [0x530548]                    # 0050e11c
L_0050e122:
    # block 0x0050e122: entered by je at 0x0050e11a, 5 instruction(s), ends with jp to 0x0050e147 (forward)
    fsin                                         # 0050e122
    wait                                         # 0050e124
    fnstsw ax                                    # 0050e125
    sahf                                         # 0050e127
    jp.d8 L_0050e147                             # 0050e128
L_0050e12a:
    # block 0x0050e12a: entered by jmp at 0x0050e15b; fall-through of jp at 0x0050e128, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e12a
    jne.d32 FUN_00513cbe                         # 0050e131
    # block 0x0050e137: entered by fall-through of jne at 0x0050e131, 3 instruction(s), ends with forward jump to 0x00513ccb
    mov edx, 0x1e                                # 0050e137
    lea ecx, [0x567e60]                          # 0050e13c
    jmp.d32 FUN_00513ccb                         # 0050e142
L_0050e147:
    # block 0x0050e147: entered by jp at 0x0050e128, 2 instruction(s), falls into the block at 0x0050e14f
    fld tbyte ptr [0x53054a]                     # 0050e147
    fxch st(1)                                   # 0050e14d
L_0050e14f:
    # block 0x0050e14f: entered by jp at 0x0050e155, 5 instruction(s), ends with jp to 0x0050e14f (backward)
    fprem1                                       # 0050e14f
    wait                                         # 0050e151
    fnstsw ax                                    # 0050e152
    sahf                                         # 0050e154
    jp.d8 L_0050e14f                             # 0050e155
    # block 0x0050e157: entered by fall-through of jp at 0x0050e155, 3 instruction(s), ends with backward jump to 0x0050e12a
    fstp st(1)                                   # 0050e157
    fsin                                         # 0050e159
    jmp.d8 L_0050e12a                            # 0050e15b
L_0050e15d:
    # block 0x0050e15d: entered by jne at 0x0050e169; jne at 0x0050e170, 2 instruction(s), calls FUN_00513c4c, ends with forward jump to 0x0050e17f
    call FUN_00513c4c                            # 0050e15d
    jmp.d8 L_0050e17f                            # 0050e162
L_0050e164:
    # block 0x0050e164: entered by je at 0x0050e112, 2 instruction(s), ends with jne to 0x0050e15d (backward)
    test eax, 0xfffff                            # 0050e164
    jne.d8 L_0050e15d                            # 0050e169
    # block 0x0050e16b: entered by fall-through of jne at 0x0050e169, 2 instruction(s), ends with jne to 0x0050e15d (backward)
    cmp dword ptr [esp + stk_8], 0x0             # 0050e16b
    jne.d8 L_0050e15d                            # 0050e170
    # block 0x0050e172: entered by fall-through of jne at 0x0050e170, 3 instruction(s), falls into the block at 0x0050e17f
    fstp st(0)                                   # 0050e172
    fld tbyte ptr [0x568910]                     # 0050e174
    mov eax, 0x1                                 # 0050e17a
L_0050e17f:
    # block 0x0050e17f: entered by jmp at 0x0050e162, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e17f
    jne.d32 FUN_00513cbe                         # 0050e186
    # block 0x0050e18c: entered by fall-through of jne at 0x0050e186, 5 instruction(s), calls FUN_00513bd7, ends with ret
    mov edx, 0x1e                                # 0050e18c
    lea ecx, [0x567e60]                          # 0050e191
    call FUN_00513bd7                            # 0050e197
    pop edx                                      # 0050e19c
    ret                                          # 0050e19d

