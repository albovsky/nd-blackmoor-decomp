# FUN_00404b19
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404b19
# extent:       0x00404b19-0x00404b39 (32 code bytes)
# span:         0x00404b19-0x00404b39 (code 32, tables 0, padding 0)
# sha256:       5f31ffe6beac7ef3d27693fa09dedf4c2f9cfe54b05249374f6ad290398a1f88
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00404b19
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00521b22, FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)
.set FUN_00521b22, .text + (0x00521b22 - 0x401000)

.org 0x00404b19 - 0x401000
.globl FUN_00404b19
FUN_00404b19:
    # block 0x00404b19: entry, 12 instruction(s), calls FUN_00521b22, FUN_00404be1, ends with ret
    push ebp                                     # 00404b19
    {load} mov ebp, esp                          # 00404b1a
    push ecx                                     # 00404b1c
    mov dword ptr [ebp - local_4], ecx           # 00404b1d
    mov ecx, dword ptr [ebp - local_4]           # 00404b20
    call FUN_00521b22                            # 00404b23
    mov ecx, dword ptr [ebp - local_4]           # 00404b28
    call FUN_00404be1                            # 00404b2b
    mov eax, 0x1                                 # 00404b30
    {load} mov esp, ebp                          # 00404b35
    pop ebp                                      # 00404b37
    ret                                          # 00404b38

