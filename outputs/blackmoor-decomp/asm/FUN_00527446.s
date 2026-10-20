# FUN_00527446
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527446
# extent:       0x00527446-0x00527455 (15 code bytes)
# span:         0x00527446-0x00527455 (code 15, tables 0, padding 0)
# sha256:       47ceb8bb87ca05205677d211b33225c00eff3067b4bd7d6e9140f370c8c37b3b
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527446
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e2d63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e2d63, .text + (0x004e2d63 - 0x401000)

.org 0x00527446 - 0x401000
.globl FUN_00527446
FUN_00527446:
    # block 0x00527446: entry, 4 instruction(s), calls FUN_004e2d63, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527446
    add ecx, 0x93d4                              # 00527449
    call FUN_004e2d63                            # 0052744f
    ret                                          # 00527454

