# FUN_0042406d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042406d
# extent:       0x0042406d-0x00424201 (404 code bytes)
# span:         0x0042406d-0x00424201 (code 404, tables 0, padding 0)
# sha256:       9a4edcb1161d5b566df53ed4fee8bfa443b99209cd4fb66a2cdc4d9493c24b07
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
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x0042406d - 0x401000
.globl FUN_0042406d
FUN_0042406d:
    # block 0x0042406d: <unfilled>
    push ebp                                     # 0042406d
    {load} mov ebp, esp                          # 0042406e
    sub esp, 0x18                                # 00424070
    mov dword ptr [ebp - local_18], ecx          # 00424073
    mov eax, dword ptr [ebp + arg_8]             # 00424076
    mov ecx, dword ptr [eax + 0x4]               # 00424079
    mov dword ptr [ebp - local_4], ecx           # 0042407c
    mov dword ptr [ebp - local_14], 0x0          # 0042407f
L_00424086:
    # block 0x00424086: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 00424086
    mov eax, dword ptr [edx + 0x38]              # 00424089
    mov dword ptr [ebp - local_10], eax          # 0042408c
    mov ecx, dword ptr [ebp - local_4]           # 0042408f
    mov edx, dword ptr [ecx + 0x34]              # 00424092
    mov dword ptr [ebp - local_8], edx           # 00424095
    cmp dword ptr [ebp - local_8], 0x0           # 00424098
    je.d8 L_004240f6                             # 0042409c
    # block 0x0042409e: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 0042409e
    movsx ecx, word ptr [eax + 0x16]             # 004240a1
    cmp ecx, 0x1                                 # 004240a5
    jne.d8 L_004240f6                            # 004240a8
    # block 0x004240aa: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004240aa
    cmp dword ptr [edx + 0x4], 0x0               # 004240ad
    jne.d8 L_004240d1                            # 004240b1
    # block 0x004240b3: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004240b3
    cmp dword ptr [eax + 0x4], 0x0               # 004240b6
    je.d8 L_004240d1                             # 004240ba
    # block 0x004240bc: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004240bc
    mov dword ptr [ecx + 0x4], 0x1               # 004240bf
    mov edx, dword ptr [ebp - local_14]          # 004240c6
    add edx, 0x1                                 # 004240c9
    mov dword ptr [ebp - local_14], edx          # 004240cc
    jmp.d8 L_004240f6                            # 004240cf
L_004240d1:
    # block 0x004240d1: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004240d1
    cmp dword ptr [eax + 0x4], 0x0               # 004240d4
    je.d8 L_004240f6                             # 004240d8
    # block 0x004240da: <unfilled>
    mov ecx, dword ptr [ebp - local_8]           # 004240da
    cmp dword ptr [ecx + 0x4], 0x0               # 004240dd
    jne.d8 L_004240f6                            # 004240e1
    # block 0x004240e3: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 004240e3
    mov dword ptr [edx + 0x4], 0x1               # 004240e6
    mov eax, dword ptr [ebp - local_14]          # 004240ed
    add eax, 0x1                                 # 004240f0
    mov dword ptr [ebp - local_14], eax          # 004240f3
L_004240f6:
    # block 0x004240f6: <unfilled>
    cmp dword ptr [ebp - local_10], 0x0          # 004240f6
    je.d8 L_0042415c                             # 004240fa
    # block 0x004240fc: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004240fc
    movsx edx, word ptr [ecx + 0x16]             # 004240ff
    cmp edx, 0x1                                 # 00424103
    jne.d8 L_00424154                            # 00424106
    # block 0x00424108: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 00424108
    cmp dword ptr [eax + 0x4], 0x0               # 0042410b
    jne.d8 L_0042412f                            # 0042410f
    # block 0x00424111: <unfilled>
    mov ecx, dword ptr [ebp - local_10]          # 00424111
    cmp dword ptr [ecx + 0x4], 0x0               # 00424114
    je.d8 L_0042412f                             # 00424118
    # block 0x0042411a: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 0042411a
    mov dword ptr [edx + 0x4], 0x1               # 0042411d
    mov eax, dword ptr [ebp - local_14]          # 00424124
    add eax, 0x1                                 # 00424127
    mov dword ptr [ebp - local_14], eax          # 0042412a
    jmp.d8 L_00424154                            # 0042412d
