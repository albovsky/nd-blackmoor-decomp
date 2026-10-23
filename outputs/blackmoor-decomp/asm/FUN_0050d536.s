# FUN_0050d536
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d536
# extent:       0x0050d536-0x0050d541 (11 code bytes)
# span:         0x0050d536-0x0050d550 (code 11, tables 0, padding 15)
# sha256:       3fa07021d5778e7b929a7256a8140461e9af0c8465b02c45dc8af4322c32609b
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d536
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050d505
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050d505, .text + (0x0050d505 - 0x401000)

.org 0x0050d536 - 0x401000
.globl FUN_0050d536
FUN_0050d536:
    # block 0x0050d536: entry, 4 instruction(s), calls FUN_0050d505, ends with ret
    push dword ptr [esp + stk_4]                 # 0050d536
    call FUN_0050d505                            # 0050d53a
    pop ecx                                      # 0050d53f
    ret                                          # 0050d540

# --- data items (not part of the function) -------------------------
.org 0x0050d541 - 0x401000
PAD_0050d541:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

