# FUN_0051f7a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f7a0
# extent:       0x0051f7a0-0x0051f805 (101 code bytes)
# span:         0x0051f7a0-0x0051f805 (code 101, tables 0, padding 0)
# sha256:       e63c3affdfa9e96d6dfb07474278a85248fc561f1699bf99dd6287ba5c8278fd
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f7a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_c, field_minus_10; [esi + n] field_4, field_20, field_3c, field_40, field_44
# callees:      calls FUN_0050f978, FUN_0051a40a, FUN_0051a44d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_20, 0x20  # offset +0x20
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a40a, .text + (0x0051a40a - 0x401000)
.set FUN_0051a44d, .text + (0x0051a44d - 0x401000)

.org 0x0051f7a0 - 0x401000
.globl FUN_0051f7a0
FUN_0051f7a0:
    # block 0x0051f7a0: entry, 34 instruction(s), calls FUN_0050f978, FUN_0051a40a, FUN_0051a44d, ends with ret 0xc
    mov eax, 0x52908e                            # 0051f7a0
    call FUN_0050f978                            # 0051f7a5
    push ecx                                     # 0051f7aa
    push esi                                     # 0051f7ab
    {load} mov esi, ecx                          # 0051f7ac
    push edi                                     # 0051f7ae
    push 0xa                                     # 0051f7af
    lea ecx, [esi + field_4]                     # 0051f7b1
    mov dword ptr [ebp - field_minus_10], esi    # 0051f7b4
    call FUN_0051a40a                            # 0051f7b7
    and dword ptr [ebp - field_minus_4], 0x0     # 0051f7bc
    lea edi, [esi + field_20]                    # 0051f7c0
    push 0x4                                     # 0051f7c3
    {load} mov ecx, edi                          # 0051f7c5
    call FUN_0051a40a                            # 0051f7c7
    push 0x0                                     # 0051f7cc
    push 0x7                                     # 0051f7ce
    {load} mov ecx, edi                          # 0051f7d0
    mov byte ptr [ebp - field_minus_4], 0x1      # 0051f7d2
    mov dword ptr [esi], 0x52fe80                # 0051f7d6
    call FUN_0051a44d                            # 0051f7dc
    mov eax, dword ptr [ebp + field_8]           # 0051f7e1
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051f7e4
    mov dword ptr [esi + field_3c], eax          # 0051f7e7
    mov eax, dword ptr [ebp + field_c]           # 0051f7ea
    mov dword ptr [esi + field_40], eax          # 0051f7ed
    mov eax, dword ptr [ebp + field_10]          # 0051f7f0
    mov dword ptr [esi + field_44], eax          # 0051f7f3
    {load} mov eax, esi                          # 0051f7f6
    pop edi                                      # 0051f7f8
    pop esi                                      # 0051f7f9
    mov dword ptr fs:[0x0], ecx                  # 0051f7fa
    leave                                        # 0051f801
    ret 0xc                                      # 0051f802

