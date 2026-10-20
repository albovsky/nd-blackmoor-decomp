# FUN_004a6946
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a6946
# extent:       0x004a6946-0x004a6bce (648 code bytes)
# span:         0x004a6946-0x004a6bde (code 648, tables 16, padding 0)
# sha256:       b73570cc524baa2b6aefbfbac0a84353588cceca84906b6ccbf342f38a04e474
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a6946_click_276f_2770
# naming:       native port src/original_methods_fl24a.c:m4a6946_click_276f_2770 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4a6946_click_276f_2770 (jump-table switch, string copies, announce); an unbounded copy is rejected beyond 40 bytes. Oracle covers the 648 code bytes (the table is data).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_2c, local_30, local_34, local_38
# fields:       [eax + n] field_1e, field_20, field_21, field_86, field_8a, field_92; [ecx + n] field_1e, field_25, field_2e, field_8b, field_90, field_298, field_2f0, field_321; [edx + n] field_80, field_94; [esi + n] field_96
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m4a6946_click_276f_2770 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 177 instruction(s), 11 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_2e, 0x2e  # offset +0x2e
.equ field_80, 0x80  # offset +0x80
.equ field_86, 0x86  # offset +0x86
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8b, 0x8b  # offset +0x8b
.equ field_90, 0x90  # offset +0x90
.equ field_92, 0x92  # offset +0x92
.equ field_94, 0x94  # offset +0x94
.equ field_96, 0x96  # offset +0x96
.equ field_298, 0x298  # offset +0x298
.equ field_2f0, 0x2f0  # offset +0x2f0
.equ field_321, 0x321  # offset +0x321

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004a6946 - 0x401000
.globl FUN_004a6946
FUN_004a6946:
    # block 0x004a6946: entry, 14 instruction(s), ends with je to 0x004a6bc8 (forward)
    push ebp                                     # 004a6946
    {load} mov ebp, esp                          # 004a6947
    sub esp, 0x38                                # 004a6949
    push esi                                     # 004a694c
    push edi                                     # 004a694d
    mov dword ptr [ebp - local_34], ecx          # 004a694e
    mov eax, dword ptr [ebp - local_34]          # 004a6951
    movsx ecx, word ptr [eax + field_1e]         # 004a6954
    imul ecx, ecx, 0x8d                          # 004a6958
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a695e
    mov dword ptr [ebp - local_4], edx           # 004a6964
    mov eax, dword ptr [ebp - local_34]          # 004a6967
    cmp dword ptr [eax + field_86], 0x0          # 004a696a
    je.d32 L_004a6bc8                            # 004a6971
    # block 0x004a6977: entered by fall-through of je at 0x004a6971, 5 instruction(s), ends with jne to 0x004a6bc8 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004a6977
    {load} xor edx, edx                          # 004a697a
    mov dl, byte ptr [ecx + field_8b]            # 004a697c
    test edx, edx                                # 004a6982
    jne.d32 L_004a6bc8                           # 004a6984
    # block 0x004a698a: entered by fall-through of jne at 0x004a6984, 3 instruction(s), ends with jne to 0x004a6bc8 (forward)
    mov eax, dword ptr [ebp - local_34]          # 004a698a
    cmp dword ptr [eax + field_21], 0x0          # 004a698d
    jne.d32 L_004a6bc8                           # 004a6991
    # block 0x004a6997: entered by fall-through of jne at 0x004a6991, 5 instruction(s), ends with jne to 0x004a6bc8 (forward)
    mov ecx, dword ptr [ebp - local_34]          # 004a6997
    movsx edx, word ptr [ecx + field_1e]         # 004a699a
    imul edx, edx, 0x8d                          # 004a699e
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004a69a4
    jne.d32 L_004a6bc8                           # 004a69ab
    # block 0x004a69b1: entered by fall-through of jne at 0x004a69ab, 2 instruction(s), ends with jne to 0x004a69e3 (forward)
    cmp dword ptr [0x5c39e5], 0x2770             # 004a69b1
    jne.d8 L_004a69e3                            # 004a69bb
    # block 0x004a69bd: entered by fall-through of jne at 0x004a69bb, 7 instruction(s), ends with forward jump to 0x004a6bc8
    mov eax, dword ptr [ebp - local_34]          # 004a69bd
    mov byte ptr [eax + field_8a], 0x1           # 004a69c0
    mov ecx, dword ptr [ebp - local_34]          # 004a69c7
    movsx edx, word ptr [ecx + field_1e]         # 004a69ca
    imul edx, edx, 0x8d                          # 004a69ce
    mov dword ptr [edx + 0x5bb632], 0x2          # 004a69d4
    jmp.d32 L_004a6bc8                           # 004a69de
