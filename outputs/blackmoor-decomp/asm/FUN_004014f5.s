# FUN_004014f5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004014f5
# extent:       0x004014f5-0x00401511 (28 code bytes)
# span:         0x004014f5-0x00401511 (code 28, tables 0, padding 0)
# sha256:       2f2b1c4f271003933f8e07a65458161443a77cded98b414f4010b07a1823d08c
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004014f5
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

.org 0x004014f5 - 0x401000
.globl FUN_004014f5
FUN_004014f5:
    # block 0x004014f5: entry, 11 instruction(s), calls FUN_005218ea, ends with ret
    push ebp                                     # 004014f5
    {load} mov ebp, esp                          # 004014f6
    push ecx                                     # 004014f8
    mov dword ptr [ebp - local_4], ecx           # 004014f9
    mov eax, dword ptr [ebp - local_4]           # 004014fc
    mov dword ptr [eax], 0x52ab70                # 004014ff
    mov ecx, dword ptr [ebp - local_4]           # 00401505
    call FUN_005218ea                            # 00401508
    {load} mov esp, ebp                          # 0040150d
    pop ebp                                      # 0040150f
    ret                                          # 00401510

