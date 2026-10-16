# FUN_005214c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005214c9
# extent:       0x005214c9-0x005214d5 (12 code bytes)
# span:         0x005214c9-0x005214d5 (code 12, tables 0, padding 0)
# sha256:       c09c976c2ffa05e530daf5523dfb3ae758d67107f6757712fdef2220b4edd250
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005214c9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c4
# callees:      calls FUN_0052513f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005214d5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c4, 0xc4  # offset +0xc4

# --- external targets -----------------------------------------------
.set FUN_0052513f, .text + (0x0052513f - 0x401000)

.org 0x005214c9 - 0x401000
.globl FUN_005214c9
FUN_005214c9:
    # block 0x005214c9: entry, 3 instruction(s), calls FUN_0052513f, ends with ret
    call FUN_0052513f                            # 005214c9
    mov eax, dword ptr [eax + field_c4]          # 005214ce
    ret                                          # 005214d4

