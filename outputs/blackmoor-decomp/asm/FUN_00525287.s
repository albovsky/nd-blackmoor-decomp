# FUN_00525287
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525287
# extent:       0x00525287-0x005252a2 (27 code bytes)
# span:         0x00525287-0x005252a2 (code 27, tables 0, padding 0)
# sha256:       613aa56108ac2e9afdc0fa8d1abb707cdc979b44f694736b3dcd4cf218e8fccf
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525287
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005252a2, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005252a2, .text + (0x005252a2 - 0x401000)
.set FUN_005256fb, .text + (0x005256fb - 0x401000)

.org 0x00525287 - 0x401000
.globl FUN_00525287
FUN_00525287:
    # block 0x00525287: entry, 5 instruction(s), calls FUN_005252a2, ends with je to 0x0052529c (forward)
    push esi                                     # 00525287
    {load} mov esi, ecx                          # 00525288
    call FUN_005252a2                            # 0052528a
    test byte ptr [esp + stk_8], 0x1             # 0052528f
    je.d8 L_0052529c                             # 00525294
    # block 0x00525296: entered by fall-through of je at 0x00525294, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x0052529c
    push esi                                     # 00525296
    call FUN_005256fb                            # 00525297
L_0052529c:
    # block 0x0052529c: entered by je at 0x00525294, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0052529c
    pop esi                                      # 0052529e
    ret 0x4                                      # 0052529f

