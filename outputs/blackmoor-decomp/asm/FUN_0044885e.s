# FUN_0044885e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044885e
# extent:       0x0044885e-0x00448871 (19 code bytes)
# span:         0x0044885e-0x00448871 (code 19, tables 0, padding 0)
# sha256:       2bfd021033b6d5c831de2562768a676c43a9e91f5657abc903f790a5ad46a6b1
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044885e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00448853
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00448853, .text + (0x00448853 - 0x401000)

.org 0x0044885e - 0x401000
.globl FUN_0044885e
FUN_0044885e:
    # block 0x0044885e: entry, 9 instruction(s), calls FUN_00448853, ends with ret
    push ebp                                     # 0044885e
    {load} mov ebp, esp                          # 0044885f
    push ecx                                     # 00448861
    mov dword ptr [ebp - local_4], ecx           # 00448862
    mov ecx, dword ptr [ebp - local_4]           # 00448865
    call FUN_00448853                            # 00448868
    {load} mov esp, ebp                          # 0044886d
    pop ebp                                      # 0044886f
    ret                                          # 00448870

