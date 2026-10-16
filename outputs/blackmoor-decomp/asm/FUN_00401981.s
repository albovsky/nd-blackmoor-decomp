# FUN_00401981
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401981
# extent:       0x00401981-0x0040199e (29 code bytes)
# span:         0x00401981-0x0040199e (code 29, tables 0, padding 0)
# sha256:       cbb2dbb9c0dde3c3b6962138611d93c7d2e6322ef93a106871a0cd1965ab237d
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401981
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401981 - 0x401000
.globl FUN_00401981
FUN_00401981:
    # block 0x00401981: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401981
    {load} mov ebp, esp                          # 00401982
    push ecx                                     # 00401984
    mov dword ptr [ebp - local_4], ecx           # 00401985
    mov dword ptr [0x569138], 0x1a               # 00401988
    mov ecx, dword ptr [ebp - local_4]           # 00401992
    call FUN_00401526                            # 00401995
    {load} mov esp, ebp                          # 0040199a
    pop ebp                                      # 0040199c
    ret                                          # 0040199d

