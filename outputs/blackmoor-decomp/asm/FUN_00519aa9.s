# FUN_00519aa9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519aa9
# extent:       0x00519aa9-0x00519acb (34 code bytes)
# span:         0x00519aa9-0x00519acb (code 34, tables 0, padding 0)
# sha256:       7027c8389d4f670135dbf4d64d4077598f062783827d2d941bb7756b51e8ce69
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00519a78 (+0x31)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519aa9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00519a78, FUN_0050d775
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d775, .text + (0x0050d775 - 0x401000)
.set FUN_00519a78, .text + (0x00519a78 - 0x401000)

.org 0x00519aa9 - 0x401000
.globl FUN_00519aa9
FUN_00519aa9:
    # block 0x00519aa9: entry, 1 instruction(s), ends with forward jump to 0x00519aae
    jmp.d32 L_00519aae                           # 00519aa9
L_00519aae:
    # block 0x00519aae: entered by jmp at 0x00519aa9, 8 instruction(s), calls FUN_00519a78, FUN_0050d775, ends with ret
    push 0x600                                   # 00519aae
    push 0x0                                     # 00519ab3
    call FUN_00519a78                            # 00519ab5
    push 0x519a96                                # 00519aba
    call FUN_0050d775                            # 00519abf
    pop ecx                                      # 00519ac4
    mov byte ptr [0x63cdbc], al                  # 00519ac5
    ret                                          # 00519aca

