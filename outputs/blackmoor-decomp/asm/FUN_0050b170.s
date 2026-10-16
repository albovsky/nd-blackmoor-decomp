# FUN_0050b170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b170
# extent:       0x0050b170-0x0050b17d (13 code bytes)
# span:         0x0050b170-0x0050b180 (code 13, tables 0, padding 3)
# sha256:       489d2cc21093f0cf5cdebd00e346221515555b58f0ea0f26bbdadcd3f455936f
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b170
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_5; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_5, 0x5  # offset +0x5

# --- external targets -----------------------------------------------

.org 0x0050b170 - 0x401000
.globl FUN_0050b170
FUN_0050b170:
    # block 0x0050b170: entry, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b170
    mov ecx, dword ptr [eax]                     # 0050b174
    mov al, byte ptr [ecx + field_5]             # 0050b176
    and eax, 0x4                                 # 0050b179
    ret                                          # 0050b17c

# --- data items (not part of the function) -------------------------
.org 0x0050b17d - 0x401000
PAD_0050b17d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

