# FUN_0051dc6c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dc6c
# extent:       0x0051dc6c-0x0051dc77 (11 code bytes)
# span:         0x0051dc6c-0x0051dc77 (code 11, tables 0, padding 0)
# sha256:       8ae30ab2c6c51bc3fcfbc7916ba80c68a46c62f3a350cd07e0a42ca51b3ef8ea
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dc6c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_free_layer_header (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x0051dc6c - 0x401000
.globl FUN_0051dc6c
FUN_0051dc6c:
    # block 0x0051dc6c: entry, 4 instruction(s), calls FUN_0050e936, ends with ret
    push dword ptr [esp + stk_4]                 # 0051dc6c
    call FUN_0050e936                            # 0051dc70
    pop ecx                                      # 0051dc75
    ret                                          # 0051dc76

