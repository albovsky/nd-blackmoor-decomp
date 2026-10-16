# FUN_0051c174
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c174
# extent:       0x0051c174-0x0051c1b5 (65 code bytes)
# span:         0x0051c174-0x0051c1b5 (code 65, tables 0, padding 0)
# sha256:       4dee9214f1a09f2d21a326d16f3ca1b059af49074ad9ad7ff12f2e2c4c73832e
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c174
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_b0; [esi + n] field_1c
# callees:      calls FUN_0051c0c9; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_b0, 0xb0  # offset +0xb0

# --- external targets -----------------------------------------------
.set FUN_0051c0c9, .text + (0x0051c0c9 - 0x401000)

.org 0x0051c174 - 0x401000
.globl FUN_0051c174
FUN_0051c174:
    # block 0x0051c174: entry, 4 instruction(s), ends with je to 0x0051c181 (forward)
    push esi                                     # 0051c174
    {load} mov esi, ecx                          # 0051c175
    test esi, esi                                # 0051c177
    je.d8 L_0051c181                             # 0051c179
    # block 0x0051c17b: entered by fall-through of je at 0x0051c179, 2 instruction(s), ends with jne to 0x0051c185 (forward)
    cmp dword ptr [esi + field_1c], 0x0          # 0051c17b
    jne.d8 L_0051c185                            # 0051c17f
L_0051c181:
    # block 0x0051c181: entered by je at 0x0051c179; fall-through of jne at 0x0051c17f, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051c181
    pop esi                                      # 0051c183
    ret                                          # 0051c184
L_0051c185:
    # block 0x0051c185: entered by jne at 0x0051c17f, 5 instruction(s), calls indirect dword ptr [eax + 0xb0], ends with jne to 0x0051c19c (forward)
    mov eax, dword ptr [esi]                     # 0051c185
    {load} mov ecx, esi                          # 0051c187
    call dword ptr [eax + field_b0]              # 0051c189
    test eax, eax                                # 0051c18f
    jne.d8 L_0051c19c                            # 0051c191
    # block 0x0051c193: entered by fall-through of jne at 0x0051c191, 3 instruction(s), calls FUN_0051c0c9, falls into the block at 0x0051c19c
    {load} mov ecx, esi                          # 0051c193
    call FUN_0051c0c9                            # 0051c195
    {load} mov esi, eax                          # 0051c19a
L_0051c19c:
    # block 0x0051c19c: entered by jne at 0x0051c191, 2 instruction(s), ends with je to 0x0051c1b1 (forward)
    test esi, esi                                # 0051c19c
    je.d8 L_0051c1b1                             # 0051c19e
    # block 0x0051c1a0: entered by fall-through of je at 0x0051c19e, 1 instruction(s), falls into the block at 0x0051c1a2
    {load} mov ecx, esi                          # 0051c1a0
L_0051c1a2:
    # block 0x0051c1a2: entered by jmp at 0x0051c1af, 3 instruction(s), calls FUN_0051c0c9, ends with je to 0x0051c1b1 (forward)
    call FUN_0051c0c9                            # 0051c1a2
    test eax, eax                                # 0051c1a7
    je.d8 L_0051c1b1                             # 0051c1a9
    # block 0x0051c1ab: entered by fall-through of je at 0x0051c1a9, 3 instruction(s), ends with backward jump to 0x0051c1a2
    {load} mov esi, eax                          # 0051c1ab
    {load} mov ecx, eax                          # 0051c1ad
    jmp.d8 L_0051c1a2                            # 0051c1af
L_0051c1b1:
    # block 0x0051c1b1: entered by je at 0x0051c19e; je at 0x0051c1a9, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 0051c1b1
    pop esi                                      # 0051c1b3
    ret                                          # 0051c1b4

