# FUN_00519c54
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519c54
# extent:       0x00519c54-0x00519c7d (41 code bytes)
# span:         0x00519c54-0x00519c7d (code 41, tables 0, padding 0)
# sha256:       b051575091de6dee355d0e17467b8b090ba0ec706155477017e45f2f02cae67f
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519c54
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c, field_10, field_14, field_94
# callees:      calls FUN_0051fb2e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00519c7d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_94, 0x94  # offset +0x94

# --- external targets -----------------------------------------------
.set FUN_0051fb2e, .text + (0x0051fb2e - 0x401000)

.org 0x00519c54 - 0x401000
.globl FUN_00519c54
FUN_00519c54:
    # block 0x00519c54: entry, 14 instruction(s), calls FUN_0051fb2e, ends with ret
    push esi                                     # 00519c54
    {load} mov esi, ecx                          # 00519c55
    push 0x80                                    # 00519c57
    lea eax, [esi + field_14]                    # 00519c5c
    mov dword ptr [esi + field_c], 0x1           # 00519c5f
    push eax                                     # 00519c66
    push dword ptr [esi + field_94]              # 00519c67
    call FUN_0051fb2e                            # 00519c6d
    neg eax                                      # 00519c72
    {load} sbb eax, eax                          # 00519c74
    neg eax                                      # 00519c76
    mov dword ptr [esi + field_10], eax          # 00519c78
    pop esi                                      # 00519c7b
    ret                                          # 00519c7c

