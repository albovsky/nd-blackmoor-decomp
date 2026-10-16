# FUN_00513ef8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513ef8
# extent:       0x00513ef8-0x00513f9d (165 code bytes)
# span:         0x00513ef8-0x00513f9d (code 165, tables 0, padding 0)
# sha256:       ecfb86ed82f65bef6cfcc51ed16dcb2a90952af774007971fafa5313983dd12a
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513ef8
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_18, arg_20, arg_28; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_20, local_30, local_58
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514250, FUN_00513f9d, FUN_0051453c, FUN_00514467, FUN_005144ef, FUN_005146dc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_20, 0x20  # offset -0x20
.equ local_30, 0x30  # offset -0x30
.equ local_58, 0x58  # offset -0x58
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_18, 0x18  # offset +0x18
.equ arg_20, 0x20  # offset +0x20
.equ arg_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_00513f9d, .text + (0x00513f9d - 0x401000)
.set FUN_00514250, .text + (0x00514250 - 0x401000)
.set FUN_00514467, .text + (0x00514467 - 0x401000)
.set FUN_005144ef, .text + (0x005144ef - 0x401000)
.set FUN_0051453c, .text + (0x0051453c - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x00513ef8 - 0x401000
.globl FUN_00513ef8
FUN_00513ef8:
    # block 0x00513ef8: entry, 11 instruction(s), calls FUN_00514250, ends with jne to 0x00513f42 (forward)
    push ebp                                     # 00513ef8
    {load} mov ebp, esp                          # 00513ef9
    sub esp, 0x58                                # 00513efb
    push dword ptr [ebp + arg_28]                # 00513efe
    lea eax, [ebp + arg_20]                      # 00513f01
    push eax                                     # 00513f04
    push dword ptr [ebp + arg_8]                 # 00513f05
    call FUN_00514250                            # 00513f08
    add esp, 0xc                                 # 00513f0d
    test eax, eax                                # 00513f10
    jne.d8 L_00513f42                            # 00513f12
    # block 0x00513f14: entered by fall-through of jne at 0x00513f12, 18 instruction(s), calls FUN_00513f9d, falls into the block at 0x00513f42
    mov eax, dword ptr [ebp - local_20]          # 00513f14
    and al, -0x1d                                # 00513f17
    or al, 0x3                                   # 00513f19
    mov dword ptr [ebp - local_20], eax          # 00513f1b
    lea eax, [ebp + arg_20]                      # 00513f1e
    push eax                                     # 00513f21
    lea eax, [ebp + arg_10]                      # 00513f22
    push eax                                     # 00513f25
    lea eax, [ebp + arg_28]                      # 00513f26
    push dword ptr [ebp + arg_c]                 # 00513f29
    fld qword ptr [ebp + arg_18]                 # 00513f2c
    push dword ptr [ebp + arg_8]                 # 00513f2f
    fstp qword ptr [ebp - local_30]              # 00513f32
    push eax                                     # 00513f35
    lea eax, [ebp - local_58]                    # 00513f36
    push eax                                     # 00513f39
    call FUN_00513f9d                            # 00513f3a
    add esp, 0x18                                # 00513f3f
L_00513f42:
    # block 0x00513f42: entered by jne at 0x00513f12, 5 instruction(s), calls FUN_0051453c, ends with jne to 0x00513f81 (forward)
    push dword ptr [ebp + arg_8]                 # 00513f42
    call FUN_0051453c                            # 00513f45
    cmp dword ptr [0x568e30], 0x0                # 00513f4a
    pop ecx                                      # 00513f51
    jne.d8 L_00513f81                            # 00513f52
    # block 0x00513f54: entered by fall-through of jne at 0x00513f52, 2 instruction(s), ends with je to 0x00513f81 (forward)
    test eax, eax                                # 00513f54
    je.d8 L_00513f81                             # 00513f56
    # block 0x00513f58: entered by fall-through of je at 0x00513f56, 19 instruction(s), calls FUN_00514467, ends with ret
    push dword ptr [ebp + arg_28]                # 00513f58
    fld qword ptr [ebp + arg_20]                 # 00513f5b
    push ecx                                     # 00513f5e
    push ecx                                     # 00513f5f
    fstp qword ptr [esp]                         # 00513f60
    fld qword ptr [ebp + arg_18]                 # 00513f63
    push ecx                                     # 00513f66
    push ecx                                     # 00513f67
    fstp qword ptr [esp]                         # 00513f68
    fld qword ptr [ebp + arg_10]                 # 00513f6b
    push ecx                                     # 00513f6e
    push ecx                                     # 00513f6f
    fstp qword ptr [esp]                         # 00513f70
    push dword ptr [ebp + arg_c]                 # 00513f73
    push eax                                     # 00513f76
    call FUN_00514467                            # 00513f77
    add esp, 0x24                                # 00513f7c
    leave                                        # 00513f7f
    ret                                          # 00513f80
L_00513f81:
    # block 0x00513f81: entered by jne at 0x00513f52; je at 0x00513f56, 10 instruction(s), calls FUN_005144ef, FUN_005146dc, ends with ret
    push eax                                     # 00513f81
    call FUN_005144ef                            # 00513f82
    mov dword ptr [esp], 0xffff                  # 00513f87
    push dword ptr [ebp + arg_28]                # 00513f8e
    call FUN_005146dc                            # 00513f91
    fld qword ptr [ebp + arg_20]                 # 00513f96
    pop ecx                                      # 00513f99
    pop ecx                                      # 00513f9a
    leave                                        # 00513f9b
    ret                                          # 00513f9c

