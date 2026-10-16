# FUN_005251d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005251d3
# extent:       0x005251d3-0x005251ee (27 code bytes)
# span:         0x005251d3-0x005251ee (code 27, tables 0, padding 0)
# sha256:       938432fc636cb08dac5585be133e0807a5a42be9d55f18e10d0cad06cc64e1fe
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005251d3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005251ee, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005251ee, .text + (0x005251ee - 0x401000)
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x005251d3 - 0x401000
.globl FUN_005251d3
FUN_005251d3:
    # block 0x005251d3: entry, 5 instruction(s), calls FUN_005251ee, ends with je to 0x005251e8 (forward)
    push esi                                     # 005251d3
    {load} mov esi, ecx                          # 005251d4
    call FUN_005251ee                            # 005251d6
    test byte ptr [esp + stk_8], 0x1             # 005251db
    je.d8 L_005251e8                             # 005251e0
    # block 0x005251e2: entered by fall-through of je at 0x005251e0, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x005251e8
    push esi                                     # 005251e2
    call FUN_005256fb                            # 005251e3
L_005251e8:
    # block 0x005251e8: entered by je at 0x005251e0, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 005251e8
    pop esi                                      # 005251ea
    ret 0x4                                      # 005251eb

