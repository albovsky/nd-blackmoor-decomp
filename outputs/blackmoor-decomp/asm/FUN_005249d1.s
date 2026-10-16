# FUN_005249d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005249d1
# extent:       0x005249d1-0x005249e6 (21 code bytes)
# span:         0x005249d1-0x005249e6 (code 21, tables 0, padding 0)
# sha256:       827d071ec2d00688eb6305d042ccc236d007d0f7923d9370a0ff5c988ed7c560
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005249a0 (+0x31)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005249d1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005256dd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x005249d1 - 0x401000
.globl FUN_005249d1
FUN_005249d1:
    # block 0x005249d1: entry, 4 instruction(s), calls FUN_005256dd, ends with je to 0x005249e3 (forward)
    push 0x30                                    # 005249d1
    call FUN_005256dd                            # 005249d3
    test eax, eax                                # 005249d8
    je.d8 L_005249e3                             # 005249da
    # block 0x005249dc: entered by fall-through of je at 0x005249da, 2 instruction(s), ends with ret
    mov dword ptr [eax], 0x52ec38                # 005249dc
    ret                                          # 005249e2
L_005249e3:
    # block 0x005249e3: entered by je at 0x005249da, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 005249e3
    ret                                          # 005249e5

