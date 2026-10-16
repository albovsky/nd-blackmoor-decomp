# FUN_00523dac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523dac
# extent:       0x00523dac-0x00523dcf (35 code bytes)
# span:         0x00523dac-0x00523dcf (code 35, tables 0, padding 0)
# sha256:       4ea428e911d998cad1c190f8c5464df973411457da04155a011bb256b8e6985b
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523c57 (+0x155)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523dac
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_24; [esp + n] stk_8
# callees:      calls USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x00523dac - 0x401000
.globl FUN_00523dac
FUN_00523dac:
    # block 0x00523dac: entry, 2 instruction(s), ends with je to 0x00523db6 (forward)
    test byte ptr [ecx + field_24], 0x40         # 00523dac
    je.d8 L_00523db6                             # 00523db0
    # block 0x00523db2: entered by fall-through of je at 0x00523db0, 2 instruction(s), ends with forward jump to 0x00523dcc
    {load} xor eax, eax                          # 00523db2
    jmp.d8 L_00523dcc                            # 00523db4
L_00523db6:
    # block 0x00523db6: entered by je at 0x00523db0, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x00523dcc
    push dword ptr [esp + stk_8]                 # 00523db6
    push dword ptr [esp + stk_8]                 # 00523dba
    push 0x362                                   # 00523dbe
    push dword ptr [ecx + field_1c]              # 00523dc3
    call dword ptr [0x52a4c8]                    # 00523dc6
L_00523dcc:
    # block 0x00523dcc: entered by jmp at 0x00523db4, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 00523dcc

