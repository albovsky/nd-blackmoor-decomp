# FUN_004eead0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eead0
# extent:       0x004eead0-0x004eeb23 (83 code bytes)
# span:         0x004eead0-0x004eeb23 (code 83, tables 0, padding 0)
# sha256:       0551cbddcc97e376a7186a5f3faff15d48880eed7e9eb286eac8e5296c38851a
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eead0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_1a2; [ecx + n] field_8
# callees:      calls FUN_004c2dfb, FUN_004ee9bb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1a2, 0x1a2  # offset +0x1a2

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004ee9bb, .text + (0x004ee9bb - 0x401000)

.org 0x004eead0 - 0x401000
.globl FUN_004eead0
FUN_004eead0:
    # block 0x004eead0: entry, 7 instruction(s), ends with jne to 0x004eeafd (forward)
    push ebp                                     # 004eead0
    {load} mov ebp, esp                          # 004eead1
    push ecx                                     # 004eead3
    mov dword ptr [ebp - local_4], ecx           # 004eead4
    mov eax, dword ptr [ebp - local_4]           # 004eead7
    cmp dword ptr [eax + field_1a2], 0x0         # 004eeada
    jne.d8 L_004eeafd                            # 004eeae1
    # block 0x004eeae3: entered by fall-through of jne at 0x004eeae1, 3 instruction(s), ends with je to 0x004eeafd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004eeae3
    cmp dword ptr [ecx + field_8], 0x0           # 004eeae6
    je.d8 L_004eeafd                             # 004eeaea
    # block 0x004eeaec: entered by fall-through of je at 0x004eeaea, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004eeafd
    mov edx, dword ptr [ebp - local_4]           # 004eeaec
    add edx, 0x8                                 # 004eeaef
    push edx                                     # 004eeaf2
    mov ecx, 0x5cf659                            # 004eeaf3
    call FUN_004c2dfb                            # 004eeaf8
L_004eeafd:
    # block 0x004eeafd: entered by jne at 0x004eeae1; je at 0x004eeaea, 3 instruction(s), ends with je to 0x004eeb17 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004eeafd
    cmp dword ptr [eax + field_c], 0x0           # 004eeb00
    je.d8 L_004eeb17                             # 004eeb04
    # block 0x004eeb06: entered by fall-through of je at 0x004eeb04, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004eeb17
    mov ecx, dword ptr [ebp - local_4]           # 004eeb06
    add ecx, 0xc                                 # 004eeb09
    push ecx                                     # 004eeb0c
    mov ecx, 0x5cf659                            # 004eeb0d
    call FUN_004c2dfb                            # 004eeb12
L_004eeb17:
    # block 0x004eeb17: entered by je at 0x004eeb04, 5 instruction(s), calls FUN_004ee9bb, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004eeb17
    call FUN_004ee9bb                            # 004eeb1a
    {load} mov esp, ebp                          # 004eeb1f
    pop ebp                                      # 004eeb21
    ret                                          # 004eeb22

