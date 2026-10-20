# FUN_0051c107
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c107
# extent:       0x0051c107-0x0051c14c (69 code bytes)
# span:         0x0051c107-0x0051c14c (code 69, tables 0, padding 0)
# sha256:       2230e437592c04fc22fc6fb9fbcf9f7338c67769ccca2e77793f869b7f8e76c9
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         AfxGetParentOwner
# naming:       Ghidra name from function-index.json (not re-derived here); summary is the ledger reason (win32_plumbing_no_observable_effect, function-ledger-overrides.json not_needed_entries)
# summary:      AfxGetParentOwner: GetWindowLong/GetParent/GetWindow owner lookup; window handle plumbing only
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [esp + n] stk_8
# callees:      calls FUN_0051ac0b, FUN_0050c17c, USER32.dll!GetWindowLongA, USER32.dll!GetParent, USER32.dll!GetWindow
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c17c, .text + (0x0050c17c - 0x401000)
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)

.org 0x0051c107 - 0x401000
.globl FUN_0051c107
FUN_0051c107:
    # block 0x0051c107: entry, 6 instruction(s), calls FUN_0051ac0b, ends with je to 0x0051c126 (forward)
    push esi                                     # 0051c107
    mov esi, dword ptr [esp + stk_8]             # 0051c108
    push esi                                     # 0051c10c
    call FUN_0051ac0b                            # 0051c10d
    test eax, eax                                # 0051c112
    je.d8 L_0051c126                             # 0051c114
    # block 0x0051c116: entered by fall-through of je at 0x0051c114, 4 instruction(s), calls FUN_0050c17c, ends with je to 0x0051c148 (forward)
    {load} mov ecx, eax                          # 0051c116
    call FUN_0050c17c                            # 0051c118
    test eax, eax                                # 0051c11d
    je.d8 L_0051c148                             # 0051c11f
    # block 0x0051c121: entered by fall-through of je at 0x0051c11f, 2 instruction(s), ends with forward jump to 0x0051c148
    mov eax, dword ptr [eax + field_1c]          # 0051c121
    jmp.d8 L_0051c148                            # 0051c124
L_0051c126:
    # block 0x0051c126: entered by je at 0x0051c114, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x0051c13f (forward)
    push -0x10                                   # 0051c126
    push esi                                     # 0051c128
    call dword ptr [0x52a454]                    # 0051c129
    test eax, 0x40000000                         # 0051c12f
    je.d8 L_0051c13f                             # 0051c134
    # block 0x0051c136: entered by fall-through of je at 0x0051c134, 3 instruction(s), calls USER32.dll!GetParent, ends with forward jump to 0x0051c148
    push esi                                     # 0051c136
    call dword ptr [0x52a3dc]                    # 0051c137
    jmp.d8 L_0051c148                            # 0051c13d
L_0051c13f:
    # block 0x0051c13f: entered by je at 0x0051c134, 3 instruction(s), calls USER32.dll!GetWindow, falls into the block at 0x0051c148
    push 0x4                                     # 0051c13f
    push esi                                     # 0051c141
    call dword ptr [0x52a450]                    # 0051c142
L_0051c148:
    # block 0x0051c148: entered by je at 0x0051c11f; jmp at 0x0051c124; jmp at 0x0051c13d, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051c148
    ret 0x4                                      # 0051c149

