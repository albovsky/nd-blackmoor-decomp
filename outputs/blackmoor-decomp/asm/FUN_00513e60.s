# FUN_00513e60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513e60
# extent:       0x00513e60-0x00513ef8 (152 code bytes)
# span:         0x00513e60-0x00513ef8 (code 152, tables 0, padding 0)
# sha256:       ff2eeb772feed2af137f739a2513d3b2eaf3814cad4051bb05c32f14629113e7
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513e60
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_18, arg_20; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_20, local_58
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514250, FUN_00513f9d, FUN_0051453c, FUN_00514467, FUN_005144ef, FUN_005146dc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_20, 0x20  # offset -0x20
.equ local_58, 0x58  # offset -0x58
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_18, 0x18  # offset +0x18
.equ arg_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00513f9d, .text + (0x00513f9d - 0x401000)
.set FUN_00514250, .text + (0x00514250 - 0x401000)
.set FUN_00514467, .text + (0x00514467 - 0x401000)
.set FUN_005144ef, .text + (0x005144ef - 0x401000)
.set FUN_0051453c, .text + (0x0051453c - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x00513e60 - 0x401000
.globl FUN_00513e60
FUN_00513e60:
    # block 0x00513e60: entry, 11 instruction(s), calls FUN_00514250, ends with jne to 0x00513e9e (forward)
    push ebp                                     # 00513e60
    {load} mov ebp, esp                          # 00513e61
    sub esp, 0x58                                # 00513e63
    push dword ptr [ebp + arg_20]                # 00513e66
    lea eax, [ebp + arg_18]                      # 00513e69
    push eax                                     # 00513e6c
    push dword ptr [ebp + arg_8]                 # 00513e6d
    call FUN_00514250                            # 00513e70
    add esp, 0xc                                 # 00513e75
    test eax, eax                                # 00513e78
    jne.d8 L_00513e9e                            # 00513e7a
    # block 0x00513e7c: entered by fall-through of jne at 0x00513e7a, 13 instruction(s), calls FUN_00513f9d, falls into the block at 0x00513e9e
    lea eax, [ebp + arg_18]                      # 00513e7c
    and dword ptr [ebp - local_20], -0x2         # 00513e7f
    push eax                                     # 00513e83
    lea eax, [ebp + arg_10]                      # 00513e84
    push eax                                     # 00513e87
    lea eax, [ebp + arg_20]                      # 00513e88
    push dword ptr [ebp + arg_c]                 # 00513e8b
    push dword ptr [ebp + arg_8]                 # 00513e8e
    push eax                                     # 00513e91
    lea eax, [ebp - local_58]                    # 00513e92
    push eax                                     # 00513e95
    call FUN_00513f9d                            # 00513e96
    add esp, 0x18                                # 00513e9b
L_00513e9e:
    # block 0x00513e9e: entered by jne at 0x00513e7a, 5 instruction(s), calls FUN_0051453c, ends with jne to 0x00513edc (forward)
    push dword ptr [ebp + arg_8]                 # 00513e9e
    call FUN_0051453c                            # 00513ea1
    cmp dword ptr [0x568e30], 0x0                # 00513ea6
    pop ecx                                      # 00513ead
    jne.d8 L_00513edc                            # 00513eae
    # block 0x00513eb0: entered by fall-through of jne at 0x00513eae, 2 instruction(s), ends with je to 0x00513edc (forward)
    test eax, eax                                # 00513eb0
    je.d8 L_00513edc                             # 00513eb2
    # block 0x00513eb4: entered by fall-through of je at 0x00513eb2, 19 instruction(s), calls FUN_00514467, ends with ret
    push dword ptr [ebp + arg_20]                # 00513eb4
    fld qword ptr [ebp + arg_18]                 # 00513eb7
    push ecx                                     # 00513eba
    push ecx                                     # 00513ebb
    fstp qword ptr [esp]                         # 00513ebc
    push ecx                                     # 00513ebf
    push ecx                                     # 00513ec0
    fldz                                         # 00513ec1
    fstp qword ptr [esp]                         # 00513ec3
    fld qword ptr [ebp + arg_10]                 # 00513ec6
    push ecx                                     # 00513ec9
    push ecx                                     # 00513eca
    fstp qword ptr [esp]                         # 00513ecb
    push dword ptr [ebp + arg_c]                 # 00513ece
    push eax                                     # 00513ed1
    call FUN_00514467                            # 00513ed2
    add esp, 0x24                                # 00513ed7
    leave                                        # 00513eda
    ret                                          # 00513edb
L_00513edc:
    # block 0x00513edc: entered by jne at 0x00513eae; je at 0x00513eb2, 10 instruction(s), calls FUN_005144ef, FUN_005146dc, ends with ret
    push eax                                     # 00513edc
    call FUN_005144ef                            # 00513edd
    mov dword ptr [esp], 0xffff                  # 00513ee2
    push dword ptr [ebp + arg_20]                # 00513ee9
    call FUN_005146dc                            # 00513eec
    fld qword ptr [ebp + arg_18]                 # 00513ef1
    pop ecx                                      # 00513ef4
    pop ecx                                      # 00513ef5
    leave                                        # 00513ef6
    ret                                          # 00513ef7

