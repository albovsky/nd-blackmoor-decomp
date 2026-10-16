# FUN_00513ca8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513ca8
# extent:       0x00513ca8-0x00513cbe (22 code bytes)
# span:         0x00513ca8-0x00513cbe (code 22, tables 0, padding 0)
# sha256:       4adcaaeddff7fc3980a56d0f0bd062f443e97ac27181910e7fc475851b93b5d9
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513ca8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00513ca8 - 0x401000
.globl FUN_00513ca8
FUN_00513ca8:
    # block 0x00513ca8: entry, 4 instruction(s), ends with je to 0x00513cb9 (forward)
    mov eax, dword ptr [esp + stk_8]             # 00513ca8
    and eax, 0x7ff00000                          # 00513cac
    cmp eax, 0x7ff00000                          # 00513cb1
    je.d8 L_00513cb9                             # 00513cb6
    # block 0x00513cb8: entered by fall-through of je at 0x00513cb6, 1 instruction(s), ends with ret
    ret                                          # 00513cb8
L_00513cb9:
    # block 0x00513cb9: entered by je at 0x00513cb6, 2 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_8]             # 00513cb9
    ret                                          # 00513cbd

