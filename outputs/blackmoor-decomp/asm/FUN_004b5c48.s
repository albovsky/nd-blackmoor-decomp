# FUN_004b5c48
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5c48
# extent:       0x004b5c48-0x004b5c5c (20 code bytes)
# span:         0x004b5c48-0x004b5c5c (code 20, tables 0, padding 0)
# sha256:       e684c2e9c49f2af6e327fa0d8c360e870d5a95e9c1b16d38c2d285848dbe6643
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b5c48
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

.org 0x004b5c48 - 0x401000
.globl FUN_004b5c48
FUN_004b5c48:
    # block 0x004b5c48: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004b5c48
    {load} mov ebp, esp                          # 004b5c49
    push ecx                                     # 004b5c4b
    mov dword ptr [ebp - local_4], ecx           # 004b5c4c
    mov word ptr [0x594db1], 0x0                 # 004b5c4f
    {load} mov esp, ebp                          # 004b5c58
    pop ebp                                      # 004b5c5a
    ret                                          # 004b5c5b

