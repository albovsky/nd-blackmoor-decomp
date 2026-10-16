# FUN_00510984
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510984
# extent:       0x00510984-0x00510a29 (165 code bytes)
# span:         0x00510984-0x00510a29 (code 165, tables 0, padding 0)
# sha256:       a896d3afd1322013b2f1279f474d2aab4b953cbc52cf7c0a76a9b91e625d4c2e
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510984
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       8 ebp-relative slot(s): local_4, local_10, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_6c, field_70; [esi + n] field_minus_4
# callees:      calls FUN_00510dd3, FUN_0050c6fc, FUN_00510a51
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510a29
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0050c6fc, .text + (0x0050c6fc - 0x401000)
.set FUN_00510a51, .text + (0x00510a51 - 0x401000)
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x00510984 - 0x401000
.globl FUN_00510984
FUN_00510984:
    # block 0x00510984: entry, 52 instruction(s), calls FUN_00510dd3, FUN_0050c6fc, FUN_00510a51, ends with ret
    push ebp                                     # 00510984
    {load} mov ebp, esp                          # 00510985
    push -0x1                                    # 00510987
    push 0x5303d0                                # 00510989
    push 0x511930                                # 0051098e
    mov eax, dword ptr fs:[0x0]                  # 00510993
    push eax                                     # 00510999
    mov dword ptr fs:[0x0], esp                  # 0051099a
    sub esp, 0x1c                                # 005109a1
    push ebx                                     # 005109a4
    push esi                                     # 005109a5
    push edi                                     # 005109a6
    mov dword ptr [ebp - local_18], esp          # 005109a7
    mov ebx, dword ptr [ebp + arg_18]            # 005109aa
    mov dword ptr [ebp - local_2c], ebx          # 005109ad
    and dword ptr [ebp - local_24], 0x0          # 005109b0
    mov esi, dword ptr [ebp + arg_c]             # 005109b4
    mov eax, dword ptr [esi - field_minus_4]     # 005109b7
    mov dword ptr [ebp - local_28], eax          # 005109ba
    call FUN_00510dd3                            # 005109bd
    mov eax, dword ptr [eax + field_6c]          # 005109c2
    mov dword ptr [ebp - local_1c], eax          # 005109c5
    call FUN_00510dd3                            # 005109c8
    mov eax, dword ptr [eax + field_70]          # 005109cd
    mov dword ptr [ebp - local_20], eax          # 005109d0
    call FUN_00510dd3                            # 005109d3
    mov edi, dword ptr [ebp + arg_8]             # 005109d8
    mov dword ptr [eax + field_6c], edi          # 005109db
    call FUN_00510dd3                            # 005109de
    mov ecx, dword ptr [ebp + arg_10]            # 005109e3
    mov dword ptr [eax + field_70], ecx          # 005109e6
    and dword ptr [ebp - local_4], 0x0           # 005109e9
    mov dword ptr [ebp - local_4], 0x1           # 005109ed
    push dword ptr [ebp + arg_20]                # 005109f4
    push dword ptr [ebp + arg_1c]                # 005109f7
    push ebx                                     # 005109fa
    push dword ptr [ebp + arg_14]                # 005109fb
    push esi                                     # 005109fe
    call FUN_0050c6fc                            # 005109ff
    add esp, 0x14                                # 00510a04
    mov dword ptr [ebp - local_2c], eax          # 00510a07
    and dword ptr [ebp - local_4], 0x0           # 00510a0a
    or dword ptr [ebp - local_4], -0x1           # 00510a0e
    call FUN_00510a51                            # 00510a12
    mov eax, dword ptr [ebp - local_2c]          # 00510a17
    mov ecx, dword ptr [ebp - local_10]          # 00510a1a
    mov dword ptr fs:[0x0], ecx                  # 00510a1d
    pop edi                                      # 00510a24
    pop esi                                      # 00510a25
    pop ebx                                      # 00510a26
    leave                                        # 00510a27
    ret                                          # 00510a28

