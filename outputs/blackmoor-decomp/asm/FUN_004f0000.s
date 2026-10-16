# FUN_004f0000
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f0000
# extent:       0x004f0000-0x004f001f (31 code bytes)
# span:         0x004f0000-0x004f001f (code 31, tables 0, padding 0)
# sha256:       0e3d7184e67d24fe58fbe9170e3ad823c9e12c4bd0825e2c4471fa4d9c793cfb
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f0000
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004f003b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004f003b, .text + (0x004f003b - 0x401000)

.org 0x004f0000 - 0x401000
.globl FUN_004f0000
FUN_004f0000:
    # block 0x004f0000: entry, 12 instruction(s), calls FUN_004f003b, ends with ret
    push ebp                                     # 004f0000
    {load} mov ebp, esp                          # 004f0001
    push ecx                                     # 004f0003
    mov dword ptr [ebp - local_4], ecx           # 004f0004
    mov eax, dword ptr [ebp - local_4]           # 004f0007
    mov dword ptr [eax], 0x52e504                # 004f000a
    mov ecx, dword ptr [ebp - local_4]           # 004f0010
    call FUN_004f003b                            # 004f0013
    mov eax, dword ptr [ebp - local_4]           # 004f0018
    {load} mov esp, ebp                          # 004f001b
    pop ebp                                      # 004f001d
    ret                                          # 004f001e

