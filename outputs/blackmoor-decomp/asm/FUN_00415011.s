# FUN_00415011
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00415011
# extent:       0x00415011-0x004150af (158 code bytes)
# span:         0x00415011-0x004150af (code 158, tables 0, padding 0)
# sha256:       6de131ad15d21cb08a1d54ce5c027579ddc63760cb9a13452646ac2ae4708b66
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00415011
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_21, field_25, field_2d; [ecx + n] field_21, field_29, field_2d; [edx + n] field_25, field_29, field_4d
# callees:      calls FUN_0051dc6c, KERNEL32.dll!UnmapViewOfFile, KERNEL32.dll!CloseHandle
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_4d, 0x4d  # offset +0x4d

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00415011 - 0x401000
.globl FUN_00415011
FUN_00415011:
    # block 0x00415011: entry, 7 instruction(s), ends with je to 0x00415042 (forward)
    push ebp                                     # 00415011
    {load} mov ebp, esp                          # 00415012
    sub esp, 0x8                                 # 00415014
    mov dword ptr [ebp - local_8], ecx           # 00415017
    mov eax, dword ptr [ebp + arg_8]             # 0041501a
    cmp dword ptr [eax + field_21], 0x0          # 0041501d
    je.d8 L_00415042                             # 00415021
    # block 0x00415023: entered by fall-through of je at 0x00415021, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00415042
    mov ecx, dword ptr [ebp + arg_8]             # 00415023
    mov edx, dword ptr [ecx + field_21]          # 00415026
    mov dword ptr [ebp - local_4], edx           # 00415029
    mov eax, dword ptr [ebp - local_4]           # 0041502c
    push eax                                     # 0041502f
    call FUN_0051dc6c                            # 00415030
    add esp, 0x4                                 # 00415035
    mov ecx, dword ptr [ebp + arg_8]             # 00415038
    mov dword ptr [ecx + field_21], 0x0          # 0041503b
L_00415042:
    # block 0x00415042: entered by je at 0x00415021, 5 instruction(s), ends with je to 0x00415069 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00415042
    mov byte ptr [edx + field_4d], 0x0           # 00415045
    mov eax, dword ptr [ebp + arg_8]             # 00415049
    cmp dword ptr [eax + field_2d], 0x0          # 0041504c
    je.d8 L_00415069                             # 00415050
    # block 0x00415052: entered by fall-through of je at 0x00415050, 6 instruction(s), calls KERNEL32.dll!UnmapViewOfFile, falls into the block at 0x00415069
    mov ecx, dword ptr [ebp + arg_8]             # 00415052
    mov edx, dword ptr [ecx + field_2d]          # 00415055
    push edx                                     # 00415058
    call dword ptr [0x52a2b4]                    # 00415059
    mov eax, dword ptr [ebp + arg_8]             # 0041505f
    mov dword ptr [eax + field_2d], 0x0          # 00415062
L_00415069:
    # block 0x00415069: entered by je at 0x00415050, 3 instruction(s), ends with je to 0x00415089 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00415069
    cmp dword ptr [ecx + field_29], 0x0          # 0041506c
    je.d8 L_00415089                             # 00415070
    # block 0x00415072: entered by fall-through of je at 0x00415070, 6 instruction(s), calls KERNEL32.dll!CloseHandle, falls into the block at 0x00415089
    mov edx, dword ptr [ebp + arg_8]             # 00415072
    mov eax, dword ptr [edx + field_29]          # 00415075
    push eax                                     # 00415078
    call dword ptr [0x52a2b8]                    # 00415079
    mov ecx, dword ptr [ebp + arg_8]             # 0041507f
    mov dword ptr [ecx + field_29], 0x0          # 00415082
L_00415089:
    # block 0x00415089: entered by je at 0x00415070, 3 instruction(s), ends with je to 0x004150a9 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00415089
    cmp dword ptr [edx + field_25], 0x0          # 0041508c
    je.d8 L_004150a9                             # 00415090
    # block 0x00415092: entered by fall-through of je at 0x00415090, 6 instruction(s), calls KERNEL32.dll!CloseHandle, falls into the block at 0x004150a9
    mov eax, dword ptr [ebp + arg_8]             # 00415092
    mov ecx, dword ptr [eax + field_25]          # 00415095
    push ecx                                     # 00415098
    call dword ptr [0x52a2b8]                    # 00415099
    mov edx, dword ptr [ebp + arg_8]             # 0041509f
    mov dword ptr [edx + field_25], 0x0          # 004150a2
L_004150a9:
    # block 0x004150a9: entered by je at 0x00415090, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004150a9
    pop ebp                                      # 004150ab
    ret 0x4                                      # 004150ac

