# FUN_0051cfd8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cfd8
# extent:       0x0051cfd8-0x0051cffc (36 code bytes)
# span:         0x0051cfd8-0x0051cffc (code 36, tables 0, padding 0)
# sha256:       210bf89f86be46f29bf2d0ed41c98784fe247cda45d42aad7df56aec39040998
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051cfd1 (+0x7)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cfd8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_24, field_2c; [esp + n] stk_4
# callees:      calls USER32.dll!PostMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051cffc
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------

.org 0x0051cfd8 - 0x401000
.globl FUN_0051cfd8
FUN_0051cfd8:
    # block 0x0051cfd8: entry, 5 instruction(s), ends with je to 0x0051cff9 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051cfd8
    mov dword ptr [ecx + field_2c], eax          # 0051cfdc
    mov eax, dword ptr [ecx + field_24]          # 0051cfdf
    test al, 0x10                                # 0051cfe2
    je.d8 L_0051cff9                             # 0051cfe4
    # block 0x0051cfe6: entered by fall-through of je at 0x0051cfe4, 8 instruction(s), calls USER32.dll!PostMessageA, falls into the block at 0x0051cff9
    and al, -0x11                                # 0051cfe6
    mov dword ptr [ecx + field_24], eax          # 0051cfe8
    {load} xor eax, eax                          # 0051cfeb
    push eax                                     # 0051cfed
    push eax                                     # 0051cfee
    push eax                                     # 0051cfef
    push dword ptr [ecx + field_1c]              # 0051cff0
    call dword ptr [0x52a31c]                    # 0051cff3
L_0051cff9:
    # block 0x0051cff9: entered by je at 0x0051cfe4, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051cff9

