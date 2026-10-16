# FUN_004ee5b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee5b8
# extent:       0x004ee5b8-0x004ee5cd (21 code bytes)
# span:         0x004ee5b8-0x004ee5cd (code 21, tables 0, padding 0)
# sha256:       a960a8755eae7f3d4db32efb50ca0acfbce596555132708c90ba2cc1141ea50c
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee5b8
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004ee5b8 - 0x401000
.globl FUN_004ee5b8
FUN_004ee5b8:
    # block 0x004ee5b8: entry, 9 instruction(s), ends with ret 0x4
    push ebp                                     # 004ee5b8
    {load} mov ebp, esp                          # 004ee5b9
    push ecx                                     # 004ee5bb
    mov dword ptr [ebp - local_4], ecx           # 004ee5bc
    mov eax, dword ptr [ebp + arg_8]             # 004ee5bf
    mov dword ptr [0x55cd94], eax                # 004ee5c2
    {load} mov esp, ebp                          # 004ee5c7
    pop ebp                                      # 004ee5c9
    ret 0x4                                      # 004ee5ca

