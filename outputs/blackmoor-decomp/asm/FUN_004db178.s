# FUN_004db178
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db178
# extent:       0x004db178-0x004db1ad (53 code bytes)
# span:         0x004db178-0x004db1ad (code 53, tables 0, padding 0)
# sha256:       bb3cc1fc66a1419e5dc459c0592ff2f5d0ad76ebfe9ed810f34051ed8f1c9c2d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db178_lifted
# naming:       native port src/original_methods_fl41.c:m4db178_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 19/19 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c
# callees:      calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetCursor
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4db178_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x004db178 - 0x401000
.globl FUN_004db178
FUN_004db178:
    # block 0x004db178: entry, 19 instruction(s), calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetCursor, ends with ret 0x4
    push ebp                                     # 004db178
    {load} mov ebp, esp                          # 004db179
    sub esp, 0xc                                 # 004db17b
    mov dword ptr [ebp - local_c], ecx           # 004db17e
    call FUN_00525371                            # 004db181
    mov eax, dword ptr [eax + field_c]           # 004db186
    mov dword ptr [ebp - local_4], eax           # 004db189
    mov ecx, dword ptr [ebp + arg_8]             # 004db18c
    push ecx                                     # 004db18f
    mov edx, dword ptr [ebp - local_4]           # 004db190
    push edx                                     # 004db193
    call dword ptr [0x52a4a4]                    # 004db194
    mov dword ptr [ebp - local_8], eax           # 004db19a
    mov eax, dword ptr [ebp - local_8]           # 004db19d
    push eax                                     # 004db1a0
    call dword ptr [0x52a474]                    # 004db1a1
    {load} mov esp, ebp                          # 004db1a7
    pop ebp                                      # 004db1a9
    ret 0x4                                      # 004db1aa

