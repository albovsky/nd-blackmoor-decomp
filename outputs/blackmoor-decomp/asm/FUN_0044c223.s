# FUN_0044c223
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c223
# extent:       0x0044c223-0x0044c2a3 (128 code bytes)
# span:         0x0044c223-0x0044c2b0 (code 128, tables 0, padding 13)
# sha256:       afcdca4db78e170d8cd16a851cd0236977a9df151d49209fe23f46c81bda349b
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44c223_lifted
# naming:       native port src/original_methods_fl40.c:m44c223_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 48/48 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8
# callees:      calls FUN_0044bf8b, FUN_0044bfe5, FUN_0044c033, FUN_0044c0b8, FUN_0044bf4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m44c223_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0044bf4b, .text + (0x0044bf4b - 0x401000)
.set FUN_0044bf8b, .text + (0x0044bf8b - 0x401000)
.set FUN_0044bfe5, .text + (0x0044bfe5 - 0x401000)
.set FUN_0044c033, .text + (0x0044c033 - 0x401000)
.set FUN_0044c0b8, .text + (0x0044c0b8 - 0x401000)

.org 0x0044c223 - 0x401000
.globl FUN_0044c223
FUN_0044c223:
    # block 0x0044c223: entry, 13 instruction(s), ends with je to 0x0044c252 (forward)
    push ebp                                     # 0044c223
    {load} mov ebp, esp                          # 0044c224
    sub esp, 0x14                                # 0044c226
    mov dword ptr [ebp - local_14], ecx          # 0044c229
    mov eax, dword ptr [ebp + arg_8]             # 0044c22c
    mov ecx, dword ptr [eax]                     # 0044c22f
    mov dword ptr [ebp - local_10], ecx          # 0044c231
    mov edx, dword ptr [eax + field_4]           # 0044c234
    mov dword ptr [ebp - local_c], edx           # 0044c237
    mov eax, dword ptr [eax + field_8]           # 0044c23a
    mov dword ptr [ebp - local_8], eax           # 0044c23d
    cmp dword ptr [ebp + arg_14], 0x0            # 0044c240
    je.d8 L_0044c252                             # 0044c244
    # block 0x0044c246: entered by fall-through of je at 0x0044c244, 4 instruction(s), calls FUN_0044bf8b, falls into the block at 0x0044c252
    lea ecx, [ebp - local_10]                    # 0044c246
    push ecx                                     # 0044c249
    mov ecx, dword ptr [ebp - local_14]          # 0044c24a
    call FUN_0044bf8b                            # 0044c24d
L_0044c252:
    # block 0x0044c252: entered by je at 0x0044c244, 31 instruction(s), calls FUN_0044bfe5, FUN_0044c033, FUN_0044c0b8, FUN_0044bf4b, ends with ret 0x10
    mov edx, dword ptr [ebp + arg_10]            # 0044c252
    push edx                                     # 0044c255
    lea eax, [ebp - local_10]                    # 0044c256
    push eax                                     # 0044c259
    mov ecx, dword ptr [ebp - local_14]          # 0044c25a
    call FUN_0044bfe5                            # 0044c25d
    fstp dword ptr [ebp - local_4]               # 0044c262
    fld dword ptr [ebp - local_4]                # 0044c265
    .insn 0xdc, 0xc0                             # 0044c268
    fstp dword ptr [ebp - local_4]               # 0044c26a
    mov ecx, dword ptr [ebp - local_4]           # 0044c26d
    push ecx                                     # 0044c270
    mov edx, dword ptr [ebp + arg_c]             # 0044c271
    push edx                                     # 0044c274
    mov eax, dword ptr [ebp + arg_10]            # 0044c275
    push eax                                     # 0044c278
    mov ecx, dword ptr [ebp - local_14]          # 0044c279
    call FUN_0044c033                            # 0044c27c
    lea ecx, [ebp - local_10]                    # 0044c281
    push ecx                                     # 0044c284
    mov edx, dword ptr [ebp + arg_c]             # 0044c285
    push edx                                     # 0044c288
    mov ecx, dword ptr [ebp - local_14]          # 0044c289
    call FUN_0044c0b8                            # 0044c28c
    mov eax, dword ptr [ebp + arg_c]             # 0044c291
    push eax                                     # 0044c294
    mov ecx, dword ptr [ebp - local_14]          # 0044c295
    call FUN_0044bf4b                            # 0044c298
    {load} mov esp, ebp                          # 0044c29d
    pop ebp                                      # 0044c29f
    ret 0x10                                     # 0044c2a0

# --- data items (not part of the function) -------------------------
.org 0x0044c2a3 - 0x401000
PAD_0044c2a3:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

