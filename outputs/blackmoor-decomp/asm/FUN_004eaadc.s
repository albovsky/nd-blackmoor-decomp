# FUN_004eaadc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eaadc
# extent:       0x004eaadc-0x004eac4c (368 code bytes)
# span:         0x004eaadc-0x004eac4c (code 368, tables 0, padding 0)
# sha256:       d898dbde05c9472e27c277f78954739b9ce4d644a5bc815c400c5658f99dce1d
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action78_visit
# naming:       native port src/action_family_78_runtime.c:action78_visit (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-16); the note is the acceptance note, a statement about the native port
# name-note:    Native is action78_visit; every branch matches. RT-19 oracle compares effect log and model per case, 0 mismatches. The named test covers null arguments only; behaviour evidence is the oracle.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_2; [edx + n] field_4
# callees:      calls FUN_004e8d96, FUN_004ea06c, FUN_004e9e84
# track-n:      outputs/blackmoor-decomp/src/action_family_78_runtime.c:action78_visit (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 90 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)
.set FUN_004ea06c, .text + (0x004ea06c - 0x401000)

.org 0x004eaadc - 0x401000
.globl FUN_004eaadc
FUN_004eaadc:
    # block 0x004eaadc: entry, 10 instruction(s), ends with je to 0x004eabf9 (forward)
    push ebp                                     # 004eaadc
    {load} mov ebp, esp                          # 004eaadd
    push ecx                                     # 004eaadf
    mov dword ptr [ebp - local_4], ecx           # 004eaae0
    movsx eax, word ptr [ebp + arg_8]            # 004eaae3
    imul eax, eax, 0x8d                          # 004eaae7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eaaed
    movsx edx, word ptr [ecx + field_2]          # 004eaaf3
    test edx, edx                                # 004eaaf7
    je.d32 L_004eabf9                            # 004eaaf9
    # block 0x004eaaff: entered by fall-through of je at 0x004eaaf9, 3 instruction(s), ends with je to 0x004eabc3 (forward)
    movsx eax, word ptr [0x583a29]               # 004eaaff
    cmp eax, -0x1                                # 004eab06
    je.d32 L_004eabc3                            # 004eab09
    # block 0x004eab0f: entered by fall-through of je at 0x004eab09, 6 instruction(s), ends with je to 0x004eab85 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004eab0f
    imul ecx, ecx, 0x8d                          # 004eab13
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004eab19
    movsx eax, word ptr [edx + field_4]          # 004eab1f
    test eax, eax                                # 004eab23
    je.d8 L_004eab85                             # 004eab25
    # block 0x004eab27: entered by fall-through of je at 0x004eab25, 7 instruction(s), ends with je to 0x004eab83 (forward)
    movsx ecx, word ptr [0x583a29]               # 004eab27
    movsx edx, word ptr [ebp + arg_8]            # 004eab2e
    imul edx, edx, 0x8d                          # 004eab32
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004eab38
    movsx edx, word ptr [eax]                    # 004eab3e
    {load} cmp ecx, edx                          # 004eab41
    je.d8 L_004eab83                             # 004eab43
    # block 0x004eab45: entered by fall-through of je at 0x004eab43, 14 instruction(s), calls FUN_004e8d96, FUN_004ea06c, falls into the block at 0x004eab83
    mov ecx, dword ptr [ebp - local_4]           # 004eab45
    call FUN_004e8d96                            # 004eab48
    movsx eax, word ptr [ebp + arg_8]            # 004eab4d
    imul eax, eax, 0x8d                          # 004eab51
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eab57
    mov dx, word ptr [ecx]                       # 004eab5d
    push edx                                     # 004eab60
    mov ecx, dword ptr [ebp - local_4]           # 004eab61
    call FUN_004ea06c                            # 004eab64
    movsx eax, word ptr [ebp + arg_8]            # 004eab69
    imul eax, eax, 0x8d                          # 004eab6d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eab73
    mov dx, word ptr [ecx]                       # 004eab79
    mov word ptr [0x583a29], dx                  # 004eab7c
