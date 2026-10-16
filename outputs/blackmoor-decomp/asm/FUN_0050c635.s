# FUN_0050c635
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c635
# extent:       0x0050c635-0x0050c662 (45 code bytes)
# span:         0x0050c635-0x0050c662 (code 45, tables 0, padding 0)
# sha256:       b49041c40c906d03627285a28e73db85a5aa2afb30c781c280caed2ef99391b4
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c635
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ebx + n] field_minus_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c662
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050c635 - 0x401000
.globl FUN_0050c635
FUN_0050c635:
    # block 0x0050c635: entry, 17 instruction(s), ends with indirect jump eax
    push ebp                                     # 0050c635
    {load} mov ebp, esp                          # 0050c636
    push ecx                                     # 0050c638
    push ebx                                     # 0050c639
    push esi                                     # 0050c63a
    push edi                                     # 0050c63b
    mov eax, dword ptr [ebp + arg_c]             # 0050c63c
    add eax, 0xc                                 # 0050c63f
    mov dword ptr [ebp - local_4], eax           # 0050c642
    mov ebx, dword ptr fs:[0x0]                  # 0050c645
    mov eax, dword ptr [ebx]                     # 0050c64c
    mov dword ptr fs:[0x0], eax                  # 0050c64e
    mov eax, dword ptr [ebp + arg_8]             # 0050c654
    mov ebx, dword ptr [ebp + arg_c]             # 0050c657
    mov esp, dword ptr [ebx - field_minus_4]     # 0050c65a
    mov ebp, dword ptr [ebp - local_4]           # 0050c65d
    jmp eax                                      # 0050c660

