# FUN_00510dc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510dc0
# extent:       0x00510dc0-0x00510dd3 (19 code bytes)
# span:         0x00510dc0-0x00510dd3 (code 19, tables 0, padding 0)
# sha256:       62c6da82d07ea4aa99511abb78901a02943ff579a4fb01cd5ba88db0c3971f86
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510dc0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_50; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------

.org 0x00510dc0 - 0x401000
.globl FUN_00510dc0
FUN_00510dc0:
    # block 0x00510dc0: entry, 4 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00510dc0
    mov dword ptr [eax + field_50], 0x568a58     # 00510dc4
    mov dword ptr [eax + field_14], 0x1          # 00510dcb
    ret                                          # 00510dd2

