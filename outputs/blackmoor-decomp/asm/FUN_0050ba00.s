# FUN_0050ba00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ba00
# extent:       0x0050ba00-0x0050ba4c (76 code bytes)
# span:         0x0050ba00-0x0050ba50 (code 76, tables 0, padding 4)
# sha256:       202d42dcff7360f763285e5565d7cc606843bcec361f1f059a3f77705b054c9b
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ba00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c, field_1c, field_20, field_24, field_142, field_146, field_14a, field_152, field_156, field_15a, field_15e and 1 more; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_142, 0x142  # offset +0x142
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_152, 0x152  # offset +0x152
.equ field_156, 0x156  # offset +0x156
.equ field_15a, 0x15a  # offset +0x15a
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162

# --- external targets -----------------------------------------------

.org 0x0050ba00 - 0x401000
.globl FUN_0050ba00
FUN_0050ba00:
    # block 0x0050ba00: entry, 17 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050ba00
    {load} xor ecx, ecx                          # 0050ba04
    mov dword ptr [eax + field_156], ecx         # 0050ba06
    mov dword ptr [eax + field_15e], ecx         # 0050ba0c
    mov dword ptr [eax + field_8], ecx           # 0050ba12
    mov dword ptr [eax + field_c], ecx           # 0050ba15
    mov dword ptr [eax + field_1c], ecx          # 0050ba18
    mov dword ptr [eax + field_20], ecx          # 0050ba1b
    mov dword ptr [eax + field_24], ecx          # 0050ba1e
    mov dword ptr [eax + field_142], ecx         # 0050ba21
    mov dword ptr [eax + field_146], ecx         # 0050ba27
    mov dword ptr [eax + field_14a], ecx         # 0050ba2d
    mov dword ptr [eax + field_152], 0xffffffff  # 0050ba33
    mov dword ptr [eax + field_15a], ecx         # 0050ba3d
    mov dword ptr [eax + field_162], ecx         # 0050ba43
    {load} xor eax, eax                          # 0050ba49
    ret                                          # 0050ba4b

# --- data items (not part of the function) -------------------------
.org 0x0050ba4c - 0x401000
PAD_0050ba4c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

