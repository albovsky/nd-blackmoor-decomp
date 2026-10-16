# FUN_004ee602
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee602
# extent:       0x004ee602-0x004ee616 (20 code bytes)
# span:         0x004ee602-0x004ee616 (code 20, tables 0, padding 0)
# sha256:       ba150710a55335a9f99429b1932f928976ae58cc973e39d1aa7dbb11d53f9b6e
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee602
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4af
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4af, 0x4af  # offset +0x4af

# --- external targets -----------------------------------------------

.org 0x004ee602 - 0x401000
.globl FUN_004ee602
FUN_004ee602:
    # block 0x004ee602: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004ee602
    {load} mov ebp, esp                          # 004ee603
    push ecx                                     # 004ee605
    mov dword ptr [ebp - local_4], ecx           # 004ee606
    mov eax, dword ptr [ebp - local_4]           # 004ee609
    mov eax, dword ptr [eax + field_4af]         # 004ee60c
    {load} mov esp, ebp                          # 004ee612
    pop ebp                                      # 004ee614
    ret                                          # 004ee615

