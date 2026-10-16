# FUN_00479d98
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00479d98
# extent:       0x00479d98-0x00479deb (83 code bytes)
# span:         0x00479d98-0x00479deb (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00479d98
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

.org 0x00479d98 - 0x401000
.globl FUN_00479d98
FUN_00479d98:
    # block 0x00479d98: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 00479d98
    {load} mov ebp, esp                          # 00479d99
    push ecx                                     # 00479d9b
    mov dword ptr [ebp - local_4], ecx           # 00479d9c
    mov eax, dword ptr [ebp + arg_8]             # 00479d9f
    mov ecx, dword ptr [eax + field_4]           # 00479da2
    add ecx, dword ptr [0x58318a]                # 00479da5
    mov edx, dword ptr [ebp + arg_c]             # 00479dab
    mov dword ptr [edx + field_4], ecx           # 00479dae
    mov eax, dword ptr [ebp + arg_8]             # 00479db1
    mov ecx, dword ptr [eax + field_c]           # 00479db4
    add ecx, dword ptr [0x58318a]                # 00479db7
    mov edx, dword ptr [ebp + arg_c]             # 00479dbd
    mov dword ptr [edx + field_c], ecx           # 00479dc0
    mov eax, dword ptr [ebp + arg_8]             # 00479dc3
    mov ecx, dword ptr [eax]                     # 00479dc6
    add ecx, dword ptr [0x583186]                # 00479dc8
    mov edx, dword ptr [ebp + arg_c]             # 00479dce
    mov dword ptr [edx], ecx                     # 00479dd1
    mov eax, dword ptr [ebp + arg_8]             # 00479dd3
    mov ecx, dword ptr [eax + field_8]           # 00479dd6
    add ecx, dword ptr [0x583186]                # 00479dd9
    mov edx, dword ptr [ebp + arg_c]             # 00479ddf
    mov dword ptr [edx + field_8], ecx           # 00479de2
    {load} mov esp, ebp                          # 00479de5
    pop ebp                                      # 00479de7
    ret 0x8                                      # 00479de8

