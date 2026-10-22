# FUN_005230f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005230f0
# extent:       0x005230f0-0x005230ff (15 code bytes)
# span:         0x005230f0-0x005230ff (code 15, tables 0, padding 0)
# sha256:       940988a7ca70f4c8ec4c7f17118bceb662d723a67f6c187bdf518c194e2eeb5d
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005230f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_005230ff
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_005230ff, .text + (0x005230ff - 0x401000)

.org 0x005230f0 - 0x401000
.globl FUN_005230f0
FUN_005230f0:
    # block 0x005230f0: entry, 5 instruction(s), calls FUN_005230ff, ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 005230f0
    push dword ptr [eax]                         # 005230f4
    push eax                                     # 005230f6
    call FUN_005230ff                            # 005230f7
    ret 0x4                                      # 005230fc

