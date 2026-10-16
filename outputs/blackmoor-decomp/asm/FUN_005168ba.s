# FUN_005168ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005168ba
# extent:       0x005168ba-0x005168d0 (22 code bytes)
# span:         0x005168ba-0x005168d0 (code 22, tables 0, padding 0)
# sha256:       9ffb02f2ce6982c63e331e60204a6fde04b97dff50cf0018aec9f03368da2959
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005168ba
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00516885
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00516885, .text + (0x00516885 - 0x401000)

.org 0x005168ba - 0x401000
.globl FUN_005168ba
FUN_005168ba:
    # block 0x005168ba: entry, 8 instruction(s), calls FUN_00516885, ends with ret
    mov eax, dword ptr [esp + stk_8]             # 005168ba
    and eax, 0xfff7ffff                          # 005168be
    push eax                                     # 005168c3
    push dword ptr [esp + stk_8]                 # 005168c4
    call FUN_00516885                            # 005168c8
    pop ecx                                      # 005168cd
    pop ecx                                      # 005168ce
    ret                                          # 005168cf

