# FUN_00519d8e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519d8e
# extent:       0x00519d8e-0x00519daa (28 code bytes)
# span:         0x00519d8e-0x00519daa (code 28, tables 0, padding 0)
# sha256:       24aaf609dc4e62ea27ecd1104733213d7883db1a612af32a4b70dc8bfc31cccd
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519d8e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005267ed, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_005267ed, .text + (0x005267ed - 0x401000)

.org 0x00519d8e - 0x401000
.globl FUN_00519d8e
FUN_00519d8e:
    # block 0x00519d8e: entry, 5 instruction(s), calls FUN_005267ed, ends with je to 0x00519da4 (forward)
    push esi                                     # 00519d8e
    {load} mov esi, ecx                          # 00519d8f
    call FUN_005267ed                            # 00519d91
    test byte ptr [esp + stk_8], 0x1             # 00519d96
    je.d8 L_00519da4                             # 00519d9b
    # block 0x00519d9d: entered by fall-through of je at 0x00519d9b, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00519da4
    push esi                                     # 00519d9d
    call FUN_0051dc6c                            # 00519d9e
    pop ecx                                      # 00519da3
L_00519da4:
    # block 0x00519da4: entered by je at 0x00519d9b, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00519da4
    pop esi                                      # 00519da6
    ret 0x4                                      # 00519da7

