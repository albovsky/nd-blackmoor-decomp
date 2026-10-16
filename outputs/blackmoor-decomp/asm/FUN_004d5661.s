# FUN_004d5661
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5661
# extent:       0x004d5661-0x004d56e2 (129 code bytes)
# span:         0x004d5661-0x004d56e2 (code 129, tables 0, padding 0)
# sha256:       16b28bf73d406ba743734582dcfc82b8357924882097a07ac6dd69887487d118
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5661
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_minus_4; [ecx + n] field_c; [edx + n] field_c, field_minus_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004d5661 - 0x401000
.globl FUN_004d5661
FUN_004d5661:
    # block 0x004d5661: entry, 12 instruction(s), ends with forward jump to 0x004d5688
    push ebp                                     # 004d5661
    {load} mov ebp, esp                          # 004d5662
    sub esp, 0xc                                 # 004d5664
    push esi                                     # 004d5667
    mov dword ptr [ebp - local_c], ecx           # 004d5668
    mov eax, dword ptr [ebp + arg_c]             # 004d566b
    mov ecx, dword ptr [ebp + arg_8]             # 004d566e
    mov edx, dword ptr [ebp + arg_10]            # 004d5671
    mov dword ptr [ecx + 4*eax], edx             # 004d5674
    mov eax, dword ptr [ebp + arg_c]             # 004d5677
    mov dword ptr [ebp - local_4], eax           # 004d567a
    jmp.d8 L_004d5688                            # 004d567d
L_004d567f:
    # block 0x004d567f: entered by jmp at 0x004d56d9, 3 instruction(s), falls into the block at 0x004d5688
    mov ecx, dword ptr [ebp - local_4]           # 004d567f
    sub ecx, 0x1                                 # 004d5682
    mov dword ptr [ebp - local_4], ecx           # 004d5685
L_004d5688:
    # block 0x004d5688: entered by jmp at 0x004d567d, 2 instruction(s), ends with jl to 0x004d56db (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 004d5688
    jl.d8 L_004d56db                             # 004d568c
    # block 0x004d568e: entered by fall-through of jl at 0x004d568c, 9 instruction(s), ends with jge to 0x004d56d7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d568e
    mov eax, dword ptr [ebp + arg_8]             # 004d5691
    mov ecx, dword ptr [eax + 4*edx]             # 004d5694
    mov edx, dword ptr [ebp - local_4]           # 004d5697
    mov eax, dword ptr [ebp + arg_8]             # 004d569a
    mov edx, dword ptr [eax + 4*edx - field_minus_4] # 004d569d
    mov eax, dword ptr [ecx + field_c]           # 004d56a1
    cmp eax, dword ptr [edx + field_c]           # 004d56a4
    jge.d8 L_004d56d7                            # 004d56a7
    # block 0x004d56a9: entered by fall-through of jge at 0x004d56a7, 15 instruction(s), ends with forward jump to 0x004d56d9
    mov ecx, dword ptr [ebp - local_4]           # 004d56a9
    mov edx, dword ptr [ebp + arg_8]             # 004d56ac
    mov eax, dword ptr [edx + 4*ecx - field_minus_4] # 004d56af
    mov dword ptr [ebp - local_8], eax           # 004d56b3
    mov ecx, dword ptr [ebp - local_4]           # 004d56b6
    mov edx, dword ptr [ebp + arg_8]             # 004d56b9
    mov eax, dword ptr [ebp - local_4]           # 004d56bc
    mov esi, dword ptr [ebp + arg_8]             # 004d56bf
    mov eax, dword ptr [esi + 4*eax]             # 004d56c2
    mov dword ptr [edx + 4*ecx - field_minus_4], eax # 004d56c5
    mov ecx, dword ptr [ebp - local_4]           # 004d56c9
    mov edx, dword ptr [ebp + arg_8]             # 004d56cc
    mov eax, dword ptr [ebp - local_8]           # 004d56cf
    mov dword ptr [edx + 4*ecx], eax             # 004d56d2
    jmp.d8 L_004d56d9                            # 004d56d5
L_004d56d7:
    # block 0x004d56d7: entered by jge at 0x004d56a7, 1 instruction(s), ends with forward jump to 0x004d56db
    jmp.d8 L_004d56db                            # 004d56d7
L_004d56d9:
    # block 0x004d56d9: entered by jmp at 0x004d56d5, 1 instruction(s), ends with backward jump to 0x004d567f
    jmp.d8 L_004d567f                            # 004d56d9
L_004d56db:
    # block 0x004d56db: entered by jl at 0x004d568c; jmp at 0x004d56d7, 4 instruction(s), ends with ret 0xc
    pop esi                                      # 004d56db
    {load} mov esp, ebp                          # 004d56dc
    pop ebp                                      # 004d56de
    ret 0xc                                      # 004d56df

