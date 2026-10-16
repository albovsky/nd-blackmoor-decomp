# FUN_0052102d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052102d
# extent:       0x0052102d-0x00521077 (74 code bytes)
# span:         0x0052102d-0x00521077 (code 74, tables 0, padding 0)
# sha256:       28325984a4f8e8af439e2659ba36ac84ad1447730f4730aaa9cd45c54bbf9a79
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052102d
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!GetWindowLongA, USER32.dll!GetClassNameA, KERNEL32.dll!lstrcmpiA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0052102d - 0x401000
.globl FUN_0052102d
FUN_0052102d:
    # block 0x0052102d: entry, 5 instruction(s), ends with je to 0x0052104c (forward)
    push ebp                                     # 0052102d
    {load} mov ebp, esp                          # 0052102e
    sub esp, 0xc                                 # 00521030
    cmp dword ptr [ebp + arg_8], 0x0             # 00521033
    je.d8 L_0052104c                             # 00521037
    # block 0x00521039: entered by fall-through of je at 0x00521037, 6 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x00521050 (forward)
    push -0x10                                   # 00521039
    push dword ptr [ebp + arg_8]                 # 0052103b
    call dword ptr [0x52a454]                    # 0052103e
    and eax, 0xf                                 # 00521044
    cmp eax, dword ptr [ebp + arg_c]             # 00521047
    je.d8 L_00521050                             # 0052104a
L_0052104c:
    # block 0x0052104c: entered by je at 0x00521037; fall-through of je at 0x0052104a, 2 instruction(s), ends with forward jump to 0x00521073
    {load} xor eax, eax                          # 0052104c
    jmp.d8 L_00521073                            # 0052104e
L_00521050:
    # block 0x00521050: entered by je at 0x0052104a, 12 instruction(s), calls USER32.dll!GetClassNameA, KERNEL32.dll!lstrcmpiA, falls into the block at 0x00521073
    lea eax, [ebp - local_c]                     # 00521050
    push 0xa                                     # 00521053
    push eax                                     # 00521055
    push dword ptr [ebp + arg_8]                 # 00521056
    call dword ptr [0x52a3b8]                    # 00521059
    lea eax, [ebp - local_c]                     # 0052105f
    push 0x52fe84                                # 00521062
    push eax                                     # 00521067
    call dword ptr [0x52a230]                    # 00521068
    neg eax                                      # 0052106e
    {load} sbb eax, eax                          # 00521070
    inc eax                                      # 00521072
L_00521073:
    # block 0x00521073: entered by jmp at 0x0052104e, 2 instruction(s), ends with ret 0x8
    leave                                        # 00521073
    ret 0x8                                      # 00521074

