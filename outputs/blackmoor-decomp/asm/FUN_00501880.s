# FUN_00501880
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501880
# extent:       0x00501880-0x00501949 (201 code bytes)
# span:         0x00501880-0x00501950 (code 201, tables 0, padding 7)
# sha256:       31db8f42400c94215dcef5c2afd0fd4de4d478de90c8ce888b44551681b24dc7
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501880
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00501880 - 0x401000
.globl FUN_00501880
FUN_00501880:
    # block 0x00501880: entry, 8 instruction(s), ends with jne to 0x005018f4 (forward)
    fld dword ptr [esp + stk_4]                  # 00501880
    fcomp qword ptr [0x52c7b0]                   # 00501884
    fld dword ptr [esp + stk_8]                  # 0050188a
    fnstsw ax                                    # 0050188e
    fcomp qword ptr [0x52c7b0]                   # 00501890
    test ah, 0x41                                # 00501896
    fnstsw ax                                    # 00501899
    jne.d8 L_005018f4                            # 0050189b
    # block 0x0050189d: entered by fall-through of jne at 0x0050189b, 2 instruction(s), ends with jne to 0x005018b7 (forward)
    test ah, 0x41                                # 0050189d
    jne.d8 L_005018b7                            # 005018a0
    # block 0x005018a2: entered by fall-through of jne at 0x005018a0, 7 instruction(s), ends with ret
    fld dword ptr [esp + stk_4]                  # 005018a2
    fmul dword ptr [esp + stk_4]                 # 005018a6
    fld dword ptr [esp + stk_8]                  # 005018aa
    fmul dword ptr [esp + stk_8]                 # 005018ae
    faddp st(1), st                              # 005018b2
    fsqrt                                        # 005018b4
    ret                                          # 005018b6
L_005018b7:
    # block 0x005018b7: entered by jne at 0x005018a0, 6 instruction(s), ends with je to 0x005018dd (forward)
    fld dword ptr [esp + stk_8]                  # 005018b7
    fchs                                         # 005018bb
    fcomp dword ptr [esp + stk_4]                # 005018bd
    fnstsw ax                                    # 005018c1
    test ah, 0x1                                 # 005018c3
    je.d8 L_005018dd                             # 005018c6
    # block 0x005018c8: entered by fall-through of je at 0x005018c6, 7 instruction(s), ends with ret
    fld dword ptr [esp + stk_4]                  # 005018c8
    fmul dword ptr [esp + stk_4]                 # 005018cc
    fld dword ptr [esp + stk_8]                  # 005018d0
    fmul dword ptr [esp + stk_8]                 # 005018d4
    fsubp st(1), st                              # 005018d8
    fsqrt                                        # 005018da
    ret                                          # 005018dc
L_005018dd:
    # block 0x005018dd: entered by je at 0x005018c6, 8 instruction(s), ends with ret
    fld dword ptr [esp + stk_8]                  # 005018dd
    fmul dword ptr [esp + stk_8]                 # 005018e1
    fld dword ptr [esp + stk_4]                  # 005018e5
    fmul dword ptr [esp + stk_4]                 # 005018e9
    fsubp st(1), st                              # 005018ed
    fsqrt                                        # 005018ef
    fchs                                         # 005018f1
    ret                                          # 005018f3
L_005018f4:
    # block 0x005018f4: entered by jne at 0x0050189b, 3 instruction(s), ends with je to 0x00501910 (forward)
    fld dword ptr [esp + stk_4]                  # 005018f4
    test ah, 0x1                                 # 005018f8
    je.d8 L_00501910                             # 005018fb
    # block 0x005018fd: entered by fall-through of je at 0x005018fb, 7 instruction(s), ends with ret
    fmul dword ptr [esp + stk_4]                 # 005018fd
    fld dword ptr [esp + stk_8]                  # 00501901
    fmul dword ptr [esp + stk_8]                 # 00501905
    faddp st(1), st                              # 00501909
    fsqrt                                        # 0050190b
    fchs                                         # 0050190d
    ret                                          # 0050190f
L_00501910:
    # block 0x00501910: entered by je at 0x005018fb, 5 instruction(s), ends with jne to 0x00501934 (forward)
    fchs                                         # 00501910
    fcomp dword ptr [esp + stk_8]                # 00501912
    fnstsw ax                                    # 00501916
    test ah, 0x41                                # 00501918
    jne.d8 L_00501934                            # 0050191b
    # block 0x0050191d: entered by fall-through of jne at 0x0050191b, 8 instruction(s), ends with ret
    fld dword ptr [esp + stk_4]                  # 0050191d
    fmul dword ptr [esp + stk_4]                 # 00501921
    fld dword ptr [esp + stk_8]                  # 00501925
    fmul dword ptr [esp + stk_8]                 # 00501929
    fsubp st(1), st                              # 0050192d
    fsqrt                                        # 0050192f
    fchs                                         # 00501931
    ret                                          # 00501933
L_00501934:
    # block 0x00501934: entered by jne at 0x0050191b, 7 instruction(s), ends with ret
    fld dword ptr [esp + stk_8]                  # 00501934
    fmul dword ptr [esp + stk_8]                 # 00501938
    fld dword ptr [esp + stk_4]                  # 0050193c
    fmul dword ptr [esp + stk_4]                 # 00501940
    fsubp st(1), st                              # 00501944
    fsqrt                                        # 00501946
    ret                                          # 00501948

# --- data items (not part of the function) -------------------------
.org 0x00501949 - 0x401000
PAD_00501949:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

