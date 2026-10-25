# FUN_004ccacf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccacf
# extent:       0x004ccacf-0x004ccb50 (129 code bytes)
# span:         0x004ccacf-0x004ccb50 (code 129, tables 0, padding 0)
# sha256:       467a3938ee6f3fdb47e25810980f035109c92c65ac3daccc4b55d127745e5a1f
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ccacf_lifted
# naming:       native port src/original_methods_fl41.c:m4ccacf_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 43/43 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_18, field_28; [ecx + n] field_14; [edx + n] field_24
# callees:      calls FUN_004cc962, FUN_0050e054, FUN_0050e104
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ccacf_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_004cc962, .text + (0x004cc962 - 0x401000)
.set FUN_0050e054, .text + (0x0050e054 - 0x401000)
.set FUN_0050e104, .text + (0x0050e104 - 0x401000)

.org 0x004ccacf - 0x401000
.globl FUN_004ccacf
FUN_004ccacf:
    # block 0x004ccacf: entry, 43 instruction(s), calls FUN_004cc962, FUN_0050e054, FUN_0050e104, ends with ret 0x8
    push ebp                                     # 004ccacf
    {load} mov ebp, esp                          # 004ccad0
    sub esp, 0x14                                # 004ccad2
    mov dword ptr [ebp - local_c], ecx           # 004ccad5
    mov eax, dword ptr [ebp + arg_8]             # 004ccad8
    push eax                                     # 004ccadb
    mov ecx, dword ptr [ebp - local_c]           # 004ccadc
    call FUN_004cc962                            # 004ccadf
    fld dword ptr [ebp + arg_c]                  # 004ccae4
    fmul qword ptr [0x52e2c8]                    # 004ccae7
    fstp dword ptr [ebp + arg_c]                 # 004ccaed
    fld dword ptr [ebp + arg_c]                  # 004ccaf0
    sub esp, 0x8                                 # 004ccaf3
    fstp qword ptr [esp]                         # 004ccaf6
    call FUN_0050e054                            # 004ccaf9
    add esp, 0x8                                 # 004ccafe
    fstp dword ptr [ebp - local_10]              # 004ccb01
    fld dword ptr [ebp - local_10]               # 004ccb04
    fstp dword ptr [ebp - local_8]               # 004ccb07
    fld dword ptr [ebp + arg_c]                  # 004ccb0a
    sub esp, 0x8                                 # 004ccb0d
    fstp qword ptr [esp]                         # 004ccb10
    call FUN_0050e104                            # 004ccb13
    add esp, 0x8                                 # 004ccb18
    fstp dword ptr [ebp - local_14]              # 004ccb1b
    fld dword ptr [ebp - local_14]               # 004ccb1e
    fstp dword ptr [ebp - local_4]               # 004ccb21
    mov ecx, dword ptr [ebp + arg_8]             # 004ccb24
    mov edx, dword ptr [ebp - local_8]           # 004ccb27
    mov dword ptr [ecx + field_14], edx          # 004ccb2a
    mov eax, dword ptr [ebp + arg_8]             # 004ccb2d
    mov ecx, dword ptr [ebp - local_4]           # 004ccb30
    mov dword ptr [eax + field_18], ecx          # 004ccb33
    fld dword ptr [ebp - local_4]                # 004ccb36
    fchs                                         # 004ccb39
    mov edx, dword ptr [ebp + arg_8]             # 004ccb3b
    fstp dword ptr [edx + field_24]              # 004ccb3e
    mov eax, dword ptr [ebp + arg_8]             # 004ccb41
    mov ecx, dword ptr [ebp - local_8]           # 004ccb44
    mov dword ptr [eax + field_28], ecx          # 004ccb47
    {load} mov esp, ebp                          # 004ccb4a
    pop ebp                                      # 004ccb4c
    ret 0x8                                      # 004ccb4d

