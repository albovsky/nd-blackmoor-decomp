# FUN_00525e9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525e9c
# extent:       0x00525e9c-0x00525eb6 (26 code bytes)
# span:         0x00525e9c-0x00525eb6 (code 26, tables 0, padding 0)
# sha256:       d1708f755095b06b8b740a17dabe46706be928b90a2e272ddd4844e600925637
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00525e69 (+0x33)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525e9c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_0051dc43
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525eb6
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00525e9c - 0x401000
.globl FUN_00525e9c
FUN_00525e9c:
    # block 0x00525e9c: entry, 5 instruction(s), calls FUN_0051dc43, ends with je to 0x00525eb3 (forward)
    push 0x8                                     # 00525e9c
    call FUN_0051dc43                            # 00525e9e
    test eax, eax                                # 00525ea3
    pop ecx                                      # 00525ea5
    je.d8 L_00525eb3                             # 00525ea6
    # block 0x00525ea8: entered by fall-through of je at 0x00525ea6, 3 instruction(s), ends with ret
    mov dword ptr [eax], 0x52ff14                # 00525ea8
    and dword ptr [eax + field_4], 0x0           # 00525eae
    ret                                          # 00525eb2
L_00525eb3:
    # block 0x00525eb3: entered by je at 0x00525ea6, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00525eb3
    ret                                          # 00525eb5

