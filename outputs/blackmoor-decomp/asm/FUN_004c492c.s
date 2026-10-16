# FUN_004c492c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c492c
# extent:       0x004c492c-0x004c4b12 (486 code bytes)
# span:         0x004c492c-0x004c4b12 (code 486, tables 0, padding 0)
# sha256:       2452156c8e8c27ee13432229245959b20b9e89d6be32f2fe4a15123499f7bc0f
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c492c
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_8, field_c, field_38c6, field_38c8, field_38c9, field_38ca; [ecx + n] field_4, field_2f, field_38c0, field_38c1, field_38c2, field_38c4; [edx + n] field_2f, field_38c5
# callees:      calls FUN_0043efb6, FUN_0043ef77, FUN_004264e8, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 155 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_2f, 0x2f  # offset +0x2f
.equ field_38c0, 0x38c0  # offset +0x38c0
.equ field_38c1, 0x38c1  # offset +0x38c1
.equ field_38c2, 0x38c2  # offset +0x38c2
.equ field_38c4, 0x38c4  # offset +0x38c4
.equ field_38c5, 0x38c5  # offset +0x38c5
.equ field_38c6, 0x38c6  # offset +0x38c6
.equ field_38c8, 0x38c8  # offset +0x38c8
.equ field_38c9, 0x38c9  # offset +0x38c9
.equ field_38ca, 0x38ca  # offset +0x38ca

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043ef77, .text + (0x0043ef77 - 0x401000)
.set FUN_0043efb6, .text + (0x0043efb6 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c492c - 0x401000
.globl FUN_004c492c
FUN_004c492c:
    # block 0x004c492c: entry, 22 instruction(s), ends with je to 0x004c497b (forward)
    push ebp                                     # 004c492c
    {load} mov ebp, esp                          # 004c492d
    sub esp, 0x1c                                # 004c492f
    push ebx                                     # 004c4932
    mov dword ptr [ebp - local_1c], ecx          # 004c4933
    mov eax, dword ptr [ebp - local_1c]          # 004c4936
    mov cl, byte ptr [ebp + arg_c]               # 004c4939
    and cl, byte ptr [eax + field_38c6]          # 004c493c
    mov byte ptr [ebp + arg_c], cl               # 004c4942
    mov edx, dword ptr [ebp - local_1c]          # 004c4945
    mov al, byte ptr [ebp + arg_10]              # 004c4948
    and al, byte ptr [edx + field_38c5]          # 004c494b
    mov byte ptr [ebp + arg_10], al              # 004c4951
    mov ecx, dword ptr [ebp - local_1c]          # 004c4954
    mov dl, byte ptr [ebp + arg_14]              # 004c4957
    and dl, byte ptr [ecx + field_38c4]          # 004c495a
    mov byte ptr [ebp + arg_14], dl              # 004c4960
    mov eax, dword ptr [ebp - local_1c]          # 004c4963
    {load} xor ecx, ecx                          # 004c4966
    mov cl, byte ptr [eax + field_38ca]          # 004c4968
    cmp ecx, 0x5                                 # 004c496e
    je.d8 L_004c497b                             # 004c4971
    # block 0x004c4973: entered by fall-through of je at 0x004c4971, 3 instruction(s), falls into the block at 0x004c497b
    mov dl, byte ptr [ebp + arg_c]               # 004c4973
    shl dl                                       # 004c4976
    mov byte ptr [ebp + arg_c], dl               # 004c4978
L_004c497b:
    # block 0x004c497b: entered by je at 0x004c4971, 5 instruction(s), ends with je to 0x004c4993 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c497b
    {load} xor ecx, ecx                          # 004c497e
    mov cl, byte ptr [eax + field_38c9]          # 004c4980
    cmp ecx, 0x5                                 # 004c4986
    je.d8 L_004c4993                             # 004c4989
    # block 0x004c498b: entered by fall-through of je at 0x004c4989, 3 instruction(s), falls into the block at 0x004c4993
    mov dl, byte ptr [ebp + arg_10]              # 004c498b
    shl dl                                       # 004c498e
    mov byte ptr [ebp + arg_10], dl              # 004c4990
L_004c4993:
    # block 0x004c4993: entered by je at 0x004c4989, 5 instruction(s), ends with je to 0x004c49ab (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c4993
    {load} xor ecx, ecx                          # 004c4996
    mov cl, byte ptr [eax + field_38c8]          # 004c4998
    cmp ecx, 0x5                                 # 004c499e
    je.d8 L_004c49ab                             # 004c49a1
    # block 0x004c49a3: entered by fall-through of je at 0x004c49a1, 3 instruction(s), falls into the block at 0x004c49ab
    mov dl, byte ptr [ebp + arg_14]              # 004c49a3
    shl dl                                       # 004c49a6
    mov byte ptr [ebp + arg_14], dl              # 004c49a8
L_004c49ab:
    # block 0x004c49ab: entered by je at 0x004c49a1, 62 instruction(s), ends with forward jump to 0x004c4a84
    mov eax, dword ptr [ebp + arg_c]             # 004c49ab
    and eax, 0xff                                # 004c49ae
    mov ecx, dword ptr [ebp - local_1c]          # 004c49b3
    {load} xor edx, edx                          # 004c49b6
    mov dl, byte ptr [ecx + field_38c2]          # 004c49b8
    {load} mov ecx, edx                          # 004c49be
    shl eax, cl                                  # 004c49c0
    mov edx, dword ptr [ebp + arg_10]            # 004c49c2
    and edx, 0xff                                # 004c49c5
    mov ecx, dword ptr [ebp - local_1c]          # 004c49cb
    {load} xor ebx, ebx                          # 004c49ce
    mov bl, byte ptr [ecx + field_38c1]          # 004c49d0
    {load} mov ecx, ebx                          # 004c49d6
    shl edx, cl                                  # 004c49d8
    {load} or eax, edx                           # 004c49da
    mov edx, dword ptr [ebp + arg_14]            # 004c49dc
    and edx, 0xff                                # 004c49df
    mov ecx, dword ptr [ebp - local_1c]          # 004c49e5
    {load} xor ebx, ebx                          # 004c49e8
    mov bl, byte ptr [ecx + field_38c0]          # 004c49ea
    {load} mov ecx, ebx                          # 004c49f0
    shl edx, cl                                  # 004c49f2
    {load} or eax, edx                           # 004c49f4
    mov word ptr [ebp - local_18], ax            # 004c49f6
    mov dword ptr [ebp - local_14], 0x0          # 004c49fa
    mov edx, dword ptr [ebp - local_18]          # 004c4a01
    and edx, 0xffff                              # 004c4a04
    shl edx, 0x10                                # 004c4a0a
    mov eax, dword ptr [ebp - local_18]          # 004c4a0d
    and eax, 0xffff                              # 004c4a10
    {load} or edx, eax                           # 004c4a15
    mov dword ptr [ebp - local_14], edx          # 004c4a17
    mov ecx, dword ptr [ebp + arg_8]             # 004c4a1a
    movsx edx, word ptr [ecx + field_2f]         # 004c4a1d
    mov eax, dword ptr [ebp + arg_18]            # 004c4a21
    mov ecx, dword ptr [eax + field_4]           # 004c4a24
    imul ecx, edx                                # 004c4a27
    mov edx, dword ptr [ebp + arg_8]             # 004c4a2a
    mov eax, dword ptr [edx]                     # 004c4a2d
    {load} add eax, ecx                          # 004c4a2f
    movsx ecx, word ptr [0x639895]               # 004c4a31
    mov edx, dword ptr [ebp + arg_18]            # 004c4a38
    mov edx, dword ptr [edx]                     # 004c4a3b
    imul edx, ecx                                # 004c4a3d
    {load} add eax, edx                          # 004c4a40
    mov dword ptr [ebp - local_4], eax           # 004c4a42
    mov eax, dword ptr [ebp + arg_18]            # 004c4a45
    mov ecx, dword ptr [ebp + arg_18]            # 004c4a48
    mov edx, dword ptr [eax + field_c]           # 004c4a4b
    sub edx, dword ptr [ecx + field_4]           # 004c4a4e
    add edx, 0x1                                 # 004c4a51
    mov dword ptr [ebp - local_c], edx           # 004c4a54
    mov eax, dword ptr [ebp + arg_18]            # 004c4a57
    mov ecx, dword ptr [ebp + arg_18]            # 004c4a5a
    mov edx, dword ptr [eax + field_8]           # 004c4a5d
    sub edx, dword ptr [ecx]                     # 004c4a60
    add edx, 0x1                                 # 004c4a62
    movsx eax, word ptr [0x639895]               # 004c4a65
    imul edx, eax                                # 004c4a6c
    mov dword ptr [ebp - local_8], edx           # 004c4a6f
    mov dword ptr [ebp - local_10], 0x0          # 004c4a72
    jmp.d8 L_004c4a84                            # 004c4a79
L_004c4a7b:
    # block 0x004c4a7b: entered by jmp at 0x004c4b06, 3 instruction(s), falls into the block at 0x004c4a84
    mov ecx, dword ptr [ebp - local_10]          # 004c4a7b
    add ecx, 0x1                                 # 004c4a7e
    mov dword ptr [ebp - local_10], ecx          # 004c4a81
L_004c4a84:
    # block 0x004c4a84: entered by jmp at 0x004c4a79, 3 instruction(s), ends with jge to 0x004c4b0b (forward)
    mov edx, dword ptr [ebp - local_10]          # 004c4a84
    cmp edx, dword ptr [ebp - local_c]           # 004c4a87
    jge.d8 L_004c4b0b                            # 004c4a8a
    # block 0x004c4a8c: entered by fall-through of jge at 0x004c4a8a, 4 instruction(s), ends with jne to 0x004c4ab5 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c4a8c
    and eax, 0x3                                 # 004c4a8f
    test eax, eax                                # 004c4a92
    jne.d8 L_004c4ab5                            # 004c4a94
    # block 0x004c4a96: entered by fall-through of jne at 0x004c4a94, 11 instruction(s), calls FUN_0043efb6, ends with forward jump to 0x004c4af7
    mov ecx, dword ptr [ebp - local_8]           # 004c4a96
    sar ecx, 0x2                                 # 004c4a99
    push ecx                                     # 004c4a9c
    mov edx, dword ptr [ebp - local_14]          # 004c4a9d
    push edx                                     # 004c4aa0
    mov eax, dword ptr [ebp - local_4]           # 004c4aa1
    push eax                                     # 004c4aa4
    mov ecx, dword ptr [ebp - local_1c]          # 004c4aa5
    add ecx, 0x38cc                              # 004c4aa8
    call FUN_0043efb6                            # 004c4aae
    jmp.d8 L_004c4af7                            # 004c4ab3
L_004c4ab5:
    # block 0x004c4ab5: entered by jne at 0x004c4a94, 4 instruction(s), ends with jne to 0x004c4ade (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c4ab5
    and ecx, 0x1                                 # 004c4ab8
    test ecx, ecx                                # 004c4abb
    jne.d8 L_004c4ade                            # 004c4abd
    # block 0x004c4abf: entered by fall-through of jne at 0x004c4abd, 11 instruction(s), calls FUN_0043ef77, ends with forward jump to 0x004c4af7
    mov edx, dword ptr [ebp - local_8]           # 004c4abf
    sar edx                                      # 004c4ac2
    push edx                                     # 004c4ac4
    mov ax, word ptr [ebp - local_18]            # 004c4ac5
    push eax                                     # 004c4ac9
    mov ecx, dword ptr [ebp - local_4]           # 004c4aca
    push ecx                                     # 004c4acd
    mov ecx, dword ptr [ebp - local_1c]          # 004c4ace
    add ecx, 0x38cc                              # 004c4ad1
    call FUN_0043ef77                            # 004c4ad7
    jmp.d8 L_004c4af7                            # 004c4adc
L_004c4ade:
    # block 0x004c4ade: entered by jne at 0x004c4abd, 6 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x004c4b0b
    push 0x5545e8                                # 004c4ade
    mov ecx, 0x583979                            # 004c4ae3
    call FUN_004264e8                            # 004c4ae8
    mov ecx, dword ptr [ebp - local_1c]          # 004c4aed
    call FUN_004c97b4                            # 004c4af0
    jmp.d8 L_004c4b0b                            # 004c4af5
L_004c4af7:
    # block 0x004c4af7: entered by jmp at 0x004c4ab3; jmp at 0x004c4adc, 6 instruction(s), ends with backward jump to 0x004c4a7b
    mov edx, dword ptr [ebp + arg_8]             # 004c4af7
    movsx eax, word ptr [edx + field_2f]         # 004c4afa
    mov ecx, dword ptr [ebp - local_4]           # 004c4afe
    {load} add ecx, eax                          # 004c4b01
    mov dword ptr [ebp - local_4], ecx           # 004c4b03
    jmp.d32 L_004c4a7b                           # 004c4b06
L_004c4b0b:
    # block 0x004c4b0b: entered by jge at 0x004c4a8a; jmp at 0x004c4af5, 4 instruction(s), ends with ret 0x14
    pop ebx                                      # 004c4b0b
    {load} mov esp, ebp                          # 004c4b0c
    pop ebp                                      # 004c4b0e
    ret 0x14                                     # 004c4b0f

