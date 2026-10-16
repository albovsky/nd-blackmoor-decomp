# FUN_0043772f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043772f
# extent:       0x0043772f-0x00437743 (20 code bytes)
# span:         0x0043772f-0x00437743 (code 20, tables 0, padding 0)
# sha256:       4ceae2f1aff4b982d2c09d958b024d6abcfe051a273c4a6315a37d80b037a14f
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043772f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0043772f - 0x401000
.globl FUN_0043772f
FUN_0043772f:
    # block 0x0043772f: entry, 9 instruction(s), ends with ret
    push ebp                                     # 0043772f
    {load} mov ebp, esp                          # 00437730
    push ecx                                     # 00437732
    mov dword ptr [ebp - local_4], ecx           # 00437733
    mov eax, dword ptr [ebp - local_4]           # 00437736
    mov dword ptr [eax], 0x52c7bc                # 00437739
    {load} mov esp, ebp                          # 0043773f
    pop ebp                                      # 00437741
    ret                                          # 00437742

