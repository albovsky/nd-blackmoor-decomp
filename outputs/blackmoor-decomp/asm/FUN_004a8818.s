# FUN_004a8818
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a8818
# extent:       0x004a8818-0x004a8bf2 (986 code bytes)
# span:         0x004a8818-0x004a8bf2 (code 986, tables 0, padding 0)
# sha256:       1ecb59b1ca301fb8a2e42e83113bd4bcb4cd795fc7234f16c9577b1a6bd63df3
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a8818_click_2798_279a
# naming:       native port src/original_methods_fl25c.c:m4a8818_click_2798_279a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4a8818_click_2798_279a. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25c-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_4, field_1e, field_45, field_3c7, field_a40, field_e5e, field_e62, field_e72, field_e7a, field_e7c, field_e7f; [ecx + n] field_4, field_1e, field_396, field_a40, field_e56, field_e5e, field_e66, field_e68, field_e7a, field_e7c, field_e7e, field_e83; [edx + n] field_4, field_1e, field_43, field_a40, field_e5a, field_e5e, field_e76, field_e7a, field_e7c
# callees:      calls FUN_004f6334, FUN_004fb2e3, FUN_004a8bf2
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25c.c:m4a8818_click_2798_279a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 236 instruction(s), 21 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ local_20, 0x20  # offset -0x20
.equ field_4, 0x4  # offset +0x4
.equ field_1e, 0x1e  # offset +0x1e
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_396, 0x396  # offset +0x396
.equ field_3c7, 0x3c7  # offset +0x3c7
.equ field_a40, 0xa40  # offset +0xa40
.equ field_e56, 0xe56  # offset +0xe56
.equ field_e5a, 0xe5a  # offset +0xe5a
.equ field_e5e, 0xe5e  # offset +0xe5e
.equ field_e62, 0xe62  # offset +0xe62
.equ field_e66, 0xe66  # offset +0xe66
.equ field_e68, 0xe68  # offset +0xe68
.equ field_e72, 0xe72  # offset +0xe72
.equ field_e76, 0xe76  # offset +0xe76
.equ field_e7a, 0xe7a  # offset +0xe7a
.equ field_e7c, 0xe7c  # offset +0xe7c
.equ field_e7e, 0xe7e  # offset +0xe7e
.equ field_e7f, 0xe7f  # offset +0xe7f
.equ field_e83, 0xe83  # offset +0xe83

