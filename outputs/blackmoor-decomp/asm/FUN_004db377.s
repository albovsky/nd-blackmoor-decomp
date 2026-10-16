# FUN_004db377
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db377
# extent:       0x004db377-0x004db38a (19 code bytes)
# span:         0x004db377-0x004db38a (code 19, tables 0, padding 0)
# sha256:       683012209919012cc2f5ca01c25884efe145827fce4e08a8e6f9cf3cc8c01931
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db377
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db29b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004db29b, .text + (0x004db29b - 0x401000)

.org 0x004db377 - 0x401000
.globl FUN_004db377
FUN_004db377:
    # block 0x004db377: entry, 9 instruction(s), calls FUN_004db29b, ends with ret
    push ebp                                     # 004db377
    {load} mov ebp, esp                          # 004db378
    push ecx                                     # 004db37a
    mov dword ptr [ebp - local_4], ecx           # 004db37b
    mov ecx, dword ptr [ebp - local_4]           # 004db37e
    call FUN_004db29b                            # 004db381
    {load} mov esp, ebp                          # 004db386
    pop ebp                                      # 004db388
    ret                                          # 004db389

