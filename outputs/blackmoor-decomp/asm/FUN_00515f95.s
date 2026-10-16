# FUN_00515f95
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515f95
# extent:       0x00515f95-0x0051621c (647 code bytes)
# span:         0x00515f95-0x0051621c (code 647, tables 0, padding 0)
# sha256:       f65a6b9ae64939832af701f3a6cb30530cd03022cdb29b2c9058596ecc8f8129
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515f95
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_3, field_3f
# callees:      calls FUN_00512c18, FUN_00518999, FUN_00512c79, KERNEL32.dll!GetTimeZoneInformation, FUN_005130f0, FUN_0050e936, FUN_00511f30, FUN_0050ea90, FUN_005128b0, FUN_0050d960, FUN_0050ca90; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 207 instruction(s), 25 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_3, 0x3  # offset +0x3
.equ field_3f, 0x3f  # offset +0x3f

# --- external targets -----------------------------------------------
.set FUN_0050ca90, .text + (0x0050ca90 - 0x401000)
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_005130f0, .text + (0x005130f0 - 0x401000)
.set FUN_00518999, .text + (0x00518999 - 0x401000)

.org 0x00515f95 - 0x401000
.globl FUN_00515f95
FUN_00515f95:
    # block 0x00515f95: entry, 22 instruction(s), calls FUN_00512c18, FUN_00518999, ends with jne to 0x005160d3 (forward)
    push ebp                                     # 00515f95
    {load} mov ebp, esp                          # 00515f96
    push ecx                                     # 00515f98
    push ecx                                     # 00515f99
    push ebx                                     # 00515f9a
    push esi                                     # 00515f9b
    push edi                                     # 00515f9c
    push 0xc                                     # 00515f9d
    pop edi                                      # 00515f9f
    {load} xor ebx, ebx                          # 00515fa0
    push edi                                     # 00515fa2
    mov dword ptr [ebp - local_8], ebx           # 00515fa3
    call FUN_00512c18                            # 00515fa6
    or dword ptr [0x568c28], -0x1                # 00515fab
    or dword ptr [0x568c18], -0x1                # 00515fb2
    mov dword ptr [0x63cc58], ebx                # 00515fb9
    mov dword ptr [esp], 0x530974                # 00515fbf
    call FUN_00518999                            # 00515fc6
    {load} mov esi, eax                          # 00515fcb
    pop ecx                                      # 00515fcd
    {load} cmp esi, ebx                          # 00515fce
    jne.d32 L_005160d3                           # 00515fd0
    # block 0x00515fd6: entered by fall-through of jne at 0x00515fd0, 6 instruction(s), calls FUN_00512c79, KERNEL32.dll!GetTimeZoneInformation, ends with je to 0x00516217 (forward)
    push edi                                     # 00515fd6
    call FUN_00512c79                            # 00515fd7
    mov dword ptr [esp], 0x63cc60                # 00515fdc
    call dword ptr [0x52a138]                    # 00515fe3
    cmp eax, -0x1                                # 00515fe9
    je.d32 L_00516217                            # 00515fec
    # block 0x00515ff2: entered by fall-through of je at 0x00515fec, 9 instruction(s), ends with je to 0x00516023 (forward)
    mov eax, dword ptr [0x63cc60]                # 00515ff2
    mov ecx, dword ptr [0x63ccb4]                # 00515ff7
    imul eax, eax, 0x3c                          # 00515ffd
    cmp word ptr [0x63cca6], bx                  # 00516000
    push 0x1                                     # 00516007
    pop edx                                      # 00516009
    mov dword ptr [0x568b80], eax                # 0051600a
    mov dword ptr [0x63cc58], edx                # 0051600f
    je.d8 L_00516023                             # 00516015
    # block 0x00516017: entered by fall-through of je at 0x00516015, 4 instruction(s), falls into the block at 0x00516023
    {load} mov esi, ecx                          # 00516017
    imul esi, esi, 0x3c                          # 00516019
    {load} add eax, esi                          # 0051601c
    mov dword ptr [0x568b80], eax                # 0051601e
L_00516023:
    # block 0x00516023: entered by je at 0x00516015, 2 instruction(s), ends with je to 0x00516047 (forward)
    cmp word ptr [0x63ccfa], bx                  # 00516023
    je.d8 L_00516047                             # 0051602a
    # block 0x0051602c: entered by fall-through of je at 0x0051602a, 3 instruction(s), ends with je to 0x00516047 (forward)
    mov eax, dword ptr [0x63cd08]                # 0051602c
    {load} cmp eax, ebx                          # 00516031
    je.d8 L_00516047                             # 00516033
    # block 0x00516035: entered by fall-through of je at 0x00516033, 5 instruction(s), ends with forward jump to 0x00516053
    {load} sub eax, ecx                          # 00516035
    mov dword ptr [0x568b84], edx                # 00516037
    imul eax, eax, 0x3c                          # 0051603d
    mov dword ptr [0x568b88], eax                # 00516040
    jmp.d8 L_00516053                            # 00516045
