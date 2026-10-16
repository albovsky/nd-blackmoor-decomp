# FUN_00401a86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401a86
# extent:       0x00401a86-0x00401aa3 (29 code bytes)
# span:         0x00401a86-0x00401aa3 (code 29, tables 0, padding 0)
# sha256:       6c424110843fdc54d77e33b764c6743ba2fbaaeba174910379b22e5790eebbcd
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401a86
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

.org 0x00401a86 - 0x401000
.globl FUN_00401a86
FUN_00401a86:
    # block 0x00401a86: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401a86
    {load} mov ebp, esp                          # 00401a87
    push ecx                                     # 00401a89
    mov dword ptr [ebp - local_4], ecx           # 00401a8a
    mov dword ptr [0x569138], 0x23               # 00401a8d
    mov ecx, dword ptr [ebp - local_4]           # 00401a97
    call FUN_00401526                            # 00401a9a
    {load} mov esp, ebp                          # 00401a9f
    pop ebp                                      # 00401aa1
    ret                                          # 00401aa2

