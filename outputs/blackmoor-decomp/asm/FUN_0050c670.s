# FUN_0050c670
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c670
# extent:       0x0050c670-0x0050c677 (7 code bytes)
# span:         0x0050c670-0x0050c677 (code 7, tables 0, padding 0)
# sha256:       ccbf196d9aacc84670c54b300822f455a21100f68e6b748f305d03175df37b65
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c670
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050c670 - 0x401000
.globl FUN_0050c670
FUN_0050c670:
    # block 0x0050c670: entry, 4 instruction(s), ends with indirect jump eax
    pop eax                                      # 0050c670
    pop ecx                                      # 0050c671
    xchg dword ptr [esp], eax                    # 0050c672
    jmp eax                                      # 0050c675

