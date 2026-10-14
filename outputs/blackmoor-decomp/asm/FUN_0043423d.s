# FUN_0043423d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043423d
# extent:       0x0043423d-0x004343a2 (357 code bytes)
# span:         0x0043423d-0x004343a2 (code 357, tables 0, padding 0)
# sha256:       11fb4c2fba56f1adfa591e51d080cbda140f510f1810e38c96315ab8635f213f
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
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
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ local_1c, 0x1c  # [ebp - 0x1c]
.equ local_1d, 0x1d  # [ebp - 0x1d]
.equ local_1e, 0x1e  # [ebp - 0x1e]
.equ local_24, 0x24  # [ebp - 0x24]
.equ local_28, 0x28  # [ebp - 0x28]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_00434814, .text + (0x00434814 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x0043423d - 0x401000
.globl FUN_0043423d
FUN_0043423d:
    # block 0x0043423d: <unfilled>
    push ebp                                     # 0043423d
    {load} mov ebp, esp                          # 0043423e
    sub esp, 0x28                                # 00434240
    push esi                                     # 00434243
    push edi                                     # 00434244
    mov dword ptr [ebp - local_14], ecx          # 00434245
    mov dword ptr [ebp - local_8], 0x0           # 00434248
    jmp.d8 L_0043425a                            # 0043424f
L_00434251:
    # block 0x00434251: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 00434251
    add eax, 0x1                                 # 00434254
    mov dword ptr [ebp - local_8], eax           # 00434257
L_0043425a:
    # block 0x0043425a: <unfilled>
    mov ecx, dword ptr [ebp - local_14]          # 0043425a
    mov edx, dword ptr [ebp - local_8]           # 0043425d
    cmp edx, dword ptr [ecx + 0x5f64]            # 00434260
    jge.d32 L_00434398                           # 00434266
    # block 0x0043426c: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 0043426c
    mov ecx, dword ptr [ebp - local_14]          # 0043426f
    mov edx, dword ptr [ecx + 4*eax + 0x1144]    # 00434272
    mov dword ptr [ebp - local_c], edx           # 00434279
    mov edi, 0x545ef0                            # 0043427c
    or ecx, -0x1                                 # 00434281
    {load} xor eax, eax                          # 00434284
    repne scasb al, byte ptr es:[edi]            # 00434286
    not ecx                                      # 00434288
    add ecx, -0x1                                # 0043428a
    mov eax, dword ptr [ebp - local_c]           # 0043428d
    {load} add eax, ecx                          # 00434290
    mov dword ptr [ebp - local_c], eax           # 00434292
    mov ecx, dword ptr [ebp - local_c]           # 00434295
    push ecx                                     # 00434298
    mov ecx, dword ptr [ebp - local_14]          # 00434299
    call FUN_004347b8                            # 0043429c
    mov dword ptr [ebp - local_4], eax           # 004342a1
    cmp dword ptr [ebp - local_4], 0x8           # 004342a4
    ja.d8 L_004342c8                             # 004342a8
    # block 0x004342aa: <unfilled>
    push 0x545ef8                                # 004342aa
    push 0x545f04                                # 004342af
    mov ecx, 0x583979                            # 004342b4
    call FUN_0042639d                            # 004342b9
    mov ecx, 0x5cf659                            # 004342be
    call FUN_004c97b4                            # 004342c3
L_004342c8:
    # block 0x004342c8: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 004342c8
    add edx, 0x4                                 # 004342cb
    mov dword ptr [ebp - local_c], edx           # 004342ce
    mov eax, dword ptr [ebp - local_c]           # 004342d1
    push eax                                     # 004342d4
    mov ecx, dword ptr [ebp - local_14]          # 004342d5
    call FUN_00434814                            # 004342d8
    mov dword ptr [ebp - local_10], eax          # 004342dd
    mov ecx, dword ptr [ebp + arg_8]             # 004342e0
    mov dword ptr [ebp - local_18], ecx          # 004342e3
    mov edx, dword ptr [ebp - local_10]          # 004342e6
    mov dword ptr [ebp - local_1c], edx          # 004342e9
