# FUN_0050d7e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d7e3
# extent:       0x0050d7e3-0x0050d7f4 (17 code bytes)
# span:         0x0050d7e3-0x0050d7f4 (code 17, tables 0, padding 0)
# sha256:       eb00d73ae511ddb6d11845de8f595e51c02f123dc8c11097756e577820909e43
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d7e3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_0050d805
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050d805, .text + (0x0050d805 - 0x401000)

.org 0x0050d7e3 - 0x401000
.globl FUN_0050d7e3
FUN_0050d7e3:
    # block 0x0050d7e3: entry, 6 instruction(s), calls FUN_0050d805, ends with ret
    push 0x0                                     # 0050d7e3
    push 0x0                                     # 0050d7e5
    push dword ptr [esp + stk_c]                 # 0050d7e7
    call FUN_0050d805                            # 0050d7eb
    add esp, 0xc                                 # 0050d7f0
    ret                                          # 0050d7f3

