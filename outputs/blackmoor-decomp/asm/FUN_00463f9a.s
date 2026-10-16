# FUN_00463f9a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463f9a
# extent:       0x00463f9a-0x00463faa (16 code bytes)
# span:         0x00463f9a-0x00463faa (code 16, tables 0, padding 0)
# sha256:       7b8c3c1aefe393b66e6bdea937326df6f6bbd23db10b50efd384eefda3e8e022
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00463f9a
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

.org 0x00463f9a - 0x401000
.globl FUN_00463f9a
FUN_00463f9a:
    # block 0x00463f9a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00463f9a
    {load} mov ebp, esp                          # 00463f9b
    push ecx                                     # 00463f9d
    mov dword ptr [ebp - local_4], ecx           # 00463f9e
    mov eax, 0x52d0d0                            # 00463fa1
    {load} mov esp, ebp                          # 00463fa6
    pop ebp                                      # 00463fa8
    ret                                          # 00463fa9

