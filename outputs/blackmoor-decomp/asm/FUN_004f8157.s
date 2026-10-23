# FUN_004f8157
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8157
# extent:       0x004f8157-0x004f81fa (163 code bytes)
# span:         0x004f8157-0x004f81fa (code 163, tables 0, padding 0)
# sha256:       ef34473e5268c6fb9e8c1eedbc96f5cb29e131acdafb5d0276af630e30a131e7
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8157
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_10, field_28f, field_3ca; [ecx + n] field_162, field_28f, field_3ca; [edx + n] field_28f, field_3ca, field_3ce
# callees:      calls FUN_004f709c; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_162, 0x162  # offset +0x162
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_004f709c, .text + (0x004f709c - 0x401000)

.org 0x004f8157 - 0x401000
.globl FUN_004f8157
FUN_004f8157:
    # block 0x004f8157: entry, 17 instruction(s), calls FUN_004f709c, ends with jne to 0x004f819c (forward)
    push ebp                                     # 004f8157
    {load} mov ebp, esp                          # 004f8158
    sub esp, 0xc                                 # 004f815a
    mov dword ptr [ebp - local_c], ecx           # 004f815d
    mov eax, dword ptr [ebp - local_c]           # 004f8160
    mov dword ptr [eax + field_3ca], 0x0         # 004f8163
    mov ecx, dword ptr [ebp + arg_8]             # 004f816d
    imul ecx, ecx, 0x5bb                         # 004f8170
    mov edx, dword ptr [ebp - local_c]           # 004f8176
    mov eax, dword ptr [edx + field_3ce]         # 004f8179
    {load} add eax, ecx                          # 004f817f
    mov dword ptr [ebp - local_8], eax           # 004f8181
    mov dword ptr [ebp - local_4], 0x0           # 004f8184
    mov ecx, dword ptr [ebp - local_c]           # 004f818b
    call FUN_004f709c                            # 004f818e
    test eax, eax                                # 004f8193
    jne.d8 L_004f819c                            # 004f8195
    # block 0x004f8197: entered by fall-through of jne at 0x004f8195, 2 instruction(s), ends with forward jump to 0x004f81f4
    or eax, -0x1                                 # 004f8197
    jmp.d8 L_004f81f4                            # 004f819a
L_004f819c:
    # block 0x004f819c: entered by jne at 0x004f8195, 3 instruction(s), ends with je to 0x004f81b4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f819c
    cmp dword ptr [ecx + field_162], 0x0         # 004f819f
    je.d8 L_004f81b4                             # 004f81a6
    # block 0x004f81a8: entered by fall-through of je at 0x004f81a6, 3 instruction(s), ends with jne to 0x004f81b9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f81a8
    cmp dword ptr [edx + field_28f], 0x0         # 004f81ab
    jne.d8 L_004f81b9                            # 004f81b2
L_004f81b4:
    # block 0x004f81b4: entered by je at 0x004f81a6; fall-through of jne at 0x004f81b2, 2 instruction(s), ends with forward jump to 0x004f81f4
    or eax, -0x1                                 # 004f81b4
    jmp.d8 L_004f81f4                            # 004f81b7
L_004f81b9:
    # block 0x004f81b9: entered by jne at 0x004f81b2, 15 instruction(s), calls indirect dword ptr [eax + 0x10], ends with jne to 0x004f81f1 (forward)
    push 0x0                                     # 004f81b9
    lea eax, [ebp - local_4]                     # 004f81bb
    push eax                                     # 004f81be
    mov ecx, dword ptr [ebp - local_8]           # 004f81bf
    mov edx, dword ptr [ecx + field_28f]         # 004f81c2
    mov eax, dword ptr [ebp - local_8]           # 004f81c8
    mov ecx, dword ptr [eax + field_28f]         # 004f81cb
    mov eax, dword ptr [ecx]                     # 004f81d1
    push edx                                     # 004f81d3
    call dword ptr [eax + field_10]              # 004f81d4
    mov ecx, dword ptr [ebp - local_c]           # 004f81d7
    mov dword ptr [ecx + field_3ca], eax         # 004f81da
    mov edx, dword ptr [ebp - local_c]           # 004f81e0
    cmp dword ptr [edx + field_3ca], 0x0         # 004f81e3
    jne.d8 L_004f81f1                            # 004f81ea
    # block 0x004f81ec: entered by fall-through of jne at 0x004f81ea, 2 instruction(s), ends with forward jump to 0x004f81f4
    mov eax, dword ptr [ebp - local_4]           # 004f81ec
    jmp.d8 L_004f81f4                            # 004f81ef
L_004f81f1:
    # block 0x004f81f1: entered by jne at 0x004f81ea, 1 instruction(s), falls into the block at 0x004f81f4
    or eax, -0x1                                 # 004f81f1
L_004f81f4:
    # block 0x004f81f4: entered by jmp at 0x004f819a; jmp at 0x004f81b7; jmp at 0x004f81ef, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f81f4
    pop ebp                                      # 004f81f6
    ret 0x4                                      # 004f81f7