L_004342ec:
    # block 0x004342ec: <unfilled>
    mov eax, dword ptr [ebp - local_1c]          # 004342ec
    mov cl, byte ptr [eax]                       # 004342ef
    mov byte ptr [ebp - local_1d], cl            # 004342f1
    mov edx, dword ptr [ebp - local_18]          # 004342f4
    cmp cl, byte ptr [edx]                       # 004342f7
    jne.d8 L_00434329                            # 004342f9
    # block 0x004342fb: <unfilled>
    cmp byte ptr [ebp - local_1d], 0x0           # 004342fb
    je.d8 L_00434320                             # 004342ff
    # block 0x00434301: <unfilled>
    mov eax, dword ptr [ebp - local_1c]          # 00434301
    mov cl, byte ptr [eax + 0x1]                 # 00434304
    mov byte ptr [ebp - local_1e], cl            # 00434307
    mov edx, dword ptr [ebp - local_18]          # 0043430a
    cmp cl, byte ptr [edx + 0x1]                 # 0043430d
    jne.d8 L_00434329                            # 00434310
    # block 0x00434312: <unfilled>
    add dword ptr [ebp - local_1c], 0x2          # 00434312
    add dword ptr [ebp - local_18], 0x2          # 00434316
    cmp byte ptr [ebp - local_1e], 0x0           # 0043431a
    jne.d8 L_004342ec                            # 0043431e
L_00434320:
    # block 0x00434320: <unfilled>
    mov dword ptr [ebp - local_24], 0x0          # 00434320
    jmp.d8 L_00434331                            # 00434327
L_00434329:
    # block 0x00434329: <unfilled>
    {load} sbb eax, eax                          # 00434329
    sbb eax, -0x1                                # 0043432b
    mov dword ptr [ebp - local_24], eax          # 0043432e
L_00434331:
    # block 0x00434331: <unfilled>
    mov ecx, dword ptr [ebp - local_24]          # 00434331
    mov dword ptr [ebp - local_28], ecx          # 00434334
    cmp dword ptr [ebp - local_28], 0x0          # 00434337
    jne.d8 L_00434393                            # 0043433b
    # block 0x0043433d: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 0043433d
    add edx, 0x4                                 # 00434340
    mov dword ptr [ebp - local_c], edx           # 00434343
    mov eax, dword ptr [ebp - local_14]          # 00434346
    mov ecx, dword ptr [ebp - local_c]           # 00434349
    mov dword ptr [eax + 0x111c], ecx            # 0043434c
    mov edx, dword ptr [ebp - local_4]           # 00434352
    sub edx, 0x4                                 # 00434355
    mov eax, dword ptr [ebp - local_14]          # 00434358
    mov dword ptr [eax + 0x1128], edx            # 0043435b
    mov edi, dword ptr [ebp - local_10]          # 00434361
    mov ecx, dword ptr [ebp - local_14]          # 00434364
    add ecx, 0x1136                              # 00434367
    {load} mov edx, ecx                          # 0043436d
    or ecx, -0x1                                 # 0043436f
    {load} xor eax, eax                          # 00434372
    repne scasb al, byte ptr es:[edi]            # 00434374
    not ecx                                      # 00434376
    {load} sub edi, ecx                          # 00434378
    {load} mov esi, edi                          # 0043437a
    {load} mov eax, ecx                          # 0043437c
    {load} mov edi, edx                          # 0043437e
    shr ecx, 0x2                                 # 00434380
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00434383
    {load} mov ecx, eax                          # 00434385
    and ecx, 0x3                                 # 00434387
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043438a
    mov eax, 0x1                                 # 0043438c
    jmp.d8 L_0043439a                            # 00434391
L_00434393:
    # block 0x00434393: <unfilled>
    jmp.d32 L_00434251                           # 00434393
L_00434398:
    # block 0x00434398: <unfilled>
    {load} xor eax, eax                          # 00434398
L_0043439a:
    # block 0x0043439a: <unfilled>
    pop edi                                      # 0043439a
    pop esi                                      # 0043439b
    {load} mov esp, ebp                          # 0043439c
    pop ebp                                      # 0043439e
    ret 0x4                                      # 0043439f
