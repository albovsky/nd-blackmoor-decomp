# FUN_0050c1b4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c1b4
# extent:       0x0050c1b4-0x0050c1cd (25 code bytes)
# span:         0x0050c1b4-0x0050c1cd (code 25, tables 0, padding 0)
# sha256:       7d26f47b010073475b412540b24a5d04b34fda4a6933a72ee50f5852af7a4339
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c1b4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c
# callees:      calls USER32.dll!SendMessageA, FUN_0051abe4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c1cd
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0050c1b4 - 0x401000
.globl FUN_0050c1b4
FUN_0050c1b4:
    # block 0x0050c1b4: entry, 8 instruction(s), calls USER32.dll!SendMessageA, FUN_0051abe4, ends with ret
    push 0x0                                     # 0050c1b4
    push 0x0                                     # 0050c1b6
    push 0x474                                   # 0050c1b8
    push dword ptr [ecx + field_1c]              # 0050c1bd
    call dword ptr [0x52a4c8]                    # 0050c1c0
    push eax                                     # 0050c1c6
    call FUN_0051abe4                            # 0050c1c7
    ret                                          # 0050c1cc

