# FUN_00472a4c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472a4c
# extent:       0x00472a4c-0x00472a5c (16 code bytes)
# span:         0x00472a4c-0x00472a5c (code 16, tables 0, padding 0)
# sha256:       6d6510ba8d6139bef6715d69a9eeb9cffc1946ead7a4fbe84799df7c1f0ffc2f
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00472a4c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00472a4c - 0x401000
.globl FUN_00472a4c
FUN_00472a4c:
    # block 0x00472a4c: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00472a4c
    {load} mov ebp, esp                          # 00472a4d
    push ecx                                     # 00472a4f
    mov dword ptr [ebp - local_4], ecx           # 00472a50
    mov eax, 0x52d3d8                            # 00472a53
    {load} mov esp, ebp                          # 00472a58
    pop ebp                                      # 00472a5a
    ret                                          # 00472a5b

