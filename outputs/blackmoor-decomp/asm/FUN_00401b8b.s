# FUN_00401b8b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401b8b
# extent:       0x00401b8b-0x00401ba8 (29 code bytes)
# span:         0x00401b8b-0x00401ba8 (code 29, tables 0, padding 0)
# sha256:       f1bcd478696aadca9948f84dd676340eee3dc1667131d862aebee99d8edd2be0
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401b8b
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

.org 0x00401b8b - 0x401000
.globl FUN_00401b8b
FUN_00401b8b:
    # block 0x00401b8b: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401b8b
    {load} mov ebp, esp                          # 00401b8c
    push ecx                                     # 00401b8e
    mov dword ptr [ebp - local_4], ecx           # 00401b8f
    mov dword ptr [0x569138], 0x2c               # 00401b92
    mov ecx, dword ptr [ebp - local_4]           # 00401b9c
    call FUN_00401526                            # 00401b9f
    {load} mov esp, ebp                          # 00401ba4
    pop ebp                                      # 00401ba6
    ret                                          # 00401ba7

