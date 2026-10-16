# FUN_004010c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004010c0
# extent:       0x004010c0-0x004010d5 (21 code bytes)
# span:         0x004010c0-0x004010d5 (code 21, tables 0, padding 0)
# sha256:       205f33584c9fd8164287360abf9ffa908aab761b5f9628cd8426cd8ea78472fe
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004010c0
# arguments:    no [ebp+n] stack argument slot referenced; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x004010c0 - 0x401000
.globl FUN_004010c0
FUN_004010c0:
    # block 0x004010c0: entry, 9 instruction(s), calls FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 004010c0
    {load} mov ebp, esp                          # 004010c1
    push ecx                                     # 004010c3
    mov dword ptr [ebp - local_4], ecx           # 004010c4
    mov ecx, dword ptr [ebp - local_4]           # 004010c7
    call FUN_0051ab4b                            # 004010ca
    {load} mov esp, ebp                          # 004010cf
    pop ebp                                      # 004010d1
    ret 0xc                                      # 004010d2

