# FUN_00424201
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00424201
# extent:       0x00424201-0x00424346 (325 code bytes)
# span:         0x00424201-0x00424346 (code 325, tables 0, padding 0)
# sha256:       b09269b88d5deda641883fc32b6f6fe0943402365f8c58ed1cbd634426252394
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ local_10, 0x10  # [ebp - 0x10]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0042356d, .text + (0x0042356d - 0x401000)
.set FUN_004235fd, .text + (0x004235fd - 0x401000)
.set FUN_0042406d, .text + (0x0042406d - 0x401000)
.set FUN_00424346, .text + (0x00424346 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00424201 - 0x401000
.globl FUN_00424201
FUN_00424201:
L_00424201:
    # block 0x00424201: <unfilled>
    push ebp                                     # 00424201
    {load} mov ebp, esp                          # 00424202
    sub esp, 0x10                                # 00424204
    mov dword ptr [ebp - local_10], ecx          # 00424207
    mov eax, dword ptr [ebp + arg_8]             # 0042420a
    mov ecx, dword ptr [eax + 0x4]               # 0042420d
    mov dword ptr [ebp - local_8], ecx           # 00424210
    mov dword ptr [ebp - local_c], 0x0           # 00424213
L_0042421a:
    # block 0x0042421a: <unfilled>
    cmp dword ptr [ebp - local_c], 0x0           # 0042421a
    jne.d32 L_0042430a                           # 0042421e
    # block 0x00424224: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00424224
    cmp dword ptr [edx], 0x2                     # 00424227
    jne.d8 L_0042426b                            # 0042422a
    # block 0x0042422c: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 0042422c
    mov ecx, dword ptr [ebp - local_8]           # 0042422f
    mov edx, dword ptr [ecx + 0x4]               # 00424232
    mov dword ptr [eax + 0x8], edx               # 00424235
    mov eax, dword ptr [ebp - local_8]           # 00424238
    push eax                                     # 0042423b
    mov ecx, dword ptr [ebp - local_10]          # 0042423c
    call FUN_00424346                            # 0042423f
    mov ecx, dword ptr [ebp - local_8]           # 00424244
    mov edx, dword ptr [ecx + 0x38]              # 00424247
    mov dword ptr [ebp - local_8], edx           # 0042424a
    cmp dword ptr [ebp - local_8], 0x0           # 0042424d
    jne.d8 L_00424266                            # 00424251
    # block 0x00424253: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 00424253
    push eax                                     # 00424256
    mov ecx, dword ptr [ebp - local_10]          # 00424257
    call FUN_0042406d                            # 0042425a
    mov dword ptr [ebp - local_c], 0x1           # 0042425f
L_00424266:
    # block 0x00424266: <unfilled>
    jmp.d32 L_00424305                           # 00424266
L_0042426b:
    # block 0x0042426b: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 0042426b
    cmp dword ptr [ecx], 0x1                     # 0042426e
    jne.d32 L_00424305                           # 00424271
    # block 0x00424277: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 00424277
    mov eax, dword ptr [ebp - local_8]           # 0042427a
    mov ecx, dword ptr [eax + 0x4]               # 0042427d
    mov dword ptr [edx + 0x8], ecx               # 00424280
    mov edx, dword ptr [ebp - local_8]           # 00424283
    push edx                                     # 00424286
    mov eax, dword ptr [ebp + arg_8]             # 00424287
    push eax                                     # 0042428a
    mov ecx, dword ptr [ebp - local_10]          # 0042428b
    call FUN_0042356d                            # 0042428e
    mov ecx, dword ptr [ebp - local_8]           # 00424293
    mov edx, dword ptr [ecx + 0x44]              # 00424296
    push edx                                     # 00424299
    mov ecx, dword ptr [ebp - local_10]          # 0042429a
    call L_00424201                              # 0042429d
    mov ecx, dword ptr [ebp - local_10]          # 004242a2
    call FUN_004235fd                            # 004242a5
    mov dword ptr [ebp - local_4], eax           # 004242aa
    cmp dword ptr [ebp - local_4], 0x0           # 004242ad
    je.d8 L_004242f1                             # 004242b1
    # block 0x004242b3: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004242b3
    mov ecx, dword ptr [eax + 0x8]               # 004242b6
    mov dword ptr [ebp - local_8], ecx           # 004242b9
    mov edx, dword ptr [ebp - local_4]           # 004242bc
    mov eax, dword ptr [edx]                     # 004242bf
    mov dword ptr [ebp + arg_8], eax             # 004242c1
    mov ecx, dword ptr [ebp - local_8]           # 004242c4
    mov edx, dword ptr [ecx + 0x38]              # 004242c7
    mov dword ptr [ebp - local_8], edx           # 004242ca
    cmp dword ptr [ebp - local_8], 0x0           # 004242cd
    jne.d8 L_004242e8                            # 004242d1
    # block 0x004242d3: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 004242d3
    push eax                                     # 004242d6
    mov ecx, dword ptr [ebp - local_10]          # 004242d7
    call FUN_0042406d                            # 004242da
    mov dword ptr [ebp - local_c], 0x1           # 004242df
    jmp.d8 L_004242ef                            # 004242e6
L_004242e8:
    # block 0x004242e8: <unfilled>
    mov dword ptr [ebp - local_c], 0x0           # 004242e8
L_004242ef:
    # block 0x004242ef: <unfilled>
    jmp.d8 L_00424305                            # 004242ef
L_004242f1:
    # block 0x004242f1: <unfilled>
    push 0x544964                                # 004242f1
    push 0x63888b                                # 004242f6
    call FUN_0050ca3e                            # 004242fb
    add esp, 0x8                                 # 00424300
    jmp.d8 L_0042433e                            # 00424303
L_00424305:
    # block 0x00424305: <unfilled>
    jmp.d32 L_0042421a                           # 00424305
L_0042430a:
    # block 0x0042430a: <unfilled>
    jmp.d8 L_00424340                            # 0042430a
L_0042430c:
    # block 0x0042430c: <unfilled>
    push 0x0                                     # 0042430c
    push 0x0                                     # 0042430e
    push 0x63888b                                # 00424310
    call FUN_0052139c                            # 00424315
    movsx ecx, word ptr [0x63a4cd]               # 0042431a
    test ecx, ecx                                # 00424321
    je.d8 L_00424332                             # 00424323
    # block 0x00424325: <unfilled>
    push 0x63888b                                # 00424325
    call FUN_0044a2b7                            # 0042432a
    add esp, 0x4                                 # 0042432f
L_00424332:
    # block 0x00424332: <unfilled>
    mov ecx, 0x5cf659                            # 00424332
    call FUN_004c97b4                            # 00424337
    jmp.d8 L_00424340                            # 0042433c
L_0042433e:
    # block 0x0042433e: <unfilled>
    jmp.d8 L_0042430c                            # 0042433e
L_00424340:
    # block 0x00424340: <unfilled>
    {load} mov esp, ebp                          # 00424340
    pop ebp                                      # 00424342
    ret 0x4                                      # 00424343
