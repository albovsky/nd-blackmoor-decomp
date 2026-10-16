# FUN_00404af0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404af0
# extent:       0x00404af0-0x00404b0c (28 code bytes)
# span:         0x00404af0-0x00404b0c (code 28, tables 0, padding 0)
# sha256:       5ee0bf5f417894bfe1c8b1d28a7d2d7fa731c70e0b22c5a423bd87db3241d210
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00404af0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005218ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00404af0 - 0x401000
.globl FUN_00404af0
FUN_00404af0:
    # block 0x00404af0: entry, 11 instruction(s), calls FUN_005218ea, ends with ret
    push ebp                                     # 00404af0
    {load} mov ebp, esp                          # 00404af1
    push ecx                                     # 00404af3
    mov dword ptr [ebp - local_4], ecx           # 00404af4
    mov eax, dword ptr [ebp - local_4]           # 00404af7
    mov dword ptr [eax], 0x52ba38                # 00404afa
    mov ecx, dword ptr [ebp - local_4]           # 00404b00
    call FUN_005218ea                            # 00404b03
    {load} mov esp, ebp                          # 00404b08
    pop ebp                                      # 00404b0a
    ret                                          # 00404b0b