L_00516047:
    # block 0x00516047: entered by je at 0x0051602a; je at 0x00516033, 2 instruction(s), falls into the block at 0x00516053
    mov dword ptr [0x568b84], ebx                # 00516047
    mov dword ptr [0x568b88], ebx                # 0051604d
L_00516053:
    # block 0x00516053: entered by jmp at 0x00516045, 14 instruction(s), calls indirect esi, ends with je to 0x0051608f (forward)
    lea eax, [ebp - local_4]                     # 00516053
    mov esi, dword ptr [0x52a1f4]                # 00516056
    push eax                                     # 0051605c
    push ebx                                     # 0051605d
    push 0x3f                                    # 0051605e
    mov edi, 0x220                               # 00516060
    push dword ptr [0x568c0c]                    # 00516065
    push -0x1                                    # 0051606b
    push 0x63cc64                                # 0051606d
    push edi                                     # 00516072
    push dword ptr [0x63cb2c]                    # 00516073
    call esi                                     # 00516079
    test eax, eax                                # 0051607b
    je.d8 L_0051608f                             # 0051607d
    # block 0x0051607f: entered by fall-through of je at 0x0051607d, 2 instruction(s), ends with jne to 0x0051608f (forward)
    cmp dword ptr [ebp - local_4], ebx           # 0051607f
    jne.d8 L_0051608f                            # 00516082
    # block 0x00516084: entered by fall-through of jne at 0x00516082, 3 instruction(s), ends with forward jump to 0x00516097
    mov eax, dword ptr [0x568c0c]                # 00516084
    and byte ptr [eax + field_3f], 0x0           # 00516089
    jmp.d8 L_00516097                            # 0051608d
L_0051608f:
    # block 0x0051608f: entered by je at 0x0051607d; jne at 0x00516082, 2 instruction(s), falls into the block at 0x00516097
    mov eax, dword ptr [0x568c0c]                # 0051608f
    and byte ptr [eax], 0x0                      # 00516094
L_00516097:
    # block 0x00516097: entered by jmp at 0x0051608d, 12 instruction(s), calls indirect esi, ends with je to 0x00516206 (forward)
    lea eax, [ebp - local_4]                     # 00516097
    push eax                                     # 0051609a
    push ebx                                     # 0051609b
    push 0x3f                                    # 0051609c
    push dword ptr [0x568c10]                    # 0051609e
    push -0x1                                    # 005160a4
    push 0x63ccb8                                # 005160a6
    push edi                                     # 005160ab
    push dword ptr [0x63cb2c]                    # 005160ac
    call esi                                     # 005160b2
    test eax, eax                                # 005160b4
    je.d32 L_00516206                            # 005160b6
    # block 0x005160bc: entered by fall-through of je at 0x005160b6, 2 instruction(s), ends with jne to 0x00516206 (forward)
    cmp dword ptr [ebp - local_4], ebx           # 005160bc
    jne.d32 L_00516206                           # 005160bf
    # block 0x005160c5: entered by fall-through of jne at 0x005160bf, 3 instruction(s), ends with forward jump to 0x00516217
    mov eax, dword ptr [0x568c10]                # 005160c5
    and byte ptr [eax + field_3f], 0x0           # 005160ca
    jmp.d32 L_00516217                           # 005160ce
L_005160d3:
    # block 0x005160d3: entered by jne at 0x00515fd0, 2 instruction(s), ends with je to 0x00516210 (forward)
    cmp byte ptr [esi], 0x0                      # 005160d3
    je.d32 L_00516210                            # 005160d6
    # block 0x005160dc: entered by fall-through of je at 0x005160d6, 3 instruction(s), ends with je to 0x005160f6 (forward)
    mov eax, dword ptr [0x63cd0c]                # 005160dc
    {load} cmp eax, ebx                          # 005160e1
    je.d8 L_005160f6                             # 005160e3
    # block 0x005160e5: entered by fall-through of je at 0x005160e3, 7 instruction(s), calls FUN_005130f0, ends with je to 0x00516210 (forward)
    push eax                                     # 005160e5
    push esi                                     # 005160e6
    call FUN_005130f0                            # 005160e7
    pop ecx                                      # 005160ec
    test eax, eax                                # 005160ed
    pop ecx                                      # 005160ef
    je.d32 L_00516210                            # 005160f0
