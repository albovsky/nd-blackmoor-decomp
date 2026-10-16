# FUN_004cca0e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cca0e
# extent:       0x004cca0e-0x004cca42 (52 code bytes)
# span:         0x004cca0e-0x004cca42 (code 52, tables 0, padding 0)
# sha256:       bcdfc687c8a5beff044df16e7641f00392dab81acabbc5fdeb8c289257872a77
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cca0e
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_34; [ecx + n] field_30; [edx + n] field_38
# callees:      calls FUN_004cc962
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_004cc962, .text + (0x004cc962 - 0x401000)

.org 0x004cca0e - 0x401000
.globl FUN_004cca0e
FUN_004cca0e:
    # block 0x004cca0e: entry, 20 instruction(s), calls FUN_004cc962, ends with ret 0x10
    push ebp                                     # 004cca0e
    {load} mov ebp, esp                          # 004cca0f
    push ecx                                     # 004cca11
    mov dword ptr [ebp - local_4], ecx           # 004cca12
    mov eax, dword ptr [ebp + arg_8]             # 004cca15
    push eax                                     # 004cca18
    mov ecx, dword ptr [ebp - local_4]           # 004cca19
    call FUN_004cc962                            # 004cca1c
    mov ecx, dword ptr [ebp + arg_8]             # 004cca21
    mov edx, dword ptr [ebp + arg_c]             # 004cca24
    mov dword ptr [ecx + field_30], edx          # 004cca27
    mov eax, dword ptr [ebp + arg_8]             # 004cca2a
    mov ecx, dword ptr [ebp + arg_10]            # 004cca2d
    mov dword ptr [eax + field_34], ecx          # 004cca30
    mov edx, dword ptr [ebp + arg_8]             # 004cca33
    mov eax, dword ptr [ebp + arg_14]            # 004cca36
    mov dword ptr [edx + field_38], eax          # 004cca39
    {load} mov esp, ebp                          # 004cca3c
    pop ebp                                      # 004cca3e
    ret 0x10                                     # 004cca3f

