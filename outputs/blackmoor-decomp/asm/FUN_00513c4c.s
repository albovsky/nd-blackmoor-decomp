# FUN_00513c4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513c4c
# extent:       0x00513c4c-0x00513c65 (25 code bytes)
# span:         0x00513c4c-0x00513c65 (code 25, tables 0, padding 0)
# sha256:       f616c842e0610d03ced8b683fd4e87feb84c726f5d7f8ff8accf5657368dfefd
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513c4c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00513c4c - 0x401000
.globl FUN_00513c4c
FUN_00513c4c:
    # block 0x00513c4c: entry, 2 instruction(s), ends with je to 0x00513c59 (forward)
    test eax, 0x80000                            # 00513c4c
    je.d8 L_00513c59                             # 00513c51
    # block 0x00513c53: entered by fall-through of je at 0x00513c51, 2 instruction(s), ends with ret
    mov eax, 0x7                                 # 00513c53
    ret                                          # 00513c58
L_00513c59:
    # block 0x00513c59: entered by je at 0x00513c51, 3 instruction(s), ends with ret
    fadd qword ptr [0x530540]                    # 00513c59
    mov eax, 0x1                                 # 00513c5f
    ret                                          # 00513c64

