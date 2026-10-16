# FUN_004d3705
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3705
# extent:       0x004d3705-0x004d3714 (15 code bytes)
# span:         0x004d3705-0x004d3714 (code 15, tables 0, padding 0)
# sha256:       b9224d541080c32532c73705956333a781ae62094551b010bc05a119a101f189
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3705
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e79ca
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004e79ca, .text + (0x004e79ca - 0x401000)

.org 0x004d3705 - 0x401000
.globl FUN_004d3705
FUN_004d3705:
    # block 0x004d3705: entry, 6 instruction(s), calls FUN_004e79ca, ends with ret
    push ebp                                     # 004d3705
    {load} mov ebp, esp                          # 004d3706
    mov ecx, 0x582711                            # 004d3708
    call FUN_004e79ca                            # 004d370d
    pop ebp                                      # 004d3712
    ret                                          # 004d3713

