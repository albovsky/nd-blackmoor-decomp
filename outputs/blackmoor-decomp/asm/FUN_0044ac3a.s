# FUN_0044ac3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044ac3a
# extent:       0x0044ac3a-0x0044ad41 (263 code bytes)
# span:         0x0044ac3a-0x0044ad41 (code 263, tables 0, padding 0)
# sha256:       5b252349d7ded085ed518caf9a86f9c01a540fc5a560fc4e14fcfc812a40ab02
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044ac3a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_38
# fields:       [eax + n] field_2, field_3; [ecx + n] field_1; [edx + n] field_1, field_2
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 90 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_38, 0x38  # offset -0x38
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0044ac3a - 0x401000
.globl FUN_0044ac3a
FUN_0044ac3a:
    # block 0x0044ac3a: entry, 17 instruction(s), ends with je to 0x0044ac65 (forward)
    push ebp                                     # 0044ac3a
    {load} mov ebp, esp                          # 0044ac3b
    sub esp, 0x38                                # 0044ac3d
    push esi                                     # 0044ac40
    push edi                                     # 0044ac41
    mov edi, dword ptr [ebp + arg_8]             # 0044ac42
    or ecx, -0x1                                 # 0044ac45
    {load} xor eax, eax                          # 0044ac48
    repne scasb al, byte ptr es:[edi]            # 0044ac4a
    not ecx                                      # 0044ac4c
    add ecx, -0x1                                # 0044ac4e
    {load} mov eax, ecx                          # 0044ac51
    {load} xor edx, edx                          # 0044ac53
    mov ecx, 0x4                                 # 0044ac55
    div ecx                                      # 0044ac5a
    test edx, edx                                # 0044ac5c
    je.d8 L_0044ac65                             # 0044ac5e
    # block 0x0044ac60: entered by fall-through of je at 0x0044ac5e, 1 instruction(s), ends with forward jump to 0x0044ad3b
    jmp.d32 L_0044ad3b                           # 0044ac60
L_0044ac65:
    # block 0x0044ac65: entered by je at 0x0044ac5e, 7 instruction(s), ends with forward jump to 0x0044ac97
    mov ecx, 0xc                                 # 0044ac65
    {load} xor eax, eax                          # 0044ac6a
    lea edi, [ebp - local_38]                    # 0044ac6c
    rep stosd dword ptr es:[edi], eax            # 0044ac6f
    mov word ptr [ebp - local_4], 0x0            # 0044ac71
    mov word ptr [ebp - local_8], 0x0            # 0044ac77
    jmp.d8 L_0044ac97                            # 0044ac7d
L_0044ac7f:
    # block 0x0044ac7f: entered by jmp at 0x0044ad13, 6 instruction(s), falls into the block at 0x0044ac97
    mov dx, word ptr [ebp - local_4]             # 0044ac7f
    add dx, 0x4                                  # 0044ac83
    mov word ptr [ebp - local_4], dx             # 0044ac87
    mov ax, word ptr [ebp - local_8]             # 0044ac8b
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044ac8f
    mov word ptr [ebp - local_8], ax             # 0044ac93
