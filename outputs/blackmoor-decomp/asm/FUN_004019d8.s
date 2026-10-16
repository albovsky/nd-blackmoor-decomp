# FUN_004019d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004019d8
# extent:       0x004019d8-0x004019f5 (29 code bytes)
# span:         0x004019d8-0x004019f5 (code 29, tables 0, padding 0)
# sha256:       a591035419065c263728c606beffd7944e786157fd873859e1fc41e32d1177b3
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004019d8
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

.org 0x004019d8 - 0x401000
.globl FUN_004019d8
FUN_004019d8:
    # block 0x004019d8: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 004019d8
    {load} mov ebp, esp                          # 004019d9
    push ecx                                     # 004019db
    mov dword ptr [ebp - local_4], ecx           # 004019dc
    mov dword ptr [0x569138], 0x1d               # 004019df
    mov ecx, dword ptr [ebp - local_4]           # 004019e9
    call FUN_00401526                            # 004019ec
    {load} mov esp, ebp                          # 004019f1
    pop ebp                                      # 004019f3
    ret                                          # 004019f4

