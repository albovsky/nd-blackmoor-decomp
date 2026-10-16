# FUN_00511b7f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511b7f
# extent:       0x00511b7f-0x00511be0 (97 code bytes)
# span:         0x00511b7f-0x00511be0 (code 97, tables 0, padding 0)
# sha256:       33eceb7ea038047cc31aaff189b4da0f2f422879a2f9cd2ff99d1c2377502ac8
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511b7f
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_10, local_28
# fields:       [esi + n] field_1
# callees:      calls FUN_00516e4e, FUN_00516dd7, FUN_00511be0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ local_28, 0x28  # offset -0x28
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00511be0, .text + (0x00511be0 - 0x401000)
.set FUN_00516dd7, .text + (0x00516dd7 - 0x401000)
.set FUN_00516e4e, .text + (0x00516e4e - 0x401000)

.org 0x00511b7f - 0x401000
.globl FUN_00511b7f
FUN_00511b7f:
    # block 0x00511b7f: entry, 42 instruction(s), calls FUN_00516e4e, FUN_00516dd7, FUN_00511be0, ends with ret
    push ebp                                     # 00511b7f
    {load} mov ebp, esp                          # 00511b80
    sub esp, 0x28                                # 00511b82
    lea eax, [ebp - local_28]                    # 00511b85
    push esi                                     # 00511b88
    push eax                                     # 00511b89
    lea eax, [ebp - local_10]                    # 00511b8a
    push eax                                     # 00511b8d
    mov eax, dword ptr [ebp + arg_8]             # 00511b8e
    push ecx                                     # 00511b91
    push ecx                                     # 00511b92
    fld qword ptr [eax]                          # 00511b93
    fstp qword ptr [esp]                         # 00511b95
    call FUN_00516e4e                            # 00511b98
    mov esi, dword ptr [ebp + arg_10]            # 00511b9d
    lea eax, [ebp - local_10]                    # 00511ba0
    push eax                                     # 00511ba3
    mov edx, dword ptr [ebp + arg_c]             # 00511ba4
    lea eax, [esi + field_1]                     # 00511ba7
    push eax                                     # 00511baa
    {load} xor eax, eax                          # 00511bab
    cmp dword ptr [ebp - local_10], 0x2d         # 00511bad
    sete al                                      # 00511bb1
    {load} xor ecx, ecx                          # 00511bb4
    test esi, esi                                # 00511bb6
    setg cl                                      # 00511bb8
    {load} add edx, eax                          # 00511bbb
    {load} add ecx, edx                          # 00511bbd
    push ecx                                     # 00511bbf
    call FUN_00516dd7                            # 00511bc0
    lea eax, [ebp - local_10]                    # 00511bc5
    push 0x0                                     # 00511bc8
    push eax                                     # 00511bca
    push dword ptr [ebp + arg_14]                # 00511bcb
    push esi                                     # 00511bce
    push dword ptr [ebp + arg_c]                 # 00511bcf
    call FUN_00511be0                            # 00511bd2
    mov eax, dword ptr [ebp + arg_c]             # 00511bd7
    add esp, 0x30                                # 00511bda
    pop esi                                      # 00511bdd
    leave                                        # 00511bde
    ret                                          # 00511bdf

