# FUN_0051e239
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e239
# extent:       0x0051e239-0x0051e24e (21 code bytes)
# span:         0x0051e239-0x0051e24e (code 21, tables 0, padding 0)
# sha256:       6b689d71cee597e9b3445d35ee9a9a3b4f7a4e0c252c37c6712fc9818c3f2c1c
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@0051e239
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated C++ catch handler funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_2c; [ebp + n] field_minus_1c, field_minus_24
# callees:      calls FUN_0051f636
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0051e24e
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_24, 0x24  # offset -0x24
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0051f636, .text + (0x0051f636 - 0x401000)

.org 0x0051e239 - 0x401000
.globl FUN_0051e239
FUN_0051e239:
    # block 0x0051e239: entry, 6 instruction(s), calls FUN_0051f636, ends with ret
    mov ecx, dword ptr [ebp - field_minus_24]    # 0051e239
    call FUN_0051f636                            # 0051e23c
    mov eax, dword ptr [ebp - field_minus_1c]    # 0051e241
    or dword ptr [eax + field_2c], -0x1          # 0051e244
    mov eax, 0x51e24e                            # 0051e248
    ret                                          # 0051e24d

