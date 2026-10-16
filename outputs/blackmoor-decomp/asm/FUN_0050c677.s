# FUN_0050c677
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c677
# extent:       0x0050c677-0x0050c6c6 (79 code bytes)
# span:         0x0050c677-0x0050c6c6 (code 79, tables 0, padding 0)
# sha256:       be31cf428ef3beb05470caa368c8e0d3d7d0c2bb147aa57bf3460921a1a7c9b1
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c677
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [ecx + n] field_4
# callees:      calls FUN_00519a24
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00519a24, .text + (0x00519a24 - 0x401000)

.org 0x0050c677 - 0x401000
.globl FUN_0050c677
FUN_0050c677:
    # block 0x0050c677: entry, 29 instruction(s), calls FUN_00519a24, ends with ret 0x8
    push ebp                                     # 0050c677
    {load} mov ebp, esp                          # 0050c678
    push ecx                                     # 0050c67a
    push ecx                                     # 0050c67b
    push ebx                                     # 0050c67c
    push esi                                     # 0050c67d
    push edi                                     # 0050c67e
    mov eax, dword ptr fs:[0x0]                  # 0050c67f
    mov dword ptr [ebp - local_8], eax           # 0050c685
    mov dword ptr [ebp - local_4], 0x50c69f      # 0050c688
    push 0x0                                     # 0050c68f
    push dword ptr [ebp + arg_c]                 # 0050c691
    push dword ptr [ebp - local_4]               # 0050c694
    push dword ptr [ebp + arg_8]                 # 0050c697
    call FUN_00519a24                            # 0050c69a
    mov eax, dword ptr [ebp + arg_c]             # 0050c69f
    mov eax, dword ptr [eax + field_4]           # 0050c6a2
    and al, -0x3                                 # 0050c6a5
    mov ecx, dword ptr [ebp + arg_c]             # 0050c6a7
    mov dword ptr [ecx + field_4], eax           # 0050c6aa
    mov eax, dword ptr fs:[0x0]                  # 0050c6ad
    mov ebx, dword ptr [ebp - local_8]           # 0050c6b3
    mov dword ptr [ebx], eax                     # 0050c6b6
    mov dword ptr fs:[0x0], ebx                  # 0050c6b8
    pop edi                                      # 0050c6bf
    pop esi                                      # 0050c6c0
    pop ebx                                      # 0050c6c1
    leave                                        # 0050c6c2
    ret 0x8                                      # 0050c6c3

