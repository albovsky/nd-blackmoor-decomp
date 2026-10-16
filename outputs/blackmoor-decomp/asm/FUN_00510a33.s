# FUN_00510a33
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510a33
# extent:       0x00510a33-0x00510a4b (24 code bytes)
# span:         0x00510a33-0x00510a4b (code 24, tables 0, padding 0)
# sha256:       b3de0389d81e9b148c1389c8d4803aa51803c86bea6b616ee8ab3f04e79ac697
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00510984 (+0xaf)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510a33
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10, field_minus_18, field_minus_2c
# callees:      calls FUN_0050c992, tail jump LOC_00510a1a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00510a4b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_2c, 0x2c  # offset -0x2c

# --- external targets -----------------------------------------------
.set FUN_0050c992, .text + (0x0050c992 - 0x401000)
.set LOC_00510a1a, .text + (0x00510a1a - 0x401000)

.org 0x00510a33 - 0x401000
.globl FUN_00510a33
FUN_00510a33:
    # block 0x00510a33: entry, 10 instruction(s), calls FUN_0050c992, ends with backward jump to 0x00510a1a
    mov esp, dword ptr [ebp - field_minus_18]    # 00510a33
    and dword ptr [ebp - field_minus_2c], 0x0    # 00510a36
    push -0x1                                    # 00510a3a
    lea eax, [ebp - field_minus_10]              # 00510a3c
    push eax                                     # 00510a3f
    call FUN_0050c992                            # 00510a40
    pop ecx                                      # 00510a45
    pop ecx                                      # 00510a46
    {load} xor eax, eax                          # 00510a47
    jmp.d8 . + (-47)  # -> LOC_00510a1a          # 00510a49

