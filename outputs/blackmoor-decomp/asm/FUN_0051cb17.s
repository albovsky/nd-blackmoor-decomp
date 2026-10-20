# FUN_0051cb17
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cb17
# extent:       0x0051cb17-0x0051cb35 (30 code bytes)
# span:         0x0051cb17-0x0051cb35 (code 30, tables 0, padding 0)
# sha256:       b33d3a7e9f0c6fa2e7ff70d576c320329882db1e4e4db378d581d60f7c112e21
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@0051cb17
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Compiler-generated C++ catch handler funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10; [ebp + n] field_minus_1c
# callees:      calls FUN_0051f636; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051cb35
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051f636, .text + (0x0051f636 - 0x401000)

.org 0x0051cb17 - 0x401000
.globl FUN_0051cb17
FUN_0051cb17:
    # block 0x0051cb17: entry, 10 instruction(s), calls indirect dword ptr [eax + 0x10], FUN_0051f636, ends with ret
    mov esi, dword ptr [ebp - field_minus_1c]    # 0051cb17
    push 0xf108                                  # 0051cb1a
    push 0x30                                    # 0051cb1f
    {load} mov ecx, esi                          # 0051cb21
    mov eax, dword ptr [esi]                     # 0051cb23
    call dword ptr [eax + field_10]              # 0051cb25
    {load} mov ecx, esi                          # 0051cb28
    call FUN_0051f636                            # 0051cb2a
    mov eax, 0x51cb35                            # 0051cb2f
    ret                                          # 0051cb34

