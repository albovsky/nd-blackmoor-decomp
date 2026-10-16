# FUN_0050f997
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f997
# extent:       0x0050f997-0x0050f9d1 (58 code bytes)
# span:         0x0050f997-0x0050f9e0 (code 58, tables 0, padding 15)
# sha256:       a3fa598186f386f17ec3820b38c12f5bd276c233e7a8088e1fab387087fa0125
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f997
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_1c, local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!RaiseException
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050f997 - 0x401000
.globl FUN_0050f997
FUN_0050f997:
    # block 0x0050f997: entry, 24 instruction(s), calls KERNEL32.dll!RaiseException, ends with ret 0x8
    push ebp                                     # 0050f997
    {load} mov ebp, esp                          # 0050f998
    sub esp, 0x20                                # 0050f99a
    mov eax, dword ptr [ebp + arg_8]             # 0050f99d
    push esi                                     # 0050f9a0
    push edi                                     # 0050f9a1
    push 0x8                                     # 0050f9a2
    pop ecx                                      # 0050f9a4
    mov esi, 0x530270                            # 0050f9a5
    lea edi, [ebp - local_20]                    # 0050f9aa
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0050f9ad
    mov dword ptr [ebp - local_8], eax           # 0050f9af
    mov eax, dword ptr [ebp + arg_c]             # 0050f9b2
    mov dword ptr [ebp - local_4], eax           # 0050f9b5
    lea eax, [ebp - local_c]                     # 0050f9b8
    push eax                                     # 0050f9bb
    push dword ptr [ebp - local_10]              # 0050f9bc
    push dword ptr [ebp - local_1c]              # 0050f9bf
    push dword ptr [ebp - local_20]              # 0050f9c2
    call dword ptr [0x52a158]                    # 0050f9c5
    pop edi                                      # 0050f9cb
    pop esi                                      # 0050f9cc
    leave                                        # 0050f9cd
    ret 0x8                                      # 0050f9ce

# --- data items (not part of the function) -------------------------
.org 0x0050f9d1 - 0x401000
PAD_0050f9d1:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

