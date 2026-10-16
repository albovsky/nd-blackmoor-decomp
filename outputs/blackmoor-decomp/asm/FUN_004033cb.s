# FUN_004033cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004033cb
# extent:       0x004033cb-0x004033db (16 code bytes)
# span:         0x004033cb-0x004033db (code 16, tables 0, padding 0)
# sha256:       c3fbe9accd2b9f616dfe2fe663b56c1ffdea50f8b10ffe1ff1250b30021154e2
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004033cb
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

.org 0x004033cb - 0x401000
.globl FUN_004033cb
FUN_004033cb:
    # block 0x004033cb: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004033cb
    {load} mov ebp, esp                          # 004033cc
    push ecx                                     # 004033ce
    mov dword ptr [ebp - local_4], ecx           # 004033cf
    mov eax, 0x1                                 # 004033d2
    {load} mov esp, ebp                          # 004033d7
    pop ebp                                      # 004033d9
    ret                                          # 004033da

