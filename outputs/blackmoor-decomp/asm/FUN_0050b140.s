# FUN_0050b140
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b140
# extent:       0x0050b140-0x0050b14c (12 code bytes)
# span:         0x0050b140-0x0050b150 (code 12, tables 0, padding 4)
# sha256:       aceb2708a261addf883d3781a785895e592f893518fd7f5f189815c01f661cfa
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b140
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0050b140 - 0x401000
.globl FUN_0050b140
FUN_0050b140:
    # block 0x0050b140: entry, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b140
    mov ecx, dword ptr [eax]                     # 0050b144
    {load} xor eax, eax                          # 0050b146
    mov al, byte ptr [ecx + field_4]             # 0050b148
    ret                                          # 0050b14b

# --- data items (not part of the function) -------------------------
.org 0x0050b14c - 0x401000
PAD_0050b14c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

