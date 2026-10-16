# FUN_00511b29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511b29
# extent:       0x00511b29-0x00511b41 (24 code bytes)
# span:         0x00511b29-0x00511b41 (code 24, tables 0, padding 0)
# sha256:       9394ba15adedb2dbac8e1d3d5b4d167a5497d7696561ea5456670fb0bebb2a0d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00511a81 (+0xa8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511b29
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00511b29 - 0x401000
.globl FUN_00511b29
FUN_00511b29:
    # block 0x00511b29: entry, 6 instruction(s), ends with jb to 0x00511b3e (forward)
    mov eax, dword ptr [esp + stk_4]             # 00511b29
    fld qword ptr [eax]                          # 00511b2d
    fcomp qword ptr [0x52c7b0]                   # 00511b2f
    fnstsw ax                                    # 00511b35
    sahf                                         # 00511b37
    jb.d8 L_00511b3e                             # 00511b38
    # block 0x00511b3a: entered by fall-through of jb at 0x00511b38, 3 instruction(s), ends with ret
    push 0x1                                     # 00511b3a
    pop eax                                      # 00511b3c
    ret                                          # 00511b3d
L_00511b3e:
    # block 0x00511b3e: entered by jb at 0x00511b38, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00511b3e
    ret                                          # 00511b40

