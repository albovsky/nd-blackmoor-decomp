# FUN_004016c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004016c9
# extent:       0x004016c9-0x004016e6 (29 code bytes)
# span:         0x004016c9-0x004016e6 (code 29, tables 0, padding 0)
# sha256:       012284df1129374ea090f7f48d7ea4338e2e13f0a5f69e5bc19800c7e29ca1a2
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004016c9
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

.org 0x004016c9 - 0x401000
.globl FUN_004016c9
FUN_004016c9:
    # block 0x004016c9: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 004016c9
    {load} mov ebp, esp                          # 004016ca
    push ecx                                     # 004016cc
    mov dword ptr [ebp - local_4], ecx           # 004016cd
    mov dword ptr [0x569138], 0x2                # 004016d0
    mov ecx, dword ptr [ebp - local_4]           # 004016da
    call FUN_00401526                            # 004016dd
    {load} mov esp, ebp                          # 004016e2
    pop ebp                                      # 004016e4
    ret                                          # 004016e5

