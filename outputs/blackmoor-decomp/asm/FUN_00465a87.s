# FUN_00465a87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465a87
# extent:       0x00465a87-0x00465a97 (16 code bytes)
# span:         0x00465a87-0x00465a97 (code 16, tables 0, padding 0)
# sha256:       86e705312ebfb7139b2a33252cd84c4c6ae5d57414e88c519fd07f01f18bb673
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00465a87
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

.org 0x00465a87 - 0x401000
.globl FUN_00465a87
FUN_00465a87:
    # block 0x00465a87: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00465a87
    {load} mov ebp, esp                          # 00465a88
    push ecx                                     # 00465a8a
    mov dword ptr [ebp - local_4], ecx           # 00465a8b
    mov eax, 0x52d158                            # 00465a8e
    {load} mov esp, ebp                          # 00465a93
    pop ebp                                      # 00465a95
    ret                                          # 00465a96

