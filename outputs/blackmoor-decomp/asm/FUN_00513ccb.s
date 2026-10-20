# FUN_00513ccb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513ccb
# extent:       0x00513ccb-0x00513cf5 (42 code bytes)
# span:         0x00513ccb-0x00513cf5 (code 42, tables 0, padding 0)
# sha256:       c52b11c2f87cb280a857bc4f1442e274b39ddcfb68cb9167f941f707193e58da
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __math_exit
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00513bd7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00513cf5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00513bd7, .text + (0x00513bd7 - 0x401000)

.org 0x00513ccb - 0x401000
.globl FUN_00513ccb
FUN_00513ccb:
    # block 0x00513ccb: entry, 3 instruction(s), ends with je to 0x00513cf3 (forward)
    mov ax, word ptr [esp]                       # 00513ccb
    .insn 0x66, 0x3d, 0x027f{:u16}               # 00513ccf
    je.d8 L_00513cf3                             # 00513cd3
    # block 0x00513cd5: entered by fall-through of je at 0x00513cd3, 2 instruction(s), ends with je to 0x00513cf0 (forward)
    and ax, 0x20                                 # 00513cd5
    je.d8 L_00513cf0                             # 00513cd9
    # block 0x00513cdb: entered by fall-through of je at 0x00513cd9, 4 instruction(s), ends with je to 0x00513cf0 (forward)
    wait                                         # 00513cdb
    fnstsw ax                                    # 00513cdc
    and ax, 0x20                                 # 00513cde
    je.d8 L_00513cf0                             # 00513ce2
    # block 0x00513ce4: entered by fall-through of je at 0x00513ce2, 4 instruction(s), calls FUN_00513bd7, ends with ret
    mov eax, 0x8                                 # 00513ce4
    call FUN_00513bd7                            # 00513ce9
    pop edx                                      # 00513cee
    ret                                          # 00513cef
L_00513cf0:
    # block 0x00513cf0: entered by je at 0x00513cd9; je at 0x00513ce2, 1 instruction(s), falls into the block at 0x00513cf3
    fldcw word ptr [esp]                         # 00513cf0
L_00513cf3:
    # block 0x00513cf3: entered by je at 0x00513cd3, 2 instruction(s), ends with ret
    pop edx                                      # 00513cf3
    ret                                          # 00513cf4