# --- external targets -----------------------------------------------
.set FUN_004a8bf2, .text + (0x004a8bf2 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004a8818 - 0x401000
.globl FUN_004a8818
FUN_004a8818:
    # block 0x004a8818: entry, 14 instruction(s), ends with je to 0x004a8bec (forward)
    push ebp                                     # 004a8818
    {load} mov ebp, esp                          # 004a8819
    sub esp, 0x20                                # 004a881b
    push esi                                     # 004a881e
    push edi                                     # 004a881f
    mov dword ptr [ebp - local_20], ecx          # 004a8820
    mov eax, dword ptr [ebp - local_20]          # 004a8823
    movsx ecx, word ptr [eax + field_1e]         # 004a8826
    imul ecx, ecx, 0x8d                          # 004a882a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a8830
    mov dword ptr [ebp - local_14], edx          # 004a8836
    mov eax, dword ptr [ebp - local_20]          # 004a8839
    cmp dword ptr [eax + field_e72], 0x0         # 004a883c
    je.d32 L_004a8bec                            # 004a8843
    # block 0x004a8849: entered by fall-through of je at 0x004a8843, 5 instruction(s), ends with jne to 0x004a8bec (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004a8849
    {load} xor edx, edx                          # 004a884c
    mov dl, byte ptr [ecx + field_e83]           # 004a884e
    test edx, edx                                # 004a8854
    jne.d32 L_004a8bec                           # 004a8856
    # block 0x004a885c: entered by fall-through of jne at 0x004a8856, 3 instruction(s), ends with jne to 0x004a8bec (forward)
    mov eax, dword ptr [ebp - local_20]          # 004a885c
    cmp dword ptr [eax + field_e7f], 0x0         # 004a885f
    jne.d32 L_004a8bec                           # 004a8866
    # block 0x004a886c: entered by fall-through of jne at 0x004a8866, 5 instruction(s), ends with jne to 0x004a8bec (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004a886c
    movsx edx, word ptr [ecx + field_1e]         # 004a886f
    imul edx, edx, 0x8d                          # 004a8873
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004a8879
    jne.d32 L_004a8bec                           # 004a8880
    # block 0x004a8886: entered by fall-through of jne at 0x004a8880, 3 instruction(s), ends with jne to 0x004a88c4 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004a8886
    cmp dword ptr [eax + field_e5e], 0x0         # 004a8889
    jne.d8 L_004a88c4                            # 004a8890
    # block 0x004a8892: entered by fall-through of jne at 0x004a8890, 2 instruction(s), ends with jne to 0x004a88c4 (forward)
    cmp dword ptr [0x5c39e5], 0x279a             # 004a8892
    jne.d8 L_004a88c4                            # 004a889c
    # block 0x004a889e: entered by fall-through of jne at 0x004a889c, 7 instruction(s), ends with forward jump to 0x004a8b33
    mov ecx, dword ptr [ebp - local_20]          # 004a889e
    mov byte ptr [ecx + field_e7e], 0x1          # 004a88a1
    mov edx, dword ptr [ebp - local_20]          # 004a88a8
    movsx eax, word ptr [edx + field_1e]         # 004a88ab
    imul eax, eax, 0x8d                          # 004a88af
    mov dword ptr [eax + 0x5bb632], 0x2          # 004a88b5
    jmp.d32 L_004a8b33                           # 004a88bf
L_004a88c4:
    # block 0x004a88c4: entered by jne at 0x004a8890; jne at 0x004a889c, 3 instruction(s), ends with jne to 0x004a89ca (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004a88c4
    cmp dword ptr [ecx + field_e5e], 0x0         # 004a88c7
    jne.d32 L_004a89ca                           # 004a88ce
    # block 0x004a88d4: entered by fall-through of jne at 0x004a88ce, 2 instruction(s), ends with jne to 0x004a89ca (forward)
    cmp dword ptr [0x5c39e5], 0x2798             # 004a88d4
    jne.d32 L_004a89ca                           # 004a88de
    # block 0x004a88e4: entered by fall-through of jne at 0x004a88de, 32 instruction(s), ends with je to 0x004a89c5 (forward)
    mov edx, dword ptr [ebp - local_20]          # 004a88e4
    mov dword ptr [edx + field_e76], 0x0         # 004a88e7
    mov eax, dword ptr [ebp - local_20]          # 004a88f1
    mov dword ptr [eax + field_e5e], 0x1         # 004a88f4
    mov ecx, dword ptr [ebp - local_20]          # 004a88fe
    mov dword ptr [ecx + field_e56], 0x1         # 004a8901
    mov edx, dword ptr [ebp - local_20]          # 004a890b
    movsx eax, word ptr [edx + field_e7a]        # 004a890e
    imul eax, eax, 0x36                          # 004a8915
    mov ecx, dword ptr [ebp - local_20]          # 004a8918
    lea edx, [ecx + eax + field_a40]             # 004a891b
    mov eax, dword ptr [ebp - local_20]          # 004a8922
    movsx ecx, word ptr [eax + field_e7c]        # 004a8925
    imul ecx, ecx, 0x6                           # 004a892c
    {load} add edx, ecx                          # 004a892f
    mov eax, dword ptr [ebp - local_20]          # 004a8931
    add eax, 0xe10                               # 004a8934
    mov ecx, dword ptr [edx]                     # 004a8939
    mov dword ptr [eax], ecx                     # 004a893b
    mov dx, word ptr [edx + field_4]             # 004a893d
    mov word ptr [eax + field_4], dx             # 004a8941
    mov eax, dword ptr [ebp - local_20]          # 004a8945
    movsx ecx, word ptr [eax + field_e7a]        # 004a8948
    imul ecx, ecx, 0x36                          # 004a894f
    mov edx, dword ptr [ebp - local_20]          # 004a8952
    lea eax, [edx + ecx + field_a40]             # 004a8955
    mov ecx, dword ptr [ebp - local_20]          # 004a895c
    movsx edx, word ptr [ecx + field_e7c]        # 004a895f
    imul edx, edx, 0x6                           # 004a8966
    mov word ptr [eax + edx], 0xfff6             # 004a8969
    cmp dword ptr [0x5bb1ca], 0x0                # 004a896f
    je.d8 L_004a89c5                             # 004a8976
    # block 0x004a8978: entered by fall-through of je at 0x004a8976, 7 instruction(s), ends with je to 0x004a89c5 (forward)
    mov edi, 0x550bac                            # 004a8978
    mov esi, dword ptr [ebp - local_14]          # 004a897d
    add esi, 0x375                               # 004a8980
    mov ecx, 0x9                                 # 004a8986
    {load} xor eax, eax                          # 004a898b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a898d
    je.d8 L_004a89c5                             # 004a898f
    # block 0x004a8991: entered by fall-through of je at 0x004a898f, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a89c5 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004a8991
    movsx edx, word ptr [ecx + field_396]        # 004a8994
    mov dword ptr [ebp - local_18], edx          # 004a899b
    mov eax, dword ptr [ebp - local_18]          # 004a899e
    push eax                                     # 004a89a1
    mov ecx, 0x5cf1eb                            # 004a89a2
    call FUN_004f6334                            # 004a89a7
    test eax, eax                                # 004a89ac
    jne.d8 L_004a89c5                            # 004a89ae
    # block 0x004a89b0: entered by fall-through of jne at 0x004a89ae, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a89c5
    mov ecx, dword ptr [ebp - local_14]          # 004a89b0
    mov dx, word ptr [ecx + field_396]           # 004a89b3
    push edx                                     # 004a89ba
    mov ecx, 0x5c3a67                            # 004a89bb
    call FUN_004fb2e3                            # 004a89c0
L_004a89c5:
    # block 0x004a89c5: entered by je at 0x004a8976; je at 0x004a898f; jne at 0x004a89ae, 1 instruction(s), ends with forward jump to 0x004a8b33
    jmp.d32 L_004a8b33                           # 004a89c5
L_004a89ca:
    # block 0x004a89ca: entered by jne at 0x004a88ce; jne at 0x004a88de, 3 instruction(s), ends with je to 0x004a8b33 (forward)
    mov eax, dword ptr [ebp - local_20]          # 004a89ca
    cmp dword ptr [eax + field_e5e], 0x0         # 004a89cd
    je.d32 L_004a8b33                            # 004a89d4
    # block 0x004a89da: entered by fall-through of je at 0x004a89d4, 2 instruction(s), ends with jne to 0x004a8b33 (forward)
    cmp dword ptr [0x5c39e5], 0x2799             # 004a89da
    jne.d32 L_004a8b33                           # 004a89e4
    # block 0x004a89ea: entered by fall-through of jne at 0x004a89e4, 42 instruction(s), ends with je to 0x004a8af0 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004a89ea
    movsx edx, word ptr [ecx + field_e7a]        # 004a89ed
    imul edx, edx, 0x36                          # 004a89f4
    mov eax, dword ptr [ebp - local_20]          # 004a89f7
    lea ecx, [eax + edx + field_a40]             # 004a89fa
    mov edx, dword ptr [ebp - local_20]          # 004a8a01
    movsx eax, word ptr [edx + field_e7c]        # 004a8a04
    imul eax, eax, 0x6                           # 004a8a0b
    {load} add ecx, eax                          # 004a8a0e
    mov edx, dword ptr [ecx]                     # 004a8a10
    mov dword ptr [ebp - local_8], edx           # 004a8a12
    mov ax, word ptr [ecx + field_4]             # 004a8a15
    mov word ptr [ebp - local_4], ax             # 004a8a19
    mov ecx, dword ptr [ebp - local_20]          # 004a8a1d
    add ecx, 0xe10                               # 004a8a20
    mov edx, dword ptr [ebp - local_20]          # 004a8a26
    movsx eax, word ptr [edx + field_e7a]        # 004a8a29
    imul eax, eax, 0x36                          # 004a8a30
    mov edx, dword ptr [ebp - local_20]          # 004a8a33
    lea eax, [edx + eax + field_a40]             # 004a8a36
    mov edx, dword ptr [ebp - local_20]          # 004a8a3d
    movsx edx, word ptr [edx + field_e7c]        # 004a8a40
    imul edx, edx, 0x6                           # 004a8a47
    {load} add eax, edx                          # 004a8a4a
    mov edx, dword ptr [ecx]                     # 004a8a4c
    mov dword ptr [eax], edx                     # 004a8a4e
    mov cx, word ptr [ecx + field_4]             # 004a8a50
    mov word ptr [eax + field_4], cx             # 004a8a54
    mov edx, dword ptr [ebp - local_20]          # 004a8a58
    mov dword ptr [edx + field_e5a], 0x1         # 004a8a5b
    mov eax, dword ptr [ebp - local_20]          # 004a8a65
    mov dword ptr [eax + field_e62], 0x1         # 004a8a68
    mov ecx, dword ptr [ebp - local_20]          # 004a8a72
    mov edx, dword ptr [ebp - local_20]          # 004a8a75
    mov ax, word ptr [edx + field_e7c]           # 004a8a78
    mov word ptr [ecx + field_e66], ax           # 004a8a7f
    mov ecx, dword ptr [ebp - local_20]          # 004a8a86
    mov edx, dword ptr [ebp - local_20]          # 004a8a89
    mov ax, word ptr [edx + field_e7a]           # 004a8a8c
    mov word ptr [ecx + field_e68], ax           # 004a8a93
    cmp dword ptr [0x5bb1ca], 0x0                # 004a8a9a
    je.d8 L_004a8af0                             # 004a8aa1
    # block 0x004a8aa3: entered by fall-through of je at 0x004a8aa1, 7 instruction(s), ends with je to 0x004a8af0 (forward)
    mov edi, 0x550bb8                            # 004a8aa3
    mov esi, dword ptr [ebp - local_14]          # 004a8aa8
    add esi, 0x3a6                               # 004a8aab
    mov ecx, 0x9                                 # 004a8ab1
    {load} xor edx, edx                          # 004a8ab6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a8ab8
    je.d8 L_004a8af0                             # 004a8aba
    # block 0x004a8abc: entered by fall-through of je at 0x004a8aba, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a8af0 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004a8abc
    movsx ecx, word ptr [eax + field_3c7]        # 004a8abf
    mov dword ptr [ebp - local_1c], ecx          # 004a8ac6
    mov edx, dword ptr [ebp - local_1c]          # 004a8ac9
    push edx                                     # 004a8acc
    mov ecx, 0x5cf1eb                            # 004a8acd
    call FUN_004f6334                            # 004a8ad2
    test eax, eax                                # 004a8ad7
    jne.d8 L_004a8af0                            # 004a8ad9
    # block 0x004a8adb: entered by fall-through of jne at 0x004a8ad9, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a8af0
    mov eax, dword ptr [ebp - local_14]          # 004a8adb
    mov cx, word ptr [eax + field_3c7]           # 004a8ade
    push ecx                                     # 004a8ae5
    mov ecx, 0x5c3a67                            # 004a8ae6
    call FUN_004fb2e3                            # 004a8aeb
L_004a8af0:
    # block 0x004a8af0: entered by je at 0x004a8aa1; je at 0x004a8aba; jne at 0x004a8ad9, 3 instruction(s), ends with jne to 0x004a8b10 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004a8af0
    cmp edx, -0xa                                # 004a8af4
    jne.d8 L_004a8b10                            # 004a8af7
    # block 0x004a8af9: entered by fall-through of jne at 0x004a8af7, 5 instruction(s), calls FUN_004a8bf2, ends with forward jump to 0x004a8b33
    mov eax, dword ptr [ebp - local_20]          # 004a8af9
    mov dword ptr [eax + field_e5e], 0x0         # 004a8afc
    mov ecx, dword ptr [ebp - local_20]          # 004a8b06
    call FUN_004a8bf2                            # 004a8b09
    jmp.d8 L_004a8b33                            # 004a8b0e
L_004a8b10:
    # block 0x004a8b10: entered by jne at 0x004a8af7, 8 instruction(s), falls into the block at 0x004a8b33
    mov ecx, dword ptr [ebp - local_20]          # 004a8b10
    mov dword ptr [ecx + field_e56], 0x1         # 004a8b13
    mov edx, dword ptr [ebp - local_20]          # 004a8b1d
    add edx, 0xe10                               # 004a8b20
    mov eax, dword ptr [ebp - local_8]           # 004a8b26
    mov dword ptr [edx], eax                     # 004a8b29
    mov cx, word ptr [ebp - local_4]             # 004a8b2b
    mov word ptr [edx + field_4], cx             # 004a8b2f
L_004a8b33:
    # block 0x004a8b33: entered by jmp at 0x004a88bf; jmp at 0x004a89c5; je at 0x004a89d4; jne at 0x004a89e4; more, 9 instruction(s), ends with je to 0x004a8bec (forward)
    mov esi, dword ptr [ebp - local_20]          # 004a8b33
    add esi, 0xa40                               # 004a8b36
    mov ecx, 0x79                                # 004a8b3c
    mov edi, 0x5a110f                            # 004a8b41
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a8b46
    movsw word ptr es:[edi], word ptr [esi]      # 004a8b48
    mov edx, dword ptr [ebp - local_20]          # 004a8b4a
    cmp dword ptr [edx + field_e5e], 0x0         # 004a8b4d
    je.d32 L_004a8bec                            # 004a8b54
    # block 0x004a8b5a: entered by fall-through of je at 0x004a8b54, 2 instruction(s), ends with forward jump to 0x004a8b6e
    mov word ptr [ebp - local_c], 0x0            # 004a8b5a
    jmp.d8 L_004a8b6e                            # 004a8b60
L_004a8b62:
    # block 0x004a8b62: entered by jmp at 0x004a8be7, 3 instruction(s), falls into the block at 0x004a8b6e
    mov ax, word ptr [ebp - local_c]             # 004a8b62
    .insn 0x66, 0x05, 0x0001{:u16}               # 004a8b66
    mov word ptr [ebp - local_c], ax             # 004a8b6a
L_004a8b6e:
    # block 0x004a8b6e: entered by jmp at 0x004a8b60, 5 instruction(s), ends with jge to 0x004a8bec (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004a8b6e
    mov edx, dword ptr [ebp - local_14]          # 004a8b72
    movsx eax, word ptr [edx + field_43]         # 004a8b75
    {load} cmp ecx, eax                          # 004a8b79
    jge.d8 L_004a8bec                            # 004a8b7b
    # block 0x004a8b7d: entered by fall-through of jge at 0x004a8b7b, 2 instruction(s), ends with forward jump to 0x004a8b91
    mov word ptr [ebp - local_10], 0x0           # 004a8b7d
    jmp.d8 L_004a8b91                            # 004a8b83
L_004a8b85:
    # block 0x004a8b85: entered by jmp at 0x004a8be5, 3 instruction(s), falls into the block at 0x004a8b91
    mov cx, word ptr [ebp - local_10]            # 004a8b85
    add cx, 0x1                                  # 004a8b89
    mov word ptr [ebp - local_10], cx            # 004a8b8d
L_004a8b91:
    # block 0x004a8b91: entered by jmp at 0x004a8b83, 5 instruction(s), ends with jge to 0x004a8be7 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004a8b91
    mov eax, dword ptr [ebp - local_14]          # 004a8b95
    movsx ecx, word ptr [eax + field_45]         # 004a8b98
    {load} cmp edx, ecx                          # 004a8b9c
    jge.d8 L_004a8be7                            # 004a8b9e
    # block 0x004a8ba0: entered by fall-through of jge at 0x004a8b9e, 7 instruction(s), ends with jne to 0x004a8be5 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004a8ba0
    imul edx, edx, 0x36                          # 004a8ba4
    movsx eax, word ptr [ebp - local_10]         # 004a8ba7
    imul eax, eax, 0x6                           # 004a8bab
    movsx ecx, word ptr [edx + eax + 0x5a110f]   # 004a8bae
    cmp ecx, -0xa                                # 004a8bb6
    jne.d8 L_004a8be5                            # 004a8bb9
    # block 0x004a8bbb: entered by fall-through of jne at 0x004a8bb9, 11 instruction(s), falls into the block at 0x004a8be5
    mov edx, dword ptr [ebp - local_20]          # 004a8bbb
    add edx, 0xe10                               # 004a8bbe
    movsx eax, word ptr [ebp - local_c]          # 004a8bc4
    imul eax, eax, 0x36                          # 004a8bc8
    movsx ecx, word ptr [ebp - local_10]         # 004a8bcb
    imul ecx, ecx, 0x6                           # 004a8bcf
    lea eax, [eax + ecx + 0x5a110f]              # 004a8bd2
    mov ecx, dword ptr [edx]                     # 004a8bd9
    mov dword ptr [eax], ecx                     # 004a8bdb
    mov dx, word ptr [edx + field_4]             # 004a8bdd
    mov word ptr [eax + field_4], dx             # 004a8be1
L_004a8be5:
    # block 0x004a8be5: entered by jne at 0x004a8bb9, 1 instruction(s), ends with backward jump to 0x004a8b85
    jmp.d8 L_004a8b85                            # 004a8be5
L_004a8be7:
    # block 0x004a8be7: entered by jge at 0x004a8b9e, 1 instruction(s), ends with backward jump to 0x004a8b62
    jmp.d32 L_004a8b62                           # 004a8be7
L_004a8bec:
    # block 0x004a8bec: entered by je at 0x004a8843; jne at 0x004a8856; jne at 0x004a8866; jne at 0x004a8880; more, 5 instruction(s), ends with ret
    pop edi                                      # 004a8bec
    pop esi                                      # 004a8bed
    {load} mov esp, ebp                          # 004a8bee
    pop ebp                                      # 004a8bf0
    ret                                          # 004a8bf1

