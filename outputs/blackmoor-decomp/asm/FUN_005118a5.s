# FUN_005118a5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005118a5
# extent:       0x005118a5-0x005118b3 (14 code bytes)
# span:         0x005118a5-0x005118b3 (code 14, tables 0, padding 0)
# sha256:       5f671d8a996ed9b6b5d29f932ff7a60ca5b1d02836de479b9c8f08e4575cb74a
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005118a5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x005118a5 - 0x401000
.globl FUN_005118a5
FUN_005118a5:
    # block 0x005118a5: entry, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 005118a5
    add dword ptr [eax], 0x4                     # 005118a9
    mov eax, dword ptr [eax]                     # 005118ac
    mov ax, word ptr [eax - field_minus_4]       # 005118ae
    ret                                          # 005118b2

