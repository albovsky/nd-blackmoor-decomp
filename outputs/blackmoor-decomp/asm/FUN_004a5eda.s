# FUN_004a5eda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a5eda
# extent:       0x004a5eda-0x004a5eea (16 code bytes)
# span:         0x004a5eda-0x004a5eea (code 16, tables 0, padding 0)
# sha256:       c21051883e4e9d5622dbd2d5515acbe5138f0a55f359221e1c7d6a1c2bc3ca09
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a5eda
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a5eda - 0x401000
.globl FUN_004a5eda
FUN_004a5eda:
    # block 0x004a5eda: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a5eda
    {load} mov ebp, esp                          # 004a5edb
    push ecx                                     # 004a5edd
    mov dword ptr [ebp - local_4], ecx           # 004a5ede
    mov eax, 0x52dcc0                            # 004a5ee1
    {load} mov esp, ebp                          # 004a5ee6
    pop ebp                                      # 004a5ee8
    ret                                          # 004a5ee9