L_0042412f:
    # block 0x0042412f: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 0042412f
    cmp dword ptr [ecx + 0x4], 0x0               # 00424132
    je.d8 L_00424154                             # 00424136
    # block 0x00424138: <unfilled>
    mov edx, dword ptr [ebp - local_10]          # 00424138
    cmp dword ptr [edx + 0x4], 0x0               # 0042413b
    jne.d8 L_00424154                            # 0042413f
    # block 0x00424141: <unfilled>
    mov eax, dword ptr [ebp - local_10]          # 00424141
    mov dword ptr [eax + 0x4], 0x1               # 00424144
    mov ecx, dword ptr [ebp - local_14]          # 0042414b
    add ecx, 0x1                                 # 0042414e
    mov dword ptr [ebp - local_14], ecx          # 00424151
L_00424154:
    # block 0x00424154: <unfilled>
    mov edx, dword ptr [ebp - local_10]          # 00424154
    mov dword ptr [ebp - local_4], edx           # 00424157
    jmp.d8 L_00424176                            # 0042415a
L_0042415c:
    # block 0x0042415c: <unfilled>
    cmp dword ptr [ebp - local_14], 0x0          # 0042415c
    je.d8 L_00424174                             # 00424160
    # block 0x00424162: <unfilled>
    mov dword ptr [ebp - local_14], 0x0          # 00424162
    mov eax, dword ptr [ebp + arg_8]             # 00424169
    mov ecx, dword ptr [eax + 0x4]               # 0042416c
    mov dword ptr [ebp - local_4], ecx           # 0042416f
    jmp.d8 L_00424176                            # 00424172
L_00424174:
    # block 0x00424174: <unfilled>
    jmp.d8 L_0042417b                            # 00424174
L_00424176:
    # block 0x00424176: <unfilled>
    jmp.d32 L_00424086                           # 00424176
L_0042417b:
    # block 0x0042417b: <unfilled>
    mov dword ptr [ebp - local_c], 0x0           # 0042417b
    mov edx, dword ptr [ebp + arg_8]             # 00424182
    mov eax, dword ptr [edx + 0x4]               # 00424185
    mov dword ptr [ebp - local_4], eax           # 00424188
L_0042418b:
    # block 0x0042418b: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 0042418b
    cmp dword ptr [ecx + 0x4], 0x0               # 0042418e
    je.d8 L_0042419d                             # 00424192
    # block 0x00424194: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 00424194
    add edx, 0x1                                 # 00424197
    mov dword ptr [ebp - local_c], edx           # 0042419a
L_0042419d:
    # block 0x0042419d: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 0042419d
    mov ecx, dword ptr [eax + 0x38]              # 004241a0
    mov dword ptr [ebp - local_4], ecx           # 004241a3
    cmp dword ptr [ebp - local_4], 0x0           # 004241a6
    jne.d8 L_004241ae                            # 004241aa
    # block 0x004241ac: <unfilled>
    jmp.d8 L_004241b0                            # 004241ac
L_004241ae:
    # block 0x004241ae: <unfilled>
    jmp.d8 L_0042418b                            # 004241ae
L_004241b0:
    # block 0x004241b0: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004241b0
    mov eax, dword ptr [edx + 0x18]              # 004241b3
    cmp eax, dword ptr [ebp - local_c]           # 004241b6
    jne.d8 L_004241dc                            # 004241b9
    # block 0x004241bb: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004241bb
    mov dword ptr [ecx], 0x1                     # 004241be
    mov edx, dword ptr [ebp + arg_8]             # 004241c4
    cmp dword ptr [edx + 0xc], 0x0               # 004241c7
    je.d8 L_004241da                             # 004241cb
    # block 0x004241cd: <unfilled>
    mov eax, dword ptr [ebp + arg_8]             # 004241cd
    mov ecx, dword ptr [eax + 0xc]               # 004241d0
    mov dword ptr [ecx + 0x4], 0x1               # 004241d3
L_004241da:
    # block 0x004241da: <unfilled>
    jmp.d8 L_004241fb                            # 004241da
L_004241dc:
    # block 0x004241dc: <unfilled>
    mov edx, dword ptr [ebp + arg_8]             # 004241dc
    mov dword ptr [edx], 0x0                     # 004241df
    mov eax, dword ptr [ebp + arg_8]             # 004241e5
    cmp dword ptr [eax + 0xc], 0x0               # 004241e8
    je.d8 L_004241fb                             # 004241ec
    # block 0x004241ee: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004241ee
    mov edx, dword ptr [ecx + 0xc]               # 004241f1
    mov dword ptr [edx + 0x4], 0x0               # 004241f4
L_004241fb:
    # block 0x004241fb: <unfilled>
    {load} mov esp, ebp                          # 004241fb
    pop ebp                                      # 004241fd
    ret 0x4                                      # 004241fe
