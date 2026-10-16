# FUN_00401720
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401720
# extent:       0x00401720-0x0040173d (29 code bytes)
# span:         0x00401720-0x0040173d (code 29, tables 0, padding 0)
# sha256:       9026331f4b60b2dfa8cf120a5db45ee9a0c7f4e23cc6dc619390e3e13dc5754a
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401720
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

.org 0x00401720 - 0x401000
.globl FUN_00401720
FUN_00401720:
    # block 0x00401720: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401720
    {load} mov ebp, esp                          # 00401721
    push ecx                                     # 00401723
    mov dword ptr [ebp - local_4], ecx           # 00401724
    mov dword ptr [0x569138], 0x5                # 00401727
    mov ecx, dword ptr [ebp - local_4]           # 00401731
    call FUN_00401526                            # 00401734
    {load} mov esp, ebp                          # 00401739
    pop ebp                                      # 0040173b
    ret                                          # 0040173c

