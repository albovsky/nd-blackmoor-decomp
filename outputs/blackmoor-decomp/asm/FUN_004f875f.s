# FUN_004f875f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f875f
# extent:       0x004f875f-0x004f88ad (334 code bytes)
# span:         0x004f875f-0x004f88ad (code 334, tables 0, padding 0)
# sha256:       7f1d2b965382ebbe3b09021712f2bc74f920b7cac759c554740fb458d70e5512
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f875f
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_40, field_19c, field_24c, field_250, field_254, field_3ca, field_3d2; [ecx + n] field_19c, field_24c, field_250, field_254, field_3ca; [edx + n] field_24c, field_250, field_254, field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 90 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_40, 0x40  # offset +0x40
.equ field_19c, 0x19c  # offset +0x19c
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_254, 0x254  # offset +0x254
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f875f - 0x401000
.globl FUN_004f875f
FUN_004f875f:
    # block 0x004f875f: entry, 9 instruction(s), ends with je to 0x004f88a5 (forward)
    push ebp                                     # 004f875f
    {load} mov ebp, esp                          # 004f8760
    push ecx                                     # 004f8762
    mov dword ptr [ebp - local_4], ecx           # 004f8763
    mov eax, dword ptr [ebp - local_4]           # 004f8766
    mov dword ptr [eax + field_3ca], 0x0         # 004f8769
    mov ecx, dword ptr [ebp - local_4]           # 004f8773
    cmp dword ptr [ecx + field_19c], 0x0         # 004f8776
    je.d32 L_004f88a5                            # 004f877d
    # block 0x004f8783: entered by fall-through of je at 0x004f877d, 3 instruction(s), ends with je to 0x004f8796 (forward)
    {load} xor edx, edx                          # 004f8783
    test edx, edx                                # 004f8785
    je.d8 L_004f8796                             # 004f8787
    # block 0x004f8789: entered by fall-through of je at 0x004f8787, 2 instruction(s), falls into the block at 0x004f8796
    mov eax, dword ptr [ebp - local_4]           # 004f8789
    mov dword ptr [eax + field_3d2], 0x1         # 004f878c
L_004f8796:
    # block 0x004f8796: entered by je at 0x004f8787, 46 instruction(s), calls indirect dword ptr [eax + 0x40], ends with jne to 0x004f88a1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8796
    mov edx, dword ptr [ebp + arg_8]             # 004f8799
    mov dword ptr [ecx + field_24c], edx         # 004f879c
    mov eax, dword ptr [ebp - local_4]           # 004f87a2
    mov ecx, dword ptr [ebp + arg_c]             # 004f87a5
    mov dword ptr [eax + field_250], ecx         # 004f87a8
    mov edx, dword ptr [ebp - local_4]           # 004f87ae
    mov eax, dword ptr [ebp + arg_10]            # 004f87b1
    mov dword ptr [edx + field_254], eax         # 004f87b4
    mov ecx, dword ptr [ebp - local_4]           # 004f87ba
    fld dword ptr [ecx + field_24c]              # 004f87bd
    .insn 0xdc, 0xc0                             # 004f87c3
    mov edx, dword ptr [ebp - local_4]           # 004f87c5
    fstp dword ptr [edx + field_24c]             # 004f87c8
    mov eax, dword ptr [ebp - local_4]           # 004f87ce
    fld dword ptr [eax + field_250]              # 004f87d1
    .insn 0xdc, 0xc0                             # 004f87d7
    mov ecx, dword ptr [ebp - local_4]           # 004f87d9
    fstp dword ptr [ecx + field_250]             # 004f87dc
    mov edx, dword ptr [ebp - local_4]           # 004f87e2
    fld dword ptr [edx + field_254]              # 004f87e5
    .insn 0xdc, 0xc0                             # 004f87eb
    mov eax, dword ptr [ebp - local_4]           # 004f87ed
    fstp dword ptr [eax + field_254]             # 004f87f0
    push 0x0                                     # 004f87f6
    mov ecx, dword ptr [ebp - local_4]           # 004f87f8
    mov edx, dword ptr [ecx + field_254]         # 004f87fb
    push edx                                     # 004f8801
    mov eax, dword ptr [ebp - local_4]           # 004f8802
    mov ecx, dword ptr [eax + field_250]         # 004f8805
    push ecx                                     # 004f880b
    mov edx, dword ptr [ebp - local_4]           # 004f880c
    mov eax, dword ptr [edx + field_24c]         # 004f880f
    push eax                                     # 004f8815
    mov ecx, dword ptr [ebp - local_4]           # 004f8816
    mov edx, dword ptr [ecx + field_19c]         # 004f8819
    mov eax, dword ptr [ebp - local_4]           # 004f881f
    mov ecx, dword ptr [eax + field_19c]         # 004f8822
    mov eax, dword ptr [ecx]                     # 004f8828
    push edx                                     # 004f882a
    call dword ptr [eax + field_40]              # 004f882b
    mov ecx, dword ptr [ebp - local_4]           # 004f882e
    mov dword ptr [ecx + field_3ca], eax         # 004f8831
    mov edx, dword ptr [ebp - local_4]           # 004f8837
    cmp dword ptr [edx + field_3ca], 0x0         # 004f883a
    jne.d8 L_004f88a1                            # 004f8841
    # block 0x004f8843: entered by fall-through of jne at 0x004f8841, 3 instruction(s), ends with je to 0x004f889a (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f8843
    test eax, eax                                # 004f884a
    je.d8 L_004f889a                             # 004f884c
    # block 0x004f884e: entered by fall-through of je at 0x004f884c, 19 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f889a
    mov ecx, dword ptr [ebp - local_4]           # 004f884e
    fld dword ptr [ecx + field_254]              # 004f8851
    sub esp, 0x8                                 # 004f8857
    fstp qword ptr [esp]                         # 004f885a
    mov edx, dword ptr [ebp - local_4]           # 004f885d
    fld dword ptr [edx + field_250]              # 004f8860
    sub esp, 0x8                                 # 004f8866
    fstp qword ptr [esp]                         # 004f8869
    mov eax, dword ptr [ebp - local_4]           # 004f886c
    fld dword ptr [eax + field_24c]              # 004f886f
    sub esp, 0x8                                 # 004f8875
    fstp qword ptr [esp]                         # 004f8878
    push 0x55eefc                                # 004f887b
    push 0x63888b                                # 004f8880
    call FUN_0050ca3e                            # 004f8885
    add esp, 0x20                                # 004f888a
    push 0x63888b                                # 004f888d
    call FUN_0044a2b7                            # 004f8892
    add esp, 0x4                                 # 004f8897
L_004f889a:
    # block 0x004f889a: entered by je at 0x004f884c, 2 instruction(s), ends with forward jump to 0x004f88a7
    mov eax, 0x1                                 # 004f889a
    jmp.d8 L_004f88a7                            # 004f889f
L_004f88a1:
    # block 0x004f88a1: entered by jne at 0x004f8841, 2 instruction(s), ends with forward jump to 0x004f88a7
    {load} xor eax, eax                          # 004f88a1
    jmp.d8 L_004f88a7                            # 004f88a3
L_004f88a5:
    # block 0x004f88a5: entered by je at 0x004f877d, 1 instruction(s), falls into the block at 0x004f88a7
    {load} xor eax, eax                          # 004f88a5
L_004f88a7:
    # block 0x004f88a7: entered by jmp at 0x004f889f; jmp at 0x004f88a3, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004f88a7
    pop ebp                                      # 004f88a9
    ret 0xc                                      # 004f88aa

