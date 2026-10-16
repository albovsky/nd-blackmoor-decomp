# FUN_00487bcc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487bcc
# extent:       0x00487bcc-0x00487bd7 (11 code bytes)
# span:         0x00487bcc-0x00487bd7 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00487bcc
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00487bcc - 0x401000
.globl FUN_00487bcc
FUN_00487bcc:
    # block 0x00487bcc: entry, 7 instruction(s), ends with ret
    push ebp                                     # 00487bcc
    {load} mov ebp, esp                          # 00487bcd
    push ecx                                     # 00487bcf
    mov dword ptr [ebp - local_4], ecx           # 00487bd0
    {load} mov esp, ebp                          # 00487bd3
    pop ebp                                      # 00487bd5
    ret                                          # 00487bd6

