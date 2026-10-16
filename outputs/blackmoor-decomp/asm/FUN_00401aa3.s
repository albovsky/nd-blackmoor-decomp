# FUN_00401aa3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401aa3
# extent:       0x00401aa3-0x00401ac0 (29 code bytes)
# span:         0x00401aa3-0x00401ac0 (code 29, tables 0, padding 0)
# sha256:       556be3247bd9e35f4552679be6c0a08eab8b383ccf8b0441d4b3ebe7261d45d8
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401aa3
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

.org 0x00401aa3 - 0x401000
.globl FUN_00401aa3
FUN_00401aa3:
    # block 0x00401aa3: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401aa3
    {load} mov ebp, esp                          # 00401aa4
    push ecx                                     # 00401aa6
    mov dword ptr [ebp - local_4], ecx           # 00401aa7
    mov dword ptr [0x569138], 0x24               # 00401aaa
    mov ecx, dword ptr [ebp - local_4]           # 00401ab4
    call FUN_00401526                            # 00401ab7
    {load} mov esp, ebp                          # 00401abc
    pop ebp                                      # 00401abe
    ret                                          # 00401abf

