# FUN_0040478e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040478e
# extent:       0x0040478e-0x00404812 (132 code bytes)
# span:         0x0040478e-0x00404812 (code 132, tables 0, padding 0)
# sha256:       1f19da4058079afeb808db0eb0916514d51013a8bace370a44af6e2725ae0e18
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040478e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_10; [ecx + n] field_4b0; [edx + n] field_4b0
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_4b0, 0x4b0  # offset +0x4b0

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)

.org 0x0040478e - 0x401000
.globl FUN_0040478e
FUN_0040478e:
    # block 0x0040478e: entry, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x00404804 (forward)
    push ebp                                     # 0040478e
    {load} mov ebp, esp                          # 0040478f
    sub esp, 0xc                                 # 00404791
    mov dword ptr [ebp - local_c], ecx           # 00404794
    mov eax, dword ptr [ebp + arg_8]             # 00404797
    mov dword ptr [ebp - local_4], eax           # 0040479a
    call dword ptr [0x52a23c]                    # 0040479d
    mov ecx, dword ptr [ebp - local_c]           # 004047a3
    cmp eax, dword ptr [ecx + field_4b0]         # 004047a6
    jbe.d8 L_00404804                            # 004047ac
    # block 0x004047ae: entered by fall-through of jbe at 0x004047ac, 13 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jl to 0x004047f1 (forward)
    call dword ptr [0x52a23c]                    # 004047ae
    add eax, 0x12c                               # 004047b4
    mov edx, dword ptr [ebp - local_c]           # 004047b9
    mov dword ptr [edx + field_4b0], eax         # 004047bc
    mov eax, dword ptr [ebp - local_4]           # 004047c2
    mov ecx, dword ptr [eax + field_10]          # 004047c5
    neg ecx                                      # 004047c8
    mov dword ptr [ebp - local_8], ecx           # 004047ca
    mov edx, dword ptr [0x5c3a63]                # 004047cd
    add edx, dword ptr [ebp - local_8]           # 004047d3
    mov dword ptr [0x5c3a63], edx                # 004047d6
    cmp dword ptr [0x5c3a63], 0xa                # 004047dc
    jl.d8 L_004047f1                             # 004047e3
    # block 0x004047e5: entered by fall-through of jl at 0x004047e3, 2 instruction(s), ends with forward jump to 0x00404804
    mov dword ptr [0x5c3a63], 0x0                # 004047e5
    jmp.d8 L_00404804                            # 004047ef
L_004047f1:
    # block 0x004047f1: entered by jl at 0x004047e3, 2 instruction(s), ends with jge to 0x00404804 (forward)
    cmp dword ptr [0x5c3a63], 0x0                # 004047f1
    jge.d8 L_00404804                            # 004047f8
    # block 0x004047fa: entered by fall-through of jge at 0x004047f8, 1 instruction(s), falls into the block at 0x00404804
    mov dword ptr [0x5c3a63], 0x9                # 004047fa
L_00404804:
    # block 0x00404804: entered by jbe at 0x004047ac; jmp at 0x004047ef; jge at 0x004047f8, 5 instruction(s), calls FUN_004033db, ends with ret 0x8
    mov ecx, dword ptr [ebp - local_c]           # 00404804
    call FUN_004033db                            # 00404807
    {load} mov esp, ebp                          # 0040480c
    pop ebp                                      # 0040480e
    ret 0x8                                      # 0040480f

