# FUN_0043eb2a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eb2a
# extent:       0x0043eb2a-0x0043eb3a (16 code bytes)
# span:         0x0043eb2a-0x0043eb3a (code 16, tables 0, padding 0)
# sha256:       d1a367fb63af8aa68efbb99156eddd0388c4421894c1850430d7fcd41f498f04
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043eb2a
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

.org 0x0043eb2a - 0x401000
.globl FUN_0043eb2a
FUN_0043eb2a:
    # block 0x0043eb2a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0043eb2a
    {load} mov ebp, esp                          # 0043eb2b
    push ecx                                     # 0043eb2d
    mov dword ptr [ebp - local_4], ecx           # 0043eb2e
    mov eax, 0x52c7d8                            # 0043eb31
    {load} mov esp, ebp                          # 0043eb36
    pop ebp                                      # 0043eb38
    ret                                          # 0043eb39

