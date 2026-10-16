# FUN_0051c0c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c0c9
# extent:       0x0051c0c9-0x0051c107 (62 code bytes)
# span:         0x0051c0c9-0x0051c107 (code 62, tables 0, padding 0)
# sha256:       96702b67f674c7c8bf35a858bf4ab0eecc5dbd99feeb95fb3e5bd3d14475280b
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c0c9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_b0; [ecx + n] field_1c; [esi + n] field_1c
# callees:      calls FUN_0051abe4; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_b0, 0xb0  # offset +0xb0

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0051c0c9 - 0x401000
.globl FUN_0051c0c9
FUN_0051c0c9:
    # block 0x0051c0c9: entry, 4 instruction(s), ends with je to 0x0051c102 (forward)
    push esi                                     # 0051c0c9
    push edi                                     # 0051c0ca
    test ecx, ecx                                # 0051c0cb
    je.d8 L_0051c102                             # 0051c0cd
    # block 0x0051c0cf: entered by fall-through of je at 0x0051c0cd, 3 instruction(s), ends with je to 0x0051c102 (forward)
    mov eax, dword ptr [ecx + field_1c]          # 0051c0cf
    test eax, eax                                # 0051c0d2
    je.d8 L_0051c102                             # 0051c0d4
    # block 0x0051c0d6: entered by fall-through of je at 0x0051c0d4, 2 instruction(s), falls into the block at 0x0051c0dd
    mov edi, dword ptr [0x52a3dc]                # 0051c0d6
    push eax                                     # 0051c0dc
L_0051c0dd:
    # block 0x0051c0dd: entered by jmp at 0x0051c0fc, 6 instruction(s), calls indirect edi, FUN_0051abe4, ends with je to 0x0051c102 (forward)
    call edi                                     # 0051c0dd
    push eax                                     # 0051c0df
    call FUN_0051abe4                            # 0051c0e0
    {load} mov esi, eax                          # 0051c0e5
    test esi, esi                                # 0051c0e7
    je.d8 L_0051c102                             # 0051c0e9
    # block 0x0051c0eb: entered by fall-through of je at 0x0051c0e9, 5 instruction(s), calls indirect dword ptr [eax + 0xb0], ends with jne to 0x0051c0fe (forward)
    mov eax, dword ptr [esi]                     # 0051c0eb
    {load} mov ecx, esi                          # 0051c0ed
    call dword ptr [eax + field_b0]              # 0051c0ef
    test eax, eax                                # 0051c0f5
    jne.d8 L_0051c0fe                            # 0051c0f7
    # block 0x0051c0f9: entered by fall-through of jne at 0x0051c0f7, 2 instruction(s), ends with backward jump to 0x0051c0dd
    push dword ptr [esi + field_1c]              # 0051c0f9
    jmp.d8 L_0051c0dd                            # 0051c0fc
L_0051c0fe:
    # block 0x0051c0fe: entered by jne at 0x0051c0f7, 2 instruction(s), ends with forward jump to 0x0051c104
    {load} mov eax, esi                          # 0051c0fe
    jmp.d8 L_0051c104                            # 0051c100
L_0051c102:
    # block 0x0051c102: entered by je at 0x0051c0cd; je at 0x0051c0d4; je at 0x0051c0e9, 1 instruction(s), falls into the block at 0x0051c104
    {load} xor eax, eax                          # 0051c102
L_0051c104:
    # block 0x0051c104: entered by jmp at 0x0051c100, 3 instruction(s), ends with ret
    pop edi                                      # 0051c104
    pop esi                                      # 0051c105
    ret                                          # 0051c106

