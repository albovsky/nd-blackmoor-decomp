# FUN_00511888
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511888
# extent:       0x00511888-0x00511895 (13 code bytes)
# span:         0x00511888-0x00511895 (code 13, tables 0, padding 0)
# sha256:       639148f2f162bda27c1f66ab90d68794bac59a533c7cbf65580a2c6853ef771f
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511888
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00511888 - 0x401000
.globl FUN_00511888
FUN_00511888:
    # block 0x00511888: entry, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00511888
    add dword ptr [eax], 0x4                     # 0051188c
    mov eax, dword ptr [eax]                     # 0051188f
    mov eax, dword ptr [eax - field_minus_4]     # 00511891
    ret                                          # 00511894

