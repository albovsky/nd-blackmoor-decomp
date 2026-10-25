# FUN_004db10c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db10c
# extent:       0x004db10c-0x004db147 (59 code bytes)
# span:         0x004db10c-0x004db147 (code 59, tables 0, padding 0)
# sha256:       abd26579e08cac9a1f9929c105a8bef49e3caed35c29d0ccd79c9e08560956f9
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db10c_lifted
# naming:       native port src/original_methods_fl41.c:m4db10c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 2 seeds; oracle: 22/22 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_4; [edx + n] field_1c
# callees:      calls USER32.dll!GetCursorPos, USER32.dll!ScreenToClient
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4db10c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x004db10c - 0x401000
.globl FUN_004db10c
FUN_004db10c:
    # block 0x004db10c: entry, 22 instruction(s), calls USER32.dll!GetCursorPos, USER32.dll!ScreenToClient, ends with ret 0x8
    push ebp                                     # 004db10c
    {load} mov ebp, esp                          # 004db10d
    sub esp, 0xc                                 # 004db10f
    mov dword ptr [ebp - local_c], ecx           # 004db112
    lea eax, [ebp - local_8]                     # 004db115
    push eax                                     # 004db118
    call dword ptr [0x52a484]                    # 004db119
    lea ecx, [ebp - local_8]                     # 004db11f
    push ecx                                     # 004db122
    mov edx, dword ptr [ebp + arg_c]             # 004db123
    mov eax, dword ptr [edx + field_1c]          # 004db126
    push eax                                     # 004db129
    call dword ptr [0x52a47c]                    # 004db12a
    mov ecx, dword ptr [ebp + arg_8]             # 004db130
    mov edx, dword ptr [ebp - local_8]           # 004db133
    mov dword ptr [ecx], edx                     # 004db136
    mov eax, dword ptr [ebp - local_4]           # 004db138
    mov dword ptr [ecx + field_4], eax           # 004db13b
    mov eax, dword ptr [ebp + arg_8]             # 004db13e
    {load} mov esp, ebp                          # 004db141
    pop ebp                                      # 004db143
    ret 0x8                                      # 004db144

