# FUN_0050cc86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cc86
# extent:       0x0050cc86-0x0050cc9c (22 code bytes)
# span:         0x0050cc86-0x0050cc9c (code 22, tables 0, padding 0)
# sha256:       bd70fe6c99c9ed47ef72db7e369f2e22c8be12b47282242c9cec3dafe837bf9d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050cc28 (+0x5e)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cc86
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls tail jump FUN_00510eda
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00510eda, .text + (0x00510eda - 0x401000)

.org 0x0050cc86 - 0x401000
.globl FUN_0050cc86
FUN_0050cc86:
    # block 0x0050cc86: entry, 4 instruction(s), ends with je to 0x0050cc97 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0050cc86
    mov eax, dword ptr [eax]                     # 0050cc8a
    cmp dword ptr [eax], 0xe06d7363              # 0050cc8c
    je.d8 L_0050cc97                             # 0050cc92
    # block 0x0050cc94: entered by fall-through of je at 0x0050cc92, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050cc94
    ret                                          # 0050cc96
L_0050cc97:
    # block 0x0050cc97: entered by je at 0x0050cc92, 1 instruction(s), ends with forward jump to 0x00510eda
    jmp.d32 FUN_00510eda                         # 0050cc97

