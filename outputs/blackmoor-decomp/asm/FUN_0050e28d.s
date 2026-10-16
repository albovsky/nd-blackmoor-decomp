# FUN_0050e28d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e28d
# extent:       0x0050e28d-0x0050e30f (130 code bytes)
# span:         0x0050e28d-0x0050e30f (code 130, tables 0, padding 0)
# sha256:       2455dd201194b07df5728bfd0a48d3f610fd7f7d6f65c1878561e8aaf2ee7ee0
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050e28d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls tail jump FUN_00513ccb, FUN_00513c4c, FUN_00513bd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         unreachable_code_entry:0x0050e2eb
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

.org 0x0050e28d - 0x401000
.globl FUN_0050e28d
FUN_0050e28d:
    # block 0x0050e28d: entry, 4 instruction(s), ends with je to 0x0050e2ca (forward)
    push edx                                     # 0050e28d
    wait                                         # 0050e28e
    fnstcw word ptr [esp]                        # 0050e28f
    je.d8 L_0050e2ca                             # 0050e292
    # block 0x0050e294: entered by fall-through of je at 0x0050e292, 2 instruction(s), ends with je to 0x0050e2a2 (forward)
    .insn 0x6681/7, dword ptr [esp], 639{:s16}   # 0050e294
    je.d8 L_0050e2a2                             # 0050e29a
    # block 0x0050e29c: entered by fall-through of je at 0x0050e29a, 1 instruction(s), falls into the block at 0x0050e2a2
    fldcw word ptr [0x530548]                    # 0050e29c
L_0050e2a2:
    # block 0x0050e2a2: entered by je at 0x0050e29a, 2 instruction(s), falls into the block at 0x0050e2a6
    fld1                                         # 0050e2a2
    fpatan                                       # 0050e2a4
L_0050e2a6:
    # block 0x0050e2a6: entered by je at 0x0050e2e5; jmp at 0x0050e2e9, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e2a6
    jne.d32 FUN_00513cbe                         # 0050e2ad
    # block 0x0050e2b3: entered by fall-through of jne at 0x0050e2ad, 3 instruction(s), ends with forward jump to 0x00513ccb
    mov edx, 0xf                                 # 0050e2b3
    lea ecx, [0x567e70]                          # 0050e2b8
    jmp.d32 FUN_00513ccb                         # 0050e2be
L_0050e2c3:
    # block 0x0050e2c3: entered by jne at 0x0050e2cf; jne at 0x0050e2d6, 2 instruction(s), calls FUN_00513c4c, ends with forward jump to 0x0050e2f0
    call FUN_00513c4c                            # 0050e2c3
    jmp.d8 L_0050e2f0                            # 0050e2c8
L_0050e2ca:
    # block 0x0050e2ca: entered by je at 0x0050e292, 2 instruction(s), ends with jne to 0x0050e2c3 (backward)
    test eax, 0xfffff                            # 0050e2ca
    jne.d8 L_0050e2c3                            # 0050e2cf
    # block 0x0050e2d1: entered by fall-through of jne at 0x0050e2cf, 2 instruction(s), ends with jne to 0x0050e2c3 (backward)
    cmp dword ptr [esp + stk_8], 0x0             # 0050e2d1
    jne.d8 L_0050e2c3                            # 0050e2d6
    # block 0x0050e2d8: entered by fall-through of jne at 0x0050e2d6, 4 instruction(s), ends with je to 0x0050e2a6 (backward)
    fstp st(0)                                   # 0050e2d8
    fld tbyte ptr [0x56891a]                     # 0050e2da
    test eax, 0x80000000                         # 0050e2e0
    je.d8 L_0050e2a6                             # 0050e2e5
    # block 0x0050e2e7: entered by fall-through of je at 0x0050e2e5, 2 instruction(s), ends with backward jump to 0x0050e2a6
    fchs                                         # 0050e2e7
    jmp.d8 L_0050e2a6                            # 0050e2e9
    # block 0x0050e2eb: entered by follows jmp at 0x0050e2e9, 1 instruction(s), falls into the block at 0x0050e2f0
    mov eax, 0x1                                 # 0050e2eb
L_0050e2f0:
    # block 0x0050e2f0: entered by jmp at 0x0050e2c8, 2 instruction(s), ends with jne to 0x00513cbe (forward)
    cmp dword ptr [0x63ca04], 0x0                # 0050e2f0
    jne.d32 FUN_00513cbe                         # 0050e2f7
    # block 0x0050e2fd: entered by fall-through of jne at 0x0050e2f7, 5 instruction(s), calls FUN_00513bd7, ends with ret
    mov edx, 0xf                                 # 0050e2fd
    lea ecx, [0x567e70]                          # 0050e302
    call FUN_00513bd7                            # 0050e308
    pop edx                                      # 0050e30d
    ret                                          # 0050e30e

