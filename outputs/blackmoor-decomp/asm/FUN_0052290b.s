# FUN_0052290b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052290b
# extent:       0x0052290b-0x0052292f (36 code bytes)
# span:         0x0052290b-0x0052292f (code 36, tables 0, padding 0)
# sha256:       a6c3cb94bce7ee5be079bd323dfe789bae0592a6d87ec8752968ca0cdd060725
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052290b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8
# callees:      calls FUN_00525371, FUN_00525b0f, FUN_00525684
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525684, .text + (0x00525684 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0052290b - 0x401000
.globl FUN_0052290b
FUN_0052290b:
    # block 0x0052290b: entry, 12 instruction(s), calls FUN_00525371, FUN_00525b0f, FUN_00525684, ends with ret
    push esi                                     # 0052290b
    {load} mov esi, ecx                          # 0052290c
    call FUN_00525371                            # 0052290e
    add eax, 0x1070                              # 00522913
    push 0x524bd4                                # 00522918
    {load} mov ecx, eax                          # 0052291d
    call FUN_00525b0f                            # 0052291f
    push esi                                     # 00522924
    lea ecx, [eax + field_8]                     # 00522925
    call FUN_00525684                            # 00522928
    pop esi                                      # 0052292d
    ret                                          # 0052292e

