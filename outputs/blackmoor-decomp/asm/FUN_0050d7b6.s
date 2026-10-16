# FUN_0050d7b6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d7b6
# extent:       0x0050d7b6-0x0050d7e3 (45 code bytes)
# span:         0x0050d7b6-0x0050d7e3 (code 45, tables 0, padding 0)
# sha256:       209862cec03e3e37164ffe251931025cc45c5d0e8f2eff5928a24f9216ebb533
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d7b6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d8bc; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d8bc, .text + (0x0050d8bc - 0x401000)

.org 0x0050d7b6 - 0x401000
.globl FUN_0050d7b6
FUN_0050d7b6:
    # block 0x0050d7b6: entry, 3 instruction(s), ends with je to 0x0050d7c1 (forward)
    mov eax, dword ptr [0x567e28]                # 0050d7b6
    test eax, eax                                # 0050d7bb
    je.d8 L_0050d7c1                             # 0050d7bd
    # block 0x0050d7bf: entered by fall-through of je at 0x0050d7bd, 1 instruction(s), calls indirect eax, falls into the block at 0x0050d7c1
    call eax                                     # 0050d7bf
L_0050d7c1:
    # block 0x0050d7c1: entered by je at 0x0050d7bd, 8 instruction(s), calls FUN_0050d8bc, ends with ret
    push 0x537094                                # 0050d7c1
    push 0x537080                                # 0050d7c6
    call FUN_0050d8bc                            # 0050d7cb
    push 0x53707c                                # 0050d7d0
    push 0x537000                                # 0050d7d5
    call FUN_0050d8bc                            # 0050d7da
    add esp, 0x10                                # 0050d7df
    ret                                          # 0050d7e2

