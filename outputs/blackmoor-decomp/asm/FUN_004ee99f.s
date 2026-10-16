# FUN_004ee99f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee99f
# extent:       0x004ee99f-0x004ee9bb (28 code bytes)
# span:         0x004ee99f-0x004ee9bb (code 28, tables 0, padding 0)
# sha256:       33b569a01abc7bfdd43548eb0229c170df8512cdcf5e96d048c5376af46c96bf
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee99f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eead0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004eead0, .text + (0x004eead0 - 0x401000)

.org 0x004ee99f - 0x401000
.globl FUN_004ee99f
FUN_004ee99f:
    # block 0x004ee99f: entry, 11 instruction(s), calls FUN_004eead0, ends with ret
    push ebp                                     # 004ee99f
    {load} mov ebp, esp                          # 004ee9a0
    push ecx                                     # 004ee9a2
    mov dword ptr [ebp - local_4], ecx           # 004ee9a3
    mov eax, dword ptr [ebp - local_4]           # 004ee9a6
    mov dword ptr [eax], 0x52e500                # 004ee9a9
    mov ecx, dword ptr [ebp - local_4]           # 004ee9af
    call FUN_004eead0                            # 004ee9b2
    {load} mov esp, ebp                          # 004ee9b7
    pop ebp                                      # 004ee9b9
    ret                                          # 004ee9ba