L_0044ac97:
    # block 0x0044ac97: entered by jmp at 0x0044ac7d, 9 instruction(s), ends with jae to 0x0044ad18 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044ac97
    mov edi, dword ptr [ebp + arg_8]             # 0044ac9b
    or ecx, -0x1                                 # 0044ac9e
    {load} xor eax, eax                          # 0044aca1
    repne scasb al, byte ptr es:[edi]            # 0044aca3
    not ecx                                      # 0044aca5
    add ecx, -0x1                                # 0044aca7
    {load} cmp edx, ecx                          # 0044acaa
    jae.d8 L_0044ad18                            # 0044acac
    # block 0x0044acae: entered by fall-through of jae at 0x0044acac, 8 instruction(s), ends with jne to 0x0044ad13 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0044acae
    mov ecx, dword ptr [ebp + arg_8]             # 0044acb2
    movsx edx, byte ptr [ecx + eax]              # 0044acb5
    movsx eax, word ptr [ebp - local_4]          # 0044acb9
    mov ecx, dword ptr [ebp + arg_8]             # 0044acbd
    movsx eax, byte ptr [ecx + eax + field_1]    # 0044acc0
    {load} cmp edx, eax                          # 0044acc5
    jne.d8 L_0044ad13                            # 0044acc7
    # block 0x0044acc9: entered by fall-through of jne at 0x0044acc7, 8 instruction(s), ends with jne to 0x0044ad13 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0044acc9
    mov edx, dword ptr [ebp + arg_8]             # 0044accd
    movsx eax, byte ptr [edx + ecx + field_1]    # 0044acd0
    movsx ecx, word ptr [ebp - local_4]          # 0044acd5
    mov edx, dword ptr [ebp + arg_8]             # 0044acd9
    movsx ecx, byte ptr [edx + ecx + field_2]    # 0044acdc
    {load} cmp eax, ecx                          # 0044ace1
    jne.d8 L_0044ad13                            # 0044ace3
    # block 0x0044ace5: entered by fall-through of jne at 0x0044ace3, 8 instruction(s), ends with jne to 0x0044ad13 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0044ace5
    mov eax, dword ptr [ebp + arg_8]             # 0044ace9
    movsx ecx, byte ptr [eax + edx + field_2]    # 0044acec
    movsx edx, word ptr [ebp - local_4]          # 0044acf1
    mov eax, dword ptr [ebp + arg_8]             # 0044acf5
    movsx edx, byte ptr [eax + edx + field_3]    # 0044acf8
    {load} cmp ecx, edx                          # 0044acfd
    jne.d8 L_0044ad13                            # 0044acff
    # block 0x0044ad01: entered by fall-through of jne at 0x0044acff, 5 instruction(s), falls into the block at 0x0044ad13
    movsx eax, word ptr [ebp - local_4]          # 0044ad01
    movsx ecx, word ptr [ebp - local_8]          # 0044ad05
    mov edx, dword ptr [ebp + arg_8]             # 0044ad09
    mov al, byte ptr [edx + eax]                 # 0044ad0c
    mov byte ptr [ebp + ecx - local_38], al      # 0044ad0f
L_0044ad13:
    # block 0x0044ad13: entered by jne at 0x0044acc7; jne at 0x0044ace3; jne at 0x0044acff, 1 instruction(s), ends with backward jump to 0x0044ac7f
    jmp.d32 L_0044ac7f                           # 0044ad13
L_0044ad18:
    # block 0x0044ad18: entered by jae at 0x0044acac, 15 instruction(s), falls into the block at 0x0044ad3b
    lea edi, [ebp - local_38]                    # 0044ad18
    mov edx, dword ptr [ebp + arg_8]             # 0044ad1b
    or ecx, -0x1                                 # 0044ad1e
    {load} xor eax, eax                          # 0044ad21
    repne scasb al, byte ptr es:[edi]            # 0044ad23
    not ecx                                      # 0044ad25
    {load} sub edi, ecx                          # 0044ad27
    {load} mov esi, edi                          # 0044ad29
    {load} mov eax, ecx                          # 0044ad2b
    {load} mov edi, edx                          # 0044ad2d
    shr ecx, 0x2                                 # 0044ad2f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044ad32
    {load} mov ecx, eax                          # 0044ad34
    and ecx, 0x3                                 # 0044ad36
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044ad39
L_0044ad3b:
    # block 0x0044ad3b: entered by jmp at 0x0044ac60, 5 instruction(s), ends with ret
    pop edi                                      # 0044ad3b
    pop esi                                      # 0044ad3c
    {load} mov esp, ebp                          # 0044ad3d
    pop ebp                                      # 0044ad3f
    ret                                          # 0044ad40

