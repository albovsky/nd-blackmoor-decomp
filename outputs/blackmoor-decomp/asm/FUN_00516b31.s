# FUN_00516b31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516b31
# extent:       0x00516b31-0x00516b3d (12 code bytes)
# span:         0x00516b31-0x00516b3d (code 12, tables 0, padding 0)
# sha256:       97388562160565ecacd99fd7cfb5a79db607bd4efed7b038160299350288888d
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516b31
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00516b31 - 0x401000
.globl FUN_00516b31
FUN_00516b31:
    # block 0x00516b31: entry, 8 instruction(s), ends with ret
    push edi                                     # 00516b31
    mov edi, dword ptr [esp + stk_8]             # 00516b32
    {load} xor eax, eax                          # 00516b36
    stosd dword ptr es:[edi], eax                # 00516b38
    stosd dword ptr es:[edi], eax                # 00516b39
    stosd dword ptr es:[edi], eax                # 00516b3a
    pop edi                                      # 00516b3b
    ret                                          # 00516b3c

