# FUN_00527a9e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527a9e
# extent:       0x00527a9e-0x00527aad (15 code bytes)
# span:         0x00527a9e-0x00527aad (code 15, tables 0, padding 0)
# sha256:       6fe5c2250cba7e37d0945a92fa5c9b323f7a25d76355b27695ae43bc9651ffe0
# evidence:     ev_4a8dff9ad380397c0b868aca2777fc0b3dcad13e813ce03a000d7bb326342248
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527a9e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00459ace
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00459ace, .text + (0x00459ace - 0x401000)

.org 0x00527a9e - 0x401000
.globl FUN_00527a9e
FUN_00527a9e:
    # block 0x00527a9e: entry, 4 instruction(s), calls FUN_00459ace, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527a9e
    add ecx, 0xac465                             # 00527aa1
    call FUN_00459ace                            # 00527aa7
    ret                                          # 00527aac

