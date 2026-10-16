# FUN_0052292f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052292f
# extent:       0x0052292f-0x00522953 (36 code bytes)
# span:         0x0052292f-0x00522953 (code 36, tables 0, padding 0)
# sha256:       13d6842539337776663b1574e820cf70f228532dbdafb7189cdc9fdf6975a5c9
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052292f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8
# callees:      calls FUN_00525371, FUN_00525b0f, FUN_00525697
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525697, .text + (0x00525697 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0052292f - 0x401000
.globl FUN_0052292f
FUN_0052292f:
    # block 0x0052292f: entry, 12 instruction(s), calls FUN_00525371, FUN_00525b0f, FUN_00525697, ends with ret
    push esi                                     # 0052292f
    {load} mov esi, ecx                          # 00522930
    call FUN_00525371                            # 00522932
    add eax, 0x1070                              # 00522937
    push 0x524bd4                                # 0052293c
    {load} mov ecx, eax                          # 00522941
    call FUN_00525b0f                            # 00522943
    push esi                                     # 00522948
    lea ecx, [eax + field_8]                     # 00522949
    call FUN_00525697                            # 0052294c
    pop esi                                      # 00522951
    ret                                          # 00522952

