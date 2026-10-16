# FUN_004ee69e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee69e
# extent:       0x004ee69e-0x004ee6c7 (41 code bytes)
# span:         0x004ee69e-0x004ee6c7 (code 41, tables 0, padding 0)
# sha256:       7c9511b3156daf3837dc3a783867b87177457cf68cd55b62727fd095c8551641
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee69e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_252
# callees:      calls FUN_004ef516
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_252, 0x252  # offset +0x252

# --- external targets -----------------------------------------------
.set FUN_004ef516, .text + (0x004ef516 - 0x401000)

.org 0x004ee69e - 0x401000
.globl FUN_004ee69e
FUN_004ee69e:
    # block 0x004ee69e: entry, 7 instruction(s), ends with je to 0x004ee6c1 (forward)
    push ebp                                     # 004ee69e
    {load} mov ebp, esp                          # 004ee69f
    push ecx                                     # 004ee6a1
    mov dword ptr [ebp - local_4], ecx           # 004ee6a2
    mov eax, dword ptr [ebp - local_4]           # 004ee6a5
    cmp dword ptr [eax + field_252], 0x0         # 004ee6a8
    je.d8 L_004ee6c1                             # 004ee6af
    # block 0x004ee6b1: entered by fall-through of je at 0x004ee6af, 4 instruction(s), calls FUN_004ef516, ends with forward jump to 0x004ee6c3
    mov ecx, dword ptr [ebp - local_4]           # 004ee6b1
    add ecx, 0x4b7                               # 004ee6b4
    call FUN_004ef516                            # 004ee6ba
    jmp.d8 L_004ee6c3                            # 004ee6bf
L_004ee6c1:
    # block 0x004ee6c1: entered by je at 0x004ee6af, 1 instruction(s), falls into the block at 0x004ee6c3
    {load} xor eax, eax                          # 004ee6c1
L_004ee6c3:
    # block 0x004ee6c3: entered by jmp at 0x004ee6bf, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ee6c3
    pop ebp                                      # 004ee6c5
    ret                                          # 004ee6c6

