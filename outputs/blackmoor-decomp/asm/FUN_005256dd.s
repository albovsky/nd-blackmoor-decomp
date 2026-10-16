# FUN_005256dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005256dd
# extent:       0x005256dd-0x005256fb (30 code bytes)
# span:         0x005256dd-0x005256fb (code 30, tables 0, padding 0)
# sha256:       a0fe4b6375bf82d7f101677fe2f967b9e11c83170b16f7de95d2fa04a4b384d5
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005256dd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls KERNEL32.dll!LocalAlloc, FUN_00519cc0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00519cc0, .text + (0x00519cc0 - 0x401000)

.org 0x005256dd - 0x401000
.globl FUN_005256dd
FUN_005256dd:
    # block 0x005256dd: entry, 7 instruction(s), calls KERNEL32.dll!LocalAlloc, ends with jne to 0x005256f5 (forward)
    push esi                                     # 005256dd
    push dword ptr [esp + stk_8]                 # 005256de
    push 0x40                                    # 005256e2
    call dword ptr [0x52a134]                    # 005256e4
    {load} mov esi, eax                          # 005256ea
    test esi, esi                                # 005256ec
    jne.d8 L_005256f5                            # 005256ee
    # block 0x005256f0: entered by fall-through of jne at 0x005256ee, 1 instruction(s), calls FUN_00519cc0, falls into the block at 0x005256f5
    call FUN_00519cc0                            # 005256f0
L_005256f5:
    # block 0x005256f5: entered by jne at 0x005256ee, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 005256f5
    pop esi                                      # 005256f7
    ret 0x4                                      # 005256f8

