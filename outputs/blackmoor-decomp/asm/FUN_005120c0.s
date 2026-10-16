# FUN_005120c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005120c0
# extent:       0x005120c0-0x005120d4 (20 code bytes)
# span:         0x005120c0-0x005120d4 (code 20, tables 0, padding 0)
# sha256:       88569be68a430c9156a07e5ac42f4d4d618cd97d912c353d640232f820183550
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00511fab (+0x115)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005120c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050dd0c, tail jump FUN_0051743a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050dd0c, .text + (0x0050dd0c - 0x401000)
.set FUN_0051743a, .text + (0x0051743a - 0x401000)

.org 0x005120c0 - 0x401000
.globl FUN_005120c0
FUN_005120c0:
    # block 0x005120c0: entry, 3 instruction(s), calls FUN_0050dd0c, ends with je to 0x005120d3 (forward)
    call FUN_0050dd0c                            # 005120c0
    cmp byte ptr [0x63ca44], 0x0                 # 005120c5
    je.d8 L_005120d3                             # 005120cc
    # block 0x005120ce: entered by fall-through of je at 0x005120cc, 1 instruction(s), ends with forward jump to 0x0051743a
    jmp.d32 FUN_0051743a                         # 005120ce
L_005120d3:
    # block 0x005120d3: entered by je at 0x005120cc, 1 instruction(s), ends with ret
    ret                                          # 005120d3

