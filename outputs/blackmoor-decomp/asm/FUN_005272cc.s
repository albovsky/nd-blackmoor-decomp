# FUN_005272cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005272cc
# extent:       0x005272cc-0x005272db (15 code bytes)
# span:         0x005272cc-0x005272db (code 15, tables 0, padding 0)
# sha256:       256595726fecfc0593e2ee2ac77cfeb039d28e4c755a8b8c47b42f3b1aceba3b
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005272cc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_0041a4be
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005272db
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0041a4be, .text + (0x0041a4be - 0x401000)

.org 0x005272cc - 0x401000
.globl FUN_005272cc
FUN_005272cc:
    # block 0x005272cc: entry, 4 instruction(s), calls FUN_0041a4be, ends with ret
    mov ecx, dword ptr [ebp - field_minus_14]    # 005272cc
    add ecx, 0x51f                               # 005272cf
    call FUN_0041a4be                            # 005272d5
    ret                                          # 005272da

