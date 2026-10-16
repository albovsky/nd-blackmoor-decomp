# FUN_00524c3e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524c3e
# extent:       0x00524c3e-0x00524c59 (27 code bytes)
# span:         0x00524c3e-0x00524c59 (code 27, tables 0, padding 0)
# sha256:       fb806d1a6d5d610505f5f9faf6cb4f1c82644640b93b52a3204fa078668c4ad6
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524c3e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0052694b, FUN_005256fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005256fb, .text + (0x005256fb - 0x401000)
.set FUN_0052694b, .text + (0x0052694b - 0x401000)

.org 0x00524c3e - 0x401000
.globl FUN_00524c3e
FUN_00524c3e:
    # block 0x00524c3e: entry, 5 instruction(s), calls FUN_0052694b, ends with je to 0x00524c53 (forward)
    push esi                                     # 00524c3e
    {load} mov esi, ecx                          # 00524c3f
    call FUN_0052694b                            # 00524c41
    test byte ptr [esp + stk_8], 0x1             # 00524c46
    je.d8 L_00524c53                             # 00524c4b
    # block 0x00524c4d: entered by fall-through of je at 0x00524c4b, 2 instruction(s), calls FUN_005256fb, falls into the block at 0x00524c53
    push esi                                     # 00524c4d
    call FUN_005256fb                            # 00524c4e
L_00524c53:
    # block 0x00524c53: entered by je at 0x00524c4b, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00524c53
    pop esi                                      # 00524c55
    ret 0x4                                      # 00524c56

