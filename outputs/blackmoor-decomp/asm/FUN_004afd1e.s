# FUN_004afd1e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afd1e
# extent:       0x004afd1e-0x004afd3a (28 code bytes)
# span:         0x004afd1e-0x004afd3a (code 28, tables 0, padding 0)
# sha256:       29b43246cc68613e02c7394c3b7f77aea49189506452fcb8d34cce7981f68669
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afd1e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004afd1e - 0x401000
.globl FUN_004afd1e
FUN_004afd1e:
    # block 0x004afd1e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004afd1e
    {load} mov ebp, esp                          # 004afd1f
    push ecx                                     # 004afd21
    mov dword ptr [ebp - local_4], ecx           # 004afd22
    mov eax, dword ptr [ebp - local_4]           # 004afd25
    mov dword ptr [eax], 0x52e010                # 004afd28
    mov ecx, dword ptr [ebp - local_4]           # 004afd2e
    call FUN_0051d730                            # 004afd31
    {load} mov esp, ebp                          # 004afd36
    pop ebp                                      # 004afd38
    ret                                          # 004afd39

