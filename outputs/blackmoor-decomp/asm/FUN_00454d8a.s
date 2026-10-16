# FUN_00454d8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454d8a
# extent:       0x00454d8a-0x00454d9e (20 code bytes)
# span:         0x00454d8a-0x00454d9e (code 20, tables 0, padding 0)
# sha256:       29c8aecdd3ab39880b1433f7cd9efaa14a7505165dcab9b8250655d302edf1a3
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454d8a
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

.org 0x00454d8a - 0x401000
.globl FUN_00454d8a
FUN_00454d8a:
    # block 0x00454d8a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00454d8a
    {load} mov ebp, esp                          # 00454d8b
    push ecx                                     # 00454d8d
    mov dword ptr [ebp - local_4], ecx           # 00454d8e
    mov word ptr [0x5a0541], 0x0                 # 00454d91
    {load} mov esp, ebp                          # 00454d9a
    pop ebp                                      # 00454d9c
    ret                                          # 00454d9d

