# FUN_00521bed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521bed
# extent:       0x00521bed-0x00521d3a (333 code bytes)
# span:         0x00521bed-0x00521d62 (code 333, tables 40, padding 0)
# sha256:       6d1be398c94b068534873cf7e52e11d012112273ca00f0fa95f07b177304f98f
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521bed
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_24, field_84, field_d0, field_d4, field_d8, field_dc, field_e0, field_e4, field_e8, field_ec; [edi + n] field_8, field_d1; [esi + n] field_1c
# callees:      calls FUN_0051c04f, FUN_0051abe4, FUN_0051f5ab, FUN_00521bcb, FUN_00521b51, USER32.dll!SendMessageA; plus 10 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 117 instruction(s), 9 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00521d62
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_84, 0x84  # offset +0x84
.equ field_d0, 0xd0  # offset +0xd0
.equ field_d1, 0xd1  # offset +0xd1
.equ field_d4, 0xd4  # offset +0xd4
.equ field_d8, 0xd8  # offset +0xd8
.equ field_dc, 0xdc  # offset +0xdc
.equ field_e0, 0xe0  # offset +0xe0
.equ field_e4, 0xe4  # offset +0xe4
.equ field_e8, 0xe8  # offset +0xe8
.equ field_ec, 0xec  # offset +0xec

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051c04f, .text + (0x0051c04f - 0x401000)
.set FUN_0051f5ab, .text + (0x0051f5ab - 0x401000)
.set FUN_00521b51, .text + (0x00521b51 - 0x401000)
.set FUN_00521bcb, .text + (0x00521bcb - 0x401000)

.org 0x00521bed - 0x401000
.globl FUN_00521bed
FUN_00521bed:
    # block 0x00521bed: entry, 13 instruction(s), calls FUN_0051c04f, ends with jne to 0x00521d2c (forward)
    push ebp                                     # 00521bed
    {load} mov ebp, esp                          # 00521bee
    push ebx                                     # 00521bf0
    push esi                                     # 00521bf1
    push edi                                     # 00521bf2
    mov edi, dword ptr [ebp + arg_c]             # 00521bf3
    push dword ptr [ebp + arg_10]                # 00521bf6
    {load} mov esi, ecx                          # 00521bf9
    push edi                                     # 00521bfb
    push dword ptr [ebp + arg_8]                 # 00521bfc
    call FUN_0051c04f                            # 00521bff
    test eax, eax                                # 00521c04
    jne.d32 L_00521d2c                           # 00521c06
    # block 0x00521c0c: entered by fall-through of jne at 0x00521c06, 4 instruction(s), ends with je to 0x00521c24 (forward)
    mov eax, dword ptr [esi + field_1c]          # 00521c0c
    mov ebx, dword ptr [0x52a3dc]                # 00521c0f
    cmp dword ptr [edi], eax                     # 00521c15
    je.d8 L_00521c24                             # 00521c17
    # block 0x00521c19: entered by fall-through of je at 0x00521c17, 4 instruction(s), calls indirect ebx, ends with jne to 0x00521d31 (forward)
    push eax                                     # 00521c19
    call ebx                                     # 00521c1a
    cmp dword ptr [edi], eax                     # 00521c1c
    jne.d32 L_00521d31                           # 00521c1e
L_00521c24:
    # block 0x00521c24: entered by je at 0x00521c17; fall-through of jne at 0x00521c1e, 4 instruction(s), ends with ja to 0x00521d31 (forward)
    mov edi, dword ptr [edi + field_8]           # 00521c24
    lea eax, [edi + field_d1]                    # 00521c27
    cmp eax, 0x9                                 # 00521c2d
    ja.d32 L_00521d31                            # 00521c30
    # block 0x00521c36: entered by fall-through of ja at 0x00521c30, 1 instruction(s), ends with indirect jump dword ptr [4*eax + 0x521d3a]
    jmp dword ptr [4*eax + SWTAB_00521d3a_VA]    # 00521c36
