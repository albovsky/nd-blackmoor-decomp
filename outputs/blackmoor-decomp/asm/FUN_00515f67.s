# FUN_00515f67
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515f67
# extent:       0x00515f67-0x00515f95 (46 code bytes)
# span:         0x00515f67-0x00515f95 (code 46, tables 0, padding 0)
# sha256:       0de8e650893034bae69e88c3a2e9dc259a417a80974a1b1e593e6c26729bed7d
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515f67
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00512c18, FUN_00515f95, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00515f95, .text + (0x00515f95 - 0x401000)

.org 0x00515f67 - 0x401000
.globl FUN_00515f67
FUN_00515f67:
    # block 0x00515f67: entry, 2 instruction(s), ends with jne to 0x00515f94 (forward)
    cmp dword ptr [0x63cd10], 0x0                # 00515f67
    jne.d8 L_00515f94                            # 00515f6e
    # block 0x00515f70: entered by fall-through of jne at 0x00515f6e, 5 instruction(s), calls FUN_00512c18, ends with jne to 0x00515f8c (forward)
    push 0xb                                     # 00515f70
    call FUN_00512c18                            # 00515f72
    cmp dword ptr [0x63cd10], 0x0                # 00515f77
    pop ecx                                      # 00515f7e
    jne.d8 L_00515f8c                            # 00515f7f
    # block 0x00515f81: entered by fall-through of jne at 0x00515f7f, 2 instruction(s), calls FUN_00515f95, falls into the block at 0x00515f8c
    call FUN_00515f95                            # 00515f81
    inc dword ptr [0x63cd10]                     # 00515f86
L_00515f8c:
    # block 0x00515f8c: entered by jne at 0x00515f7f, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x00515f94
    push 0xb                                     # 00515f8c
    call FUN_00512c79                            # 00515f8e
    pop ecx                                      # 00515f93
L_00515f94:
    # block 0x00515f94: entered by jne at 0x00515f6e, 1 instruction(s), ends with ret
    ret                                          # 00515f94

