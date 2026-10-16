# FUN_004f0046
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f0046
# extent:       0x004f0046-0x004f0059 (19 code bytes)
# span:         0x004f0046-0x004f0059 (code 19, tables 0, padding 0)
# sha256:       2bfd021033b6d5c831de2562768a676c43a9e91f5657abc903f790a5ad46a6b1
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f0046
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004f003b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004f003b, .text + (0x004f003b - 0x401000)

.org 0x004f0046 - 0x401000
.globl FUN_004f0046
FUN_004f0046:
    # block 0x004f0046: entry, 9 instruction(s), calls FUN_004f003b, ends with ret
    push ebp                                     # 004f0046
    {load} mov ebp, esp                          # 004f0047
    push ecx                                     # 004f0049
    mov dword ptr [ebp - local_4], ecx           # 004f004a
    mov ecx, dword ptr [ebp - local_4]           # 004f004d
    call FUN_004f003b                            # 004f0050
    {load} mov esp, ebp                          # 004f0055
    pop ebp                                      # 004f0057
    ret                                          # 004f0058

