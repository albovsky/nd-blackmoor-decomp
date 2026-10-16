# FUN_0051e2a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e2a0
# extent:       0x0051e2a0-0x0051e2c3 (35 code bytes)
# span:         0x0051e2a0-0x0051e2c3 (code 35, tables 0, padding 0)
# sha256:       e9e7d010f2034433c83622d18a6fba104b42b74d27a1373743fe271e28c7d6bd
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e2a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_74; [esi + n] field_1c, field_24; [esp + n] stk_8
# callees:      calls USER32.dll!EndDialog; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051e2c3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_74, 0x74  # offset +0x74

# --- external targets -----------------------------------------------

.org 0x0051e2a0 - 0x401000
.globl FUN_0051e2a0
FUN_0051e2a0:
    # block 0x0051e2a0: entry, 4 instruction(s), ends with je to 0x0051e2b2 (forward)
    push esi                                     # 0051e2a0
    {load} mov esi, ecx                          # 0051e2a1
    test byte ptr [esi + field_24], 0x18         # 0051e2a3
    je.d8 L_0051e2b2                             # 0051e2a7
    # block 0x0051e2a9: entered by fall-through of je at 0x0051e2a7, 3 instruction(s), calls indirect dword ptr [eax + 0x74], falls into the block at 0x0051e2b2
    mov eax, dword ptr [esi]                     # 0051e2a9
    push dword ptr [esp + stk_8]                 # 0051e2ab
    call dword ptr [eax + field_74]              # 0051e2af
L_0051e2b2:
    # block 0x0051e2b2: entered by je at 0x0051e2a7, 5 instruction(s), calls USER32.dll!EndDialog, ends with ret 0x4
    push dword ptr [esp + stk_8]                 # 0051e2b2
    push dword ptr [esi + field_1c]              # 0051e2b6
    call dword ptr [0x52a360]                    # 0051e2b9
    pop esi                                      # 0051e2bf
    ret 0x4                                      # 0051e2c0

