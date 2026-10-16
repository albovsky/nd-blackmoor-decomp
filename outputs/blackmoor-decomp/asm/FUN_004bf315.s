# FUN_004bf315
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf315
# extent:       0x004bf315-0x004bf38c (119 code bytes)
# span:         0x004bf315-0x004bf38c (code 119, tables 0, padding 0)
# sha256:       243b91165921af0771acdea9476fd6f1e5ce1afba97cbed26f60887ad32ad021
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bf315
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2c0
# callees:      calls FUN_004bf38c, FUN_004bede7, binkw32.dll!_BinkOpen@8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bede7, .text + (0x004bede7 - 0x401000)
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bf315 - 0x401000
.globl FUN_004bf315
FUN_004bf315:
    # block 0x004bf315: entry, 18 instruction(s), calls FUN_004bf38c, FUN_004bede7, ends with jne to 0x004bf35a (forward)
    push ebp                                     # 004bf315
    {load} mov ebp, esp                          # 004bf316
    sub esp, 0x8                                 # 004bf318
    push edi                                     # 004bf31b
    mov dword ptr [ebp - local_8], ecx           # 004bf31c
    mov dword ptr [ebp - local_4], 0x0           # 004bf31f
    mov ecx, dword ptr [ebp - local_8]           # 004bf326
    call FUN_004bf38c                            # 004bf329
    mov ecx, dword ptr [ebp - local_8]           # 004bf32e
    call FUN_004bede7                            # 004bf331
    mov edi, dword ptr [ebp + arg_8]             # 004bf336
    or ecx, -0x1                                 # 004bf339
    {load} xor eax, eax                          # 004bf33c
    repne scasb al, byte ptr es:[edi]            # 004bf33e
    not ecx                                      # 004bf340
    add ecx, -0x1                                # 004bf342
    test ecx, ecx                                # 004bf345
    jne.d8 L_004bf35a                            # 004bf347
    # block 0x004bf349: entered by fall-through of jne at 0x004bf347, 4 instruction(s), ends with forward jump to 0x004bf385
    mov eax, dword ptr [ebp - local_8]           # 004bf349
    mov dword ptr [eax + field_2c0], 0xfffffffb  # 004bf34c
    {load} xor eax, eax                          # 004bf356
    jmp.d8 L_004bf385                            # 004bf358
L_004bf35a:
    # block 0x004bf35a: entered by jne at 0x004bf347, 8 instruction(s), calls binkw32.dll!_BinkOpen@8, ends with jne to 0x004bf382 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004bf35a
    push ecx                                     # 004bf35d
    mov edx, dword ptr [ebp + arg_8]             # 004bf35e
    push edx                                     # 004bf361
    call dword ptr [0x52a518]                    # 004bf362
    mov dword ptr [ebp - local_4], eax           # 004bf368
    cmp dword ptr [ebp - local_4], 0x0           # 004bf36b
    jne.d8 L_004bf382                            # 004bf36f
    # block 0x004bf371: entered by fall-through of jne at 0x004bf36f, 4 instruction(s), ends with forward jump to 0x004bf385
    mov eax, dword ptr [ebp - local_8]           # 004bf371
    mov dword ptr [eax + field_2c0], 0xfffffffa  # 004bf374
    {load} xor eax, eax                          # 004bf37e
    jmp.d8 L_004bf385                            # 004bf380
L_004bf382:
    # block 0x004bf382: entered by jne at 0x004bf36f, 1 instruction(s), falls into the block at 0x004bf385
    mov eax, dword ptr [ebp - local_4]           # 004bf382
L_004bf385:
    # block 0x004bf385: entered by jmp at 0x004bf358; jmp at 0x004bf380, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004bf385
    {load} mov esp, ebp                          # 004bf386
    pop ebp                                      # 004bf388
    ret 0x8                                      # 004bf389

