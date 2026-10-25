# FUN_004ccb50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccb50
# extent:       0x004ccb50-0x004ccbd0 (128 code bytes)
# span:         0x004ccb50-0x004ccbd0 (code 128, tables 0, padding 0)
# sha256:       1e59e3dfa12288cb4b022be457e3968216ef03e47fd70cbe80a10b3127283df9
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccb50
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_8, field_28; [ecx + n] field_20
# callees:      calls FUN_004cc962, FUN_0050e054, FUN_0050e104
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_20, 0x20  # offset +0x20
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_004cc962, .text + (0x004cc962 - 0x401000)
.set FUN_0050e054, .text + (0x0050e054 - 0x401000)
.set FUN_0050e104, .text + (0x0050e104 - 0x401000)

.org 0x004ccb50 - 0x401000
.globl FUN_004ccb50
FUN_004ccb50:
    # block 0x004ccb50: entry, 43 instruction(s), calls FUN_004cc962, FUN_0050e054, FUN_0050e104, ends with ret 0x8
    push ebp                                     # 004ccb50
    {load} mov ebp, esp                          # 004ccb51
    sub esp, 0x14                                # 004ccb53
    mov dword ptr [ebp - local_c], ecx           # 004ccb56
    mov eax, dword ptr [ebp + arg_8]             # 004ccb59
    push eax                                     # 004ccb5c
    mov ecx, dword ptr [ebp - local_c]           # 004ccb5d
    call FUN_004cc962                            # 004ccb60
    fld dword ptr [ebp + arg_c]                  # 004ccb65
    fmul qword ptr [0x52e2c8]                    # 004ccb68
    fstp dword ptr [ebp + arg_c]                 # 004ccb6e
    fld dword ptr [ebp + arg_c]                  # 004ccb71
    sub esp, 0x8                                 # 004ccb74
    fstp qword ptr [esp]                         # 004ccb77
    call FUN_0050e054                            # 004ccb7a
    add esp, 0x8                                 # 004ccb7f
    fstp dword ptr [ebp - local_10]              # 004ccb82
    fld dword ptr [ebp - local_10]               # 004ccb85
    fstp dword ptr [ebp - local_8]               # 004ccb88
    fld dword ptr [ebp + arg_c]                  # 004ccb8b
    sub esp, 0x8                                 # 004ccb8e
    fstp qword ptr [esp]                         # 004ccb91
    call FUN_0050e104                            # 004ccb94
    add esp, 0x8                                 # 004ccb99
    fstp dword ptr [ebp - local_14]              # 004ccb9c
    fld dword ptr [ebp - local_14]               # 004ccb9f
    fstp dword ptr [ebp - local_4]               # 004ccba2
    mov ecx, dword ptr [ebp + arg_8]             # 004ccba5
    mov edx, dword ptr [ebp - local_8]           # 004ccba8
    mov dword ptr [ecx], edx                     # 004ccbab
    fld dword ptr [ebp - local_4]                # 004ccbad
    fchs                                         # 004ccbb0
    mov eax, dword ptr [ebp + arg_8]             # 004ccbb2
    fstp dword ptr [eax + field_8]               # 004ccbb5
    mov ecx, dword ptr [ebp + arg_8]             # 004ccbb8
    mov edx, dword ptr [ebp - local_4]           # 004ccbbb
    mov dword ptr [ecx + field_20], edx          # 004ccbbe
    mov eax, dword ptr [ebp + arg_8]             # 004ccbc1
    mov ecx, dword ptr [ebp - local_8]           # 004ccbc4
    mov dword ptr [eax + field_28], ecx          # 004ccbc7
    {load} mov esp, ebp                          # 004ccbca
    pop ebp                                      # 004ccbcc
    ret 0x8                                      # 004ccbcd

