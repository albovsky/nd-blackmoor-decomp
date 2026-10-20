# FUN_004de24f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de24f
# extent:       0x004de24f-0x004de2d8 (137 code bytes)
# span:         0x004de24f-0x004de2d8 (code 137, tables 0, padding 0)
# sha256:       5b182498c0bfafc78f28f9d926d258b23ca72fd8b89985bebf4cc9aeb5c5d546
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_frame_text_box_open
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.h:248 says "0x4de24f(mode, text). The text is the caller's mutable C string."; src/action_family_51.h:63 says "0x4de24f(2, text) on the 0x61f864 frame text-box object."
# name-note:    Opens the frame text box with a mode and a mutable text string.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_991
# callees:      calls FUN_00448d11, FUN_0043dbd5, FUN_004ee673, FUN_004edf96, FUN_004e053f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004e053f, .text + (0x004e053f - 0x401000)
.set FUN_004edf96, .text + (0x004edf96 - 0x401000)
.set FUN_004ee673, .text + (0x004ee673 - 0x401000)

.org 0x004de24f - 0x401000
.globl FUN_004de24f
FUN_004de24f:
    # block 0x004de24f: entry, 13 instruction(s), ends with jbe to 0x004de283 (forward)
    push ebp                                     # 004de24f
    {load} mov ebp, esp                          # 004de250
    push ecx                                     # 004de252
    push edi                                     # 004de253
    mov dword ptr [ebp - local_4], ecx           # 004de254
    mov edi, dword ptr [ebp + arg_c]             # 004de257
    or ecx, -0x1                                 # 004de25a
    {load} xor eax, eax                          # 004de25d
    repne scasb al, byte ptr es:[edi]            # 004de25f
    not ecx                                      # 004de261
    add ecx, -0x1                                # 004de263
    test ecx, ecx                                # 004de266
    jbe.d8 L_004de283                            # 004de268
    # block 0x004de26a: entered by fall-through of jbe at 0x004de268, 8 instruction(s), calls FUN_00448d11, falls into the block at 0x004de283
    push 0x0                                     # 004de26a
    push -0x2                                    # 004de26c
    mov eax, dword ptr [ebp + arg_c]             # 004de26e
    push eax                                     # 004de271
    mov ecx, dword ptr [0x5d03af]                # 004de272
    push ecx                                     # 004de278
    mov ecx, 0x619a05                            # 004de279
    call FUN_00448d11                            # 004de27e
L_004de283:
    # block 0x004de283: entered by jbe at 0x004de268, 21 instruction(s), calls FUN_0043dbd5, FUN_004ee673, FUN_004edf96, FUN_004e053f, ends with ret 0x8
    mov dword ptr [0x5b15d6], 0x1                # 004de283
    mov dword ptr [0x5d17f5], 0x1                # 004de28d
    mov byte ptr [0x5a161f], 0x1                 # 004de297
    call FUN_0043dbd5                            # 004de29e
    push 0x0                                     # 004de2a3
    mov ecx, dword ptr [ebp - local_4]           # 004de2a5
    call FUN_004ee673                            # 004de2a8
    mov edx, dword ptr [ebp - local_4]           # 004de2ad
    mov eax, dword ptr [ebp + arg_8]             # 004de2b0
    mov dword ptr [edx + field_991], eax         # 004de2b3
    mov ecx, dword ptr [ebp + arg_8]             # 004de2b9
    push ecx                                     # 004de2bc
    mov ecx, dword ptr [ebp - local_4]           # 004de2bd
    call FUN_004edf96                            # 004de2c0
    push 0x2                                     # 004de2c5
    mov ecx, 0x570508                            # 004de2c7
    call FUN_004e053f                            # 004de2cc
    pop edi                                      # 004de2d1
    {load} mov esp, ebp                          # 004de2d2
    pop ebp                                      # 004de2d4
    ret 0x8                                      # 004de2d5

