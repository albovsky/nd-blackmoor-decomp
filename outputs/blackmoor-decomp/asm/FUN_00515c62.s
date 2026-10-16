# FUN_00515c62
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515c62
# extent:       0x00515c62-0x00515cc7 (101 code bytes)
# span:         0x00515c62-0x00515cc7 (code 101, tables 0, padding 0)
# sha256:       1170c5e1de13319e2916801827cc4d88bd530819eccdf980ba83d330a7427800
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515c62
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00515aa0, FUN_00514569
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00514569, .text + (0x00514569 - 0x401000)
.set FUN_00515aa0, .text + (0x00515aa0 - 0x401000)

.org 0x00515c62 - 0x401000
.globl FUN_00515c62
FUN_00515c62:
    # block 0x00515c62: entry, 13 instruction(s), calls FUN_00515aa0, ends with jne to 0x00515cc3 (forward)
    push ebp                                     # 00515c62
    {load} mov ebp, esp                          # 00515c63
    push ecx                                     # 00515c65
    push ecx                                     # 00515c66
    fld qword ptr [ebp + arg_8]                  # 00515c67
    push ecx                                     # 00515c6a
    push ecx                                     # 00515c6b
    fstp qword ptr [esp]                         # 00515c6c
    call FUN_00515aa0                            # 00515c6f
    pop ecx                                      # 00515c74
    test al, -0x70                               # 00515c75
    pop ecx                                      # 00515c77
    jne.d8 L_00515cc3                            # 00515c78
    # block 0x00515c7a: entered by fall-through of jne at 0x00515c78, 13 instruction(s), calls FUN_00514569, ends with jne to 0x00515cc3 (forward)
    fld qword ptr [ebp + arg_8]                  # 00515c7a
    push ecx                                     # 00515c7d
    push ecx                                     # 00515c7e
    fstp qword ptr [esp]                         # 00515c7f
    call FUN_00514569                            # 00515c82
    fstp qword ptr [ebp - local_8]               # 00515c87
    fld qword ptr [ebp - local_8]                # 00515c8a
    fcomp qword ptr [ebp + arg_8]                # 00515c8d
    pop ecx                                      # 00515c90
    pop ecx                                      # 00515c91
    fnstsw ax                                    # 00515c92
    sahf                                         # 00515c94
    jne.d8 L_00515cc3                            # 00515c95
    # block 0x00515c97: entered by fall-through of jne at 0x00515c95, 14 instruction(s), calls FUN_00514569, ends with jne to 0x00515cbe (forward)
    fld qword ptr [ebp + arg_8]                  # 00515c97
    fdiv qword ptr [0x52c678]                    # 00515c9a
    push ecx                                     # 00515ca0
    push ecx                                     # 00515ca1
    fstp qword ptr [ebp + arg_8]                 # 00515ca2
    fld qword ptr [ebp + arg_8]                  # 00515ca5
    fstp qword ptr [esp]                         # 00515ca8
    call FUN_00514569                            # 00515cab
    fcomp qword ptr [ebp + arg_8]                # 00515cb0
    pop ecx                                      # 00515cb3
    pop ecx                                      # 00515cb4
    fnstsw ax                                    # 00515cb5
    sahf                                         # 00515cb7
    jne.d8 L_00515cbe                            # 00515cb8
    # block 0x00515cba: entered by fall-through of jne at 0x00515cb8, 2 instruction(s), ends with forward jump to 0x00515cc0
    push 0x2                                     # 00515cba
    jmp.d8 L_00515cc0                            # 00515cbc
L_00515cbe:
    # block 0x00515cbe: entered by jne at 0x00515cb8, 1 instruction(s), falls into the block at 0x00515cc0
    push 0x1                                     # 00515cbe
L_00515cc0:
    # block 0x00515cc0: entered by jmp at 0x00515cbc, 3 instruction(s), ends with ret
    pop eax                                      # 00515cc0
    leave                                        # 00515cc1
    ret                                          # 00515cc2
L_00515cc3:
    # block 0x00515cc3: entered by jne at 0x00515c78; jne at 0x00515c95, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00515cc3
    leave                                        # 00515cc5
    ret                                          # 00515cc6

