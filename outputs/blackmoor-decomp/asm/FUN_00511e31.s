# FUN_00511e31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511e31
# extent:       0x00511e31-0x00511e82 (81 code bytes)
# span:         0x00511e31-0x00511e82 (code 81, tables 0, padding 0)
# sha256:       44b7a47fd466967e627031bbdcb26ae436194d897e0dcf10dddaa1fd2e23fabf
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511e31
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00511ca2, FUN_00511d9e, FUN_00511b7f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00511b7f, .text + (0x00511b7f - 0x401000)
.set FUN_00511ca2, .text + (0x00511ca2 - 0x401000)
.set FUN_00511d9e, .text + (0x00511d9e - 0x401000)

.org 0x00511e31 - 0x401000
.globl FUN_00511e31
FUN_00511e31:
    # block 0x00511e31: entry, 4 instruction(s), ends with je to 0x00511e6c (forward)
    push ebp                                     # 00511e31
    {load} mov ebp, esp                          # 00511e32
    cmp dword ptr [ebp + arg_10], 0x65           # 00511e34
    je.d8 L_00511e6c                             # 00511e38
    # block 0x00511e3a: entered by fall-through of je at 0x00511e38, 2 instruction(s), ends with je to 0x00511e6c (forward)
    cmp dword ptr [ebp + arg_10], 0x45           # 00511e3a
    je.d8 L_00511e6c                             # 00511e3e
    # block 0x00511e40: entered by fall-through of je at 0x00511e3e, 2 instruction(s), ends with jne to 0x00511e59 (forward)
    cmp dword ptr [ebp + arg_10], 0x66           # 00511e40
    jne.d8 L_00511e59                            # 00511e44
    # block 0x00511e46: entered by fall-through of jne at 0x00511e44, 7 instruction(s), calls FUN_00511ca2, ends with ret
    push dword ptr [ebp + arg_14]                # 00511e46
    push dword ptr [ebp + arg_c]                 # 00511e49
    push dword ptr [ebp + arg_8]                 # 00511e4c
    call FUN_00511ca2                            # 00511e4f
    add esp, 0xc                                 # 00511e54
    pop ebp                                      # 00511e57
    ret                                          # 00511e58
L_00511e59:
    # block 0x00511e59: entered by jne at 0x00511e44, 6 instruction(s), calls FUN_00511d9e, ends with forward jump to 0x00511e7d
    push dword ptr [ebp + arg_18]                # 00511e59
    push dword ptr [ebp + arg_14]                # 00511e5c
    push dword ptr [ebp + arg_c]                 # 00511e5f
    push dword ptr [ebp + arg_8]                 # 00511e62
    call FUN_00511d9e                            # 00511e65
    jmp.d8 L_00511e7d                            # 00511e6a
L_00511e6c:
    # block 0x00511e6c: entered by je at 0x00511e38; je at 0x00511e3e, 5 instruction(s), calls FUN_00511b7f, falls into the block at 0x00511e7d
    push dword ptr [ebp + arg_18]                # 00511e6c
    push dword ptr [ebp + arg_14]                # 00511e6f
    push dword ptr [ebp + arg_c]                 # 00511e72
    push dword ptr [ebp + arg_8]                 # 00511e75
    call FUN_00511b7f                            # 00511e78
L_00511e7d:
    # block 0x00511e7d: entered by jmp at 0x00511e6a, 3 instruction(s), ends with ret
    add esp, 0x10                                # 00511e7d
    pop ebp                                      # 00511e80
    ret                                          # 00511e81

