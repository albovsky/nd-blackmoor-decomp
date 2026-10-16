# FUN_0051dcb7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dcb7
# extent:       0x0051dcb7-0x0051dd50 (153 code bytes)
# span:         0x0051dcb7-0x0051dd50 (code 153, tables 0, padding 0)
# sha256:       c5c4d9b090ed6a9b8b5c8d062be70175d772a5002eab3719fdac77fc84828cfe
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051dc77 (+0x40)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051dcb7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50; [edi + n] field_4, field_8; [esi + n] field_1c; [esp + n] stk_c
# callees:      calls FUN_0051b4ac, FUN_0051c174, USER32.dll!GetWindowLongA, FUN_00521077, USER32.dll!GetDlgItem, USER32.dll!IsWindowEnabled, USER32.dll!SendMessageA, FUN_0051ce42
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0051b4ac, .text + (0x0051b4ac - 0x401000)
.set FUN_0051c174, .text + (0x0051c174 - 0x401000)
.set FUN_0051ce42, .text + (0x0051ce42 - 0x401000)
.set FUN_00521077, .text + (0x00521077 - 0x401000)

.org 0x0051dcb7 - 0x401000
.globl FUN_0051dcb7
FUN_0051dcb7:
    # block 0x0051dcb7: entry, 8 instruction(s), calls FUN_0051b4ac, ends with jne to 0x0051dd3e (forward)
    push esi                                     # 0051dcb7
    push edi                                     # 0051dcb8
    mov edi, dword ptr [esp + stk_c]             # 0051dcb9
    {load} mov esi, ecx                          # 0051dcbd
    push edi                                     # 0051dcbf
    call FUN_0051b4ac                            # 0051dcc0
    test eax, eax                                # 0051dcc5
    jne.d8 L_0051dd3e                            # 0051dcc7
    # block 0x0051dcc9: entered by fall-through of jne at 0x0051dcc7, 4 instruction(s), calls FUN_0051c174, ends with je to 0x0051dcde (forward)
    {load} mov ecx, esi                          # 0051dcc9
    call FUN_0051c174                            # 0051dccb
    test eax, eax                                # 0051dcd0
    je.d8 L_0051dcde                             # 0051dcd2
    # block 0x0051dcd4: entered by fall-through of je at 0x0051dcd2, 2 instruction(s), ends with je to 0x0051dcde (forward)
    cmp dword ptr [eax + field_50], 0x0          # 0051dcd4
    je.d8 L_0051dcde                             # 0051dcd8
    # block 0x0051dcda: entered by fall-through of je at 0x0051dcd8, 2 instruction(s), ends with forward jump to 0x0051dd4b
    {load} xor eax, eax                          # 0051dcda
    jmp.d8 L_0051dd4b                            # 0051dcdc
L_0051dcde:
    # block 0x0051dcde: entered by je at 0x0051dcd2; je at 0x0051dcd8, 2 instruction(s), ends with jne to 0x0051dd43 (forward)
    cmp dword ptr [edi + field_4], 0x100         # 0051dcde
    jne.d8 L_0051dd43                            # 0051dce5
    # block 0x0051dce7: entered by fall-through of jne at 0x0051dce5, 3 instruction(s), ends with je to 0x0051dcf4 (forward)
    mov eax, dword ptr [edi + field_8]           # 0051dce7
    cmp eax, 0x1b                                # 0051dcea
    je.d8 L_0051dcf4                             # 0051dced
    # block 0x0051dcef: entered by fall-through of je at 0x0051dced, 2 instruction(s), ends with jne to 0x0051dd43 (forward)
    cmp eax, 0x3                                 # 0051dcef
    jne.d8 L_0051dd43                            # 0051dcf2
L_0051dcf4:
    # block 0x0051dcf4: entered by je at 0x0051dced; fall-through of jne at 0x0051dcf2, 5 instruction(s), calls USER32.dll!GetWindowLongA, ends with je to 0x0051dd43 (forward)
    push -0x10                                   # 0051dcf4
    push dword ptr [edi]                         # 0051dcf6
    call dword ptr [0x52a454]                    # 0051dcf8
    test al, 0x4                                 # 0051dcfe
    je.d8 L_0051dd43                             # 0051dd00
    # block 0x0051dd02: entered by fall-through of je at 0x0051dd00, 5 instruction(s), calls FUN_00521077, ends with je to 0x0051dd43 (forward)
    push 0x52f290                                # 0051dd02
    push dword ptr [edi]                         # 0051dd07
    call FUN_00521077                            # 0051dd09
    test eax, eax                                # 0051dd0e
    je.d8 L_0051dd43                             # 0051dd10
    # block 0x0051dd12: entered by fall-through of je at 0x0051dd10, 5 instruction(s), calls USER32.dll!GetDlgItem, ends with je to 0x0051dd2c (forward)
    push 0x2                                     # 0051dd12
    push dword ptr [esi + field_1c]              # 0051dd14
    call dword ptr [0x52a404]                    # 0051dd17
    test eax, eax                                # 0051dd1d
    je.d8 L_0051dd2c                             # 0051dd1f
    # block 0x0051dd21: entered by fall-through of je at 0x0051dd1f, 4 instruction(s), calls USER32.dll!IsWindowEnabled, ends with je to 0x0051dd43 (forward)
    push eax                                     # 0051dd21
    call dword ptr [0x52a330]                    # 0051dd22
    test eax, eax                                # 0051dd28
    je.d8 L_0051dd43                             # 0051dd2a
L_0051dd2c:
    # block 0x0051dd2c: entered by je at 0x0051dd1f; fall-through of je at 0x0051dd2a, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x0051dd3e
    push 0x0                                     # 0051dd2c
    push 0x2                                     # 0051dd2e
    push 0x111                                   # 0051dd30
    push dword ptr [esi + field_1c]              # 0051dd35
    call dword ptr [0x52a4c8]                    # 0051dd38
L_0051dd3e:
    # block 0x0051dd3e: entered by jne at 0x0051dcc7, 3 instruction(s), ends with forward jump to 0x0051dd4b
    push 0x1                                     # 0051dd3e
    pop eax                                      # 0051dd40
    jmp.d8 L_0051dd4b                            # 0051dd41
L_0051dd43:
    # block 0x0051dd43: entered by jne at 0x0051dce5; jne at 0x0051dcf2; je at 0x0051dd00; je at 0x0051dd10; je at 0x0051dd2a, 3 instruction(s), calls FUN_0051ce42, falls into the block at 0x0051dd4b
    push edi                                     # 0051dd43
    {load} mov ecx, esi                          # 0051dd44
    call FUN_0051ce42                            # 0051dd46
L_0051dd4b:
    # block 0x0051dd4b: entered by jmp at 0x0051dcdc; jmp at 0x0051dd41, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0051dd4b
    pop esi                                      # 0051dd4c
    ret 0x4                                      # 0051dd4d

