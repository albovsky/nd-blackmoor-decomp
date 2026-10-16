# FUN_00512bef
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00512bef
# extent:       0x00512bef-0x00512c18 (41 code bytes)
# span:         0x00512bef-0x00512c18 (code 41, tables 0, padding 0)
# sha256:       02c06f5b673d9dfc969facf2d93f6135e31d72b911682c50c3418983f07329a3
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00512bef
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none direct; 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00512bef - 0x401000
.globl FUN_00512bef
FUN_00512bef:
    # block 0x00512bef: entry, 12 instruction(s), calls indirect esi, ends with ret
    push esi                                     # 00512bef
    mov esi, dword ptr [0x52a0b4]                # 00512bf0
    push dword ptr [0x5686f4]                    # 00512bf6
    call esi                                     # 00512bfc
    push dword ptr [0x5686e4]                    # 00512bfe
    call esi                                     # 00512c04
    push dword ptr [0x5686d4]                    # 00512c06
    call esi                                     # 00512c0c
    push dword ptr [0x5686b4]                    # 00512c0e
    call esi                                     # 00512c14
    pop esi                                      # 00512c16
    ret                                          # 00512c17

