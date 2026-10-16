# FUN_00511895
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511895
# extent:       0x00511895-0x005118a5 (16 code bytes)
# span:         0x00511895-0x005118a5 (code 16, tables 0, padding 0)
# sha256:       c0dff18e6194a628974f879b3b458f2c32143e8e460e9f471bbd1d5a2b5e299f
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511895
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_minus_4, field_minus_8; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00511895 - 0x401000
.globl FUN_00511895
FUN_00511895:
    # block 0x00511895: entry, 6 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00511895
    add dword ptr [eax], 0x8                     # 00511899
    mov ecx, dword ptr [eax]                     # 0051189c
    mov eax, dword ptr [ecx - field_minus_8]     # 0051189e
    mov edx, dword ptr [ecx - field_minus_4]     # 005118a1
    ret                                          # 005118a4