L_005160f6:
    # block 0x005160f6: entered by je at 0x005160e3; fall-through of je at 0x005160f0, 11 instruction(s), calls FUN_0050e936, FUN_00511f30, FUN_0050ea90, ends with je to 0x00516210 (forward)
    push dword ptr [0x63cd0c]                    # 005160f6
    call FUN_0050e936                            # 005160fc
    push esi                                     # 00516101
    call FUN_00511f30                            # 00516102
    inc eax                                      # 00516107
    push eax                                     # 00516108
    call FUN_0050ea90                            # 00516109
    add esp, 0xc                                 # 0051610e
    {load} cmp eax, ebx                          # 00516111
    mov dword ptr [0x63cd0c], eax                # 00516113
    je.d32 L_00516210                            # 00516118
    # block 0x0051611e: entered by fall-through of je at 0x00516118, 15 instruction(s), calls FUN_005128b0, FUN_00512c79, FUN_0050d960, ends with jne to 0x00516155 (forward)
    push esi                                     # 0051611e
    push eax                                     # 0051611f
    call FUN_005128b0                            # 00516120
    push edi                                     # 00516125
    call FUN_00512c79                            # 00516126
    push 0x3                                     # 0051612b
    push esi                                     # 0051612d
    push dword ptr [0x568c0c]                    # 0051612e
    call FUN_0050d960                            # 00516134
    mov eax, dword ptr [0x568c0c]                # 00516139
    add esi, 0x3                                 # 0051613e
    add esp, 0x18                                # 00516141
    and byte ptr [eax + field_3], 0x0            # 00516144
    cmp byte ptr [esi], 0x2d                     # 00516148
    jne.d8 L_00516155                            # 0051614b
    # block 0x0051614d: entered by fall-through of jne at 0x0051614b, 2 instruction(s), falls into the block at 0x00516155
    mov dword ptr [ebp - local_8], 0x1           # 0051614d
    inc esi                                      # 00516154
L_00516155:
    # block 0x00516155: entered by jne at 0x0051614b, 7 instruction(s), calls FUN_0050ca90, falls into the block at 0x0051616c
    push esi                                     # 00516155
    call FUN_0050ca90                            # 00516156
    pop ecx                                      # 0051615b
    mov bl, 0x30                                 # 0051615c
    {load} mov ecx, eax                          # 0051615e
    imul ecx, ecx, 0xe10                         # 00516160
    mov dword ptr [0x568b80], ecx                # 00516166
L_0051616c:
    # block 0x0051616c: entered by jmp at 0x0051617b, 3 instruction(s), ends with je to 0x0051617a (forward)
    mov al, byte ptr [esi]                       # 0051616c
    cmp al, 0x2b                                 # 0051616e
    je.d8 L_0051617a                             # 00516170
    # block 0x00516172: entered by fall-through of je at 0x00516170, 2 instruction(s), ends with jl to 0x0051617d (forward)
    {load} cmp al, bl                            # 00516172
    jl.d8 L_0051617d                             # 00516174
    # block 0x00516176: entered by fall-through of jl at 0x00516174, 2 instruction(s), ends with jg to 0x0051617d (forward)
    cmp al, 0x39                                 # 00516176
    jg.d8 L_0051617d                             # 00516178
L_0051617a:
    # block 0x0051617a: entered by je at 0x00516170; fall-through of jg at 0x00516178, 2 instruction(s), ends with backward jump to 0x0051616c
    inc esi                                      # 0051617a
    jmp.d8 L_0051616c                            # 0051617b
L_0051617d:
    # block 0x0051617d: entered by jl at 0x00516174; jg at 0x00516178, 2 instruction(s), ends with jne to 0x005161d0 (forward)
    cmp byte ptr [esi], 0x3a                     # 0051617d
    jne.d8 L_005161d0                            # 00516180
    # block 0x00516182: entered by fall-through of jne at 0x00516180, 8 instruction(s), calls FUN_0050ca90, falls into the block at 0x0051619b
    inc esi                                      # 00516182
    push esi                                     # 00516183
    call FUN_0050ca90                            # 00516184
    imul eax, eax, 0x3c                          # 00516189
    pop ecx                                      # 0051618c
    mov ecx, dword ptr [0x568b80]                # 0051618d
    {load} add ecx, eax                          # 00516193
    mov dword ptr [0x568b80], ecx                # 00516195