L_00521c3d:
    # block 0x00521c3d: entered by switch case, 11 instruction(s), calls indirect ebx, FUN_0051abe4, FUN_0051f5ab, ends with je to 0x00521c73 (forward)
    push dword ptr [esi + field_1c]              # 00521c3d
    call ebx                                     # 00521c40
    push eax                                     # 00521c42
    call FUN_0051abe4                            # 00521c43
    push eax                                     # 00521c48
    push 0x52ee58                                # 00521c49
    call FUN_0051f5ab                            # 00521c4e
    pop ecx                                      # 00521c53
    test eax, eax                                # 00521c54
    pop ecx                                      # 00521c56
    je.d8 L_00521c73                             # 00521c57
    # block 0x00521c59: entered by fall-through of je at 0x00521c57, 2 instruction(s), ends with jne to 0x00521c73 (forward)
    test byte ptr [eax + field_24], 0x10         # 00521c59
    jne.d8 L_00521c73                            # 00521c5d
    # block 0x00521c5f: entered by fall-through of jne at 0x00521c5d, 2 instruction(s), ends with jne to 0x00521c73 (forward)
    cmp dword ptr [eax + field_84], 0x0          # 00521c5f
    jne.d8 L_00521c73                            # 00521c66
    # block 0x00521c68: entered by fall-through of jne at 0x00521c66, 3 instruction(s), ends with forward jump to 0x00521d2c
    mov eax, dword ptr [ebp + arg_10]            # 00521c68
    or dword ptr [eax], -0x1                     # 00521c6b
    jmp.d32 L_00521d2c                           # 00521c6e
L_00521c73:
    # block 0x00521c73: entered by je at 0x00521c57; jne at 0x00521c5d; jne at 0x00521c66, 8 instruction(s), calls indirect dword ptr [eax + 0xd8], ends with forward jump to 0x00521d10
    mov eax, dword ptr [esi]                     # 00521c73
    {load} mov ecx, esi                          # 00521c75
    call dword ptr [eax + field_d8]              # 00521c77
    neg eax                                      # 00521c7d
    {load} sbb eax, eax                          # 00521c7f
    neg eax                                      # 00521c81
    dec eax                                      # 00521c83
    jmp.d32 L_00521d10                           # 00521c84
L_00521c89:
    # block 0x00521c89: entered by switch case, 4 instruction(s), calls indirect dword ptr [eax + 0xdc], ends with forward jump to 0x00521d0b
    mov eax, dword ptr [esi]                     # 00521c89
    {load} mov ecx, esi                          # 00521c8b
    call dword ptr [eax + field_dc]              # 00521c8d
    jmp.d8 L_00521d0b                            # 00521c93
L_00521c95:
    # block 0x00521c95: entered by switch case, 9 instruction(s), calls indirect dword ptr [eax + 0xd0], ends with forward jump to 0x00521d10
    mov eax, dword ptr [esi]                     # 00521c95
    {load} mov ecx, esi                          # 00521c97
    call dword ptr [eax + field_d0]              # 00521c99
    neg eax                                      # 00521c9f
    {load} sbb eax, eax                          # 00521ca1
    and al, -0x2                                 # 00521ca3
    inc eax                                      # 00521ca5
    inc eax                                      # 00521ca6
    jmp.d8 L_00521d10                            # 00521ca7
L_00521ca9:
    # block 0x00521ca9: entered by switch case, 4 instruction(s), calls indirect dword ptr [eax + 0xd4], ends with forward jump to 0x00521d2c
    mov eax, dword ptr [esi]                     # 00521ca9
    {load} mov ecx, esi                          # 00521cab
    call dword ptr [eax + field_d4]              # 00521cad
    jmp.d8 L_00521d2c                            # 00521cb3
L_00521cb5:
    # block 0x00521cb5: entered by switch case, 4 instruction(s), calls indirect dword ptr [eax + 0xe0], ends with forward jump to 0x00521d0b
    mov eax, dword ptr [esi]                     # 00521cb5
    {load} mov ecx, esi                          # 00521cb7
    call dword ptr [eax + field_e0]              # 00521cb9
    jmp.d8 L_00521d0b                            # 00521cbf
L_00521cc1:
    # block 0x00521cc1: entered by switch case, 5 instruction(s), calls FUN_00521bcb, ends with je to 0x00521d2c (forward)
    push 0x3024                                  # 00521cc1
    {load} mov ecx, esi                          # 00521cc6
    call FUN_00521bcb                            # 00521cc8
    test eax, eax                                # 00521ccd
    je.d8 L_00521d2c                             # 00521ccf
    # block 0x00521cd1: entered by fall-through of je at 0x00521ccf, 3 instruction(s), calls indirect dword ptr [eax + 0xe8], falls into the block at 0x00521cdb
    mov eax, dword ptr [esi]                     # 00521cd1
    {load} mov ecx, esi                          # 00521cd3
    call dword ptr [eax + field_e8]              # 00521cd5
