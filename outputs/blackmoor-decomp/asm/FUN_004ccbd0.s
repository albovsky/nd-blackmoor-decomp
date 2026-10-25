# FUN_004ccbd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccbd0
# extent:       0x004ccbd0-0x004ccc50 (128 code bytes)
# span:         0x004ccbd0-0x004ccc50 (code 128, tables 0, padding 0)
# sha256:       2bf24ab937805431851f519dd6e5c922ab3d70270d15c9ede95e50d5f56f668d
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ccbd0_lifted
# naming:       native port src/original_methods_fl41.c:m4ccbd0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 43/43 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_14; [edx + n] field_10
# callees:      calls FUN_004cc962, FUN_0050e054, FUN_0050e104
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ccbd0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 43 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_004cc962, .text + (0x004cc962 - 0x401000)
.set FUN_0050e054, .text + (0x0050e054 - 0x401000)
.set FUN_0050e104, .text + (0x0050e104 - 0x401000)

.org 0x004ccbd0 - 0x401000
.globl FUN_004ccbd0
FUN_004ccbd0:
    # block 0x004ccbd0: entry, 43 instruction(s), calls FUN_004cc962, FUN_0050e054, FUN_0050e104, ends with ret 0x8
    push ebp                                     # 004ccbd0
    {load} mov ebp, esp                          # 004ccbd1
    sub esp, 0x14                                # 004ccbd3
    mov dword ptr [ebp - local_c], ecx           # 004ccbd6
    mov eax, dword ptr [ebp + arg_8]             # 004ccbd9
    push eax                                     # 004ccbdc
    mov ecx, dword ptr [ebp - local_c]           # 004ccbdd
    call FUN_004cc962                            # 004ccbe0
    fld dword ptr [ebp + arg_c]                  # 004ccbe5
    fmul qword ptr [0x52e2c8]                    # 004ccbe8
    fstp dword ptr [ebp + arg_c]                 # 004ccbee
    fld dword ptr [ebp + arg_c]                  # 004ccbf1
    sub esp, 0x8                                 # 004ccbf4
    fstp qword ptr [esp]                         # 004ccbf7
    call FUN_0050e054                            # 004ccbfa
    add esp, 0x8                                 # 004ccbff
    fstp dword ptr [ebp - local_10]              # 004ccc02
    fld dword ptr [ebp - local_10]               # 004ccc05
    fstp dword ptr [ebp - local_8]               # 004ccc08
    fld dword ptr [ebp + arg_c]                  # 004ccc0b
    sub esp, 0x8                                 # 004ccc0e
    fstp qword ptr [esp]                         # 004ccc11
    call FUN_0050e104                            # 004ccc14
    add esp, 0x8                                 # 004ccc19
    fstp dword ptr [ebp - local_14]              # 004ccc1c
    fld dword ptr [ebp - local_14]               # 004ccc1f
    fstp dword ptr [ebp - local_4]               # 004ccc22
    mov ecx, dword ptr [ebp + arg_8]             # 004ccc25
    mov edx, dword ptr [ebp - local_8]           # 004ccc28
    mov dword ptr [ecx], edx                     # 004ccc2b
    mov eax, dword ptr [ebp + arg_8]             # 004ccc2d
    mov ecx, dword ptr [ebp - local_4]           # 004ccc30
    mov dword ptr [eax + field_4], ecx           # 004ccc33
    fld dword ptr [ebp - local_4]                # 004ccc36
    fchs                                         # 004ccc39
    mov edx, dword ptr [ebp + arg_8]             # 004ccc3b
    fstp dword ptr [edx + field_10]              # 004ccc3e
    mov eax, dword ptr [ebp + arg_8]             # 004ccc41
    mov ecx, dword ptr [ebp - local_8]           # 004ccc44
    mov dword ptr [eax + field_14], ecx          # 004ccc47
    {load} mov esp, ebp                          # 004ccc4a
    pop ebp                                      # 004ccc4c
    ret 0x8                                      # 004ccc4d

