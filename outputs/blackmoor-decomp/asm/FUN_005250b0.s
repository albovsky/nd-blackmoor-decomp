# FUN_005250b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005250b0
# extent:       0x005250b0-0x005250cb (27 code bytes)
# span:         0x005250b0-0x005250cb (code 27, tables 0, padding 0)
# sha256:       03f54ddb35e172f76b91649b3dd973b5a13eda0b9982b0574740d00677a08f56
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005250b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005250cb, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005250cb, .text + (0x005250cb - 0x401000)
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x005250b0 - 0x401000
.globl FUN_005250b0
FUN_005250b0:
    # block 0x005250b0: entry, 5 instruction(s), calls FUN_005250cb, ends with je to 0x005250c5 (forward)
    push esi                                     # 005250b0
    {load} mov esi, ecx                          # 005250b1
    call FUN_005250cb                            # 005250b3
    test byte ptr [esp + stk_8], 0x1             # 005250b8
    je.d8 L_005250c5                             # 005250bd
    # block 0x005250bf: entered by fall-through of je at 0x005250bd, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x005250c5
    push esi                                     # 005250bf
    call FUN_005256fb                            # 005250c0
L_005250c5:
    # block 0x005250c5: entered by je at 0x005250bd, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 005250c5
    pop esi                                      # 005250c7
    ret 0x4                                      # 005250c8

