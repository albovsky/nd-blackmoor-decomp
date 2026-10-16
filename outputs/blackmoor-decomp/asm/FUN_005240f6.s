# FUN_005240f6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005240f6
# extent:       0x005240f6-0x00524157 (97 code bytes)
# span:         0x005240f6-0x00524157 (code 97, tables 0, padding 0)
# sha256:       a0c859aafb8badf8997fa3f76b664b7c5bf02d955c7d877bb0a5e454cfca68a1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052401f (+0xd7)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005240f6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_1c; [esp + n] stk_c
# callees:      calls USER32.dll!GetKeyState; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x005240f6 - 0x401000
.globl FUN_005240f6
FUN_005240f6:
    # block 0x005240f6: entry, 8 instruction(s), ends with je to 0x0052413a (forward)
    push ebx                                     # 005240f6
    push esi                                     # 005240f7
    mov esi, dword ptr [esp + stk_c]             # 005240f8
    push 0x1                                     # 005240fc
    pop ebx                                      # 005240fe
    mov eax, dword ptr [esi + field_4]           # 005240ff
    sub eax, 0xe701                              # 00524102
    je.d8 L_0052413a                             # 00524107
    # block 0x00524109: entered by fall-through of je at 0x00524107, 2 instruction(s), ends with je to 0x00524133 (forward)
    dec eax                                      # 00524109
    je.d8 L_00524133                             # 0052410a
    # block 0x0052410c: entered by fall-through of je at 0x0052410a, 2 instruction(s), ends with je to 0x0052412c (forward)
    dec eax                                      # 0052410c
    je.d8 L_0052412c                             # 0052410d
    # block 0x0052410f: entered by fall-through of je at 0x0052410d, 2 instruction(s), ends with je to 0x00524119 (forward)
    sub eax, 0x3                                 # 0052410f
    je.d8 L_00524119                             # 00524112
    # block 0x00524114: entered by fall-through of je at 0x00524112, 2 instruction(s), ends with forward jump to 0x00524152
    mov dword ptr [esi + field_1c], ebx          # 00524114
    jmp.d8 L_00524152                            # 00524117
L_00524119:
    # block 0x00524119: entered by je at 0x00524112, 4 instruction(s), ends with jne to 0x0052413d (forward)
    cmp dword ptr [0x63c7a4], 0x0                # 00524119
    push 0x15                                    # 00524120
    pop eax                                      # 00524122
    jne.d8 L_0052413d                            # 00524123
    # block 0x00524125: entered by fall-through of jne at 0x00524123, 2 instruction(s), ends with forward jump to 0x0052413d
    mov ebx, 0x8000                              # 00524125
    jmp.d8 L_0052413d                            # 0052412a
L_0052412c:
    # block 0x0052412c: entered by je at 0x0052410d, 2 instruction(s), ends with forward jump to 0x0052413d
    mov eax, 0x91                                # 0052412c
    jmp.d8 L_0052413d                            # 00524131
L_00524133:
    # block 0x00524133: entered by je at 0x0052410a, 2 instruction(s), ends with forward jump to 0x0052413d
    mov eax, 0x90                                # 00524133
    jmp.d8 L_0052413d                            # 00524138
L_0052413a:
    # block 0x0052413a: entered by je at 0x00524107, 2 instruction(s), falls into the block at 0x0052413d
    push 0x14                                    # 0052413a
    pop eax                                      # 0052413c
L_0052413d:
    # block 0x0052413d: entered by jne at 0x00524123; jmp at 0x0052412a; jmp at 0x00524131; jmp at 0x00524138, 10 instruction(s), calls USER32.dll!GetKeyState, indirect dword ptr [edi], falls into the block at 0x00524152
    push edi                                     # 0052413d
    mov edi, dword ptr [esi]                     # 0052413e
    push eax                                     # 00524140
    call dword ptr [0x52a4b8]                    # 00524141
    movsx eax, ax                                # 00524147
    {load} and eax, ebx                          # 0052414a
    {load} mov ecx, esi                          # 0052414c
    push eax                                     # 0052414e
    call dword ptr [edi]                         # 0052414f
    pop edi                                      # 00524151
L_00524152:
    # block 0x00524152: entered by jmp at 0x00524117, 3 instruction(s), ends with ret 0x4
    pop esi                                      # 00524152
    pop ebx                                      # 00524153
    ret 0x4                                      # 00524154

