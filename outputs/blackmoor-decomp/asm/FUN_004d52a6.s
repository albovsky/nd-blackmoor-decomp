# FUN_004d52a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d52a6
# extent:       0x004d52a6-0x004d52b9 (19 code bytes)
# span:         0x004d52a6-0x004d52b9 (code 19, tables 0, padding 0)
# sha256:       2bfd021033b6d5c831de2562768a676c43a9e91f5657abc903f790a5ad46a6b1
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d52a6
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d529b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d529b, .text + (0x004d529b - 0x401000)

.org 0x004d52a6 - 0x401000
.globl FUN_004d52a6
FUN_004d52a6:
    # block 0x004d52a6: entry, 9 instruction(s), calls FUN_004d529b, ends with ret
    push ebp                                     # 004d52a6
    {load} mov ebp, esp                          # 004d52a7
    push ecx                                     # 004d52a9
    mov dword ptr [ebp - local_4], ecx           # 004d52aa
    mov ecx, dword ptr [ebp - local_4]           # 004d52ad
    call FUN_004d529b                            # 004d52b0
    {load} mov esp, ebp                          # 004d52b5
    pop ebp                                      # 004d52b7
    ret                                          # 004d52b8

