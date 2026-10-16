# FUN_004017ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004017ce
# extent:       0x004017ce-0x004017eb (29 code bytes)
# span:         0x004017ce-0x004017eb (code 29, tables 0, padding 0)
# sha256:       206097ec91e34e92302996db3f38ca380320429b47475901a547c7d24d3e602d
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004017ce
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

.org 0x004017ce - 0x401000
.globl FUN_004017ce
FUN_004017ce:
    # block 0x004017ce: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 004017ce
    {load} mov ebp, esp                          # 004017cf
    push ecx                                     # 004017d1
    mov dword ptr [ebp - local_4], ecx           # 004017d2
    mov dword ptr [0x569138], 0xb                # 004017d5
    mov ecx, dword ptr [ebp - local_4]           # 004017df
    call FUN_00401526                            # 004017e2
    {load} mov esp, ebp                          # 004017e7
    pop ebp                                      # 004017e9
    ret                                          # 004017ea

