# FUN_0043ef00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ef00
# extent:       0x0043ef00-0x0043ef10 (16 code bytes)
# span:         0x0043ef00-0x0043ef10 (code 16, tables 0, padding 0)
# sha256:       8edf86b97213e6c00c808a0a289fc81b7504823ab64fc8623e08a7832f7d80fc
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043ef00
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

.org 0x0043ef00 - 0x401000
.globl FUN_0043ef00
FUN_0043ef00:
    # block 0x0043ef00: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0043ef00
    {load} mov ebp, esp                          # 0043ef01
    push ecx                                     # 0043ef03
    mov dword ptr [ebp - local_4], ecx           # 0043ef04
    mov eax, 0x52c9f8                            # 0043ef07
    {load} mov esp, ebp                          # 0043ef0c
    pop ebp                                      # 0043ef0e
    ret                                          # 0043ef0f