L_004a69e3:
    # block 0x004a69e3: entered by jne at 0x004a69bb, 2 instruction(s), ends with jne to 0x004a6bc8 (forward)
    cmp dword ptr [0x5c39e5], 0x276f             # 004a69e3
    jne.d32 L_004a6bc8                           # 004a69ed
    # block 0x004a69f3: entered by fall-through of jne at 0x004a69ed, 14 instruction(s), ends with ja to 0x004a6b8a (forward)
    mov eax, dword ptr [ebp - local_34]          # 004a69f3
    mov ecx, dword ptr [ebp - local_34]          # 004a69f6
    mov edx, dword ptr [ecx + field_25]          # 004a69f9
    mov dword ptr [eax + field_21], edx          # 004a69fc
    mov eax, dword ptr [ebp - local_34]          # 004a69ff
    mov byte ptr [eax + field_20], 0x1           # 004a6a02
    mov ecx, dword ptr [ebp - local_34]          # 004a6a06
    mov edx, dword ptr [ecx + field_25]          # 004a6a09
    mov dword ptr [ebp - local_38], edx          # 004a6a0c
    mov eax, dword ptr [ebp - local_38]          # 004a6a0f
    sub eax, 0x1                                 # 004a6a12
    mov dword ptr [ebp - local_38], eax          # 004a6a15
    cmp dword ptr [ebp - local_38], 0x3          # 004a6a18
    ja.d32 L_004a6b8a                            # 004a6a1c
    # block 0x004a6a22: entered by fall-through of ja at 0x004a6a1c, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4a6bce]
    mov ecx, dword ptr [ebp - local_38]          # 004a6a22
    jmp dword ptr [4*ecx + SWTAB_004a6bce_VA]    # 004a6a25
L_004a6a2c:
    # block 0x004a6a2c: entered by switch case, 2 instruction(s), ends with forward jump to 0x004a6a40
    mov word ptr [ebp - local_8], 0x0            # 004a6a2c
    jmp.d8 L_004a6a40                            # 004a6a32
L_004a6a34:
    # block 0x004a6a34: entered by jmp at 0x004a6a73, 3 instruction(s), falls into the block at 0x004a6a40
    mov dx, word ptr [ebp - local_8]             # 004a6a34
    add dx, 0x1                                  # 004a6a38
    mov word ptr [ebp - local_8], dx             # 004a6a3c
L_004a6a40:
    # block 0x004a6a40: entered by jmp at 0x004a6a32, 6 instruction(s), ends with jge to 0x004a6a75 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004a6a40
    mov ecx, dword ptr [ebp - local_4]           # 004a6a44
    movsx edx, word ptr [ecx + field_298]        # 004a6a47
    sub edx, 0x1                                 # 004a6a4e
    {load} cmp eax, edx                          # 004a6a51
    jge.d8 L_004a6a75                            # 004a6a53
    # block 0x004a6a55: entered by fall-through of jge at 0x004a6a53, 7 instruction(s), ends with backward jump to 0x004a6a34
    movsx eax, word ptr [ebp - local_8]          # 004a6a55
    movsx ecx, word ptr [ebp - local_8]          # 004a6a59
    mov edx, dword ptr [ebp - local_34]          # 004a6a5d
    mov esi, dword ptr [ebp - local_34]          # 004a6a60
    mov ax, word ptr [esi + 2*eax + field_96]    # 004a6a63
    mov word ptr [edx + 2*ecx + field_94], ax    # 004a6a6b
    jmp.d8 L_004a6a34                            # 004a6a73