L_004eab83:
    # block 0x004eab83: entered by je at 0x004eab43, 1 instruction(s), ends with forward jump to 0x004eabc1
    jmp.d8 L_004eabc1                            # 004eab83
L_004eab85:
    # block 0x004eab85: entered by je at 0x004eab25, 7 instruction(s), ends with je to 0x004eabc1 (forward)
    movsx eax, word ptr [0x583a29]               # 004eab85
    movsx ecx, word ptr [ebp + arg_8]            # 004eab8c
    imul ecx, ecx, 0x8d                          # 004eab90
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004eab96
    movsx ecx, word ptr [edx]                    # 004eab9c
    {load} cmp eax, ecx                          # 004eab9f
    je.d8 L_004eabc1                             # 004eaba1
    # block 0x004eaba3: entered by fall-through of je at 0x004eaba1, 8 instruction(s), calls FUN_004e9e84, falls into the block at 0x004eabc1
    push 0x0                                     # 004eaba3
    movsx edx, word ptr [ebp + arg_8]            # 004eaba5
    imul edx, edx, 0x8d                          # 004eaba9
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004eabaf
    mov cx, word ptr [eax]                       # 004eabb5
    push ecx                                     # 004eabb8
    mov ecx, dword ptr [ebp - local_4]           # 004eabb9
    call FUN_004e9e84                            # 004eabbc
L_004eabc1:
    # block 0x004eabc1: entered by jmp at 0x004eab83; je at 0x004eaba1, 1 instruction(s), ends with forward jump to 0x004eabf9
    jmp.d8 L_004eabf9                            # 004eabc1
L_004eabc3:
    # block 0x004eabc3: entered by je at 0x004eab09, 12 instruction(s), calls FUN_004ea06c, falls into the block at 0x004eabf9
    movsx edx, word ptr [ebp + arg_8]            # 004eabc3
    imul edx, edx, 0x8d                          # 004eabc7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004eabcd
    mov cx, word ptr [eax]                       # 004eabd3
    push ecx                                     # 004eabd6
    mov ecx, dword ptr [ebp - local_4]           # 004eabd7
    call FUN_004ea06c                            # 004eabda
    movsx edx, word ptr [ebp + arg_8]            # 004eabdf
    imul edx, edx, 0x8d                          # 004eabe3
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004eabe9
    mov cx, word ptr [eax]                       # 004eabef
    mov word ptr [0x583a29], cx                  # 004eabf2
L_004eabf9:
    # block 0x004eabf9: entered by je at 0x004eaaf9; jmp at 0x004eabc1, 7 instruction(s), ends with je to 0x004eac35 (forward)
    movsx edx, word ptr [0x583a29]               # 004eabf9
    movsx eax, word ptr [ebp + arg_8]            # 004eac00
    imul eax, eax, 0x8d                          # 004eac04
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eac0a
    movsx eax, word ptr [ecx]                    # 004eac10
    {load} cmp edx, eax                          # 004eac13
    je.d8 L_004eac35                             # 004eac15
    # block 0x004eac17: entered by fall-through of je at 0x004eac15, 8 instruction(s), calls FUN_004e9e84, falls into the block at 0x004eac35
    push 0x1                                     # 004eac17
    movsx ecx, word ptr [ebp + arg_8]            # 004eac19
    imul ecx, ecx, 0x8d                          # 004eac1d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004eac23
    mov ax, word ptr [edx]                       # 004eac29
    push eax                                     # 004eac2c
    mov ecx, dword ptr [ebp - local_4]           # 004eac2d
    call FUN_004e9e84                            # 004eac30
L_004eac35:
    # block 0x004eac35: entered by je at 0x004eac15, 6 instruction(s), ends with ret 0x4
    movsx ecx, word ptr [ebp + arg_8]            # 004eac35
    imul ecx, ecx, 0x8d                          # 004eac39
    mov byte ptr [ecx + 0x5bb625], 0x1           # 004eac3f
    {load} mov esp, ebp                          # 004eac46
    pop ebp                                      # 004eac48
    ret 0x4                                      # 004eac49

