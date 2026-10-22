# FUN_00521b22
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521b22
# extent:       0x00521b22-0x00521b3c (26 code bytes)
# span:         0x00521b22-0x00521b3c (code 26, tables 0, padding 0)
# sha256:       5fbd45fcaf9e4a17ec0cce44248a56aae3e71897a02778124eab328217342abd
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521b22
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_88
# callees:      calls FUN_0051cab3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00521b3c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_88, 0x88  # offset +0x88

# --- external targets -----------------------------------------------
.set FUN_0051cab3, .text + (0x0051cab3 - 0x401000)

.org 0x00521b22 - 0x401000
.globl FUN_00521b22
FUN_00521b22:
    # block 0x00521b22: entry, 4 instruction(s), ends with je to 0x00521b32 (forward)
    lea eax, [ecx + field_88]                    # 00521b22
    {load} xor edx, edx                          # 00521b28
    cmp dword ptr [eax], edx                     # 00521b2a
    je.d8 L_00521b32                             # 00521b2c
    # block 0x00521b2e: entered by fall-through of je at 0x00521b2c, 2 instruction(s), ends with forward jump to 0x00521b38
    mov dword ptr [eax], edx                     # 00521b2e
    jmp.d8 L_00521b38                            # 00521b30
L_00521b32:
    # block 0x00521b32: entered by je at 0x00521b2c, 2 instruction(s), calls FUN_0051cab3, falls into the block at 0x00521b38
    push edx                                     # 00521b32
    call FUN_0051cab3                            # 00521b33
L_00521b38:
    # block 0x00521b38: entered by jmp at 0x00521b30, 3 instruction(s), ends with ret
    push 0x1                                     # 00521b38
    pop eax                                      # 00521b3a
    ret                                          # 00521b3b