L_00521cdb:
    # block 0x00521cdb: entered by jmp at 0x00521cff, 4 instruction(s), calls FUN_00521b51, ends with forward jump to 0x00521d10
    push eax                                     # 00521cdb
    {load} mov ecx, esi                          # 00521cdc
    call FUN_00521b51                            # 00521cde
    jmp.d8 L_00521d10                            # 00521ce3
L_00521ce5:
    # block 0x00521ce5: entered by switch case, 5 instruction(s), calls FUN_00521bcb, ends with je to 0x00521d2c (forward)
    push 0x3023                                  # 00521ce5
    {load} mov ecx, esi                          # 00521cea
    call FUN_00521bcb                            # 00521cec
    test eax, eax                                # 00521cf1
    je.d8 L_00521d2c                             # 00521cf3
    # block 0x00521cf5: entered by fall-through of je at 0x00521cf3, 4 instruction(s), calls indirect dword ptr [eax + 0xe4], ends with backward jump to 0x00521cdb
    mov eax, dword ptr [esi]                     # 00521cf5
    {load} mov ecx, esi                          # 00521cf7
    call dword ptr [eax + field_e4]              # 00521cf9
    jmp.d8 L_00521cdb                            # 00521cff
L_00521d01:
    # block 0x00521d01: entered by switch case, 3 instruction(s), calls indirect dword ptr [eax + 0xec], falls into the block at 0x00521d0b
    mov eax, dword ptr [esi]                     # 00521d01
    {load} mov ecx, esi                          # 00521d03
    call dword ptr [eax + field_ec]              # 00521d05
L_00521d0b:
    # block 0x00521d0b: entered by jmp at 0x00521c93; jmp at 0x00521cbf, 3 instruction(s), falls into the block at 0x00521d10
    neg eax                                      # 00521d0b
    {load} sbb eax, eax                          # 00521d0d
    inc eax                                      # 00521d0f
L_00521d10:
    # block 0x00521d10: entered by jmp at 0x00521c84; jmp at 0x00521ca7; jmp at 0x00521ce3, 3 instruction(s), ends with forward jump to 0x00521d2c
    mov ecx, dword ptr [ebp + arg_10]            # 00521d10
    mov dword ptr [ecx], eax                     # 00521d13
    jmp.d8 L_00521d2c                            # 00521d15
L_00521d17:
    # block 0x00521d17: entered by switch case, 5 instruction(s), calls USER32.dll!SendMessageA, falls into the block at 0x00521d2c
    push 0x0                                     # 00521d17
    push 0xe146                                  # 00521d19
    push 0x111                                   # 00521d1e
    push dword ptr [esi + field_1c]              # 00521d23
    call dword ptr [0x52a4c8]                    # 00521d26
L_00521d2c:
    # block 0x00521d2c: entered by jne at 0x00521c06; jmp at 0x00521c6e; jmp at 0x00521cb3; je at 0x00521ccf; more, 3 instruction(s), ends with forward jump to 0x00521d33
    push 0x1                                     # 00521d2c
    pop eax                                      # 00521d2e
    jmp.d8 L_00521d33                            # 00521d2f
L_00521d31:
    # block 0x00521d31: entered by jne at 0x00521c1e; ja at 0x00521c30; switch case, 1 instruction(s), falls into the block at 0x00521d33
    {load} xor eax, eax                          # 00521d31
L_00521d33:
    # block 0x00521d33: entered by jmp at 0x00521d2f, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00521d33
    pop esi                                      # 00521d34
    pop ebx                                      # 00521d35
    pop ebp                                      # 00521d36
    ret 0xc                                      # 00521d37

# --- data items (not part of the function) -------------------------
.org 0x00521d3a - 0x401000
SWTAB_00521d3a:  # 10 case address(es)
    .long L_00521cb5 - .text + 0x401000
    .long L_00521d01 - .text + 0x401000
    .long L_00521cc1 - .text + 0x401000
    .long L_00521ce5 - .text + 0x401000
    .long L_00521d17 - .text + 0x401000
    .long L_00521d31 - .text + 0x401000
    .long L_00521ca9 - .text + 0x401000
    .long L_00521c95 - .text + 0x401000
    .long L_00521c89 - .text + 0x401000
    .long L_00521c3d - .text + 0x401000
.set SWTAB_00521d3a_VA, SWTAB_00521d3a - .text + 0x401000

