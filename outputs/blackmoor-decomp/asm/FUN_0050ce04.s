# FUN_0050ce04
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ce04
# extent:       0x0050ce04-0x0050ce2b (39 code bytes)
# span:         0x0050ce04-0x0050ce2b (code 39, tables 0, padding 0)
# sha256:       d0a2aca68648a0ae9d5cbfae1b276d4a64d4f797fc0c60f28b64096cdfa3148c
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __ftol
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_2, local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d9_runtime.c:ftol_low (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_2, 0x2  # offset -0x2
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------

.org 0x0050ce04 - 0x401000
.globl FUN_0050ce04
FUN_0050ce04:
    # block 0x0050ce04: entry, 16 instruction(s), ends with ret
    push ebp                                     # 0050ce04
    {load} mov ebp, esp                          # 0050ce05
    add esp, -0xc                                # 0050ce07
    wait                                         # 0050ce0a
    fnstcw word ptr [ebp - local_2]              # 0050ce0b
    wait                                         # 0050ce0e
    mov ax, word ptr [ebp - local_2]             # 0050ce0f
    or ah, 0xc                                   # 0050ce13
    mov word ptr [ebp - local_4], ax             # 0050ce16
    fldcw word ptr [ebp - local_4]               # 0050ce1a
    fistp qword ptr [ebp - local_c]              # 0050ce1d
    fldcw word ptr [ebp - local_2]               # 0050ce20
    mov eax, dword ptr [ebp - local_c]           # 0050ce23
    mov edx, dword ptr [ebp - local_8]           # 0050ce26
    leave                                        # 0050ce29
    ret                                          # 0050ce2a

