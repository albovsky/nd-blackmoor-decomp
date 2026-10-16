# FUN_00513e00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513e00
# extent:       0x00513e00-0x00513e60 (96 code bytes)
# span:         0x00513e00-0x00513e60 (code 96, tables 0, padding 0)
# sha256:       c4604c39fa94b7938b8cfb831adeeb6e904d35f44b0534cdf8e83fe9cccc55c8
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513e00
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_14, arg_1c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514467, FUN_0050ea7e, FUN_005146dc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_14, 0x14  # offset +0x14
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)
.set FUN_00514467, .text + (0x00514467 - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)

.org 0x00513e00 - 0x401000
.globl FUN_00513e00
FUN_00513e00:
    # block 0x00513e00: entry, 9 instruction(s), ends with jne to 0x00513e41 (forward)
    push ebp                                     # 00513e00
    {load} mov ebp, esp                          # 00513e01
    push ecx                                     # 00513e03
    push ecx                                     # 00513e04
    fld qword ptr [ebp + arg_c]                  # 00513e05
    fadd qword ptr [ebp + arg_14]                # 00513e08
    cmp dword ptr [0x568e30], 0x0                # 00513e0b
    fstp qword ptr [ebp - local_8]               # 00513e12
    jne.d8 L_00513e41                            # 00513e15
    # block 0x00513e17: entered by fall-through of jne at 0x00513e15, 19 instruction(s), calls FUN_00514467, ends with ret
    push dword ptr [ebp + arg_1c]                # 00513e17
    fld qword ptr [ebp - local_8]                # 00513e1a
    push ecx                                     # 00513e1d
    push ecx                                     # 00513e1e
    fstp qword ptr [esp]                         # 00513e1f
    fld qword ptr [ebp + arg_14]                 # 00513e22
    push ecx                                     # 00513e25
    push ecx                                     # 00513e26
    fstp qword ptr [esp]                         # 00513e27
    fld qword ptr [ebp + arg_c]                  # 00513e2a
    push ecx                                     # 00513e2d
    push ecx                                     # 00513e2e
    fstp qword ptr [esp]                         # 00513e2f
    push dword ptr [ebp + arg_8]                 # 00513e32
    push 0x1                                     # 00513e35
    call FUN_00514467                            # 00513e37
    add esp, 0x24                                # 00513e3c
    leave                                        # 00513e3f
    ret                                          # 00513e40
L_00513e41:
    # block 0x00513e41: entered by jne at 0x00513e15, 10 instruction(s), calls FUN_0050ea7e, FUN_005146dc, ends with ret
    call FUN_0050ea7e                            # 00513e41
    push 0xffff                                  # 00513e46
    mov dword ptr [eax], 0x21                    # 00513e4b
    push dword ptr [ebp + arg_1c]                # 00513e51
    call FUN_005146dc                            # 00513e54
    fld qword ptr [ebp - local_8]                # 00513e59
    pop ecx                                      # 00513e5c
    pop ecx                                      # 00513e5d
    leave                                        # 00513e5e
    ret                                          # 00513e5f

