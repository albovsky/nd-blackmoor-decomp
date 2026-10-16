# FUN_00515cc7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515cc7
# extent:       0x00515cc7-0x00515d0d (70 code bytes)
# span:         0x00515cc7-0x00515d0d (code 70, tables 0, padding 0)
# sha256:       2c1ef2b0bcfabb06fae7717627043dd0bdc9ffb43445945cf30c89a651023230
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515cc7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10, field_14; [esp + n] stk_8
# callees:      calls tail jump FUN_00510eda, FUN_00516638; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00515d0d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00510eda, .text + (0x00510eda - 0x401000)
.set FUN_00516638, .text + (0x00516638 - 0x401000)

.org 0x00515cc7 - 0x401000
.globl FUN_00515cc7
FUN_00515cc7:
    # block 0x00515cc7: entry, 5 instruction(s), ends with jne to 0x00515cea (forward)
    push esi                                     # 00515cc7
    mov esi, dword ptr [esp + stk_8]             # 00515cc8
    mov eax, dword ptr [esi]                     # 00515ccc
    cmp dword ptr [eax], 0xe06d7363              # 00515cce
    jne.d8 L_00515cea                            # 00515cd4
    # block 0x00515cd6: entered by fall-through of jne at 0x00515cd4, 2 instruction(s), ends with jne to 0x00515cea (forward)
    cmp dword ptr [eax + field_10], 0x3          # 00515cd6
    jne.d8 L_00515cea                            # 00515cda
    # block 0x00515cdc: entered by fall-through of jne at 0x00515cda, 2 instruction(s), ends with jne to 0x00515cea (forward)
    cmp dword ptr [eax + field_14], 0x19930520   # 00515cdc
    jne.d8 L_00515cea                            # 00515ce3
    # block 0x00515ce5: entered by fall-through of jne at 0x00515ce3, 1 instruction(s), ends with backward jump to 0x00510eda
    jmp.d32 FUN_00510eda                         # 00515ce5
L_00515cea:
    # block 0x00515cea: entered by jne at 0x00515cd4; jne at 0x00515cda; jne at 0x00515ce3, 3 instruction(s), ends with je to 0x00515d07 (forward)
    mov eax, dword ptr [0x63cc50]                # 00515cea
    test eax, eax                                # 00515cef
    je.d8 L_00515d07                             # 00515cf1
    # block 0x00515cf3: entered by fall-through of je at 0x00515cf1, 5 instruction(s), calls FUN_00516638, ends with je to 0x00515d07 (forward)
    push eax                                     # 00515cf3
    call FUN_00516638                            # 00515cf4
    test eax, eax                                # 00515cf9
    pop ecx                                      # 00515cfb
    je.d8 L_00515d07                             # 00515cfc
    # block 0x00515cfe: entered by fall-through of je at 0x00515cfc, 3 instruction(s), calls indirect dword ptr [0x63cc50], ends with forward jump to 0x00515d09
    push esi                                     # 00515cfe
    call dword ptr [0x63cc50]                    # 00515cff
    jmp.d8 L_00515d09                            # 00515d05
L_00515d07:
    # block 0x00515d07: entered by je at 0x00515cf1; je at 0x00515cfc, 1 instruction(s), falls into the block at 0x00515d09
    {load} xor eax, eax                          # 00515d07
L_00515d09:
    # block 0x00515d09: entered by jmp at 0x00515d05, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 00515d09
    ret 0x4                                      # 00515d0a

