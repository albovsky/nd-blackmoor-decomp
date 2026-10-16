# FUN_0052549b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052549b
# extent:       0x0052549b-0x005254b2 (23 code bytes)
# span:         0x0052549b-0x005254b2 (code 23, tables 0, padding 0)
# sha256:       81aee4dca30621635cf12c9df195d49b268d774b7bd094ce3bfe92f91d01d858
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525485 (+0x16)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052549b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00520a2c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005254b2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_00520a2c, .text + (0x00520a2c - 0x401000)

.org 0x0052549b - 0x401000
.globl FUN_0052549b
FUN_0052549b:
    # block 0x0052549b: entry, 5 instruction(s), calls FUN_0051dc43, ends with je to 0x005254af (forward)
    push 0x10                                    # 0052549b
    call FUN_0051dc43                            # 0052549d
    test eax, eax                                # 005254a2
    pop ecx                                      # 005254a4
    je.d8 L_005254af                             # 005254a5
    # block 0x005254a7: entered by fall-through of je at 0x005254a5, 3 instruction(s), calls FUN_00520a2c, ends with ret
    {load} mov ecx, eax                          # 005254a7
    call FUN_00520a2c                            # 005254a9
    ret                                          # 005254ae
L_005254af:
    # block 0x005254af: entered by je at 0x005254a5, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 005254af
    ret                                          # 005254b1

