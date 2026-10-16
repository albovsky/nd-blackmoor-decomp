# FUN_00513711
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513711
# extent:       0x00513711-0x00513745 (52 code bytes)
# span:         0x00513711-0x00513745 (code 52, tables 0, padding 0)
# sha256:       3c83d67ad932cc2c9c910f2899a3c81dfeae37e5d9db6a5dea08179cce7a8241
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x1cb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513711
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00513745
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00513711 - 0x401000
.globl FUN_00513711
FUN_00513711:
    # block 0x00513711: entry, 7 instruction(s), ends with jne to 0x00513737 (forward)
    fld st(0)                                    # 00513711
    frndint                                      # 00513713
    fcomp st(1)                                  # 00513715
    wait                                         # 00513717
    fnstsw ax                                    # 00513718
    sahf                                         # 0051371a
    jne.d8 L_00513737                            # 0051371b
    # block 0x0051371d: entered by fall-through of jne at 0x0051371b, 9 instruction(s), ends with je to 0x0051373e (forward)
    fld st(0)                                    # 0051371d
    fmul qword ptr [0x5688e2]                    # 0051371f
    fld st(0)                                    # 00513725
    frndint                                      # 00513727
    fcompp                                       # 00513729
    wait                                         # 0051372b
    fnstsw ax                                    # 0051372c
    sahf                                         # 0051372e
    je.d8 L_0051373e                             # 0051372f
    # block 0x00513731: entered by fall-through of je at 0x0051372f, 1 instruction(s), falls into the block at 0x00513736
    mov eax, 0x1                                 # 00513731
L_00513736:
    # block 0x00513736: entered by jmp at 0x0051373c; jmp at 0x00513743, 1 instruction(s), ends with ret
    ret                                          # 00513736
L_00513737:
    # block 0x00513737: entered by jne at 0x0051371b, 2 instruction(s), ends with backward jump to 0x00513736
    mov eax, 0x0                                 # 00513737
    jmp.d8 L_00513736                            # 0051373c
L_0051373e:
    # block 0x0051373e: entered by je at 0x0051372f, 2 instruction(s), ends with backward jump to 0x00513736
    mov eax, 0x2                                 # 0051373e
    jmp.d8 L_00513736                            # 00513743

