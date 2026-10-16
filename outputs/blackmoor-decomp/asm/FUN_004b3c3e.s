# FUN_004b3c3e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3c3e
# extent:       0x004b3c3e-0x004b3c5a (28 code bytes)
# span:         0x004b3c3e-0x004b3c5a (code 28, tables 0, padding 0)
# sha256:       0e7c3e664db0b1da981814e65c03716a1878338a88528d01d4e1f81912dccab2
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b3c3e
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

.org 0x004b3c3e - 0x401000
.globl FUN_004b3c3e
FUN_004b3c3e:
    # block 0x004b3c3e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004b3c3e
    {load} mov ebp, esp                          # 004b3c3f
    push ecx                                     # 004b3c41
    mov dword ptr [ebp - local_4], ecx           # 004b3c42
    mov eax, dword ptr [ebp - local_4]           # 004b3c45
    mov dword ptr [eax], 0x52e098                # 004b3c48
    mov ecx, dword ptr [ebp - local_4]           # 004b3c4e
    call FUN_0051d730                            # 004b3c51
    {load} mov esp, ebp                          # 004b3c56
    pop ebp                                      # 004b3c58
    ret                                          # 004b3c59

