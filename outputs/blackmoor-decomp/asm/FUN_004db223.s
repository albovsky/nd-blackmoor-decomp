# FUN_004db223
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db223
# extent:       0x004db223-0x004db258 (53 code bytes)
# span:         0x004db223-0x004db260 (code 53, tables 0, padding 8)
# sha256:       a8892a5e4607efc41a01169a45b10ceb988a71f4fc6a1cbf2c2c0916158cb64f
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db223_lifted
# naming:       native port src/original_methods_fl41.c:m4db223_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 2 seeds; oracle: 20/20 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c
# callees:      calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetClassLongA
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4db223_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x004db223 - 0x401000
.globl FUN_004db223
FUN_004db223:
    # block 0x004db223: entry, 20 instruction(s), calls FUN_00525371, USER32.dll!LoadCursorA, USER32.dll!SetClassLongA, ends with ret 0x8
    push ebp                                     # 004db223
    {load} mov ebp, esp                          # 004db224
    sub esp, 0x8                                 # 004db226
    mov dword ptr [ebp - local_8], ecx           # 004db229
    call FUN_00525371                            # 004db22c
    mov eax, dword ptr [eax + field_c]           # 004db231
    mov dword ptr [ebp - local_4], eax           # 004db234
    mov ecx, dword ptr [ebp + arg_c]             # 004db237
    push ecx                                     # 004db23a
    mov edx, dword ptr [ebp - local_4]           # 004db23b
    push edx                                     # 004db23e
    call dword ptr [0x52a4a4]                    # 004db23f
    push eax                                     # 004db245
    push -0xc                                    # 004db246
    mov eax, dword ptr [ebp + arg_8]             # 004db248
    push eax                                     # 004db24b
    call dword ptr [0x52a470]                    # 004db24c
    {load} mov esp, ebp                          # 004db252
    pop ebp                                      # 004db254
    ret 0x8                                      # 004db255

# --- data items (not part of the function) -------------------------
.org 0x004db258 - 0x401000
PAD_004db258:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

