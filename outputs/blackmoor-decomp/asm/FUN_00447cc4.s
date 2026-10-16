# FUN_00447cc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447cc4
# extent:       0x00447cc4-0x00447cd4 (16 code bytes)
# span:         0x00447cc4-0x00447ce0 (code 16, tables 0, padding 12)
# sha256:       7c2ff5dd875fddb7d4fd437473f4b1ebaf351477c80b2d39c656359a7bbb7a0a
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447cc4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00447cc4 - 0x401000
.globl FUN_00447cc4
FUN_00447cc4:
    # block 0x00447cc4: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00447cc4
    {load} mov ebp, esp                          # 00447cc5
    push ecx                                     # 00447cc7
    mov dword ptr [ebp - local_4], ecx           # 00447cc8
    mov eax, 0x52ca38                            # 00447ccb
    {load} mov esp, ebp                          # 00447cd0
    pop ebp                                      # 00447cd2
    ret                                          # 00447cd3

# --- data items (not part of the function) -------------------------
.org 0x00447cd4 - 0x401000
PAD_00447cd4:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

