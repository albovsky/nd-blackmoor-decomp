# FUN_005136ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005136ce
# extent:       0x005136ce-0x00513711 (67 code bytes)
# span:         0x005136ce-0x00513711 (code 67, tables 0, padding 0)
# sha256:       3037783a49f9e1286cfff374f4f50db6636b59c5c21a66dbd9c383a0ddaf1a92
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x188)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005136ce
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_9f, field_minus_a0
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513711
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_9f, 0x9f  # offset -0x9f
.equ field_minus_a0, 0xa0  # offset -0xa0

# --- external targets -----------------------------------------------
.set FUN_00513680, .text + (0x00513680 - 0x401000)

.org 0x005136ce - 0x401000
.globl FUN_005136ce
FUN_005136ce:
    # block 0x005136ce: entry, 9 instruction(s), ends with jne to 0x00513680 (backward)
    fld st(0)                                    # 005136ce
    fabs                                         # 005136d0
    fld tbyte ptr [0x5688ce]                     # 005136d2
    fcompp                                       # 005136d8
    wait                                         # 005136da
    fnstsw word ptr [ebp - field_minus_a0]       # 005136db
    wait                                         # 005136e1
    test byte ptr [ebp - field_minus_9f], 0x41   # 005136e2
    jne.d8 . + (-105)  # -> FUN_00513680         # 005136e9
    # block 0x005136eb: entered by fall-through of jne at 0x005136e9, 15 instruction(s), ends with ret
    fld st(0)                                    # 005136eb
    frndint                                      # 005136ed
    ftst                                         # 005136ef
    wait                                         # 005136f1
    fnstsw word ptr [ebp - field_minus_a0]       # 005136f2
    wait                                         # 005136f8
    mov dl, byte ptr [ebp - field_minus_9f]      # 005136f9
    fxch st(1)                                   # 005136ff
    fsub st, st(1)                               # 00513701
    ftst                                         # 00513703
    wait                                         # 00513705
    fnstsw word ptr [ebp - field_minus_a0]       # 00513706
    fabs                                         # 0051370c
    f2xm1                                        # 0051370e
    ret                                          # 00513710

