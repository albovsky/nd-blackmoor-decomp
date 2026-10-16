# FUN_004e76d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e76d5
# extent:       0x004e76d5-0x004e76ed (24 code bytes)
# span:         0x004e76d5-0x004e76ed (code 24, tables 0, padding 0)
# sha256:       c2600154031e55686220c64de538925d1cbbc2139a8213ebb247bdb2f43d44f8
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e76d5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------

.org 0x004e76d5 - 0x401000
.globl FUN_004e76d5
FUN_004e76d5:
    # block 0x004e76d5: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e76d5
    {load} mov ebp, esp                          # 004e76d6
    push ecx                                     # 004e76d8
    mov dword ptr [ebp - local_4], ecx           # 004e76d9
    mov eax, dword ptr [ebp - local_4]           # 004e76dc
    mov dword ptr [eax + field_991], 0x0         # 004e76df
    {load} mov esp, ebp                          # 004e76e9
    pop ebp                                      # 004e76eb
    ret                                          # 004e76ec

