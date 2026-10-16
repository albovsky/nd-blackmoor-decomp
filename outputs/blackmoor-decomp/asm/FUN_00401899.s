# FUN_00401899
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401899
# extent:       0x00401899-0x004018b6 (29 code bytes)
# span:         0x00401899-0x004018b6 (code 29, tables 0, padding 0)
# sha256:       451caf346a8017ff6b7ada93ad7f55b0c069cab58f361ab5dae7eddf71e8e4a8
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401899
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

.org 0x00401899 - 0x401000
.globl FUN_00401899
FUN_00401899:
    # block 0x00401899: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401899
    {load} mov ebp, esp                          # 0040189a
    push ecx                                     # 0040189c
    mov dword ptr [ebp - local_4], ecx           # 0040189d
    mov dword ptr [0x569138], 0x12               # 004018a0
    mov ecx, dword ptr [ebp - local_4]           # 004018aa
    call FUN_00401526                            # 004018ad
    {load} mov esp, ebp                          # 004018b2
    pop ebp                                      # 004018b4
    ret                                          # 004018b5

