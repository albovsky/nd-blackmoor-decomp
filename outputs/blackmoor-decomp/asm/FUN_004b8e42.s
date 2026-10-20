# FUN_004b8e42
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8e42
# extent:       0x004b8e42-0x004b8e92 (80 code bytes)
# span:         0x004b8e42-0x004b8e92 (code 80, tables 0, padding 0)
# sha256:       5a922b613325a8067cecd45ca5286e05021bbd89ee5c71a8ead93d838db033a9
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b8e42_expire_slot
# naming:       native port src/original_methods_fl16.c:m4b8e42_expire_slot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4b8e42_expire_slot. Direct test plus a differential test against the original bytes (Unicorn), every original instruction reached. Oracle window runs all 80 bytes. Direct test covers slot -1.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_48, field_7d; [ecx + n] field_48
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004b8a27
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4b8e42_expire_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_48, 0x48  # offset +0x48
.equ field_7d, 0x7d  # offset +0x7d

# --- external targets -----------------------------------------------
.set FUN_004b8a27, .text + (0x004b8a27 - 0x401000)

.org 0x004b8e42 - 0x401000
.globl FUN_004b8e42
FUN_004b8e42:
    # block 0x004b8e42: entry, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b8e8c (forward)
    push ebp                                     # 004b8e42
    {load} mov ebp, esp                          # 004b8e43
    push ecx                                     # 004b8e45
    mov dword ptr [ebp - local_4], ecx           # 004b8e46
    call dword ptr [0x52a23c]                    # 004b8e49
    movsx ecx, word ptr [ebp + arg_8]            # 004b8e4f
    imul ecx, ecx, 0x37                          # 004b8e53
    cmp eax, dword ptr [ecx + 0x61eee1]          # 004b8e56
    jb.d8 L_004b8e8c                             # 004b8e5c
    # block 0x004b8e5e: entered by fall-through of jb at 0x004b8e5c, 12 instruction(s), calls FUN_004b8a27, falls into the block at 0x004b8e8c
    movsx edx, word ptr [ebp + arg_8]            # 004b8e5e
    imul edx, edx, 0x37                          # 004b8e62
    mov eax, dword ptr [ebp - local_4]           # 004b8e65
    mov dword ptr [eax + edx + field_7d], 0x3    # 004b8e68
    mov ecx, dword ptr [ebp - local_4]           # 004b8e70
    mov dx, word ptr [ecx + field_48]            # 004b8e73
    sub dx, 0x1                                  # 004b8e77
    mov eax, dword ptr [ebp - local_4]           # 004b8e7b
    mov word ptr [eax + field_48], dx            # 004b8e7e
    push 0x2                                     # 004b8e82
    mov ecx, dword ptr [ebp - local_4]           # 004b8e84
    call FUN_004b8a27                            # 004b8e87
L_004b8e8c:
    # block 0x004b8e8c: entered by jb at 0x004b8e5c, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004b8e8c
    pop ebp                                      # 004b8e8e
    ret 0x4                                      # 004b8e8f

