# FUN_0050ba70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ba70
# extent:       0x0050ba70-0x0050ba85 (21 code bytes)
# span:         0x0050ba70-0x0050ba90 (code 21, tables 0, padding 11)
# sha256:       1d89112015ad4cd4f87a93e47c8891321b5760a073e6674309e2e017b81b3cc0
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ba70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      calls FUN_0050ba90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ba90, .text + (0x0050ba90 - 0x401000)

.org 0x0050ba70 - 0x401000
.globl FUN_0050ba70
FUN_0050ba70:
    # block 0x0050ba70: entry, 8 instruction(s), calls FUN_0050ba90, ends with ret
    mov eax, dword ptr [esp + stk_8]             # 0050ba70
    mov ecx, dword ptr [esp + stk_4]             # 0050ba74
    push 0x1                                     # 0050ba78
    push eax                                     # 0050ba7a
    push ecx                                     # 0050ba7b
    call FUN_0050ba90                            # 0050ba7c
    add esp, 0xc                                 # 0050ba81
    ret                                          # 0050ba84

# --- data items (not part of the function) -------------------------
.org 0x0050ba85 - 0x401000
PAD_0050ba85:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

