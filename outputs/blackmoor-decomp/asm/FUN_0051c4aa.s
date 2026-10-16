# FUN_0051c4aa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c4aa
# extent:       0x0051c4aa-0x0051c4ec (66 code bytes)
# span:         0x0051c4aa-0x0051c4ec (code 66, tables 0, padding 0)
# sha256:       39f343bd67ace4f0a7b05ac0c1fb5f619f9d42e4c1f51a5cd7139e2c7545b215
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c4aa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_90; [esp + n] stk_c, stk_10
# callees:      calls FUN_0051ac0b, USER32.dll!GetParent; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)

.org 0x0051c4aa - 0x401000
.globl FUN_0051c4aa
FUN_0051c4aa:
    # block 0x0051c4aa: entry, 4 instruction(s), falls into the block at 0x0051c4b2
    push esi                                     # 0051c4aa
    push edi                                     # 0051c4ab
    mov edi, dword ptr [esp + stk_10]            # 0051c4ac
    mov esi, dword ptr [edi]                     # 0051c4b0
L_0051c4b2:
    # block 0x0051c4b2: entered by jmp at 0x0051c4de, 2 instruction(s), ends with je to 0x0051c4e5 (forward)
    test esi, esi                                # 0051c4b2
    je.d8 L_0051c4e5                             # 0051c4b4
    # block 0x0051c4b6: entered by fall-through of je at 0x0051c4b4, 4 instruction(s), calls FUN_0051ac0b, ends with je to 0x0051c4cf (forward)
    push esi                                     # 0051c4b6
    call FUN_0051ac0b                            # 0051c4b7
    test eax, eax                                # 0051c4bc
    je.d8 L_0051c4cf                             # 0051c4be
    # block 0x0051c4c0: entered by fall-through of je at 0x0051c4be, 6 instruction(s), calls indirect dword ptr [edx + 0x90], ends with jne to 0x0051c4e0 (forward)
    mov edx, dword ptr [eax]                     # 0051c4c0
    push edi                                     # 0051c4c2
    {load} mov ecx, eax                          # 0051c4c3
    call dword ptr [edx + field_90]              # 0051c4c5
    test eax, eax                                # 0051c4cb
    jne.d8 L_0051c4e0                            # 0051c4cd
L_0051c4cf:
    # block 0x0051c4cf: entered by je at 0x0051c4be; fall-through of jne at 0x0051c4cd, 2 instruction(s), ends with je to 0x0051c4e5 (forward)
    cmp esi, dword ptr [esp + stk_c]             # 0051c4cf
    je.d8 L_0051c4e5                             # 0051c4d3
    # block 0x0051c4d5: entered by fall-through of je at 0x0051c4d3, 4 instruction(s), calls USER32.dll!GetParent, ends with backward jump to 0x0051c4b2
    push esi                                     # 0051c4d5
    call dword ptr [0x52a3dc]                    # 0051c4d6
    {load} mov esi, eax                          # 0051c4dc
    jmp.d8 L_0051c4b2                            # 0051c4de
L_0051c4e0:
    # block 0x0051c4e0: entered by jne at 0x0051c4cd, 3 instruction(s), ends with forward jump to 0x0051c4e7
    push 0x1                                     # 0051c4e0
    pop eax                                      # 0051c4e2
    jmp.d8 L_0051c4e7                            # 0051c4e3
L_0051c4e5:
    # block 0x0051c4e5: entered by je at 0x0051c4b4; je at 0x0051c4d3, 1 instruction(s), falls into the block at 0x0051c4e7
    {load} xor eax, eax                          # 0051c4e5
L_0051c4e7:
    # block 0x0051c4e7: entered by jmp at 0x0051c4e3, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0051c4e7
    pop esi                                      # 0051c4e8
    ret 0x8                                      # 0051c4e9