L_0051619b:
    # block 0x0051619b: entered by jmp at 0x005161a6, 3 instruction(s), ends with jl to 0x005161a8 (forward)
    mov al, byte ptr [esi]                       # 0051619b
    {load} cmp al, bl                            # 0051619d
    jl.d8 L_005161a8                             # 0051619f
    # block 0x005161a1: entered by fall-through of jl at 0x0051619f, 2 instruction(s), ends with jg to 0x005161a8 (forward)
    cmp al, 0x39                                 # 005161a1
    jg.d8 L_005161a8                             # 005161a3
    # block 0x005161a5: entered by fall-through of jg at 0x005161a3, 2 instruction(s), ends with backward jump to 0x0051619b
    inc esi                                      # 005161a5
    jmp.d8 L_0051619b                            # 005161a6
L_005161a8:
    # block 0x005161a8: entered by jl at 0x0051619f; jg at 0x005161a3, 2 instruction(s), ends with jne to 0x005161d0 (forward)
    cmp byte ptr [esi], 0x3a                     # 005161a8
    jne.d8 L_005161d0                            # 005161ab
    # block 0x005161ad: entered by fall-through of jne at 0x005161ab, 7 instruction(s), calls FUN_0050ca90, falls into the block at 0x005161c3
    inc esi                                      # 005161ad
    push esi                                     # 005161ae
    call FUN_0050ca90                            # 005161af
    pop ecx                                      # 005161b4
    mov ecx, dword ptr [0x568b80]                # 005161b5
    {load} add ecx, eax                          # 005161bb
    mov dword ptr [0x568b80], ecx                # 005161bd
L_005161c3:
    # block 0x005161c3: entered by jmp at 0x005161ce, 3 instruction(s), ends with jl to 0x005161d0 (forward)
    mov al, byte ptr [esi]                       # 005161c3
    {load} cmp al, bl                            # 005161c5
    jl.d8 L_005161d0                             # 005161c7
    # block 0x005161c9: entered by fall-through of jl at 0x005161c7, 2 instruction(s), ends with jg to 0x005161d0 (forward)
    cmp al, 0x39                                 # 005161c9
    jg.d8 L_005161d0                             # 005161cb
    # block 0x005161cd: entered by fall-through of jg at 0x005161cb, 2 instruction(s), ends with backward jump to 0x005161c3
    inc esi                                      # 005161cd
    jmp.d8 L_005161c3                            # 005161ce
L_005161d0:
    # block 0x005161d0: entered by jne at 0x00516180; jne at 0x005161ab; jl at 0x005161c7; jg at 0x005161cb, 2 instruction(s), ends with je to 0x005161de (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 005161d0
    je.d8 L_005161de                             # 005161d4
    # block 0x005161d6: entered by fall-through of je at 0x005161d4, 2 instruction(s), falls into the block at 0x005161de
    neg ecx                                      # 005161d6
    mov dword ptr [0x568b80], ecx                # 005161d8
L_005161de:
    # block 0x005161de: entered by je at 0x005161d4, 4 instruction(s), ends with je to 0x00516206 (forward)
    movsx eax, byte ptr [esi]                    # 005161de
    test eax, eax                                # 005161e1
    mov dword ptr [0x568b84], eax                # 005161e3
    je.d8 L_00516206                             # 005161e8
    # block 0x005161ea: entered by fall-through of je at 0x005161e8, 8 instruction(s), calls FUN_0050d960, ends with forward jump to 0x00516217
    push 0x3                                     # 005161ea
    push esi                                     # 005161ec
    push dword ptr [0x568c10]                    # 005161ed
    call FUN_0050d960                            # 005161f3
    mov eax, dword ptr [0x568c10]                # 005161f8
    add esp, 0xc                                 # 005161fd
    and byte ptr [eax + field_3], 0x0            # 00516200
    jmp.d8 L_00516217                            # 00516204
L_00516206:
    # block 0x00516206: entered by je at 0x005160b6; jne at 0x005160bf; je at 0x005161e8, 3 instruction(s), ends with forward jump to 0x00516217
    mov eax, dword ptr [0x568c10]                # 00516206
    and byte ptr [eax], 0x0                      # 0051620b
    jmp.d8 L_00516217                            # 0051620e
L_00516210:
    # block 0x00516210: entered by je at 0x005160d6; je at 0x005160f0; je at 0x00516118, 3 instruction(s), calls FUN_00512c79, falls into the block at 0x00516217
    push edi                                     # 00516210
    call FUN_00512c79                            # 00516211
    pop ecx                                      # 00516216
L_00516217:
    # block 0x00516217: entered by je at 0x00515fec; jmp at 0x005160ce; jmp at 0x00516204; jmp at 0x0051620e, 5 instruction(s), ends with ret
    pop edi                                      # 00516217
    pop esi                                      # 00516218
    pop ebx                                      # 00516219
    leave                                        # 0051621a
    ret                                          # 0051621b

