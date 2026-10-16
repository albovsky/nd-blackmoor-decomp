# FUN_0050b150
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b150
# extent:       0x0050b150-0x0050b15d (13 code bytes)
# span:         0x0050b150-0x0050b160 (code 13, tables 0, padding 3)
# sha256:       38c1c8aff745d3a99455b59ccb9930e94ea41687b6db353804fb6fe04ea4b6d6
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b150
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

.org 0x0050b150 - 0x401000
.globl FUN_0050b150
FUN_0050b150:
    # block 0x0050b150: entry, 5 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b150
    mov ecx, dword ptr [eax]                     # 0050b154
    mov al, byte ptr [ecx + field_5]             # 0050b156
    and eax, 0x1                                 # 0050b159
    ret                                          # 0050b15c

# --- data items (not part of the function) -------------------------
.org 0x0050b15d - 0x401000
PAD_0050b15d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

