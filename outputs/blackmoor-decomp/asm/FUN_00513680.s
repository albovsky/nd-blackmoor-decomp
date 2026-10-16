# FUN_00513680
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513680
# extent:       0x00513680-0x005136af (47 code bytes)
# span:         0x00513680-0x005136af (code 47, tables 0, padding 0)
# sha256:       d1714211c5508dd5fe8480daa653fcb2fbbb482d3f2d29b7ed9222e7161aa5e1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x13a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513680
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_90, field_minus_9f, field_minus_a0
# callees:      calls tail jump LOC_00513af6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005136af
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_90, 0x90  # offset -0x90
.equ field_minus_9f, 0x9f  # offset -0x9f
.equ field_minus_a0, 0xa0  # offset -0xa0

# --- external targets -----------------------------------------------
.set LOC_00513af6, .text + (0x00513af6 - 0x401000)

.org 0x00513680 - 0x401000
.globl FUN_00513680
FUN_00513680:
    # block 0x00513680: entry, 7 instruction(s), ends with jne to 0x005136a3 (forward)
    pop eax                                      # 00513680
    ftst                                         # 00513681
    wait                                         # 00513683
    fnstsw word ptr [ebp - field_minus_a0]       # 00513684
    wait                                         # 0051368a
    test byte ptr [ebp - field_minus_9f], 0x1    # 0051368b
    jne.d8 L_005136a3                            # 00513692
    # block 0x00513694: entered by fall-through of jne at 0x00513692, 4 instruction(s), ends with je to 0x005136a2 (forward)
    fstp st(0)                                   # 00513694
    fld tbyte ptr [0x5688b0]                     # 00513696
    {load} or ch, ch                             # 0051369c
    je.d8 L_005136a2                             # 0051369e
    # block 0x005136a0: entered by fall-through of je at 0x0051369e, 1 instruction(s), falls into the block at 0x005136a2
    fchs                                         # 005136a0
L_005136a2:
    # block 0x005136a2: entered by je at 0x0051369e, 1 instruction(s), ends with ret
    ret                                          # 005136a2
L_005136a3:
    # block 0x005136a3: entered by jne at 0x00513692, 2 instruction(s), ends with forward jump to 0x00513af6
    mov byte ptr [ebp - field_minus_90], 0x4     # 005136a3
    jmp.d32 LOC_00513af6                         # 005136aa