L_004a6a75:
    # block 0x004a6a75: entered by jge at 0x004a6a53, 31 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004a6b8a
    mov ecx, dword ptr [ebp - local_4]           # 004a6a75
    movsx edx, word ptr [ecx + field_298]        # 004a6a78
    mov eax, dword ptr [ebp - local_34]          # 004a6a7f
    mov ecx, dword ptr [ebp - local_34]          # 004a6a82
    mov cx, word ptr [ecx + field_2e]            # 004a6a85
    mov word ptr [eax + 2*edx + field_92], cx    # 004a6a89
    mov edx, dword ptr [ebp - local_4]           # 004a6a91
    add edx, 0x300                               # 004a6a94
    {load} mov edi, edx                          # 004a6a9a
    lea edx, [ebp - local_2c]                    # 004a6a9c
    or ecx, -0x1                                 # 004a6a9f
    {load} xor eax, eax                          # 004a6aa2
    repne scasb al, byte ptr es:[edi]            # 004a6aa4
    not ecx                                      # 004a6aa6
    {load} sub edi, ecx                          # 004a6aa8
    {load} mov esi, edi                          # 004a6aaa
    {load} mov eax, ecx                          # 004a6aac
    {load} mov edi, edx                          # 004a6aae
    shr ecx, 0x2                                 # 004a6ab0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a6ab3
    {load} mov ecx, eax                          # 004a6ab5
    and ecx, 0x3                                 # 004a6ab7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a6aba
    mov ecx, dword ptr [ebp - local_4]           # 004a6abc
    mov dx, word ptr [ecx + field_321]           # 004a6abf
    mov word ptr [ebp - local_30], dx            # 004a6ac6
    call dword ptr [0x52a23c]                    # 004a6aca
    add eax, 0x1f4                               # 004a6ad0
    mov ecx, dword ptr [ebp - local_34]          # 004a6ad5
    mov dword ptr [ecx + field_90], eax          # 004a6ad8
    jmp.d32 L_004a6b8a                           # 004a6ade
L_004a6ae3:
    # block 0x004a6ae3: entered by switch case, 27 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004a6b8a
    mov edx, dword ptr [ebp - local_4]           # 004a6ae3
    add edx, 0x2cf                               # 004a6ae6
    {load} mov edi, edx                          # 004a6aec
    lea edx, [ebp - local_2c]                    # 004a6aee
    or ecx, -0x1                                 # 004a6af1
    {load} xor eax, eax                          # 004a6af4
    repne scasb al, byte ptr es:[edi]            # 004a6af6
    not ecx                                      # 004a6af8
    {load} sub edi, ecx                          # 004a6afa
    {load} mov esi, edi                          # 004a6afc
    {load} mov eax, ecx                          # 004a6afe
    {load} mov edi, edx                          # 004a6b00
    shr ecx, 0x2                                 # 004a6b02
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a6b05
    {load} mov ecx, eax                          # 004a6b07
    and ecx, 0x3                                 # 004a6b09
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a6b0c
    mov ecx, dword ptr [ebp - local_4]           # 004a6b0e
    mov dx, word ptr [ecx + field_2f0]           # 004a6b11
    mov word ptr [ebp - local_30], dx            # 004a6b18
    call dword ptr [0x52a23c]                    # 004a6b1c
    add eax, 0x12c                               # 004a6b22
    mov ecx, dword ptr [ebp - local_34]          # 004a6b27
    mov dword ptr [ecx + field_90], eax          # 004a6b2a
    mov edx, dword ptr [ebp - local_34]          # 004a6b30
    mov word ptr [edx + field_80], 0x1           # 004a6b33
    jmp.d8 L_004a6b8a                            # 004a6b3c
