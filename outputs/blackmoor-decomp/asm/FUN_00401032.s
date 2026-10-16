# FUN_00401032
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401032
# extent:       0x00401032-0x0040104e (28 code bytes)
# span:         0x00401032-0x0040104e (code 28, tables 0, padding 0)
# sha256:       727d0aa66792eb4d77030b7175a1de2bc3994f24146c5121f188d389e606c041
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401032
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00521756
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00521756, .text + (0x00521756 - 0x401000)

.org 0x00401032 - 0x401000
.globl FUN_00401032
FUN_00401032:
    # block 0x00401032: entry, 11 instruction(s), calls FUN_00521756, ends with ret
    push ebp                                     # 00401032
    {load} mov ebp, esp                          # 00401033
    push ecx                                     # 00401035
    mov dword ptr [ebp - local_4], ecx           # 00401036
    mov eax, dword ptr [ebp - local_4]           # 00401039
    mov dword ptr [eax], 0x52a5d0                # 0040103c
    mov ecx, dword ptr [ebp - local_4]           # 00401042
    call FUN_00521756                            # 00401045
    {load} mov esp, ebp                          # 0040104a
    pop ebp                                      # 0040104c
    ret                                          # 0040104d

