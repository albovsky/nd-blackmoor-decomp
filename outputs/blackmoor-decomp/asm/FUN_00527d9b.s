# FUN_00527d9b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527d9b
# extent:       0x00527d9b-0x00527daa (15 code bytes)
# span:         0x00527d9b-0x00527daa (code 15, tables 0, padding 0)
# sha256:       a675e82e2a103cfa5f8316afdaa9f1f125a4d677d37197ada8025ab6ca3126d9
# evidence:     ev_630eb8c9c6330d8d8954b0f0603252a92e8f72ed7f378cfbde79d9e20ec97ca4
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00527d9b
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004bf61f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004bf61f, .text + (0x004bf61f - 0x401000)

.org 0x00527d9b - 0x401000
.globl FUN_00527d9b
FUN_00527d9b:
    # block 0x00527d9b: entry, 4 instruction(s), calls FUN_004bf61f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527d9b
    add ecx, 0xc7c47                             # 00527d9e
    call FUN_004bf61f                            # 00527da4
    ret                                          # 00527da9

