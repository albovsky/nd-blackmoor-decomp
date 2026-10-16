# FUN_0051a2b1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a2b1
# extent:       0x0051a2b1-0x0051a2cd (28 code bytes)
# span:         0x0051a2b1-0x0051a2cd (code 28, tables 0, padding 0)
# sha256:       2829dfff55232e947c455bf2c48cf05e051da25d259797802c626911b67cf772
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a2b1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0051a2ed, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051a2ed, .text + (0x0051a2ed - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a2b1 - 0x401000
.globl FUN_0051a2b1
FUN_0051a2b1:
    # block 0x0051a2b1: entry, 5 instruction(s), calls FUN_0051a2ed, ends with je to 0x0051a2c7 (forward)
    push esi                                     # 0051a2b1
    {load} mov esi, ecx                          # 0051a2b2
    call FUN_0051a2ed                            # 0051a2b4
    test byte ptr [esp + stk_8], 0x1             # 0051a2b9
    je.d8 L_0051a2c7                             # 0051a2be
    # block 0x0051a2c0: entered by fall-through of je at 0x0051a2be, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0051a2c7
    push esi                                     # 0051a2c0
    call FUN_0051dc6c                            # 0051a2c1
    pop ecx                                      # 0051a2c6
L_0051a2c7:
    # block 0x0051a2c7: entered by je at 0x0051a2be, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0051a2c7
    pop esi                                      # 0051a2c9
    ret 0x4                                      # 0051a2ca

