# FUN_0050c950
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c950
# extent:       0x0050c950-0x0050c970 (32 code bytes)
# span:         0x0050c950-0x0050c970 (code 32, tables 0, padding 0)
# sha256:       96524f2d95fec101cca712ec9236a4982a82782cc4c35d61e00248eb273a4f10
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __global_unwind2
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00519a24
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0050c970
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00519a24, .text + (0x00519a24 - 0x401000)

.org 0x0050c950 - 0x401000
.globl FUN_0050c950
FUN_0050c950:
    # block 0x0050c950: entry, 18 instruction(s), calls FUN_00519a24, ends with ret
    push ebp                                     # 0050c950
    {load} mov ebp, esp                          # 0050c951
    push ebx                                     # 0050c953
    push esi                                     # 0050c954
    push edi                                     # 0050c955
    push ebp                                     # 0050c956
    push 0x0                                     # 0050c957
    push 0x0                                     # 0050c959
    push 0x50c968                                # 0050c95b
    push dword ptr [ebp + arg_8]                 # 0050c960
    call FUN_00519a24                            # 0050c963
    pop ebp                                      # 0050c968
    pop edi                                      # 0050c969
    pop esi                                      # 0050c96a
    pop ebx                                      # 0050c96b
    {load} mov esp, ebp                          # 0050c96c
    pop ebp                                      # 0050c96e
    ret                                          # 0050c96f

