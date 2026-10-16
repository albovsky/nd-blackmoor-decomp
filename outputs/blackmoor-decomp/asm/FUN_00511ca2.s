# FUN_00511ca2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511ca2
# extent:       0x00511ca2-0x00511cf7 (85 code bytes)
# span:         0x00511ca2-0x00511cf7 (code 85, tables 0, padding 0)
# sha256:       31694f4cdb27ad5fce55d488dabec03d60d207411afe9830500a2002802d9a4b
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511ca2
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_c, local_10, local_28
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00516e4e, FUN_00516dd7, FUN_00511cf7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_28, 0x28  # offset -0x28
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00511cf7, .text + (0x00511cf7 - 0x401000)
.set FUN_00516dd7, .text + (0x00516dd7 - 0x401000)
.set FUN_00516e4e, .text + (0x00516e4e - 0x401000)

.org 0x00511ca2 - 0x401000
.globl FUN_00511ca2
FUN_00511ca2:
    # block 0x00511ca2: entry, 37 instruction(s), calls FUN_00516e4e, FUN_00516dd7, FUN_00511cf7, ends with ret
    push ebp                                     # 00511ca2
    {load} mov ebp, esp                          # 00511ca3
    sub esp, 0x28                                # 00511ca5
    lea eax, [ebp - local_28]                    # 00511ca8
    push esi                                     # 00511cab
    push eax                                     # 00511cac
    lea eax, [ebp - local_10]                    # 00511cad
    push eax                                     # 00511cb0
    mov eax, dword ptr [ebp + arg_8]             # 00511cb1
    push ecx                                     # 00511cb4
    push ecx                                     # 00511cb5
    fld qword ptr [eax]                          # 00511cb6
    fstp qword ptr [esp]                         # 00511cb8
    call FUN_00516e4e                            # 00511cbb
    mov esi, dword ptr [ebp + arg_10]            # 00511cc0
    lea eax, [ebp - local_10]                    # 00511cc3
    push eax                                     # 00511cc6
    mov eax, dword ptr [ebp - local_c]           # 00511cc7
    {load} add eax, esi                          # 00511cca
    push eax                                     # 00511ccc
    {load} xor eax, eax                          # 00511ccd
    cmp dword ptr [ebp - local_10], 0x2d         # 00511ccf
    sete al                                      # 00511cd3
    add eax, dword ptr [ebp + arg_c]             # 00511cd6
    push eax                                     # 00511cd9
    call FUN_00516dd7                            # 00511cda
    lea eax, [ebp - local_10]                    # 00511cdf
    push 0x0                                     # 00511ce2
    push eax                                     # 00511ce4
    push esi                                     # 00511ce5
    push dword ptr [ebp + arg_c]                 # 00511ce6
    call FUN_00511cf7                            # 00511ce9
    mov eax, dword ptr [ebp + arg_c]             # 00511cee
    add esp, 0x2c                                # 00511cf1
    pop esi                                      # 00511cf4
    leave                                        # 00511cf5
    ret                                          # 00511cf6

