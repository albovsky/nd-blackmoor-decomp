# FUN_0051ea5d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ea5d
# extent:       0x0051ea5d-0x0051ea75 (24 code bytes)
# span:         0x0051ea5d-0x0051ea75 (code 24, tables 0, padding 0)
# sha256:       d40d1b44ce5cb34b11a199896c789d0bb7219f396cda9d4fea099650ba152815
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ea5d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8; [esp + n] stk_4
# callees:      calls FUN_0051e9c2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051e9c2, .text + (0x0051e9c2 - 0x401000)

.org 0x0051ea5d - 0x401000
.globl FUN_0051ea5d
FUN_0051ea5d:
    # block 0x0051ea5d: entry, 10 instruction(s), calls FUN_0051e9c2, ends with ret 0x4
    mov eax, dword ptr [esp + stk_4]             # 0051ea5d
    push esi                                     # 0051ea61
    {load} mov esi, ecx                          # 0051ea62
    mov eax, dword ptr [eax]                     # 0051ea64
    push eax                                     # 0051ea66
    push dword ptr [eax - field_minus_8]         # 0051ea67
    call FUN_0051e9c2                            # 0051ea6a
    {load} mov eax, esi                          # 0051ea6f
    pop esi                                      # 0051ea71
    ret 0x4                                      # 0051ea72

