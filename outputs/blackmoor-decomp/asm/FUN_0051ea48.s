# FUN_0051ea48
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ea48
# extent:       0x0051ea48-0x0051ea5d (21 code bytes)
# span:         0x0051ea48-0x0051ea5d (code 21, tables 0, padding 0)
# sha256:       7978891a90385a731fbd636c188d534a366696e891639e68e60365517bddbba2
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ea48
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0051e9c2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051e9c2, .text + (0x0051e9c2 - 0x401000)

.org 0x0051ea48 - 0x401000
.globl FUN_0051ea48
FUN_0051ea48:
    # block 0x0051ea48: entry, 9 instruction(s), calls FUN_0051e9c2, ends with ret 0x4
    lea eax, [esp + stk_4]                       # 0051ea48
    push esi                                     # 0051ea4c
    push eax                                     # 0051ea4d
    {load} mov esi, ecx                          # 0051ea4e
    push 0x1                                     # 0051ea50
    call FUN_0051e9c2                            # 0051ea52
    {load} mov eax, esi                          # 0051ea57
    pop esi                                      # 0051ea59
    ret 0x4                                      # 0051ea5a

