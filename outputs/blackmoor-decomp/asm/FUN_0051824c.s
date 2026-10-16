# FUN_0051824c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051824c
# extent:       0x0051824c-0x00518261 (21 code bytes)
# span:         0x0051824c-0x00518261 (code 21, tables 0, padding 0)
# sha256:       45f779a594c2eedb14c937d7ece2fa9b980bbced7ce6fa5d7d94bdfdbed21cdd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051779c (+0xab0)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051824c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00517a70
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00518261
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00517a70, .text + (0x00517a70 - 0x401000)

.org 0x0051824c - 0x401000
.globl FUN_0051824c
FUN_0051824c:
    # block 0x0051824c: entry, 8 instruction(s), calls FUN_00517a70, ends with ret
    push eax                                     # 0051824c
    sub esp, 0x2c                                # 0051824d
    fstp tbyte ptr [esp]                         # 00518250
    fstp tbyte ptr [esp + stk_c]                 # 00518253
    call FUN_00517a70                            # 00518257
    add esp, 0x2c                                # 0051825c
    pop eax                                      # 0051825f
    ret                                          # 00518260

