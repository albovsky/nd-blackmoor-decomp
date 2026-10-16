# FUN_004234b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004234b5
# extent:       0x004234b5-0x004234c8 (19 code bytes)
# span:         0x004234b5-0x004234c8 (code 19, tables 0, padding 0)
# sha256:       21ea666fd71394642d63c11277598ace2d5c9d91481677f66c74f9dd98f15e52
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004234b5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0042347b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0042347b, .text + (0x0042347b - 0x401000)

.org 0x004234b5 - 0x401000
.globl FUN_004234b5
FUN_004234b5:
    # block 0x004234b5: entry, 9 instruction(s), calls FUN_0042347b, ends with ret
    push ebp                                     # 004234b5
    {load} mov ebp, esp                          # 004234b6
    push ecx                                     # 004234b8
    mov dword ptr [ebp - local_4], ecx           # 004234b9
    mov ecx, dword ptr [ebp - local_4]           # 004234bc
    call FUN_0042347b                            # 004234bf
    {load} mov esp, ebp                          # 004234c4
    pop ebp                                      # 004234c6
    ret                                          # 004234c7

