# FUN_00454f29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454f29
# extent:       0x00454f29-0x00454f7c (83 code bytes)
# span:         0x00454f29-0x00454f7c (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454f29
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00454f29 - 0x401000
.globl FUN_00454f29
FUN_00454f29:
    # block 0x00454f29: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 00454f29
    {load} mov ebp, esp                          # 00454f2a
    push ecx                                     # 00454f2c
    mov dword ptr [ebp - local_4], ecx           # 00454f2d
    mov eax, dword ptr [ebp + arg_8]             # 00454f30
    mov ecx, dword ptr [eax + field_4]           # 00454f33
    add ecx, dword ptr [0x58318a]                # 00454f36
    mov edx, dword ptr [ebp + arg_c]             # 00454f3c
    mov dword ptr [edx + field_4], ecx           # 00454f3f
    mov eax, dword ptr [ebp + arg_8]             # 00454f42
    mov ecx, dword ptr [eax + field_c]           # 00454f45
    add ecx, dword ptr [0x58318a]                # 00454f48
    mov edx, dword ptr [ebp + arg_c]             # 00454f4e
    mov dword ptr [edx + field_c], ecx           # 00454f51
    mov eax, dword ptr [ebp + arg_8]             # 00454f54
    mov ecx, dword ptr [eax]                     # 00454f57
    add ecx, dword ptr [0x583186]                # 00454f59
    mov edx, dword ptr [ebp + arg_c]             # 00454f5f
    mov dword ptr [edx], ecx                     # 00454f62
    mov eax, dword ptr [ebp + arg_8]             # 00454f64
    mov ecx, dword ptr [eax + field_8]           # 00454f67
    add ecx, dword ptr [0x583186]                # 00454f6a
    mov edx, dword ptr [ebp + arg_c]             # 00454f70
    mov dword ptr [edx + field_8], ecx           # 00454f73
    {load} mov esp, ebp                          # 00454f76
    pop ebp                                      # 00454f78
    ret 0x8                                      # 00454f79

