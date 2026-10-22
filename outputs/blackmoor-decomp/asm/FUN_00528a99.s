# FUN_00528a99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a99
# extent:       0x00528a99-0x00528ab4 (27 code bytes)
# span:         0x00528a99-0x00528ab4 (code 27, tables 0, padding 0)
# sha256:       978ff36e056c64ff27412928ffe254dfea592c030c729abdc8eb9d37029ef6e9
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@00528a99
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528ab4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x00528a99 - 0x401000
.globl FUN_00528a99
FUN_00528a99:
    # block 0x00528a99: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 00528a99
    push 0x2                                     # 00528a9e
    push 0x18f                                   # 00528aa0
    mov eax, dword ptr [ebp - field_minus_10]    # 00528aa5
    add eax, 0xca8                               # 00528aa8
    push eax                                     # 00528aad
    call FUN_0050cba8                            # 00528aae
    ret                                          # 00528ab3

