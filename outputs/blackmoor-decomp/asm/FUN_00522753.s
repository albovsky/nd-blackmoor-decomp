# FUN_00522753
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522753
# extent:       0x00522753-0x00522776 (35 code bytes)
# span:         0x00522753-0x00522776 (code 35, tables 0, padding 0)
# sha256:       b352295e89e0b9deebd007326ba7f1c84ad388a84029eb213c9cdd20a5f7f3e6
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005226e2 (+0x71)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522753
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00522776
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00522753 - 0x401000
.globl FUN_00522753
FUN_00522753:
    # block 0x00522753: entry, 1 instruction(s), ends with forward jump to 0x00522758
    jmp.d32 L_00522758                           # 00522753
L_00522758:
    # block 0x00522758: entered by jmp at 0x00522753, 6 instruction(s), ends with ret
    and dword ptr [0x63c438], 0x0                # 00522758
    and dword ptr [0x63c43c], 0x0                # 0052275f
    mov eax, 0x80000000                          # 00522766
    mov dword ptr [0x63c430], eax                # 0052276b
    mov dword ptr [0x63c434], eax                # 00522770
    ret                                          # 00522775

