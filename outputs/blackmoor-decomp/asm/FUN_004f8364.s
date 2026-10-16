# FUN_004f8364
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8364
# extent:       0x004f8364-0x004f83c8 (100 code bytes)
# span:         0x004f8364-0x004f83c8 (code 100, tables 0, padding 0)
# sha256:       26c1cd5d3e96827a046779d1b39973b4b4f240c6a0be3eded69027d8171378f6
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f8364
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_3ca; [edx + n] field_4, field_8, field_c, field_10, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------

.org 0x004f8364 - 0x401000
.globl FUN_004f8364
FUN_004f8364:
    # block 0x004f8364: entry, 27 instruction(s), calls indirect dword ptr [eax + 0xc], ends with jne to 0x004f83c0 (forward)
    push ebp                                     # 004f8364
    {load} mov ebp, esp                          # 004f8365
    push ecx                                     # 004f8367
    mov dword ptr [ebp - local_4], ecx           # 004f8368
    mov eax, dword ptr [ebp - local_4]           # 004f836b
    mov dword ptr [eax + field_3ca], 0x0         # 004f836e
    {load} xor ecx, ecx                          # 004f8378
    mov edx, dword ptr [ebp + arg_c]             # 004f837a
    mov dword ptr [edx], ecx                     # 004f837d
    mov dword ptr [edx + field_4], ecx           # 004f837f
    mov dword ptr [edx + field_8], ecx           # 004f8382
    mov dword ptr [edx + field_c], ecx           # 004f8385
    mov dword ptr [edx + field_10], ecx          # 004f8388
    mov eax, dword ptr [ebp + arg_c]             # 004f838b
    mov dword ptr [eax], 0x14                    # 004f838e
    mov ecx, dword ptr [ebp + arg_c]             # 004f8394
    push ecx                                     # 004f8397
    mov edx, dword ptr [ebp + arg_8]             # 004f8398
    mov eax, dword ptr [edx]                     # 004f839b
    mov ecx, dword ptr [ebp + arg_8]             # 004f839d
    push ecx                                     # 004f83a0
    call dword ptr [eax + field_c]               # 004f83a1
    mov edx, dword ptr [ebp - local_4]           # 004f83a4
    mov dword ptr [edx + field_3ca], eax         # 004f83a7
    mov eax, dword ptr [ebp - local_4]           # 004f83ad
    cmp dword ptr [eax + field_3ca], 0x0         # 004f83b0
    jne.d8 L_004f83c0                            # 004f83b7
    # block 0x004f83b9: entered by fall-through of jne at 0x004f83b7, 2 instruction(s), ends with forward jump to 0x004f83c2
    mov eax, 0x1                                 # 004f83b9
    jmp.d8 L_004f83c2                            # 004f83be
L_004f83c0:
    # block 0x004f83c0: entered by jne at 0x004f83b7, 1 instruction(s), falls into the block at 0x004f83c2
    {load} xor eax, eax                          # 004f83c0
L_004f83c2:
    # block 0x004f83c2: entered by jmp at 0x004f83be, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f83c2
    pop ebp                                      # 004f83c4
    ret 0x8                                      # 004f83c5

