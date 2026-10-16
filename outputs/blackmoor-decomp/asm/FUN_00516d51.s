# FUN_00516d51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516d51
# extent:       0x00516d51-0x00516d67 (22 code bytes)
# span:         0x00516d51-0x00516d67 (code 22, tables 0, padding 0)
# sha256:       b52618df706932e261263a70e4caa268658ab1b4c01e0d3ab7e1fa13d3b4314e
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516d51
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00516be5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00516be5, .text + (0x00516be5 - 0x401000)

.org 0x00516d51 - 0x401000
.globl FUN_00516d51
FUN_00516d51:
    # block 0x00516d51: entry, 6 instruction(s), calls FUN_00516be5, ends with ret
    push 0x568ca0                                # 00516d51
    push dword ptr [esp + stk_c]                 # 00516d56
    push dword ptr [esp + stk_c]                 # 00516d5a
    call FUN_00516be5                            # 00516d5e
    add esp, 0xc                                 # 00516d63
    ret                                          # 00516d66

