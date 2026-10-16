# FUN_00520a19
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520a19
# extent:       0x00520a19-0x00520a2c (19 code bytes)
# span:         0x00520a19-0x00520a2c (code 19, tables 0, padding 0)
# sha256:       c971fca4492e43dc280334441385e1f0575fc928b2876e13fb034fe625b78340
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005209a3 (+0x76)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520a19
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ecx + n] field_1c
# callees:      calls USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00520a19 - 0x401000
.globl FUN_00520a19
FUN_00520a19:
    # block 0x00520a19: entry, 7 instruction(s), calls USER32.dll!SendMessageA, ends with ret
    mov eax, dword ptr [ecx + field_1c]          # 00520a19
    push 0x0                                     # 00520a1c
    push 0x0                                     # 00520a1e
    push 0x10                                    # 00520a20
    push dword ptr [eax + field_1c]              # 00520a22
    call dword ptr [0x52a4c8]                    # 00520a25
    ret                                          # 00520a2b

