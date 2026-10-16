# FUN_005104fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005104fa
# extent:       0x005104fa-0x00510516 (28 code bytes)
# span:         0x005104fa-0x00510516 (code 28, tables 0, padding 0)
# sha256:       380c5c86baf907f2530d30c8df2c1e21dbe18fab095a1e7c83bd9935ea2752a4
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005104fa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00510122
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00510122, .text + (0x00510122 - 0x401000)

.org 0x005104fa - 0x401000
.globl FUN_005104fa
FUN_005104fa:
    # block 0x005104fa: entry, 2 instruction(s), ends with jne to 0x00510515 (forward)
    cmp dword ptr [0x63e130], 0x0                # 005104fa
    jne.d8 L_00510515                            # 00510501
    # block 0x00510503: entered by fall-through of jne at 0x00510501, 4 instruction(s), calls FUN_00510122, falls into the block at 0x00510515
    push -0x3                                    # 00510503
    call FUN_00510122                            # 00510505
    pop ecx                                      # 0051050a
    mov dword ptr [0x63e130], 0x1                # 0051050b
L_00510515:
    # block 0x00510515: entered by jne at 0x00510501, 1 instruction(s), ends with ret
    ret                                          # 00510515