L_004a6b3e:
    # block 0x004a6b3e: entered by switch case, 24 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004a6b8a
    mov eax, dword ptr [ebp - local_4]           # 004a6b3e
    add eax, 0x300                               # 004a6b41
    {load} mov edi, eax                          # 004a6b46
    lea edx, [ebp - local_2c]                    # 004a6b48
    or ecx, -0x1                                 # 004a6b4b
    {load} xor eax, eax                          # 004a6b4e
    repne scasb al, byte ptr es:[edi]            # 004a6b50
    not ecx                                      # 004a6b52
    {load} sub edi, ecx                          # 004a6b54
    {load} mov esi, edi                          # 004a6b56
    {load} mov eax, ecx                          # 004a6b58
    {load} mov edi, edx                          # 004a6b5a
    shr ecx, 0x2                                 # 004a6b5c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a6b5f
    {load} mov ecx, eax                          # 004a6b61
    and ecx, 0x3                                 # 004a6b63
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a6b66
    mov ecx, dword ptr [ebp - local_4]           # 004a6b68
    mov dx, word ptr [ecx + field_321]           # 004a6b6b
    mov word ptr [ebp - local_30], dx            # 004a6b72
    call dword ptr [0x52a23c]                    # 004a6b76
    add eax, 0x1f4                               # 004a6b7c
    mov ecx, dword ptr [ebp - local_34]          # 004a6b81
    mov dword ptr [ecx + field_90], eax          # 004a6b84
L_004a6b8a:
    # block 0x004a6b8a: entered by ja at 0x004a6a1c; jmp at 0x004a6ade; jmp at 0x004a6b3c, 2 instruction(s), ends with je to 0x004a6bc8 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004a6b8a
    je.d8 L_004a6bc8                             # 004a6b91
    # block 0x004a6b93: entered by fall-through of je at 0x004a6b91, 6 instruction(s), ends with je to 0x004a6bc8 (forward)
    mov edi, 0x550964                            # 004a6b93
    lea esi, [ebp - local_2c]                    # 004a6b98
    mov ecx, 0x9                                 # 004a6b9b
    {load} xor edx, edx                          # 004a6ba0
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a6ba2
    je.d8 L_004a6bc8                             # 004a6ba4
    # block 0x004a6ba6: entered by fall-through of je at 0x004a6ba4, 6 instruction(s), calls FUN_004f6334, ends with jne to 0x004a6bc8 (forward)
    movsx eax, word ptr [ebp - local_30]         # 004a6ba6
    push eax                                     # 004a6baa
    mov ecx, 0x5cf1eb                            # 004a6bab
    call FUN_004f6334                            # 004a6bb0
    test eax, eax                                # 004a6bb5
    jne.d8 L_004a6bc8                            # 004a6bb7
    # block 0x004a6bb9: entered by fall-through of jne at 0x004a6bb7, 4 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a6bc8
    mov cx, word ptr [ebp - local_30]            # 004a6bb9
    push ecx                                     # 004a6bbd
    mov ecx, 0x5c3a67                            # 004a6bbe
    call FUN_004fb2e3                            # 004a6bc3
L_004a6bc8:
    # block 0x004a6bc8: entered by je at 0x004a6971; jne at 0x004a6984; jne at 0x004a6991; jne at 0x004a69ab; more, 5 instruction(s), ends with ret
    pop edi                                      # 004a6bc8
    pop esi                                      # 004a6bc9
    {load} mov esp, ebp                          # 004a6bca
    pop ebp                                      # 004a6bcc
    ret                                          # 004a6bcd

# --- data items (not part of the function) -------------------------
.org 0x004a6bce - 0x401000
SWTAB_004a6bce:  # 4 case address(es)
    .long L_004a6b3e - .text + 0x401000
    .long L_004a6ae3 - .text + 0x401000
    .long L_004a6ae3 - .text + 0x401000
    .long L_004a6a2c - .text + 0x401000
.set SWTAB_004a6bce_VA, SWTAB_004a6bce - .text + 0x401000

