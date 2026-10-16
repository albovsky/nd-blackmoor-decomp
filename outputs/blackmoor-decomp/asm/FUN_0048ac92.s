# FUN_0048ac92
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ac92
# extent:       0x0048ac92-0x0048ad26 (148 code bytes)
# span:         0x0048ac92-0x0048ad26 (code 148, tables 0, padding 0)
# sha256:       854bf70992272cde3031446b3a4a704c2af7f403f11e0d2a8637afed3b3a41fc
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048ac92
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_21, field_1af; [ecx + n] field_2e, field_42, field_1ba; [edx + n] field_1b6
# callees:      calls FUN_0048ad26
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_2e, 0x2e  # offset +0x2e
.equ field_42, 0x42  # offset +0x42
.equ field_1af, 0x1af  # offset +0x1af
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba

# --- external targets -----------------------------------------------
.set FUN_0048ad26, .text + (0x0048ad26 - 0x401000)

.org 0x0048ac92 - 0x401000
.globl FUN_0048ac92
FUN_0048ac92:
    # block 0x0048ac92: entry, 11 instruction(s), ends with forward jump to 0x0048acc3
    push ebp                                     # 0048ac92
    {load} mov ebp, esp                          # 0048ac93
    sub esp, 0xc                                 # 0048ac95
    mov dword ptr [ebp - local_c], ecx           # 0048ac98
    mov eax, dword ptr [ebp - local_c]           # 0048ac9b
    movsx ecx, word ptr [eax + field_1e]         # 0048ac9e
    imul ecx, ecx, 0x8d                          # 0048aca2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048aca8
    mov dword ptr [ebp - local_8], edx           # 0048acae
    mov dword ptr [ebp - local_4], 0x0           # 0048acb1
    jmp.d8 L_0048acc3                            # 0048acb8
L_0048acba:
    # block 0x0048acba: entered by jmp at 0x0048acf6, 3 instruction(s), falls into the block at 0x0048acc3
    mov eax, dword ptr [ebp - local_4]           # 0048acba
    add eax, 0x1                                 # 0048acbd
    mov dword ptr [ebp - local_4], eax           # 0048acc0
L_0048acc3:
    # block 0x0048acc3: entered by jmp at 0x0048acb8, 4 instruction(s), ends with jge to 0x0048acf8 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048acc3
    movsx edx, word ptr [ecx + field_42]         # 0048acc6
    cmp dword ptr [ebp - local_4], edx           # 0048acca
    jge.d8 L_0048acf8                            # 0048accd
    # block 0x0048accf: entered by fall-through of jge at 0x0048accd, 8 instruction(s), ends with je to 0x0048acf6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048accf
    mov ecx, dword ptr [ebp - local_c]           # 0048acd2
    movsx edx, word ptr [ecx + 2*eax + field_2e] # 0048acd5
    mov eax, dword ptr [ebp - local_4]           # 0048acda
    mov ecx, dword ptr [ebp - local_c]           # 0048acdd
    movsx eax, word ptr [ecx + 2*eax + field_1ba] # 0048ace0
    {load} cmp edx, eax                          # 0048ace8
    je.d8 L_0048acf6                             # 0048acea
    # block 0x0048acec: entered by fall-through of je at 0x0048acea, 3 instruction(s), calls FUN_0048ad26, ends with forward jump to 0x0048ad22
    mov ecx, dword ptr [ebp - local_c]           # 0048acec
    call FUN_0048ad26                            # 0048acef
    jmp.d8 L_0048ad22                            # 0048acf4
L_0048acf6:
    # block 0x0048acf6: entered by je at 0x0048acea, 1 instruction(s), ends with backward jump to 0x0048acba
    jmp.d8 L_0048acba                            # 0048acf6
L_0048acf8:
    # block 0x0048acf8: entered by jge at 0x0048accd, 7 instruction(s), ends with jne to 0x0048ad22 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048acf8
    movsx edx, word ptr [ecx + field_42]         # 0048acfb
    mov eax, dword ptr [ebp - local_8]           # 0048acff
    {load} xor ecx, ecx                          # 0048ad02
    mov cl, byte ptr [eax + field_21]            # 0048ad04
    {load} cmp edx, ecx                          # 0048ad07
    jne.d8 L_0048ad22                            # 0048ad09
    # block 0x0048ad0b: entered by fall-through of jne at 0x0048ad09, 4 instruction(s), falls into the block at 0x0048ad22
    mov edx, dword ptr [ebp - local_c]           # 0048ad0b
    mov dword ptr [edx + field_1b6], 0x1         # 0048ad0e
    mov eax, dword ptr [ebp - local_c]           # 0048ad18
    mov byte ptr [eax + field_1af], 0x1          # 0048ad1b
L_0048ad22:
    # block 0x0048ad22: entered by jmp at 0x0048acf4; jne at 0x0048ad09, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048ad22
    pop ebp                                      # 0048ad24
    ret                                          # 0048ad25

