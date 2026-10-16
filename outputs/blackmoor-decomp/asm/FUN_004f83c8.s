# FUN_004f83c8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f83c8
# extent:       0x004f83c8-0x004f842f (103 code bytes)
# span:         0x004f83c8-0x004f842f (code 103, tables 0, padding 0)
# sha256:       60082184abc471ee8dcbde8436983bea14563bbcd8b48272a789a54f944eb568
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f83c8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_190, field_3ca; [ecx + n] field_190, field_3ca; [edx + n] field_3ca
# callees:      calls FUN_004fced0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_190, 0x190  # offset +0x190
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------
.set FUN_004fced0, .text + (0x004fced0 - 0x401000)

.org 0x004f83c8 - 0x401000
.globl FUN_004f83c8
FUN_004f83c8:
    # block 0x004f83c8: entry, 18 instruction(s), calls FUN_004fced0, ends with je to 0x004f8416 (forward)
    push ebp                                     # 004f83c8
    {load} mov ebp, esp                          # 004f83c9
    push ecx                                     # 004f83cb
    mov dword ptr [ebp - local_4], ecx           # 004f83cc
    mov eax, dword ptr [ebp - local_4]           # 004f83cf
    mov dword ptr [eax + field_3ca], 0x0         # 004f83d2
    mov ecx, dword ptr [ebp - local_4]           # 004f83dc
    mov dword ptr [ecx + field_190], 0x0         # 004f83df
    mov edx, dword ptr [ebp - local_4]           # 004f83e9
    add edx, 0x190                               # 004f83ec
    push edx                                     # 004f83f2
    push 0x4fa8d2                                # 004f83f3
    call FUN_004fced0                            # 004f83f8
    mov ecx, dword ptr [ebp - local_4]           # 004f83fd
    mov dword ptr [ecx + field_3ca], eax         # 004f8400
    mov edx, dword ptr [ebp - local_4]           # 004f8406
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8409
    je.d8 L_004f8416                             # 004f8410
    # block 0x004f8412: entered by fall-through of je at 0x004f8410, 2 instruction(s), ends with forward jump to 0x004f842b
    {load} xor eax, eax                          # 004f8412
    jmp.d8 L_004f842b                            # 004f8414
L_004f8416:
    # block 0x004f8416: entered by je at 0x004f8410, 3 instruction(s), ends with jne to 0x004f8426 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f8416
    cmp dword ptr [eax + field_190], 0x0         # 004f8419
    jne.d8 L_004f8426                            # 004f8420
    # block 0x004f8422: entered by fall-through of jne at 0x004f8420, 2 instruction(s), ends with forward jump to 0x004f842b
    {load} xor eax, eax                          # 004f8422
    jmp.d8 L_004f842b                            # 004f8424
L_004f8426:
    # block 0x004f8426: entered by jne at 0x004f8420, 1 instruction(s), falls into the block at 0x004f842b
    mov eax, 0x1                                 # 004f8426
L_004f842b:
    # block 0x004f842b: entered by jmp at 0x004f8414; jmp at 0x004f8424, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f842b
    pop ebp                                      # 004f842d
    ret                                          # 004f842e

