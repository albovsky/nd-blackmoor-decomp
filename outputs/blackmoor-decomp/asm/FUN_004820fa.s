# FUN_004820fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004820fa
# extent:       0x004820fa-0x0048210a (16 code bytes)
# span:         0x004820fa-0x0048210a (code 16, tables 0, padding 0)
# sha256:       0f3575663e8936e13df1386d0c83584a1587457c8ce7b5ca2ca7020839915c18
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004820fa
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

.org 0x004820fa - 0x401000
.globl FUN_004820fa
FUN_004820fa:
    # block 0x004820fa: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004820fa
    {load} mov ebp, esp                          # 004820fb
    push ecx                                     # 004820fd
    mov dword ptr [ebp - local_4], ecx           # 004820fe
    mov eax, 0x52d680                            # 00482101
    {load} mov esp, ebp                          # 00482106
    pop ebp                                      # 00482108
    ret                                          # 00482109

