# FUN_00520fbf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520fbf
# extent:       0x00520fbf-0x00520fd4 (21 code bytes)
# span:         0x00520fbf-0x00520fd4 (code 21, tables 0, padding 0)
# sha256:       115003e7ae91ba68f6634e92018edfe56aaf4ceda3911bd243344fdbb077a13e
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520fbf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00520f4d, FUN_0051f805
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051f805, .text + (0x0051f805 - 0x401000)
.set FUN_00520f4d, .text + (0x00520f4d - 0x401000)

.org 0x00520fbf - 0x401000
.globl FUN_00520fbf
FUN_00520fbf:
    # block 0x00520fbf: entry, 6 instruction(s), calls FUN_00520f4d, FUN_0051f805, ends with ret 0x4
    push 0x1                                     # 00520fbf
    call FUN_00520f4d                            # 00520fc1
    {load} mov ecx, eax                          # 00520fc6
    push dword ptr [esp + stk_4]                 # 00520fc8
    call FUN_0051f805                            # 00520fcc
    ret 0x4                                      # 00520fd1

