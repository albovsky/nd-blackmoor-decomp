# FUN_0050f440
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f440
# extent:       0x0050f440-0x0050f459 (25 code bytes)
# span:         0x0050f440-0x0050f459 (code 25, tables 0, padding 0)
# sha256:       a39b146e16cbbab84442ad0a2ac74ad3532fec7ad9f70bf38cf2d7d8f4a99ff9
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f440
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c
# callees:      calls FUN_0050f462
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050f459
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050f462, .text + (0x0050f462 - 0x401000)

.org 0x0050f440 - 0x401000
.globl FUN_0050f440
FUN_0050f440:
    # block 0x0050f440: entry, 8 instruction(s), calls FUN_0050f462, ends with ret
    sub esp, 0x10                                # 0050f440
    fxch st(1)                                   # 0050f443
    fstp qword ptr [esp]                         # 0050f445
    fst qword ptr [esp + stk_8]                  # 0050f448
    mov eax, dword ptr [esp + stk_c]             # 0050f44c
    call FUN_0050f462                            # 0050f450
    add esp, 0x10                                # 0050f455
    ret                                          # 0050f458

