# FUN_0052730d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052730d
# extent:       0x0052730d-0x00527325 (24 code bytes)
# span:         0x0052730d-0x00527325 (code 24, tables 0, padding 0)
# sha256:       3ee38a1c5a80a0c0ea6749240cc197f463ec40d12fb7ee859fb3a09c0a462beb
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@0052730d
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x0052730d - 0x401000
.globl FUN_0052730d
FUN_0052730d:
    # block 0x0052730d: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x51e7ba                                # 0052730d
    push 0x1e                                    # 00527312
    push 0x4                                     # 00527314
    mov eax, dword ptr [ebp - field_minus_14]    # 00527316
    add eax, 0xea5                               # 00527319
    push eax                                     # 0052731e
    call FUN_0050cba8                            # 0052731f
    ret                                          # 00527324

