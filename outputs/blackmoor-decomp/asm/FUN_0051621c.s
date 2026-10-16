# FUN_0051621c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051621c
# extent:       0x0051621c-0x0051623d (33 code bytes)
# span:         0x0051621c-0x0051623d (code 33, tables 0, padding 0)
# sha256:       934ea1b991086991f8db659c0b33f3b3c8ca095d09441e777e1ed11000de787e
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051621c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00512c18, FUN_0051623d, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_0051623d, .text + (0x0051623d - 0x401000)

.org 0x0051621c - 0x401000
.globl FUN_0051621c
FUN_0051621c:
    # block 0x0051621c: entry, 12 instruction(s), calls FUN_00512c18, FUN_0051623d, FUN_00512c79, ends with ret
    push esi                                     # 0051621c
    push 0xb                                     # 0051621d
    call FUN_00512c18                            # 0051621f
    push dword ptr [esp + stk_c]                 # 00516224
    call FUN_0051623d                            # 00516228
    push 0xb                                     # 0051622d
    {load} mov esi, eax                          # 0051622f
    call FUN_00512c79                            # 00516231
    add esp, 0xc                                 # 00516236
    {load} mov eax, esi                          # 00516239
    pop esi                                      # 0051623b
    ret                                          # 0051623c

