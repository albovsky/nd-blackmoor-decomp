# FUN_00501950
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501950
# extent:       0x00501950-0x005019dc (140 code bytes)
# span:         0x00501950-0x005019e0 (code 140, tables 0, padding 4)
# sha256:       cdff35795ae18ae3468b42443bbfc891e77e6d08428fb4a91208cdbff3b5f1b5
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501950
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 47 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00501950 - 0x401000
.globl FUN_00501950
FUN_00501950:
    # block 0x00501950: entry, 8 instruction(s), ends with jne to 0x0050199a (forward)
    fld dword ptr [esp + stk_4]                  # 00501950
    fcomp qword ptr [0x52c7b0]                   # 00501954
    fld dword ptr [esp + stk_8]                  # 0050195a
    fnstsw ax                                    # 0050195e
    fcomp qword ptr [0x52c7b0]                   # 00501960
    test ah, 0x41                                # 00501966
    fnstsw ax                                    # 00501969
    jne.d8 L_0050199a                            # 0050196b
    # block 0x0050196d: entered by fall-through of jne at 0x0050196b, 2 instruction(s), ends with je to 0x005019c7 (forward)
    test ah, 0x41                                # 0050196d
    je.d8 L_005019c7                             # 00501970
    # block 0x00501972: entered by fall-through of je at 0x00501970, 11 instruction(s), ends with jne to 0x005019d9 (forward)
    fld dword ptr [esp + stk_8]                  # 00501972
    fchs                                         # 00501976
    fcomp dword ptr [esp + stk_4]                # 00501978
    fld dword ptr [esp + stk_4]                  # 0050197c
    fmul dword ptr [esp + stk_4]                 # 00501980
    fld dword ptr [esp + stk_8]                  # 00501984
    fmul dword ptr [esp + stk_8]                 # 00501988
    fnstsw ax                                    # 0050198c
    test ah, 0x1                                 # 0050198e
    faddp st(1), st                              # 00501991
    jne.d8 L_005019d9                            # 00501993
    # block 0x00501995: entered by fall-through of jne at 0x00501993, 3 instruction(s), ends with ret
    fsqrt                                        # 00501995
    fchs                                         # 00501997
    ret                                          # 00501999
L_0050199a:
    # block 0x0050199a: entered by jne at 0x0050196b, 3 instruction(s), ends with jne to 0x005019b4 (forward)
    fld dword ptr [esp + stk_4]                  # 0050199a
    test ah, 0x1                                 # 0050199e
    jne.d8 L_005019b4                            # 005019a1
    # block 0x005019a3: entered by fall-through of jne at 0x005019a1, 5 instruction(s), ends with jne to 0x005019c7 (forward)
    fchs                                         # 005019a3
    fcomp dword ptr [esp + stk_8]                # 005019a5
    fnstsw ax                                    # 005019a9
    test ah, 0x41                                # 005019ab
    jne.d8 L_005019c7                            # 005019ae
    # block 0x005019b0: entered by fall-through of jne at 0x005019ae, 1 instruction(s), falls into the block at 0x005019b4
    fld dword ptr [esp + stk_4]                  # 005019b0
L_005019b4:
    # block 0x005019b4: entered by jne at 0x005019a1, 7 instruction(s), ends with ret
    fmul dword ptr [esp + stk_4]                 # 005019b4
    fld dword ptr [esp + stk_8]                  # 005019b8
    fmul dword ptr [esp + stk_8]                 # 005019bc
    faddp st(1), st                              # 005019c0
    fsqrt                                        # 005019c2
    fchs                                         # 005019c4
    ret                                          # 005019c6
L_005019c7:
    # block 0x005019c7: entered by je at 0x00501970; jne at 0x005019ae, 5 instruction(s), falls into the block at 0x005019d9
    fld dword ptr [esp + stk_4]                  # 005019c7
    fmul dword ptr [esp + stk_4]                 # 005019cb
    fld dword ptr [esp + stk_8]                  # 005019cf
    fmul dword ptr [esp + stk_8]                 # 005019d3
    faddp st(1), st                              # 005019d7
L_005019d9:
    # block 0x005019d9: entered by jne at 0x00501993, 2 instruction(s), ends with ret
    fsqrt                                        # 005019d9
    ret                                          # 005019db

# --- data items (not part of the function) -------------------------
.org 0x005019dc - 0x401000
PAD_005019dc:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

